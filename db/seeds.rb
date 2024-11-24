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

def create_user(first_name, last_name, email, profile)
  user = User.create! :first_name => first_name,
                      :last_name => last_name,
                      :email => email,
                      :profile => profile,
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

def create_municipality(file_name, default_sheet)
  xlsx = Roo::Excelx.new(file_name)
  xlsx.default_sheet = xlsx.sheets[default_sheet]
  # puts " Default sheet: #{xlsx.default_sheet}"
  # 0-uf	1-name	2-coord-ori	3-corrd-current	4-contact-name	5-contact-title	6-contact-phone
  # 7-contact-email	8-number-of-attempts	9-date-last-attempt	10-contact-effective	11-date-memo-sent
  # "name", "contact_name", "contact_title", "original_coordinator", "number_of_attempts"
  # "date_last_attempt", "contact_effective", "official_letter_sent", "capital_city", "state_id"
  # "batch_id", "user_id"
  #
  xlsx.each_row_streaming(offset: 1) do |row|

    # busca o state_id
    state_code = row[0].to_s
    state = State.find_by code: state_code
    unless state_code.nil?
      puts "state record encontrado: #{state.id}"
    end

    # busca user_id od coordenador atual
    user_name_current = row[3].to_s
    user_name_ori = row[2].to_s
    puts "vou fazer o find"
    # user = User.find_by first_name: user_name_current
    user = User.find_by("(first_name = ?) or last_name = ?", user_name_current, user_name_current)
    puts "sai do find"
    unless user.nil?
      puts "user record encontrado: #{user.first_name}"
    end

  end
end

puts "*****************"
puts "Cleaning the database"
puts "*****************"

# State.destroy_all
# Batch.destroy_all
# Enrollment.destroy_all
# Phone.destroy_all
# Email.destroy_all
# Provider.destroy_all
# Municipality.destroy_all
# User.destroy_all

puts "************************"
puts 'Creating users'
puts "************************"

# create_user('Carlos', 'Siqueira', 'carlos.siqueira@sevabrasil.com', 'Admin')
# create_user('Ailtom', 'Gobira', 'gobira@sevabrasil.com', 'Coordinator')
# create_user('João', 'Viríssimo', 'joao@sevabrasil.com', 'Coordinator')
# create_user('Mara', 'Francy', 'mara@sevabrasil.com', 'Coordinator')
# create_user('Marcello', 'Santo', 'marcelo@sevabrasil.com', 'Coordinator')
# create_user('Márcia', 'Cavalcante', 'marcia@sevabrasil.com', 'Coordinator')

puts "************************"
puts 'Creating states'
puts "************************"

# create_state('RJ', 'Rio de Janeiro')
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

puts "************************"
puts 'Creating batches'
puts "************************"

# create_batch('20240916', '20241017')
# create_batch('20240930', '20241017')

puts "************************"
puts 'Creating municipalities'
puts "************************"

create_municipality('./lib/seeds/municipalities/Lista2.xlsx', 0)

puts "Seeding completed (❁´◡`❁)"
