require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.has_table" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on existing tuple with #{adapter.class}" do
      before{  
        adapter.create_table(nil, :example, :id => Integer, :name => "dbagile") 
        adapter.insert(nil, :example, :id => 1, :name => "dbagile")
        adapter.insert(nil, :example, :id => 2, :name => "sequel")
      }
      subject{ 
        adapter.delete(nil, :example, {:id => 2}) 
      }
      specify{ 
        subject.should be_true
        adapter.dataset(:example).to_a.should == [
          {:id => 1, :name => "dbagile"},
        ] 
      }
    end

    describe "When called on existing tuple with #{adapter.class} with an empty projection" do
      before{  
        adapter.create_table(nil, :example2, :id => Integer, :name => "dbagile") 
        adapter.insert(nil, :example2, :id => 1, :name => "dbagile")
        adapter.insert(nil, :example2, :id => 2, :name => "sequel")
      }
      subject{ 
        adapter.delete(nil, :example2, {}) 
      }
      specify{ 
        subject.should be_true
        adapter.dataset(:example2).to_a.should == []
      }
    end
  
  end
  
end