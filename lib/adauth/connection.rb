module Adauth
    # Active Directory Connection wrapper
    #
    # Handles errors and configures the connection.
    class Connection
        def initialize(config)
            @config = config
        end
        
        # Attempts to bind to Active Directory
        #
        # If it works it returns the connection
        #
        # If it fails it raises and exception
        def bind
            conn = Net::LDAP.new :host => @config[:server],
                                 :port => @config[:port],
                                 :base => @config[:base]
            if @config[:encryption]
               conn.encryption = @config[:encryption]
            end

            conn.auth "#{@config[:username]}@#{@config[:domain]}", @config[:password]
            
            begin
                Timeout::timeout(10){
                    if conn.bind
                        return conn
                    else
                        raise 'Query User Rejected'
                    end
                }
            rescue Timeout::Error
                raise 'Unable to connect to LDAP Server'
            end
        end
    end
end