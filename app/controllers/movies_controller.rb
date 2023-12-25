class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find(params[:id])
    @review = @movie.reviews.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
    # redirect_to movie_path(@movie) to redirect to the show page
    redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save

    # redirect_to movie_path(@movie) to redirect to the show page
    redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    # redirect_to movies_path to redirect to the index page (note the pluralization)
    # see other is an alias for 303
    redirect_to movies_url, status: :see_other, danger: "I'm sorry, I'm afraid I can't do that!"
  end

  private

  def movie_params
    params.require(:movie)
      .permit(:title, :description, :rating, :released_on, :total_gross, :director, :duration, :image_file_name)
  end

end

