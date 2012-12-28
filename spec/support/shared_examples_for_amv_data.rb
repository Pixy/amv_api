shared_examples_for "amv data" do

   it {should respond_to(:q)}
   it {should respond_to(:data)}
   it {should respond_to(:expires_at)}
   it {should allow_mass_assignment_of(:q)}
   it {should_not allow_mass_assignment_of(:data)}
   it {should_not allow_mass_assignment_of(:expires_at)}

   its(:soap_client)    { should_not be_nil }
   its(:remote_session_id)    { should_not be_nil }     #this will use the external web service in order to get the remote_session_id
end