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

  def index
    @providers = Provider.order("name").all
  end

  def edit
    @provider = Provider.find(params[:id])
  end

  def update
    provider = Provider.find(params[:id])
    provider.update(provider_params)
    redirect_to provider_path(provider)
  end

  private

  def provider_params
    # params.require(:provider).permit(:name, :cnpj, :site_url, :contact_name, :acceptance_date)
    params.require(:provider).permit(:name, :cnpj, :site_url, :contact_name)
  end
end
