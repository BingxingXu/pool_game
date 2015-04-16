---
--Name:Snooker app
--
--A simple Snooker Game
--
--Version .2.7
--
--Dec.1.2013
--
--@author Bingxing Xu
--@author Chong Liu


---
--Reference
--
--Corona Labs Inc. SimplePoolPlus sample project (Version: 1.3)
--
--




local physics = require("physics")
physics.start()


--physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale( 60 )
physics.setGravity( 0, 0 )
display.setStatusBar( display.HiddenStatusBar )
--Constants
local spriteTime = 100 -- sprite itteration time
local animationStop = 2.8 -- Sprite Animation Stops Below this velocity
local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight --Screen Size properties
local ballBody = { density=0.8, friction=1.0, bounce=.7, radius=18 }
local onePlayer = 1
local twoPlayer = 2
local options = 3
local about = 4
local midPointX=384
local midPointY=794
local isStart = false

--
local gameOver
local mode
--Load Audio
local buzzAudio = audio.loadSound("sound/buzz.mp3")
local cueShot = audio.loadSound("sound/cueShot.mp3")
--local fallAudio = audio.loadSound("fall.mp3")
local bgm = audio.loadSound("sound/bgm2.mp3")
--default Skin type is one
--'1' classic
--'2' wood
--'3'
--'4'
local skintype = 1


---load skin
--
-------------------------------
function setSkin()
	if skintype == 1 then
		optionBKG = "images/optionsBG.jpg"
		onePlayerButton = "images/onePlayerButton.jpg"
		twoPlayerButton = "images/twoPlayerButton.jpg"
		optionsButton   = "images/optionsButton.jpg"
		table_bkg		= "images/table_bkg.jpg"
		newGameButton	= "images/newGameButton.jpg"
		resumeGameButton= "images/resumeGameButton.jpg"
		gameOver 		= "images/gameover.jpg"
		about			= "images/aboutButton.jpg"
		neonOn			= "images/neonOn.jpg"		--
		neonOff			= "images/neonOff.jpg"		--
		splashBKG		= "images/splash.jpg"		--
		playerOne 		= "images/player1.jpg"		--
		playerTwo		= "images/player2.jpg"		--
		solidScore		= "images/solidScore.jpg"	--
		stripeScore		= "images/stripeScore.jpg" --
		twoplayerBG		= "images/twoPlayerBG.jpg"
		lanButtonIcon	= "images/onLAN.jpg"
		localButtonIcon	= "images/thisDevice.jpg"
		backIcon		= "images/back.jpg"
		serverButtonIcon= "images/server.jpg"
		clientButtonIcon= "images/client.jpg"
	elseif skintype == 2 then
		optionBKG = "images/optionsBG_wood.jpg"
		onePlayerButton = "images/onePlayerButton_wood.jpg"
		twoPlayerButton = "images/twoPlayerButton_wood.jpg"
		optionsButton   = "images/optionsButton_wood.jpg"
		table_bkg		= "images/table_bkg_wood.jpg"
		newGameButton	= "images/newGameButton_wood.jpg"
		resumeGameButton= "images/resumeGameButton_wood.jpg"
		gameOver 		= "images/gameover_wood.jpg"
		about			= "images/aboutButton_wood.jpg"
		neonOn			= "images/neonOn_wood.jpg"		--
		neonOff			= "images/neonOff_wood.jpg"		--
		splashBKG		= "images/splash_wood.jpg"		--
		playerOne 		= "images/player1_wood.jpg"		--
		playerTwo		= "images/player2_wood.jpg"		--
		solidScore		= "images/solidScore_wood.jpg"	--
		stripeScore		= "images/stripeScore_wood.jpg" --
		twoplayerBG		= "images/twoPlayerBG_wood.jpg"
		lanButtonIcon	= "images/onLAN_wood.jpg"
		localButtonIcon	= "images/thisDevice_wood.jpg"
		serverButtonIcon= "images/server_wood.jpg"
		clientButtonIcon= "images/client_wood.jpg"

	elseif skintype ==3 then
		optionBKG = "images/optionsBG_ab.jpg"
		onePlayerButton = "images/onePlayerButton_ab.jpg"
		twoPlayerButton = "images/twoPlayerButton_ab.jpg"
		optionsButton   = "images/optionsButton_ab.jpg"
		table_bkg		= "images/table_bkg_ab.jpg"
		newGameButton	= "images/newGameButton_ab.jpg"
		resumeGameButton= "images/resumeGameButton_ab.jpg"
		gameOver 		= "images/gameover_ab.jpg"
		about			= "images/aboutButton_ab.jpg"
		neonOn			= "images/neonOn_ab.jpg"		--
		neonOff			= "images/neonOff_ab.jpg"		--
		splashBKG		= "images/splash_ab.jpg"		--
		playerOne 		= "images/player1_ab.jpg"		--
		playerTwo		= "images/player2_ab.jpg"		--
		solidScore		= "images/solidScore_ab.jpg"	--
		stripeScore		= "images/stripeScore_ab.jpg" --
		twoplayerBG		= "images/twoPlayerBG_ab.jpg"
		lanButtonIcon	= "images/onLAN_ab.jpg"
		localButtonIcon	= "images/thisDevice_ab.jpg"
		backIcon		= "images/back_ab.jpg"
		serverButtonIcon= "images/server_ab.jpg"
		clientButtonIcon= "images/client_ab.jpg"

	elseif skintype ==4 then

	end
