class MemoryTypesController < ApplicationController
  before_action :set_memory_type, only: [:show, :edit, :update, :destroy]

  # GET /memory_types
  # GET /memory_types.json
  def index
    @memory_types = MemoryType.all
  end

  # GET /memory_types/1
  # GET /memory_types/1.json
  def show
  end

  # GET /memory_types/new
  def new
    @memory_type = MemoryType.new
  end

  # GET /memory_types/1/edit
  def edit
  end

  # POST /memory_types
  # POST /memory_types.json
  def create
    @memory_type = MemoryType.new(memory_type_params)

    respond_to do |format|
      if @memory_type.save
        format.html { redirect_to @memory_type, notice: 'Memory type was successfully created.' }
        format.json { render :show, status: :created, location: @memory_type }
      else
        format.html { render :new }
        format.json { render json: @memory_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memory_types/1
  # PATCH/PUT /memory_types/1.json
  def update
    respond_to do |format|
      if @memory_type.update(memory_type_params)
        format.html { redirect_to @memory_type, notice: 'Memory type was successfully updated.' }
        format.json { render :show, status: :ok, location: @memory_type }
      else
        format.html { render :edit }
        format.json { render json: @memory_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memory_types/1
  # DELETE /memory_types/1.json
  def destroy
    @memory_type.destroy
    respond_to do |format|
      format.html { redirect_to memory_types_url, notice: 'Memory type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_memory_type
      @memory_type = MemoryType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def memory_type_params
      params.require(:memory_type).permit(:quantity, :unit)
    end
end
