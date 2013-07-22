module Adauth
    # Active Directory Connection wrapper
    #
    # Handles errors and configures the connection.
    class Connection
        include Expects
      
        def initialize(config)
            expects config, Hash
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
               conn.encryption @config[:encryption]
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
            rescue Errno::ECONNRESET
              if @config[:allow_fallback]
                @config[:port] = @config[:allow_fallback]
                @config[:encryption] = false
                return Adauth::Connection.new(@config).bind
              end
            end
        end
    end
end