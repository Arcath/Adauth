module Adauth
    class Connection
        def self.bind(login, pass)
            conn = Net::LDAP.new    :host => Adauth.config.server,
                                    :port => Adauth.config.port,
                                    :base => Adauth.config.base,
                                    :auth => { :username => "#{login}@#{Adauth.config.domain}",
                                        :password => pass,
                                        :method => :simple }
            if conn.bind
                return conn
            else
                return nil
            end
        end
    end
end