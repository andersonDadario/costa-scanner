require 'pony'

class SendEmailOperation

    def initialize(value)
        subject = value["data"]["subject"] || "SendEmailOperation"
        body = value["data"]["body"] || "Empty body"
        emails = value["data"]["emails"]
        # [ "a@a.com", "b@b.com"]
        attachments = value["data"]["attachments"] || {}
        # {"foo.zip" => File.read("path/to/foo.zip"), "hello.txt" => "hello!"}

        emails.each do |email|
            log "[#{Time.now}] [SendEmail] Begin Sending email to #{email}..."

            # Detailed Pony options
            # https://github.com/benprew/pony
            Pony.mail({
              :to => email,
              :from => $smtp_from,
              :subject => subject,
              :body => body,
              :via => :smtp,
              :via_options => $smtp_via_options,
              :attachments => attachments
            })

            log "[#{Time.now}] [SendEmail] Ended sending email to #{email}..."
        end
    end

end