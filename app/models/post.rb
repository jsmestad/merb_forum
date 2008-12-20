class Post
  include DataMapper::Resource
  
  property :id,         Serial
  property :title,      String
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_length :content, :min => 5
  validates_present :user
  
  belongs_to :topic
  belongs_to :user
  
  before :save, :highlight_and_style_content
  
  protected
  
    def highlight_and_style_content
      style_bbcode
      highlight_code
    end
    
    def style_bbcode
      self.content = self.content.bbcode_to_html({}, true, :disable, :code)
    end
      
    def highlight_code
      starts = self.content.index(/\[c|Co|Od|De|E\]/)
      ends   = self.content.index(/\[\/c|Co|Od|De|E\]/)
      ends = ends ? ends + 6 : self.content.length - 1
      if starts
        code = self.content.slice(starts..ends)
        new_code = code.gsub('[code]', '').gsub('[/code]', '')
        highlighted = CodeRay.scan(new_code, :ruby).html
        self.content = self.content.gsub(code, highlighted)
      end
    end
  
end