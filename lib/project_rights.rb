module ProjectRights
  private
  
  def can_remove?(participant)
    (created?(@project) && !i_am?(participant) && !project_created_by?(participant)) || (!created?(@project) && i_am?(participant))
  end
  
  def i_am?(participant)
    participant.id == @current_user.id
  end
  
  def created?(project)
    @current_user.id == @project.creator_id
  end
  
  def project_created_by?(participant)
    participant.id == @project.creator_id
  end
end