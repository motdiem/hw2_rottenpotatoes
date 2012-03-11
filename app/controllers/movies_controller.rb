class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @checked_ratings = {}
    @all_ratings =Movie.all_ratings
    if params[:ratings]
      chk_r = params[:ratings].keys
      @checked_ratings = params[:ratings]
    else
      chk_r = Movie.all_ratings
    end
    
    if params['sort']
      @movies = Movie.find_all_by_rating(chk_r,:order => params['sort'])
      flash[:sort]=params['sort']
    else
      @movies = Movie.find_all_by_rating(chk_r)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    #debugger
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
