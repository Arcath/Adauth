require 'adauth'
require 'yaml'

def default_config
    Adauth.configure do |c|
        c.domain = test_data("domain", "domain")
        c.port = test_data("domain", "port")
        c.base = test_data("domain", "base")
        c.server = test_data("domain", "server")
        c.query_user = test_data("domain", "query_user")
        c.query_password = test_data("domain", "query_password")
    end
end

def test_data(set, key)
    @yaml ||= YAML::load(File.open('spec/test_data.yml'))
    @yaml[set][key]
end

def administrator
    Adauth::AdObjects::User.where('sAMAccountName', "administrator").first
end

def domain_admins
    Adauth::AdObjects::Group.where('name', 'Domain Admins').first
end

def domain_controllers
    Adauth::AdObjects::OU.where('name', 'Domain Controllers').first
end

def pdc
    domain_controllers.members.first
end
