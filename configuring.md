---
layout: page
title: "Configuring"
tagline: "Anything &amp; Everything"
---

Adauth is very easy to configure, all of its config is in _config/initializers/adauth.rb_ and there are only 4 values that need to be set for it to work.

# Creating Adauth.rb

The easiest way to create adauth.rb is to run `rails g adauth:config` and have adauth create the file with all the values present and some helpful comments.

# Important values

## domain

This one is pretty self explanatory, it needs to be set to the domain name of your network. For example "github.com", "arcath.net" or "company.local", if your unsure what your domain name is contact your network staff.

## server

This needs to be the IP or Hostname of a Domain Controller on your network. For example "dc1.github.com", "windowsdc.arcath.net" or "server.company.local", again if you are unsure ask your network staff.

If you have multiple DCs on your network _server_ can be set to your domain as "company.local" resolves to a DC on your network. This will only work if your webserver is on the same network as your DCs if your hosting the app externally you will need to set this to a specific DC.

## base

This is the LDAP base for the users you wish to allow access. If you wanted to restrict access to your app to specific OUs on the domain you could do it here. If you want to give access to every user on the domain the base would be

"dc=github, dc=com",
"dc=arcath, dc=net",
"dc=company, dc=local"

If you would rather restrict users based on their group memberships see the allowed groups variable below.

## port

Port isn't always necessary as adauth defaults to _389_ which is the default ldap port. Obviosuly if you are accessing ldap from the outside its a lot safer to use a non standard port and you will need to change this.

# Other Variables

## allowed_groups

This can be set to an array of group names which __can login to your app__. This allows you to control access through active directory and removes the need for you to do any user administration in app.

For example if you had the groups "Warehouse Staff", "Finance Staff" and "Customer Services" and you only wanted "Warehouse Staff" and "Finance Staff" to be able to login then you would set allowed groups to `["Warehouse Staff", "Finance Staff"]` this makes adauth check group memberships if a valid user is found. This means that if someone in the "IT Support" group logins in with a valid username and password combo adauth will return the same as if they had got their password wrong.

## denied_groups

This works in the same way as __allowed_groups__ only in reverse, groups listed in this array will fail to login. Like all windows permissions a denied permission comes before an allowed.

## allowed_ous and denied_ous

These work in exactly the same way as their group based counterparts.