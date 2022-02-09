HighScores = {}

function LoadHighScores()
    HighScores = {}
    local no_scores_file = false
    if love.filesystem.getInfo("highscores.sav") then
        local current_mode = ""
        for line in love.filesystem.lines("highscores.sav") do
            local header = line:match("%[(.+)%]")
            if header then
                current_mode             = header
                HighScores[current_mode] = {}
            else
                local score, clear_score, lines, start_level, stop_level, time, clear_time = line:match("(.+),(.+),(.+),(.+),(.+),(.+),(.+)")
                if start_level and score and lines and stop_level then
                    table.insert(HighScores[current_mode],{
                        ["start_level"] = tonumber(start_level),
                        ["score"]      = score,
                        ["lines"]      = lines,
                        ["final_level"] = tonumber(stop_level),
                        ["clear_score"] = clear_score ~= "none" and clear_score,
                        ["time"]       = tonumber(time),
                        ["clear_time"]  = clear_time ~= "none" and tonumber(clear_time)
                    })
                elseif #line > 0 then
                    no_scores_file = true
                end
            end
		end
    else
        no_scores_file = true
    end

    if no_scores_file then
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
    for mode_id, _ in pairs(HighScores) do
        --first things first, we have to sort them by score, of course!
        table.sort(HighScores[mode_id], function(a, b) return tonumber(a.score) > tonumber(b.score) end)

        local mode_str = ("[%s]\n"):format(mode_id)
        for _, score in ipairs(HighScores[mode_id]) do
            local score_str = ("%s,%s,%s,%s,%s,%s,%s"):format(
                score.score, score.clear_score or "none", score.lines,
                score.start_level, score.final_level, score.time,
                score.clear_time or "none"
            )
            mode_str = mode_str..score_str.."\n"
        end
        str = str..mode_str.."\n"
    end
    local success, message = love.filesystem.write("highscores.sav", str:sub(1,-2))
end

LoadHighScores()