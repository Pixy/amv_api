require 'spec_helper'

describe ProductsController do

  describe "tag" do
   render_views

  it "returns a 200 status"  do
      get :tag
      response.code.should eq("200")
   end

    it "should return the products" do
      AmvDataByTag.any_instance.stub(:get_products).and_return({"key" => "value"})

      get :tag

      json = JSON.parse(response.body)
      json.should eq({"key" => "value"})
    end

    it "should use an existing object (if available)" do
      amv = stub_model(AmvDataByTag)
      AmvDataByTag.stub(:find_by_q).and_return(amv)

      get :tag

      assigns(:amv_data).should eq(amv)
    end

    it "should create a new object (when existing is not available)"  do
      AmvDataByTag.stub(:find_by_q).and_return(nil)

      expect{
      get :tag
      }.to change(AmvDataByTag, :count).by(1)

    end

  end

end
