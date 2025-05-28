class ProfilesController < ApplicationController
  def index
    @query = params[:q]

    profiles = if @query.present?
      KlaviyoProfile.where("email LIKE ?", "%#{@query}%")
    else
      KlaviyoProfile.all
    end.order(:email)

    @pagy, @profiles = pagy(profiles)
  end

  def engagement_modal
    @engagement_levels = EngagementLevel.order(:sort_order)
    @profile_ids = params[:ids].to_s.split(",")
    render partial: "engagement_modal", locals: {profile_ids: @profile_ids, engagement_levels: @engagement_levels}
  end

  def update_engagement
    profile_ids = params[:profile_ids]
    level = params[:engagement_level]

    if profile_ids.present? && level.present?
      profile_ids.each do |id|
        Klaviyo::UpdateEngagementJob.perform_later(id, level)
      end

      respond_to do |format|
        format.turbo_stream do
          flash[:notice] = "Updating tags..."
          render turbo_stream: turbo_stream.replace("engagement_modal", partial: "shared/redirect")
        end
        format.html { redirect_to profiles_path, notice: "Updating tags..." }
      end
    end
  end

  def refresh
    Klaviyo::RefreshProfilesJob.perform_later

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial: "shared/refreshing") }
      format.html { redirect_to profiles_path, notice: "Refreshing profiles..." }
    end
  end
end
