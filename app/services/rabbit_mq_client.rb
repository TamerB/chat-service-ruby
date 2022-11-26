class RabbitMqClient
    attr_accessor :call_id, :response, :lock, :condition, :connection,
                :channel, :server_queue_name, :reply_queue, :exchange

    def initialize(server_queue_name)
        @connection = Bunny.new(automatically_recover: false)
        @connection.start

        @channel = connection.create_channel
        @exchange = channel.default_exchange
        @server_queue_name = server_queue_name

        setup_reply_queue
    end

    def call(message)
        @call_id = SecureRandom.uuid
    
        exchange.publish(message.to_json,
                         routing_key: server_queue_name,
                         correlation_id: call_id,
                         reply_to: reply_queue.name)
    
        # wait for the signal to continue the execution
        lock.synchronize { condition.wait(lock) }
    
        response
    end

    def stop
        channel.close
        connection.close
    end

    def stop_connection
        connection.close
    end

    def setup_reply_queue
        @lock = Mutex.new
        @condition = ConditionVariable.new
        that = self
        @reply_queue = channel.queue('', exclusive: false)
    
        reply_queue.subscribe do |_delivery_info, properties, payload|
            if properties[:correlation_id] == that.call_id
                that.response = JSON.parse(payload)
                
                # sends the signal to continue the execution of #call
                that.lock.synchronize { that.condition.signal }
            end
        end
    end






    #def self.publish(exchange, message = {})
    #    event = channel.fanout("chatwrite.#{exchange}")
    #    event.publish(message.to_json)
    #end

    #def self.channel
    #    @channel ||= connection.create_channel
    #end

    #def self.connection
    #    @connection ||= Bunny.new.tap do |connect|
    #        connect.start
    #    end
    #end
end