namespace :build do

  task deploy: :environment do
    from = Rails.root.join('public', 'dist')
    tmp = Rails.root.join('tmp')
    to = Rails.root.join('docs', 'dist')
    `rm -rf #{tmp}/dist`
    `cp -R #{from} #{tmp}/`
    `git checkout master`
    `cp -R #{tmp}/dist/* #{to}/`
    `git add docs/dist`
    `git commit -m 'deploy at #{Time.now}'`
    `git pull origin master`
    `git push origin master`
  end

  task taiwan: :environment do
    JsCompiler.to_file(:taiwan)
    `cp #{Rails.root.join('db', 'countries', 'taiwan.json')} #{Rails.root.join('public', 'dist')}`
  end

end
