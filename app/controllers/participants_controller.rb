class ParticipantsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :project
end
