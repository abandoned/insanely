# DO NOT MODIFY THIS FILE

require 'digest/sha1'
require "rubygems"

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  module SharedHelpers

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "The default Gemfile was not found"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten

     :: Kernel.class_eval do
        private
        def gem(*) ; end
      end
      Gem.source_index # ensure RubyGems is fully loaded

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        File.join(spec.full_gem_path, spec.bindir, exec_name)
      end
    end

    extend self
  end
end

module Bundler
  LOCKED_BY    = '0.9.10'
  FINGERPRINT  = "693a430e9323df659bba2c39b5e2516d87b41249"
  AUTOREQUIRES = {:production=>[["heroku", false], ["pg", false]], :test=>[["factory_girl", false]], :cucumber=>[["pickle", false]], :default=>[["RedCloth", false], ["responders", false], ["will_paginate", false], ["has_scope", false], ["erubis", false], ["delayed_job", false], ["aws/s3", true], ["inherited_resources", false], ["aasm", false], ["authlogic", false], ["haml", false], ["paperclip", false], ["gravtastic", false], ["test-unit", false], ["rails", false], ["compass", false]], :development=>[["hirb", false], ["sqlite3", true], ["annotate", false]]}
  SPECS        = [
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/xml-simple-1.0.12/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/xml-simple-1.0.12.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/activesupport-2.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/activesupport-2.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/configuration-1.1.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/configuration-1.1.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/builder-2.1.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/builder-2.1.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/RedCloth-4.2.3/lib", "/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/RedCloth-4.2.3/ext", "/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/RedCloth-4.2.3/lib/case_sensitive_require"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/RedCloth-4.2.3.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/json_pure-1.2.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/json_pure-1.2.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/responders-0.4.3/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/responders-0.4.3.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/pickle-0.2.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/pickle-0.2.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/actionmailer-2.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/actionmailer-2.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/will_paginate-2.3.12/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/will_paginate-2.3.12.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/hirb-0.2.10/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/hirb-0.2.10.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/has_scope-0.4.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/has_scope-0.4.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/factory_girl-1.2.3/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/factory_girl-1.2.3.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/cucumber-rails-0.3.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/cucumber-rails-0.3.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/database_cleaner-0.5.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/database_cleaner-0.5.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rack-1.0.1/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rack-1.0.1.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/actionpack-2.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/actionpack-2.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rack-test-0.5.3/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rack-test-0.5.3.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/webrat-0.7.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/webrat-0.7.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rubyforge-2.0.4/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rubyforge-2.0.4.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/abstract-1.0.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/abstract-1.0.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/erubis-2.6.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/erubis-2.6.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/delayed_job-1.8.4/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/delayed_job-1.8.4.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/mime-types-1.16/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/mime-types-1.16.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/aws-s3-0.6.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/aws-s3-0.6.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rest-client-1.3.1/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rest-client-1.3.1.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/inherited_resources-1.0.4/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/inherited_resources-1.0.4.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/sqlite3-ruby-1.2.5/lib", "/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/sqlite3-ruby-1.2.5/ext"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/sqlite3-ruby-1.2.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rake-0.8.7/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rake-0.8.7.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/launchy-0.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/launchy-0.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/gemcutter-0.4.1/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/gemcutter-0.4.1.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/hoe-2.5.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/hoe-2.5.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/nokogiri-1.4.1/lib", "/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/nokogiri-1.4.1/ext"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/nokogiri-1.4.1.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/diff-lcs-1.1.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/diff-lcs-1.1.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rspec-1.3.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rspec-1.3.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/aasm-2.1.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/aasm-2.1.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/heroku-1.8.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/heroku-1.8.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rspec-rails-1.3.2/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rspec-rails-1.3.2.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/authlogic-2.1.3/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/authlogic-2.1.3.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/polyglot-0.3.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/polyglot-0.3.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/treetop-1.4.4/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/treetop-1.4.4.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/haml-2.2.20/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/haml-2.2.20.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/pg-0.9.0/lib", "/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/pg-0.9.0/ext"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/pg-0.9.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/activerecord-2.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/activerecord-2.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/paperclip-2.3.1.1/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/paperclip-2.3.1.1.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/annotate-2.4.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/annotate-2.4.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/gravtastic-2.2.0/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/gravtastic-2.2.0.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/test-unit-1.2.3/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/test-unit-1.2.3.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/activeresource-2.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/activeresource-2.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/rails-2.3.5/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/rails-2.3.5.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/compass-0.8.17/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/compass-0.8.17.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/term-ansicolor-1.0.4/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/term-ansicolor-1.0.4.gemspec"},
        {:load_paths=>["/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/gems/cucumber-0.6.3/lib"], :loaded_from=>"/Users/papercavalier/.rvm/gems/ree-1.8.7-2010.01/specifications/cucumber-0.6.3.gemspec"},
      ].map do |hash|
    spec = eval(File.read(hash[:loaded_from]), binding, hash[:loaded_from])
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    spec
  end

  extend SharedHelpers

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      $LOAD_PATH.unshift(*spec.require_paths)
    end
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Setup bundle when it's required.
  setup
end
