class QuotationController < ApplicationController
    def index
        @quotations = Quotation.all
    end

    def new
        @quotation = Quotation.new
    end

    def create
        @quotation = Quotation.new(params[:quotation])
        if @quotation.save
            flash[:notice] = 'Quotation was successfully created'
            @quotation = Quotation.new
        end
    end

    def quotation_params
        param.require(:quotation).permit(:author_name, :category, :quote)
    end
end
