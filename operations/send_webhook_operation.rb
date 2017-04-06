class SendWebhookOperation

    def initialize(value)
        webhook_url = value["data"]["url"] || $webhook_url
        webhook_body = value["data"]["body"] || ""

        log "[#{Time.now}] [SendWebhook] Begin Request: #{webhook_url}..."

        sucessful_request = false
        request_counter = 0

        while (!sucessful_request && request_counter<10) do
            begin
                RestClient.post(webhook_url, webhook_body)

                sucessful_request = true
            rescue Exception => e
                log "[[ SendWebhook Exception: #{e.inspect} ]]"
                request_counter += 1
            end
        end

        if sucessful_request
            log "[#{Time.now}] [SendWebhook] Ended Request: #{webhook_url}"
        else
            log "[#{Time.now}] [SendWebhook] Failed to request: #{webhook_url}"
        end

    end

end