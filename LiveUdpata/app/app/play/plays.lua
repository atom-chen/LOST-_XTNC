

local player = class("player", function()
	return display.newNode()
end)

function player:ctor(play)
 	-- body
    --玩家头像
 	self.playpicture = play.Picture
    --playID
    self.playID = play.ID
    --玩家游戏币
    self.playGold = play.Gold

end


return player 