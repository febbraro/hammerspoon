---- Find your Hangout window and bring it to the forefront

local mod={}

mod.config={
  find_hangout_key = {{"ctrl", "alt"}, 'h'}
}

-- Toggle Skype between muted/unmuted, whether it is focused or not
function mod.findHangout()
  local found = false
  local chrome = hs.appfinder.appFromName("Google Chrome")
  if chrome then
    chromeScript = [[
      tell application "Google Chrome" 
        repeat with w in windows 
          set i to 0
          repeat with t in tabs of w 
            set i to i + 1
            if URL of t starts with "https://hangouts.google.com/hangouts/_" then
              activate
              set active tab index of w to i
              return true
            end if 
          end repeat
        end repeat
        return false
      end tell
    ]]
    ret, found = hs.osascript.applescript(chromeScript)
  end

  -- Try for Safari
  local safari = hs.appfinder.appFromName("Safari")
  if not found and safari then
    safariScript = [[
      tell application "Safari" 
        set windowCount to number of windows
        repeat with w from 1 to windowCount
          set tabCount to number of tabs in window w
          repeat with t from 1 to tabCount
            set currentTab to tab t of window w
            if URL of currentTab starts with "https://hangouts.google.com/hangouts/_" then
              activate
              tell front window of application "Safari"
                set current tab to tab t
                return true
              end tell
            end if 
          end repeat
        end repeat
        return false
      end tell
    ]]
    ret, found = hs.osascript.applescript(safariScript)
  end

  -- Future Support for Firefox

  if not found then
    hs.notify.show("Hangout Finder", "", "No active hangout was found")
  end
end

function mod.init(logger)
  mod.logger = logger
  hs.hotkey.bind(mod.config.find_hangout_key[1], mod.config.find_hangout_key[2], mod.findHangout)
end

return mod