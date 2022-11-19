class Application < ApplicationRecord
    before_create :generate_token
end
