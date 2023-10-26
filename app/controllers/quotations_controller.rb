require 'nokogiri'

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
    
    
      def import_xml
        # Implement the logic to parse the XML data from the source
        # and save it to your database
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
        def search_quotations
            Quotation.where('quote ILIKE ? OR author_name ILIKE ?', "%#{@query}%", "%#{@query}%")
          end
        
      
        def quotation_params
            params.require(:quotation).permit(:author_name, :quote, :category_id, :new_category)
          end
          
      end
      
      
