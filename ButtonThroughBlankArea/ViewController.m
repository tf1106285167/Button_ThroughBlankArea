//
//  ViewController.m
//  ButtonThroughBlankArea
//
//  Created by TuFa on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "OBShapedButton.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainURL  @"http://m.zlifan.com/"
@interface ViewController ()
{
    UILabel *content3Label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *imgArr = @[@"yuan",@"yuanTxt"];
    
    CGFloat imgWH = 240;
    OBShapedButton *obshapBtn;
    for (int i=0; i<imgArr.count; i++) {
       
        obshapBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake((KScreenWidth-240)/2, (KScreenHeight-240)/2, imgWH, imgWH)];;
        obshapBtn.tag = 200+i;
        
        //取消长按变灰
        obshapBtn.adjustsImageWhenHighlighted = NO;
        [self.view addSubview:obshapBtn];
        [obshapBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        obshapBtn.layer.cornerRadius = imgWH/2;
        [obshapBtn addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *view3Back = [[UIView alloc]initWithFrame:CGRectMake(97, 226-60, imgWH-88, imgWH-88)];
    view3Back.layer.cornerRadius = (imgWH-88)/2;
    view3Back.center = obshapBtn.center;
    view3Back.tag = 250;
    view3Back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3Back];
    
    content3Label = [[UILabel alloc]initWithFrame:CGRectMake(120, 250, imgWH-120, imgWH-150)];
    content3Label.font = [UIFont systemFontOfSize:15];
    content3Label.textColor = [UIColor blackColor];
    content3Label.center = obshapBtn.center;
    content3Label.textAlignment = NSTextAlignmentCenter;
    content3Label.numberOfLines = 0;
    content3Label.text = @"只需反馈一次,\n问题就能解决";
    [self.view addSubview:content3Label];

}

-(void)imgAction:(UIButton *)btn{
    
    UIView *view = [self.view viewWithTag:250];
    
    NSString *url = [NSString stringWithFormat:@"%@images/yuan/yuan.jsp",MainURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *diction = [defaults objectForKey:@"pixelColor"];
    
    NSArray *array1 = [str componentsSeparatedByString:@","];
    
    CGFloat r = [diction[@"colorRed"] floatValue];
    CGFloat g = [diction[@"colorGreen"] floatValue];
    CGFloat b = [diction[@"colorBlue"] floatValue];
    CGFloat alpha = [diction[@"colorAlpha"] floatValue];
    
    if (!(r == 0 && g == 0 && b == 0) && !(r ==255 && g ==255 && b ==255) && alpha == 1) {
        
        view.backgroundColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
        NSInteger colorInt = [self redName:r WithGreenName:g WithBlueName:b];
        
        for (int i=0; i<array1.count; i++) {
            
            NSString *content = array1[i];
            if([content rangeOfString:[NSString stringWithFormat:@"%ld",(long)colorInt]].location !=NSNotFound)//_roaldSearchText
            {
                
                NSArray *array2 = [content componentsSeparatedByString:@":"];
                NSString *content2 = [array2[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                content2 = [content2 stringByReplacingOccurrencesOfString:@"}" withString:@""];
                content3Label.text = content2;
            }
        }
    }
}

-(NSInteger)redName:(NSInteger)red WithGreenName:(NSInteger)green WithBlueName:(NSInteger)blue{
    
    return (0xFF << 24) | (red << 16) | (green << 8) | blue;
}



@end
