require 'ruote/part/smtp_participant'

class EmailParticipant < Ruote::SmtpParticipant
  def consume(workitem)
    puts "This would send an email (#{workitem.inspect}) ..."
  end
end

RuoteKit.engine.register do
  participant :buyer, Ruote::StorageParticipant
  participant :dealer, Ruote::StorageParticipant
  participant :superdealer, Ruote::StorageParticipant
  participant :backoffice, Ruote::StorageParticipant

  participant :office_email, EmailParticipant, to: 'office@example.com'
end
