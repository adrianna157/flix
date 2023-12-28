class GenresController < ApplicationController
  before_action :set_genre
  before_action :get_genres
  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to new_genre_path
    else
      render :new
    end
  end

  def destroy
    @genre.destroy
    redirect_to new_genre_path
  end

  def update
    if @genre.update(genre_params)
      redirect_to new_genre_path
    else
      render :new
    end
  end

  def edit
  end

  private
  def genre_params
    params.require(:genre)
          .permit(:name)
  end

  def set_genre
    @genre = Genre.find(params[:id]) if params[:id]
  end
  def get_genres
    @genres = Genre.all
  end
end
