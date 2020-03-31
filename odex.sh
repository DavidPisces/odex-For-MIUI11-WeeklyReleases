#!/bin/bash
workfile=/storage/emulated/0/MIUI_odex
success_count=0
faild_count=0
now_time=$(date '+%Y%m%d_%H:%M:%S')
# rm
rm -rf $workfile
# mkdir
mkdir -p /storage/emulated/0/MIUI_odex/log
mkdir -p /storage/emulated/0/MIUI_odex/app
mkdir -p /storage/emulated/0/MIUI_odex/priv-app
mkdir -p /storage/emulated/0/MIUI_odex/product/app
mkdir -p /storage/emulated/0/MIUI_odex/product/priv-app
# log
touch $workfile/log/MIUI_odex_$now_time.log
# copy files to path
cp -r /system/app/* $workfile/app
cp -r /system/priv-app/* $workfile/priv-app
cp -r /system/product/app/* $workfile/product/app
cp -r /system/product/priv-app/* $workfile/product/priv-app
echo "- 文件复制完成，开始执行"

# system/app
echo "- 正在分离system/app"
shopt -s extglob
dirapp=$(ls -l $workfile/app |awk '/^d/ {print $NF}')
for i in $dirapp
do
   cd $workfile/app/$i
# unzip
   echo "- 正在解包$i，请稍后"
   unzip -q -o *.apk
# whether unzip apk success
if [ $? = 0 ] ; then
   echo "- 解包$i成功，开始处理"
   rm -rf !(*.dex)
   mkdir -p $workfile/app/$i/oat/arm64
   oat=$workfile/app/$i/oat/arm64
   count=`ls -l $workfile/app/$i/ | grep "^-" | wc -l`
   if [ "$count" -ge "1"  ]; then
      echo "- 检测到$count个dex文件，开始编译"
	  echo "! 正在分离$i的odex，请坐和放宽"
        if [ "$count" == "1"  ]; then
           dex2oat --dex-file=$workfile/app/$i/classes.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$oat/$i.odex
        fi
        if [ "$count" == "2"  ]; then
           dex2oat --dex-file=$workfile/app/$i/classes.dex --dex-file=$workfile/app/$i/classes2.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$oat/$i.odex
        fi
        if [ "$count" == "3"  ]; then
           dex2oat --dex-file=$workfile/app/$i/classes.dex --dex-file=$workfile/app/$i/classes2.dex --dex-file=$workfile/app/$i/classes3.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$oat/$i.odex
        fi
        if [ "$count" == "4"  ]; then
           dex2oat --dex-file=$workfile/app/$i/classes.dex --dex-file=$workfile/app/$i/classes2.dex --dex-file=$workfile/app/$i/classes3.dex --dex-file=$workfile/app/$i/classes4.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$oat/$i.odex
        fi
        if [ "$count" == "5"  ]; then
           dex2oat --dex-file=$workfile/app/$i/classes.dex --dex-file=$workfile/app/$i/classes2.dex --dex-file=$workfile/app/$i/classes3.dex --dex-file=$workfile/app/$i/classes4.dex --dex-file=$workfile/app/$i/classes5.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$oat/$i.odex
        fi
        if [ "$count" == "6"  ]; then
           dex2oat --dex-file=$workfile/app/$i/classes.dex --dex-file=$workfile/app/$i/classes2.dex --dex-file=$workfile/app/$i/classes3.dex --dex-file=$workfile/app/$i/classes4.dex --dex-file=$workfile/app/$i/classes5.dex --dex-file=$workfile/app/$i/classes6.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$oat/$i.odex
        fi
      rm -rf *.dex
      echo "- 已完成对$i的odex分离处理"
	  let success_count=success_count+1
   else
      echo "! 未检测到dex文件，跳过编译"
	  rm  -rf $workfile/app/$i
	  let faild_count=faild_count+1
	  echo "$i ：编译失败，没有dex文件" >> $workfile/log/MIUI_odex_$now_time.log
   fi
else
      echo "! 解压$i失败，没有apk文件"
	  rm  -rf $workfile/app/$i
	  echo "$i ：编译失败，没有apk文件" >> $workfile/log/MIUI_odex_$now_time.log
	  let faild_count=faild_count+1
fi
done

# system/priv-app
echo "- 正在分离system/priv-app"
shopt -s extglob
dirpriv=$(ls -l $workfile/priv-app |awk '/^d/ {print $NF}')
for p in $dirpriv
do
   cd $workfile/priv-app/$p
# unzip
   echo "- 正在解包$p，请稍后"
   unzip -q -o *.apk
# whether unzip apk success
if [ $? = 0 ] ; then
   echo "- 解包$p成功，开始处理"
   rm -rf !(*.dex)
   mkdir -p $workfile/priv-app/$p/oat/arm64
   privoat=$workfile/priv-app/$p/oat/arm64
   count=`ls -l $workfile/priv-app/$p/ | grep "^-" | wc -l`
   if [ "$count" -ge "1"  ]; then
      echo "- 检测到$count个dex文件，开始编译"
	  echo "! 正在分离$p的odex，请坐和放宽"
        if [ "$count" == "1"  ]; then
           dex2oat --dex-file=$workfile/priv-app/$p/classes.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$privoat/$p.odex
        fi
        if [ "$count" == "2"  ]; then
           dex2oat --dex-file=$workfile/priv-app/$p/classes.dex --dex-file=$workfile/priv-app/$p/classes2.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$privoat/$p.odex
        fi
        if [ "$count" == "3"  ]; then
           dex2oat --dex-file=$workfile/priv-app/$p/classes.dex --dex-file=$workfile/priv-app/$p/classes2.dex --dex-file=$workfile/priv-app/$p/classes3.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$privoat/$p.odex
        fi
        if [ "$count" == "4"  ]; then
           dex2oat --dex-file=$workfile/priv-app/$p/classes.dex --dex-file=$workfile/priv-app/$p/classes2.dex --dex-file=$workfile/priv-app/$p/classes3.dex --dex-file=$workfile/priv-app/$p/classes4.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$privoat/$p.odex
        fi
        if [ "$count" == "5"  ]; then
           dex2oat --dex-file=$workfile/priv-app/$p/classes.dex --dex-file=$workfile/priv-app/$p/classes2.dex --dex-file=$workfile/priv-app/$p/classes3.dex --dex-file=$workfile/priv-app/$p/classes4.dex --dex-file=$workfile/priv-app/$p/classes5.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$privoat/$p.odex
        fi
        if [ "$count" == "6"  ]; then
           dex2oat --dex-file=$workfile/priv-app/$p/classes.dex --dex-file=$workfile/priv-app/$p/classes2.dex --dex-file=$workfile/priv-app/$p/classes3.dex --dex-file=$workfile/priv-app/$p/classes4.dex --dex-file=$workfile/priv-app/$p/classes5.dex --dex-file=$workfile/priv-app/$p/classes6.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$privoat/$p.odex
        fi
      rm -rf *.dex
      echo "- 已完成对$p的odex分离处理"
	  let success_count=success_count+1
   else
      echo "! 未检测到dex文件，跳过编译"
	  rm -rf $workfile/priv-app/$p
	  let faild_count=faild_count+1
	  echo "$p ：编译失败，没有dex文件" >> $workfile/log/MIUI_odex_$now_time.log
   fi
else
      echo "! 解压$p失败，没有apk文件"
	  echo "$p ：编译失败，没有apk文件" >> $workfile/log/MIUI_odex_$now_time.log
	  rm -rf $workfile/priv-app/$p
	  let faild_count=faild_count+1
fi
done

# system/product/app
echo "- 正在分离system/product/app"
shopt -s extglob
productapp=$(ls -l $workfile/product/app |awk '/^d/ {print $NF}')
for a in $productapp
do
   cd $workfile/product/app/$a
# unzip
   echo "- 正在解包$a，请稍后"
   unzip -q -o *.apk
# whether unzip apk success
if [ $? = 0 ] ; then
   echo "- 解包$a成功，开始处理"
   rm -rf !(*.dex)
   mkdir -p $workfile/product/app/$a/oat/arm64
   productappoat=$workfile/product/app/$a/oat/arm64
   count=`ls -l $workfile/product/app/$a/ | grep "^-" | wc -l`
   if [ "$count" -ge "1"  ]; then
      echo "- 检测到$count个dex文件，开始编译"
	  echo "! 正在分离$a的odex，请坐和放宽"
        if [ "$count" == "1"  ]; then
           dex2oat --dex-file=$workfile/product/app/$a/classes.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productappoat/$a.odex
        fi
        if [ "$count" == "2"  ]; then
           dex2oat --dex-file=$workfile/product/app/$a/classes.dex --dex-file=$workfile/product/app/$a/classes2.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productappoat/$a.odex
        fi
        if [ "$count" == "3"  ]; then
           dex2oat --dex-file=$workfile/product/app/$a/classes.dex --dex-file=$workfile/product/app/$a/classes2.dex --dex-file=$workfile/product/app/$a/classes3.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productappoat/$a.odex
        fi
        if [ "$count" == "4"  ]; then
           dex2oat --dex-file=$workfile/product/app/$a/classes.dex --dex-file=$workfile/product/app/$a/classes2.dex --dex-file=$workfile/product/app/$a/classes3.dex --dex-file=$workfile/product/app/$a/classes4.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productappoat/$a.odex
        fi
        if [ "$count" == "5"  ]; then
           dex2oat --dex-file=$workfile/product/app/$a/classes.dex --dex-file=$workfile/product/app/$a/classes2.dex --dex-file=$workfile/product/app/$a/classes3.dex --dex-file=$workfile/product/app/$a/classes4.dex --dex-file=$workfile/product/app/$a/classes5.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productappoat/$a.odex
        fi
        if [ "$count" == "6"  ]; then
           dex2oat --dex-file=$workfile/product/app/$a/classes.dex --dex-file=$workfile/product/app/$a/classes2.dex --dex-file=$workfile/product/app/$a/classes3.dex --dex-file=$workfile/product/app/$a/classes4.dex --dex-file=$workfile/product/app/$a/classes5.dex --dex-file=$workfile/product/app/$a/classes6.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productappoat/$a.odex
        fi
      rm -rf *.dex
      echo "- 已完成对$a的odex分离处理"
	  let success_count=success_count+1
   else
      echo "! 未检测到dex文件，跳过编译"
	  rm  -rf $workfile/product/app/$a
	  let faild_count=faild_count+1
	  echo "$a ：编译失败，没有dex文件" >> $workfile/log/MIUI_odex_$now_time.log
   fi
else
      echo "! 解压$a失败，没有apk文件"
	  rm  -rf $workfile/product/app/$a
	  echo "$a ：编译失败，没有apk文件" >> $workfile/log/MIUI_odex_$now_time.log
	  let faild_count=faild_count+1
fi
done

# system/product/priv-app
echo "- 正在分离system/product/priv-app"
shopt -s extglob
productprivapp=$(ls -l $workfile/product/priv-app |awk '/^d/ {print $NF}')
for b in $productprivapp
do
   cd $workfile/product/priv-app/$b
# unzip
   echo "- 正在解包$b，请稍后"
   unzip -q -o *.apk
# whether unzip apk success
if [ $? = 0 ] ; then
   echo "- 解包$b成功，开始处理"
   rm -rf !(*.dex)
   mkdir -p $workfile/product/priv-app/$b/oat/arm64
   productprivappoat=$workfile/product/priv-app/$b/oat/arm64
   count=`ls -l $workfile/product/priv-app/$b/ | grep "^-" | wc -l`
   if [ "$count" -ge "1"  ]; then
      echo "- 检测到$count个dex文件，开始编译"
	  echo "! 正在分离$b的odex，请坐和放宽"
        if [ "$count" == "1"  ]; then
           dex2oat --dex-file=$workfile/product/priv-app/$b/classes.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productprivappoat/$b.odex
        fi
        if [ "$count" == "2"  ]; then
           dex2oat --dex-file=$workfile/product/priv-app/$b/classes.dex --dex-file=$workfile/product/priv-app/$b/classes2.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productprivappoat/$b.odex
        fi
        if [ "$count" == "3"  ]; then
           dex2oat --dex-file=$workfile/product/priv-app/$b/classes.dex --dex-file=$workfile/product/priv-app/$b/classes2.dex --dex-file=$workfile/product/priv-app/$b/classes3.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productprivappoat/$b.odex
        fi
        if [ "$count" == "4"  ]; then
           dex2oat --dex-file=$workfile/product/priv-app/$b/classes.dex --dex-file=$workfile/product/priv-app/$b/classes2.dex --dex-file=$workfile/product/priv-app/$b/classes3.dex --dex-file=$workfile/product/priv-app/$b/classes4.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productprivappoat/$b.odex
        fi
        if [ "$count" == "5"  ]; then
           dex2oat --dex-file=$workfile/product/priv-app/$b/classes.dex --dex-file=$workfile/product/priv-app/$b/classes2.dex --dex-file=$workfile/product/priv-app/$b/classes3.dex --dex-file=$workfile/product/priv-app/$b/classes4.dex --dex-file=$workfile/product/priv-app/$b/classes5.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productprivappoat/$b.odex
        fi
        if [ "$count" == "6"  ]; then
           dex2oat --dex-file=$workfile/product/priv-app/$b/classes.dex --dex-file=$workfile/product/priv-app/$b/classes2.dex --dex-file=$workfile/product/priv-app/$b/classes3.dex --dex-file=$workfile/product/priv-app/$b/classes4.dex --dex-file=$workfile/product/priv-app/$b/classes5.dex --dex-file=$workfile/product/priv-app/$b/classes6.dex --compiler-filter=everything --instruction-set=arm64 --oat-file=$productprivappoat/$b.odex
        fi
      rm -rf *.dex
      echo "- 已完成对$b的odex分离处理"
	  let success_count=success_count+1
   else
      echo "! 未检测到dex文件，跳过编译"
	  rm -rf $workfile/product/priv-app/$b
	  let faild_count=faild_count+1
	  echo "$b ：编译失败，没有dex文件" >> $workfile/log/MIUI_odex_$now_time.log
   fi
else
      echo "! 解压$b失败，没有apk文件"
	  rm -rf $workfile/product/priv-app/$b
	  echo "$b ：编译失败，没有apk文件" >> $workfile/log/MIUI_odex_$now_time.log
	  let faild_count=faild_count+1
fi
done
# end
echo "- 共$success_count次成功，$faild_count次失败，请检查对应目录"

# 用户应用
echo "正在以Everything模式优化用户软件"
mkdir -p $workfile/packagelist
touch $workfile/packagelist/packagelist.log
echo "`pm list packages -3`" > $workfile/packagelist/packagelist.log
apptotalnumber="`grep -o "package:" $workfile/packagelist/packagelist.log | wc -l`"
appnumber=0
for item in `pm list packages -3`
do
echo 
app=${item:8}
echo "应用优化完成 -> $app"
cmd package compile -m everything $app
let appnumber=appnumber+1
echo "已完成 $appnumber / $apptotalnumber"
done

# 生成模块
echo "- 正在制作模块，请坐和放宽"
rm -rf /data/adb/modules/odex
mkdir -p /data/adb/modules/odex/system
touch /data/adb/modules/odex/module.prop
echo "id=odex" >> /data/adb/modules/odex/module.prop
echo "name=$model 优化" >> /data/adb/modules/odex/module.prop
echo "version=1.0" >> /data/adb/modules/odex/module.prop
echo "versionCode=1" >> /data/adb/modules/odex/module.prop
echo "author=柚稚的孩纸&雄式老方" >> /data/adb/modules/odex/module.prop
echo "minMagisk=19000" >> /data/adb/modules/odex/module.prop
model="`grep -n "ro.product.system.model" /system/build.prop | cut -d= -f2`"
ver="`grep -n "ro.miui.ui.version.name" /system/build.prop | cut -dV -f2`"
modelversion="`grep -n "ro.system.build.version.incremental" /system/build.prop | cut -d= -f2`"
time=$(date "+%Y年%m月%d日 %H:%M:%S")
echo -n "description=对系统应用进行分离odex，分离的机型为$model，版本为MIUI $ver $modelversion，编译时间为$time" >> /data/adb/modules/odex/module.prop
mv $workfile/* /data/adb/modules/odex/system
if [ $? = 0 ] ; then
     mv /data/adb/modules/odex/system/log $workfile
     rm -rf /data/adb/modules/odex/system/packagelist
     echo "- 模块制作完成，请重启生效"
else
     echo "! 模块制作失败，自个儿看着办"
fi
echo "- 活整好了"
