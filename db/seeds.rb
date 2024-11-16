# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
require 'roo'

def create_admin_user(first_name, last_name, email)
  # user = User.new(code: code, name: name)
  # user.save!
  user = User.create! :first_name => first_name,
                      :last_name => last_name,
                      :email => email,
                      :profile => "Admin",
                      :password => "123456",
                      :password_confirmation => "123456"
end

def create_state(code, name)
  state = State.new(code: code, name: name)
  state.save!
end

def create_batch(date_start, date_end)
  batch = Batch.new(start_date: date_start, end_date: date_end)
  batch.save!
end

def create_municipality(file_name)
  xlsx = Roo::Spreadsheet.open(file_name)
  # xlsx.default_sheet = xlsx.sheets[1]
  # puts xlsx.default_sheet

  xlsx.each(id: 'uf', name: "municipality_name", coordinator:original_coordinator) do | row |
    p row
    # p row.values
    p row[:name]
  end
end

# puts "*****************"
# puts "Cleaning the database"
# puts "*****************"

# State.destroy_all
# User.destroy_all

# puts "************************"
# puts 'Creating admin user'
# puts "************************"

# create_admin_user('Carlos', 'Siqueira', 'carlos.siqueira@sevabrasil.com')

# puts "************************"
# puts 'Creating states'
# puts "************************"

# #create_state('RJ', 'Rio de Janeiro')
# create_state('AC', 'Acre')
# create_state('AL', 'Alagoas')
# create_state('AP', 'Amapá')
# create_state('AM', 'Amazonas')
# create_state('BA', 'Bahia')
# create_state('CE', 'Ceará')
# create_state('ES', 'Espírito Santo')
# create_state('GO', 'Goiás')
# create_state('MA', 'Maranhão')
# create_state('MT', 'Mato Grosso')
# create_state('MS', 'Mato Grosso do Sul')
# create_state('MG', 'Minas Gerais')
# create_state('PA', 'Pará')
# create_state('PB', 'Paraíba')
# create_state('PR', 'Paraná')
# create_state('PE', 'Pernambuco')
# create_state('PI', 'Piauí')
# create_state('RJ', 'Rio de Janeiro')
# create_state('RN', 'Rio Grande do Norte')
# create_state('RS', 'Rio Grande do Sul')
# create_state('RO', 'Rondônia')
# create_state('RR', 'Roraima')
# create_state('SC', 'Santa Catarina')
# create_state('SP', 'São Paulo')
# create_state('SE', 'Sergipe')
# create_state('TO', 'Tocantins')

# puts "************************"
# puts 'Creating batches'
# puts "************************"

# create_batch('20240916', '20241017')
# create_batch('20240930', '20241017')

puts "************************"
puts 'Creating municipalities'
puts "************************"

create_municipality('./lib/seeds/municipalities/Lista2.xlsx')


puts "Seeding completed (❁´◡`❁)"
