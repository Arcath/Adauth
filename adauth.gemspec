# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'adauth/version'

Gem::Specification.new do |s|
    s.name = "adauth"
    s.version = Adauth::Version
    s.platform = Gem::Platform::RUBY
    s.authors = ["Adam \"Arcath\" Laycock"]
    s.email = ["gems@arcath.net"]
    s.homepage = "http://adauth.arcath.net"
    s.summary = "Provides Active Directory authentication for Rails"
    s.description = "A full featured library for working with Microsofts Active Directory in Ruby."
    s.license = 'MIT'
    
    s.add_development_dependency "rake"
    s.add_development_dependency "rspec"
    s.add_development_dependency "simplecov"
    s.add_development_dependency "yard"
    s.add_dependency "net-ldap"
    s.add_dependency "expects", "~> 0.0.2"
    s.add_dependency "missingly", "~> 0.0.5"
    
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")   
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_paths = ["lib"]
end