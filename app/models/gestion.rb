class Gestion < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :servers

  def to_s
    name.nil? ? "" : name
  end
end
