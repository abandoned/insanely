class ActionController::Base
  def self.inherit_states
    resource_class.aasm_states.each do |state|
      has_scope(state.name, :only => [state.name])
      define_method(state.name) do
        params[state.name] = 1
        collection
        render :action => :index
      end
    end
  end
end