class Topics < Application
  before :fetch_forum
  
  
  def index
    @topics = Topic.all(:forum_id => params[:forum_id], :order => [:created_at.desc])
    display @topics
  end
  
  def show(id)
    @topic = Topic.get(id)
    raise NotFound unless @topic
    display @topic
  end
  
  def new
    @topic = Topic.new
    #@post = Post.new
    display @topic
  end
  
  def create(topic)
    @topic = @forum.topics.build(topic)
    @post = @topic.posts.build(params[:post])
    if @topic.save && @post.save
      redirect resource(@forum, @topic), 
        :message => {
          :success => "Topic was successfully created."
        }
    else
      message[:error] = "Error while creating topic."
      render :new, :status => 422
    end
  end
  
  private
    
    def fetch_forum
      @forum = Forum.get(params[:forum_id])
    end
  
end