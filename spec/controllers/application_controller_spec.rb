require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def after_sign_in_path_for(resource)
      super(resource)
    end

    def after_sign_out_path_for(resource_or_scope)
      super(resource_or_scope)
    end
  end

  describe "#after_sign_in_path_for" do
    it "redirects to patients_path after sign in" do
      user = create(:user)
      sign_in user

      expect(controller.after_sign_in_path_for(user)).to eq(patients_path)
    end
  end

  describe "#after_sign_out_path_for" do
    it "redirects to new_user_session_path after sign out" do
      user = create(:user)
      sign_in user
      sign_out user

      expect(controller.after_sign_out_path_for(user)).to eq(new_user_session_path)
    end
  end
end
