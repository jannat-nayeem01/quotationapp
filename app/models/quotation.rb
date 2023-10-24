class Quotation < ApplicationRecord
    validates_presence_of :author_name, :category, :quote
end
