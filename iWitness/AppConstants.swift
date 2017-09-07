//
//  AppConstants.swift
//  iWitness
//
//  Created by Sravani on 24/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import Foundation
import AFNetworking

let AppClientId = "1ef28784-23f8-11e4-b8aa-000c29c9a052"
let AppClientSecret = "26b30aba-23f8-11e4-b8aa-000c29c9a052"
let kAppDelegate  =     UIApplication.shared.delegate as! AppDelegate
let kAppController = kAppDelegate.appController
let kUtilities =    Utilities.sharedInstance
let kUserPreferences = UserPreferences.sharedInstance
let kNetworkManager = NetworkManager.sharedInstance
let kLocation = LocationManager.sharedInstance


//Notification names

let kNotification_LocationUpdated =  "kNotification_LocationUpdated"
let kNotification_EmergencyNumberChanged  = "EmergencyNumberChanged"
let kNotification_CallBtntapped  = "CallBtnTapped"
let kNotification_DoLogoutAllDevices  = "DoLogoutAllDevices"



let kIcn_Check01    =     UIImage(named: "icnCheck01")
let kIcn_Uncheck01  = UIImage(named: "icnUncheck01")

let kLightGrayColor =  UIColor.lightGray.cgColor
let kAppDefaultTime = 600

//Gender
let kGender_Male                                                                              =  0
let kGender_Female                                                                            =  1

let kSubscription_Annual                                                                      =  "com.iwitness.yearly_subscribe_ar_new"
let kSubscription_Monthly                                                                     = "com.iwitness.monthly_subscribe_ar_new"

let kText_DefaultTimezone                                                                     =  "(UTC -07:00) America/Los_Angeles"


let kText_911_IS_BEING_CALLED                                                              =   "The Police are being called!"


let kCapText_ARM_IWITNESS                                                                     =   "ARM iWitness"
let kCapText_OK                                                                               =  "OK"
let kCapText_OR                                                                               =  "OR"
let kCapText_REC                                                                              =  "REC"
let kCapText_STOP                                                                             =  "STOP"


