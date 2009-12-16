class ActionController::Base
  def self.inherit_states
    resource_class.aasm_states.each do |state|
      has_scope(state.name, :boolean => true, :only => [state.name])
      define_method(state.name) do
        params[state.name] = true
        collection
        render :action => :index
      end
    end
  end
end