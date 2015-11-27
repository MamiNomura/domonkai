

class LabelsController < ApplicationController

  def show

    case params[:shikaku]
      when "kyouju"
        members = Member.where( shikaku_kubun_id: [1,2]).order(:last_name)
      when "shikaku"
        members = Member.where( shikaku_kubun_id: 3).order(:last_name)
      when "ippan"
        members = Member.where( shikaku_kubun_id: 4).order(:last_name)
      when "no_email"
        members = Member.where(email: nil).order(:last_name)
      when "kojin"
        members = Member.where(sensei_member_id: nil).order(:domonkai_id)
      else
        members = Member.order(:last_name)
    end

    labels = Prawn::Labels.render(members, :type => "Avery5160") do |pdf, member|
      if member.sex.eql? 'Male'
        pdf.text 'Mr. '  + member.first_name.to_s + ' ' + member.last_name.to_s
      else
        pdf.text 'Ms. ' + member.first_name.to_s + ' ' + member.last_name.to_s
      end
      pdf.text member.address
      pdf.text member.city.to_s + ', '  + member.state.to_s +  ' ' + member.zip.to_s
      unless member.country.eql? "USA"
        pdf.text member.country
      end
    end

    send_data labels, :filename => "members-avery5160.pdf", :type => "application/pdf"
  end
end