let kText_Address                                                                             =  "Address"
let kText_AppName                                                                             =  "iWitness"
let kText_Back                                                                                =  "Back"
let kText_Call911                                                                             =  "Call %@"
let kText_Camera                                                                              =  "Camera"
let kText_Cancel                                                                              =  "Cancel"
let kText_CannotAddMoreEmergencyContact                                                       =  "Cannot add more than 6 emergency contacts."
let kText_City                                                                                =  "City"
let kText_ChangePassword                                                                      =  "Update Password"
let kText_Contacts                                                                            =  "Contacts"
//let kText_ConfirmSkipEmergencyContact                                                         =  "Are you sure you want to skip this step? If you are in danger no one will be alerted!"
//let kText_ConfirmSkipProfile                                                                  =  "Are you sure you want to skip this? Once you leave the app you won't be able to log-in and use iWitness as we need this basic information to set up your account."
let kText_ConfirmNewPassword                                                                  =  "Confirm New Password"
let kText_ConfirmPassword                                                                     =  "Confirm Password"
let kText_Continue                                                                            =  "Continue"
let kText_CouldNotConnectToServer                                                             =  "Could not connect to server at the moment."
let kText_CouldNotConnectToiTunes                                                             =  "Could not connect to iTunes at the moment."
let kText_CouldNotCreateEmergencyContact                                                      =  "Could not create emergency contact at the moment."
let kText_CouldNotDelete_updateEmergencyContact                                                      =  "Could not process your request at the moment."
let kText_CouldNotLoadEmergencyContactList                                                    =  "Could not load emergency contact list at the moment."
let kText_CouldNotLoadEvents                                                                  =  "Could not load events at the moment."
let kText_CouldNotDeleteVideo                                                                 =  "Could not delete video."
let kText_InvalidLocation                                                                     =  "Based on your location, this is not a valid option."
let kText_CouldNotSendInvitation                                                              =  "Could not send invitation to your friends at the moment."
let kText_CouldNotResetPassword                                                               =  "Could not send email to restore password at the moment."
let kText_NetworkNotAvailable                                                                 =  "Network is not available."
let kText_CouldNotSendSubscription                                                            =  "Could not send subscription at the moment. Please try again."
let kText_CouldNotUpdateAccount                                                               =  "Could not update account info at the moment."
let kText_CouldNotUpdateAddress                                                               =  "Could not update address at the moment."
let kText_CouldNotUpdateEmergencyContact                                                      =  "Could not update emergency contact at the moment."
let kText_CouldNotUpdatePassword                                                              =  "Could not update your password at the moment."
let kText_CouldNotUpdateUserProfileImage                                                      =  "Could not update user's profile photo at the moment."
let kText_CurrentPassword                                                                     =  "Current Password"
// D
let kText_DeleteContact                                                                       =  "Delete Contact"
let kText_Dismiss                                                                             =  "Dismiss"
let kText_DistinguishingFeatures                                                              =  "Distinguishing Features"
// E
let kText_Edit                                                                                =  "Edit"
let kText_Understand                                                                          =  "I Understand"
let kText_Email                                                                               =  "Email"
let kText_EmailAddress                                                                        =  "Email Address"
let kText_EmergencyContact                                                                    =  "Emergency Contact"
let kText_EmergencyPhoneChanged                                                               =  "We have detected a different emergency number for your current location. Change from %@ to %@?"
let kText_EnableShake                                                                         =  "Shake to Call"
let kText_EnableTorch                                                                         =  "Strobe Light"
let kText_Error                                                                               =  "Error"
let kText_Ethnicity                                                                           =  "Ethnicity"
let kText_EyeColor                                                                            =  "Eye Color"
let kText_Timezone                                                                            =  "Timezone"
// F
let kText_Female                                                                              =  "Female"
let kText_FirstEmergencyContactWelcome                                                        =  "To get the most from iWitness, it's important that you add emergency contacts who you want notified whenever you trigger a 911 call via iWitness. Listing all six possible contacts will increase the chances of someone noticing the alert and responding quickly."
let kText_FirstName                                                                           =  "First Name"
let kText_FullName                                                                            =  "Full Name"
// G
// H
let kText_HairColor                                                                           =  "Hair Color"
let kText_Height                                                                              =  "Height"
let kText_HeightAndWeight                                                                     =  "Height and Weight"
let kText_Home                                                                                =  "Home"
// I
let kText_NoNetWorkMessage                                                                         = "Internet Connection appears to be offline."
let kText_Info                                                                                =  "Info"
let kText_InvalidCurrentPassword                                                              =  "Invalid current password. A valid password must be at least 8 characters, must contain at least one upper case, one lower case, and one number."
let kText_InvalidConfirmPassword                                                              =  "Password and confirm password do not match."
let kText_InvalidEmailAddress                                                                 =  "Invalid email address format."
let kText_InvalidEmergencyPhone1                                                              =  "Emergency contact's mobile number cannot be the same as your mobile number."
let kText_InvalidEmergencyPhone2                                                              =  "Emergency contact's mobile number cannot be the same as your alternative mobile number."
let kText_InvalidEmergencyPhoneAlt1                                                           =  "Emergency contact's alternative mobile number cannot be the same as your mobile number."
let kText_InvalidEmergencyPhoneAlt2                                                           =  "Emergency contact's alternative mobile number cannot be the same as your alternative mobile number."
let kText_EmptyUserName                                                                     =  "UserName should not be empty."
let kText_EmptyAddress1                                                                     =  "Address field should not be empty."
let kText_InvalidNewPassword                                                                  =  "Invalid new password. A valid password must be at least 8 characters, must contain at least one upper case, one lower case and one number."
let kText_InvalidPassword                                                                     =  "Invalid password format. A valid password must be at least 8 characters, must contain at least one upper case, one lower case and one number."
let kText_InvalidRecordTime                                                                   =  "Please increase the recording time to at least 30 seconds."
let kText_InvalidUSPhone                                                                      =  "Invalid mobile number format."
let kText_InvalidUSPhoneAlternative                                                           =  "Invalid alternative mobile number format."
let kText_InvalidNewConfirmPassword                                                           =  "New password and confirm password does not match."
let kText_InvalidNew_OldPassword                                                           =  "Old and New password should not be same."


