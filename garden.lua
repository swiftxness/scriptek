local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Grow A Garden", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Collecting")

local Toggle = Tab:CreateToggle({
   Name = "Auto Collect",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      farming = Value

      local activationDistance = 60
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      while farming do
         for _, descendant in ipairs(workspace:GetDescendants()) do
         if descendant:IsA("ProximityPrompt") then
               local parentPart = descendant.Parent
               if parentPart and parentPart:IsA("BasePart") then
                  local distance = (parentPart.Position - hrp.Position).Magnitude
                  if distance <= activationDistance and descendant.Enabled then
                     -- Csak akkor aktiválunk, ha az ActionText "Collect"
                     if descendant.ActionText == "Collect" then
                           fireproximityprompt(descendant)
                           print("Prompt aktiválva:", descendant:GetFullName())
                     end
                  end
               end
            end
         end
         task.wait(0.3) -- fél másodperces ciklus
      end
   end,
})

local spamCollecting = false
local Toggle = Tab:CreateToggle({
   Name = "Auto Collect (E Spam)",
   CurrentValue = false,
   Flag = "ToggleESpam",
   Callback = function(Value)
      spamCollecting = Value
      if spamCollecting then
         task.spawn(function()
            local VirtualInputManager = game:GetService("VirtualInputManager")
            while spamCollecting do
               -- E billentyű lenyomásának szimulálása
               VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
               VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
               task.wait(0.01)
            end
         end)
      end
   end,
})

local Section = Tab:CreateSection("Selling")

local Button = Tab:CreateButton({
   Name = "Sell All",
   Callback = function()
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      -- 1. Elmentjük a jelenlegi koordinátákat
      local originalPosition = hrp.Position

      -- 2. Cél koordináták (pl. a teleportálni kívánt hely)
      local targetPosition = Vector3.new(61.5, 3, 0.42) -- Itt tetszőleges koordinátát adhatunk meg
      local targetCFrame = CFrame.new(targetPosition)

      -- 3. Teleportálunk a cél koordinátára
      hrp.CFrame = targetCFrame
      print("Teleported to target position:", targetPosition)

      -- 4. Lefuttatunk egy kódot itt, pl. valami funkciót vagy eseményt
      -- Például egyszerűen egy print üzenetet, de bármi más kód is lehet
      wait(0.3) -- Tetszőleges várakozás, ha szükséges
      game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()

      -- 5. Visszateleportálás az eredeti pozícióra
      task.delay(0.2, function() -- Kis késleltetés a visszateleportáláshoz
         hrp.CFrame = CFrame.new(originalPosition)
         print("Returned to original position:", originalPosition)
      end)
   end,
})

local Button = Tab:CreateButton({
   Name = "Sell Hand",
   Callback = function()
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      -- 1. Elmentjük a jelenlegi koordinátákat
      local originalPosition = hrp.Position

      -- 2. Cél koordináták (pl. a teleportálni kívánt hely)
      local targetPosition = Vector3.new(61.5, 3, 0.42) -- Itt tetszőleges koordinátát adhatunk meg
      local targetCFrame = CFrame.new(targetPosition)

      -- 3. Teleportálunk a cél koordinátára
      hrp.CFrame = targetCFrame
      print("Teleported to target position:", targetPosition)

      -- 4. Lefuttatunk egy kódot itt, pl. valami funkciót vagy eseményt
      -- Például egyszerűen egy print üzenetet, de bármi más kód is lehet
      wait(0.3) -- Tetszőleges várakozás, ha szükséges
      game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Item"):FireServer()

      -- 5. Visszateleportálás az eredeti pozícióra
      task.delay(0.2, function() -- Kis késleltetés a visszateleportáláshoz
         hrp.CFrame = CFrame.new(originalPosition)
         print("Returned to original position:", originalPosition)
      end)
   end,
})

local Section = Tab:CreateSection("Player")

local antiAfkActive = false
local antiAfkThread = nil

