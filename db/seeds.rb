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

def create_municipality(file_name, default_sheet, batch_id, max_rows)
  xlsx = Roo::Excelx.new(file_name)
  xlsx.default_sheet = xlsx.sheets[default_sheet]
  # p batch_id.id
  # puts " Default sheet: #{xlsx.default_sheet}"
  # 0-uf	1-name	2-coord-ori	3-corrd-current	4-contact-name	5-contact-title	6-contact-phone
  # 7-contact-email	8-number-of-attempts	9-date-last-attempt	10-contact-effective	11-date-memo-sent
  # "name", "contact_name", "contact_title", "original_coordinator", "number_of_attempts"
  # "date_last_attempt", "contact_effective", "official_letter_sent", "capital_city", "state_id"
  # "batch_id", "user_id"
  rows = 0
  xlsx.each_row_streaming(offset: 1, pad_cells: true, max_rows: max_rows) do |row|
    # puts row[1]
    # busca o state_id
    state_code = row[0].to_s
    state = State.find_by code: state_code
    unless state_code.nil?
      state_id = state.id
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

    #prepara number of atttempts - tá vindo como float
    number_of_attempts = row[8].to_s.to_i
    if number_of_attempts.nil?
      number_of_attempts = 0
    end

    #prepara datas
    unless row[9].to_s.nil?
      # p default_sheet
      # p row[4]
      # p row[9].to_s
      date_last_attempt_d = Date.strptime(row[9].to_s, "%m-%d-%y")
    end
    unless row[11].to_s.nil?
      date_official_letter_d = Date.strptime(row[11].to_s, "%m-%d-%y")
    end
    # p row[11].formatted_value

    municipality = Municipality.create! :name => row[1],
                                        :contact_name => row[4],
                                        :contact_title => row[5],
                                        :original_coordinator => user_id_original,
                                        :number_of_attempts => number_of_attempts,
                                        :date_last_attempt => date_last_attempt_d,
                                        :contact_effective => contact_effective,
                                        :official_letter_sent => date_official_letter_d,
                                        :capital_city => false,
                                        :state_id => state_id,
                                        :batch_id => batch_id,
                                        :user_id => user_id_current

    phone = Phone.create! :number => row[6].to_s,
                          :callable => municipality
    email = Email.create! :address => row[7].to_s,
                          :emailable => municipality
    # p email

    rows += 1
  end
  puts "#{rows} lidas da Lista #{file_name}"
end

puts "*****************"
puts "Cleaning the database"
puts "*****************"

Enrollment.destroy_all
Municipality.destroy_all
State.destroy_all
Batch.destroy_all
Phone.destroy_all
Email.destroy_all
Provider.destroy_all
User.destroy_all

puts "************************"
puts 'Creating users'
puts "************************"

create_user('Carlos', 'Siqueira', 'carlos.siqueira@sevabrasil.com', 'Admin')
create_user('Ailtom', 'Gobira', 'gobira@sevabrasil.com', 'Coordinator')
create_user('João', 'Viríssimo', 'joao@sevabrasil.com', 'Coordinator')
create_user('Mara', 'Francy', 'mara@sevabrasil.com', 'Coordinator')
create_user('Marcello', 'Santo', 'marcelo@sevabrasil.com', 'Coordinator')
create_user('Márcia', 'Cavalcante', 'marcia@sevabrasil.com', 'Coordinator')

puts "************************"
puts 'Creating states'
puts "************************"

create_state('RJ', 'Rio de Janeiro')
create_state('AC', 'Acre')
create_state('AL', 'Alagoas')
create_state('AP', 'Amapá')
create_state('AM', 'Amazonas')
create_state('BA', 'Bahia')
create_state('CE', 'Ceará')
create_state('ES', 'Espírito Santo')
create_state('GO', 'Goiás')
create_state('MA', 'Maranhão')
create_state('MT', 'Mato Grosso')
create_state('MS', 'Mato Grosso do Sul')
create_state('MG', 'Minas Gerais')
create_state('PA', 'Pará')
create_state('PB', 'Paraíba')
create_state('PR', 'Paraná')
create_state('PE', 'Pernambuco')
create_state('PI', 'Piauí')
create_state('RJ', 'Rio de Janeiro')
create_state('RN', 'Rio Grande do Norte')
create_state('RS', 'Rio Grande do Sul')
create_state('RO', 'Rondônia')
create_state('RR', 'Roraima')
create_state('SC', 'Santa Catarina')
create_state('SP', 'São Paulo')
create_state('SE', 'Sergipe')
create_state('TO', 'Tocantins')

puts "************************"
puts 'Creating batches'
puts "************************"

lista_1 = create_batch('20240916', '20241017')
lista_2 = create_batch('20240930', '20241017')
# puts lista_2

puts "******************************************"
puts 'Creating municipalities, phones and emails'
puts "******************************************"

create_municipality('./lib/seeds/municipalities/Listas.xlsx', 0, nil, 116)
create_municipality('./lib/seeds/municipalities/Listas.xlsx', 1, lista_1.id, 194)
create_municipality('./lib/seeds/municipalities/Listas.xlsx', 2, lista_2.id, 95)

puts "Seeding completed (❁´◡`❁)"
