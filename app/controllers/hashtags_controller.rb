class HashtagsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
  actions :show
  
  def show
    @tasks = resource.tasks.paginate(
      :page     => params[:page],
      :include  => :assets,
      :order    => 'tasks.updated_at DESC'
    )
    show!
  end
  
  private
  
  def begin_of_association_chain
    current_user
  end
end
