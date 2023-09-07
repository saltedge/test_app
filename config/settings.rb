require 'settingslogic'

class Settings < Settingslogic
  source "#{__dir__}/application.yml"
  namespace ENV["RAILS_ENV"] || ENV["RACK_ENV"] || Rails.env
  load!

  ENVIRONMENTS = %w(development production staging test)

  ENVIRONMENTS.each do |name|
    define_method "#{name}?" do
      Settings.namespace == name
    end
  end
end
