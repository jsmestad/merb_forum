require File.join( File.dirname(__FILE__), '..', "spec_helper" )

given 'a new user' do
  @user = User.new
end

describe User do

  it 'should respond to .new' do
    User.should respond_to(:new)
  end
  
  describe '.new' do
    before(:each) do
      @response = User.new
    end
    
    it 'should return a user' do
      @response.should be_kind_of(User)
    end
  end

  [ :id, :login, :email, :identity_url ].each do |attribute|
    it "should respond_to ##{attribute}" do
      User.new.should respond_to(attribute)
    end

    describe "#{attribute}", :given => 'a new user' do
      before do
        @response = @user.send(attribute)
      end

      it 'should return nil by default' do
        @response.should be_nil
      end
    end
  end
  
end