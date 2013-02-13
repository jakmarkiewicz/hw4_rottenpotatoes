# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  assert movies_table.hashes.size == Movie.all.count
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie, director|
	assert page.body.match(director).to_s == director
end