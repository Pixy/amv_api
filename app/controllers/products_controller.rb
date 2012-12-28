class ProductsController < ApplicationController
   def tag
      @amv_data = AmvDataByTag.find_by_q(params[:q]) || AmvDataByTag.create!(:q => params[:q])
      render :json => @amv_data.get_products
   end
end
