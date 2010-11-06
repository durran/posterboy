# encoding: utf-8

require 'active_record'
require 'active_support/concern'
require 'posterboy/document'
require 'posterboy/version'

module Posterboy #:nodoc:
  extend ActiveSupport::Concern

  # This is the base query used to perform a full-text search in Postgre.
  QUERY = "to_tsvector('english', documents.search_text) @@ plainto_tsquery('english', ?)"

  # Operators for performing different types of searches.
  OPERATORS = { and: '&', or: '|' }

  included do

    # Each searchable model has a reference to a single {#Posterboy::Document},
    # which is where the searchable attributes will get stored.
    has_one \
      :document,
      as: :searchable,
      inverse_of: :searchable,
      class_name: "Posterboy::Document"

    # The search scope takes a space separated list of terms to perform an
    # AND query on. This should be configurable in the future.
    #
    # @example
    #   User.search('Syd London')
    #
    # @param [ Symbol ] operator The type of search to perform.
    # @param [ String ] term The words to search on.
    #
    # @return [ ActiveRecord::Relation ] The matching records.
    scope :search, lambda { | operator, term |
      if term.present?
        {
          include: [:document],
          conditions: [ QUERY, term.gsub(' ', " #{OPERATORS[:operator]} ") ]
        }
     end
    }

    # Update the searchable {#Document} after each save.
    set_callback :save, :after, :update_document

    # Searchable fields are stored here.
    class_inheritable_accessor :searchables
  end

  private

  # Get the actual values for the attributes that have been defined as
  # searchable.
  #
  # @example
  #   user.searchable_values
  #
  # @return [ Array ] The actual values for this record.
  def searchable_values
    [].tap do |values|
      searchables.each do |searchable|
        searchable.is_a?(Hash) ?
          values << send(searchable.to_a[0][0]).map(&searchable.to_a[0][1]) :
          values << send(searchable)
      end
    end
  end

  # Updates or creates the document with the supplied attribute values with
  # each save.
  #
  # @example
  #   user.update_document
  def update_document
    if searchables
      text = searchable_values.flatten.join(' ')
      return document.update_attribute(:search_text, text) if document
      create_document(search_text: text)
    end
  end

  module ClassMethods

    # Macro to define which attributes should be searched on.
    #
    # @example
    #   class User < ActiveRecord::Base
    #     has_many :tags, through: :user_tags
    #
    #     search_on :first_name, :last_name, tags: :name
    #   end
    #
    # @param [ Array<Symbol> ] args The attributes to search on.
    def search_on(*args)
      self.searchables = args
    end
  end
end

ActiveRecord::Base.send(:include, Posterboy)
