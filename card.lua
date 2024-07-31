local extension = Package:new("card")
extension.extensionName = "tj55zx"

Fk:loadTranslationTable{
  ["tj55zx"] = "五十五中",
}

local school = General:new(extension, "sb__school", "god", 5)
--嫁祸 实现1

-- 嫁祸 主技能
local sb__jiahuo=fk.CreateTriggerSkill{
  name = "sb__jiahuo",
  anim_type = "defensive",
  events={fk.TargetConfirming,},
  can_trigger = function(self, event, target, player, data)
    local ret = target == player and player:hasSkill(self) 
    if ret then
      local room = player.room
      local from = room:getPlayerById(data.from)
      for _, p in ipairs(room.alive_players) do
        if p ~= player and p.id ~= data.from and not from:isProhibited(p, data.card) then
          if data.card.trueName=="slash" then
            return true
          elseif data.card.trueName=="snatch" or data.card.trueName== "dismantlement" then
            if p.player_cards[1] ~= {} and p.player_cards[2] ~= {} and p.player_cards[3] ~= {} then
              return true
            end
          end
        
          
        end
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    

    local room = player.room
    local prompt = "#sb__jiahuo-target"
    local targets = {}
    local from = room:getPlayerById(data.from)
    for _, p in ipairs(room.alive_players) do
      if from == nil then
        return true
      end
      if p ~= player and p.id ~= data.from and not from:isProhibited(p, data.card) then
        table.insert(targets, p.id)
      end
    end
    if #targets == 0 then return false end
    local plist, cid = room:askForChooseCardAndPlayers(player, targets, 1, 1, nil, prompt, self.name, true)
    if #plist > 0 then
      self.cost_data = {plist[1], cid}
      return true
    end
    return false
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = self.cost_data[1]
    room:doIndicate(player.id, { to })
    AimGroup:cancelTarget(data, player.id)
    AimGroup:addTargets(room, data, to)

    -- print("MarkNames:"..player:getMarkNames())
    player:addMark("@yulun",1)

    -- local times=player:usedSkillTimes("sb__jiahuo")
    -- if times == 3 then
      
    -- end

    if player:getMark("@yulun")>=8 and player.hp ~= 0 then
      player.hp=0
    end
  end,
}

-- 此处以下是废稿 --
-- local sb__jiahuoBanPeach =fk.CreateTriggerSkill{
--   name = "#sb__jiahuoBanPeach",
--   anim_type="offensive",
--   events={"AskForCardUse"},
--   can_trigger =  function(self, event, target, player, data)
--     if player:hasSkill(self) then
--       print("触发banpeach")
--     else
--       print("没触发banpeach")
--     end
--     return player:hasSkill(self);
--   end,
--   on_use = function(self, event, target, player, data)
--     print("阿松大好读书")
--      if event==fk.AskForCardUse then
--      print(11111)
--      print(player:usedSkillTimes(self))
--      if data.card~= nil and data.card.trueName=="peach" then
--         print(22222)
--         if player:usedSkillTimes(self)>2 then
--           print(player:usedSkillTimes(self))
--           event.result=false
--           return true
--         end


--       else
--         print(data.card~= nil)
--       end
--     end
--   end,
-- }
-- sb__jiahuo:addRelatedSkill(sb__jiahuoBanPeach)
-- 废稿到此截止 --

-- 嫁祸 舆论>=4 副技能
local sb__jiahuoAudio = fk.CreateTriggerSkill{
  name = "sb__jiahuoAudio",
  anim_type = "defensive",
  events={fk.TargetConfirming,},
  can_trigger = function(self, event, target, player, data)
    print( "player:getMark(@yulun)".. player:getMark("@yulun"))
    if player:hasSkill(self) and player:getMark("@yulun") > 3 and data.to==player.id and data.card.trueName=="slash" then return true end
    return false
  end,
  on_use = function(self, event, target, player, data)
    data.damageDealt=player:getMark("@yulun")-2
  end,
}
sb__jiahuo:addRelatedSkill(sb__jiahuoAudio)

school:addSkill(sb__jiahuo)
Fk:loadTranslationTable{
    ["sb__school"] = "五十五中",
    ["#sb__school"] = "低进高出",
    ["designer:sb__school"] = "sb",
    ["cv:sb__school"] = "田所浩二",
    ["illustrator:sb__school"] = "天津市政府",
    ["sb__jiahuo"]="嫁祸",
    [":sb__jiahuo"]="当你成为任意牌的目标时，你可以将一名角色作为此牌的目标，同时你获得一颗【舆论】标记。当【舆论】数量大于等于4时，每张杀对你造成X-2点伤害（X为你手中【舆论】的数量。当【舆论】数量大于等于8时，你直接被杀死。",
    ["#sb__jiahuo-target"]="选择一名角色作为你转移伤害的对象。同时选择一张牌，这张牌不会有任何效果（扣除或使用）。"
  }


return extension