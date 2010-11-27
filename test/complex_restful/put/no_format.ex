# no format
describe "when no extension is provided" do
  
  it "should return a valid JSON string" do
    client.put(basic_values_uri, {:tuple => {:id => 1, :name => "This is a modification attempt"}}){|res,http|
      res.content_type.should == 'application/json'
      res.body.should be_a_valid_json_string
      res.body.should =~ /This is a modification attempt/
    }
    
    # tuple should be inserted
    client.get(basic_values_uri('.json'), {:id => 1}){|res,http|
      res.body.should =~ /This is a modification attempt/
    }
    
    # no other tuples should be created
    client.get(basic_values_uri('.json')){|res,http|
       JSON::parse(res.body).size.should == 1
    }
  end
  
end
