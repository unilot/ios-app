//
//  Constants.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

//    pod 'QRCodeReader.swift', '~> 8.0.3'


let is_mod_production          = true

let current_api_version            = "1.1.0"

// check for #removeNextBuild# in each build!!!!
let current_build              = "52"





let app_name                   = "Unilot"
let kFeedBackMail              = "mvp@unilot.io"

//MARK: -  LINKS

let kLink_FB            = "https://www.facebook.com/unilot.io/"
let kLink_LinkedIn      = "https://www.linkedin.com/company/unilot"
let kLink_Reddit        = "https://www.reddit.com/r/Unilot/"
let kLink_Twitter       = "https://twitter.com/unilot_platform"
let kLink_Telegram      = "https://t.me/Uniloteng"
let kLink_Steemit       = "https://steemit.com/@unilot"
let kLink_Medium        = "https://medium.com/@unilot"
let kLink_YouTube       = "https://www.youtube.com/channel/UCNdn2maOQEbYwpNK4Yaoxqw"


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
let kTypeToken = 70
let kTypeUndefined = 0
let kTypeProfileView = 666


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

let default_first_launch     = "&&\(kTypeProfileView)"

var lottery_images   = ["`1day-x3","`7days-x3","`31days-x3","`token-x3"]
var histiry_images   = ["`alldays-x3","`1day-x3","`7days-x3","`31days-x3","`token-x3" ]

var kTypeImage       = [kTypeDay : "`1day-x3", kTypeWeek : "`7days-x3", kTypeMonth : "`31days-x3",kTypeToken : "`token-x3"]
var kTypeTabBarOrder = [kTypeDay, kTypeWeek, kTypeMonth, kTypeToken]
var kCurrenciesTabBarOrder = [kETHGameCurrency, kETHGameCurrency, kETHGameCurrency, kUNITGameCurrency]


let staticClockNames =
    [
        ["hours","minutes","seconds"],
        ["days","hours","minutes",],
        ["weeks", "days","hours",]
]

var langCodes = ["en","ru"]
var langCodesImages = ["eng","rus"]

var langCodesSite = ["en-us","ru-ru"]


var setting_strings =  [ ["daily2","weekly2","bonus2","token2" ],  ["English","Русский"]]

var tabbar_strings =   ["daily1","weekly1","bonus1","token1"]
var history_tabbbar  =   ["all","daily1","weekly1","bonus1","token1"]

let kEmpty = ""

let kETHGameCurrency = "ETH"
let kUNITGameCurrency = "UNIT"


//MARK: - EVENTS

let kEVENT_menuLeft = ["EVENT_FB","EVENT_TG","EVENT_REDDIT","EVENT_TWITTER","EVENT_MEDIUM"]


let kEVENT_main_views = ["EVENT_DAILY", "EVENT_WEEKLY", "EVENT_BONUS",  "EVENT_TOKEN"]



let kEVENTS_middle : [Int : String] =  [kTypeDay : "DAILY", kTypeWeek : "WEEKLY", kTypeMonth : "BONUS", kTypeToken : "TOKEN"]


//MARK: - TAGS
let kTag_PopUp        = 6666666

//MARK: - COLORS

let kColorMenuDarkFon =  UIColor(red: 24.0/255.0, green: 24.0/255.0, blue: 30.0/255.0, alpha: 1)

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
