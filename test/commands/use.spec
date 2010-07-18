shared_examples_for("The use command") do
  
  it "should return the current configuration" do
    dba.config_file_path = empty_config_path
    dba.add(%w{test sqlite://test.db})
    dba.use(%w{test}).should be_kind_of(::DbAgile::Core::Configuration)
  end

  it "should raise an error if the configuration is unknown" do
    dba.config_file_path = empty_config_path
    lambda{ dba.use(%w{test}) }.should raise_error(DbAgile::NoSuchConfigError)
  end

  it "should flush the config file" do
    dba.config_file_path = empty_config_path
    dba.add(%w{--no-current test sqlite://test.db})
    dba.use(%w{test})
    dba.dup.config_file.current?(:test).should be_true
  end
  
end