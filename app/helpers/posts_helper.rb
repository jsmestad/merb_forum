module Merb
  module PostsHelper
    
    def bb_code_to_html(code)
      code.bbcode_to_html({}, true, :disable, :code)
    end
    
    def highlight_syntax(code)
      starts = code.index(/\[code\]|\[CODE\]/)
      ends   = code.index(/\[\/code\]|\[\/CODE\]/)
      ends = ends ? ends + 6 : code.length - 1
      if starts
        snippet = code.slice(starts..ends)
        new_code = snippet.gsub('[code]', '').gsub('[/code]', '')
        highlighted = CodeRay.scan(new_code, :ruby).html
        code.gsub(snippet, "<div class=\"CodeRay\">#{highlighted}</div>")
      end
    end
    
    def pretty_post(content)
      highlight_syntax(bb_code_to_html(content))
    end

  end
end # Merb