// J
// K
// L
let kText_LastName                                                                            =  "Last Name"
let kText_Login                                                                               =  "Login"
// M
let kText_Male                                                                                =  "Male"
// N
let kText_NoNetWorkTitle                                                                         = "Network Error"
let kText_Name                                                                                =  "Name"
let kText_NewPassword                                                                         =  "New Password"
let kText_No                                                                                  =  "No"
let kText_NoEvents                                                                            =  "You currently have no videos to view. After you record an event via the iWitness app, you may view videos in app. They will be stored on our secure servers and are not able to be deleted via the app."
// O
let kText_OneOfInputEmailIsIncorrect                                                          =  "One of input email addresses is incorrect. Please check and try again."
// P
let kText_EmailIsIncorrect                                                                    =  "The input email addresses is incorrect. Please check and try again."
let kText_Password                                                                            =  "Password"
let kText_Pending                                                                             =  "Pending"
let kText_Accepted                                                                            =  "Accepted"
let kText_PersonalizedMessage                                                                 =  "Personalized message"
let kText_Phone                                                                               =  "Mobile"
let kText_PhoneNumber                                                                         =  "Mobile Number"
let kText_PhoneNumberAlternative                                                              =  "Alternative Mobile Number"
let kText_PhotoLibrary                                                                        =  "Photo Library"
let kText_Profile                                                                             =  "Profile"


// Q
// R
let kText_Register                                                                            =  "Sign Up For iWitness"
let kText_ForgotPassword                                                                      =  "Forgot Password"
let kText_Rejected                                                                            =  "Rejected"
let kText_Relationship                                                                        =  "Relationship"
let kText_RequireCurrentPassword                                                              =  "Please enter current password."
let kText_RequireConfirmPassword                                                              =  "Please enter confirm password."
let kText_RequireEmailAddress                                                                 =  "Please enter email address."
let kText_RequireEmergencyEmail                                                               =  "Please enter email address."
let kText_RequireEmergencyPhone                                                               =  "Please enter mobile number."
let kText_RequireFirstname                                                                    =  "Please enter first name."
let kText_RequireFriendEmails                                                                 =  "Please enter friends' email addresses."
let kText_RequireLastname                                                                     =  "Please enter last name."
let kText_RequireNewConfirmPassword                                                           =  "Please enter confirm password."
let kText_RequireNewPassword                                                                  =  "Please enter new password."
let kText_RequirePassword                                                                     =  "Please enter password."
let kText_RequirePhone                                                                        =  "Please enter mobile number."
let kText_RequireRelation    =     "Please enter your relationship with the contact."
let kText_RecordingTimerText  =        "Recording will automatically stop when timer reads 0:00"

// S
let kText_StreamingText = "Streaming to secure server..."

let kText_SaveAndContinue                                                                     =  "Save & Continue"
let kText_SelectSubscription                                                                  =  "Please select a subscription."
let kText_Settings                                                                            =  "Settings"
let kText_Share                                                                               =  "Share"
let kText_Skip                                                                                =  "Skip"
let kText_State                                                                               =  "State"
let kText_SubscriptionExpired                                                                 =  "Subscription Expired"
let kText_SuccessCreateEmergencyContact                                                       =  "Success create new emergency contact."
let kText_SuccessDeleteEmergencyContact                                                       =  "Success delete emergency contact."
let kText_SuccessInviteYourFriends                                                            =  "Invitation sent successfully."
let kText_DisclaimerAlertTxt                                                                  =  "iWitness relies upon the proper functioning of your smartphone, its software and your data plan. It requires a reserve of battery power, ringer set to high, and a strong network connection. All or some of these elements are subject to failure. There is no guarantee that even iWitness' proper operation will prevent harm to you or your property."
let kText_EmergencyTextMessage   =                      "I've made it to my destination safely."  //"EMERGENCY - iWitness App \n !!Need your immediate attention. Pls acknowledge. !!" // "I've made it to my destination safely."



