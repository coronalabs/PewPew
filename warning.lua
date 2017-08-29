
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()


local function handleContinueButton( event )
	composer.setVariable( "userDevice", nil )
	composer.gotoScene( "main-menu", { effect="slideDown", time=600 } )
end


local function onInputDeviceStatusChanged( event )

	local isDeviceValid = composer.getVariable("isDeviceValid")

	if event.connectionStateChanged and event.device and isDeviceValid( event.device ) and event.device.isConnected == true then
		composer.gotoScene( "main-menu", { effect="slideDown", time=600 } )
	end
end


function scene:create( event )

	local sceneGroup = self.view
	
	local infoBoxBack = display.newRect( display.contentCenterX, display.contentCenterY - 50, display.contentWidth - 100, display.contentHeight - 200 )
	if themeName == "whiteorange" then infoBoxBack:setFillColor( 0.88 )
	elseif themeName == "lightgrey" then infoBoxBack:setFillColor( 0.98 )
	else infoBoxBack:setFillColor( 0.78 ) end
	sceneGroup:insert( infoBoxBack )
	
	-- Create the info text and anchoring box
	local infoText = display.newText( 
	{
		text = "\n" .. "Warning!" .. "\n\n" .. "This sample will not work on a mobile device unless a game controller is used",
    parent = sceneGroup,     
    x = display.contentCenterX,
    y = display.contentCenterY - 50,
    width = display.contentWidth - 100,
		height = display.contentHeight - 200,
    font = native.systemFont,   
    fontSize = 16,
    align = "center"
	} )
	infoText:setFillColor( 0 )
	sceneGroup:insert( infoText )
	
	-- Continue button
	local continueButton = widget.newButton{
		x = display.contentCenterX,
		y = display.contentHeight - 82,
		label = "Continue anyway",
		onPress = handleContinueButton,
		emboss = false,
		font = composer.getVariable("appFont"),
		fontSize = 17,
		shape = "rectangle",
		width = 200,
		height = 32,
		fillColor = {
			default={ (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 1 },
			over={ (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 0.8 }
		},
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	}
	sceneGroup:insert( continueButton )
end


function scene:show( event )

	if event.phase == "did" then
		Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
	elseif event.phase == "will" then
	end
end


function scene:hide( event )

	if event.phase == "will" then
		Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
	elseif event.phase == "did" then
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
