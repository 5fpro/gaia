namespace :build do

  task deploy: :environment do
    from = Rails.root.join('public', 'gaia', 'dist')
    to = Rails.root.join('docs', 'gaia', 'dist')
    `cp #{from}/* #{to}/`
    `git checkout master`
    `git pull origin master`
    `git add #{to}`
    `git commit -m 'deploy at #{Time.now}'`
    `git push origin master`
  end

  task taiwan: :environment do
    JsCompiler.to_file(:taiwan)
  end

end
