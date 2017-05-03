Sequel.migration do
  change do
    run 'CREATE EXTENSION "uuid-ossp"'

    create_table(:specialties) do
      uuid :id, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      String :specialty, null: false
    end

    create_table(:doctors) do
      uuid :id, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      String :name, null: false
      foreign_key :specialty_id, :specialties, type: :uuid
    end

    create_table(:patients) do
      uuid :id, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      foreign_key :doctor_id, :doctors, type: :uuid
      String :name, null: false
      Date :birthday, null: false
    end
  end
end
