class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update]
  before_action :initialize_ransack, only: [:index, :upcoming]

  def index
    @patients = SearchService.new(params[:q], page: params[:page], per_page: 5).call
  end

  def upcoming
    @patients = SearchService.new(params[:q], page: params[:page], per_page: 5, upcoming: true).call
    render :index
  end

  def show; end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to patients_path, notice: "Patient created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: "Patient updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :date_of_birth, :next_appointment_date)
  end

  def set_patient
    begin
      @patient = Patient.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end

  def initialize_ransack
    @q = Patient.ransack(params[:q])
  end
end
