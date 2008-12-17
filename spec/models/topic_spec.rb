require File.join( File.dirname(__FILE__), '..', "spec_helper" )

given 'a new topic' do
  @topic = Topic.new
end

describe Topic do

  it 'should respond to .new' do
    Topic.should respond_to(:new)
  end
  
  describe '.new' do
    before(:each) do
      @response = Topic.new
    end
    
    it 'should return a user' do
      @response.should be_kind_of(Topic)
    end
  end

  [ :id, :title, :description ].each do |attribute|
    it "should respond_to ##{attribute}" do
      Topic.new.should respond_to(attribute)
    end

    describe "#{attribute}", :given => 'a new topic' do
      before do
        @response = @topic.send(attribute)
      end

      it 'should return nil by default' do
        @response.should be_nil
      end
    end
  end
  
end