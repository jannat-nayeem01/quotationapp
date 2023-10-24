# app/views/quotations/export_json.json.jbuilder

json.array! @quotations do |quotation|
  json.extract! quotation, :author_name, :category, :quote
end
