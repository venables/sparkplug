
after_bundler do

  say_wizard "Cleanup recipe running 'after bundler'"

  # remove unnecessary files
  %w{
    README
    doc/README_FOR_APP
    public/index.html
    app/assets/images/rails.png
  }.each { |file| remove_file file }
  
  # add placeholder READMEs
  copy_template "README.textile"
  gsub_file "README.textile", /AppName/, "#{app_name.humanize.titleize}"
end