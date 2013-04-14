TicTacToe::Application.routes.draw do
  root to: "games#new"
  resources :games, except: [:index, :edit, :destroy]
  match '/games/:id/move' => 'games#move', via: [:post]
end