let kText_SuccessForgotPassword                                                               =  "We just sent an email on how to restore your password."
let kText_SuccessUpdateAddress                                                                =  "Success update address."
let kText_SuccessUpdateEmergencyContact                                                       =  "Success update emergency contact."
let kText_SuccessUpdatePassword                                                               =  "Success update your password."
let kText_SuccessUpdateAccount                                                                =  "Success update account info."
let kText_SuccessUpdateUserProfileImage                                                       =  "Success update user's profile photo."
// T
let kText_TimeToRecordAnEvent                                                                 =  "Time to record an event"
// U
let kText_UpdatePhoneNumber                                                                   =  "Enter your password to confirm this update."
// V
let kText_Videos                                                                              =  "Videos"
// W
let kText_Warning                                                                             =  "Warning"
let kText_Expired                                                                             =  "Expired"
let kText_WarningUpper                                                                        =  "WARNING"
let kText_Weight                                                                              =  "Weight"
// X
// Y
let kText_Yes                                                                                 =  "Yes"
let kText_DeleteEvent                                                                         =  "Delete Event Confirmation"
let kText_DeleteEvent_Detail                                                                  =  "Would you like to delete this event?"
let kText_RenewSubscription                                                                   =  "Please renew your subscription to restore full app functionality."
// Z
let kText_Zipcode                                                                             =  "Zip Code"
let kTagText_ChooseSubscription                                                               =  "Choose your subscription:"

let myowndefaults = UserDefaults.standard

let _g_stateCode : [String] =  ["AL","AK","AS","AZ","AR",
    "CA","CO","CT",
    "DE","DC",
    "FL","GA","GU",
    "HI","ID","IL","IN","IA",
    "KS","KY","LA","LAS",
    "ME","MD","MA","MI",
    "MN","MS","MO","MT",
    "NE","NV","NH","NJ",
    "NM","NY","NC","ND",
    "MP",
    "OH","OK","OR","PA","PR",
    "RI",
    "SC","SD","TN","TX",
    "UT","VT","VA","VI",
    "WA","WV","WI","WY"]

let _g_stateName : [String] =  ["Alabama"       ,"Alaska"              ,"American Samoa","Arizona"       ,"Arkansas",
    "California"    ,"Colorado"            ,"Connecticut"   ,
    "Delaware"      ,"District of Columbia",
    "Florida"       ,"Georgia"             ,"Guam"          ,
    "Hawaii"        ,"Idaho"               ,"Illinois"      ,"Indiana"       ,"Iowa",
    "Kansas"        ,"Kentucky"            ,"Louisiana"     ,"Los Angeles"   ,
    "Maine"         ,"Maryland"            ,"Massachusetts" ,"Michigan"      ,
    "Minnesota"     ,"Mississippi"         ,"Missouri"      ,"Montana"       ,
    "Nebraska"      ,"Nevada"              ,"New Hampshire" ,"New Jersey"    ,
    "New Mexico"    ,"New York"            ,"North Carolina","North Dakota"  ,
    "Northern Marianas Islands",
    "Ohio"          ,"Oklahoma"            ,"Oregon"        ,"Pennsylvania"  ,"Puerto Rico",
    "Rhode Island"  ,
    "South Carolina","South Dakota"        ,"Tennessee"     ,"Texas"         ,
    "Utah"          ,"Vermont"             ,"Virginia"      ,"Virgin Islands",
    "Washington"    ,"West Virginia"       ,"Wisconsin"     ,"Wyoming"]

let _keyeColor : [String] = ["Black eyes","Blue eyes","Brown eyes","Gray eyes","Green eyes","Hazel eyes","Other colored eyes"]
let _kEthnic : [String] = ["Asian/Pacific Islander", "Black/African American", "Hispanic/Latino", "Native American", "White/Caucasian", "Other"]
let _khairColor : [String] = ["Black hair","Blond(e) hair","Brown hair","Gray hair","Red hair","White hair","Other colored hair"]


