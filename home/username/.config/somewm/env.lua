local env = {}

env.terminal = "kitty"
env.launcher = "pkill -9 fuzzel || fuzzel"
env.super = "Mod4"
env.filemanager = "yazi"
env.home = os.getenv("HOME")

env.rice_point = env.terminal
	.. " --class "
	.. env.filemanager
	.. "_ricing"
	.. " "
	.. env.filemanager
	.. " "
	.. env.home
	.. "/.config/somewm/"

return env
