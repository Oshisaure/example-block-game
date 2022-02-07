--[[
    What the fuck am I doing here? I'm not like the rest of the comments, I swear! -MarkGamed7794 2021
]]

HighScores = {}

function LoadHighScores()
    HighScores = {}
    local scoremachinebroke = false
    if love.filesystem.getInfo("highscores.sav") then
        local currentMode = ""
        for line in love.filesystem.lines("highscores.sav") do
            local header = line:match("%[(.+)%]")
            if header then
                currentMode = header
                HighScores[currentMode] = {}
            else
                local score, clearScore, lines, startlevel, stoplevel, time, clearTime = line:match("(.+),(.+),(.+),(.+),(.+),(.+),(.+)")
                if startlevel and score and lines and stoplevel then
                    table.insert(HighScores[currentMode],{
                        ["startLevel"] = tonumber(startlevel),
                        ["score"]      = score,
                        ["lines"]      = lines,
                        ["finalLevel"] = tonumber(stoplevel),
                        ["clearScore"] = clearScore ~= "none" and clearScore,
                        ["time"]       = tonumber(time),
                        ["clearTime"]  = clearTime ~= "none" and tonumber(clearTime)
                    })
                elseif #line > 0 then
                    scoremachinebroke = true
                end
            end
		end
    else scoremachinebroke = true end
    if scoremachinebroke then
        print("Nevermind, it broke, resetting high scores to default!")
        -- make some default high scores
        for _, mode in pairs(Levels) do
            HighScores[mode.name] = {}
        end
        SaveHighScores()
    end
end

function SaveHighScores()
    local str = ""
    for mode, scores in pairs(HighScores) do
        --first things first, we have to sort them by score, of course!
        table.sort(HighScores[mode], function(a, b) return tonumber(a.score) > tonumber(b.score) end)
        local modeStr = "["..mode.."]\n"
        for i=1, #HighScores[mode] do
            local score = HighScores[mode][i]
            local scoreStr = score.score .. "," ..
                             (score.clearScore or "none") .. "," ..
                             score.lines .. "," ..
                             score.startLevel .. "," ..
                             score.finalLevel .. "," ..
                             score.time .. "," ..
                             (score.clearTime or "none")
                             
                             
            modeStr = modeStr .. scoreStr .. "\n"
        end
        str = str .. modeStr .."\n"
    end
    local success, message = love.filesystem.write("highscores.sav", str:sub(1,-2))
end

LoadHighScores()