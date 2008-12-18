class Posts < Application
  before :fetch_topic
  
  def new
    only_provides :html
    @post = Post.new
    @post.title = "Re: #{@topic.title}"
    display @post
  end
  
  def create(post)
    @post = @topic.posts.build(post)
    if @post.save
      redirect resource(@topic.forum, @topic),
        :message => {
          :success => 'Post was created successfully.'
        }
    else
      message[:error] = "Error while creating reply."
      render :new, :status => 422
    end
  end
  
  def edit(id)
    only_provides :html
    @post = Post.get(id)
    raise NotFound unless @post
    display @post
  end
  
  def update(id, post)
    @post = Post.get(id)
    raise NotFound unless @post
    if @post.update_attributes(post)
      redirect resource(@topic.forum, @topic),
        :message => {
          :success => 'Post was updated successfully.'
        }
    else
      message[:error] = "Error while updating post."
      display @post, :edit, :status => 422
    end
  end
  
  def destroy(id)
    @post = Post.get(id)
    raise NotFound unless @post
    if @post.destroy
      redirect resource(@topic.forum, @topic)
    else
      raise InternalServerError
    end
  end
  
  private
  
    def fetch_topic
      @topic = Topic.get(params[:topic_id])
    end
  
end