#! /bin/bash
# Type a script or drag a script file from your workspace to insert its path.


#进入当前文件路径 - 请放置在Webcast工程文件路径下
CURRENT_DIR=$(dirname $0)
cd "$CURRENT_DIR"
echo "当前project路径为:$CURRENT_DIR"
echo "更新svn工程目录..."

PRODUCT_NAME="PlayerSDKDemo"
# 工程中需要编译的target
TARGET="PlayerSDKDemo"
#参数配置
CONFIGURATION="Release"
EXPORT_PATH="$CURRENT_DIR/Export"
APP_PATH="$EXPORT_PATH/$TARGET.ipa"
ARCHIVE_PATH="$EXPORT_PATH/${TARGET}.xcarchive"
PROJECT_PATH="$CURRENT_DIR/$PRODUCT_NAME.xcodeproj"

rm -r "$EXPORT_PATH"
mkdir "$EXPORT_PATH"

if [ -d $EXPORT_PATH ];then
    echo "EXPORT_PATH=$EXPORT_PATH"
fi

xcodebuild archive -project "$PROJECT_PATH"  -scheme "$TARGET" -configuration "$CONFIGURATION" -archivePath "$ARCHIVE_PATH" -UseModernBuildSystem=NO || { echo "Archive Failed : xcodebuild archive action failed"; return 1; }
# 关于动态库的引用关系修改问题，使用install_name_tool指令,由于在工程中附带了脚本进行处理，这里没有写
xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportOptionsPlist "$CURRENT_DIR/ExportOptions.plist" -exportPath "$EXPORT_PATH"


curl -F "file=@$APP_PATH" -F "uKey=59bfd98e91f71442381cba09d0f30e45" -F "_api_key=d8289add0d924858bc19d5d8199d28cf" "https://www.pgyer.com/apiv1/app/upload" &> Uploadlog

cat uploadlog