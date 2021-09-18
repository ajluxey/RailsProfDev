module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_rateable, only: %i[rate rate_against cancel_rating]
  end

  def rate
    unless current_user.ratings.for(@rateable).present?
      status = current_user.rates(@rateable)
    end

    rating_response(status, @rateable)
  end

  def rate_against
    unless current_user.ratings.for(@rateable).present?
      status = current_user.rates_against(@rateable)
    end

    rating_response(status, @rateable)
  end

  def cancel_rating
    if current_user.ratings.for(@rateable).present?
      status = current_user.cancel_rating_for(@rateable)
    end

    rating_response(status, @rateable)
  end

  private

  def rating_response(status, rateable)
    respond_to do |format|
      if status == true
        format.json { render json: { rating: rateable.rating }.merge(rateable.data_attribute_id), status: :ok }
      else
        format.json { render json: {}, status: :bad_request }
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_rateable
    @rateable = model_klass.find(params[:id])
  end
end