end


-------
--
--


---Setup Splash Screen
--
--Corona Labs Inc, function splash()
------------------------------
function splash()



	splashGroup = display.newGroup()

	local splashBG = display.newImage(splashBKG,true,20, -5, true)
	splashGroup:insert(splashBG)

	local onePlayerButton = display.newImage( onePlayerButton, display.viewableContentWidth/4, display.viewableContentHeight/2- 110, true)
	onePlayerButton.id = onePlayer
	splashGroup:insert(onePlayerButton)

	local optionsButton = display.newImage( optionsButton, display.viewableContentWidth/4, display.viewableContentHeight/2+110, true)
	optionsButton.id = options
	splashGroup:insert(optionsButton)

	local aboutButton = display.newImage( about, display.viewableContentWidth/4, display.viewableContentHeight/2+220, true)
	aboutButton.id = about
	splashGroup:insert(aboutButton)

	local fillBot = display.newImage( "images/fill_bkg.jpg", true )
	fillBot.rotation=180; fillBot.x = 384; fillBot.y = 1117
	splashGroup:insert(fillBot)

	onePlayerButton:addEventListener("touch", init)
	optionsButton:addEventListener("touch", init)
	aboutButton:addEventListener("touch", init)

	buzzTimer =  timer.performWithDelay(400, buzzLogo, -1) --Loops buzz animation

---move bgm pasue icon to front
	bgmGroup:toFront()
end

-----------------------------------
--
--



---Buzzing Splashing screen animation
--
--Corona Labs Inc, function buzzLogo()
--------------------------------------------------------------------------------------------------
function buzzLogo()
	local buzzGroup = display.newGroup()
	local randBuzz = math.random(1,6)
	local animationOne = 1
	local animationTwo = 2

	local logo = display.newImage("images/logo.jpg",0,0,true)
	if randBuzz == animationOne then
		local buzzOn = display.newImage(neonOn , 150, 50, true)
		buzzGroup:insert(buzzOn)
		timer.performWithDelay(1000, function() buzzOn:removeSelf(); end, 1)

	elseif randBuzz >= animationTwo then
		local buzzOff = display.newImage( neonOff, 150, 50, true)

		buzzGroup:insert(buzzOff)
		timer.performWithDelay(1000, function() buzzOff:removeSelf() end, 1)
	end
end
-------
--
--




---Initializing Program
--
------------------------------
function init( event )

	mode = event.target.id

	if mode == onePlayer  then

		timer.cancel(buzzTimer)-- Remoes buzzing animation

		splashGroup:removeSelf()-- Removes splash screen objects

		timer.performWithDelay(800, onePlayerMode, 1)
	elseif mode == twoPlayer then

		timer.cancel(buzzTimer)-- Remoes buzzing animation

		splashGroup:removeSelf()-- Removes splash screen objects

		timer.performWithDelay(800, twoPlayerMode, 1)

	elseif mode == options then
		splashGroup:removeSelf()
		optionMenu()
	elseif mode == about then
		splashGroup:removeSelf()
		aboutAnimation()

	end


end
--------
--
--



