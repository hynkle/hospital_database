Sequel.migration do
  up do
    [
      'brain surgeon',
      'heart surgeon',
      'pediatrician',
      'orthodontist'
    ].each do |specialty_name|
      self[:specialties].insert(specialty: specialty_name)
    end
  end
end
