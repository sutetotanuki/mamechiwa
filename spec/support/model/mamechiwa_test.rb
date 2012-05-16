class MamechiwaTest < ActiveRecord::Base
  mamechiwa :options do
    mattr :name
    mattr :value

    define_validator do
      validates :name, presence: true
    end
  end
end
