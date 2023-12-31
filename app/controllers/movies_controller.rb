class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @fave = current_user.favorites.find_by(movie_id: @movie.id) if current_user
    @genres = @movie.genres
  end

  def edit
  end

  def update
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
    @movie.destroy
    # redirect_to movies_path to redirect to the index page (note the pluralization)
    # see other is an alias for 303
    redirect_to movies_url, status: :see_other, danger: "I'm sorry, I'm afraid I can't do that!"
  end

  private

  def movie_params
    params.require(:movie)
      .permit(:title, :description, :rating, :released_on, :total_gross, :director, :duration, :main_image, genre_ids: [])
  end

  def movies_filter
    if params[:filter].in? %w(upcoming recent hits flops)
      params[:filter]
    else
      :released
    end
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

end

