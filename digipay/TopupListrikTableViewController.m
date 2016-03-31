//
//  TopupListrikTableViewController.m
//  digipay
//
//  Created by Lutfi Azhar on 3/31/16.
//  Copyright © 2016 Lutfi Azhar. All rights reserved.
//

#import "TopupListrikTableViewController.h"
#import "TopUpPulsaListTableViewController.h"
#import "APIClient.h"
#import "Utils.h"

@interface TopupListrikTableViewController ()

@end

@implementation TopupListrikTableViewController {
    NSMutableArray *providerSelected, *nominalSelected;
    int providerId, nominalId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getProviderAPI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.balanceText.text = [NSString stringWithFormat:@"Sisa Saldo Anda : Rp. %@,-", [Utils getUserBalance]];
    
    if (providerSelected) {
        self.selectProviderTF.text = [providerSelected valueForKey:@"name"];
        providerId = [[providerSelected valueForKey:@"id"] intValue];
    }else{
        self.selectProviderTF.text = @"";
        providerId = 0;
    }
    
    if (nominalSelected) {
        self.nominalTF.text = [NSString stringWithFormat:@"%@", [nominalSelected valueForKey:@"amount"]];
        nominalId = [[nominalSelected valueForKey:@"id"] intValue];
    }else{
        self.nominalTF.text = @"";
        nominalId = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"topUpList"]) {
        
        TopUpPulsaListTableViewController *topUpList = [segue destinationViewController];
        if ([sender isEqualToString:@"provider"]) {
            
            topUpList.providerList = self.providerList;
            topUpList.isForNominal = NO;
            
        }else if ([sender isEqualToString:@"nominal"]) {
            
            topUpList.providerList = providerSelected;
            topUpList.isForNominal = YES;
            
        }
        
        topUpList.delegate = self;
    }
}

#pragma mark - Action Methods
- (IBAction)selectProviderBtn:(UIButton *)sender {
    if (self.providerList) {
        [self performSegueWithIdentifier:@"topUpList" sender:@"provider"];
    }
}

- (IBAction)selectNominalBtn:(UIButton *)sender {
    if (providerSelected) {
        [self performSegueWithIdentifier:@"topUpList" sender:@"nominal"];
    }else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Kolom provider kosong"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBtn = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:nil];
        
        [alert addAction:okBtn];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setProvider:(NSMutableArray *)provider {
    providerSelected = provider;
}

- (void)setNominal:(NSMutableArray *)nominal {
    nominalSelected = nominal;
}

- (IBAction)beliBtn:(UIButton *)sender {
    if ([self.nominalTF.text  isEqual: @""])
    {
        [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Kolom nominal kosong"];
    }
    else if ([self.nomerMeterTF.text  isEqual: @""])
    {
        [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Kolom Nomer Meter Kosong" ];
    }
    else{
        
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Masukkan PIN Anda"
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
            self.pinTF = textField;
            
        }];
        
        [alert addAction: [UIAlertAction actionWithTitle:@"Selesai"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     
                                                     if ([self.pinTF.text isEqualToString:@""]) {
                                                         UIAlertController * alert=   [UIAlertController
                                                                                       alertControllerWithTitle:@""
                                                                                       message:@"PIN Kosong"
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction* okBtn = [UIAlertAction
                                                                                 actionWithTitle:@"Ok"
                                                                                 style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction * action)
                                                                                 {
                                                                                     
                                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                     
                                                                                 }];
                                                         
                                                         [alert addAction:okBtn];
                                                         
                                                         [self presentViewController:alert animated:YES completion:nil];
                                                     }else{
                                                         
                                                         [self topUpPulsaAPIWithPIN:self.pinTF.text];
                                                         
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         
                                                     }
                                                     
                                                     
                                                 }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Batal"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {
                                                    
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

#pragma mark - API methods
- (void)topUpPulsaAPIWithPIN:(NSString *)pin{
    
    [APIClient postAPIWithParam:@{
                                  @"top_up":@{
                                          @"provider_id":@(providerId),
                                          @"nominal_id":@(nominalId),
                                          @"msisdn":self.nomerMeterTF.text,
                                          @"payment_type":@"pln",
                                          @"pin":pin
                                          }
                                  }andEndPoint:kPostTopUpPulsa withAuthorization:YES successBlock:^(NSDictionary *response) {
                                      
                                      NSString *status = [response valueForKeyPath:@"payment.status"];
                                      NSString *message = [response valueForKeyPath:@"payment.message"];
                                      
                                      [Utils showDefaultAlertWithViewController:self withTitle:status andMessage:message];
                                      
                                  } andFailureBlock:^(NSString *errorMessage) {
                                      [Utils showDefaultAlertWithViewController:self withTitle:@"Error" andMessage:errorMessage];
                                  }];
}

- (void)getProviderAPI{
    
    [APIClient getAPIWithParam:@{
                                 @"payment_type":@"pln"
                                 }
                   andEndPoint:kGetProvider withAuthorization:YES successBlock:^(NSDictionary *response) {
                       
                       self.providerList = (NSMutableArray *)[response objectForKey:@"providers"];
                       
                   } andFailureBlock:^(NSString *errorMessage) {
                       
                       [Utils showDefaultAlertWithViewController:self withTitle:@"Error" andMessage:errorMessage];
                       
                   }];
    
}

@end
