class Tag < ActiveRecord::Base
  belongs_to :user, inverse_of: :tags
end
