shared_examples_for("The ComplexRestful POST interface") do
  
  before(:each){ DbAgile::Fixtures::restore_basic_values(database) }
  after(:each) { DbAgile::Fixtures::restore_basic_values(database) }
  
  dbagile_install_examples(__FILE__, self)
  
end
