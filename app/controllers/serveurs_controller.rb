class ServeursController < ApplicationController
  before_action :set_serveur, only: [:show, :edit, :update, :destroy]

  # GET /serveurs
  # GET /serveurs.json
  def index
    unless params[:serveurs_grid].present?
      params[:serveurs_grid] = {"column_names"=>["id", "localisation", "rack", "nom", "type"]}
    end

    @serveurs = ServeursGrid.new(params[:serveurs_grid])
    render "serveurs_grids/index"
  end

  def grid
    @serveurs = ServeursGrid.new(params[:serveurs_grid])
  end

  def baies
    @serveurs_par_baies = {}
    Serveur.joins(:salle).order('salles.title ASC, ilot ASC, baie ASC, position asc').each do |s|
      salle = (s.salle.title.present? ? s.salle.title : "non précisée")
      ilot = (s.ilot.present? ? s.ilot.to_s : "non précisé")
      baie = (s.baie.present? ? s.baie.to_s : "non précisée")
      @serveurs_par_baies[salle] ||= {}
      @serveurs_par_baies[salle][ilot] ||= {}
      @serveurs_par_baies[salle][ilot][baie] ||= []

      @serveurs_par_baies[salle][ilot][baie] << s
    end
  end

  def sort
    params[:serveur].each_with_index do |id, index|
      Serveur.where(id: id).update_all(position: index+1)
    end
    render nothing: true
  end

  # GET /serveurs/1
  # GET /serveurs/1.json
  def show
  end

  # GET /serveurs/new
  def new
    @serveur = Serveur.new
  end

  # GET /serveurs/1/edit
  def edit
  end

  # POST /serveurs
  # POST /serveurs.json
  def create
    @serveur = Serveur.new(serveur_params)

    respond_to do |format|
      if @serveur.save
        format.html { redirect_to @serveur, notice: 'Serveur was successfully created.' }
        format.json { render :show, status: :created, location: @serveur }
      else
        format.html { render :new }
        format.json { render json: @serveur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /serveurs/1
  # PATCH/PUT /serveurs/1.json
  def update
    respond_to do |format|
      if @serveur.update(serveur_params)
        format.html { redirect_to @serveur, notice: 'Serveur was successfully updated.' }
        format.json { render :show, status: :ok, location: @serveur }
      else
        format.html { render :edit }
        format.json { render json: @serveur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /serveurs/1
  # DELETE /serveurs/1.json
  def destroy
    @serveur.destroy
    respond_to do |format|
      format.html { redirect_to serveurs_url, notice: 'Serveur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serveur
      @serveur = Serveur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serveur_params
      params.require(:serveur).permit(:localisation_id, :armoire_id, :categorie_id, :nom, :nb_elts, :architecture_id, :u, :marque_id, :modele_id, :numero, :conso, :cluster, :critique, :domaine_id, :gestin_id, :acte_id, :phase, :salle_id, :ilot, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie, :baie)
    end
end