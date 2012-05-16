require "spec_helper"

describe Mamechiwa do
  before { @mame = MamechiwaTest.new }

  it "should set value like hash" do
    @mame.options.name = "aa"
    @mame.options["name"].should eq "aa"
  end

  it "should validation with define validator" do
    @mame.should_not be_valid
  end

  it "should set error message when validation is fail" do
    @mame.valid?
    @mame.errors["options[name]"].should eq ["can't be blank"]
  end

  it "should decode from serialized value from database" do
    @mame.options.name = "hanako"
    @mame.options.value = "kawaii"
    @mame.save!
    @fetched = MamechiwaTest.find(@mame.id)
    @fetched.options.value.should eq "kawaii"
  end

  describe "as_json" do
    it "should include the defined option" do
      @mame.options.name = "aa"
      @mame.as_json["mamechiwa_test"]["options"]["name"].should eq "aa"
    end

    it "should include the defined option if not present" do
      @mame.as_json["mamechiwa_test"]["options"].keys.include?("name").should be_true
      @mame.as_json["mamechiwa_test"]["options"]["name"].should be_nil
    end
  end

  describe "to_json" do
    it "should convert a json format string" do
      @mame.options.name = "abc"
      ActiveSupport::JSON.decode(@mame.to_json)["mamechiwa_test"]["options"]["name"].should eq "abc"
    end
  end

  describe "group" do
    before { @group = Group.new }
    
    it "should switch default attributes if not define group key" do
      @group.options.group_1_attr = "a"
      @group.options.group_1_attr.should eq "a"
    end

    it "should switch specified attributes by group key" do
      @group.group_type = "group1"
      @group.options.group_1_attr = "a"
      @group.options.group_1_attr.should eq "a"

      @group2 = Group.new({ group_type: "group2" })
      @group2.options.group_2_attr_1 = "a"
      @group2.options.group_2_attr_1.should eq "a"
    end

    it "should error if use other group attribyte" do
      expect {
        @group.options.group_2_attr_1
      }.should raise_error NoMethodError
    end
  end
end