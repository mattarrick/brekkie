class BrekkiesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def destroy
    @brek = Brek.find_by_id(params[:id])
    return render_not_found if @brek.blank?
    return render_not_found(:forbidden) if @brek.user != current_user

    @brek.destroy
    redirect_to root_path
  end

  def update
    @brek = Brek.find_by_id(params[:id])
    return render_not_found if @brek.blank?
    return render_not_found(:forbidden) if @brek.user != current_user

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
    return render_not_found(:forbidden) if @brek.user != current_user
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

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

end
