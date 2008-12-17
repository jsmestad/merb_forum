require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a user exists" do
  create_user
end

describe "Users Resource" do
  
  describe "index action" do
    it "should respond successfully" do
      visits("/users").should be_successful
    end
    
    it "should render the proper view" do
      response = visits("/users")
      response.body.should include("Members List")
    end
  end

  describe "show action", :given => 'a user exists' do
    before do
      @response = visits("/users/1")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
  end
  
  describe "new action" do
    before do
      @response = visits("/users/new")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
    
    it "should render new.html.haml" do
      @response.body.should include("Register")
    end
  end
  
  describe "create action", :given => 'a user exists' do  
    it "should fail for duplicate user information" do
      response = visit("/users", :post, :user => user_attributes)
      response.status.should == 422
    end
    
    it 'should fail on unmatched passwords' do
      response = visit("/users", :post, :user => user_attributes.update(:password => 'dude'))
      response.status.should == 422
    end
  end
  
  describe "edit action", :given => 'a user exists' do
    before do
      @response = visit("/users/1/edit")
    end
    
    it "should find the user if it exists" do
      @response.should be_successful
      response = visit("/users/2/edit")
      response.should_not be_successful
      response.status.should == 404
    end
    
    it 'should render edit.haml.html' do
      @response.body.should include("Update Account")
    end
  end
  
  describe "update action", :given => 'a user exists' do
    before do
      @response = visit("/users/1", :put, :user => {:email => 'theguy@hotmail.com'})
    end
    
    it 'should update user attributes properly' do
      @response.should be_successful
      User.first.email.should == 'theguy@hotmail.com'
    end
    
    it 'should redirect to show template' do
      @response.headers['Location'] == '/users/1'
    end
  end
  
  describe "destroy action", :given => 'a user exists' do
    before do
      @user = User.first
      @user.should_not be_nil
      @response = visit("/users/#{@user.id}", :delete)
    end
    
    it "should delete the user" do
      redirect_to(resource(:users))
      User.first.should be_nil
    end
  end
  
end
