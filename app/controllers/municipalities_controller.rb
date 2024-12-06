class MunicipalitiesController < ApplicationController

  def index 
    @municipalities = Municipality.all
  end

  def show 
    @municipality = Municipality.find(params[:id])
  end

  def meus_municipios 
    @municipalities = current_user.municipalities
  end
end
