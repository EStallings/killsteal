
--[[========================================================================----
                     __ ________   __   _________________   __
                    / //_/  _/ /  / /  / __/_  __/ __/ _ | / /
                   / ,< _/ // /__/ /___\ \  / / / _// __ |/ /__
                  /_/|_/___/____/____/___/ /_/ /___/_/ |_/____/

----========================================================================]]--

require 'src/minion'
require 'src/utils'
require 'src/world'
--require 'src/entity'
require 'src/camera'
require 'src/enemy'
require 'src/player'
require 'src/bit'
require 'src/physics'
require 'src/aimodules'
require 'src/controls'

require 'src/modeGame'
require 'src/modeMenu'
require 'src/modeBuy'
require 'src/modeHelp'
require 'src/modePaused'

MODE = modeMenu

function love.load()
	initControls()
	MODE.load()
end

function love.update(dt)
	updateControls()
	MODE.update(dt)
end

function love.draw()
	MODE.draw()
end

function changeMode(mode)
	if MODE.exit then MODE.exit() end
	MODE = mode
	MODE.load()
end

--------------------------------------------------------------------------------

function love.keyreleased(key, unicode) if key == 'escape' then love.event.push('quit') end end
