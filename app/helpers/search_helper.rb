module SearchHelper
  def get_query_class(options)
    if options[:inline]
      ''
    else
      options[:main_page] ? 'span9' : 'span11'
    end
  end
end
