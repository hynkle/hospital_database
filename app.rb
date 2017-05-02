require 'sinatra'
require 'sinatra/reloader'
require 'sequel'
require './lib/doctors_office'
require 'pry'

also_reload('lib/**/*.rb')

DB = Sequel.connect("postgres://Guest@localhost/hospital")

get('/') do
  erb(:index)
end

get('/admin_home') do
  @todays_date = Time.now.strftime("%Y-%m-%d")
  erb(:admin)
end

get('/patient_home') do
  @specialties_list = DB["select * from specialties order by specialty"].all
  erb(:patient)
end

get('/specialties_by_doctor/:specialty') do
  @specialty = params.fetch("specialty")
  @doctors = Doctor.by_specialty(@specialty)
  erb(:docs_by_specialty)
end

post "/add/doctor" do
  doctor_name = params["doctor-name"]
  doctor_specialty = params["doctor-specialty"]
  Doctor.add(doctor_name, doctor_specialty)
  erb(:sucessfully_added)
end

post "/add/patient" do
  patient_name = params["patient-name"]
  patient_birthday = params["patient-birthday"]
  Patient.add(patient_name, patient_birthday)
  erb(:sucessfully_added)
end

get "/doctor/list" do
  @doctor_list = Doctor.alphabetical_with_number_of_patients
  erb :doctor_list
end
