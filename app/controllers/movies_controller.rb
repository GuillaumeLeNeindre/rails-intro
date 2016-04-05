class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    
     
    @selected_ratings = params[:ratings]
    if @selected_ratings == nil
      @selected_ratings = {}
      @all_ratings.each do |current_rating|
        @selected_ratings[current_rating] = "1"
      end
      @selected_ratings
    end
    if @selected_ratings != nil && !@selected_ratings.empty?
      index = 0
      sql_query = ""
      @selected_ratings.each_key do |selected_rating|
        index = index + 1
        sql_query = sql_query + %Q<rating = "#{selected_rating}" OR >
      end
      sql_query.gsub!(/ OR $/, "")
      @movies = Movie.where(sql_query)
    else
      @movies = Movie
    end
    
    @hilite_release_date = false
    @hilite_title = false
    
    sort = params[:sort]
    
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
