module FavoritesHelper
  def fave_or_un_fave_button(movie, fave)
    if fave
    button_to "♡ Unfave", movie_favorite_path(movie, fave), method: :delete
       else
          button_to "♥️ Fave", movie_favorites_path(movie)
    end
  end
end
