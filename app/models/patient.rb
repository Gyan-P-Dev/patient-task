class Patient < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { message: "Email has already been taken" }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "date_of_birth", "email", "first_name", "id", "id_value", "last_name", "next_appointment_date", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