---Option Menu
--
------------------------------
function optionMenu()

	local stroke = 5
	local optionsGroup = display.newGroup() --Create options menu group
	local optionsBG = display.newImage(optionBKG,-5,190,true)
	optionsGroup:insert(optionsBG)

	local skinIconGroup = display.newGroup()
	optionsGroup:insert(skinIconGroup)

	--skin 1
	function skin1(event)
		skintype = 1
		skinIconGroup.strokWidth = 0
		event.target.strokeWidth = stroke
	end
	local classic = display.newImage( "images/sample1.jpg", 49, 701, true )
	skinIconGroup:insert(classic)
	classic:addEventListener('touch', skin1)


	--skin 2
	function skin2(event)
		skintype = 2
		skinIconGroup.strokWidth = 0
		event.target.strokeWidth = stroke
	end
	local modern = display.newImage( "images/sample2.jpg", 219, 701, true )
	skinIconGroup:insert(modern)
	modern:addEventListener('touch', skin2)



	--skin 3
	function skin3(event)
		skintype = 3
		skinIconGroup.strokWidth = 0
		event.target.strokeWidth = stroke
	end
	local redFelt = display.newImage( "images/sample3.jpg", 392, 701, true )
	skinIconGroup:insert(redFelt)
	redFelt:addEventListener('touch', skin3)


	--skin 4
	function skin4(event)
		skintype = 1
		skinIconGroup.strokWidth = 0
		event.target.strokeWidth = stroke
	end
	local tealFelt = display.newImage( "images/sample4.jpg", 565, 701, true )
	skinIconGroup:insert(tealFelt)
	tealFelt:addEventListener('touch', skin4)
		--bgm 1

	--bgm 2

	--bgm 3

	--bgm 4


	--Back button
	function back()
		optionsGroup:removeSelf()
		timer.cancel(buzzTimer)-- Remoes buzzing animation
		--bgm
		--music
		setSkin()
		splash()
	end

	local goBack = display.newImage("images/goback.jpg",screenW-50,screenH-50,true)
	optionsGroup:insert(goBack)
	goBack:addEventListener("touch",back)

	selectSkin = display.newText("Select a table color!", 160, 625, systemFontBold, 50 )
	optionsGroup:insert(selectSkin)
	selectSkin:setTextColor(255,255,255)

	selectBGMText = display.newText("Select backgroud music!", 160, 360, systemFontBold, 50 )
	optionsGroup:insert(selectBGMText)
	selectBGMText:setTextColor(255,255,255)



end
---------
--
--

--About Animation
--
-----------------------------
function aboutAnimation()
	local aboutGroup = display.newGroup()
	local goBack = display.newImage("images/goback.jpg",screenW-50,screenH-50,true)
	aboutGroup:insert(goBack)


	local Producer=display.newText("Producer: \n   Bingxing Xu & Chong Liu",280,1300,systemFontBold,45)
	Producer.alpha=0
	local Executive=display.newText("Executive Director: \n   Bingxing Xu & Chong Liu",-120,1400,systemFontBold,45)
	Executive.alpha=0
	local SpEffect=display.newText("Special Effect: \n   Bingxing Xu ",280,1500,systemFontBold,45)
	SpEffect.alpha=0
	local SpecThank=display.newText("Special Thanks: \n   Angery Bird ",-120,1870,systemFontBold,45)
	SpecThank.alpha=0
	local bgmCR=display.newText("BGM: \n   School Days\n      by Maeda Jun",280,1670,systemFontBold,45)
	bgmCR.alpha=0

	aboutGroup:insert(Producer)
	aboutGroup:insert(Executive)
	aboutGroup:insert(SpEffect)
	aboutGroup:insert(SpecThank)
	aboutGroup:insert(bgmCR)

	timer.performWithDelay(500,
			function()
				transition.to( Producer, { alpha= 1, time=5000, x=350, y=350 } )
				transition.to( Executive, { alpha= 1, time=5000, x=348, y=470 } )
				transition.to( SpEffect, { alpha= 1, time=5000, x=240, y=580 } )
				transition.to( SpecThank, { alpha= 1, time=5000, x=250, y=900 } )
				transition.to( bgmCR, { alpha= 1, time=5000, x=250, y=770 } )
			end
	,1)

	local function aboutBack()
		aboutGroup:removeSelf()
		timer.cancel(buzzTimer)
		splash()
	end
	goBack:addEventListener("touch",aboutBack)

end
--------
--
--



