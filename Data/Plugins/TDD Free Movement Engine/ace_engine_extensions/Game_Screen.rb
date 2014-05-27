if true

class Game_Screen
  attr_reader :previous_frame_update_timestamp
  attr_reader :time_elapsed_in_miliseconds
  attr_reader :timestep
  #--------------------------------------------------------------------------
  # * ALIAS Object Initialization
  #--------------------------------------------------------------------------
  alias_method :tdd_fme_original_initialize, :initialize
  def initialize
    @timestep = 0
    tdd_fme_original_initialize
  end
  #--------------------------------------------------------------------------
  # * ALIAS Frame Update
  #--------------------------------------------------------------------------
  alias_method :tdd_fme_original_update, :update
  def update
    update_timestep
    tdd_fme_original_update
  end

  #--------------------------------------------------------------------------
  # * NEW Update Timestep
  #--------------------------------------------------------------------------
  def update_timestep
    if @previous_frame_update_timestamp
      @time_elapsed_in_miliseconds = Time.now.to_ms - @previous_frame_update_timestamp
      @timestep = @time_elapsed_in_miliseconds / 1000.0
    end
    @previous_frame_update_timestamp = Time.now.to_ms
  end
end

end