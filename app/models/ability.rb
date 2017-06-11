class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:update, :edit, :destroy], [Book], author_id: user.id
  end
end
