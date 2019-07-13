class BrekkiesController < ApplicationController
  def new
    @brek = Brek.new
  end

  def index

  end

  def create
    @brek = Brek.create(brek_params)
    redirect_to root_path
  end

  private

  def brek_params
    params.require(:brek).permit(:message)
  end

end
