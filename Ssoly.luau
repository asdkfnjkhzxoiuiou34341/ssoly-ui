local Ssoly = {Flags = {}, Themes = {}, Config = {}}

local function getService(n)
	local s = game:GetService(n)
	return cloneref and cloneref(s) or s
end

local TS = getService("TweenService")
local UIS = getService("UserInputService")
local RS = getService("RunService")
local HS = getService("HttpService")
local Players = getService("Players")
local Player = Players.LocalPlayer

Ssoly.Themes = {
	Dark = {
		BG = Color3.fromRGB(18,18,22),
		TopBar = Color3.fromRGB(22,22,28),
		Element = Color3.fromRGB(28,28,35),
		ElementHover = Color3.fromRGB(35,35,42),
		Text = Color3.fromRGB(245,245,250),
		TextDim = Color3.fromRGB(160,160,170),
		Accent = Color3.fromRGB(88,101,242),
		Stroke = Color3.fromRGB(45,45,55),
		Shadow = Color3.fromRGB(10,10,12)
	},
	Light = {
		BG = Color3.fromRGB(245,245,250),
		TopBar = Color3.fromRGB(235,235,242),
		Element = Color3.fromRGB(255,255,255),
		ElementHover = Color3.fromRGB(248,248,252),
		Text = Color3.fromRGB(20,20,25),
		TextDim = Color3.fromRGB(100,100,110),
		Accent = Color3.fromRGB(70,130,220),
		Stroke = Color3.fromRGB(210,210,220),
		Shadow = Color3.fromRGB(180,180,190)
	},
	Ocean = {
		BG = Color3.fromRGB(15,25,35),
		TopBar = Color3.fromRGB(20,32,45),
		Element = Color3.fromRGB(25,40,55),
		ElementHover = Color3.fromRGB(32,48,65),
		Text = Color3.fromRGB(230,240,250),
		TextDim = Color3.fromRGB(140,160,180),
		Accent = Color3.fromRGB(0,180,200),
		Stroke = Color3.fromRGB(40,60,80),
		Shadow = Color3.fromRGB(10,18,25)
	},
	Amber = {
		BG = Color3.fromRGB(20,18,15),
		TopBar = Color3.fromRGB(25,22,18),
		Element = Color3.fromRGB(30,27,22),
		ElementHover = Color3.fromRGB(35,32,27),
		Text = Color3.fromRGB(255,245,230),
		TextDim = Color3.fromRGB(180,170,150),
		Accent = Color3.fromRGB(255,180,50),
		Stroke = Color3.fromRGB(50,45,35),
		Shadow = Color3.fromRGB(10,8,5)
	},
	Green = {
		BG = Color3.fromRGB(15,20,15),
		TopBar = Color3.fromRGB(18,25,18),
		Element = Color3.fromRGB(22,30,22),
		ElementHover = Color3.fromRGB(27,35,27),
		Text = Color3.fromRGB(240,255,240),
		TextDim = Color3.fromRGB(160,180,160),
		Accent = Color3.fromRGB(80,200,120),
		Stroke = Color3.fromRGB(35,50,35),
		Shadow = Color3.fromRGB(8,12,8)
	},
	Purple = {
		BG = Color3.fromRGB(20,15,28),
		TopBar = Color3.fromRGB(25,20,35),
		Element = Color3.fromRGB(32,25,42),
		ElementHover = Color3.fromRGB(40,32,52),
		Text = Color3.fromRGB(240,235,255),
		TextDim = Color3.fromRGB(160,150,180),
		Accent = Color3.fromRGB(138,80,255),
		Stroke = Color3.fromRGB(48,38,65),
		Shadow = Color3.fromRGB(12,8,18)
	}
}

local function tween(obj, info, props)
	TS:Create(obj, info, props):Play()
end

local function create(class, props)
	local obj = Instance.new(class)
	for k,v in pairs(props) do
		if k ~= "Parent" then obj[k] = v end
	end
	obj.Parent = props.Parent
	return obj
end

function Ssoly:SaveConfig(name)
	name = name or "default"
	local config = {}
	for flag, data in pairs(self.Flags) do
		local value = data.Get()
		if typeof(value) == "Color3" then
			config[flag] = {R = value.R, G = value.G, B = value.B, _type = "Color3"}
		else
			config[flag] = value
		end
	end
	local success, encoded = pcall(function() return HS:JSONEncode(config) end)
	if success and writefile then
		writefile("ssoly_" .. name .. ".json", encoded)
		return true
	end
	return false
end

function Ssoly:LoadConfig(name)
	name = name or "default"
	local file = "ssoly_" .. name .. ".json"
	if not isfile or not isfile(file) or not readfile then return false end
	local success, config = pcall(function() return HS:JSONDecode(readfile(file)) end)
	if success and config then
		for flag, value in pairs(config) do
			if self.Flags[flag] then
				if type(value) == "table" and value._type == "Color3" then
					self.Flags[flag].Set(Color3.new(value.R, value.G, value.B))
				else
					self.Flags[flag].Set(value)
				end
			end
		end
		return true
	end
	return false
end

