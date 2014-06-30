require 'ruote/storage/fs_storage'

$ruote_storage = Ruote::FsStorage.new("db/ruote/#{Rails.env}")

RuoteKit.engine = Ruote::Dashboard.new(Ruote::Worker.new($ruote_storage))
