require 'sinatra'
require 'sinatra/reloader'
require './lib/doctors_office'
require 'pry'

also_reload('lib/**/*.rb')

DB = Sequel.connect("postgres://Guest@localhost/hospital")

get('/') do
  erb(:index)
end
