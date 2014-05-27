############################################################
#
#  Name:        Sean Glover
#  Assignment:  Simple Classes - DVD Assignment
#  Date:        04/22/2013
#  Class:       CIS 283
#  Description: Simulate operation of DVD player
#
############################################################

class Dvd
  @@max_time = 7200 # maximum time of 2 hours
  @@no_disc = "Disc is not inserted" # default message when disc not inserted
  attr_writer :action_time

  def initialize()
    @play_time = 0        # seconds
    @inserted = false     # boolean
    @status = "No Disc"   # current status (play, stop)
    @play = false         # boolean
    @start_time = 0       # time
    @stop_time = 0        # time
    @action_time = 0      # time of action (FF, Rew, Status)
  end

  # check if disc is inserted and return default message when not
  def inserted
    if !@inserted
      return @@no_disc
    end
  end

  # check if disc is currently playing and set play time based on previous actions (FF, Rew, Status)
  def check_play
    if @play
      current_time = Time.now.to_i

      if @play_time == 0 && @action_time == 0
        @play_time += current_time - @start_time
        self.action_time = current_time

      else
        @play_time += current_time - @action_time
        self.action_time = current_time
      end
    end
  end

  # return prompt to user for fast forward or rewind time in seconds.
  def rew_ff_disc(direction)
    if self.inserted != @@no_disc
      return "Enter number of seconds to #{direction}:"

    else # return default message when disc not inserted
      return self.inserted
    end
  end

  # method to insert disc in player
  def insert_disk
    if !@inserted # check that @inserted == false
      @inserted = true
      @status = "Stopped"
      return "Disc Inserted."

    else # message when disc is already inserted
      return "Disc is already inserted."
    end
  end

  # method to eject disc from player
  def eject_disk
    if self.inserted != @@no_disc
      @inserted = false
      @play_time = 0
      @status = "No Disc"
      @start_time = 0
      @stop_time = 0
      @action_time = 0
      return "Disc Ejected."

    else # message when no disc is inserted
      return self.inserted
    end
  end

  # method to play disc
  def play_disk
    if self.inserted != @@no_disc

      if !@play && @play_time < @@max_time
        @status = "Playing"
        @play = true
        @start_time = Time.now.to_i
        return "Playing"

      else # message when disc is already playing
        return "Disc already playing."
      end

    else # default message when no disc inserted
      return self.inserted
    end
  end

  # method to stop disc
  def stop_disk
    if self.inserted != @@no_disc

      if @play
        @status = "Stopped"
        @play = false
        @stop_time = Time.now.to_i
        @play_time += @stop_time - @start_time
        return "Play stopped."

      else # message when disc is not playing
        return "Disc is not playing."
      end

    else # default message when no disc inserted
      return self.inserted
    end
  end

  # display current disc status
  def status
    self.check_play

    # condition when play time has reached max time
    if @play_time >= @@max_time
      @play_time = @@max_time
      @status = "Stopped"
      @play = false
    end

    # return status report
    return "Disc Status:\nInserted: #{@inserted.to_s.capitalize.rjust(20)}\nCurrent Position: #{Time.at(@play_time).gmtime.strftime('%R:%S').rjust(12)}\nPlay Status: #{@status.rjust(17)}"
  end

  # method to rewind disc from current position
  def rewind(seconds)
    if self.inserted != @@no_disc
      self.check_play
      @play_time -= seconds

      if @play_time > 0
        return "Rewind disc to #{@play_time}."

      else
        @play_time = 0
        return "Rewind to start of disc."
      end

    else # default message when disc not inserted
      return self.inserted
    end
  end

  # method to fast forward disc from current position
  def fast_forward(seconds)
    if self.inserted != @@no_disc
      self.check_play
      @play_time += seconds

      if @play_time <= @@max_time
        return "Fast Forward disc to #{@play_time}."

      else
        @play_time = @@max_time
        return "Fast Forward to end of disc."
      end

    else # default message when disc not inserted
      return self.inserted
    end
  end
end

# method to display menu until user quits
def menu
  puts
  puts "1) Insert Disk"
  puts "2) Play Disk"
  puts "3) Rewind Disk"
  puts "4) Fast Forward Disk"
  puts "5) Stop Disk"
  puts "6) Eject Disk"
  puts "7) Show Current Disk Status"
  puts "8) Quit"
end


dvd_disk = Dvd.new()
user_option = 0
until user_option == 8
  menu
  user_option = gets.to_i

  if user_option == 1 # insert disc
    puts dvd_disk.insert_disk

  elsif user_option == 2 # play disc
    puts dvd_disk.play_disk

  elsif user_option == 3 # rewind disc
    check_rewind = dvd_disk.rew_ff_disc("Rewind")

    puts check_rewind
    if /Enter/.match(check_rewind)
      rew = gets.to_i

      if rew > 0
        puts dvd_disk.rewind(rew)
      else
        puts "That is not a valid entry."
      end
    end

  elsif user_option == 4 # fast forward disc
    check_fast = dvd_disk.rew_ff_disc("Fast Forward")

    puts check_fast
    if /Enter/.match(check_fast)
      ff = gets.to_i

      if ff > 0
        puts dvd_disk.fast_forward(ff)
      else
        puts "That is not a valid entry."
      end
    end

  elsif user_option == 5 # stop disc
    puts dvd_disk.stop_disk

  elsif user_option == 6 # eject disc
    puts dvd_disk.eject_disk

  elsif user_option == 7 # print report (status)
    puts dvd_disk.status

  elsif user_option != 8 # error condition
    puts "That is not a valid option"
  end
end
