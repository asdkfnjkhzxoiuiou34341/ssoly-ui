local Ssoly = loadstring(game:HttpGet("https://raw.githubusercontent.com/asdkfnjkhzxoiuiou34341/ssoly-ui/refs/heads/main/Ssoly.luau"))()

local Window = Ssoly:Window({
	Title = "Ssoly UI - Enhanced Demo",
	Theme = "Dark",
	Size = UDim2.fromOffset(750, 550),
	Keybind = Enum.KeyCode.RightControl,
	LoadingScreen = true,
	Blur = true,
	AcrylicBlur = true,
	AutoSave = true,
	ConfigName = "ssoly_demo"
})

-- Tab 1: Основные элементы
local MainTab = Window:Tab({Name = "Main", Icon = "7733955511"})

MainTab:Header({Text = "Основные элементы"})
MainTab:Paragraph({
	Header = "Добро пожаловать в Ssoly UI!",
	Body = "Это улучшенная демонстрация всех возможностей библиотеки. Попробуйте все элементы!"
})

MainTab:Button({
	Name = "Тестовая кнопка",
	Callback = function()
		Window:Notify({Title = "Успех", Description = "Кнопка работает!", Lifetime = 2})
	end
})

local toggle = MainTab:Toggle({
	Name = "Переключатель",
	Default = false,
	Flag = "MainToggle",
	Callback = function(state)
		print("Toggle:", state)
	end
})

local slider = MainTab:Slider({
	Name = "Слайдер значений",
	Min = 0,
	Max = 100,
	Default = 50,
	Flag = "MainSlider",
	Callback = function(value)
		print("Slider:", value)
	end
})

MainTab:Divider()

local dropdown = MainTab:Dropdown({
	Name = "Выпадающий список",
	Options = {"Опция 1", "Опция 2", "Опция 3", "Опция 4"},
	Default = "Опция 1",
	Flag = "MainDropdown",
	Callback = function(option)
		print("Dropdown:", option)
	end
})

local multiDropdown = MainTab:MultiDropdown({
	Name = "Множественный выбор",
	Options = {"Вариант A", "Вариант B", "Вариант C", "Вариант D"},
	Default = {"Вариант A"},
	Flag = "MainMultiDropdown",
	Callback = function(selected)
		print("MultiDropdown:", table.concat(selected, ", "))
	end
})

-- Tab 2: Ввод данных
local InputTab = Window:Tab({Name = "Input", Icon = "7733964126"})

InputTab:Header({Text = "Элементы ввода"})

local input = InputTab:Input({
	Name = "Текстовое поле",
	Placeholder = "Введите текст...",
	Default = "",
	Flag = "MainInput",
	Callback = function(text)
		print("Input:", text)
	end
})

local keybind = InputTab:Keybind({
	Name = "Горячая клавиша",
	Default = Enum.KeyCode.E,
	Flag = "MainKeybind",
	Callback = function(key)
		print("Keybind changed:", key.Name)
	end,
	OnPress = function()
		Window:Notify({Title = "Keybind", Description = "Горячая клавиша нажата!", Lifetime = 1})
	end
})

InputTab:Divider()

local colorPicker = InputTab:ColorPicker({
	Name = "Выбор цвета",
	Default = Color3.fromRGB(88, 101, 242),
	Flag = "MainColor",
	Callback = function(color)
		print("Color:", color)
	end
})

local label = InputTab:Label({Text = "Динамический текст"})

task.spawn(function()
	local counter = 0
	while task.wait(1) do
		counter = counter + 1
		label:Set("Счётчик: " .. counter)
	end
end)

-- Tab 3: Секции
local SectionTab = Window:Tab({Name = "Sections", Icon = "7733920644"})

SectionTab:Header({Text = "Секции и группировка"})

local Section1 = SectionTab:Section({Name = "Секция 1", Collapsed = false})

Section1:Toggle({
	Name = "Опция в секции 1",
	Default = true,
	Callback = function(state)
		print("Section1 Toggle:", state)
	end
})

Section1:Slider({
	Name = "Слайдер в секции",
	Min = 1,
	Max = 10,
	Default = 5,
	Callback = function(value)
		print("Section1 Slider:", value)
	end
})

