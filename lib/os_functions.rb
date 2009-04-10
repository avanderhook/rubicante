module OsFunctions
  def is_windows?
    RUBY_PLATFORM.downcase.include?("mswin")
  end
end
