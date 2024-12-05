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
  state = State.create!(code: code, name: name)
end

def create_batch(date_start, date_end)
  batch = Batch.create! :start_date => date_start,
                        :end_date => date_end
end

def get_state(key)
  state = State.find_by(code: key)
  if state.nil?
    puts "Estado não encontrado: #{key}"
  end
  return state
end

def get_user(name)
  user = User.find_by("(first_name = ?) or last_name = ?", name, name)
  if user.nil?
    puts "Usuário não encontrado: #{name}"
  end
  return user
end

def get_municipality(key)
  Municipality.find_by(name: key)
end

def create_municipality(file_name, default_sheet, batch_id, max_rows)
  xlsx = Roo::Excelx.new(file_name)
  xlsx.default_sheet = xlsx.sheets[default_sheet]
  # 0-uf	1-name	2-coord-ori	3-corrd-current	4-contact-name	5-contact-title	6-contact-phone
  # 7-contact-email	8-number-of-attempts	9-date-last-attempt	10-contact-effective	11-date-memo-sent
  rows = 0
  xlsx.each_row_streaming(offset: 1, pad_cells: true, max_rows: max_rows) do |row|
    # busca o state
    state = get_state(row[0].to_s)

    # busca user_id do coordenador original e atual
    user_id_original = get_user(row[2].to_s).id
    user_id_current = get_user(row[3].to_s).id

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
      date_last_attempt_d = Date.strptime(row[9].to_s, "%m-%d-%y")
    end
    unless row[11].to_s.nil?
      date_official_letter_d = Date.strptime(row[11].to_s, "%m-%d-%y")
    end

    municipality = Municipality.create! :name => row[1],
                                        :contact_name => row[4],
                                        :contact_title => row[5],
                                        :original_coordinator => user_id_original,
                                        :number_of_attempts => number_of_attempts,
                                        :date_last_attempt => date_last_attempt_d,
                                        :contact_effective => contact_effective,
                                        :official_letter_sent => date_official_letter_d,
                                        :capital_city => false,
                                        :state_id => state.id,
                                        :batch_id => batch_id,
                                        :user_id => user_id_current
    number = row[6].to_s
    unless number.nil?
      phone = Phone.create! :number => number, :callable => municipality
    end

    address = row[7].to_s
    unless address.nil?
      email = Email.create! :address => address, :emailable => municipality
    end
    rows += 1
  end
  puts "#{rows} municipios lidos da Lista #{file_name}"
end

def create_provider_enrollment(file_name, default_sheet, max_rows)
  xlsx_prov = Roo::Excelx.new(file_name)
  xlsx_prov.default_sheet = xlsx_prov.sheets[default_sheet]
  rows = 0
  xlsx_prov.each_row_streaming(offset: 1, pad_cells: true, max_rows: max_rows) do |row|
    # busca FKs
    state = get_state(row[0].to_s)
    municipality = get_municipality(row[1].to_s)
    user = get_user(row[2].to_s)

    provider = Provider.find_by(name: row[3].to_s)
    unless !provider.nil?
      provider = Provider.create! :name => row[3],
                                  :cnpj => row[4],
                                  :site_url => row[5],
                                  :contact_name => row[6]
      number = row[8].to_s
      unless number.nil?
        phone = Phone.create! :number => number,
        :callable => provider
      end
      address = row[7].to_s
      unless address.nil?
        email = Email.create! :address => address,
        :emailable => provider
      end
    end

    invitation_sent = false
    if row[10].to_s == "s" || row[10].to_s == "S"
      invitation_sent = true
    end
    unless row[9].to_s.nil?
      contact_date = Date.strptime(row[9].to_s, "%m-%d-%y")
    end
    unless row[11].to_s.nil?
      acceptance_date = Date.strptime(row[11].to_s, "%m-%d-%y")
    end
    enrollment = Enrollment.create! :contact_date => contact_date,
                                    :acceptance_date => acceptance_date,
                                    :invited => invitation_sent,
                                    :note => row[12],
                                    :municipality_id => municipality.id,
                                    :provider_id => provider.id,
                                    :user_id => user.id
    rows += 1
  end
  puts "#{rows} provedores lidos da Lista #{file_name}"
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

puts "*"
puts "* Usuários criados: #{User.count}"
puts "*"

puts "************************"
puts '* Creating states'
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

puts "*"
puts "*Estados criados: #{State.count}"
puts "*"

puts "************************"
puts 'Creating batches'
puts "************************"

lista_1 = create_batch('20240916', '20241017')
lista_2 = create_batch('20240930', '20241017')

puts "*"
puts "* Batches criados: #{Batch.count}"
puts "*"

puts "******************************************"
puts 'Creating municipalities, phones and emails'
puts "******************************************"

create_municipality('./lib/seeds/municipalities/Listas.xlsx', 0, nil, 116)
create_municipality('./lib/seeds/municipalities/Listas.xlsx', 1, lista_1.id, 194)
create_municipality('./lib/seeds/municipalities/Listas.xlsx', 2, lista_2.id, 95)

puts "*"
puts "* Municipios criados: #{Municipality.count}"
puts "*"

puts "******************************************"
puts 'Creating provider/enrollments'
puts "******************************************"

create_provider_enrollment('./lib/seeds/providers/Provedores.xlsx', 0, 598)
create_provider_enrollment('./lib/seeds/providers/Provedores.xlsx', 1, 301)

puts "*"
puts "* Provedores criados: #{Provider.count}"
puts "*"

puts "*"
puts "* Enrollments criados: #{Enrollment.count}"
puts "*"

puts "Seeding completed (❁´◡`❁)"