---Game stages
--
--------------------------------
function gameStage()


	stageGroup = display.newGroup()


	local table = display.newImage( table_bkg, true)
	stageGroup:insert(table)
	table.x = 384
	table.y = 512

	--set bumps
	local bumperGroup = display.newGroup()		--Create bumper group and add it to stage group
	stageGroup:insert(bumperGroup)
	local bumperBody = { friction=0.5, bounce=0.5}
	local botBumper = display.newRect(171,984,424,0)
	local topBumper = display.newRect(171,40,424,0)
	local leftUpBumper = display.newRect(139,73,0,413)
	local leftDownBumper = display.newRect(139,538,0,413)
	local rightUpBumper = display.newRect(629,73,0,413)
	local rightDownBumper = display.newRect(629,538,0,413)
	bumperGroup:insert(botBumper)
	bumperGroup:insert(topBumper)
	bumperGroup:insert(leftUpBumper)
	bumperGroup:insert(leftDownBumper)
	bumperGroup:insert(rightUpBumper)
	bumperGroup:insert(rightDownBumper)

	-- add physics to bumps
	physics.addBody( topBumper, "static", bumperBody )
	physics.addBody( botBumper, "static", bumperBody )
	physics.addBody( leftUpBumper, "static", bumperBody )
	physics.addBody( leftDownBumper, "static", bumperBody )
	physics.addBody( rightUpBumper, "static", bumperBody )
	physics.addBody( rightDownBumper, "static", bumperBody )

	--set pocket
	createPockets()

	--Pause bottom
	pauseBtn = display.newImage("images/pause.jpg",720,screenH-49 )
	stageGroup:insert(pauseBtn)
	pauseBtn:addEventListener("touch",pauseMenu)

	--initial balls
	ballGroup = display.newGroup()
	setBalls()
	Runtime:addEventListener("tap",createCueBall)


	--bgm icon to front
	bgmGroup:toFront()

end
--------
--
--



---In game pause menu
--
------------------------------
function pauseMenu()
	pauseBtn:removeSelf()

	physics.pause()

	if mode==onePlayer then
		if isStart==true then timePasue() end
	end

	backDrop = display.newRect(0, 0, screenW, screenH )
	backDrop:setFillColor(0, 0, 0,100)

	pauseGroup = display.newGroup()
	pauseGroup:insert(backDrop)

	restartGameImage = display.newImage(newGameButton,200,200,true )
	pauseGroup:insert(restartGameImage)
	restartGameImage:addEventListener('touch', restartGame)

	resumeGameImage = display.newImage(resumeGameButton,200,350,true)
	pauseGroup:insert(resumeGameImage)
	resumeGameImage:addEventListener('touch',resumeGame)
end
--------
--
--



---Resume Game
--
---------------------------------
function resumeGame(event)

	pauseGroup:removeSelf()
	physics.start()
	if mode==onePlayer then
		if isStart==true then timeResume() end
	end
	--Pause bottom
	pauseBtn = display.newImage("images/pause.jpg",720,screenH-49 )
	pauseBtn:addEventListener("touch",pauseMenu)
	stageGroup:insert(pauseBtn)
end
---------
--
--



---New Game
--
--------------------------------
function restartGame(event)
	physics.start()

	if mode == onePlayer then
		isStart = false
	end
	if isCueBallOnTable==true then
		Runtime:removeEventListener("enterFrame", isCueBallStop)
	else
		Runtime:removeEventListener("tap",createCueBall)
	end

	stageGroup:removeSelf()
	ballGroup:removeSelf()
	pauseGroup:removeSelf()
	timer.performWithDelay(1000, splash, 1)

end
--------
--
--



---BGM pause
--
--------------------------------
function music(event)

	audio.play(bgm,{loops=-1,fadein=1000})

	bgmGroup = display.newGroup()

	local bgmpause = display.newImage("images/bgmpause.jpg",0,screenH-49,true)
	bgmGroup:insert(bgmpause)
	local bgmresume = display.newImage("images/bgmresume.jpg",0,screenH-49,true)
	bgmGroup:insert(bgmresume)
	bgmresume.isVisible =false



	function switch(event)
	if event.phase == "ended" then
		if bgmpause.isVisible == true then
			bgmpause.isVisible = false
			bgmresume.isVisible = true
			audio.pause(bgm)
		else
			bgmpause.isVisible = true
			bgmresume.isVisible = false
			audio.resume(bgm)
		end
	end
	end

bgmGroup:addEventListener("touch",switch)


end


--------
--
--


