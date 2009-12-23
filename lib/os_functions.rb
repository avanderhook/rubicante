module OsFunctions
  def is_windows?
    RUBY_PLATFORM.downcase.include?("mswin") or RUBY_PLATFORM.downcase.include?("cygwin")
  end
end
