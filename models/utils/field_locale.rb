# encoding: utf-8
module FieldLocale
  def field_locale(*fields)
    raise NotImplementedError, 'uninitialized constant ActiveRecord::Base' unless defined?(ActiveRecord::Base)
    raise NotImplementedError, "#{self.to_s} is not a subclass of ActiveRecord::Base" unless self.superclass == ActiveRecord::Base
    fields.each do |field|
      define_method "#{field}_locale" do |locale=I18n.locale|
        try(:"#{field}_#{locale}") ? __send__(:"#{field}_#{locale}") : __send__(field)
      end
    end
  end
end