local Toggle = Tab:CreateToggle({
   Name = "Anti-Afk",
   CurrentValue = false,
   Flag = "AntiAfkToggle", -- Egyedi azonosító a konfigurációhoz
   Callback = function(Value)
      antiAfkActive = Value
      
      if antiAfkActive then
         -- Anti-Afk ciklus indítása
         antiAfkThread = task.spawn(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local hrp = character:WaitForChild("HumanoidRootPart")

            while antiAfkActive do
               -- Szimulálunk egy kis mozgást vagy ugrást
               humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
               task.wait(0.5)
               -- Visszaállítjuk a sétáló állapotot, ha szükséges
               if humanoid.MoveDirection.Magnitude == 0 then
                   humanoid:ChangeState(Enum.HumanoidStateType.Running)
               end
               task.wait(2) -- Várakozás a következő aktivitásig
            end
         end)
      else
         -- Anti-Afk kikapcsolása
         if antiAfkThread and coroutine.status(antiAfkThread) ~= "dead" then
            task.cancel(antiAfkThread)
            antiAfkThread = nil
         end
      end
   end,
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Sebesség beállító csúszka
local SpeedSlider = Tab:CreateSlider({
   Name = "Player Speed",
   Range = {0, 128},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 24,
   Flag = "SpeedSlider",
   Callback = function(Value)
      Humanoid.WalkSpeed = Value
   end,
})

-- Ugróerő beállító csúszka
local JumpSlider = Tab:CreateSlider({
   Name = "Player Jump-Power",
   Range = {0, 128},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      Humanoid.UseJumpPower = true
      Humanoid.JumpPower = Value
   end,
})

-- Noclip toggle
local noclipActive = false
local Toggle = Tab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      noclipActive = Value
      
      if noclipActive then
         -- Noclip bekapcsolása
         local player = game.Players.LocalPlayer
         local character = player.Character or player.CharacterAdded:Wait()
         
         -- Noclip ciklus indítása
         local noclipLoop = game:GetService("RunService").Stepped:Connect(function()
            if noclipActive and character and character:FindFirstChild("Humanoid") then
               for _, part in pairs(character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
            end
         end)
         
         -- Karakter újratöltődés esetén
         local characterAddedConnection
         characterAddedConnection = player.CharacterAdded:Connect(function(newCharacter)
            character = newCharacter
            if not noclipActive then
               characterAddedConnection:Disconnect()
               if noclipLoop then
                  noclipLoop:Disconnect()
               end
            end
         end)
         
         -- Tároljuk a kapcsolatokat egy változóban, hogy később leállíthassuk
         _G.noclipConnections = {
            noclipLoop = noclipLoop,
            characterAdded = characterAddedConnection
         }
      else
         -- Noclip kikapcsolása
         if _G.noclipConnections then
            if _G.noclipConnections.noclipLoop then
               _G.noclipConnections.noclipLoop:Disconnect()
            end
            if _G.noclipConnections.characterAdded then
               _G.noclipConnections.characterAdded:Disconnect()
            end
         end
         
         -- Visszaállítjuk az ütközéseket
         local player = game.Players.LocalPlayer
         local character = player.Character
         if character then
            for _, part in pairs(character:GetDescendants()) do
               if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                  part.CanCollide = true
               end
            end
         end
      end
   end,
})

local Section = Tab:CreateSection("GUIs")

local Toggle = Tab:CreateToggle({
   Name = "Seed Shop Toggle",
   CurrentValue = false,
   Flag = "SeedShopToggle", -- Egyedi azonosító a konfigurációhoz
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local seedShopGui = player:WaitForChild("PlayerGui"):FindFirstChild("Seed_Shop")

      if seedShopGui then
         seedShopGui.Enabled = Value
      else
         warn("Seed_Shop GUI nem található!")
      end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Gear Shop Toggle",
   CurrentValue = false,
   Flag = "SeedShopToggle", -- Egyedi azonosító a konfigurációhoz
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local seedShopGui = player:WaitForChild("PlayerGui"):FindFirstChild("Gear_Shop")

      if seedShopGui then
         seedShopGui.Enabled = Value
      else
         warn("Seed_Shop GUI nem található!")
      end
   end,
})

local selectedSeed = {}
local isBuying = false
local buyingThread = nil

local Dropdown = Tab:CreateDropdown({
   Name = "Autobuy Seeds",
   Options = {"None", "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cocoa", "Beanstalk"},
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "Dropdown1",
   Callback = function(Options)
      isBuying = false

      -- Várunk, hogy előző ciklus biztosan kilépjen
      task.wait()

      if #Options == 0 or (#Options == 1 and Options[1] == "None") then
         selectedSeed = {}
         return
      end

      selectedSeed = Options
      isBuying = true

      -- Új coroutine indítása
      buyingThread = coroutine.create(function()
         while isBuying do
            for _, seedName in ipairs(selectedSeed) do
               if seedName ~= "None" then
                  game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(seedName)
                  task.wait(0.01)
               end
            end
            task.wait(0.1)
         end
      end)
      coroutine.resume(buyingThread)
   end,
})

local selectedGear = {}
local isGear = false
local gearThread = nil

local Dropdown = Tab:CreateDropdown({
   Name = "Autobuy Gear",
   Options = {"None", "Watering Can", "Lightning Rod", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler"},
   CurrentOption = {"None"},
   MultipleOptions = true,
   Flag = "Dropdown2",
   Callback = function(Options)
      isGear = false

      -- Várunk, hogy az előző ciklus leálljon
      task.wait()

      if #Options == 0 or (#Options == 1 and Options[1] == "None") then
         selectedGear = {}
         return
      end

      selectedGear = Options
      isGear = true

      gearThread = coroutine.create(function()
         while isGear do
            for _, gearName in ipairs(selectedGear) do
               if gearName ~= "None" then
                  game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(gearName)
                  task.wait(0.01)
               end
            end
            task.wait(0.1)
         end
      end)
      coroutine.resume(gearThread)
   end,
})


local Section = Tab:CreateSection("Moonlit")

local Button = Tab:CreateButton({
   Name = "Set Pos1",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")
      pos1 = hrp.Position
      print("Pos1 set to:", pos1)
   end,
})

local Button = Tab:CreateButton({
   Name = "Set Pos2",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")
      pos2 = hrp.Position
      print("Pos2 set to:", pos2)
   end,
})

local selectedPlantSeed = ""
local Input = Tab:CreateInput({
   Name = "Seeds To Plant",
   CurrentValue = "",
   PlaceholderText = "Write the name of the seed like \"Tomato\" or \"Carrot\" (Case sensitive!)",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
   -- The function that takes place when the input is changed
   -- The variable (Text) is a string for the value in the text box
   selectedPlantSeed = Text -- Frissítjük a változót a beviteli mező tartalmával
   print("Input mező értéke megváltozott: ", Text)
   end,
})

local Button = Tab:CreateButton({
   Name = "Plant Seeds for Moonlit",
   Callback = function()
      -- Ellenőrizzük, hogy a pos1 és pos2 változók léteznek-e
      if not pos1 or not pos2 then
         Rayfield:Notify({
            Title = "Hiba",
            Content = "Először állítsd be a Pos1 és Pos2 pozíciókat!",
            Duration = 5,
            Image = 4483362458,
            Actions = {
               Ignore = {
                  Name = "Rendben",
                  Callback = function()
                     -- Nincs további művelet
                  end
               },
            },
         })
         return -- Kilépünk a funkcióból, ha nincsenek beállítva a pozíciók
      end
      
      -- Fix y érték beállítása mindkét vektorhoz
      local fixedY = 0.13552513718605042 -- A magasságot fixen 0.13552513718605042-re állítjuk
      -- Két sarok koordináta, de az y értéket a fixedY-ra állítjuk
      local x1, _, z1 = pos1.X, fixedY, pos1.Z
      local x2, _, z2 = pos2.X, fixedY, pos2.Z
      -- Koordináták rendezése
      local minX, maxX = math.min(x1, x2), math.max(x1, x2)
      local minZ, maxZ = math.min(z1, z2), math.max(z1, z2)
      local step = 2 -- Ültetési távolság (igény szerint állítható)
      -- Az Input1 mezőből vesszük a növény nevét a tárolt változóból
      local seedName = selectedPlantSeed

      print("Ültetendő mag: ", seedName) -- Kiírjuk a mag nevét

      -- Ellenőrizzük, hogy a mag neve nem üres, mielőtt elküldjük a szervernek
      if seedName == "" then
         Rayfield:Notify({
            Title = "Hiba",
            Content = "Kérlek, írd be az ültetendő mag nevét!",
            Duration = 5,
            Image = 4483362458,
            Actions = {
               Ignore = {
                  Name = "Rendben",
                  Callback = function() end
               },
            },
         })
         return -- Kilépünk a funkcióból, ha üres a mag neve
      end

      for x = minX, maxX, step do
         for z = minZ, maxZ, step do
            if seedName == "Watercan" then
               local args = {
                  Vector3.new(x, fixedY, z)
               }
               game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Water_RE"):FireServer(unpack(args))
            else
               local args = {
                  Vector3.new(x, fixedY, z),
                  seedName
               }
               game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
            end
            task.wait(0.05) -- Kis várakozás, hogy ne legyen túl gyors
         end
      end
   end,
})

local Button = Tab:CreateButton({
   Name = "Submit All Plants",
   Callback = function()
      local args = {
         "SubmitAllPlants"
      }
      game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer(unpack(args))      
   end,
})
