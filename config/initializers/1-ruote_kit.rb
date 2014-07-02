require 'ruote/storage/fs_storage'

$ruote_storage = Ruote::FsStorage.new("db/ruote/#{Rails.env}")

# based on an env variable, we either use an inline or external worker
RuoteKit.engine = Ruote::Dashboard.new(ENV['RUOTE_INLINE_WORKER'] ? Ruote::Worker.new($ruote_storage) : $ruote_storage)

RuoteKit.engine.noisy = Rails.env.development?
