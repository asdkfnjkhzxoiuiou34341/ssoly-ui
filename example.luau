-- Ssoly UI - Complete Example
-- Загрузка библиотеки
local Ssoly = loadstring(game:HttpGet("https://raw.githubusercontent.com/asdkfnjkhzxoiuiou34341/ssoly-ui/refs/heads/main/Ssoly.luau"))()

-- Создание окна со всеми настройками
local Window = Ssoly:Window({
	Title = "Ssoly UI - Showcase",
	Size = UDim2.fromOffset(780, 580),
	Theme = "Dark",
	AcrylicBlur = true,
	Blur = true,
	Keybind = Enum.KeyCode.RightControl,
	AutoSave = true,
	ConfigName = "ssoly_config",
	LoadingScreen = true
})

-- ═══════════════════════════════════════════════════════════
-- TAB 1: HOME - Основные функции
-- ═══════════════════════════════════════════════════════════
local Home = Window:Tab({Name = "Home", Icon = 7733964370})

Home:Paragraph({
	Header = "Welcome to Ssoly UI!",
	Body = "Modern UI library with smooth animations, auto-save configs, color pickers, multi-select dropdowns, collapsible sections, and search functionality."
})

Home:Divider()

local CombatSection = Home:Section({Name = "Combat Features", Collapsed = false})

CombatSection:Toggle({
	Name = "Auto Farm",
	Default = false,
	Flag = "AutoFarm",
	Callback = function(v)
		print("Auto Farm:", v)
	end
})

CombatSection:Toggle({
	Name = "Auto Collect Coins",
	Default = true,
	Callback = function(v)
		print("Auto Collect:", v)
	end
})

CombatSection:Slider({
	Name = "Farm Speed",
	Min = 1,
	Max = 100,
	Default = 50,
	Flag = "FarmSpeed",
	Callback = function(v)
		print("Speed:", v)
	end
})

local ActionsSection = Home:Section({Name = "Quick Actions", Collapsed = false})

ActionsSection:Button({
	Name = "Teleport to Spawn",
	Callback = function()
		Window:Notify({
			Title = "Teleported!",
			Description = "You have been teleported to spawn point.",
			Style = "Confirm",
			Lifetime = 2
		})
	end
})

ActionsSection:Button({
	Name = "Reset Character",
	Callback = function()
		Window:Dialog({
			Title = "Confirm Action",
			Description = "Are you sure you want to reset your character?",
			Buttons = {
				{Name = "Yes", Callback = function() 
					print("Character reset")
					Window:Notify({Title = "Reset", Description = "Character has been reset.", Lifetime = 2})
				end},
				{Name = "Cancel"}
			}
		})
	end
})

-- ═══════════════════════════════════════════════════════════
-- TAB 2: PLAYER - Настройки персонажа
-- ═══════════════════════════════════════════════════════════
local Player = Window:Tab({Name = "Player", Icon = 7733955511})

local MovementSection = Player:Section({Name = "Movement", Collapsed = false})

MovementSection:Slider({
	Name = "Walk Speed",
	Min = 16,
	Max = 200,
	Default = 16,
	Callback = function(v)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
	end
})

MovementSection:Slider({
	Name = "Jump Power",
	Min = 50,
	Max = 300,
	Default = 50,
	Callback = function(v)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
	end
})

MovementSection:Toggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(v)
		print("Infinite Jump:", v)
	end
})

local KeybindsSection = Player:Section({Name = "Keybinds", Collapsed = false})

KeybindsSection:Keybind({
	Name = "Toggle ESP",
	Default = Enum.KeyCode.E,
	OnPress = function()
		Window:Notify({Title = "ESP", Description = "ESP toggled!", Lifetime = 1})
	end
})

KeybindsSection:Keybind({
	Name = "Fly Mode",
	Default = Enum.KeyCode.F,
	OnPress = function()
		Window:Notify({Title = "Fly", Description = "Fly mode activated!", Lifetime = 1})
	end
})

KeybindsSection:Keybind({
	Name = "Noclip",
	Default = Enum.KeyCode.N,
	OnPress = function()
		Window:Notify({Title = "Noclip", Description = "Noclip toggled!", Lifetime = 1})
	end
})

