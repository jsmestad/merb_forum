class Forums < Application
  
  def index
    @forums = Forum.all
    display @forums
  end
  
  def show(id)
    @forum = Forum.get(id)
    raise NotFound unless @forum
    display @forum
  end
  
  def new
    only_provides :html
    @forum = Forum.new
    display @forum
  end
  
  def create(forum)
    @forum = Forum.new(forum)
    if @forum.save
      redirect resource(@forum), 
        :message => {
          :success => "Forum was successfully created."
        }
    else
      message[:error] = "Error while creating forum."
      render :new, :status => 422
    end
  end
  
  def edit(id)
    only_provides :html
    @forum = Forum.get(id)
    raise NotFound unless @forum
    display @forum
  end
  
  def update(id, forum)
    @forum = Forum.get(id)
    raise NotFound unless @forum
    if @forum.update_attributes(forum)
       redirect resource(@forum)
    else
      display @forum, :edit
    end
  end

  def destroy(id)
    @forum = Forum.get(id)
    raise NotFound unless @forum
    if @forum.destroy
      redirect resource(:forums)
    else
      raise InternalServerError
    end
  end
  
end