class HashtagsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
  actions :show
  
  def show
    @tasks = resource.tasks.paginate(:page => params[:page], :include => [:assets], :conditions => ['"tasks".status = ?', 'active'])
    show!
  end
end
