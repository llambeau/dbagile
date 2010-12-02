# no format
describe "without extension /" do
  
  it "should work as expected when no projection is provided" do
    client.delete(basic_values_uri){|res,http|
      res.content_type.should == 'application/json'
      res.body.should be_a_valid_json_string
      JSON::load(res.body).should == {"ok" => true}
    }
    
    # all tuples should have been deleted
    client.get(basic_values_uri('.json')){|res,http|
      res.body.should be_a_valid_json_string
      JSON::load(res.body)["data"].should == []
    }
  end
  
  it "should work as expected when a projection is provided" do
    client.delete(basic_values_uri, {:filters=>{:id => 2}}){|res,http|
      res.content_type.should == 'application/json'
      res.body.should be_a_valid_json_string
      JSON::load(res.body).should == {"ok" => true}
    }
    
    # all tuples should have been deleted
    client.get(basic_values_uri('.json')){|res,http|
      res.body.should be_a_valid_json_string
      JSON::load(res.body)["data"].size.should.should == 1
    }
  end
  
end