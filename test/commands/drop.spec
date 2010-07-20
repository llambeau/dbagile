shared_examples_for("The drop command") do
  
  before{
    dba.with_current_connection do |conn|
      conn.transaction do |t|
        t.create_table(:unexisting, {:id => String})
      end
    end
  }
  after{
    dba.with_current_connection do |conn|
      conn.transaction do |t|
        t.drop_table(:unexisting) if t.has_table?(:unexisting)
      end
    end
  }
  
  it "should drop the table" do
    dba.drop %{unexisting}
    dba.with_current_connection do |conn|
      conn.has_table?(:unexisting).should be_false
    end
  end

end