class RegisterOnGauntletOperation

    def initialize(value)
        servers = value["data"]["servers"] || []

        servers.each do |server|
            log "[#{Time.now}] [Gauntlet] Begin Registering: #{server}..."

            sucessful_request = false
            request_counter = 0

            while (!sucessful_request && request_counter<10) do
                begin
                    RestClient.post( "#{$gauntlet_api_endpoint}/api/v1/applications", {
                            application: {
                                name: server,
                                application_type: "Server",
                                business_criticality: $gauntlet_default_business_criticality,
                                internal: $gauntlet_default_internal,
                                tags: $gauntlet_default_tags,
                                url: server,
                                organization_id: $gauntlet_api_organization_id
                            }
                        }
                    )

                    sucessful_request = true
                rescue Exception => e
                    log "[[ Gauntlet Exception: #{e.inspect} ]]"
                    request_counter += 1
                end
            end

            if sucessful_request
                log "[#{Time.now}] [Gauntlet] Ended Registering: #{server}"
            else
                log "[#{Time.now}] [Gauntlet] Failed to register: #{server}"
            end
        end
    end

end