//
//  ViewController.m
//  textFiled小数点Test
//
//  Created by 周祺华 on 15/9/15.
//  Copyright (c) 2015年 周祺华. All rights reserved.
//

#import "ViewController.h"

//RGB颜色
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]

@interface ViewController ()
{
    UITextField *text;
    UILabel *result;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //textFiled
    self->text = [UITextField new];
    self->text.frame = CGRectMake(150, 150, 80, 35);
    self->text.backgroundColor = RGB(150, 150, 150);
    self->text.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:self->text];
    
    [self->text addTarget:self action:@selector(textFieldInputControl:) forControlEvents:UIControlEventEditingChanged];
    
    //label
    self->result = [UILabel new];
    self->result.frame = CGRectMake(150, 100, 80, 35);
    self->result.backgroundColor = RGB(200, 200, 200);
    
    [self.view addSubview:self->result];
    
//    text.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) textFieldInputControl:(id) sender
{
    BOOL dotDidExist = NO;
    
    UITextField *currentTextField = (UITextField *)sender;
    NSMutableString *currentText = [NSMutableString stringWithCapacity:3];
    [currentText appendString:currentTextField.text];

   
    
    //判断首字符是否为小数点，是则在前面增加一个0
    unichar firstCharacter;
    if ([currentText length] > 0)
    {
        firstCharacter = [currentText characterAtIndex:0];
    }
    
    if (firstCharacter == '.')
    {
        [currentText insertString:@"0" atIndex:0];
        currentTextField.text = currentText;
        
    }
    
    
    
    //判断字符串中有无小数点
    if ([currentText rangeOfString:@"."].location != NSNotFound)
    {
        dotDidExist = YES;
    }

    if (dotDidExist == YES)
    {
        NSLog(@"******有了小数点******");
    }
    else
    {
        NSLog(@"******还没有小数点******");
    }
    
    
    
    NSUInteger currentCharacterLocation = 0;
    unichar currentCharacter;
    if ([currentText length] > 0)
    {
        currentCharacterLocation = [currentText length]-1;
        currentCharacter = [currentText characterAtIndex:currentCharacterLocation];
        NSLog(@"当前输入的位置: %lu", (unsigned long)currentCharacterLocation);
    }
    //如果有了小数点，此时再输入小数点则会删除
    if (dotDidExist == YES)
    {
        if (currentCharacter == '.')
        {
            //以第一个小数点为界，截取出子串，无需考虑子串为空
            NSUInteger fisrtDotLocation = [currentText rangeOfString:@"."].location;
            NSLog(@"第一个小数点位置%lu", (unsigned long)fisrtDotLocation);
            NSString *subString = [currentText substringWithRange:NSMakeRange(fisrtDotLocation+1, [currentText length]-fisrtDotLocation-1)];
            //如果子串里还有小数点则删除
            if ([subString rangeOfString:@"."].location != NSNotFound)
            {
                NSLog(@"进入删除");
                [currentText deleteCharactersInRange:NSMakeRange(currentCharacterLocation, 1)];
                currentTextField.text = currentText;
            }
        }
    }

    
    
    NSLog(@"当前输入了: %c", currentCharacter);
    NSLog(@"文本显示为: %@", currentText);
    
    
    float tmp = [currentText floatValue];
    //小数点后默认显示1位
    NSString *finalResult = [NSString stringWithFormat:@"%.1f", tmp];
    self->result.text = finalResult;
}


//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    NSString *currentText = textField.text;
//    if (currentText.length > 0) {
//        return NO;
//    }
//    else
//        return YES;
//
//}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *currentText = textField.text;
//    if (currentText.length > 0)
//    {
//        unichar firstCharacter = [currentText characterAtIndex:0];
//        if (firstCharacter == '.')
//        {
//            return NO;
//        }
//        
//        if ([currentText rangeOfString:@"."].length >= 2)
//        {
//            return NO;
//        }
//        else
//            return YES;
//    }
//    else
//        return YES;
//}

@end