local Section2 = SectionTab:Section({Name = "Секция 2 (Свёрнута)", Collapsed = true})

Section2:Button({
	Name = "Кнопка в секции 2",
	Callback = function()
		print("Section2 Button clicked")
	end
})

Section2:Input({
	Name = "Ввод в секции",
	Placeholder = "Текст...",
	Callback = function(text)
		print("Section2 Input:", text)
	end
})

Section2:ColorPicker({
	Name = "Цвет в секции",
	Default = Color3.fromRGB(255, 100, 100),
	Callback = function(color)
		print("Section2 Color:", color)
	end
})

-- Tab 4: Уведомления и диалоги
local NotifyTab = Window:Tab({Name = "Notifications", Icon = "7733992358"})

NotifyTab:Header({Text = "Уведомления и диалоги"})

NotifyTab:Button({
	Name = "Простое уведомление",
	Callback = function()
		Window:Notify({
			Title = "Информация",
			Description = "Это простое уведомление",
			Lifetime = 3
		})
	end
})

NotifyTab:Button({
	Name = "Уведомление с подтверждением",
	Callback = function()
		Window:Notify({
			Title = "Подтверждение",
			Description = "Нажмите галочку для подтверждения",
			Style = "Confirm",
			Lifetime = 0,
			Callback = function()
				print("Confirmed!")
			end
		})
	end
})

NotifyTab:Button({
	Name = "Уведомление с отменой",
	Callback = function()
		Window:Notify({
			Title = "Предупреждение",
			Description = "Нажмите крестик для отмены",
			Style = "Cancel",
			Lifetime = 0,
			Callback = function()
				print("Cancelled!")
			end
		})
	end
})

NotifyTab:Divider()

NotifyTab:Button({
	Name = "Диалоговое окно",
	Callback = function()
		Window:Dialog({
			Title = "Подтверждение действия",
			Description = "Вы уверены, что хотите продолжить?",
			Buttons = {
				{
					Name = "Да",
					Callback = function()
						Window:Notify({Title = "Успех", Description = "Действие выполнено!", Lifetime = 2})
					end
				},
				{
					Name = "Нет",
					Callback = function()
						Window:Notify({Title = "Отмена", Description = "Действие отменено", Lifetime = 2})
					end
				}
			}
		})
	end
})

NotifyTab:Button({
	Name = "Множественный выбор",
	Callback = function()
		Window:Dialog({
			Title = "Выберите действие",
			Description = "Что вы хотите сделать?",
			Buttons = {
				{Name = "Сохранить", Callback = function() print("Save") end},
				{Name = "Загрузить", Callback = function() print("Load") end},
				{Name = "Удалить", Callback = function() print("Delete") end},
				{Name = "Отмена", Callback = function() print("Cancel") end}
			}
		})
	end
})

NotifyTab:Button({
	Name = "Спам уведомлений (тест скролла)",
	Callback = function()
		for i = 1, 10 do
			Window:Notify({
				Title = "Уведомление #" .. i,
				Description = "Это тестовое уведомление для проверки скролла",
				Lifetime = 5
			})
			task.wait(0.1)
		end
	end
})

-- Tab 5: Настройки
local SettingsTab = Window:Tab({Name = "Settings", Icon = "7734053495"})

SettingsTab:Header({Text = "Настройки интерфейса"})

SettingsTab:Paragraph({
	Header = "Темы оформления",
	Body = "Выберите тему для изменения внешнего вида интерфейса"
})

local themeDropdown = SettingsTab:Dropdown({
	Name = "Тема",
	Options = {"Dark", "Light", "Ocean", "Amber", "Green", "Purple"},
	Default = "Dark",
	Callback = function(theme)
		Window:SetTheme(theme)
	end
})

SettingsTab:Divider()

SettingsTab:Toggle({
	Name = "Acrylic Blur",
	Default = true,
	Callback = function(state)
		Window:SetAcrylicBlur(state)
	end
})

SettingsTab:Keybind({
	Name = "Горячая клавиша меню",
	Default = Enum.KeyCode.RightControl,
	Callback = function(key)
		Window:SetKeybind(key)
	end
})

