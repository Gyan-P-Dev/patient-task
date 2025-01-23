require 'rails_helper'

RSpec.describe SearchService, type: :service do
  let!(:patient1) { create(:patient, first_name: "John", last_name: "Doe", email: "john@example.com", next_appointment_date: 2.days.from_now) }
  let!(:patient2) { create(:patient, first_name: "Jane", last_name: "Doe", email: "jane@example.com", next_appointment_date: 5.days.from_now) }
  let!(:patient3) { create(:patient, first_name: "Jim", last_name: "Beam", email: "jim@example.com", next_appointment_date: 1.day.from_now) }
  
  describe "#call" do
    context "when the 'upcoming' filter is applied" do
      it "returns only patients with upcoming appointments within 72 hours" do
        service = SearchService.new({}, upcoming: true)
        result = service.call

        expect(result).to include(patient1, patient3)
        expect(result).not_to include(patient2)
      end
    end

    context "when a search query is applied" do
      it "filters patients by the search query" do
        query_params = { first_name_or_last_name_or_email_cont: "Jim" }
        service = SearchService.new(query_params)
        result = service.call

        expect(result).to include(patient3)
        expect(result).not_to include(patient1, patient2)
      end
    end

    context "when both a search query and the 'upcoming' filter are applied" do
      it "filters patients by both search query and upcoming appointments" do
        query_params = { first_name_or_last_name_or_email_cont: "Jim" }
        service = SearchService.new(query_params, upcoming: true)
        result = service.call

        expect(result).to include(patient3)
        expect(result).not_to include(patient1, patient2)
      end
    end
  end
end
