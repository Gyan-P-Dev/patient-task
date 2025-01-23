require 'rails_helper'

RSpec.describe PatientsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "test@example.com",
      next_appointment_date: 2.days.from_now
    }
  end

  let(:invalid_attributes) do
    {
      first_name: "",
      last_name: "",
      email: "invalid_email",
      next_appointment_date: nil
    }
  end

  before { sign_in user }

  describe "GET #index" do
    context "when no filter or search is applied" do
      it "assigns all patients to @patients and paginates them" do
        patient1 = Patient.create!(valid_attributes.merge(email: "patient1@example.com"))
        patient2 = Patient.create!(valid_attributes.merge(email: "patient2@example.com"))
        get :index
        expect(assigns(:patients)).to match_array([patient1, patient2])
        expect(assigns(:patients).current_page).to eq(1)  # assuming default pagination is 5
      end
    end

    context "when search is applied" do
      it "filters patients matching the search query" do
        patient1 = Patient.create!(valid_attributes.merge(email: "ram.patient@example.com", first_name: "Alice"))
        patient2 = Patient.create!(valid_attributes.merge(email: "shyam.patient@example.com", last_name: "Doe"))
        get :index, params: { q: { first_name_cont: "Alice" } }
        expect(assigns(:patients)).to include(patient1)
        expect(assigns(:patients)).not_to include(patient2)
      end
    end
  end

  describe "GET #upcoming" do
    context "when upcoming filter is applied" do
      it "assigns only patients with upcoming appointments within 72 hours to @patients" do
        upcoming_patient = Patient.create!(valid_attributes.merge(email: "upcoming.patient@example.com", next_appointment_date: 24.hours.from_now))
        past_patient = Patient.create!(valid_attributes.merge(email: "past.patient@example.com", next_appointment_date: 1.week.ago))

        get :upcoming
        expect(assigns(:patients)).to include(upcoming_patient)
        expect(assigns(:patients)).not_to include(past_patient)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested patient to @patient" do
      patient = Patient.create!(valid_attributes)
      get :show, params: { id: patient.id }
      expect(assigns(:patient)).to eq(patient)
    end

    context "when patient is not found" do
      it "returns a 404 not found status" do
        invalid_id = "nonexistent_id"
        get :show, params: { id: invalid_id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET #new" do
    it "assigns a new patient to @patient" do
      get :new
      expect(assigns(:patient)).to be_a_new(Patient)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new patient and redirects to the patients list" do
        expect {
          post :create, params: { patient: valid_attributes }
        }.to change(Patient, :count).by(1)
        expect(response).to redirect_to(patients_path)
        expect(flash[:notice]).to eq("Patient created successfully")
      end
    end

    context "with invalid attributes" do
      it "does not create a new patient and renders the new template" do
        expect {
          post :create, params: { patient: invalid_attributes }
        }.to_not change(Patient, :count)
        expect(response).to render_template(:new)
        expect(assigns(:patient).errors).to be_present
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested patient to @patient" do
      patient = Patient.create!(valid_attributes)
      get :edit, params: { id: patient.id }
      expect(assigns(:patient)).to eq(patient)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the patient and redirects to the patients list" do
        patient = Patient.create!(valid_attributes)
        patch :update, params: { id: patient.id, patient: { first_name: "Updated" } }
        patient.reload
        expect(patient.first_name).to eq("Updated")
        expect(response).to redirect_to(patients_path)
        expect(flash[:notice]).to eq("Patient updated successfully")
      end
    end

    context "with invalid attributes" do
      it "does not update the patient and renders the edit template" do
        patient = Patient.create!(valid_attributes)
        patch :update, params: { id: patient.id, patient: invalid_attributes }
        patient.reload
        expect(patient.first_name).not_to eq("")
        expect(response).to render_template(:edit)
      end
    end
  end
end
