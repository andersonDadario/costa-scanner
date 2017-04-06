#!/usr/bin/ruby

require_relative 'commons'
Dir[File.dirname(__FILE__) + '/operations/*.rb'].each {|file| require file }
SLEEP_TIME = 10

# Monitor Actions every SLEEP_TIME
while true do
    $redis.keys('*').each do |key|
        operations = JSON.parse($redis.get(key)) || []
        operations.each do |value|
            Object.const_get("#{value["operation"]}").new(value)
        end

        $redis.del(key)
    end

    sleep SLEEP_TIME
end