-- ═══════════════════════════════════════════════════════════
-- TAB 3: COMBAT - Боевые настройки
-- ═══════════════════════════════════════════════════════════
local Combat = Window:Tab({Name = "Combat", Icon = 7734000129})

Combat:Header({Text = "Weapon Configuration"})

Combat:Dropdown({
	Name = "Weapon Type",
	Options = {"Sword", "Gun", "Bow", "Magic Staff", "Axe", "Spear"},
	Default = "Sword",
	Flag = "WeaponType",
	Callback = function(v)
		print("Selected weapon:", v)
	end
})

Combat:Dropdown({
	Name = "Target Priority",
	Options = {"Nearest", "Lowest HP", "Highest Level", "Random", "Strongest"},
	Default = "Nearest",
	Callback = function(v)
		print("Target priority:", v)
	end
})

Combat:Divider()

Combat:Header({Text = "Combat Settings"})

Combat:Toggle({
	Name = "Auto Attack",
	Default = false,
	Callback = function(v)
		print("Auto Attack:", v)
	end
})

Combat:Toggle({
	Name = "Auto Block",
	Default = false,
	Callback = function(v)
		print("Auto Block:", v)
	end
})

Combat:Slider({
	Name = "Attack Range",
	Min = 10,
	Max = 100,
	Default = 30,
	Callback = function(v)
		print("Range:", v)
	end
})

Combat:Slider({
	Name = "Attack Speed",
	Min = 1,
	Max = 10,
	Default = 5,
	Callback = function(v)
		print("Attack Speed:", v)
	end
})

-- ═══════════════════════════════════════════════════════════
-- TAB 4: VISUALS - Визуальные настройки
-- ═══════════════════════════════════════════════════════════
local Visuals = Window:Tab({Name = "Visuals", Icon = 7734053495})

Visuals:Header({Text = "ESP Settings"})

Visuals:MultiDropdown({
	Name = "ESP Elements",
	Options = {"Players", "NPCs", "Items", "Chests", "Vehicles"},
	Default = {"Players"},
	Callback = function(selected)
		print("ESP Elements:", table.concat(selected, ", "))
	end
})

Visuals:ColorPicker({
	Name = "ESP Color",
	Default = Color3.fromRGB(255, 100, 100),
	Callback = function(color)
		print("ESP Color:", color)
	end
})

Visuals:Divider()

Visuals:Header({Text = "UI Customization"})

Visuals:ColorPicker({
	Name = "Accent Color",
	Default = Color3.fromRGB(88, 101, 242),
	Callback = function(color)
		print("Accent Color:", color)
	end
})

Visuals:ColorPicker({
	Name = "Background Color",
	Default = Color3.fromRGB(18, 18, 22),
	Callback = function(color)
		print("Background Color:", color)
	end
})

-- ═══════════════════════════════════════════════════════════
-- TAB 5: MISC - Разное
-- ═══════════════════════════════════════════════════════════
local Misc = Window:Tab({Name = "Misc", Icon = 7734068321})

Misc:Header({Text = "Input Fields"})

Misc:Input({
	Name = "Custom Message",
	Placeholder = "Enter your message...",
	Default = "Hello World!",
	Callback = function(v)
		print("Message:", v)
	end
})

Misc:Input({
	Name = "Player Name",
	Placeholder = "Enter player name...",
	Callback = function(v)
		print("Target player:", v)
	end
})

Misc:Divider()

Misc:Header({Text = "Information"})

Misc:Label({Text = "Version: 2.0.0"})
Misc:Label({Text = "Made with ❤️ by Ssoly"})
Misc:Label({Text = "Discord: discord.gg/ssoly"})

Misc:Divider()

Misc:Paragraph({
	Header = "About Ssoly UI",
	Body = "Ssoly UI is a modern, feature-rich UI library for Roblox. It includes smooth animations, auto-save configurations, color pickers, multi-select dropdowns, collapsible sections, search functionality, and much more!"
})

-- ═══════════════════════════════════════════════════════════
-- TAB 6: SETTINGS - Настройки UI
-- ═══════════════════════════════════════════════════════════
local Settings = Window:Tab({Name = "Settings", Icon = 7734068321})

