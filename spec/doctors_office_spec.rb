require "doctors_office"
require "rspec"
require "pry"
require "sequel"

DB = Sequel.connect("postgres://Guest@localhost/hospital_test")

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
      Doctor.add("Dr. Kojisan", "heart surgeon")
      expect(DB[:doctor_specialty].first[:specialty]).to(eq("heart surgeon"))
    end
  end

end
