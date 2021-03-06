class CoupleBaie < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :baie_one, :class_name => "Frame"
  belongs_to :baie_two, :class_name => "Frame"

end
