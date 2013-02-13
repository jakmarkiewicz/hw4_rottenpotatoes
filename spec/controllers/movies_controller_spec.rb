require 'spec_helper'

describe MoviesController do

	describe 'happy path' do
	    before :each do
	      @fakeMovie = mock(Movie, :title => "Star Wars", :director => "George Lucas", :id => "1")
	      @fakeMovies = [mock('Movie1'), mock('Movie2')]
	    end
	    
	    it 'should generate route path to similar movies' do
	      { :get => similar_movie_path(1) }.
	      should route_to(:controller => "movies", :action => "similar", :id => "1")
	    end

	    it 'should call movies controller similar method that finds similar movies' do
	      Movie.should_receive(:find).with("1").and_return(@fakeMovie)
	      Movie.should_receive(:find_all_by_director).with(@fakeMovie.director).and_return(@fakeMovies)
	      get :similar, {:id => "1"}
    	end
  	end
end