---One player mode
--
--------------------------------
function onePlayerMode()
	gameStage()

	local startTime
	local pasueStartTime
	local pasueLengthTime=0
	local pasueTimeTotal=0

	---start the timer for oneplayer
	function timeStart()
		startTime = os.time()

		---check the length of time about the gane
		function checkTime(event)
			local now = os.time()
			oneplayerScore.text = now - startTime - pasueTimeTotal
		end

		Runtime:addEventListener("enterFrame", checkTime)

	end

	---Pasue the timer for oneplayer
	function timePasue()
		pasueStartTime = os.time()

		function pasueLength(event)
			local now = os.time()
			pasueLengthTime = now - pasueStartTime
		end

		Runtime:removeEventListener("enterFrame", checkTime)
		Runtime:addEventListener("enterFrame", pasueLength)

		---Resume the timer for oneplayer
		function timeResume()
			pasueTimeTotal = pasueTimeTotal + pasueLengthTime
			Runtime:removeEventListener("enterFrame", pasueLength)
			Runtime:addEventListener("enterFrame", checkTime)
		end
	end

	---add time to the oneplayerScoreBoard because of foul
	function addTime()
		startTime = startTime -20
	end


	local oneplayerScoreBoard = display.newImage(solidScore)
		stageGroup:insert(oneplayerScoreBoard)
		oneplayerScoreBoard.y = 500; oneplayerScoreBoard.x = 53;

		oneplayerScore = display.newText(0, 0, 0, native.systemFontBold, 30 )
		oneplayerScore:setTextColor( 0, 255, 255 )
		oneplayerScore.x = 50; oneplayerScore.y = 400; oneplayerScore.rotation = 270
		stageGroup:insert(oneplayerScore)

		timer.performWithDelay(500,
			function()
				local player1 = display.newImage(playerOne)
				stageGroup:insert(player1)
				player1.y = display.contentHeight/2; player1.x = display.contentWidth/2; player1.alpha = 0;
				local player1 = transition.to( player1, { alpha= 1, time=400, x=53, y=500 } )
			end
		,1)


end
--------
--
--



---show foul message
--
--------------------------------
function foulOperation()
	local message = display.newImage("images/foul.jpg", screenW/2-100, screenH/2 + 100)
	if mode == onePlayer then
		addTime()
		timer.performWithDelay(1250,
			function()
				message.alpha = 1
				message = transition.to(message, {alpha= 0, time=800, x=53, y=540})
			end
		,1)
	end
	if mode == twoPlayer then
		timer.performWithDelay(1250,
			function()
				message.alpha = 1
				message = transition.to(message, {alpha= 0, time=800, x=53, y=540})
			end
		,1)
	end

end
-------
--
--