Settings:Header({Text = "Theme Configuration"})

Settings:Dropdown({
	Name = "Theme",
	Options = {"Dark", "Light", "Ocean", "Amber", "Green", "Purple"},
	Default = "Dark",
	Callback = function(v)
		Window:SetTheme(v)
		Window:Notify({
			Title = "Theme Changed",
			Description = "Theme set to " .. v,
			Style = "Confirm",
			Lifetime = 2
		})
	end
})

Settings:Toggle({
	Name = "Acrylic Blur",
	Default = true,
	Callback = function(v)
		Window:SetAcrylicBlur(v)
	end
})

Settings:Toggle({
	Name = "Background Blur",
	Default = true,
	Callback = function(v)
		print("Background Blur:", v)
	end
})

Settings:Divider()

Settings:Header({Text = "Notifications"})

Settings:Button({
	Name = "Test Notification",
	Callback = function()
		Window:Notify({
			Title = "Test",
			Description = "This is a test notification!",
			Lifetime = 3
		})
	end
})

Settings:Button({
	Name = "Success Notification",
	Callback = function()
		Window:Notify({
			Title = "Success!",
			Description = "Operation completed successfully!",
			Style = "Confirm",
			Lifetime = 3
		})
	end
})

Settings:Button({
	Name = "Show Dialog",
	Callback = function()
		Window:Dialog({
			Title = "Example Dialog",
			Description = "This is an example dialog with multiple buttons.",
			Buttons = {
				{Name = "Option 1", Callback = function() 
					print("Option 1 selected")
				end},
				{Name = "Option 2", Callback = function() 
					print("Option 2 selected")
				end},
				{Name = "Cancel"}
			}
		})
	end
})

Settings:Divider()

Settings:Header({Text = "Configuration"})

Settings:Button({
	Name = "Save Config",
	Callback = function()
		Window:SaveConfig()
		Window:Notify({
			Title = "Saved",
			Description = "Configuration saved successfully!",
			Style = "Confirm",
			Lifetime = 2
		})
	end
})

Settings:Button({
	Name = "Load Config",
	Callback = function()
		Window:LoadConfig()
		Window:Notify({
			Title = "Loaded",
			Description = "Configuration loaded successfully!",
			Style = "Confirm",
			Lifetime = 2
		})
	end
})

Settings:Divider()

Settings:Paragraph({
	Header = "Keybinds",
	Body = "Press RightControl to toggle the UI. You can change this keybind using Window:SetKeybind(key)."
})

-- ═══════════════════════════════════════════════════════════
-- TAB 7: ADVANCED - Продвинутые функции
-- ═══════════════════════════════════════════════════════════
local Advanced = Window:Tab({Name = "Advanced", Icon = 7734068321})

Advanced:Header({Text = "Dynamic Dropdowns"})

Advanced:Paragraph({
	Header = "Refresh Method Demo",
	Body = "Dropdowns can be dynamically updated using the :Refresh() method. Click the buttons below to see it in action!"
})

local playerDropdown = Advanced:Dropdown({
	Name = "Select Player",
	Options = {"Loading..."},
	Default = "Loading...",
	Callback = function(v)
		print("Selected player:", v)
	end
})

Advanced:Button({
	Name = "Refresh Player List",
	Callback = function()
		local players = {}
		for _, player in ipairs(game.Players:GetPlayers()) do
			table.insert(players, player.Name)
		end
		playerDropdown:Refresh(players)
		Window:Notify({
			Title = "Refreshed",
			Description = "Player list updated with " .. #players .. " players!",
			Lifetime = 2
		})
	end
})

Advanced:Divider()

Advanced:Header({Text = "Multi-Select Refresh"})

local itemMulti = Advanced:MultiDropdown({
	Name = "Select Items",
	Options = {"Item 1", "Item 2", "Item 3"},
	Default = {},
	Callback = function(selected)
		print("Selected items:", table.concat(selected, ", "))
	end
})

