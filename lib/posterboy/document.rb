# encoding: utf-8
module Posterboy
  class Document < ActiveRecord::Base
    belongs_to :searchable, polymorphic: true, inverse_of: :document
    set_table_name :documents
  end
end
