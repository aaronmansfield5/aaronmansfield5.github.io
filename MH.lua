_G.MH = {
    doRebirth = false,
    rbLayout = 'Layout1',
    useWebhooks = false,
    doCrates = false,
    webhooks = {
        rebirth = nil,
        item = nil
    }
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Yellow's Haven",
    LoadingTitle = "Yellow's Haven",
    LoadingSubtitle = "by YellowTripleG",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "Yellow's Hub",
       FileName = "MH"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false
})

local HomeTab = Window:CreateTab("Home", 5506574548)
local RebirthTab = Window:CreateTab("Rebirth", 5506488860)

local RebirthSection1 = RebirthTab:CreateSection("Rebirth Automation")
local RebirthToggle = RebirthTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "doRebirth",
    Callback = function(Value)
        _G.MH.doRebirth = Value
    end,
})
local Dropdown = RebirthTab:CreateDropdown({
    Name = "Auto Layout",
    Options = {"Layout1","Layout2", "Layout3"},
    CurrentOption = {"Layout1"},
    MultipleOptions = false,
    Flag = "rbLayout",
    Callback = function(Option)
        _G.MH.rbLayout = Option[1]
    end,
})

local RebirthSection2 = RebirthTab:CreateSection("Rebirth Settings")
local RebirthNotify = RebirthTab:CreateToggle({
    Name = "Use Webhooks",
    CurrentValue = false,
    Flag = "doRebirth",
    Callback = function(Value)
        _G.MH.useWebhooks = Value
    end,
})
local RebirthWH = RebirthTab:CreateInput({
    Name = "Rebirth Webhook",
    PlaceholderText = "Discord Webhook",
    RemoveTextAfterFocusLost = false,
    Flag = "rebirthWH",
    Callback = function(Text)
        _G.MH.webhooks.rebirth = Text
    end,
})
local ItemWH = RebirthTab:CreateInput({
    Name = "Item Webhook",
    PlaceholderText = "Discord Webhook",
    RemoveTextAfterFocusLost = false,
    Flag = "itemWH",
    Callback = function(Text)
        _G.MH.webhooks.item = Text
    end,
})

local BoxesTab = Window:CreateTab("Boxes", 5140907803)
local BoxesSection1 = BoxesTab:CreateSection("Box Automation")
local CratesToggle = BoxesTab:CreateToggle({
    Name = "Collect Crates",
    CurrentValue = false,
    Flag = "doCrates",
    Callback = function(Value)
        _G.MH.doCrates = Value
        if not Value then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.PlayerTycoon.Value.Base.CFrame
        end
    end,
})

local PlayerTab = Window:CreateTab("Player", 5506279557)
local DeleteButton = PlayerTab:CreateButton({
    Name = "Delete Rayfield",
    Callback = function()
        Rayfield:Destroy()
    end,
})

game.ReplicatedStorage.MoneyMirror:FindFirstChild(game.Players.LocalPlayer.Name).Changed:Connect(function(newVal)
	skips = game.Players.LocalPlayer.PlayerGui.Rebirth.Frame.Rebirth_Content.Content.Rebirth.Frame.Top.SkipBox.Label
    if(_G.MH.doRebirth and skips.Parent.Visible == true) then
        money = newVal --require(game.ReplicatedStorage.MoneyLib).HandleMoney(newVal)
		local args = {
			[1] = 26
		}

		game:GetService("ReplicatedStorage"):WaitForChild("Rebirth"):InvokeServer(unpack(args))
		wait(1.5)
        game.ReplicatedStorage.Layouts:InvokeServer("Load", _G.MH.rbLayout)
        if _G.MH.useWebhooks and _G.MH.webhooks.rebirth then
            for i,v in game:GetService("CoreGui").ExperienceChat.appLayout.chatWindow.scrollingView.bottomLockedScrollView.RCTScrollView.RCTScrollContentView:GetChildren() do
                plrlife = game.Players.LocalPlayer.Rebirths.Value + 1 --require(game.ReplicatedStorage.MoneyLib).HandleLife(game.Players.LocalPlayer.Rebirths.Value + 1)
                if(v:FindFirstChild("TextLabel")) then
                    txt = v.TextLabel.TextMessage
                    if(txt.ContentText:match(game.Players.LocalPlayer.DisplayName) and txt.ContentText:match("was born into their") and not txt:FindFirstChild("Posted")) then
                        timeIn = string.split(string.split(txt.ContentText, " in ")[2], " (")[1]
                        wait()
                        rbSend = "You've rebirthed into life **S+"..plrlife.."** with **$"..money.."** in **"..timeIn.."**!"
                        WebHook = _G.MH.webhooks.rebirth
                        request({
                            Url = WebHook,
                            Method = "POST",
                            Headers = {
                                ["Content-Type"] = "application/json"
                            },
                            Body = game.HttpService:JSONEncode({
                                embeds = {{
                                    title = "Rebirth",
                                    description = rbSend,
                                     author = {
                                        name = "Rebirth Tracker",
                                        icon_url = "https://pbs.twimg.com/profile_images/1392664665516171275/LNC_H6fs_400x400.jpg"
                                    },
                                    footer = {
                                        text = game.Players.LocalPlayer.Name,
                                        icon_url = "https://tr.rbxcdn.com/c33870b88e37558299bf25640ea5f1c0/150/150/AvatarHeadshot/Png"
                                    }
                                }}
                            })
                        })
                        local saved = Instance.new("BoolValue")
                        saved.Name = "Posted"
                        saved.Parent = txt
                    end
                end
            end
        end
	end
end)

game.Players.LocalPlayer.PlayerGui.GUI.Notifications.ChildAdded:Connect(function(Item)
    if(_G.MH.doRebirth and _G.MH.webhooks.item and _G.MH.useWebhooks) then
        if Item:IsA("Frame") and Item:FindFirstChild("Tier") and (Item.Tier.Text:match("Reborn") or Item.Tier.Text:match("Ultimate") or Item.Tier.Text:match("Shiny") or Item.Tier.Text:match("Superstitious")) then
            local tier = Item.Tier.Text
            local name = Item.Title.Text
            local color = Item.BackgroundColor3
            local amount = Item.Icon.Amount.Text
            local quantity = game.ReplicatedStorage.FetchInventory:InvokeServer()[tostring(game.ReplicatedStorage.Items[name].ItemId.Value)].Quantity
            local toSend = "You've obtained "..amount.." **"..name.." ("..tier..")** at life **S+".. game.Players.LocalPlayer.Rebirths.Value.."**! You now have **x"..quantity.." "..name.."(s)**."
            WebHook = _G.MH.webhooks.item
            request({
                Url = WebHook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game.HttpService:JSONEncode({
                    embeds = {{
                        title = "New Reborn Item",
                        description = toSend,
                        color = math.floor(color.r*255)*256^2+math.floor(color.g*255)*256+math.floor(color.b*255),
                        author = {
                            name = "Rebirth Tracker",
                            icon_url = "https://pbs.twimg.com/profile_images/1392664665516171275/LNC_H6fs_400x400.jpg"
                        },
                        footer = {
                            text = game.Players.LocalPlayer.Name,
                            icon_url = "https://tr.rbxcdn.com/c33870b88e37558299bf25640ea5f1c0/150/150/AvatarHeadshot/Png"
                        }
                    }}
                })
            })
        end
    end
end)

game:GetService("RunService").RenderStepped:connect(function()
    if _G.MH.doCrates then
		for i,v in pairs(game.Workspace.Boxes:GetChildren()) do
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
		end
	end
end)