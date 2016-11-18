//
//  EMAboutViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/9/22.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMAboutViewController.h"

@interface EMAboutViewController ()

@end

@implementation EMAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configBackButton];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndetifier = @"aboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
    }
    if (indexPath.row == 0) {
        
        cell.textLabel.text = NSLocalizedString(@"setting.about.appversion", @"App Version");
        cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = NSLocalizedString(@"setting.about.sdkversion", @"SDK Version");
        cell.detailTextLabel.text = [[EMClient sharedClient] version];
    }
    
    return cell;
}


@end
