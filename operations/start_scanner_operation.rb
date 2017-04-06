class StartScannerOperation

    def initialize(value)
        servers = value["data"]["servers"] || []
        scanner = value["data"]["scanner"] || "nmap"
        printable_scanner_name = scanner.capitalize

        send_email = $scanner_send_email
        send_webhook = $scanner_send_webhook
        save_to_file = $scanner_save_to_file

        servers.each do |server|
            command = ([scanner] + (value["data"]["params"] || [server]))
                                        .join(" ")
                                        .gsub("%server%",server)

            log "[#{Time.now}] [#{printable_scanner_name}] Begin Scanning: #{server}..."
            scanner_output = %x[#{command}]
            log "[#{Time.now}] [#{printable_scanner_name}] Ended Scanning: #{server}"

            if send_email
                $redis.setnx(
                    "#{scanner}-report-email-#{Digest::MD5.hexdigest(server)}",[
                        {
                            operation: "SendEmailOperation",
                            data: {
                                emails: $smtp_to_emails,
                                subject: "#{printable_scanner_name} output for #{server}",
                                body: scanner_output
                            }
                        }
                    ].to_json
                  )
            end

            if send_webhook
                $redis.setnx(
                    "#{scanner}-scan-report-webhook-#{Digest::MD5.hexdigest(server)}",[
                        {
                            operation: "SendWebhookOperation",
                            data: {
                                body: scanner_output
                            }
                        }
                    ].to_json
                  )
            end

            if save_to_file
                $redis.setnx(
                    "#{scanner}-scan-report-save-to-file-#{Digest::MD5.hexdigest(server)}",[
                        {
                            operation: "SaveToFileOperation",
                            data: {
                                filepath: "scans/#{scanner}-#{server}.log",
                                content: scanner_output
                            }
                        }
                    ].to_json
                  )
            end
        end
    end

end