class MunicipalitiesController < ApplicationController

  def index 
    @municipalities = Municipality.all

    if params[:query].present?
      @municipalities = @municipalities.where("name ILIKE ?", "%#{params[:query]}%") 
    end

    respond_to do |format|
      format.html 
      format.text { render partial: 'municipalities/list', locals: { municipalities: @municipalities}, formats: [:html] }
    end
  end

  def new
    @municipality = Municipality.new
  end

  def create
    @municipality = Municipality.new(municipality_params)
    if @municipality.save 
      redirect_to(@municipality)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show 
    @municipality = Municipality.find(params[:id])
  end

  def meus_municipios 
    @municipalities = current_user.municipalities
  end

  private 

  def municipality_params
    params.require(:municipality).permit(:name, :contact_name, :contact_title, :original_coordinator, :number_of_attempts, :date_last_attempt, :contact_effective, :official_letter_sent, :capital_city, :state_id, :batch_id, :user_id)
  end
end
