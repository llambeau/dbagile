describe "it should support projection through the query string" do
  
  it "should correctly project the table" do
    client.get(basic_values_uri('.json'), {:filters => {:id => 0}}){|res,http|
      res.body.should be_a_valid_json_string
      JSON::parse(res.body).size.should == 0
    }
  end
  
  it "should correctly sort the table" do
    client.get(suppliers_uri('.json'), {:sort_by => {:name => :asc}}){|res,http|
      res.body.should be_a_valid_json_string
      suppliers = JSON::parse(res.body)
      suppliers.first["name"].should == "Adams"
    }
    client.get(suppliers_uri('.json'), {:sort_by => {:name => :desc}}){|res,http|
      res.body.should be_a_valid_json_string
      suppliers = JSON::parse(res.body)
      suppliers.first["name"].should == "Smith"
    }
  end
  
end
