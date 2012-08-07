/* 
 * Copyright (C) 2012 Ci&T Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy 
 * of this software and associated documentation files (the "Software"), to deal 
 * in the  Software without restriction, including without limitation the rights 
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "NSData+CITBase64.h"

@implementation NSData (Base64)

static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)stringInBase64FromData
{
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[self bytes];
    int srcLen = [self length];
    
    // tackle the source in 3's as conveniently 4 Base64 nibbles fit into 3 bytes
    for (int i=0; i<srcLen; i += 3)
    {
        // for each output nibble
        for (int nib=0; nib<4; nib++)
        {
            // nibble:nib from char:byt
            int byt = (nib == 0)?0:nib-1;
            int ix = (nib+1)*2;
            
            if (i+byt >= srcLen) break;
            
            // extract the top bits of the nibble, if valid
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
            
            // extract the bottom bits of the nibble, if valid
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
            
            [dest appendFormat:@"%c", base64[curr]];
        }
    }
    
    return dest;
}

- (NSString *)stringInBase64FromDataWithPadding
{
    NSMutableString *returnString = (NSMutableString*)[self stringInBase64FromData];
    int lenght = [returnString length];
    
    if (lenght%4 == 3) 
    {
        [returnString appendString:@"="];
    }
    
    else if (lenght%4 == 2) 
    {
        [returnString appendString:@"=="];
    }
    
    return returnString;
}

@end