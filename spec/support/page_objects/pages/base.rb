module PageObjects
  class Base
    include Formulaic::Dsl
    include Capybara::DSL
    include Rails.application.routes.url_helpers
  end
end