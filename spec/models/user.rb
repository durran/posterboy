"CREATE TABLE users (
  first_name char varying(255),
  last_name char varying(255),
  instrument char varying(255)
)"

class User < ActiveRecord::Base
  has_many :tags, inverse_of: :user
  search_on :first_name, :last_name, :instrument, tags: :name
end
