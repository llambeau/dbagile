require File.expand_path('../spec_helper', __FILE__)
Dir[File.expand_path('../commands/**/*.spec', __FILE__)].each{|f| load(f)}
describe "DbAgile::Command through API" do
  
  # Path to an empty configuration file
  let(:empty_config_path){ File.expand_path('../fixtures/configs/empty_config.dba', __FILE__) }
  
  # The environment to use
  let(:dba){ DbAgile::Command::API.new(DbAgile::Fixtures::environment) }
  
  # Remove empty config between all test
  before(:each){ FileUtils.rm_rf(empty_config_path) }
  after(:each){ FileUtils.rm_rf(empty_config_path) }
  
  ### Configuration commands
  
  describe "The configuration commands" do 
    describe "The list command" do
      it_should_behave_like "The list command" 
    end

    describe "The add command" do
      it_should_behave_like "The add command" 
    end
  
    describe "The rm command" do
      it_should_behave_like "The rm command" 
    end
  
    describe "The use command" do
      it_should_behave_like "The use command" 
    end
  
    describe "The ping command" do
      it_should_behave_like "The ping command" 
    end
  end
  
  ### Inport/Export commands
  DbAgile::Fixtures::environment.config_file.each do |config|
    next if config.name == :unexisting
    if config.ping?
      describe "The input/output commands on #{config.name}" do 

        before{ 
          dba.use(%w{sqlite}) 
          dba.output_buffer = StringIO.new
        }
      
        describe "The show command" do
          it_should_behave_like "The show command" 
        end
  
        describe "The export command" do
          it_should_behave_like "The export command" 
        end
  
        describe "The import command" do
          it_should_behave_like "The import command" 
        end
    
      end
    else
      puts "Skipping tests on #{config.name} (no ping)"
    end
  end

  
end
