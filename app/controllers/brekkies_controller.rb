class BrekkiesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def destroy
    @brek = Brek.find_by_id(params[:id])
    return render_not_found if @brek.blank?
    @brek.destroy
    redirect_to root_path
  end

  def update
    @brek = Brek.find_by_id(params[:id])
    return render_not_found if @brek.blank?

    @brek.update_attributes(brek_params)
    if @brek.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def new
    @brek = Brek.new
  end

  def index

  end

  def show
    @brek = Brek.find_by_id(params[:id])
    return render_not_found if @brek.blank?
  end

  def edit
    @brek = Brek.find_by_id(params[:id])
    return render_not_found if @brek.blank?
  end

  def create
    @brek = current_user.breks.create(brek_params)
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

  def render_not_found
    render plain: 'Not Found :(', status: :not_found
  end

end
