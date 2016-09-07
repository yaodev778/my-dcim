class Composant < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :nom => proc { |controller, model_instance| model_instance.try(:name)}
  }

  validates_presence_of :type_composant_id

  belongs_to :modele
  belongs_to :type_composant

  has_many :slots
  has_many :cards_servers

  acts_as_list scope: [:modele_id, :type_composant_id]

  accepts_nested_attributes_for :slots,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  def to_s
    name
  end

end
