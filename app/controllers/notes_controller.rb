class NotesController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
  
  private
  
  def begin_of_association_chain
    current_user
  end
end