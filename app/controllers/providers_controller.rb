class ProvidersController < ApplicationController
  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)
    if @provider.save 
      redirect_to root_path 
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @provider = Provider.find(params[:id])
  end

  private

  def provider_params
    params.require(:provider).permit(:name, :cnpj, :site_url, :contact_name, :acceptance_date)
  end
end
