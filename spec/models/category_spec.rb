require File.join( File.dirname(__FILE__), '..', "spec_helper" )

given 'a new category' do
  @category = Category.new
end

describe Category do

  it 'should respond to .new' do
    Category.should respond_to(:new)
  end
  
  describe '.new' do
    before(:each) do
      @response = Category.new
    end
    
    it 'should return a user' do
      @response.should be_kind_of(Category)
    end
  end

  [ :id, :name, :description ].each do |attribute|
    it "should respond_to ##{attribute}" do
      Category.new.should respond_to(attribute)
    end

    describe "#{attribute}", :given => 'a new category' do
      before do
        @response = @category.send(attribute)
      end

      it 'should return nil by default' do
        @response.should be_nil
      end
    end
  end
  
end