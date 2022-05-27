class UserPresenter
  include Enumerable

  def initialize(gender)
    @gender = gender
  end

  def each(&_block)
    users.each do |user|
      yield format(user)
    end
  end

  def format(user)
    {
      name:         user.name,
      email:        user.email,
      phone_number: user.phone,
    }
  end

  def users
    @_users ||= User.where(gender: @gender)
  end
end