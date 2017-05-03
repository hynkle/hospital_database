require "sequel"
require "securerandom"

# module Patient


class Patient < Sequel::Model

  def self.add(name, birthday)
    record = create(name: name, birthday: birthday)
    record.id
  end

  def self.patients_of(doctor_id)
    where(doctor_id: doctor_id).all
  end

end

class Doctor < Sequel::Model

  def self.add(name, specialty)
    specialty_id = get_specialty_id(specialty)
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
    specialty_id = get_specialty_id(specialty)
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

  private

  def self.get_specialty_id(specialty_name)
    Specialty.where(specialty: specialty_name).first.id
  end

end

class Specialty < Sequel::Model

end
