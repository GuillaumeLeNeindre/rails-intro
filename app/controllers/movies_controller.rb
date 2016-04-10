class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    do_redirect = false
    @all_ratings = Movie.all_ratings
    
    if params[:ratings] != nil
      @selected_ratings = params[:ratings]
      session[:ratings] = @selected_ratings
    elsif session[:ratings] != nil
      @selected_ratings = session[:ratings]
      do_redirect = true
    else
      @selected_ratings = {}
      @all_ratings.each do |current_rating|
        @selected_ratings[current_rating] = "1"
      end
      session[:ratings] = @selected_ratings
      do_redirect = true
    end
    
    if @selected_ratings != nil && !@selected_ratings.empty?
      sql_query = ""
      @selected_ratings.each_key do |selected_rating|
        sql_query = sql_query + %Q<rating = "#{selected_rating}" OR >
      end
      sql_query.gsub!(/ OR $/, "")
      @movies = Movie.where(sql_query)
    else
      @movies = Movie
    end
    
    @hilite_release_date = false
    @hilite_title = false
    
    if params[:sort] != nil
      sort = params[:sort]
      session[:sort] = sort
    elsif session[:sort] != nil
      sort = session[:sort]
      do_redirect = true
    end
    
    if sort != nil
      if sort == "title"
        @movies = @movies.order(:title)
        @hilite_title = true
      elsif sort == "release_date"
        @movies = @movies.order(:release_date)
        @hilite_release_date = true
      end 
    else
      @movies = @movies.all
    end
    if do_redirect
      flash.keep
      debugger
      redirect_to :controler => 'movies', :action => 'index', :ratings => session[:ratings], :sort => session[:sort]
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
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
