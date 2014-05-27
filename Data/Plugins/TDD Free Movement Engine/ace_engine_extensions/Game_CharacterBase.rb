if true

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * NEW Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :velocity_x               # Velocity on X axis
  attr_reader   :velocity_y               # Velocity on Y axis
  attr_reader   :acceleration
  attr_reader   :deceleration
  attr_reader   :max_velocity
  #--------------------------------------------------------------------------
  # * ALIAS Object Initialization
  #--------------------------------------------------------------------------
  alias_method :tdd_fme_original_game_character_base_initialize, :initialize
  def initialize
    tdd_fme_original_game_character_base_initialize
    @velocity_x = @velocity_y = 0.0
  end
  #--------------------------------------------------------------------------
  # * NEW FME Move
  #   Parameters:
  #     * d - 8 point direction
  #--------------------------------------------------------------------------
  def tdd_fme_update_move
    @x = $game_map.round_x_with_direction(@x, @direction)
    @y = $game_map.round_y_with_direction(@y, @direction)

    @real_x += @velocity_x
    @real_y += @velocity_y
  end

  def tdd_fme_move(d)
    dir_4 = dir_8_to_4(d)
    @move_succeed = passable?(@x, @y, dir_4)
    set_direction(dir_4)
    #return unless @move_succeed

    if [7,4,1].include?(d) # Left
      if @velocity_x <= 0
        @velocity_x -= acceleration
      elsif @velocity_x > 0
        @velocity_x -= acceleration/2
      end
      @velocity_x = -max_velocity if @velocity_x.abs > max_velocity
    end
    if [9,6,3].include?(d) # Right
      if @velocity_x >= 0
        @velocity_x += acceleration
      elsif @velocity_x < 0
        @velocity_x += acceleration/2
      end
      @velocity_x = max_velocity if @velocity_x > max_velocity
    end
    if [7,8,9].include?(d) # Up
      if @velocity_y <= 0
        @velocity_y -= acceleration
      elsif @velocity_y < 0
        @velocity_y -= acceleration/2
      end
      @velocity_y = -max_velocity if @velocity_y.abs > max_velocity
    end
    if [1,2,3].include?(d) # Down
      if @velocity_y >= 0
        @velocity_y += acceleration
      elsif @velocity_y < 0
        @velocity_y += acceleration/2
      end
      @velocity_y = max_velocity if @velocity_y > max_velocity
    end
  end

  def acceleration
    tdd_fme_timestep(@acceleration)
  end

  def deceleration
    tdd_fme_timestep(@deceleration)
  end

  def max_velocity
    tdd_fme_timestep(@max_velocity)
  end

  def tdd_fme_move_stop_horizontal
    if @velocity_x > 0
      @velocity_x -= deceleration
    elsif @velocity_x < 0
      @velocity_x += deceleration
    end
    @velocity_x = 0 if @velocity_x.abs < deceleration
  end

  def tdd_fme_move_stop_vertical
    if @velocity_y > 0
      @velocity_y -= deceleration
    elsif @velocity_y < 0
      @velocity_y += deceleration
    end
    @velocity_y = 0 if @velocity_y.abs < deceleration
  end

  def dir_8_to_4(d)
    return 8 if [7,8,9].include?(d)
    return 4 if [7,4,1].include?(d)
    return 2 if [1,2,3].include?(d)
    return 6 if [9,6,3].include?(d)
  end

  #--------------------------------------------------------------------------
  # * OVERRIDE Frame Update
  #--------------------------------------------------------------------------
  def update
    update_animation
    if tdd_use_fme?
      return tdd_fme_update_move
    else
      return update_jump if jumping?
      return update_move if moving?
      return update_stop
    end
  end

  #--------------------------------------------------------------------------
  # * OVERRIDE Determine if Moving
  #--------------------------------------------------------------------------
  def moving?
    if tdd_use_fme?
      Input.dir8 > 0
    else
      @real_x != @x || @real_y != @y
    end
  end

  #--------------------------------------------------------------------------
  # * NEW Check if FME is enabled
  #--------------------------------------------------------------------------
  def tdd_use_fme?
    false
  end

  #--------------------------------------------------------------------------
  # * NEW Convert Attribute Relative To Timestep
  #--------------------------------------------------------------------------
  def tdd_fme_timestep(attribute)
    attribute * $game_map.screen.timestep
  end
end

end