let _g_EmergencyPhone:NSDictionary  =  ["Algeria":"17",
    "Cameroon":"17",
    "Chad":"17",
    "Djibouti":"17",
    "Egypt":"122",
    "Ghana":"191",
    "Mali":"17",
    "Mauritius":"999",
    "Morocco - City":"19",
    "Morocco - Royal Gendarmerie":"177",
    "Nigeria":"",
    "South Africa":"10111",
    "Tunisia":"197",
    "Rwanda":"112",
    "Uganda Option 1":"999",
    "Uganda Option 2":"112",
    "Sudan":"",
    "Sierra Leone":"019",
    "Zambia":"999",
    "Zimbabwe":"995",
    "Afghanistan":"119",
    "Bangladesh":"999",
    "Bahrain":"",
    "Cambodia":"",
    "East Timor":"",
    "China":"110",
    "Myanmar":"",
    "Hong Kong":"112",
    "India":"100",
    "Indonesia":"110",
    "Iran":"110",
    "Israel":"100",
    "Japan":"110",
    "Jordan":"",
    "Kazakhstan":"102",
    "North Korea":"112",
    "South Korea":"112",
    "Kuwait":"777",
    "Lebanon Option 1":"112",
    "Lebanon Option 2":"999",
    "Macau":"",
    "Maldives":"119",
    "Malaysia":"112",
    "Mongolia":"102",
    "Nepal Option 1":"100",
    "Nepal Option 2":"103",
    "Oman":"",
    "Pakistan":"15",
    "Philippines":"112",
    "Qatar":"",
    "Saudi Arabia":"999",
    "Singapore":"999",
    "Sri Lanka Option 1":"118",
    "Sri Lanka Option 2":"119",
    "Syria":"112",
    "Taiwan":"110",
    "Tajikistan":"102",
    "Thailand":"191",
    "United Arab Emirates Option 1":"999",
    "United Arab Emirates Option 2":"112",
    "Vietnam":"113",
    "Albania":"129",
    "Armenia":"",
    "Austria":"",
    "Azerbaijan":"102",
    "Belarus":"102",
    "Belgium":"",
    "Bosnia and Herzegovina":"122",
    "Bulgaria":"",
    "Croatia":"",
    "Cyprus":"",
    "Czech Republic":"",
    "Denmark":"",
    "Estonia":"",
    "Faroe Islands":"",
    "Finland":"",
    "France":"",
    "Georgia":"",
    "Germany":"",
    "Gibraltar":"",
    "Greece":"",
    "Greenland":"",
    "Hungary":"",
    "Iceland":"",
    "Ireland":"",
    "Italy":"",
    "Latvia":"",
    "Lithuania":"",
    "Luxembourg":"",
    "Republic of Macedonia":"",
    "Malta":"",
    "Moldova":"902",
    "Monaco":"",
    "Montenegro":"",
    "Netherlands":"",
    "Norway":"112",
    "Poland":"",
    "Portugal":"",
    "Romania":"",
    "Russia":"",
    "San Marino":"113",
    "Serbia":"",
    "Slovakia":"",
    "Slovenia":"",
    "Spain":"",
    "Sweden":"",
    "Switzerland":"",
    "Turkey":"",
    "Ukraine":"",
    "United Kingdom":"",
    "Vatican City":"113",
    "Australia":"",
    "Fiji":"",
    "New Zealand":"",
    "Solomon Islands":"",
    "Vanuatu":"",
    "Canada":"",
    "Mexico":"066",
    "Saint Pierre and Miquelon":"17",
   // "United States of America":"911",
    "United States" : "911",
    "Guatemala Option 1":"110",
    "Guatemala Option 2":"120",
    "El Salvador":"",
    "Costa Rica":"",
    "Panama":"",
    "Barbados":"211",
    "Cayman Islands":"",
    "Dominican Republic":"",
    "Jamaica":"119",
    "Trinidad and Tobago":"999",
    "Nicaragua":"",
    "Honduras":"",
    "Haiti":"",
    "Argentina":"101",
    "Bolivia":"110",
    "Brazil":"190",
    "Chile":"133",
    "Colombia":"156",
    "Ecuador":"101",
    "French Guiana":"17",
    "Guyana":"911",
    "Paraguay":"",
    "Peru":"105",
    "Suriname":"",
    "Uruguay":"",
    "Venezuela":""]

struct AppConstants {
    
    static func RGBCOLOR(_ red: Int, green: Int, blue: Int) -> UIColor {
        
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
    
    static func IOS7VERSION() -> Bool {
        return UIDevice.current.systemVersion.compare("7.0", options: .numeric, range: nil, locale: nil) != .orderedAscending
    }
    
    
}
