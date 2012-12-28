require 'spec_helper'

describe AmvDataByTag do
  subject do
    AmvDataByTag.create(:q => "value")
  end

  it_should_behave_like "amv data"

  it {should validate_uniqueness_of(:q)}


  describe "the format of the product list (when not empty)" do
    subject do
      AmvDataByTag.create(:q => "bio").get_products
    end

    it_should_behave_like "standard amv list of products"
  end

  describe "the format of the product list (when empty)" do
    subject do
      AmvDataByTag.create(:q => "qwerty").get_products
    end

    it_should_behave_like "empty standard amv list of products"
  end


end

