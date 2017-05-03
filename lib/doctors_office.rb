require "sequel"
require "securerandom"

module Patient

  def self.add(name, birthday)
    patient_id = SecureRandom.uuid
    DB[:patients].insert(id: patient_id, name: name, birthday: birthday)
    patient_id
  end

  #list of patients assigned to doctor using id
  def self.patients_of(doctor_id)
    DB[:patients].where(:doctor_id => doctor_id).all
  end

end

module Doctor

  def self.add(name, specialty)
    doctor_id = SecureRandom.uuid
    specialty_id = self.get_specialty_id(specialty)
    DB[:doctors].insert(doctor_id, name, specialty_id)
    doctor_id
  end

  def self.assign(doctor_id, patient_id)
    DB.run("update patients set doctor_id = '#{doctor_id}' where id = '#{patient_id}'")
  end

  #list of doctors based on given specialty
  def self.by_specialty(specialty)
    specialty_id = self.get_specialty_id(specialty)
    DB[:doctors].where(:specialty_id => specialty_id).all
  end

  #alphabetical list of doctors with cooresponding number of patients
  def self.alphabetical_with_number_of_patients
    doctor_with_patient_number = []
    DB["select * from doctors order by name"].all.each do |doctor|
      number_of_patients = Patient.patients_of(doctor[:id]).length
# binding.pry
      doctor_with_patient_number.push([doctor[:name], number_of_patients])
    end
    doctor_with_patient_number
  end

  private

  def self.get_specialty_id(specialty)
    DB["select id from specialties where specialty = '#{specialty}'"].first[:id]
  end

end
