class ReferralsController < ApplicationController
  def create
    respond_to do |format|
      referral = Referral.new(referral_params)
      referral.user = current_user if current_user.present?
      if referral.save
        ReferralMailer.delay.referred(referral.id)
        format.json {
          render :json => {
            :status => 200,
            :message => "Referral created successfully"
          }
        }
      else
        format.json { render :json => { :status => 500, :message => referral.errors.full_messages.join(". ") + "." } }
      end
    end
  end

  private 

  def referral_params
    params.require(:referral).permit(
      :email,
      :referrer_name,
      :dream_id,
      :user_id
    )
  end
end