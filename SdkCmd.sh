#！/bin/bash

function new_sdk()
{
    echo "---begin init libs----"
    cp -rf libs/libs-template/ libs/libs-$1
    sed -i '' 's/\-template/\-'$1'/g' libs/libs-$1/AndroidManifest.xml libs/libs-$1/build.gradle
    sed -i '' 's/\.template/\.'$1'/g' libs/libs-$1/AndroidManifest.xml libs/libs-$1/build.gradle
    sed -i '' 's/template_version/'$2'/g' libs/libs-$1/build.gradle
    echo "---init libs done---"

    echo '---begin init project '$1
    cp -rf projects/talkingsdk-template/ projects/talkingsdk-$1
    mv projects/talkingsdk-$1/src/com/talkingsdk/template projects/talkingsdk-$1/src/com/talkingsdk/$1
    sed -i '' 's/\.template/\.'$1'/g' `grep \.template -rl projects/talkingsdk-$1/src`
    sed -i '' 's/\.template/\.'$1'/g' projects/talkingsdk-$1/AndroidManifest.xml projects/talkingsdk-$1/build.gradle
    sed -i '' 's/\-template/\-'$1'/g' projects/talkingsdk-$1/build.gradle projects/talkingsdk-$1/AndroidManifest.xml
    sed -i '' 's/template_version/'$2'/g' projects/talkingsdk-$1/build.gradle projects/talkingsdk-$1/build.gradle
    echo '----init projects-'$1' end--'
    echo '---begin demo projects---'
    cp -rf projects/talkingsdk-template-demo/ projects/talkingsdk-$1-demo
    sed -i '' 's/\.template/\.'$1'/g' projects/talkingsdk-$1-demo/AndroidManifest.xml
    sed -i '' 's/\-template/\-'$1'/g' projects/talkingsdk-$1-demo/build.gradle
    sed -i '' 's/template_version/'$2'/g' projects/talkingsdk-$1-demo/build.gradle
    mv projects/talkingsdk-$1-demo/src/com/talkingsdk/templatesdkdemo projects/talkingsdk-$1-demo/src/com/talkingsdk/$1sdkdemo
    sed -i '' 's/\.templatesdkdemo/\.'$1'sdkdemo/g' `grep \.template -rl projects/talkingsdk-$1-demo/src`
    sed -i '' 's/\.template/\.'$1'/g' `grep \.template -rl projects/talkingsdk-$1-demo/src`
    echo '-----end demo projects'
    echo '-----remove .git '
    rm -rf projects/talkingsdk-$1-demo/.git
    rm -rf libs/libs-$1/.git
    rm -rf projects/talkingsdk-$1/.git
    cd libs/libs-$1;git init
    cd ../../projects/talkingsdk-$1;git init
    cd ../talkingsdk-$1-demo;git init
    echo '----添加子模块-----'
    git submodule add -f http://repos.code4.in/cooperators/sdkbase-release.git jni/SdkBase_release
    cd ../../
    echo '-----done hava fun!-----'
}

if [ "$1" == 'init' ]; then
    cd libs;git clone git@repos.code4.in:androidsdks/libs-template.git
    cd ../projects/;git clone git@repos.code4.in:androidsdks/talkingsdk-template.git
    git clone git@repos.code4.in:androidsdks/talkingsdk-template-demo.git
    cd ../
elif [ $1 == 'new' ]; then
    new_sdk $2 $3
elif [ $1 == 'rm' ]; then
    rm -rf libs/libs-$2
    rm -rf projects/talkingsdk-$2
    rm -rf projects/talkingsdk-$2-demo
    echo '项目移除成功'
elif [ $1 == '--help' ]; then
    echo 'init: 如果本地没有init必须先init\n rm name 移除name \n new name: 创建name'
else
    echo '输入参数异常'
fi