Advanced:Button({
	Name = "Add More Items",
	Callback = function()
		local newItems = {"Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"}
		itemMulti:Refresh(newItems)
		Window:Notify({
			Title = "Updated",
			Description = "Item list expanded to " .. #newItems .. " items!",
			Lifetime = 2
		})
	end
})

Advanced:Button({
	Name = "Reset Items",
	Callback = function()
		itemMulti:Refresh({"Item 1", "Item 2", "Item 3"})
		Window:Notify({
			Title = "Reset",
			Description = "Item list reset to default!",
			Lifetime = 2
		})
	end
})

Advanced:Divider()

Advanced:Header({Text = "Collapsible Sections"})

local CollapsedSection = Advanced:Section({Name = "Collapsed by Default", Collapsed = true})

CollapsedSection:Label({Text = "This section starts collapsed!"})
CollapsedSection:Toggle({
	Name = "Hidden Toggle",
	Default = false,
	Callback = function(v)
		print("Hidden toggle:", v)
	end
})

local OpenSection = Advanced:Section({Name = "Open by Default", Collapsed = false})

OpenSection:Label({Text = "This section starts open!"})
OpenSection:Slider({
	Name = "Hidden Slider",
	Min = 0,
	Max = 100,
	Default = 50,
	Callback = function(v)
		print("Hidden slider:", v)
	end
})

-- ═══════════════════════════════════════════════════════════
-- WELCOME NOTIFICATION
-- ═══════════════════════════════════════════════════════════
Window:Notify({
	Title = "Welcome to Ssoly UI!",
	Description = "All features loaded successfully. Press RightControl to toggle the menu.",
	Style = "Confirm",
	Lifetime = 5
})

-- ═══════════════════════════════════════════════════════════
-- FLAGS DEMONSTRATION
-- ═══════════════════════════════════════════════════════════
task.wait(2)
print("═══════════════════════════════════════")
print("Ssoly UI - Flags Demo")
print("═══════════════════════════════════════")
if Ssoly.Flags.WeaponType then
	print("Current weapon:", Ssoly.Flags.WeaponType.Get())
end
if Ssoly.Flags.FarmSpeed then
	print("Farm speed:", Ssoly.Flags.FarmSpeed.Get())
end
if Ssoly.Flags.AutoFarm then
	print("Auto farm enabled:", Ssoly.Flags.AutoFarm.Get())
end
print("═══════════════════════════════════════")
print("")
print("Features Showcase:")
print("✓ Active tab indicator")
print("✓ Larger notifications")
print("✓ Smooth toggle animations")
print("✓ ColorPicker with Select button")
print("✓ Slower dropdown animations")
print("✓ Animated section collapse")
print("✓ Resize handles on hover")
print("✓ Bigger slider for easier use")
print("✓ Dropdown/MultiDropdown :Refresh()")
print("✓ Auto-save configurations")
print("✓ Search functionality")
print("✓ Loading screen")
print("═══════════════════════════════════════")tion()
		Window:LoadConfig()
		Window:Notify({
			Title = "Loaded",
			Description = "Configuration loaded successfully!",
			Style = "Confirm",
			Lifetime = 2
		})
	end
})

Settings:Divider()

Settings:Paragraph({
	Header = "Keybinds",
	Body = "Press RightControl to toggle the UI. You can change this keybind in the window settings using Window:SetKeybind(key)."
})

-- ═══════════════════════════════════════════════════════════
-- WELCOME NOTIFICATION
-- ═══════════════════════════════════════════════════════════
Window:Notify({
	Title = "Welcome to Ssoly UI!",
	Description = "All features loaded. Press RightControl to toggle.",
	Style = "Confirm",
	Lifetime = 5
})

-- ═══════════════════════════════════════════════════════════
-- FLAGS DEMONSTRATION
-- ═══════════════════════════════════════════════════════════
task.wait(2)
print("═══════════════════════════════════════")
print("Ssoly UI - Flags Demo")
print("═══════════════════════════════════════")
print("Current weapon:", Ssoly.Flags.WeaponType.Get())
print("Farm speed:", Ssoly.Flags.FarmSpeed.Get())
print("Auto farm enabled:", Ssoly.Flags.AutoFarm.Get())
print("═══════════════════════════════════════")
