project_dir=$PWD/../../../..
build_dir=$project_dir/public
object_dir=$project_dir/object/vsw
lib_name=liboss.a
output_path=$project_dir/output/lib/hwm/vsw
debug_make=

if [ "$1" ]; then
    debug_make="VERBOSE=1" #if you want to see gcc flags then you will use "./oss_make.sh 1"
fi

if [ ! -d $build_dir ]; then
    echo "directory $build_dir is not exist, please clone the build directory to $build_dir."
    exit 1
fi

if [ ! -d $project_dir/oss ]; then
    echo "$project_dir/oss directory is not exist, please clone the oss directory to  $project_dir."
    exit 2
fi

if [ ! -d $object_dir ]; then
    mkdir -p $object_dir
fi

cd $object_dir
rm -fr *
if [ -f $output_path/$lib_name ]; then
    rm $output_path/$lib_name
fi

. $build_dir/script/ver.sh  COMPILE_LIB ${object_dir} $project_dir/oss  ${lib_name}
cp -f $build_dir/cmake/template.txt $project_dir/CMakeLists.txt
{
    func_AddVerInfoSrcFile  "OSS_SOURCES"
    echo 'add_subdirectory(oss)'
}>>$project_dir/CMakeLists.txt

corenum=$(cat /proc/cpuinfo | grep processor | wc -l)
cmake -DHWM=VSW ../..
make oss $debug_make -j$corenum


if [ ! -d $output_path ]; then
    mkdir -p $output_path
fi

if [ ! -f $object_dir/$lib_name ]; then
    echo "make oss failed, please check your code."
    exit 3
fi

cp $object_dir/$lib_name $output_path/$lib_name

echo "please check whether $lib_name is the newest."
ls $project_dir/output/lib/hwm/vsw -lahr

exit 0
