#!/usr/bin/ruby

require 'ipaddress'
require 'net/ping'
require_relative 'commons'

def notify_new_server(hosts_ip_addresses)
    return if hosts_ip_addresses.count==0
    
    log "[#{Time.now}] [New Servers] #{hosts_ip_addresses}"
    operations = []

    if $operations.include?("Print")
        operations << {
            operation: "PrintOperation",
            data: {
                servers: hosts_ip_addresses
            }
        }
    end

    if $operations.include?("SendEmail")
        operations << {
            operation: "SendEmailOperation",
            data: {
                emails: $smtp_to_emails,
                subject: $smtp_subject,
                body: JSON.pretty_generate(hosts_ip_addresses)
            }
        }
    end

    if $operations.include?("StartNmap")
        operations << {
            operation: "StartScannerOperation",
            data: {
                scanner: "nmap",
                params: ["%server%"],
                servers: hosts_ip_addresses
            }
        }
    end

    if $operations.include?("SendWebhook")
        operations << {
            operation: "SendWebhookOperation",
            data: {
                url: $webhook_url,
                body: JSON.pretty_generate(hosts_ip_addresses)
            }
        }
    end

    if $operations.include?("RegisterOnGauntlet")
        operations << {
            operation: "RegisterOnGauntletOperation",
            data: {
                servers: hosts_ip_addresses
            }
        }
    end

    # Custom defined operations
    $custom_operations.each do |custom_operation|
        if $operations.include?(custom_operation["name"])
            custom_operation["data"] ||= {}
            custom_operation["data"]["servers"] = hosts_ip_addresses
            custom_operation["data"]["emails"] = $smtp_to_emails

            operations << {
                operation: "#{custom_operation["operation"]}Operation",
                data: custom_operation["data"]
            }
        end
    end

    $redis.setnx(
        "new-servers-#{Digest::MD5.hexdigest(hosts_ip_addresses.to_s)}",
        operations.to_json
      )
end

def save_database(hash)
    File.open("database.txt","w") do |f|
        f << JSON.pretty_generate(hash)
    end
end

def load_database
    JSON.parse(File.read("database.txt")) rescue {}
end

def up?(host)
    log "[#{Time.now}] [up?] Testing #{host}..."
    check = Net::Ping::External.new(host)
    check.ping?
end

database = load_database
new_servers = []

$networks.each do |line|
    next if line.strip == ""
    next if line.strip.start_with?("#")

    network_ip_address = line.strip
    database[network_ip_address] ||= {}

    network_ip = IPAddress::IPv4.new network_ip_address
    network_hosts = (network_ip.hosts.count==0 ? [network_ip] : network_ip.hosts)
    network_hosts.each do |host_ip|
        # Is host up?
        host_up = up?(host_ip.address)

        # Is it an existent server?
        last_record = database[network_ip_address][host_ip.address]
        if last_record && last_record["has_been_processed"]
            # Yes, it is
            has_been_processed = true
        else
            # No, it's a new server!
            # But we only count servers that are running
            if host_up
                has_been_processed = true
                new_servers << host_ip.address
            else
                has_been_processed = false
            end
        end

        database[network_ip_address][host_ip.address] = {
                up: host_up,
                has_been_processed: has_been_processed,
                last_checked: Time.now
            }
    end
end

save_database(database)

notify_new_server(new_servers)
