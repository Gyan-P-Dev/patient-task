require 'rails_helper'

RSpec.describe Patient, type: :model do
  it "is valid with a first name, last name, and email" do
    patient = Patient.new(first_name: "John", last_name: "Doe", email: "patient@gmail.com")
    expect(patient).to be_valid
  end

  it "is invalid without a first name" do
    patient = Patient.new(last_name: "test", email: "test@gmail.com")
    expect(patient).to_not be_valid
    expect(patient.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid without a last name" do
    patient = Patient.new(first_name: "ram", email: "ram@gmail.com")
    expect(patient).to_not be_valid
    expect(patient.errors[:last_name]).to include("can't be blank")
  end

  it "is invalid without an email" do
    patient = Patient.new(first_name: "ram", last_name: "test")
    expect(patient).to_not be_valid
    expect(patient.errors[:email]).to include("can't be blank")
  end

  it "is invalid with a duplicate email" do
    Patient.create(first_name: "ram", last_name: "test", email: "ramtest@gmail.com")
    patient = Patient.new(first_name: "ramesh", last_name: "test1", email: "ramtest@gmail.com")
    expect(patient).to_not be_valid
    expect(patient.errors[:email]).to include("Email has already been taken")
  end

  describe '.ransackable_attributes' do
    it 'returns the correct list of searchable attributes' do
      expect(Patient.ransackable_attributes).to eq(
        ["created_at", "date_of_birth", "email", "first_name", "id", "id_value", "last_name", "next_appointment_date", "updated_at"]
      )
    end
  end

  describe ".ransackable_associations" do
    it "returns an empty array" do
      expect(Patient.ransackable_associations).to eq([])
    end
  end

end
