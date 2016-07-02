//
//  Constants.h
//  digipay
//
//  Created by Lutfi Azhar on 2/3/16.
//  Copyright © 2016 Lutfi Azhar. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//#define kIsProduction       NO
#define kIsProduction       YES

#define autoLogoutTimerInSeconds        900.0

#define kBaseURL                        kIsProduction ? @"http://walletku.com/" : @"http://188.166.236.85/"
#define kPostAuthentication             @"api/v1/sessions"
#define kPostAuthorization              @"api/v1/resource"
#define kPostUsers                      @"api/v1/users"
#define kPostForgotPassword             @"api/v1/password_resets"
#define kPostTopUpPulsa                 @"api/v1/payments"
#define kPostCallUs                     @"api/v1/contacts"
#define kPostTransferConfirmation       @"api/v1/deposits"
#define kPostFlightsSearch              @"api/v1/flights"

#define kGetProvider                    @"api/v1/providers"
#define kGetPayment                     @"api/v1/payments"

#define AEROFLIGHT_ACCESS_CODE          @"MTA2DiaNjIz"
#define AEROFLIGHT_URL                  @"http://dev.aeroaffiliate.com/service/v2"

#define kUserDefaultsUserKey            @"userDefaultsUser"
#define kUserDefaultsTokenKey           @"userDefaultsToken"
#define kUserDefaultsEmailKey           @"userDefaultsEmail"

#endif /* Constants_h */