---create all the balls
--
--------------------------------
function setBalls()

	---set up black ball
	function setBlack()
		blackBall = display.newImage("images/blackball.jpg")
		blackBall.x =384
		blackBall.y =103
		physics.addBody(blackBall, ballBody)
		ballGroup:insert(blackBall)
		blackBall.id = "colorBall"
		blackBall.type = "blackBall"
		blackBall.score = 7
		blackBall.linearDamping = 0.3
		blackBall.angularDamping = 0.8
		blackBall.isBullet = true --physics body always awake
		blackBall.bullet = false
		blackBall.collision = onCollision
		blackBall:addEventListener("collision", blackBall)
	end


	---set up pink ball
	function setPink()
		pinkBall = display.newImage("images/pinkball.jpg")
		pinkBall.x = 384
		pinkBall.y = 347
		ballGroup:insert(pinkBall)
		physics.addBody(pinkBall, ballBody)
		pinkBall.id = "colorBall"
		pinkBall.type = "pinkBall"
		pinkBall.score= 6
		pinkBall.linearDamping = 0.3
		pinkBall.angularDamping = 0.8
		pinkBall.isBullet = true
		pinkBall.bullet = false
		pinkBall.collision = onCollision
		pinkBall:addEventListener("collision", pinkBall)
	end


	---set up blue ball
	function setBlue()
		blueBall = display.newImage("images/blueball.jpg",366,494)
		ballGroup:insert(blueBall)
		physics.addBody(blueBall, ballBody)
		blueBall.id = "colorBall"
		blueBall.type = "blueBall"
		blueBall.score = 5
		blueBall.linearDamping = 0.3
		blueBall.angularDamping = 0.8
		blueBall.isBullet = true
		blueBall.bullet = false
		blueBall.collision = onCollision
		blueBall:addEventListener("collision", blueBall)
	end

	---set up green ball
	function setGreen()
		greenBall = display.newImage("images/greenball.jpg",282,777)
		ballGroup:insert(greenBall)
		physics.addBody(greenBall, ballBody)
		greenBall.id = "colorBall"
		greenBall.type = "greenBall"
		greenBall.score = 3
		greenBall.linearDamping = 0.3
		greenBall.angularDamping = 0.8
		greenBall.isBullet = true
		greenBall.bullet = false
		greenBall.collision = onCollision
		greenBall:addEventListener("collision", greenBall)
	end


	---set up brown ball
	function setBrown()
		brownBall = display.newImage("images/zheball.jpg",366,777)
		ballGroup:insert(brownBall)
		physics.addBody(brownBall, ballBody)
		brownBall.id = "colorBall"
		brownBall.type = "brownBall"
		brownBall.score = 4
		brownBall.linearDamping = 0.3
		brownBall.angularDamping = 0.8
		brownBall.isBullet = true
		brownBall.bullet = false
		brownBall.collision = onCollision
		brownBall:addEventListener("collision", brownBall)
	end


	---set up yellow ball
	function setYellow()
		yellowBall = display.newImage("images/yellowball.jpg",450,777)
		ballGroup:insert(yellowBall)
		physics.addBody(yellowBall, ballBody)
		yellowBall.id = "colorBall"
		yellowBall.type = "yellowBall"
		yellowBall.score = 2
		yellowBall.linearDamping = 0.3
		yellowBall.angularDamping = 0.8
		yellowBall.isBullet = true
		yellowBall.bullet = false
		yellowBall.collision = onCollision
		yellowBall:addEventListener("collision", yellowBall)
	end


	---reset the color ball according to colorBallTYPE
	function resetColorBall(colorBallTYPE)
		if colorBallTYPE == "blackBall" then setBlack() end
		if colorBallTYPE == "pinkBall" then setPink() end
		if colorBallTYPE == "blueBall" then setBlue() end
		if colorBallTYPE == "greenBall" then setGreen() end
		if colorBallTYPE == "brownBall" then setBrown() end
		if colorBallTYPE == "yellowBall" then setYellow() end
	end


	---set up red balls
	function setReds()
		redBalls = {}
		redBalls[0] = display.newImage("images/redball.jpg",366,292)
		redBalls[1] = display.newImage("images/redball.jpg",348,260)
		redBalls[2] = display.newImage("images/redball.jpg",384,260)
		redBalls[3] = display.newImage("images/redball.jpg",330,228)
		redBalls[4] = display.newImage("images/redball.jpg",366,228)
		redBalls[5] = display.newImage("images/redball.jpg",402,228)
		redBalls[6] = display.newImage("images/redball.jpg",312,196)
		redBalls[7] = display.newImage("images/redball.jpg",348,196)
		redBalls[8] = display.newImage("images/redball.jpg",384,196)
		redBalls[9] = display.newImage("images/redball.jpg",420,196)
		redBalls[10] = display.newImage("images/redball.jpg",294,164)
		redBalls[11] = display.newImage("images/redball.jpg",330,164)
		redBalls[12] = display.newImage("images/redball.jpg",366,164)
		redBalls[13] = display.newImage("images/redball.jpg",402,164)
		redBalls[14] = display.newImage("images/redball.jpg",438,164)
		for i = 0, 14 do
			ballGroup:insert(redBalls[i])
			physics.addBody(redBalls[i], ballBody)
			redBalls[i].id = "redBall"
			redBalls[i].score = 1
			redBalls[i].linearDamping = 0.3
			redBalls[i].angularDamping = 0.8
			redBalls[i].isBullet = true
			redBalls[i].bullet = false
		end
		redTotal = 15 --the total num of redBalls on the table
	end





	setBlack()
	setPink()
	setBlue()
	setGreen()
	setBrown()
	setYellow()
	setReds()
	colorTotal = 6 -- the total num of color balls

	targetBall = "redBall"
	targetColor = "redBall"
	isCueBallOnTable=false

	---find the next target ball that should be hit
	function findTargetBall()
		if redTotal~=0 then
				targetBall = "redBall"
				targetColor = "redBall"
		else

			targetBall = "colorBall"

			if colorTotal==6 then
				targetColor = "yellowBall"

			elseif colorTotal==5 then
				targetColor = "greenBall"

			elseif colorTotal==4 then
				targetColor = "brownBall"

			elseif colorTotal==3 then
				targetColor = "blueBall"

			elseif colorTotal==2 then
				targetColor = "pinkBall"

			else
				targetColor = "blackBall"
			end
		end
	end
