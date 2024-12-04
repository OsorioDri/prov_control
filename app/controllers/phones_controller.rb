class PhonesController < ApplicationController
  before_action :set_callable, only: [:new, :create]

  def index
    @phones = Provider.order("name").all
  end

  def new
    @phone = Phone.new

  end

  def create
    @phone = Phone.new(phone_params)
    # set_callable
    @phone.callable_id = @callable.id
    @phone.callable_type = @callable_type
    @phone.save
    # redirect_to provider_path(@provider)
  end

  private

  def set_callable
    if params[:provider_id].present?
      @callable = Provider.find(params[:provider_id])
      @callable_type = "Provider"
    else
      @callable = Municipality.find(params[:municipality_id])
      @callable_type = "Municipality"
    end
  end

  def phone_params
    params.require(:phone).permit(:number)
  end
end
