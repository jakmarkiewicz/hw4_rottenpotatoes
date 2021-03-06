require 'spec_helper'

describe MoviesController do

	before :each do
		@fakeMovie = mock(Movie, :title => "Star Wars", :director => "George Lucas", :id => "1")
	    @fakeMovies = [mock('Movie1'), mock('Movie2')]
	end

	describe 'create/destory/edit a movie' do
	    it 'should create a new movie' do
		    MoviesController.stub(:create).and_return(@fakeMovie)
		    post :create, {:id => "1"}
	    end
		it 'should destroy a movie' do
		    Movie.stub(:find).with("1").and_return(@fakeMovie)
		    @fakeMovie.should_receive(:destroy)
		    delete :destroy, {:id => "1"}
	    end
		it 'should edit a movie' do
		    Movie.stub(:find).with("1").and_return(@fakeMovie)
		    get :edit, {:id => "1"}
		    response.should render_template 'edit'
	    end
	    it 'should show a movie' do
		    Movie.stub(:find).with("1").and_return(@fakeMovie)
		    get :show, {:id => "1"}
		    response.should render_template 'show'
	    end
	    it 'should sort movies by title' do
		    Movie.stub(:find).and_return(@fakeMovie)
			Movie.stub(:find_all_by_director).and_return(@fakeMovies)
		    get :index, {:id => "1", :sort => "title", :ratings => "PG"}
	    end
	    it 'should sort movies by release date' do
	    	Movie.stub(:find).and_return(@fakeMovie)
			Movie.stub(:find_all_by_director).and_return(@fakeMovies)
		    get :index, {:id => "1", :sort => "release_date", :ratings => {}}
		end
		it "should index all movies" do
		    Movie.stub(:all) { [@fakeMovie] }
		    get :index
		    response.should render_template 'index'
    	end
	end

	describe 'update movie director info' do
		before :each do
			Movie.should_receive(:find).with("1").and_return(@fakeMovie)
			@fakeMovie.should_receive(:update_attributes!).exactly 1
			put :update, {:id => "1", :movie => @fakeMovie}
		end
		it 'should call the method that updates the movie' do
			true
		end
		it 'should redirect to the details page' do
			response.should redirect_to(movie_path(@fakeMovie))
		end

	end


	describe 'happy path for finding movies by same director' do
	    it 'should generate route path to similar movies' do
	        { :get => similar_movie_path(1) }.
	        should route_to(:controller => "movies", :action => "similar", :id => "1")
	    end

	    it 'should call movies controller similar method that finds similar movies' do
	        Movie.should_receive(:find).with("1").and_return(@fakeMovie)
	        Movie.should_receive(:find_all_by_director).with(@fakeMovie.director).and_return(@fakeMovies)
	        get :similar, {:id => "1"}
	        response.should render_template 'movies/similar'
	        assigns(:movies).should == @fakeMovies
    	end
		it 'should call Model method to get movies with same director' do
			Movie.should_receive(:find).with("1").and_return(@fakeMovie)
			Movie.should_receive(:find_all_by_director).and_return(@fakeMovies)
			get :similar, {:id => "1"}
		end

  	end

  	describe 'sad path for finding movies by same director' do
	    before :each do
	        @fakeMovie = mock(Movie, :title => "Star Wars", :director => nil, :id => "1")
	        Movie.stub!(:find).with("1").and_return(@fakeMovie)
	    end
	    
	    it 'should generate route path to similar movies' do
	        { :get => similar_movie_path(1) }.
	        should route_to(:controller => "movies", :action => "similar", :id => "1")
	    end

	    it 'should redirect to index page and display flash' do
	    	Movie.stub(:find).and_return(@fakeMovie)
			Movie.stub(:find_all_by_director)
			get :similar, {:id => "1"}
			response.should redirect_to(movies_path)
			flash[:notice].should_not be_blank
    	end
  	end
end
