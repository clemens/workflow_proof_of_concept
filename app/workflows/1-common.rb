require 'ruote/part/smtp_participant'

class EmailParticipant < Ruote::SmtpParticipant
  def consume(workitem)
    to, template = workitem.params.values_at('to', 'template')

    puts "This would send an email to #{to} with the template #{template} ..."

    reply_to_engine(workitem)
  end
end

RuoteKit.engine.register do
  participant :buyer, Ruote::StorageParticipant
  participant :dealer, Ruote::StorageParticipant
  participant :superdealer, Ruote::StorageParticipant
  participant :backoffice, Ruote::StorageParticipant

  participant :email, EmailParticipant
end
