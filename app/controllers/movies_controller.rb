class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings =Movie.all_ratings
    @checked_ratings = {}
    @sort_order= nil
    do_redirect = false;
    # check if we have values in the session that are missing from params
    params_to_check = [:ratings , :sort] 
    params_values = {:ratings => @all_ratings , :sort => @sort_order} 
    params_to_check.each do |param|
      if params.has_key?(param)
        session[param] = params[param]
      elsif session.has_key?(param)
          p = session[param]
          unless p.length == 0 
            params[param] = session[param]
            do_redirect = true
          end
      end
    end
    if do_redirect
      s = params[:sort]
      r = params[:ratings]
      redirect_to movies_path({:sort => params[:sort],:ratings => params[:ratings]} )
    end
    if params[:sort]
      @sort_order = params[:sort]
    end
    chk_r = @all_ratings
    if params[:ratings]
      chk_r = params[:ratings].keys
      @checked_ratings = params[:ratings]
    end

    # Store the values in the session
    session[:sort] = @sort_order
    session[:ratings] = @checked_ratings
    
      @movies = Movie.find_all_by_rating(chk_r, :order => @sort_order)
      flash[:sort]=params[:sort]
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
