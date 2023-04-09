BankRS_Config = {
    ["Robbery"] = {
	    ["Timer"] = 300, //The amount of time needed to finish a bank robbery.
		["Max_Distance"] = 700, //The maximum distance that you can go from the bank during a robbery.
		["Min_Cops"] = 1, //Minimum number of teams considered cops by the bank needed to start a robbery. (0 to disable)
		["Min_Bankers"] = 0, //Minimum number of teams considered bankers by the bank needed to start a robbery. (0 to disable)
	    ["Min_Players"] = 0, //Minimum of players needed to start a robbery. (0 to disable)
		["Killer_Reward"] = 19000, //The reward won by the player who kills the robber.
		["Should_Loop"] = true, //Should the siren sound loop?
		["Team_Required"] = { //The teams considered cops/robbers/bankers by the bank.
		    ["Cops"] = {"Police", "Police Chief"},
            ["Bankers"] = {"Banker", "Bank Owner"},
			["Robbers"] = {"Mob boss", "Gangster", "Hobo Boss", "Hobo", "Theif", "Citizen"},
		},
	},
	["Interest"] = {
		["Interest_Delay"] = 1, //The delay between increasing the bank's reward.
		["Interest_Amount"] = 14, //The amount to increase in each interest.
		["Base_Reward"] = 16745, //The base amount of money without any interest available to rob from the bank.
		["Reward_Max"] = 423657, //As high as interest can make the reward go.
	},
	["Cooldown"] = {
	    ["Timer"] = 600, //The amount of time that you need to wait before you can rob the bank again after a failed/sucessfull robbery.
	},
}