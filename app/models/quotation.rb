class Quotation < ApplicationRecord
    attr_accessor :new_category
    belongs_to :category
    validates_presence_of :author_name, :quote
  
end
