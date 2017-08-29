
display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Pew Pew!", showBuildNum=false } )

local composer = require( "composer" )
local widget = require( "widget" )
local json = require( "json" )
local presetControls = require( "presetControls" )

local platform = system.getInfo( "platform" )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
display.getCurrentStage():insert( composer.stage )
display.getCurrentStage():insert( sampleUI.frontGroup )

composer.setVariable( "letterboxWidth", (display.actualContentWidth-display.contentWidth)/2 )
composer.setVariable( "letterboxHeight", (display.actualContentHeight-display.contentHeight)/2 )

-- Set app font
composer.setVariable( "appFont", sampleUI.appFont )


local function getEventDevice( event )
	return event.device and event.device.descriptor or "Keyboard"
end
-- Assign function to Composer variable for access in other modules
composer.setVariable( "getEventDevice", getEventDevice )


local function getNiceDeviceName( event )
	if event.device then
		return event.device.displayName
	else
		return "Keyboard"
	end
end
-- Assign function to Composer variable for access in other modules
composer.setVariable( "getNiceDeviceName", getNiceDeviceName )

local function isDeviceValid( device )
	return device and device.type ~= "touchscreen"
end
composer.setVariable( "isDeviceValid", isDeviceValid )

-- Load preset controller file
local controls = {}

if ( platform == "win32" or platform == "macos" ) then
	controls.Keyboard = presetControls.presetForKeyboard()
end

local inputDevices = system.getInputDevices()
for i = 1,#inputDevices do
	local device = inputDevices[i]
	if isDeviceValid( device ) then
		controls[device.descriptor] = presetControls.presetForDevice( device )
	end
end

composer.setVariable( "controls", controls )

local devicePlatform = system.getInfo( "platform" )
if ( ( devicePlatform == "ios" or devicePlatform == "android" ) and #inputDevices == 0 ) then
	composer.gotoScene( "warning" )
else
	composer.gotoScene( "main-menu" )
end

system.setIdleTimer( false )
