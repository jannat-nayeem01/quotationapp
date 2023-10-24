class QuotationsController < ApplicationController
    def index
        @quotations = Quotation.all
        
    end

    def new
        @quotation = Quotation.new
        @existing_categories = Quotation.distinct.pluck(:category)

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

        if params[:quotation][:category] == 'New category'
            # The user entered a new category, so create it
            new_category = params[:category]
            # You may want to add additional validation here before creating the category
            # For example, check if the category already exists
            # Then, create a new category or handle errors as needed
            category = Category.create(name: category)
            @quotation.category = category.name
          end
        
        if @quotation.save
            flash[:notice] = 'Quotation was successfully created'
            format.json { render :show, status: :created, location: @quotation }
            @quotation = Quotation.new
        end
    end

    def quotation_params
        params.require(:quotation).permit(:author_name, :category, :quote)
    end
end
