require "sequel"
require "securerandom"

# module Patient


class Patient < Sequel::Model

  many_to_one :doctor

  def self.add(name, birthday)
    record = create(name: name, birthday: birthday)
    record.id
  end

  def self.patients_of(doctor_id)
    where(doctor_id: doctor_id).all
  end

end

class Doctor < Sequel::Model

  one_to_many :patients
  many_to_one :specialty

  def self.add(name, specialty)
    specialty_id = Specialty.id_for_name(specialty)
    record = create(name: name, specialty_id: specialty_id)
    record.id
  end

  def self.assign(doctor_id, patient_id)
    patient = Patient.find(patient_id)
    patient.doctor_id = doctor_id
    patient.save!
  end

  #list of doctors based on given specialty
  def self.by_specialty(specialty)
    specialty_id = Specialty.id_for_name(specialty)
    where(specialty_id: specialty_id).all
  end

  #alphabetical list of doctors with cooresponding number of patients
  def self.alphabetical_with_number_of_patients
    doctor_with_patient_number = []
    order(:name).all.each do |doctor|
      number_of_patients = Patient.patients_of(doctor[:id]).length
      doctor_with_patient_number.push([doctor[:name], number_of_patients])
    end
    doctor_with_patient_number
  end

end

class Specialty < Sequel::Model

  one_to_many :doctors

  def self.id_for_name(name)
    Specialty.find_by(specialty: name).id
  end

end
