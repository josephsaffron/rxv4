class EntriesController < ApplicationController
  
  before_filter :login_required, :only => [:new, :edit]

  def index      
    if (params[:id])
      show
    else
      list
    end
    render :action => 'index'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @entries = Entry.find :all, :order => 'created_at DESC', :conditions =>'category_id = 1',
                                        :limit => 3
  end

  def show
    @entry = Entry.find(params[:id])
    if (params[:comment])
      addcomment(params[:id])
    end
  end

  def new
    @entry = Entry.new
    @categories = Category.find_all
  end

  def create
    @entry = Entry.new(params[:entry])
    if @entry.save
      flash[:notice] = 'Entry was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    @categories = Category.find_all
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      flash[:notice] = 'Entry was successfully updated.'
      redirect_to :action => 'show', :id => @entry
    else
      render :action => 'edit'
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def blogrss
    @entries = Entry.find :all, :order => 'created_at DESC',
                                        :limit => 10
    render_without_layout
  end
  
  def addcomment entry_id
    @comment = Comment.new(params[:comment])
    @comment.created = Date.today
    @comment.entry_id = entry_id
    @comment.ip = request.remote_ip
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
    end
  end
  
end
