class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:gitlab]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.username = auth.info.username
      user.avatar_url = auth.info.image
      user.is_admin = auth.is_admin
      user.state = auth.state
      user.password = Devise.friendly_token[0,20]
      user.scroll_hint = true
    end
  end

  def setup_complete?
    !(self.token.nil? || self.token.empty?)
  end
end
