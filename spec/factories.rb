Factory.define :user do |f|
  f.sequence(:login) { |n| "foo#{n}" }
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.password 'secret'
  f.password_confirmation { |u| u.password }
  f.sequence(:persistence_token) { |n| "foo#{n}" }
end

Factory.define :project do |f|
  f.sequence(:title) { |n| "foo#{n}" }
end

Factory.define :task do |f|
  f.message 'lorem ipsum'
  f.status 'active'
  f.association :project
  f.author { |author| author.association(:user) }
end

Factory.define :task_with_asset, :class => Task do |f| 
  f.message 'lorem ipsum'
  f.status 'active'
  f.association :project
  f.assets { |assets| [assets.association(:attachable_asset)] }
  f.author { |author| author.association(:user) }
end
  
Factory.define :comment do |f|
  f.message 'lorem ipsum'
  f.association :task
  f.author { |author| author.association(:user) }
end

Factory.define :comment_with_asset, :class => Comment do |f|
  f.message 'lorem ipsum'
  f.association :task
  f.assets { |assets| [assets.association(:attachable_asset)] }
  f.author { |author| author.association(:user) }
end

Factory.define :participation do |f|
  f.association :participant
  f.association :project
end

Factory.define :attachable_asset, :class => Asset do |f|
  f.file_file_name 'foo.bar'
end

Factory.define :asset do |f|
  f.file_file_name 'foo.bar'
  f.association :attachable, :factory => :task 
  f.association :attachable, :factory => :comment
end