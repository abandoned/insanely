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
    @snl.workmates << @john
    @project = @snl.created_projects.create!(
        :title => "My first project!"
    )
  end
end
