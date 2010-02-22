# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pluralize_verb(count, verb)
    count == 1 ? "#{verb}s" : verb
  end
end
