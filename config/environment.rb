# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

$writeClient = RabbitMqClient.new('write_queue')
puts "Writer initialized"
$readClient = RabbitMqClient.new('read_queue')
puts "Reader initialized"