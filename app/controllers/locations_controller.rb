class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  def ranking
    location_ids = Like.group(:location_id).order('count_location_id DESC').limit(10).count(:location_id).keys
    @locations = location_ids.map { |id| Location.find_by(id: id) }
  end

  # GET /locations/new
  def new
    @location = Location.new(address: params[:address],
                             latitude: params[:latitude],
                             longitude: params[:longitude])
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        set_tags
        format.html { redirect_to root_path, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:title, :comment, :address, :latitude, :longitude).merge(user_id: current_user.id)
    end

    def set_tags
      if params[:scenery]
        LocationsTag.create(location_id: @location.id, tag_id: 1)
      end
      if params[:building]
        LocationsTag.create(location_id: @location.id, tag_id: 2)
      end
      if params[:nature]
        LocationsTag.create(location_id: @location.id, tag_id: 3)
      end
      if params[:food]
        LocationsTag.create(location_id: @location.id, tag_id: 4)
      end
      if params[:amusement]
        LocationsTag.create(location_id: @location.id, tag_id: 5)
      end
      if params[:others]
        LocationsTag.create(location_id: @location.id, tag_id: 6)
      end
    end
end
