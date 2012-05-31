class NoDefault < ActiveRecord::Base
  mamechiwa :options, :group_type do
    mame_group "group" do
      mattr :value
    end
  end
end
