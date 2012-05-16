module Mamechiwa
  module Integrations
    module ActiveRecord
      ::ActiveRecord::Base.extend(Mamechiwa::ClassMethods)
    end
  end
end