end
-------
--
--



---Create Cue ball
--
------------------------------------
function createCueBall(event)
	--check if the legal position of cue ball
	local distance=math.sqrt(math.pow(event.y-midPointY,2)+math.pow(event.x-midPointX,2))

	if event.y - midPointY<0 then
	--illegal position
	elseif distance>84 then
	--illegal position
	else
		if redTotal~=0 then targetBall = "redBall" end
		cueball = display.newImage("images/whiteball.jpg")
		ballGroup:insert(cueball)
		cueball.x = event.x
		cueball.y = event.y
		physics.addBody( cueball, ballBody )
		cueball.linearDamping = 0.3
		cueball.angularDamping = 0.8

		cueball.isBullet = true --stop passing through if every fast
		cueball.id = "cueBall"
		cueball.collision = onCollision

		-- Sprite balls start animation on Collision with cueball
		cueball:addEventListener("collision", cueball)

		cueball.postCollision = cueBallCollision

		Runtime:removeEventListener("tap",createCueBall)
		isCueBallOnTable=true

		--create Billiard Cue
		billiardCue = display.newRect(event.x,event.y,5,20)
		billiardCue.alpha = 0
		--cueball:addEventListener("touch",shot)

		cueball:addEventListener("touch",shot)

		if mode==onePlayer then
			if isStart == false then
				timeStart()
				isStart = true
			else
				timeResume()
			end
		end
	end
end
--------
--
--

---cueBallCollision
--
--check the first ball that cueball shot each time
--------------------------------------
function cueBallCollision(self,event)
	if event.other.id=="redBall" or event.other.id == "colorBall" then
		cueball:removeEventListener("postCollision", cueball)
		if event.other.id~=targetBall then
			foulOperation()
			findTargetBall()
		elseif event.other.id=="colorBall" and targetBall == "colorBall" then
			if targetColor=="NONE" then

			elseif event.other.type~=targetColor then
				foulOperation()
				findTargetBall()
			end
		end

		isHit=true
	end
end
-------
--
--


---isCueBallStop
--
--check if cueball is stopped
--then the next shot will be allowed
--------------------------------------
function isCueBallStop(event)
	local vx, vy = cueball:getLinearVelocity()

	if vx~=0 or vy ~=0 then

		cueball:removeEventListener("touch",shot)

	elseif vx==0 and vy ==0 then
		if isHit==false then
			foulOperation()
			findTargetBall()

		elseif isBallInPocket==false then
			findTargetBall()
		end
		cueball:addEventListener("touch",shot)
		Runtime:removeEventListener("enterFrame", isCueBallStop)

	end
end
-------
--
--


---shot the Cue ball
--
-- Corona Labs Inc, function cueShot( event )
-------------------------------------------
function shot( event )

	local t = event.target
	local phase = event.phase


	if "began" == phase then

		isBallInPocket=false

		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		billiardCue.x = t.x
		billiardCue.y = t.y

		startRotation = function()
			billiardCue.rotation = billiardCue.rotation + 4
		end

		Runtime:addEventListener( "enterFrame", startRotation )

		local showTarget = transition.to( target, { alpha=0.4, xScale=0.4, yScale=0.4, time=200 } )
		myLine = nil

	elseif t.isFocus then

		if "moved" == phase then

			if ( myLine ) then
				myLine.parent:remove( myLine ) -- erase previous line, if any
			end
			myLine = display.newLine( t.x,t.y, event.x,event.y )
			myLine:setColor( 255, 255, 255, 50 )
			myLine.width = 15

		elseif "ended" == phase or "cancelled" == phase then

			display.getCurrentStage():setFocus( nil )
			t.isFocus = false

			local stopRotation = function()
				Runtime:removeEventListener( "enterFrame", startRotation )
			end

			local hideTarget = transition.to( billiardCue, { alpha=0, xScale=1.0, yScale=1.0, time=200, onComplete=stopRotation } )

			if ( myLine ) then
				myLine.parent:remove( myLine )
			end

			-- Strike the ball!
			audio.play(cueShot)
			t:applyForce( (t.x - event.x), (t.y - event.y), t.x, t.y )

			isHit=false --false if no ball was hit
			Runtime:addEventListener("enterFrame",isCueBallStop)
			cueball:addEventListener("postCollision", cueball)
		end
	end

end
-------
--
--


