class Topics < Application
  before :fetch_forum
  
  def index
    @topics = Topic.all(:forum_id => @forum.id, :order => [:created_at.desc])
    display @topics
  end
  
  def show(id)
    @topic = Topic.get(id)
    raise NotFound unless @topic
    display @topic
  end
  
  def new
    @topic = Topic.new
    display @topic
  end
  
  def create(topic, post)
    @topic = @forum.topics.build(topic)
    @post = @topic.posts.build(post)
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
  
  def edit(id)
    @topic = Topic.get(id)
    raise NotFound unless @topic
    display @topic
  end
  
  def update(id, topic)
    @topic = Topic.get(id)
    raise NotFound unless @topic
    if @topic.update_attributes(topic)
      redirect resource(@forum, @topic),
        :message => {
          :success => "Topic was successfully updated."
        }
    else
      message[:error] = "Error while updating topic."
      display @topic, :edit, :status => 422
    end
  end
  
  def destroy(id)
    @topic = Topic.get(id)
    raise NotFound unless @topic
    if @topic.destroy
      redirect resource(@forum)
    else
      raise InternalServerError
    end
  end
  
  private
    
    def fetch_forum
      @forum = Forum.get(params[:forum_id])
    end
  
end