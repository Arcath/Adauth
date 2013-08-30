#!/bin/sh

mkdir log

password="secret"
crypted_password=`slappasswd -s $password`
cat <<EOF | sudo ldapmodify -Y EXTERNAL -H ldapi:///
version: 1
dn: olcDatabase={1}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: ${crypted_password}
-
EOF

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f travis/ldif/phonetic-attribute-options.ldif

base="dc=`echo get slapd/domain | sudo debconf-communicate slapd | sed -e 's/^0 //' | sed -e 's/^\.//; s/\./,dc=/g'`"
domain="`echo get slapd/domain | sudo debconf-communicate slapd | sed -e 's/^0 //'`"

cat <<EOF > spec/test_data.yml
domain:
  domain: ${domain}
  port: 389
  base: ${base}
  server: 127.0.0.1
  query_user: admin
  query_password: ${password}
  breakable_user: foo
  breakable_password: bar
  testable_ou: Foo
EOF

cat spec/test_data.yml
