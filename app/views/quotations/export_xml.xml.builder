# app/views/quotations/export_xml.xml.builder

xml.instruct!
xml.quotations do
  @quotations.each do |quotation|
    xml.quotation do
      xml.author_name quotation.author_name
      xml.category quotation.category
      xml.quote quotation.quote
    end
  end
end
