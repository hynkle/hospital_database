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