--- Create pockets
--
---------------------------------
function createPockets()

	local pockets = {}
	local pocketsRadius = 15
	pockets[0]=display.newCircle(139,45,pocketsRadius)
	pockets[1]=display.newCircle(628,45,pocketsRadius)
	pockets[2]=display.newCircle(139,512,pocketsRadius)
	pockets[3]=display.newCircle(628,512,pocketsRadius)
	pockets[4]=display.newCircle(139,985,pocketsRadius)
	pockets[5]=display.newCircle(628,985,pocketsRadius)
	for i = 0, 5 do
		stageGroup:insert(pockets[i])
		pockets[i].isVisible = false
		physics.addBody( pockets[i], { radius=pocketsRadius, isSensor=true } )
		pockets[i].id = "pocket"
		pockets[i].bullet = false
		pockets[i].collision = setPocket
		pockets[i]:addEventListener( "collision", pockets[i] )
	end
end
-------
--
--


---Sets up pockets
--
-------------------------------
function setPocket( self, event )

	local function reset_color_ball()
		local ballType = event.other.type
		event.other:removeSelf()
		timer.performWithDelay(750,
			function()
				resetColorBall(ballType)
			end
		,1)
	end

	--fall down animation
	local fallDown = transition.to( event.other, { alpha=0, xScale=0.3, yScale=0.3, time=200 } )
	event.other:setLinearVelocity( 0, 0 )


	if event.other.id=="cueBall" then
		Runtime:removeEventListener("enterFrame", isCueBallStop)
		isCueBallOnTable=false
		foulOperation()
		if mode == onePlayer then
			timePasue()
		end
		event.other:removeSelf()
		Runtime:addEventListener("tap",createCueBall)

		findTargetBall()
		isBallInPocket=false
	elseif event.other.id=="redBall" then

		if targetBall~="redBall" then
			if isBallInPocket==true then
				targetBall="colorBall"
				targetColor="NONE"
				isBallInPocket=true
			else
				foulOperation()
				findTargetBall()
			end
		else
			targetBall="colorBall"
			targetColor="NONE"
			isBallInPocket=true
		end

		redTotal = redTotal -1
		event.other:removeSelf()


	elseif event.other.id =="colorBall" then
		if redTotal~=0 then

			if targetBall~="colorBall" then
				foulOperation()
			end

			findTargetBall()
			reset_color_ball()

		elseif redTotal==0 then

			if targetColor=="NONE" or isBallInPocket==true then
				findTargetBall()
				reset_color_ball()

			elseif event.other.type=="blackBall" and targetColor=="blackBall" then
				event.other:removeSelf()
				gameIsOver()

			elseif event.other.type=="pinkBall" and targetColor=="pinkBall" then
				event.other:removeSelf()
				colorTotal = 1
				findTargetBall()

			elseif event.other.type=="blueBall" and targetColor=="blueBall" then
				event.other:removeSelf()
				colorTotal = 2
				findTargetBall()

			elseif event.other.type=="brownBall" and targetColor=="brownBall" then
				event.other:removeSelf()
				colorTotal = 3
				findTargetBall()

			elseif event.other.type=="greenBall" and targetColor=="greenBall" then
				event.other:removeSelf()
				colorTotal = 4
				findTargetBall()

			elseif event.other.type=="yellowBall" then
				event.other:removeSelf()
				colorTotal = 5
				findTargetBall()

			else
				foulOperation()
				findTargetBall()
				reset_color_ball()
			end
		end

		isBallInPocket=true
	end
end
-------
--
--



---Game over
--
--------------------------------
function gameIsOver()
	if mode == onePlayer then
		isStart = false
	end
	if isCueBallOnTable==true then
		Runtime:removeEventListener("enterFrame", isCueBallStop)
	else
		Runtime:removeEventListener("tap",createCueBall)
	end

	stageGroup:removeSelf()
	ballGroup:removeSelf()

	local overSplash = display.newImage( gameOver, true )
	overSplash.alpha = 0
	overSplash.xScale = 1.5; overSplash.yScale = 1.5

	local showGameOver = transition.to( overSplash, { alpha=1.0, xScale=1.0, yScale=1.0, time=500 } )
	--cueball:removeEventListener( "touch", shot )

	local gameState = "gameOver"
	timer.performWithDelay(3500,
		function()
			overSplash:removeSelf()
			splash()
		end
	, 1)

end
--------
--
--




--- Start Splashh Screen
--Entry of The Program
setSkin()
music()
splash()

