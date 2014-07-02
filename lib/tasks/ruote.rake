namespace :ruote do
  desc "Run a worker thread for ruote"
  task :run_worker => :environment do
    puts 'Launching ruote-kit worker ...'

    RuoteKit.run_worker($ruote_storage) do |engine|
      engine.noisy = Rails.env.development?
    end
  end
end
