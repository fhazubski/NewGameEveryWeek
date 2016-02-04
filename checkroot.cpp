/****************************************************************************
**
** The MIT License (MIT)
**
** Copyright (c) 2016 Filip Hazubski
**
** Permission is hereby granted, free of charge, to any person obtaining a
** copy of this software and associated documentation files (the "Software"),
** to deal in the Software without restriction, including without limitation
** the rights to use, copy, modify, merge, publish, distribute, sublicense,
** and/or sell copies of the Software, and to permit persons to whom the
** Software is furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included
** in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
** OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
** OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
** THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
****************************************************************************/

#include "checkroot.h"
CheckRoot::CheckRoot(QObject *parent) : QObject(parent)
{

}
bool CheckRoot::checkIfDeviceIsRooted() {
//    QAndroidJniObject javaIsDeviceRooted = QAndroidJniObject::fromString(m_notification);
//    QAndroidJniObject::callStaticMethod<void>("com/monkeybison/newgameeveryweek/CheckRoot",
//                                           "notify",
//                                           "(Ljava/lang/String;)V",
//                                           javaNotification.object<jstring>());

    jboolean value = QAndroidJniObject::callStaticMethod<jboolean>("com/monkeybison/newgameeveryweek/CheckRoot", "isDeviceRooted");
    return (bool)value;
}
