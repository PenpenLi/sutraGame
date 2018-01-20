local Card = class("Card", cocosMake.Node)
Card.value = 0
Card.color = 0

local value2number={}
value2number[1]="3"
value2number[2]="4"
value2number[3]="5"
value2number[4]="6"
value2number[5]="7"
value2number[6]="8"
value2number[7]="9"
value2number[8]="10"
value2number[9]="j"
value2number[10]="q"
value2number[11]="k"
value2number[12]="a"
value2number[13]="2"
value2number[14]="w"
value2number[15]="ww"

local color2huase={}
color2huase[1]="meihua"
color2huase[2]="fangkuai"
color2huase[3]="hongtao"
color2huase[4]="heitao"
color2huase[5]="heitao"

function Card:ctor(param)
    
	self.value = param.value
	self.color = param.color
	self.beClick = false
	
	local number = value2number[self.value]
	local huase = color2huase[self.color]
	local cardtype = param.cardtype == 1 and "1" or "1_bg"
	--param.cardtype
	local card = ccui.ImageView:create("ui/card/card" .. cardtype .. ".png")
	card:setAnchorPoint(cc.p(0, 0))
	self.card = card
	self:addChild(card)
	
	if param.cardtype ~= 1 then
		return
	end
	
	local cardsize = card:getContentSize()	
	local number_offsetx = 5.0
	local number_offsety = 5.0
	local number_lt = cocosMake.newSprite("ui/card/" .. number .. ".png", 0, 0)
	number_lt:setAnchorPoint(cc.p(0.0, 1.0))
	number_lt:setPosition(cc.p(number_offsetx, cardsize.height - number_offsety))
	card:addChild(number_lt)
	
	local number_rb = cocosMake.newSprite("ui/card/" .. number .. ".png", 0, 0)
	number_rb:setAnchorPoint(cc.p(1.0, 0.0))
	number_rb:setPosition(cc.p(cardsize.width - number_offsetx, number_offsety))
	card:addChild(number_rb)
	
	if number ~= "w" and number ~= "ww" then
		local huase_offsetx = 3.0
		local huase_offsety = 40.0
		local huase_lt = cocosMake.newSprite("ui/card/" .. huase .. ".png", 0, 0)
		huase_lt:setAnchorPoint(cc.p(0.0, 1.0))
		huase_lt:setPosition(cc.p(huase_offsetx, cardsize.height - huase_offsety))
		card:addChild(huase_lt)
		
		local huase_rb = cocosMake.newSprite("ui/card/" .. huase .. ".png", 0, 0)
		huase_rb:setAnchorPoint(cc.p(1.0, 0.0))
		huase_rb:setPosition(cc.p(cardsize.width - huase_offsetx, huase_offsety))
		card:addChild(huase_rb)
	end
	card:setTouchEnabled(true)
	card:addTouchEventListener(function(sender, state)
        if state == 0 then
        elseif state == 1 then
        elseif state == 2 then
            self.beClick = not self.beClick
			card:setPositionY(card:getPositionY() + (self.beClick and 50 or -50))
			if self.clickCallback then self.clickCallback(self.value, self.color, self.beClick) end
        end
    end)
	
	
end

function Card:setClickCallback(f)
	self.clickCallback = f
end
function Card:setTouchEnable(b)
	self.card:setTouchEnabled(b)
	
	if not b then
		self.card:setPositionY(self.card:getPositionY() + (self.beClick and -50 or 0))
		self.beClick = b
	end
end
function Card:isSelect()
	return self.beClick
end
function Card:getValueColor()
	return self.value, self.color
end
--------------------------------------------------------------------------------------------------------------------
return Card

