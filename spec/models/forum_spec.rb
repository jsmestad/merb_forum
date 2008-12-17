require File.join( File.dirname(__FILE__), '..', "spec_helper" )

given 'a new forum' do
  @forum = Forum.new
end

describe Forum do

  it 'should respond to .new' do
    Forum.should respond_to(:new)
  end
  
  describe '.new' do
    before(:each) do
      @response = Forum.new
    end
    
    it 'should return a user' do
      @response.should be_kind_of(Forum)
    end
  end

  [ :id, :name, :description ].each do |attribute|
    it "should respond_to ##{attribute}" do
      Forum.new.should respond_to(attribute)
    end

    describe "#{attribute}", :given => 'a new forum' do
      before do
        @response = @forum.send(attribute)
      end

      it 'should return nil by default' do
        @response.should be_nil
      end
    end
  end
  
end