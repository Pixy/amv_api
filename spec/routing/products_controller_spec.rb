require 'spec_helper'

describe ProductsController do
  it "should route /products/by_tag to  products#tag" do
      expect(:get => "/products/by_tag").to route_to(:controller => "products", :action => "tag")
   end


  describe "root" do
    it "should define root" do
      expect(:get => "/").to be_routable
    end

    it "should route / to products#tag" do
      expect(:get => "/").to route_to(:controller => "products", :action => "tag")
    end
  end


end