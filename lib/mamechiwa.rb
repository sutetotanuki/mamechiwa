require "active_record"

module Mamechiwa
  module ClassMethods
    attr_accessor :mame_config, :mame_scope, :mame_group_field

    def mame_config
      @mame_config ||= Hash.new{ |h,k| h[k] = {} }
    end

    def mame_scope
      @mame_scope ||= ""
    end

    def mamechiwa(field, group_field="")
      self.mame_group_field = group_field

      yield self

      self.mame_config.each do |k, scope|
        clazz = create_embedded_class(scope[:attrs])
        clazz.class_eval &scope[:validator] if scope[:validator]

        scope[:class] = clazz
      end

      class_eval do
        define_method :initialize_with_mame do
          unless @mame_embedded
            group = self.class.mame_group_field.length > 0 ? self.send(self.class.mame_group_field).to_s : ""

            if self.class.mame_config[group] && self.class.mame_config[group][:class]
              @mame_embedded = self.class.mame_config[group][:class].new(self, field)
            end
          end
        end

        define_method "#{field}=" do |value|
          initialize_with_mame

          hash = value
          hash = ActiveSupport::JSON.decode(value) if value.is_a?(String)
          write_attribute("#{field}", @mame_embedded.merge(hash).to_json)

          @mame_embedded.refresh
        end
        
        define_method "#{field}" do
          initialize_with_mame

          @mame_embedded
        end

        validate :mame_validator

        define_method :mame_validator do
          initialize_with_mame

          unless @mame_embedded
            errors.add("#{field}", "#{self.class.mame_group_field} is unregistered type.")
          else
            if (unregistered_attributes = (@mame_embedded.keys.map(&:to_sym) - @mame_embedded.mame_attrs)).size > 0
              unregistered_attributes.each do |unregistered_attribute|
                errors.add("#{field}[#{unregistered_attribute}]", "is unregistered attribute.")
              end
            end
            
            if !@mame_embedded.valid?
              @mame_embedded.errors.each do |k, v|
                errors.add("#{field}[#{k}]", v)
              end
            end
          end
        end
      end
    end

    def mattr(*name)
      mame_config[mame_scope][:attrs] ||= []
      mame_config[mame_scope][:attrs] += [name].flatten
      mame_config[mame_scope][:attrs].uniq!
    end

    def define_validator(&validator)
      mame_config[mame_scope][:validator] = validator
    end

    def mame_group(name)
      self.mame_scope = name
      mame_config[mame_scope][:attrs] ||= []
      mame_config[mame_scope][:validator] = Proc.new{ }
      yield self if block_given?
      self.mame_scope = ""
    end

    def create_embedded_class(attrs)
      clazz = Class.new(Hash) do
        include ActiveModel::Validations

        define_method :mame_attrs do
          attrs
        end

        def self.name
          "MameciwaEmbedded"
        end
        
        def initialize(parent, field)
          @mame_parent = parent
          @mame_parent_field = field

          refresh
        end

        def refresh
          value = @mame_parent.send(:read_attribute, @mame_parent_field)

          mame_attrs.each do |attr|
            self.old_set(attr.to_s, nil)
          end

          if value
            self.merge!(ActiveSupport::JSON.decode(value))
          end
        end

        def serialize
          self.to_json
        end

        alias :old_get :[]

        def [](arg)
          self.old_get(arg)
        end
        
        alias :old_set :[]=

        def []=(*args)
          key, value = args
          self.old_set(key, value)
          @mame_parent.send(:write_attribute, @mame_parent_field.to_sym, self.serialize)
        end

        attrs.each do |attr|
          class_eval <<-EOF
            def #{attr}
              self["#{attr}"]
            end

            def #{attr}=(value)
              self["#{attr}"] = value
            end
          EOF
        end
      end
    end
  end
end

require "mamechiwa/integrations/active_record"
