require "doctors_office"
require "rspec"
require "pry"
require "sequel"

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

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

  describe ".patients_of" do
    it "returns a list of patients for a given doctor" do
      doctor_id = Doctor.add("Dr. Kojisan", "heart surgeon")
      patient_id1 = Patient.add("Francis Bacon", "1867-01-01")
      Doctor.assign(doctor_id, patient_id1)
      patient_id2 = Patient.add("Parker Posey", "1979-02-02")
      Doctor.assign(doctor_id, patient_id2)
      expect(Patient.patients_of(doctor_id).length).to eq 2
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
      doctor_id = Doctor.add("Dr. Kojisan", "heart surgeon")
      patient_id = Patient.add("Francis Bacon", "1867-01-01")
      Doctor.assign(doctor_id, patient_id)
      expect(DB[:patients].where(:id => patient_id).first[:doctor_id]).to eq doctor_id
    end
  end

  describe ".by_specialty" do
    it "returns a list of doctors for a given specialty" do
      doctor_id = Doctor.add("Dr. Kojisan", "heart surgeon")
      doctor_hash = Doctor.by_specialty("heart surgeon")
      expect(doctor_hash[0][:specialty_id]).to(eq("9ce3257c-4fc7-4a2c-b1c9-1a0671785026"))
    end
  end

  describe ".alphabetical_with_number_of_patients" do
    it "returns a list of doctors in aphabetical order and their number of patients" do
      doctor_id1 = Doctor.add("Dr. Kojisan", "heart surgeon")
      patient_id1 = Patient.add("Francis Bacon", "1867-01-01")
      doctor_id2 = Doctor.add("Dr. Anderson", "brain surgeon")
      patient_id2 = Patient.add("Parker Posey", "1979-02-02")
      Doctor.assign(doctor_id1, patient_id1)
      Doctor.assign(doctor_id2, patient_id2)
      expect(Doctor.alphabetical_with_number_of_patients).to eq [["Dr. Anderson", 1], ["Dr. Kojisan", 1]]
    end
  end


end
