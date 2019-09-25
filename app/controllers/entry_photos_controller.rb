class EntryPhotosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @entry_photos_pages, @entry_photos = paginate :entry_photos, :per_page => 10
  end

  def show
    @entry_photos = EntryPhoto.find(:first, :conditions => [ "filename = ?", params[:id]])
    send_data @entry_photos.file, 
    :filename => @entry_photos.filename, 
    :type => "image/jpeg", 
    :disposition => "inline"
  end

  def new
  end

  def create
    @params['entry_photo']['filename'] = @params['entry_photo']['tmp_file'].original_filename.gsub(/[^a-zA-Z0-9.]/, '_') # This makes sure filenames are sane
    @params['entry_photo']['file'] = @params['entry_photo']['tmp_file'].read
    @params['entry_photo'].delete('tmp_file') # let's remove the field from the hash, because there's no such field in the DB anyway.
    @entry_photo = EntryPhoto.new(@params['entry_photo'])
    if @entry_photo.save
      redirect_to :action => "show", :id => @entry_photo.id
    else
      render :action => 'show'
    end
  end

  def edit
    @entry_photos = EntryPhoto.find(params[:id])
  end

  def update
    @entry_photos = EntryPhoto.find(params[:id])
    if @entry_photos.update_attributes(params[:entry_photos])
      flash[:notice] = 'EntryPhotos was successfully updated.'
      redirect_to :action => 'show', :id => @entry_photos
    else
      render :action => 'edit'
    end
  end

  def destroy
    EntryPhoto.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end
