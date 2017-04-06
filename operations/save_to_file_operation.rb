class SaveToFileOperation

    def initialize(value)
        filepath = value["data"]["filepath"]
        content = value["data"]["content"].to_s

        log "[#{Time.now}] [SaveToFileOperation] Saving ... #{filepath}"
        File.open(filepath,"w") do |f|
            f << content
        end
        log "[#{Time.now}] [SaveToFileOperation] Saved: #{filepath}"
    end

end