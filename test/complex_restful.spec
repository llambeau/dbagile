require File.expand_path('../spec_helper', __FILE__)
require 'dbagile/complex_restful/server'
require 'dbagile/complex_restful/client'
dbagile_load_all_subspecs(__FILE__)

describe "DbAgile::ComplexRestful feature" do
  
  let(:environment)  { DbAgile::Fixtures::environment                      }
  let(:database_name){ :sqlite                                             }
  let(:database)     { environment.repository.database(database_name)      }
  let(:server)       { DbAgile::ComplexRestful::Server.new(environment)    }
  let(:client)       { DbAgile::ComplexRestful::Client.new(server.uri)     }
  before(:all)       { server.start                                        }
  after(:all)        { server.stop                                         }
  
  def basic_values_uri(extension = "")
    "#{database_name}/basic_values#{extension}"
  end
  
  def suppliers_uri(extension = "")
    "#{database_name}/suppliers#{extension}"
  end
        
  describe "the GET interface" do
    it_should_behave_like "The ComplexRestful GET interface" 
  end

  describe "the POST interface" do
    it_should_behave_like "The ComplexRestful POST interface" 
  end

  describe "the DELETE interface" do
    it_should_behave_like "The ComplexRestful DELETE interface" 
  end

  describe "the PUT interface" do
    it_should_behave_like "The ComplexRestful PUT interface" 
  end

end
