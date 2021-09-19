class RegisterRatingService
  def self.from(user)
    new(user)
  end

  def initialize(user)
    @user = user
  end

  def for(rateable)
    @rateable = rateable
    self
  end

  def register_rate
    return unless can_rates?

    UserRating.create!(user: @user, rateable: @rateable, mark: true).attributes
  end

  def register_rate_against
    return unless can_rates?

    UserRating.create!(user: @user, rateable: @rateable, mark: false).attributes
  end

  def cancel_rate
    return unless already_rates?

    rating_record.destroy!.attributes
  end

  private

  def can_rates?
    @user.can_change_rating?(@rateable) && !already_rates?
  end

  def already_rates?
    rating_record.present?
  end

  def rating_record
    @rating_record ||= UserRating.where(user: @user, rateable: @rateable).first
  end
end
