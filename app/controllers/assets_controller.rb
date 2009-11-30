class AssetsController < ApplicationController
  before_filter :require_user
  
  def index
    @project = current_user.projects.find(params[:project_id])
    @images, @files = @project.tasks.
      inject([]) { |m, t| m + (t.assets + t.comments.inject([]) { |m1, c| m1 + c.assets }) }.
      partition { |a| a.image? }
  end
  
  def show
    asset = Asset.find(params[:id])
    head(:not_found) and return if asset.nil?
    head(:forbidden) and return if (
      (asset.attachable_type == 'Comment' && !asset.attachable.task.project.participants.include?(current_user)) ||
      (asset.attachable_type == 'Task' && !asset.attachable.project.participants.include?(current_user))
    )
    path = asset.file.path(params[:style])
    redirect_to(AWS::S3::S3Object.url_for(path, asset.file.bucket_name, :expires_in => 1.minute))
  end
end
