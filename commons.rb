#!/usr/bin/ruby

# OTHER
require 'json'
require 'digest'
require 'rest-client'

# REDIS
require 'redis'
$redis = Redis.new(:url => ENV["REDIS_URL"])

# NETWORKS TO BE MONITORED
$networks = ENV["TARGETS"].split(",")

# OPERATIONS
$custom_operations = JSON.parse(ENV["CUSTOM_OPERATIONS"])
$operations = ENV["OPERATIONS"].split(",")

# WEBHOOK
$webhook_url = ENV["WEBHOOK_URL"]

# SMTP
$smtp_to_emails = ENV["SMTP_TO"].split(",")
$smtp_from = ENV["SMTP_FROM"]
$smtp_subject = ENV["SMTP_SUBJECT"]
$smtp_via_options = {
    :address              => ENV["SMTP_HOST"],
    :port                 => ENV["SMTP_PORT"],
    :enable_starttls_auto => (ENV["SMTP_ENABLE_STARTTLS_AUTO"]=="True"),
    :domain               => ENV["SMTP_DOMAIN"]
}

unless ENV["SMTP_AUTH"] == "none"
    $smtp_via_options = $smtp_via_options.merge({
            :authentication => ENV["SMTP_AUTH"].to_sym,
            :user_name      => ENV["SMTP_USER"],
            :password       => ENV["SMTP_PASS"],
        })
end

# SCANNER
$scanner_send_email = (ENV["SCANNER_SEND_EMAIL"]=="True")
$scanner_send_webhook = (ENV["SCANNER_SEND_WEBHOOK"]=="True")
$scanner_save_to_file = (ENV["SCANNER_SAVE_TO_FILE"]=="True")

# GAUNTLET
$gauntlet_api_user=ENV["GAUNTLET_API_USER"]
$gauntlet_api_pass=ENV["GAUNTLET_API_PASS"]
$gauntlet_api_organization_id=ENV["GAUNTLET_ORGANIZATION_ID"]
$gauntlet_api_endpoint=ENV["GAUNTLET_API_ENDPOINT"]
                                .gsub("%user%",$gauntlet_api_user)
                                .gsub("%pass%",$gauntlet_api_pass)
$gauntlet_default_business_criticality=ENV["GAUNTLET_DEFAULT_BUSINESS_CRITICALITY"]
$gauntlet_default_internal=(ENV["GAUNTLET_DEFAULT_INTERNAL"]=="True")
$gauntlet_default_tags=ENV["GAUNTLET_DEFAULT_TAGS"].split(",")

# LOG
def log(text)
    File.open("app.log","a") do |f|
        f << "#{text}\n"
    end
end