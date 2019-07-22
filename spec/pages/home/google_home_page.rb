require_relative '../base_page.rb'

class GoogleHome < BasePage
  set_url '/'

  element :google_search_field, {:css => '[name="q"]'}

end
