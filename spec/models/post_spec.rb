require File.join( File.dirname(__FILE__), '..', "spec_helper" )

given 'a new post' do
  @post = Post.new
end

describe Post do

  it 'should respond to .new' do
    Post.should respond_to(:new)
  end
  
  describe '.new' do
    before(:each) do
      @response = Post.new
    end
    
    it 'should return a user' do
      @response.should be_kind_of(Post)
    end
  end

  [ :id, :title, :content ].each do |attribute|
    it "should respond_to ##{attribute}" do
      Post.new.should respond_to(attribute)
    end

    describe "#{attribute}", :given => 'a new post' do
      before do
        @response = @post.send(attribute)
      end

      it 'should return nil by default' do
        @response.should be_nil
      end
    end
  end
  
end

describe Post, 'when styling for BB_code' do
  
  before(:each) do
    @post = Post.new
  end
  
  it 'should change simple bold tags to HTML bold tags' do
    @post.content = "this should be [b]bold[/b]"
    @post.send(:style_bbcode)
    @post.content.should == 'this should be <strong>bold</strong>'
  end
  
  it 'should ignore [code] tags' do
    @post.content = "this is a [code] code snippet [/code]"
    lambda{ @post.send(:style_bbcode) }.should_not change(@post, :content)
  end
  
end

describe Post, 'when highlighting code snippets' do
  
  before(:each) do
    @post = Post.new
  end
  
  it 'should style a simple class definition' do
    @post.content = "[code]def methodname; end[/code]"
    @post.send(:highlight_code)
    @post.content.should == "<span class=\"r\">def</span> <span class=\"fu\">methodname</span>; <span class=\"r\">end</span>"
  end
  
  it 'should ignore text before and after the code block' do
    @post.content = "Before code [code] class ModelName < SuperClass; [/code] after code"
    @post.send(:highlight_code)
    @post.content.should == "Before code  <span class=\"r\">class</span> <span class=\"cl\">ModelName</span> &lt; <span class=\"co\">SuperClass</span>;  after code"
  end
  
  it 'should not hit Coderay if there is no [code] block' do
    @post.content = "Some regular text"
    CodeRay.should_not_receive(:scan)
    @post.send(:highlight_code)
  end
  
end