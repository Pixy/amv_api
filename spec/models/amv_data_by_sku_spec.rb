require 'spec_helper'

describe AmvDataBySku do
  subject do
    AmvDataBySku.create(:q => "value")
  end

  it_should_behave_like "amv data"

  it {should validate_uniqueness_of(:q)}


  describe "the format of the product list (when not empty)" do
    subject do
      AmvDataBySku.create(:q => "C209666, C210195, C210196, C210197").get_products
    end

    it_should_behave_like "standard amv list of products"
  end

  describe "the format of the product list (when empty)" do
    subject do
      AmvDataBySku.create(:q => "xxx").get_products
    end

    it_should_behave_like "empty standard amv list of products"
  end


end

