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
      

    def create
        @quotation = Quotation.new(quotation_paramsexit)
        if params[:quotation][:category] == 'New category'
            # The user entered a new category, so create it
            new_category = params[:new_category]
            # You may want to add additional validation here before creating the category
            # For example, check if the category already exists
            # Then, create a new category or handle errors as needed
            category = Category.create(name: new_category)
            @quotation.category = category.name
          end
        
        if @quotation.save
            flash[:notice] = 'Quotation was successfully created'
            @quotation = Quotation.new
        end
    end

    def quotation_params
        param.require(:quotation).permit(:author_name, :category, :quote)
    end
end
