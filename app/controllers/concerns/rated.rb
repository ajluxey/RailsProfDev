module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_rateable, only: %i[rate rate_against cancel_rating]
  end

  def rate
    RegisterRatingService.from(current_user).for(@rateable).register_rate
    rating_response(@rateable)
  end

  def rate_against
    RegisterRatingService.from(current_user).for(@rateable).register_rate_against
    rating_response(@rateable)
  end

  def cancel_rating
    RegisterRatingService.from(current_user).for(@rateable).cancel_rate
    rating_response(@rateable)
  end

  private

  def rating_response(rateable)
    respond_to do |format|
      format.json { render json: { rating: rateable.rating }, status: :ok }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_rateable
    @rateable = model_klass.find(params[:id])
  end
end
