shared_examples_for  "standard amv list of products" do

   it {should be_a(Array)}
   it {should have(4).items}

   end

shared_examples_for  "empty standard amv list of products" do

   it {should be_a(Array)}
   it {should have(0).items}

end