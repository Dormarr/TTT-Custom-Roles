-- This doesn't work.

hook.Add("PreDrawOutlines", "KarenVisibility", function()
    local localPlayer = LocalPlayer()
    if not IsValid(localPlayer) or not localPlayer:IsDetectiveLike() then return end
    
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetRole() == ROLE_KAREN then
            outline.Add(ply, Color(255, 105, 180), OUTLINE_MODE_VISIBLE)
        end
    end
end)