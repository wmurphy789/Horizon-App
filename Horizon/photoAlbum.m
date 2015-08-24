//
//  ViewController.m
//  OverPicker
//
//  Created by Brandon Trebitowski on 7/21/13.
//  Copyright (c) 2013 Brandon Trebitowski. All rights reserved.
//

#import "photoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

@interface photoAlbum () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *assets;
@end

@implementation photoAlbum

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [photoAlbum defaultAssetsLibrary];

    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Horizon"]) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result) {
                    NSTimeInterval diff = 240 - ([[NSDate date] timeIntervalSinceDate:[result valueForProperty:ALAssetPropertyDate]] / 60);
                    
                    if(diff > 0) {
                        [tmpAssets addObject:result];
                    }
                }
            }];
            
            self.assets = tmpAssets;
            
            // 5
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    width = (width - 20) / 3;
    return CGSizeMake(width,width);
}

#pragma mark - collection view delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    NSString* MIMEType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass
    ((__bridge CFStringRef)[defaultRep UTI], kUTTagClassMIMEType);
    NSLog(@"%@",MIMEType);
    if([MIMEType  isEqual: @"image/jpeg"]) {
        UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
        app.selfie = image;
    } else {
        app.selfie = nil;
        Byte *buffer = (Byte*)malloc((NSUInteger)defaultRep.size);
        NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:(NSUInteger)defaultRep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        app.vFile = data;
        NSLog(@"location: %@",[[defaultRep url] absoluteString]);
        app.vSelfie = defaultRep.url;
    }
    
    [self performSegueWithIdentifier:@"showSelfie" sender:self];
}

#pragma mark - assets

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - Actions

- (IBAction)takePhotoButtonTapped:(id)sender
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO))
        return;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (IBAction)albumsButtonTapped:(id)sender
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary] == NO))
        return;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];

}

#pragma mark - image picker delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        // Do something with the image
    }];
}

@end
