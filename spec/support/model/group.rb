class Group < ActiveRecord::Base
  mamechiwa :options, :group_type do
    mame_group "group1" do 
      mattr :group_1_attr

      define_validator do
        validates :group_1_attr, presence: true
      end
    end

    mame_group "group2" do 
      mattr :group_2_attr_1
      mattr :group_2_attr_2

      define_validator do
        validates :group_2_attr_1, presence: true
        validates :group_2_attr_2, presence: true
      end
    end

    mattr :group_1_attr
  end
end
