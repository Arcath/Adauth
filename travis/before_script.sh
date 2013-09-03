#!/bin/sh

# Create the Logs directory
mkdir log

# Generate admin password
password="secret"
crypted_password=`slappasswd -s $password`
echo "crtpyed password: ${crypted_password}"

# Apply the administrator password
cat <<EOF | sudo ldapmodify -Y EXTERNAL -H ldapi:///
version: 1
dn: olcDatabase={1}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: ${crypted_password}
-
EOF

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f travis/ldif/phonetic-attribute-options.ldif

# Calculate base and domain name
base="dc=`echo get slapd/domain | sudo debconf-communicate slapd | sed -e 's/^0 //' | sed -e 's/^\.//; s/\./,dc=/g'`"
domain="`echo get slapd/domain | sudo debconf-communicate slapd | sed -e 's/^0 //'`"

# Create the query user ldif file
cat <<EOF > travis/ldif/query_user.ldif
dn: cn=adauth,${base}
cn: Adauth
objectClass: user
objectClass: top
userPassword: ${crypted_password}
sn: Tests
EOF

# Add the new user
sudo ldapadd -D "cn=admin,${base}" -W -x -f travis/ldif/query_user.ldif

# Generate the tests config file
cat <<EOF > spec/test_data.yml
domain:
  domain: ${domain}
  port: 389
  base: ${base}
  server: 127.0.0.1
  query_user: adauth
  query_user_dn: cn=admin,${base}
  query_password: ${password}
  breakable_user: foo
  breakable_password: bar
  testable_ou: Foo
EOF

# Output the config file for debugging purposes
cat spec/test_data.yml
