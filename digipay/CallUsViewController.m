//
//  CallUsViewController.m
//  digipay
//
//  Created by Lutfi Azhar on 4/1/16.
//  Copyright © 2016 Lutfi Azhar. All rights reserved.
//

#import "CallUsViewController.h"
#import "APIManager.h"
#import "DataManager.h"
#import "UtilityManager.h"


@interface CallUsViewController ()

@end

@implementation CallUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Calls
- (void)callUsAPI {
    [APIManager postAPIWithParam:@{
                                  @"contact": @{
                                          @"division": self.divisionTF.text,
                                          @"message": self.messageTV.text
                                          }
                                  }
                    andEndPoint:kPostCallUs withAuthorization:YES successBlock:^(NSDictionary *response) {
                        [UtilityManager showDefaultAlertWithViewController:self withTitle:@"Success" andMessage:@"Pesan berhasil terkirim"];
                    } andFailureBlock:^(NSString *errorMessage) {
                        [UtilityManager showDefaultAlertWithViewController:self withTitle:@"Error" andMessage:errorMessage];
                    }];
}

#pragma mark - Actions
- (IBAction)sendBtn:(UIButton *)sender {
    if ([self.divisionTF.text isEqualToString:@""] || [self.messageTV.text isEqualToString:@""]) {
        [UtilityManager showDefaultAlertWithViewController:self withTitle:@"Error" andMessage:@"Mohon isi kolom yang kosong"];
    }else{
        [self callUsAPI];
    }
}

- (IBAction)backgroundTap:(UITapGestureRecognizer *)sender {
    [self.divisionTF resignFirstResponder];
    [self.messageTV resignFirstResponder];
}
@end
