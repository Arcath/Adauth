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
                                    :base => Adauth.config.base

            unless !Adauth.config.encryption
              conn.encryption Adauth.config.encryption
            end

            conn.auth "#{login}@#{Adauth.config.domain}", pass

            begin
                Timeout::timeout(10){
                    if conn.bind
                        return conn
                    else
                        return nil
                    end
                }
            rescue Timeout::Error
                raise "Unable to connect to LDAP Server"
            end
        end
    end
end
