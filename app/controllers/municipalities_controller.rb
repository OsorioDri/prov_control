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

  def show 
    @municipality = Municipality.find(params[:id])
  end

  def meus_municipios 
    @municipalities = current_user.municipalities
  end
end
