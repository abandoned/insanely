class Bootstrapper
  def self.bootstrap!
    @snl, @john = User.create!([
      {
        :login => "snl",
        :password => "secret",
        :password_confirmation => "secret",
        :email => "hakan.ensari@papercavalier.com"
      },
      {
        :login => "johndoe",
        :password => "secret",
        :password_confirmation => "secret",
        :email => "john.doe@example.com"
      }
    ])
    
    [@snl, @john].each { |u| u.update_attribute(:active, true) }
  end
end