function Ssoly:Window(cfg)
	cfg = cfg or {}
	local theme = self.Themes[cfg.Theme or "Dark"]
	local acrylicBlur = cfg.AcrylicBlur ~= false
	local currentTheme = cfg.Theme or "Dark"
	local autoSave = cfg.AutoSave ~= false
	local configName = cfg.ConfigName or "default"
	
	local gui = create("ScreenGui", {
		Name = "Ssoly",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = gethui and gethui() or (cloneref and cloneref(getService("CoreGui")) or getService("CoreGui"))
	})
	
	local loadingScreen
	if cfg.LoadingScreen ~= false then
		loadingScreen = create("Frame", {
			Size = UDim2.fromScale(1,1),
			BackgroundColor3 = Color3.fromRGB(0,0,0),
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			ZIndex = 1000,
			Parent = gui
		})
		
		local loadingBox = create("Frame", {
			AnchorPoint = Vector2.new(0.5,0.5),
			Position = UDim2.fromScale(0.5,0.5),
			Size = UDim2.fromOffset(200,100),
			BackgroundColor3 = theme.Element,
			BorderSizePixel = 0,
			Parent = loadingScreen
		})
		
		create("UICorner", {CornerRadius = UDim.new(0,12), Parent = loadingBox})
		create("UIStroke", {Color = theme.Stroke, Transparency = 0.5, Parent = loadingBox})
		
		local loadingText = create("TextLabel", {
			Position = UDim2.fromOffset(0,20),
			Size = UDim2.new(1,0,0,20),
			BackgroundTransparency = 1,
			Text = "Loading...",
			TextColor3 = theme.Text,
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			Parent = loadingBox
		})
		
		local loadingBar = create("Frame", {
			AnchorPoint = Vector2.new(0.5,0),
			Position = UDim2.new(0.5,0,0,55),
			Size = UDim2.fromOffset(160,4),
			BackgroundColor3 = theme.Stroke,
			BorderSizePixel = 0,
			Parent = loadingBox
		})
		
		create("UICorner", {CornerRadius = UDim.new(1,0), Parent = loadingBar})
		
		local loadingFill = create("Frame", {
			Size = UDim2.fromScale(0,1),
			BackgroundColor3 = theme.Accent,
			BorderSizePixel = 0,
			Parent = loadingBar
		})
		
		create("UICorner", {CornerRadius = UDim.new(1,0), Parent = loadingFill})
		
		task.spawn(function()
			tween(loadingFill, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(1,1)})
			task.wait(1.2)
			loadingText.Text = "Ready!"
			task.wait(0.3)
			tween(loadingScreen, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
			tween(loadingBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
			tween(loadingText, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 1})
			task.wait(0.4)
			loadingScreen:Destroy()
		end)
	end
	
	local blur
	if cfg.Blur ~= false then
		blur = create("DepthOfFieldEffect", {
			FarIntensity = 0,
			FocusDistance = 51.6,
			InFocusRadius = 50,
			NearIntensity = 1,
			Parent = game:GetService("Lighting")
		})
	end
	
	local main = create("CanvasGroup", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		Size = cfg.Size or UDim2.fromOffset(700,500),
		BackgroundColor3 = theme.BG,
		BackgroundTransparency = acrylicBlur and 0.15 or 0,
		BorderSizePixel = 0,
		GroupTransparency = 0,
		Parent = gui
	})
	
	create("UICorner", {CornerRadius = UDim.new(0,12), Parent = main})
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.7, Parent = main})
	
	local topbar = create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1,0,0,40),
		BackgroundColor3 = theme.TopBar,
		BorderSizePixel = 0,
		Parent = main
	})
	
	create("UICorner", {CornerRadius = UDim.new(0,12), Parent = topbar})
	
	-- Corner repair для нижней части topbar
	local cornerRepair = create("Frame", {
		Position = UDim2.fromOffset(0,28),
		Size = UDim2.new(1,0,0,12),
		BackgroundColor3 = theme.TopBar,
		BorderSizePixel = 0,
		Parent = topbar
	})
	
	local title = create("TextLabel", {
		Name = "Title",
		Position = UDim2.fromOffset(15,0),
		Size = UDim2.new(1,-100,1,0),
		BackgroundTransparency = 1,
		Text = cfg.Title or "Ssoly",
		TextColor3 = theme.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		Parent = topbar
	})
	
	local controls = create("Frame", {
		AnchorPoint = Vector2.new(1,0.5),
		Position = UDim2.new(1,-15,0.5,0),
		Size = UDim2.fromOffset(116,28),
		BackgroundTransparency = 1,
		Parent = topbar
	})
	
	create("UIListLayout", {Padding = UDim.new(0,8), FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = controls})
	
	local fullscreen = create("TextButton", {
		Size = UDim2.fromOffset(28,28),
		BackgroundColor3 = theme.ElementHover,
		BackgroundTransparency = 0,
		Text = "",
		Parent = controls
	})
	create("UICorner", {CornerRadius = UDim.new(0,6), Parent = fullscreen})
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.7, Parent = fullscreen})
	
	local fullscreenIcon = create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromOffset(14,14),
		BackgroundTransparency = 1,
		Image = "rbxassetid://7734053426",
		ImageColor3 = theme.Text,
		Parent = fullscreen
	})
	
	local minimize = create("TextButton", {
		Size = UDim2.fromOffset(28,28),
		BackgroundColor3 = theme.ElementHover,
		BackgroundTransparency = 0,
		Text = "",
		LayoutOrder = 1,
		Parent = controls
	})
	create("UICorner", {CornerRadius = UDim.new(0,6), Parent = minimize})
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.7, Parent = minimize})
	
	local minimizeIcon = create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromOffset(14,14),
		BackgroundTransparency = 1,
		Image = "rbxassetid://7733717447",
		ImageColor3 = theme.Text,
		Parent = minimize
	})
	
	local close = create("TextButton", {
		Size = UDim2.fromOffset(28,28),
		BackgroundColor3 = theme.ElementHover,
		BackgroundTransparency = 0,
		Text = "",
		LayoutOrder = 2,
		Parent = controls
	})
	create("UICorner", {CornerRadius = UDim.new(0,6), Parent = close})
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.7, Parent = close})
	
	local closeIcon = create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromOffset(14,14),
		BackgroundTransparency = 1,
		Image = "rbxassetid://7733717447",
		ImageColor3 = theme.Text,
		Rotation = 45,
		Parent = close
	})
	
	local isFullscreen = false
	local savedSize = cfg.Size or UDim2.fromOffset(700,500)
	
	fullscreen.MouseEnter:Connect(function() tween(fullscreen, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Element}) end)
	fullscreen.MouseLeave:Connect(function() tween(fullscreen, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.ElementHover}) end)
	fullscreen.MouseButton1Click:Connect(function()
		isFullscreen = not isFullscreen
		if isFullscreen then
			savedSize = main.Size
			local vpSize = workspace.CurrentCamera.ViewportSize
			tween(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(vpSize.X - 20, vpSize.Y - 20)})
		else
			tween(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = savedSize})
		end
	end)
	
	minimize.MouseEnter:Connect(function() tween(minimize, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Element}) end)
	minimize.MouseLeave:Connect(function() tween(minimize, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.ElementHover}) end)
	close.MouseEnter:Connect(function() tween(close, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(220,50,50)}) end)
	close.MouseLeave:Connect(function() tween(close, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.ElementHover}) end)
	
	local sidebar = create("Frame", {
		Name = "Sidebar",
		Position = UDim2.fromOffset(0,40),
		Size = UDim2.new(0,180,1,-40),
		BackgroundColor3 = theme.BG,
		BorderSizePixel = 0,
		Parent = main
	})
	
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.5, Parent = sidebar})
	
	local divider = create("Frame", {
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.fromScale(1,0),
		Size = UDim2.new(0,1,1,0),
		BackgroundColor3 = theme.Stroke,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = sidebar
	})
	
	local dividerBtn = create("TextButton", {
		AnchorPoint = Vector2.new(0.5,0),
		Position = UDim2.fromScale(0.5,0),
		Size = UDim2.new(1,6,1,0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = divider
	})
	
	local resizing = false
	local startX, startWidth
	
	dividerBtn.MouseEnter:Connect(function()
		tween(divider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3})
	end)
	
	dividerBtn.MouseLeave:Connect(function()
		if not resizing then
			tween(divider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
		end
	end)
	
	dividerBtn.MouseButton1Down:Connect(function()
		resizing = true
		startX = UIS:GetMouseLocation().X
		startWidth = sidebar.AbsoluteSize.X
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
			tween(divider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
		end
	end)
	
	local resizeConnection
	resizeConnection = UIS.InputChanged:Connect(function(input)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement and startX and startWidth then
			local delta = UIS:GetMouseLocation().X - startX
			local newWidth = math.clamp(startWidth + delta, 150, 400)
			sidebar.Size = UDim2.new(0, newWidth, 1, -40)
			content.Position = UDim2.fromOffset(newWidth, 40)
			content.Size = UDim2.new(1, -newWidth, 1, -40)
		end
	end)
	
	-- User info внизу sidebar
	local userInfo = create("Frame", {
		Name = "UserInfo",
		AnchorPoint = Vector2.new(0,1),
		Position = UDim2.fromScale(0,1),
		Size = UDim2.new(1,0,0,60),
		BackgroundTransparency = 1,
		Parent = sidebar
	})
	
	local userInfoContent = create("Frame", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Parent = userInfo
	})
	
	create("UIPadding", {PaddingLeft = UDim.new(0,12), PaddingBottom = UDim.new(0,10), Parent = userInfoContent})
	create("UIListLayout", {Padding = UDim.new(0,8), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = userInfoContent})
	
	local userId = Player.UserId
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local headshotImage, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	
	local headshot = create("ImageLabel", {
		Size = UDim2.fromOffset(32,32),
		BackgroundTransparency = 1,
		Image = (isReady and headshotImage) or "rbxassetid://0",
		Parent = userInfoContent
	})
	
	create("UICorner", {CornerRadius = UDim.new(1,0), Parent = headshot})
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.7, Parent = headshot})
	
	local userTextFrame = create("Frame", {
		Size = UDim2.new(1,-42,0,32),
		BackgroundTransparency = 1,
		Parent = userInfoContent
	})
	
	create("UIListLayout", {Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = userTextFrame})
	
	local displayName = create("TextLabel", {
		Size = UDim2.new(1,0,0,14),
		BackgroundTransparency = 1,
		Text = Player.DisplayName,
		TextColor3 = theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Font = Enum.Font.GothamBold,
		Parent = userTextFrame
	})
	
	local username = create("TextLabel", {
		Size = UDim2.new(1,0,0,12),
		BackgroundTransparency = 1,
		Text = "@" .. Player.Name,
		TextColor3 = theme.TextDim,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Font = Enum.Font.Gotham,
		LayoutOrder = 1,
		Parent = userTextFrame
	})
	
	local searchBox = create("Frame", {
		Position = UDim2.fromOffset(10,10),
		Size = UDim2.new(1,-20,0,32),
		BackgroundColor3 = theme.Element,
		BorderSizePixel = 0,
		Parent = sidebar
	})
	
	create("UICorner", {CornerRadius = UDim.new(0,6), Parent = searchBox})
	create("UIStroke", {Color = theme.Stroke, Transparency = 0.7, Parent = searchBox})
	
	local searchIcon = create("TextLabel", {
		Position = UDim2.fromOffset(8,0),
		Size = UDim2.fromOffset(20,32),
		BackgroundTransparency = 1,
		Text = "🔍",
		TextColor3 = theme.TextDim,
		TextSize = 14,
		Parent = searchBox
	})
	
	local searchInput = create("TextBox", {
		Position = UDim2.fromOffset(32,0),
		Size = UDim2.new(1,-40,1,0),
		BackgroundTransparency = 1,
		PlaceholderText = "Search...",
		PlaceholderColor3 = theme.TextDim,
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false,
		Parent = searchBox
	})
	
	local tabList = create("ScrollingFrame", {
		Position = UDim2.fromOffset(0,52),
		Size = UDim2.new(1,0,1,-112),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		CanvasSize = UDim2.fromScale(1,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = sidebar
	})
	
	create("UIListLayout", {Padding = UDim.new(0,5), Parent = tabList})
	create("UIPadding", {PaddingTop = UDim.new(0,10), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10), PaddingBottom = UDim.new(0,10), Parent = tabList})
	
	local content = create("Frame", {
		Name = "Content",
		Position = UDim2.fromOffset(180,40),
		Size = UDim2.new(1,-180,1,-40),
		BackgroundTransparency = 1,
		Parent = main
	})
	
	local notifs = create("ScrollingFrame", {
		Name = "Notifs",
		AnchorPoint = Vector2.new(1,1),
		Position = UDim2.new(1,-10,1,-10),
		Size = UDim2.new(0,300,1,-20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.fromScale(1,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = gui
	})
	
	create("UIListLayout", {Padding = UDim.new(0,10), VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = notifs})
	
	-- Палочка для высоты (по центру внизу)
	local resizeBarBottom = create("Frame", {
		AnchorPoint = Vector2.new(0.5,0),
		Position = UDim2.new(0,0,0,0),
		Size = UDim2.fromOffset(80,6),
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = gui
	})
	create("UICorner", {CornerRadius = UDim.new(1,0), Parent = resizeBarBottom})
	
	-- Палочка для ширины (справа по центру)
	local resizeBarRight = create("Frame", {
		AnchorPoint = Vector2.new(0,0.5),
		Position = UDim2.new(0,0,0,0),
		Size = UDim2.fromOffset(6,80),
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = gui
	})
	create("UICorner", {CornerRadius = UDim.new(1,0), Parent = resizeBarRight})
	
	-- Угловой ресайзер (правый нижний угол)
	local resizeCorner = create("Frame", {
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0,0,0,0),
		Size = UDim2.fromOffset(12,12),
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = gui
	})
	create("UICorner", {CornerRadius = UDim.new(1,0), Parent = resizeCorner})
	
	local function updateResizeBars()
		local mainPos = main.AbsolutePosition
		local mainSize = main.AbsoluteSize
		resizeBarBottom.Position = UDim2.fromOffset(mainPos.X + mainSize.X/2, mainPos.Y + mainSize.Y + 5)
		resizeBarRight.Position = UDim2.fromOffset(mainPos.X + mainSize.X + 5, mainPos.Y + mainSize.Y/2)
		resizeCorner.Position = UDim2.fromOffset(mainPos.X + mainSize.X + 5, mainPos.Y + mainSize.Y + 5)
	end
	
	updateResizeBars()
	main:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateResizeBars)
	main:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateResizeBars)
	
	local resizingCorner = false
	
	main.MouseEnter:Connect(function()
		tween(resizeBarBottom, TweenInfo.new(0.3), {BackgroundTransparency = 0.3})
		tween(resizeBarRight, TweenInfo.new(0.3), {BackgroundTransparency = 0.3})
		tween(resizeCorner, TweenInfo.new(0.3), {BackgroundTransparency = 0.3})
	end)
	
	main.MouseLeave:Connect(function()
		if not resizingHeight and not resizingWidth and not resizingCorner then
			tween(resizeBarBottom, TweenInfo.new(0.3), {BackgroundTransparency = 0.5})
			tween(resizeBarRight, TweenInfo.new(0.3), {BackgroundTransparency = 0.5})
			tween(resizeCorner, TweenInfo.new(0.3), {BackgroundTransparency = 0.5})
		end
	end)
	
	local resizeHeightBtn = create("TextButton", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = resizeBarBottom
	})
	
	local resizingHeight = false
	local startY, startHeight
	
	resizeHeightBtn.MouseEnter:Connect(function()
		tween(resizeBarBottom, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2, Size = UDim2.fromOffset(90,6)})
	end)
	
	resizeHeightBtn.MouseLeave:Connect(function()
		if not resizingHeight then
			tween(resizeBarBottom, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(80,6)})
		end
	end)
	
	resizeHeightBtn.MouseButton1Down:Connect(function()
		resizingHeight = true
		startY = UIS:GetMouseLocation().Y
		startHeight = main.AbsoluteSize.Y
	end)
	
	local resizeWidthBtn = create("TextButton", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = resizeBarRight
	})
	
	local resizingWidth = false
	local startX, startWidth
	
	resizeWidthBtn.MouseEnter:Connect(function()
		tween(resizeBarRight, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2, Size = UDim2.fromOffset(6,90)})
	end)
	
	resizeWidthBtn.MouseLeave:Connect(function()
		if not resizingWidth then
			tween(resizeBarRight, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(6,80)})
		end
	end)
	
	resizeWidthBtn.MouseButton1Down:Connect(function()
		resizingWidth = true
		startX = UIS:GetMouseLocation().X
		startWidth = main.AbsoluteSize.X
	end)
	
	local resizeCornerBtn = create("TextButton", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = resizeCorner
	})
	
	resizeCornerBtn.MouseEnter:Connect(function()
		tween(resizeCorner, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2, Size = UDim2.fromOffset(14,14)})
	end)
	
	resizeCornerBtn.MouseLeave:Connect(function()
		if not resizingCorner then
			tween(resizeCorner, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(12,12)})
		end
	end)
	
	resizeCornerBtn.MouseButton1Down:Connect(function()
		resizingCorner = true
		startX = UIS:GetMouseLocation().X
		startY = UIS:GetMouseLocation().Y
		startWidth = main.AbsoluteSize.X
		startHeight = main.AbsoluteSize.Y
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if resizingHeight then
				resizingHeight = false
				tween(resizeBarBottom, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(80,6)})
			end
			if resizingWidth then
				resizingWidth = false
				tween(resizeBarRight, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(6,80)})
			end
			if resizingCorner then
				resizingCorner = false
				tween(resizeCorner, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(12,12)})
			end
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if resizingHeight and startY and startHeight then
				local delta = UIS:GetMouseLocation().Y - startY
				local newHeight = math.clamp(startHeight + delta, 400, 800)
				main.Size = UDim2.fromOffset(main.AbsoluteSize.X, newHeight)
				updateResizeBars()
			end
			if resizingWidth and startX and startWidth then
				local delta = UIS:GetMouseLocation().X - startX
				local newWidth = math.clamp(startWidth + delta, 500, 1200)
				main.Size = UDim2.fromOffset(newWidth, main.AbsoluteSize.Y)
				updateResizeBars()
			end
			if resizingCorner and startX and startY and startWidth and startHeight then
				local deltaX = UIS:GetMouseLocation().X - startX
				local deltaY = UIS:GetMouseLocation().Y - startY
				local newWidth = math.clamp(startWidth + deltaX, 500, 1200)
				local newHeight = math.clamp(startHeight + deltaY, 400, 800)
				main.Size = UDim2.fromOffset(newWidth, newHeight)
				updateResizeBars()
			end
		end
	end)
	
	local dragging, dragStart, startPos
	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			local mousePos = UIS:GetMouseLocation()
			dragStart = Vector2.new(mousePos.X, mousePos.Y)
			startPos = main.Position
		end
	end)
	
	local dragConnection
	dragConnection = UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			if dragStart and startPos then
				local mousePos = UIS:GetMouseLocation()
				local delta = Vector2.new(mousePos.X - dragStart.X, mousePos.Y - dragStart.Y)
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	local tabs = {}
	local currentTab
	local window = {}
	local windowVisible = true
	local menuKeybind = cfg.Keybind or Enum.KeyCode.RightControl
	
	searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local query = searchInput.Text:lower()
		for _, tab in pairs(tabs) do
			if query == "" then
				tab.btn.Visible = true
			else
				local tabName = tab.btn.Name:lower()
				tab.btn.Visible = tabName:find(query) ~= nil
			end
		end
	end)
	
	create("UICorner", {CornerRadius = UDim.new(1,0), Parent = close})
	
	minimize.MouseButton1Click:Connect(function()
		window:Toggle()
	end)
	
	close.MouseButton1Click:Connect(function()
		local targetSize = UDim2.fromOffset(main.AbsoluteSize.X * 0.9, main.AbsoluteSize.Y * 0.9)
		tween(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {GroupTransparency = 1, Size = targetSize})
		task.wait(0.3)
		window:Destroy()
	end)
	
	function window:Tab(cfg)
		local tabBtn = create("TextButton", {
			Name = cfg.Name,
			Size = UDim2.new(1,0,0,35),
			BackgroundColor3 = theme.Element,
			Text = "",
			TextColor3 = theme.Text,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			Parent = tabList
		})
		
		create("UICorner", {CornerRadius = UDim.new(0,8), Parent = tabBtn})
		create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = tabBtn})
		
		local activeIndicator = create("Frame", {
			Position = UDim2.fromOffset(0,7),
			Size = UDim2.fromOffset(3,21),
			BackgroundColor3 = theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = tabBtn
		})
		
		create("UICorner", {CornerRadius = UDim.new(1,0), Parent = activeIndicator})
		
		local tabContent_inner = create("Frame", {
			Size = UDim2.fromScale(1,1),
			BackgroundTransparency = 1,
			Parent = tabBtn
		})
		
		create("UIListLayout", {Padding = UDim.new(0,8), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = tabContent_inner})
		create("UIPadding", {PaddingLeft = UDim.new(0,10), Parent = tabContent_inner})
		
		if cfg.Icon then
			local icon = create("ImageLabel", {
				Size = UDim2.fromOffset(18,18),
				BackgroundTransparency = 1,
				Image = "rbxassetid://"..cfg.Icon,
				ImageColor3 = theme.Text,
				Parent = tabContent_inner
			})
		end
		
		local tabLabel = create("TextLabel", {
			Size = UDim2.new(1,-38,1,0),
			BackgroundTransparency = 1,
			Text = cfg.Name,
			TextColor3 = theme.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = Enum.Font.Gotham,
			Parent = tabContent_inner
		})
		
		local tabContent = create("ScrollingFrame", {
			Name = cfg.Name,
			Size = UDim2.fromScale(1,1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 4,
			CanvasSize = UDim2.fromScale(1,0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = content
		})
		
		create("UIListLayout", {Padding = UDim.new(0,8), Parent = tabContent})
		create("UIPadding", {PaddingTop = UDim.new(0,10), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10), Parent = tabContent})
		
		tabBtn.MouseEnter:Connect(function()
			if tabBtn.BackgroundColor3 ~= theme.Accent then
				tween(tabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.ElementHover})
			end
		end)
		
		tabBtn.MouseLeave:Connect(function()
			if tabBtn.BackgroundColor3 ~= theme.Accent then
				tween(tabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Element})
			end
		end)
		
		local tabScale = create("UIScale", {Scale = 1, Parent = tabContent})
		
		tabBtn.MouseButton1Click:Connect(function()
			if currentTab == tabContent then return end
			for _,t in pairs(tabs) do
				tween(t.btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Element})
				tween(t.indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {BackgroundTransparency = 1, Size = UDim2.fromOffset(3,15)})
				if t.content.Visible and t.scale then
					tween(t.scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Scale = 0.95})
				end
				t.content.Visible = false
			end
			tween(tabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Accent})
			tween(activeIndicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {BackgroundTransparency = 0, Size = UDim2.fromOffset(3,21)})
			tabContent.Visible = true
			tabScale.Scale = 0.95
			tween(tabScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Scale = 1})
			currentTab = tabContent
		end)
		
		local tab = {btn = tabBtn, content = tabContent, indicator = activeIndicator, scale = tabScale}
		table.insert(tabs, tab)
		
		if #tabs == 1 then
			tabBtn.BackgroundColor3 = theme.Accent
			activeIndicator.BackgroundTransparency = 0
			tabContent.Visible = true
			currentTab = tabContent
		end
		
		function tab:Button(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			local stroke = create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local btn = create("TextButton", {
				Size = UDim2.fromScale(1,1),
				BackgroundTransparency = 1,
				Text = cfg.Name,
				TextColor3 = theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				Parent = frame
			})
			
			btn.MouseEnter:Connect(function() 
				tween(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Accent})
				tween(stroke, TweenInfo.new(0.2), {Transparency = 0.5})
			end)
			btn.MouseLeave:Connect(function() 
				tween(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Element})
				tween(stroke, TweenInfo.new(0.2), {Transparency = 0.8})
			end)
			btn.MouseButton1Click:Connect(function()
				local scale = create("UIScale", {Scale = 1, Parent = frame})
				tween(scale, TweenInfo.new(0.1), {Scale = 0.95})
				task.wait(0.1)
				tween(scale, TweenInfo.new(0.1), {Scale = 1})
				if cfg.Callback then cfg.Callback() end
			end)
			
			return {Set = function() end}
		end
		
		function tab:Toggle(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local label = create("TextLabel", {
				Position = UDim2.fromOffset(10,0),
				Size = UDim2.new(1,-60,1,0),
				BackgroundTransparency = 1,
				Text = cfg.Name,
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local toggle = create("Frame", {
				AnchorPoint = Vector2.new(1,0.5),
				Position = UDim2.new(1,-10,0.5,0),
				Size = UDim2.fromOffset(40,20),
				BackgroundColor3 = cfg.Default and theme.Accent or theme.Stroke,
				BorderSizePixel = 0,
				Parent = frame
			})
			
			create("UICorner", {CornerRadius = UDim.new(1,0), Parent = toggle})
			
			local circle = create("Frame", {
				Position = cfg.Default and UDim2.fromOffset(22,2) or UDim2.fromOffset(2,2),
				Size = UDim2.fromOffset(16,16),
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel = 0,
				Parent = toggle
			})
			
			create("UICorner", {CornerRadius = UDim.new(1,0), Parent = circle})
			
			local state = cfg.Default or false
			
			local btn = create("TextButton", {
				Size = UDim2.fromScale(1,1),
				BackgroundTransparency = 1,
				Text = "",
				Parent = frame
			})
			
			btn.MouseButton1Click:Connect(function()
				state = not state
				tween(toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = state and theme.Accent or theme.Stroke})
				tween(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = state and UDim2.fromOffset(22,2) or UDim2.fromOffset(2,2)})
				if cfg.Callback then cfg.Callback(state) end
			end)
			
			if cfg.Flag then 
				Ssoly.Flags[cfg.Flag] = {Type = "Toggle", Get = function() return state end, Set = function(v) state = v end}
				if autoSave then
					task.delay(0.5, function() Ssoly:SaveConfig(configName) end)
				end
			end
			
			return {Set = function(self, v) state = v tween(toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = v and theme.Accent or theme.Stroke}) tween(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = v and UDim2.fromOffset(22,2) or UDim2.fromOffset(2,2)}) end}
		end
		
		function tab:Slider(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,50),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local label = create("TextLabel", {
				Position = UDim2.fromOffset(10,5),
				Size = UDim2.new(1,-20,0,20),
				BackgroundTransparency = 1,
				Text = cfg.Name,
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local value = cfg.Default or cfg.Min
			
			local valueLabel = create("TextLabel", {
				Position = UDim2.fromOffset(10,5),
				Size = UDim2.new(1,-20,0,20),
				BackgroundTransparency = 1,
				Text = tostring(value),
				TextColor3 = theme.TextDim,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Right,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local slider = create("Frame", {
				Position = UDim2.fromOffset(10,30),
				Size = UDim2.new(1,-20,0,10),
				BackgroundColor3 = theme.Stroke,
				BorderSizePixel = 0,
				Parent = frame
			})
			
			create("UICorner", {CornerRadius = UDim.new(1,0), Parent = slider})
			
			local fill = create("Frame", {
				Size = UDim2.fromScale((value - cfg.Min) / (cfg.Max - cfg.Min), 1),
				BackgroundColor3 = theme.Accent,
				BorderSizePixel = 0,
				Parent = slider
			})
			
			create("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})
			
			local handle = create("Frame", {
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.new((value - cfg.Min) / (cfg.Max - cfg.Min), 0, 0.5, 0),
				Size = UDim2.fromOffset(14,14),
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel = 0,
				Parent = slider
			})
			
			create("UICorner", {CornerRadius = UDim.new(1,0), Parent = handle})
			create("UIStroke", {Color = theme.Accent, Thickness = 2, Parent = handle})
			
			local dragging = false
			
			slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			
			UIS.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
					value = math.floor(cfg.Min + (cfg.Max - cfg.Min) * pos)
					tween(fill, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(pos, 1)})
					tween(handle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = UDim2.new(pos, 0, 0.5, 0)})
					valueLabel.Text = tostring(value)
					if cfg.Callback then cfg.Callback(value) end
				end
			end)
			
			if cfg.Flag then 
				Ssoly.Flags[cfg.Flag] = {Type = "Slider", Get = function() return value end, Set = function(v) value = v end}
				if autoSave then
					task.delay(0.5, function() Ssoly:SaveConfig(configName) end)
				end
			end
			
			return {Set = function(self, v) value = v local pos = (v - cfg.Min) / (cfg.Max - cfg.Min) fill.Size = UDim2.fromScale(pos, 1) handle.Position = UDim2.new(pos, 0, 0.5, 0) valueLabel.Text = tostring(v) end}
		end
		
		function tab:Dropdown(cfg)
			local dropdownHeight = math.min(#cfg.Options * 35, 200)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local label = create("TextLabel", {
				Position = UDim2.fromOffset(10,0),
				Size = UDim2.new(1,-40,0,40),
				BackgroundTransparency = 1,
				Text = cfg.Name .. ": " .. (cfg.Default or "None"),
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local arrow = create("ImageLabel", {
				AnchorPoint = Vector2.new(1,0.5),
				Position = UDim2.new(1,-10,0,20),
				Size = UDim2.fromOffset(12,12),
				BackgroundTransparency = 1,
				Image = "rbxassetid://7733717447",
				ImageColor3 = theme.TextDim,
				Rotation = 90,
				Parent = frame
			})
			
			local selected = cfg.Default
			local open = false
			local list
			
			local btn = create("TextButton", {
				Size = UDim2.new(1,0,0,40),
				BackgroundTransparency = 1,
				Text = "",
				Parent = frame
			})
			
			btn.MouseButton1Click:Connect(function()
				if open then
					open = false
					tween(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Rotation = 90})
					tween(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,40)})
					tween(list, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,0), GroupTransparency = 1})
					task.wait(0.25)
					if list then list:Destroy() list = nil end
					return
				end
				
				open = true
				tween(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Rotation = -90})
				tween(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,45 + dropdownHeight)})
				
				list = create("CanvasGroup", {
					Position = UDim2.fromOffset(0,45),
					Size = UDim2.new(1,0,0,0),
					BackgroundColor3 = theme.ElementHover,
					BorderSizePixel = 0,
					GroupTransparency = 1,
					Parent = frame
				})
				
				create("UICorner", {CornerRadius = UDim.new(0,6), Parent = list})
				
				local scroll = create("ScrollingFrame", {
					Size = UDim2.fromScale(1,1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 4,
					CanvasSize = UDim2.fromScale(1,0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					Parent = list
				})
				
				create("UIListLayout", {Padding = UDim.new(0,2), Parent = scroll})
				create("UIPadding", {PaddingTop = UDim.new(0,5), PaddingBottom = UDim.new(0,5), Parent = scroll})
				
				for _,opt in ipairs(cfg.Options) do
					local optBtn = create("TextButton", {
						Size = UDim2.new(1,0,0,30),
						BackgroundColor3 = theme.ElementHover,
						Text = opt,
						TextColor3 = theme.Text,
						TextSize = 13,
						Font = Enum.Font.Gotham,
						Parent = scroll
					})
					
					optBtn.MouseEnter:Connect(function() tween(optBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.Element}) end)
					optBtn.MouseLeave:Connect(function() tween(optBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = theme.ElementHover}) end)
					
					optBtn.MouseButton1Click:Connect(function()
						selected = opt
						label.Text = cfg.Name .. ": " .. opt
						open = false
						tween(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Rotation = 90})
						tween(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,40)})
						tween(list, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,0), GroupTransparency = 1})
						task.wait(0.25)
						if list then list:Destroy() list = nil end
						if cfg.Callback then cfg.Callback(opt) end
					end)
				end
				
				tween(list, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,dropdownHeight), GroupTransparency = 0})
			end)
			
			if cfg.Flag then 
				Ssoly.Flags[cfg.Flag] = {Type = "Dropdown", Get = function() return selected end, Set = function(v) selected = v end}
				if autoSave then
					task.delay(0.5, function() Ssoly:SaveConfig(configName) end)
				end
			end
			
			local dropdownObj = {}
			
			function dropdownObj:Set(v)
				selected = v
				label.Text = cfg.Name .. ": " .. v
			end
			
			function dropdownObj:Refresh(newOptions)
				cfg.Options = newOptions
				dropdownHeight = math.min(#newOptions * 35, 200)
			end
			
			return dropdownObj
		end
		
		function tab:MultiDropdown(cfg)
			local dropdownHeight = math.min(#cfg.Options * 35, 200)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local selected = cfg.Default or {}
			
			local function getSelectedText()
				if #selected == 0 then return "None" end
				if #selected == 1 then return selected[1] end
				return #selected .. " selected"
			end
			
			local label = create("TextLabel", {
				Position = UDim2.fromOffset(10,0),
				Size = UDim2.new(1,-40,0,40),
				BackgroundTransparency = 1,
				Text = cfg.Name .. ": " .. getSelectedText(),
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local arrow = create("ImageLabel", {
				AnchorPoint = Vector2.new(1,0.5),
				Position = UDim2.new(1,-10,0,20),
				Size = UDim2.fromOffset(12,12),
				BackgroundTransparency = 1,
				Image = "rbxassetid://7733717447",
				ImageColor3 = theme.TextDim,
				Rotation = 90,
				Parent = frame
			})
			
			local open = false
			local list
			
			local btn = create("TextButton", {
				Size = UDim2.new(1,0,0,40),
				BackgroundTransparency = 1,
				Text = "",
				Parent = frame
			})
			
			local checkboxes = {}
			
			btn.MouseButton1Click:Connect(function()
				if open then
					open = false
					tween(arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Rotation = 90})
					tween(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,40)})
					tween(list, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,0), GroupTransparency = 1})
					task.wait(0.5)
					if list then list:Destroy() list = nil end
					return
					end
				
				open = true
				tween(arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Rotation = -90})
				tween(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,45 + dropdownHeight)})
				
				list = create("CanvasGroup", {
					Position = UDim2.fromOffset(0,45),
					Size = UDim2.new(1,0,0,0),
					BackgroundColor3 = theme.ElementHover,
					BorderSizePixel = 0,
					GroupTransparency = 1,
					Parent = frame
				})
				
				create("UICorner", {CornerRadius = UDim.new(0,6), Parent = list})
				
				local scroll = create("ScrollingFrame", {
					Size = UDim2.fromScale(1,1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 4,
					CanvasSize = UDim2.fromScale(1,0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					Parent = list
				})
				
				create("UIListLayout", {Padding = UDim.new(0,2), Parent = scroll})
				create("UIPadding", {PaddingTop = UDim.new(0,5), PaddingBottom = UDim.new(0,5), Parent = scroll})
				
				for _,opt in ipairs(cfg.Options) do
					local optFrame = create("Frame", {
						Size = UDim2.new(1,0,0,30),
						BackgroundColor3 = theme.ElementHover,
						BorderSizePixel = 0,
						Parent = scroll
					})
					
					local optBtn = create("TextButton", {
						Size = UDim2.fromScale(1,1),
						BackgroundTransparency = 1,
						Text = "",
						Parent = optFrame
					})
					
					local optLabel = create("TextLabel", {
						Position = UDim2.fromOffset(10,0),
						Size = UDim2.new(1,-40,1,0),
						BackgroundTransparency = 1,
						Text = opt,
						TextColor3 = theme.Text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Enum.Font.Gotham,
						Parent = optFrame
					})
					
					local isSelected = table.find(selected, opt) ~= nil
					
					local checkbox = create("Frame", {
						AnchorPoint = Vector2.new(1,0.5),
						Position = UDim2.new(1,-10,0.5,0),
						Size = UDim2.fromOffset(16,16),
						BackgroundColor3 = isSelected and theme.Accent or theme.Stroke,
						BorderSizePixel = 0,
						Parent = optFrame
					})
					
					create("UICorner", {CornerRadius = UDim.new(0,3), Parent = checkbox})
					
					local checkmark = create("TextLabel", {
						Size = UDim2.fromScale(1,1),
						BackgroundTransparency = 1,
						Text = isSelected and "✓" or "",
						TextColor3 = Color3.fromRGB(255,255,255),
						TextSize = 12,
						Font = Enum.Font.GothamBold,
						Parent = checkbox
					})
					
					checkboxes[opt] = {frame = checkbox, mark = checkmark}
					
					optBtn.MouseEnter:Connect(function() tween(optFrame, TweenInfo.new(0.2), {BackgroundColor3 = theme.Element}) end)
					optBtn.MouseLeave:Connect(function() tween(optFrame, TweenInfo.new(0.2), {BackgroundColor3 = theme.ElementHover}) end)
					
					optBtn.MouseButton1Click:Connect(function()
						local idx = table.find(selected, opt)
						if idx then
							table.remove(selected, idx)
							tween(checkbox, TweenInfo.new(0.2), {BackgroundColor3 = theme.Stroke})
							checkmark.Text = ""
						else
							table.insert(selected, opt)
							tween(checkbox, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent})
							checkmark.Text = "✓"
						end
						label.Text = cfg.Name .. ": " .. getSelectedText()
						if cfg.Callback then cfg.Callback(selected) end
					end)
				end
				
				tween(list, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,dropdownHeight), GroupTransparency = 0})
			end)
			
			if cfg.Flag then Ssoly.Flags[cfg.Flag] = {Type = "MultiDropdown", Get = function() return selected end, Set = function(v) selected = v end} end
			
			local multiDropdownObj = {}
			
			function multiDropdownObj:Set(v)
				selected = v
				label.Text = cfg.Name .. ": " .. getSelectedText()
			end
			
			function multiDropdownObj:Get()
				return selected
			end
			
			function multiDropdownObj:Refresh(newOptions)
				cfg.Options = newOptions
				dropdownHeight = math.min(#newOptions * 35, 200)
				selected = {}
				label.Text = cfg.Name .. ": None"
			end
			
			return multiDropdownObj
		end
		
		function tab:Keybind(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local label = create("TextLabel", {
				Position = UDim2.fromOffset(10,0),
				Size = UDim2.new(1,-80,1,0),
				BackgroundTransparency = 1,
				Text = cfg.Name,
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local keyBox = create("TextBox", {
				AnchorPoint = Vector2.new(1,0.5),
				Position = UDim2.new(1,-10,0.5,0),
				Size = UDim2.fromOffset(60,25),
				BackgroundColor3 = theme.Stroke,
				Text = cfg.Default and cfg.Default.Name or "...",
				TextColor3 = theme.Text,
				TextSize = 12,
				Font = Enum.Font.Gotham,
				ClearTextOnFocus = false,
				PlaceholderText = "...",
				Parent = frame
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,4), Parent = keyBox})
			
			local currentKey = cfg.Default
			local binding = false
			
			keyBox.Focused:Connect(function()
				binding = true
				keyBox.Text = "..."
				
				local conn
				conn = UIS.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						keyBox.Text = input.KeyCode.Name
						keyBox:ReleaseFocus()
						binding = false
						conn:Disconnect()
						if cfg.Callback then cfg.Callback(currentKey) end
					end
				end)
			end)
			
			keyBox.FocusLost:Connect(function()
				if binding then
					keyBox.Text = currentKey and currentKey.Name or "..."
					binding = false
				end
			end)
			
			UIS.InputBegan:Connect(function(input)
				if not binding and currentKey and input.KeyCode == currentKey then
					if cfg.OnPress then cfg.OnPress() end
				end
			end)
			
			if cfg.Flag then Ssoly.Flags[cfg.Flag] = {Type = "Keybind", Get = function() return currentKey end, Set = function(v) currentKey = v keyBox.Text = v.Name end} end
			
			return {Set = function(self, v) currentKey = v keyBox.Text = v.Name end, Get = function() return currentKey end}
		end
		
		function tab:Input(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local input = create("TextBox", {
				Position = UDim2.fromOffset(10,0),
				Size = UDim2.new(1,-20,1,0),
				BackgroundTransparency = 1,
				PlaceholderText = cfg.Placeholder or cfg.Name,
				Text = cfg.Default or "",
				TextColor3 = theme.Text,
				PlaceholderColor3 = theme.TextDim,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				ClearTextOnFocus = false,
				Parent = frame
			})
			
			input.FocusLost:Connect(function()
				if cfg.Callback then cfg.Callback(input.Text) end
			end)
			
			if cfg.Flag then Ssoly.Flags[cfg.Flag] = {Type = "Input", Get = function() return input.Text end, Set = function(v) input.Text = v end} end
			
			return {Set = function(self, v) input.Text = v end}
		end
		
		function tab:ColorPicker(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,40),
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			
			local label = create("TextLabel", {
				Position = UDim2.fromOffset(10,0),
				Size = UDim2.new(1,-60,1,0),
				BackgroundTransparency = 1,
				Text = cfg.Name,
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			local currentColor = cfg.Default or Color3.fromRGB(255,255,255)
			
			local colorBox = create("TextButton", {
				AnchorPoint = Vector2.new(1,0.5),
				Position = UDim2.new(1,-10,0.5,0),
				Size = UDim2.fromOffset(40,25),
				BackgroundColor3 = currentColor,
				Text = "",
				Parent = frame
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,6), Parent = colorBox})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.5, Parent = colorBox})
			
			local pickerOpen = false
			local picker
			
			colorBox.MouseButton1Click:Connect(function()
				if pickerOpen then
					pickerOpen = false
					tween(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,40)})
					if picker then 
						task.wait(0.3)
						picker:Destroy() 
						picker = nil 
					end
					return
					end
				
				pickerOpen = true
				tween(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,230)})
				
				picker = create("Frame", {
					Position = UDim2.fromOffset(10,50),
					Size = UDim2.new(1,-20,0,170),
					BackgroundTransparency = 1,
					Parent = frame
				})
				
				local h,s,v = currentColor:ToHSV()
				
				local hueBar = create("Frame", {
					AnchorPoint = Vector2.new(1,0),
					Position = UDim2.new(1,0,0,0),
					Size = UDim2.fromOffset(25,140),
					BackgroundColor3 = Color3.fromRGB(255,255,255),
					BorderSizePixel = 0,
					Parent = picker
				})
				
				create("UICorner", {CornerRadius = UDim.new(0,4), Parent = hueBar})
				create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}), Rotation = 90, Parent = hueBar})
				
				local svBox = create("Frame", {
					Size = UDim2.new(1,-35,0,140),
					BackgroundColor3 = Color3.fromHSV(h,1,1),
					BorderSizePixel = 0,
					Parent = picker
				})
				
				create("UICorner", {CornerRadius = UDim.new(0,4), Parent = svBox})
				
				local white = create("Frame", {
					Size = UDim2.fromScale(1,1),
					BackgroundColor3 = Color3.fromRGB(255,255,255),
					BorderSizePixel = 0,
					Parent = svBox
				})
				create("UICorner", {CornerRadius = UDim.new(0,4), Parent = white})
				create("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}), Parent = white})
				
				local black = create("Frame", {
					Size = UDim2.fromScale(1,1),
					BackgroundColor3 = Color3.fromRGB(0,0,0),
					BorderSizePixel = 0,
					Parent = svBox
				})
				create("UICorner", {CornerRadius = UDim.new(0,4), Parent = black})
				create("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(0,0,0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}), Rotation = 90, Parent = black})
				
				local cursor = create("Frame", {
					AnchorPoint = Vector2.new(0.5,0.5),
					Position = UDim2.fromScale(s,1-v),
					Size = UDim2.fromOffset(14,14),
					BackgroundColor3 = Color3.fromRGB(255,255,255),
					BorderSizePixel = 0,
					Parent = svBox
				})
				create("UICorner", {CornerRadius = UDim.new(1,0), Parent = cursor})
				create("UIStroke", {Color = Color3.fromRGB(0,0,0), Thickness = 3, Parent = cursor})
				
				local hueIndicator = create("Frame", {
					AnchorPoint = Vector2.new(0.5,0.5),
					Position = UDim2.fromScale(0.5,h),
					Size = UDim2.new(1,2,0,4),
					BackgroundColor3 = Color3.fromRGB(255,255,255),
					BorderSizePixel = 0,
					Parent = hueBar
				})
				create("UICorner", {CornerRadius = UDim.new(1,0), Parent = hueIndicator})
				create("UIStroke", {Color = Color3.fromRGB(0,0,0), Thickness = 2, Parent = hueIndicator})
				
				local draggingSV = false
				local draggingHue = false
				
				svBox.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSV = true
					end
				end)
				
				hueBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingHue = true
					end
				end)
				
				UIS.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSV = false
						draggingHue = false
					end
				end)
				
				UIS.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if draggingSV then
							local posX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
							local posY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
							s = posX
							v = 1 - posY
							cursor.Position = UDim2.fromScale(s,posY)
							currentColor = Color3.fromHSV(h,s,v)
							colorBox.BackgroundColor3 = currentColor
							if cfg.Callback then cfg.Callback(currentColor) end
						elseif draggingHue then
							local posY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
							h = posY
							hueIndicator.Position = UDim2.fromScale(0.5,h)
							svBox.BackgroundColor3 = Color3.fromHSV(h,1,1)
							currentColor = Color3.fromHSV(h,s,v)
							colorBox.BackgroundColor3 = currentColor
							if cfg.Callback then cfg.Callback(currentColor) end
						end
					end
				end)
				
				local selectBtn = create("TextButton", {
					Position = UDim2.fromOffset(0,150),
					Size = UDim2.new(1,0,0,28),
					BackgroundColor3 = theme.Accent,
					Text = "Select Color",
					TextColor3 = Color3.fromRGB(255,255,255),
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					Parent = picker
				})
				
				create("UICorner", {CornerRadius = UDim.new(0,6), Parent = selectBtn})
				
				selectBtn.MouseEnter:Connect(function()
					tween(selectBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(theme.Accent.R * 255 * 0.8, theme.Accent.G * 255 * 0.8, theme.Accent.B * 255 * 0.8)})
				end)
				
				selectBtn.MouseLeave:Connect(function()
					tween(selectBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent})
				end)
				
				selectBtn.MouseButton1Click:Connect(function()
					pickerOpen = false
					tween(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,40)})
					if picker then 
						task.wait(0.3)
						picker:Destroy() 
						picker = nil 
					end
				end)
				end)
			
			local colorPickerObj = {}
			
			function colorPickerObj:Set(v)
				currentColor = v
				colorBox.BackgroundColor3 = v
			end
			
			function colorPickerObj:Get()
				return currentColor
			end
			
			if cfg.Flag then 
				Ssoly.Flags[cfg.Flag] = {
					Type = "ColorPicker", 
					Get = function() return currentColor end, 
					Set = function(v) colorPickerObj:Set(v) end
				}
			end
			
			return colorPickerObj
		end
		
		function tab:Label(cfg)
			local label = create("TextLabel", {
				Size = UDim2.new(1,0,0,30),
				BackgroundTransparency = 1,
				Text = cfg.Text,
				TextColor3 = theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = tabContent
			})
			
			return {Set = function(self, v) label.Text = v end}
		end
		
		function tab:Header(cfg)
			local header = create("TextLabel", {
				Size = UDim2.new(1,0,0,25),
				BackgroundTransparency = 1,
				Text = cfg.Text or cfg.Name,
				TextColor3 = theme.Text,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.GothamBold,
				Parent = tabContent
			})
			
			return {Set = function(self, v) header.Text = v end}
		end
		
		function tab:Paragraph(cfg)
			local frame = create("Frame", {
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = frame})
			create("UIPadding", {PaddingTop = UDim.new(0,15), PaddingBottom = UDim.new(0,15), PaddingLeft = UDim.new(0,15), PaddingRight = UDim.new(0,15), Parent = frame})
			
			local layout = create("UIListLayout", {Padding = UDim.new(0,8), Parent = frame})
			
			local header = create("TextLabel", {
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = cfg.Header or "Header",
				TextColor3 = theme.Text,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Font = Enum.Font.GothamBold,
				Parent = frame
			})
			
			local body = create("TextLabel", {
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = cfg.Body or "",
				TextColor3 = theme.TextDim,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Font = Enum.Font.Gotham,
				Parent = frame
			})
			
			return {
				SetHeader = function(self, v) header.Text = v end,
				SetBody = function(self, v) body.Text = v end
			}
		end
		
		function tab:Divider()
			local divider = create("Frame", {
				Size = UDim2.new(1,0,0,1),
				BackgroundColor3 = theme.Stroke,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			local padding = create("Frame", {
				Size = UDim2.new(1,0,0,16),
				BackgroundTransparency = 1,
				Parent = tabContent
			})
			
			return {Remove = function() divider:Destroy() padding:Destroy() end}
		end
		
		function tab:Section(cfg)
			local section = create("Frame", {
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = tabContent
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,8), Parent = section})
			create("UIStroke", {Color = theme.Stroke, Transparency = 0.8, Parent = section})
			
			local sectionHeader = create("TextButton", {
				Size = UDim2.new(1,0,0,35),
				BackgroundTransparency = 1,
				Text = "",
				Parent = section
			})
			
			local arrow = create("ImageLabel", {
				Position = UDim2.fromOffset(12,11),
				Size = UDim2.fromOffset(12,12),
				BackgroundTransparency = 1,
				Image = "rbxassetid://7733717447",
				ImageColor3 = theme.TextDim,
				Rotation = -90,
				Parent = sectionHeader
			})
			
			local sectionTitle = create("TextLabel", {
				Position = UDim2.fromOffset(32,0),
				Size = UDim2.new(1,-44,1,0),
				BackgroundTransparency = 1,
				Text = cfg.Name or "Section",
				TextColor3 = theme.Text,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.GothamBold,
				Parent = sectionHeader
			})
			
			local sectionContent = create("Frame", {
				Position = UDim2.fromOffset(0,35),
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Visible = cfg.Collapsed ~= true,
				Parent = section
			})
			
			if cfg.Collapsed then
				arrow.Rotation = 90
			end
			
			local collapsed = cfg.Collapsed or false
			
			local contentSize = create("UIScale", {Scale = 1, Parent = sectionContent})
			
			sectionHeader.MouseButton1Click:Connect(function()
				collapsed = not collapsed
				tween(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Rotation = collapsed and 90 or -90})
				if collapsed then
					tween(contentSize, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = 0})
					task.wait(0.3)
					sectionContent.Visible = false
				else
					sectionContent.Visible = true
					contentSize.Scale = 0
					tween(contentSize, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = 1})
				end
			end)
			
			create("UIListLayout", {Padding = UDim.new(0,6), Parent = sectionContent})
			create("UIPadding", {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), PaddingBottom = UDim.new(0,8), Parent = sectionContent})
			
			local sectionObj = {content = sectionContent}
			
			function sectionObj:Button(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Button(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:Toggle(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Toggle(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:Slider(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Slider(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:Dropdown(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Dropdown(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:Keybind(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Keybind(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:Input(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Input(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:Label(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:Label(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:ColorPicker(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:ColorPicker(cfg)
				tabContent = oldParent
				return result
			end
			
			function sectionObj:MultiDropdown(cfg)
				local oldParent = tabContent
				tabContent = sectionContent
				local result = tab:MultiDropdown(cfg)
				tabContent = oldParent
				return result
			end
			
			return sectionObj
		end
		
		return tab
	end
	
	function window:Dialog(cfg)
		local dialogCanvas = create("CanvasGroup", {
			Name = "DialogCanvas",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1,1),
			GroupTransparency = 1,
			ZIndex = 100,
			Parent = gui
		})
		
		local dialogBG = create("Frame", {
			Size = UDim2.fromScale(1,1),
			BackgroundColor3 = Color3.fromRGB(0,0,0),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Parent = dialogCanvas
		})
		
		create("UICorner", {CornerRadius = UDim.new(0,10), Parent = dialogBG})
		
		local prompt = create("Frame", {
			AnchorPoint = Vector2.new(0.5,0.5),
			Position = UDim2.fromScale(0.5,0.5),
			Size = UDim2.fromOffset(300,0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.Element,
			BorderSizePixel = 0,
			Parent = dialogBG
		})
		
		create("UICorner", {CornerRadius = UDim.new(0,10), Parent = prompt})
		create("UIStroke", {Color = theme.Stroke, Transparency = 0.5, Parent = prompt})
		create("UIPadding", {PaddingTop = UDim.new(0,20), PaddingBottom = UDim.new(0,20), PaddingLeft = UDim.new(0,20), PaddingRight = UDim.new(0,20), Parent = prompt})
		
		local promptScale = create("UIScale", {Scale = 0.95, Parent = prompt})
		
		local layout = create("UIListLayout", {Padding = UDim.new(0,15), Parent = prompt})
		
		local titleLbl = create("TextLabel", {
			Text = cfg.Title or "Dialog",
			TextColor3 = theme.Text,
			TextSize = 16,
			Font = Enum.Font.GothamBold,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = prompt
		})
		
		local descLbl = create("TextLabel", {
			Text = cfg.Description or "",
			TextColor3 = theme.TextDim,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = prompt
		})
		
		local btnContainer = create("Frame", {
			Size = UDim2.new(1,0,0,0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = prompt
		})
		
		create("UIListLayout", {Padding = UDim.new(0,10), Parent = btnContainer})
		
		local function closeDialog()
			tween(dialogCanvas, TweenInfo.new(0.1), {GroupTransparency = 1})
			tween(promptScale, TweenInfo.new(0.1), {Scale = 0.95})
			task.wait(0.1)
			dialogCanvas:Destroy()
		end
		
		for _, btn in ipairs(cfg.Buttons or {}) do
			local button = create("TextButton", {
				Text = btn.Name or "Button",
				TextColor3 = theme.Text,
				TextSize = 14,
				Font = Enum.Font.Gotham,
				BackgroundColor3 = theme.ElementHover,
				Size = UDim2.new(1,0,0,35),
				Parent = btnContainer
			})
			
			create("UICorner", {CornerRadius = UDim.new(0,6), Parent = button})
			
			button.MouseButton1Click:Connect(function()
				if btn.Callback then btn.Callback() end
				closeDialog()
			end)
		end
		
		tween(dialogCanvas, TweenInfo.new(0.1), {GroupTransparency = 0})
		tween(promptScale, TweenInfo.new(0.1), {Scale = 1})
		
		return {Cancel = closeDialog}
	end
	
	function window:Notify(cfg)
		local notifScale = create("UIScale", {Scale = 0})
		
		local notif = create("Frame", {
			Size = UDim2.fromOffset(cfg.SizeX or 320, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.Element,
			BorderSizePixel = 0,
			Parent = notifs
		})
		
		notifScale.Parent = notif
		
		create("UICorner", {CornerRadius = UDim.new(0,10), Parent = notif})
		create("UIStroke", {Color = theme.Stroke, Transparency = 0.5, Parent = notif})
		create("UIPadding", {PaddingTop = UDim.new(0,15), PaddingBottom = UDim.new(0,15), PaddingLeft = UDim.new(0,15), PaddingRight = UDim.new(0,15), Parent = notif})
		
		local layout = create("UIListLayout", {Padding = UDim.new(0,5), Parent = notif})
		
		local titleFrame = create("Frame", {
			Size = UDim2.new(1,0,0,20),
			BackgroundTransparency = 1,
			Parent = notif
		})
		
		local title = create("TextLabel", {
			Size = UDim2.new(1,-25,1,0),
			BackgroundTransparency = 1,
			Text = cfg.Title or "Notification",
			TextColor3 = theme.Text,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = Enum.Font.GothamBold,
			Parent = titleFrame
		})
		
		local closeBtn
		if cfg.Style == "Confirm" or cfg.Style == "Cancel" then
			closeBtn = create("TextButton", {
				AnchorPoint = Vector2.new(1,0.5),
				Position = UDim2.new(1,0,0.5,0),
				Size = UDim2.fromOffset(20,20),
				BackgroundTransparency = 1,
				Text = cfg.Style == "Confirm" and "✓" or "✗",
				TextColor3 = theme.Text,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				Parent = titleFrame
			})
		end
		
		local desc = create("TextLabel", {
			Size = UDim2.new(1,0,0,0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = cfg.Description or "",
			TextColor3 = theme.TextDim,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Font = Enum.Font.Gotham,
			Parent = notif
		})
		
		local function closeNotif()
			tween(notifScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {Scale = 0})
			task.wait(0.2)
			notif:Destroy()
		end
		
		if closeBtn then
			closeBtn.MouseButton1Click:Connect(function()
				if cfg.Callback then cfg.Callback() end
				closeNotif()
			end)
		end
		
		tween(notifScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {Scale = 1})
		
		local lifetime = cfg.Lifetime or 3
		if lifetime > 0 then
			task.delay(lifetime, closeNotif)
		end
		
		return {
			Cancel = closeNotif,
			UpdateTitle = function(self, v) title.Text = v end,
			UpdateDescription = function(self, v) desc.Text = v end
		}
	end
	
	function window:SetState(state)
		windowVisible = state
		if state then
			main.Visible = true
			main.GroupTransparency = 1
			main.Size = UDim2.fromOffset((cfg.Size or UDim2.fromOffset(700,500)).X.Offset * 0.95, (cfg.Size or UDim2.fromOffset(700,500)).Y.Offset * 0.95)
			tween(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0, Size = cfg.Size or UDim2.fromOffset(700,500)})
			resizeBarBottom.Position = UDim2.new(0.5,0,0.5,main.AbsoluteSize.Y/2 + 10)
			resizeCorner.Position = UDim2.new(0.5,main.AbsoluteSize.X/2 + 10,0.5,main.AbsoluteSize.Y/2 - 20)
		else
			local targetSize = UDim2.fromOffset(main.AbsoluteSize.X * 0.95, main.AbsoluteSize.Y * 0.95)
			tween(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1, Size = targetSize})
			task.wait(0.4)
			main.Visible = false
		end
	end
	
	function window:GetState()
		return windowVisible
	end
	
	function window:Toggle()
		window:SetState(not windowVisible)
	end
	
	function window:SetKeybind(key)
		menuKeybind = key
	end
	
	function window:GetKeybind()
		return menuKeybind
	end
	
	function window:SetSize(size)
		main.Size = size
	end
	
	function window:GetSize()
		return main.Size
	end
	
	function window:SetAcrylicBlur(state)
		acrylicBlur = state
		main.BackgroundTransparency = state and 0.15 or 0
	end
	
	function window:GetAcrylicBlur()
		return acrylicBlur
	end
	
	function window:SetTheme(themeName)
		if not Ssoly.Themes[themeName] then return end
		theme = Ssoly.Themes[themeName]
		currentTheme = themeName
		
		main.BackgroundColor3 = theme.BG
		topbar.BackgroundColor3 = theme.TopBar
		cornerRepair.BackgroundColor3 = theme.TopBar
		sidebar.BackgroundColor3 = theme.BG
		title.TextColor3 = theme.Text
		searchBox.BackgroundColor3 = theme.Element
		searchIcon.TextColor3 = theme.TextDim
		searchInput.TextColor3 = theme.Text
		searchInput.PlaceholderColor3 = theme.TextDim
		displayName.TextColor3 = theme.Text
		username.TextColor3 = theme.TextDim
		resizeBarBottom.BackgroundColor3 = theme.Accent
		resizeBarRight.BackgroundColor3 = theme.Accent
		
		for _, stroke in ipairs(main:GetDescendants()) do
			if stroke:IsA("UIStroke") then
				stroke.Color = theme.Stroke
			end
		end
		
		for _, tab in pairs(tabs) do
			if tab.btn.BackgroundColor3 == theme.Accent or tab == tabs[1] then
				tab.btn.BackgroundColor3 = theme.Accent
				tab.indicator.BackgroundColor3 = theme.Accent
			else
				tab.btn.BackgroundColor3 = theme.Element
			end
		end
	end
	
	function window:GetTheme()
		return currentTheme
	end
	
	UIS.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == menuKeybind then
			window:Toggle()
		end
	end)
	
	function window:SaveConfig(name)
		return Ssoly:SaveConfig(name or configName)
	end
	
	function window:LoadConfig(name)
		return Ssoly:LoadConfig(name or configName)
	end
	
	function window:Destroy()
		if autoSave then
			Ssoly:SaveConfig(configName)
		end
		if blur then blur:Destroy() end
		gui:Destroy()
	end
	
	if autoSave then
		task.spawn(function()
			task.wait(0.5)
			Ssoly:LoadConfig(configName)
		end)
	end
	
	return window
end

return Ssoly
