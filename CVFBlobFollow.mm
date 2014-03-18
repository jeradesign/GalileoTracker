//
//  CVFBlobFollow.mm
//  CVFunhouse
//
//  Created by John Brewer on 3/17/14.
//  Copyright (c) 2014 Jera Design LLC. All rights reserved.
//

#import "CVFBlobFollow.h"
#import "CVFGalileoHandler.h"

#include "opencv2/imgproc/imgproc.hpp"

const int morph_size = 3;

using namespace std;
using namespace cv;

@interface CVFBlobFollow() {
    bool _inited;
    CVFGalileoHandler *_galileo;
}
@end

@implementation CVFBlobFollow

-(instancetype)init
{
    self = [super init];
    if (self != nil) {
        _galileo = [[CVFGalileoHandler alloc] init];
    }
    return self;
}

-(void)processMat:(Mat)mat
{
    pyrDown(mat, mat);
    pyrDown(mat, mat);
    cvtColor(mat, mat, CV_BGR2RGB);
    Mat hsbMat;
    cvtColor(mat, hsbMat, CV_RGB2HSV);
    vector<Mat> splitChannels;
    split(hsbMat, splitChannels);
    Mat h(splitChannels[0]);
    Mat s(splitChannels[1]);
    Mat v(splitChannels[2]);
    cv::Mat kernel = getStructuringElement(MORPH_RECT,
                                           cv::Size( 2*morph_size + 1, 2*morph_size+1 ),
                                           cv::Point( morph_size, morph_size ) );
//    cv::erode(h, h, kernel);
    threshold(h, h, 20, 255, THRESH_BINARY_INV);
//    cv::erode(s, s, kernel);
    threshold(s, s, 180, 255, THRESH_BINARY);
//    cv::erode(v, v, kernel);
    threshold(v, v, 200, 255, THRESH_BINARY);
    h = min(h, s);
    h = min(h, v);
    vector<vector<cv::Point> > contours;
    findContours(h, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    vector<cv::Point> biggestContour;
    int biggestArea = 0;
    for (const auto& contour : contours) {
        int currentArea = contourArea(contour);
        if (currentArea > biggestArea) {
            biggestArea = currentArea;
            biggestContour = contour;
        }
    }
    NSLog(@"Biggest area %d", biggestArea);
    if (biggestArea > 0) {
        Moments mu = moments(biggestContour);
        int x = mu.m10/mu.m00;
        int y = mu.m01/mu.m00;
        Scalar green(0, 255, 0);
        drawContours(mat, vector<vector<cv::Point> >{biggestContour}, -1, green);
        Scalar blue(0, 0, 255);
        int right = mat.cols;
        int bottom = mat.rows;
        cv::line(mat, cv::Point(0,y), cv::Point(right,y), cv::Scalar(0, 0 , 255));
        cv::line(mat, cv::Point(x,0), cv::Point(x,bottom), cv::Scalar(0, 0 , 255));
        int matX = mat.cols / 2;
        int matY = mat.rows / 2;
        
        float deltaX = -(float)(x - matX) / mat.cols;
        float deltaY = -(float)(y - matY) / mat.rows;
        
        NSLog(@"%f, %f", deltaX, deltaY);
        [_galileo panBy:deltaX * 30];
        [_galileo tiltBy:deltaY * 30];
    }
    [self matReady:mat];
}

@end
