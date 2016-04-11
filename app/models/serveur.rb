class Serveur < ActiveRecord::Base

  belongs_to :acte
  belongs_to :baie
  has_one :salle, through: :baie
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :armoire
  belongs_to :localisation
  belongs_to :cluster

  has_many :slots
  has_many :cards_serveurs, -> { joins(:composant).order("composants.name asc, composants.position asc") }
  has_many :cards, through: :cards_serveurs

  accepts_nested_attributes_for :cards_serveurs,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

end
