class BrekkiesController < ApplicationController
  def new
    @brek = Brek.new
  end

  def index

  end

  def create
    @brek = Brek.create(brek_params)
    if @brek.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def brek_params
    params.require(:brek).permit(:message)
  end

end
