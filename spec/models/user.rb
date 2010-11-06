class User < ActiveRecord::Base
  has_many :tags, inverse_of: :user
  search_on :first_name, :last_name
end
