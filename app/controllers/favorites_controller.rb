class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie
  def create
    @movie.fans << current_user
    redirect_to @movie
  end

  def destroy
    fave = current_user.favorites.find(params[:id])
    fave.destroy
    redirect_to @movie
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end
