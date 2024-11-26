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
  batch = Batch.create! :start_date => date_start,
                        :end_date => date_end
end

def create_municipality(file_name, default_sheet, batch_id)
  xlsx = Roo::Excelx.new(file_name)
  xlsx.default_sheet = xlsx.sheets[default_sheet]
  puts "Batchid = #{batch_id}"
  # puts " Default sheet: #{xlsx.default_sheet}"
  # 0-uf	1-name	2-coord-ori	3-corrd-current	4-contact-name	5-contact-title	6-contact-phone
  # 7-contact-email	8-number-of-attempts	9-date-last-attempt	10-contact-effective	11-date-memo-sent
  # "name", "contact_name", "contact_title", "original_coordinator", "number_of_attempts"
  # "date_last_attempt", "contact_effective", "official_letter_sent", "capital_city", "state_id"
  # "batch_id", "user_id"
  rows = 0
  xlsx.each_row_streaming(offset: 1, pad_cells: true, max_rows: 2) do |row|
    puts "row: #{rows}"
    # busca o state_id
    state_code = row[0].to_s
    state = State.find_by code: state_code
    unless state_code.nil?
      state_id = state.id
      puts "state code: #{state_code} e state id = #{state_id} e name = #{row[1]}"
    end

    # busca user_id do coordenador original e atual
    user_name_current = row[3].to_s
    user = User.find_by("(first_name = ?) or last_name = ?", user_name_current, user_name_current)
    unless user.nil?
      user_id_current = user.id
    end
    user_name_ori = row[2].to_s
    user = User.find_by("(first_name = ?) or last_name = ?", user_name_ori, user_name_ori)
    unless user.nil?
      user_id_original = user.id
    end

    # prepara contact effective?
    contact_effective = false
    if row[10].to_s == "s" || row[10].to_s == "S"
        contact_effective = true
    end

    #prepara number of atttempts


    #prepara datas
    puts "data last attempt lida: #{row[9]} com tipo #{row[9].type}"
    puts "data memo sent lida: #{row[9]} com tipo #{row[9].type}"
    puts "batch id: #{batch_id}"
    puts "number of atttempts lido: #{row[8]} com tipo #{row[8].type}"
    date_last_attempt = row[9]
    puts date_last_attempt.type
    municipality = Municipality.create! :name => row[1],
                                        :contact_name => row[4],
                                        :contact_title => row[5],
                                        :original_coordinator => user_id_original,
                                        :number_of_attempts => row[8],
                                        :date_last_attempt => "10-14-24",
                                        :contact_effective => row[10],
                                        :official_letter_sent => "10-14-24",
                                        :capital_city => false,
                                        :state_id => state_id,
                                        :batch_id => batch_id,
                                        :user_id => user_id_current

    rows += 1
  end
  puts "#{rows} lidas da Lista #{file_name}"
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
Municipality.destroy_all
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

lista_1 = create_batch('20240916', '20241017')
lista_2 = create_batch('20240930', '20241017')
puts lista_2

puts "************************"
puts 'Creating municipalities'
puts "************************"

create_municipality('./lib/seeds/municipalities/Lista2.xlsx', 0, lista_2)

puts "Seeding completed (❁´◡`❁)"
