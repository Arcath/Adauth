module Adauth
    
    # Create a connection to LDAP using Net::LDAP
    #
    # Called as:
    #    Adauth::Connection.bind(username, password)
    #
    # 
    class Connection
        
        # Create a connection to LDAP using Net::LDAP
        #
        # Called as:
        #    Adauth::Connection.bind(username, password)
        #
        #
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