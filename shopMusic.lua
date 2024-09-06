-- Find the peripherals
local speaker = peripheral.wrap("left") -- Speaker on the left side
local playerDetector = peripheral.wrap("right") -- Player detector on the right side
local dfpwm = require("cc.audio.dfpwm")

if speaker == nil then
  print("No speaker found on the left!")
  return
end

if playerDetector == nil then
  print("No player detector found on the right!")
  return
end

-- Define the area boundaries
local xMin, xMax = 199, 207
local zMin, zMax = 1373, 1377
local yLevel = 81

-- Function to check if any player is in the area
local function isPlayerInArea()
  -- Get a list of all players detected
  local players = playerDetector.getPlayersInRange(100) -- Adjust range as needed

  for _, player in ipairs(players) do
    print("player found" .. player)
    local pos = playerDetector.getPlayerPos(player)
    -- Check if the player is within the defined coordinates
    print(player .. " location X:" .. pos.x .. " Y:" .. pos.y .. " Z:" .. pos.z )
    if pos.x >= xMin and pos.x <= xMax and pos.z >= zMin and pos.z <= zMax and pos.y == yLevel then
        print("Player in range")
        return true
    end
  end
  return false
end

-- Main loop
local musicPlaying = false

while true do
  if isPlayerInArea() then
    if not musicPlaying then
      -- If no music is playing, start playing it
      speaker play "https://raw.githubusercontent.com/OdysseyScorpio/ccMusic/master/Coffee_Shop.dfpwm" -- You can change the sound to another one
      
      musicPlaying = true
      print("Player detected! Music playing...")
    end
  else
    if musicPlaying then
      -- If no players are in the area, stop the music
      speaker.stop()
      musicPlaying = false
      print("No players in the area. Music stopped.")
    end
  end
  
  -- Wait for a short interval before checking again
  sleep(1) -- Adjust the sleep time as needed
end
