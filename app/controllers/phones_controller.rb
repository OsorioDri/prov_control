class PhonesController < ApplicationController

  def index
    @phones = Provider.order("name").all
  end

  def new
    # We need @provider in our `simple_form_for`
    @provider = Provider.find(params[:provider_id])
    @phone = Phone.new
  end

  def create
    @phone = Phone.new(phone_params)
    raise
    @phone.provider = @provider
    @review.save
    redirect_to provider_path(@provider)
  end

  private

  def set_provider
    @provider = Provider.find(params[:provider_id])
  end

  def phone_params
    params.require(:phone).permit(:number)
  end
end