SettingsTab:Divider()

SettingsTab:Button({
	Name = "Сохранить конфигурацию",
	Callback = function()
		local success = Window:SaveConfig()
		if success then
			Window:Notify({Title = "Успех", Description = "Конфигурация сохранена!", Lifetime = 2})
		else
			Window:Notify({Title = "Ошибка", Description = "Не удалось сохранить", Lifetime = 2})
		end
	end
})

SettingsTab:Button({
	Name = "Загрузить конфигурацию",
	Callback = function()
		local success = Window:LoadConfig()
		if success then
			Window:Notify({Title = "Успех", Description = "Конфигурация загружена!", Lifetime = 2})
		else
			Window:Notify({Title = "Ошибка", Description = "Не удалось загрузить", Lifetime = 2})
		end
	end
})

-- Tab 6: Продвинутые функции
local AdvancedTab = Window:Tab({Name = "Advanced", Icon = "7734068321"})

AdvancedTab:Header({Text = "Продвинутые возможности"})

AdvancedTab:Paragraph({
	Header = "Работа с флагами",
	Body = "Флаги позволяют получать и устанавливать значения элементов программно"
})

AdvancedTab:Button({
	Name = "Получить значения флагов",
	Callback = function()
		print("=== Значения флагов ===")
		for flag, data in pairs(Ssoly.Flags) do
			print(flag .. ":", data.Get())
		end
	end
})

AdvancedTab:Button({
	Name = "Установить случайные значения",
	Callback = function()
		toggle:Set(math.random() > 0.5)
		slider:Set(math.random(0, 100))
		local options = {"Опция 1", "Опция 2", "Опция 3", "Опция 4"}
		dropdown:Set(options[math.random(1, 4)])
		colorPicker:Set(Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
		Window:Notify({Title = "Готово", Description = "Значения изменены!", Lifetime = 2})
	end
})

AdvancedTab:Divider()

AdvancedTab:Button({
	Name = "Обновить опции Dropdown",
	Callback = function()
		dropdown:Refresh({"Новая 1", "Новая 2", "Новая 3"})
		Window:Notify({Title = "Обновлено", Description = "Список опций изменён", Lifetime = 2})
	end
})

AdvancedTab:Button({
	Name = "Получить выбранные элементы",
	Callback = function()
		local selected = multiDropdown:Get()
		Window:Notify({
			Title = "Выбрано",
			Description = #selected > 0 and table.concat(selected, ", ") or "Ничего",
			Lifetime = 3
		})
	end
})

AdvancedTab:Divider()

AdvancedTab:Button({
	Name = "Скрыть/Показать окно",
	Callback = function()
		Window:Toggle()
	end
})

AdvancedTab:Button({
	Name = "Изменить размер окна",
	Callback = function()
		local sizes = {
			UDim2.fromOffset(600, 450),
			UDim2.fromOffset(800, 600),
			UDim2.fromOffset(900, 650)
		}
		Window:SetSize(sizes[math.random(1, #sizes)])
	end
})

AdvancedTab:Divider()

AdvancedTab:Header({Text = "Новые возможности"})

AdvancedTab:Button({
	Name = "Тест анимации закрытия",
	Callback = function()
		Window:Notify({
			Title = "Подсказка",
			Description = "Нажмите на кнопку закрытия (X) чтобы увидеть анимацию!",
			Lifetime = 3
		})
	end
})

AdvancedTab:Button({
	Name = "Тест ресайза окна",
	Callback = function()
		Window:Notify({
			Title = "Подсказка",
			Description = "Используйте палочки внизу и справа для изменения размера окна!",
			Lifetime = 4
		})
	end
})

AdvancedTab:Button({
	Name = "Тест ресайза сайдбара",
	Callback = function()
		Window:Notify({
			Title = "Подсказка",
			Description = "Потяните за разделитель между сайдбаром и контентом!",
			Lifetime = 4
		})
	end
})

-- Приветственное уведомление
Window:Notify({
	Title = "Добро пожаловать!",
	Description = "Ssoly UI успешно загружен. Изучите все возможности библиотеки!",
	Lifetime = 5
})
