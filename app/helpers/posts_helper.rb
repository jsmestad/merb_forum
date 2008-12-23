module Merb
  module PostsHelper
    
    def bb_code_to_html(content)
      content.bbcode_to_html({}, false, :disable, :code)
    end
    
    def highlight_syntax(text)
      starts = text.index(/\[code\]|\[CODE\]/)
      ends   = text.index(/\[\/code\]|\[\/CODE\]/)
      ends = ends ? ends + 6 : text.length - 1
      if starts
        snippet = text.slice(starts..ends)
        new_code = snippet.gsub('[code]', '').gsub('[/code]', '')
        highlighted = CodeRay.scan(new_code, :ruby).html
        text.gsub(snippet, "<div class=\"code-ray\">#{highlighted}</div>")
      else
        text
      end
    end
    
    def pretty_post(content)
      result = highlight_syntax(content)
      bb_code_to_html(result)
    end

  end
end # Merb