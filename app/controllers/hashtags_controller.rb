class HashtagsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
  actions :show
end
