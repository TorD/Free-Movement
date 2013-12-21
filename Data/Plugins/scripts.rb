
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * OVERWRITE Frame Update
  #--------------------------------------------------------------------------
  def update
    update_animation
    return update_jump if jumping?
    update_move
    update_stop
  end

  def update_move
    @real_y += 1 if passable?(@real_x, @real_y, 8)
  end
end
class Game_Player
  alias_method :tdd_platform_engine_game_player_update, :update
  def update
    tdd_platform_engine_game_player_update
  end
end
