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
    UserRating.create!(user: @user, rateable: @rateable, mark: true).attributes
  end

  def register_rate_against
    UserRating.create!(user: @user, rateable: @rateable, mark: false).attributes
  end

  def cancel_rate
    rating_record.destroy!.attributes
  end

  private

  def rating_record
    @rating_record ||= UserRating.where(user: @user, rateable: @rateable).first
  end
end
