# Given there are 3 users
Given /^there are (\d+) (.+)$/ do |n, model_str|
  model_str = model_str.gsub(/\s/, '_').singularize
  model_sym = model_str.to_sym
  klass = eval(model_str.camelize)
  klass.transaction do
    klass.destroy_all
    n.to_i.times do |i|
      Factory.create(model_sym)
    end
  end
end

Given /^I have no ([^"]*)$/ do |model_str|
  Given %{there are 0 #{model_str}}
end

# Given the following users exist:
Given /^the following ([^"]*) exist:$/ do |model_str, table|
  model_str = model_str.gsub(/\s/, '_').singularize

  table.hashes.each do |data|
    record = Factory.create(model_str.to_sym, data)
    record.save!
  end
end

# Then there should be 3 users
Then /^there should be (\d+) (.+)$/ do |num, model_str|
  model_str.gsub(/\s/, '_').singularize.classify.constantize.count.should == num.to_i
end

Then /^I should have (\d+) (.+)$/ do |num, model_str|
  Then %{there should be #{num} #{model_str}}
end
