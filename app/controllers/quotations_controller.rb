require 'nokogiri'
require 'open-uri'
require 'rexml/document'


class QuotationsController < ApplicationController
    def index
        @quotations = if params[:query].present?
          search_quotations
        else
          Quotation.all
        end
      end
    

    def new
        @quotation = Quotation.new
        @existing_categories = Category.distinct.pluck(:name).compact
        @existing_categories ||= [] 
      end
          
    def show
        @quotation = Quotation.find(params[:id])
    end
      
    def search
        @query = params[:query].downcase
        @quotations = search_quotations
        render :index
      end
    
      
    
      def export_xml
        @quotations = Quotation.all
    
        # Build the XML document
        xml_builder = Nokogiri::XML::Builder.new do |xml|
          xml.quotations {
            @quotations.each do |quotation|
              xml.quotation {
                xml.author_name quotation.author_name
                xml.category quotation.category.name
                xml.quote quotation.quote
              }
            end
          }
        end
    
        formatted_xml = xml_builder.to_xml(indent: 2)
    
        respond_to do |format|
          format.xml { render xml: formatted_xml }
        end
      end
    
    

      def export_json
        @quotations = Quotation.all
    
        formatted_json = JSON.pretty_generate(JSON.parse(@quotations.to_json))
    
        respond_to do |format|
          format.json { render json: formatted_json }
        end
      end
    
    
      def import_xml_external
        if params[:xml_url].present?
          url = params[:xml_url]
    
          begin
            xml_data = open(url).read
            import_quotations_from_xml(xml_data)
            flash[:notice] = 'Quotations imported successfully'
          rescue OpenURI::HTTPError => e
            flash[:error] = "Error fetching data from the URL: #{e.message}"
          rescue REXML::ParseException => e
            flash[:error] = "Error parsing XML data: #{e.message}"
          end
        else
          flash[:error] = 'Please provide a valid XML URL'
        end
    
        redirect_to quotations_path
      end
    
      def import_xml
        begin
          file_path = Rails.root.join('app', 'views', 'quotations', 'Importxml_test.xml')
          xml_data = File.read(file_path)
          import_quotations_from_xml(xml_data)
          flash[:notice] = 'Quotations imported successfully'
        rescue Errno::ENOENT
          flash[:error] = 'XML file not found'
        rescue REXML::ParseException => e
          flash[:error] = "Error parsing XML data: #{e.message}"
        end
      
        redirect_to quotations_path
      end
      

      
      def create
        @quotation = Quotation.new(quotation_params)
      
        if params[:quotation][:category_id].present?
          # User selected an existing category
          existing_category_id = params[:quotation][:category_id]
          @quotation.category_id = existing_category_id
        else
          # User entered a new category
          if params[:quotation][:new_category].present?
            new_category_name = params[:quotation][:new_category]
            category = Category.create(name: new_category_name)
            @quotation.category_id = category.id
          end
        end
      
        respond_to do |format|
          if @quotation.save
            flash[:notice] = 'Quotation was successfully created'
            format.html { redirect_to @quotation }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @quotation.errors, status: :unprocessable_entity }
          end
        end
      end
      
      
        # ...
      
        private

        def import_quotations_from_xml(xml_data)
            doc = REXML::Document.new(xml_data)
            doc.elements.each('quotations/quotation') do |quotation_element|
              author_name = quotation_element.elements['author_name'].text
              category_name = quotation_element.elements['category'].text
              quote = quotation_element.elements['quote'].text
          
              # Find or create the Category based on the category_name
              category = Category.find_or_create_by(name: category_name)
          
              Quotation.create(author_name: author_name, category: category, quote: quote)
            end
          end
          
        
        def search_quotations
            Quotation.where('quote ILIKE ? OR author_name ILIKE ?', "%#{@query}%", "%#{@query}%")
          end
        
      
        def quotation_params
            params.require(:quotation).permit(:author_name, :quote, :category_id, :new_category)
          end
          
      end
      
      
