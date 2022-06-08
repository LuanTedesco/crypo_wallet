namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") { %x(rails db:drop) }
      show_spinner("Criando DB...") { %x(rails db:create) }
      show_spinner("Migrando DB...") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts("Você não está em ambiente de desenvolvimento!")
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
  show_spinner("Cadastrando moedas...") do
    coins = [
    { description: "Bitcoin",
      acronym: "BTC",
      url_image: "https://imagensemoldes.com.br/wp-content/uploads/2020/09/%C3%8Dcone-Bitcoin-PNG.png",
      mining_type: MiningType.find_by(acronym: 'PoW')
    },
    { description: "Ethirium",
      acronym: "ETH",
      url_image: "https://upload.wikimedia.org/wikipedia/commons/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png",
      mining_type: MiningType.all.sample
    },
    { description: "Dash",
      acronym: "DASH",
      url_image: "https://cryptologos.cc/logos/dash-dash-logo.png",
      mining_type: MiningType.all.sample
    },
    { description: "Iota",
      acronym: "IOT",
      url_image: "https://cryptologos.cc/logos/iota-miota-logo.png",
      mining_type: MiningType.all.sample
    },
    { description: "ZCash",
      acronym: "ZEC",
      url_image: "https://cryptologos.cc/logos/zcash-zec-logo.png",
      mining_type: MiningType.all.sample
    },
    ]
    
    coins.each do |coin|
      Coin.find_or_create_by!(coin)
    end
  end
end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
      show_spinner("Cadastrando tipos de mineração") do
      mining_types = [
        {description: "Proof od Work", acronym: "PoW"},
        {description: "Proof od Stake", acronym: "PoS"},
        {description: "Proof od Capacity", acronym: "PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})") 
  end
end
