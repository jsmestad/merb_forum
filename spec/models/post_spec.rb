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