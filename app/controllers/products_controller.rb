class ProductsController < ApplicationController
   def tag
     begin
       @amv_data = AmvDataByTag.find_by_q(params[:q]) || AmvDataByTag.create!(:q => params[:q])
       render :json => @amv_data.get_products
     rescue => e
       render :json => Array.new
     end
   end

   def skus
     begin
       @amv_data = AmvDataBySku.find_by_q(params[:q]) || AmvDataBySku.create!(:q => params[:q])
       render :json => @amv_data.get_products
     rescue => e
       render :json => Array.new
     end
   end
end
