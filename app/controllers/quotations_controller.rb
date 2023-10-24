class QuotationsController < ApplicationController
    def index
        @quotations = Quotation.all
        
    end

    def new
        @quotation = Quotation.new
        @existing_categories = Category.distinct.pluck(:name).compact
    end
    
    def show
        @quotation = Quotation.find(params[:id])
    end
      
      def search
        @query = params[:query].downcase
        @quotations = Quotation.where('LOWER(quote) LIKE ? OR LOWER(author_name) LIKE ?', "%#{@query}%", "%#{@query}%")
      end
    
      def export_xml
        @quotations = Quotation.all
        respond_to do |format|
          format.xml
        end
      end

      def export_json
        @quotations = Quotation.all
        respond_to do |format|
          format.json
        end
      end
    
      def import_xml
        # Implement the logic to parse the XML data from the source
        # and save it to your database
      end
    

      
      def create
    @quotation = Quotation.new(quotation_params)

    if params[:quotation][:new_category].present?
        new_category_name = params[:quotation][:new_category]
        category = Category.create(name: new_category_name)
        @quotation.category = category
    elsif params[:quotation][:category].present?
        @quotation.category_id = params[:quotation][:category]
    end

    if @quotation.save
        flash[:notice] = 'Quotation was successfully created'
        redirect_to @quotation
    else
        render :new
    end
end

      
        # ...
      
        private
      
        def quotation_params
            params.require(:quotation).permit(:author_name, :quote, :category_id, :new_category)
          end
          
      end
      
      
