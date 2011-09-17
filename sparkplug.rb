@recipes = %w(
  rvm
  cleanup
  database_renamer
  rspec
  cucumber
  coverage
  action_mailer
  homepage
  sorcery
  app_helpers
  pagination
  rails_config
  application_layout
  css_setup
  git
  friendly_errors
  friendly_id
  pow
)


############## Don't go lower.

def recipes_dir
  File.dirname(__FILE__) + "/recipes"
end

def templates_dir
  File.dirname(__FILE__) + "/templates"
end

def template_path(name)
  File.join(templates_dir, @current_recipe, name)
end

def copy_template(name, opts={})
  remove_file(name) if opts[:force]
  copy_file template_path(name), name
end

def run_recipe(name)
  @current_recipe = name
  @before_configs[name].call if @before_configs[name]
  say_recipe name.humanize
  
  eval(contents_of_file("#{recipes_dir}/#{name}.rb"))
end

def contents_of_file(source)
  File.open(source, "rb").read
end

def say_custom(tag, text)
  say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}"
end

def say_recipe(name)
  say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." 
end

def say_wizard(text)
  say_custom(@current_recipe || 'wizard', text) 
end

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + (@current_recipe || "prompt").rjust(10) + "\033[0m\033[36m" + "  #{question}\033[0m"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
  when "yes", "y"
    true
  when "no", "n"
    false
  else
    yes_wizard?(question)
  end
end

def no_wizard?(question)
  !yes_wizard?(question) 
end

def multiple_choice(question, choices)
  say_custom('question', question)
  values = {}
  choices.each_with_index do |choice,i| 
    values[(i + 1).to_s] = choice[1]
    say_custom (i + 1).to_s + ')', choice[0]
  end
  answer = ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

@current_recipe = nil
@configs = {}

@after_blocks = []
def after_bundler(&block)
  @after_blocks << [@current_recipe, block]
end

@after_everything_blocks = []
def after_everything(&block)
  @after_everything_blocks << [@current_recipe, block]
end

@before_configs = {}
def before_config(&block)
  @before_configs[@current_recipe] = block
end

say_wizard "Custom-building your next million dollar app"

@recipes.each do |recipe|
  run_recipe recipe
end
run_recipe 'finalize'
