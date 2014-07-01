# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Brand.where(identifier: 'brand-1').first_or_create!
Brand.where(identifier: 'brand-2').first_or_create!

Dealer.where(email: 'dealer-1@example.com').first_or_create!
Dealer.where(email: 'dealer-2@example.com').first_or_create!
