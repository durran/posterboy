class User < ActiveRecord::Base
  search_on :first_name, :last_name
end
