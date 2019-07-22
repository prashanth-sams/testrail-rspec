current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path)

Dir.glob(File.join(current_path, '**', '*.rb')).each do |f|
  require f
end

class App
  def initialize
    @pages = {}
  end

  def google_home
    @pages[:google_home] ||= GoogleHome.new
  end
end