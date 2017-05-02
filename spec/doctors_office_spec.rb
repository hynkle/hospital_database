require "doctors_office"
require "rspec"
require "pry"
require "sequel"

DB = Sequel.connect("postgres://Guest@localhost/hospital_test")

RSpec.configure do |config|
  config.after(:each) do
    DB[:patients].delete
    DB[:doctors].delete
  end
end

describe "Patient" do

  describe ".add" do
    it "adds a patient record to the database" do
      Patient.add("Francis Bacon", "1867-01-01")
      expect(DB[:patients].first[:name]).to eq "Francis Bacon"
    end
  end

end


describe "Doctor" do

  describe ".add" do
    it "adds a Doctor to the database" do
      Doctor.add("Dr. Kojisan", "heart surgeon")
      expect(DB[:doctors].first[:name]).to(eq("Dr. Kojisan"))
    end
  end

  describe ".add" do
    it "adds a Doctor to the database" do
      doctor_id = Doctor.add("Dr. Kojisan", "heart surgeon")
      expect(DB[:doctors].where(:id => doctor_id).first[:specialty_id]).to eq "9ce3257c-4fc7-4a2c-b1c9-1a0671785026"
    end
  end

  describe ".assign" do
    it "assigns a doctor to a patient in the database" do

    end
  end

end
