# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Group.create([ {name: 'A'}, {name: 'B'}, {name: 'C'}, {name: 'D'}, {name: 'E'}, {name: 'F'}])

Team.create(country: 'Frankrike', group_id: 1, abbreviation: 'FRA')
Team.create(country: 'Rumänien', group_id: 1, abbreviation: 'ROM')

Game.create(home_id: 1, away_id: 2, final: false, home_score: 0, away_score: 0, group_id: 1, kickoff: '2016-06-10')
