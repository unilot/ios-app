//
//  Constants.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

//    pod 'QRCodeReader.swift', '~> 8.0.3'

 

let is_mod_production          = false

let current_version            = "1.0.0"
let current_build              = "20"

let app_name                   = "Unilot"

//MARK: -  LINKS

let kLink_FB            = "https://www.facebook.com/unilot.io/"
let kLink_LinkedIn      = "https://www.linkedin.com/company/unilot"
let kLink_Reddit        = "https://www.reddit.com/user/unilot_lottery/"
let kLink_Twitter       = "https://twitter.com/unilot_lottery"
let kLink_Telegram      = "https://t.me/unilot_channel"

let kLink_AppStore      = "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4"

let kLink_AppSite       = "https://unilot.io"

 


let kPDF_files = ["https://unilot.io//static/files/UNILOT_ENG.pdf",
                  "https://unilot.io//static/files/UNILOT_RUS.pdf"]



//MARK: -  games info

let kNullUserId = "0x0000000000000000000000000000000000000000"

let kTypeHour = 5
let kTypeDay = 10
let kTypeWeek = 30
let kTypeMonth = 50
let kTypeUndefined = 0
let kTypeProfile = 100


let kStatusUndefined = -1
let kStatusNoGame = 0
let kStatusPublished = 10
let kStatusFinishing = 15
let kStatusCancele  = 20
let kStatusComplete = 30

let kActionUpdate       = "game_updated"
let kActionFinishing    = "game_unpublished"
let kActionCompleted    = "game_finished"

let kActionStarted      = "game_started"
let kActionProlong      = "game_prolong"
let kActionUndefined    =  ""


let kGameStatusClosed   = 0
let kGameStatusOpened   = 1
let kGameStatusSleep    = 2


let kTimeForPreperationWait = 3600

var timeOfFlipperAnimation = 15.0

let staticClockSecondsStep = [1,60,3600]


//MARK: -  LOCALS



let default_first_launch     = "&&\(kTypeProfile)"

var lottery_images   = ["`1day-x3","`7days-x3","`31days-x3","`profile-x3"]
var histiry_images   = ["`alldays-x3","`1day-x3","`7days-x3","`31days-x3" ]

var kTypeImage       = [kTypeDay : "`1day-x3", kTypeWeek : "`7days-x3", kTypeMonth : "`31days-x3"]
var kTypeTabBarOrder = [kTypeDay, kTypeWeek, kTypeMonth, kTypeProfile]


let staticClockNames =
    [
        ["hours","minutes","seconds"],
        ["days","hours","minutes",],
        ["weeks", "days","hours",]
]

var langCodes = ["en","ru"]

var setting_strings =  [ ["daily2","weekly2","bonus2" ],  ["English","Русский"]]

var tabbar_strings =   ["daily1","weekly1","bonus1","profile"]
var history_tabbbar  =   ["all","daily1","weekly1","bonus1"]

let kEmpty = ""


//MARK: - EVENTS

let kEVENT_menuLeft = ["EVENT_FB","EVENT_TG","EVENT_REDDIT","EVENT_TWITTER"]


let kEVENT_main_views = ["EVENT_DAILY", "EVENT_WEEKLY", "EVENT_BONUS",  "EVENT_PROFIL"]



let kEVENTS_middle : [Int : String] =  [kTypeDay : "DAILY", kTypeWeek : "WEEKLY", kTypeMonth : "BONUS"]


//MARK: - TAGS
let kTag_PopUp        = 6666666

//MARK: - COLORS

let kColorHistoryGray   =  UIColor(red: 190.0/255.0, green:190.0/255.0, blue: 190.0/255.0, alpha: 1)
let kColorLightGray   =  UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1)
let kColorNormalGreen =  UIColor(red: 76.0/255.0, green: 215.0/255.0, blue: 100/255.0, alpha: 1)
let kColorLightOrange =  UIColor(red: 255.0/255.0, green: 152.0/255.0, blue: 140/255.0, alpha: 1)
let kColorLightYellow =  UIColor(red: 252.0/255.0, green: 223.0/255.0, blue: 138.0/255.0, alpha: 1)
let kColorMenuFon =  UIColor(red: 39.0/255.0, green: 39.0/255.0, blue: 56.0/255.0, alpha: 1)
let kColorSelectedBlue =  UIColor(red: 54.0/255.0, green: 102.0/255.0, blue: 241.0/255.0, alpha: 1)
let kColorMenuPeach    =  UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 167.0/255.0, alpha: 1)
let kColorBadge =  UIColor(red: 172.0/255.0, green: 41.0/255.0, blue: 74.0/255.0, alpha: 1)

let kColorDarkBlue =  UIColor(red: 15.0/255.0, green: 15.0/255.0, blue: 34.0/255.0, alpha: 0.9)

let kColorSoftGray =  UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 0.9)
let kColorHistoryDarkGray =  UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 0.9)
let kColorHistoryUnselectDarkGray =  UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 0.9)

let kColorGameUnselectGray =  UIColor(red: 142.0/255.0, green: 134.0/255.0, blue: 162.0/255.0, alpha: 0.9)



//MARK: - FONTS

let kFont_Bold          = "Roboto-Bold"
let kFont_Light         = "Roboto-Light"
let kFont_Medium        = "Roboto-Medium"
let kFont_Regular       = "Roboto-Regular"
let kFont_Thin          = "Roboto-Thin"
