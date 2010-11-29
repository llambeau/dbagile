describe "it should support windowing through the query string" do
  
  it "should correctly support windowing" do
    client.get(suppliers_uri('.json'), {:sort_by => {:name => :asc}, :window => {:limit => 1, :offset => 0}}){|res,http|
      res.body.should be_a_valid_json_string
      suppliers = JSON::parse(res.body)
      suppliers.size.should == 1
      suppliers.first["name"].should == "Adams"      
    }
    client.get(suppliers_uri('.json'), {:sort_by => {:name => :asc}, :window => {:limit => 2, :offset => 3}}){|res,http|
      res.body.should be_a_valid_json_string
      suppliers = JSON::parse(res.body)
      suppliers.size.should == 2
      suppliers.first["name"].should == "Jones"
      suppliers[1]["name"].should == "Smith"
    }
  end
  
end
