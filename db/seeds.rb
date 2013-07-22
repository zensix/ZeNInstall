# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

country = Country.create([{code:'TR', name:'Turkey'}, {code:'DE', name:'Germany'}, {code:'GB', name:'England'}])
category = Category.create([{name:'Discounter'}, {name:'Reseller'}, {name:'End user'}])

Famille.create(label: 'Debian', description: 'Os de type debian')
Famille.create(label: 'Red hat', description: 'Os de type Red Hat')

