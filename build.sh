#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
    mac=true      
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	linux=true
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    windows=true
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    windows=true
fi
here=$(pwd)

### ILMBASE ###
cd ilmbase-2*
rm out/CMakeCache.txt
mkdir -p out
cd out

if [ ${windows+x} ]; then
	#call build for ilmbase
	cmake -DCMAKE_INSTALL_PREFIX=$here/ilmbase-install -DBUILD_SHARED_LIBS=false -G "Visual Studio 14 2015 Win64" ../
	build_file="build.bat"
	echo "call \"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\bin\\amd64\\vcvars64.bat\" || EXIT /B 1" >> $build_file
	echo "call msbuild.exe ilmbase.sln /m /t:ALL_BUILD /p:Configuration=Release;Platform=x64 || EXIT /B 1" >> $build_file
	echo "call msbuild.exe INSTALL.vcxproj /p:Configuration=Release;Platform=x64 || EXIT /B 1" >> $build_file
	powershell ./$build_file
	rm $build_file
	cd ../..
else
	cmake -DCMAKE_INSTALL_PREFIX=$here/ilmbase-install -DBUILD_SHARED_LIBS=false -G "Unix Makefiles" ../
	make -j4
	make install
fi

### ZLIB ###
cd zlib
rm out/CMakeCache.txt
mkdir -p out
cd out

if [ ${windows+x} ]; then
	#call build for zlib
	cmake -DCMAKE_INSTALL_PREFIX=$here/zlib-install  -G "Visual Studio 14 2015 Win64" ..
	build_file="build.bat"
	echo "call \"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\bin\\amd64\\vcvars64.bat\" || EXIT /B 1" >> $build_file
	echo "call msbuild.exe zlib.sln /m /t:ALL_BUILD /p:Configuration=Release;Platform=x64 || EXIT /B 1" >> $build_file
	echo "call msbuild.exe INSTALL.vcxproj /p:Configuration=Release;Platform=x64 || EXIT /B 1" >> $build_file
	powershell ./$build_file
	rm $build_file
	cd ../..
else
	cmake -DCMAKE_INSTALL_PREFIX=$here/zlib-install  -G "Unix Makefiles" ..
	make -j4
	make install
fi

### OPENEXR ###
cd openexr-2*
rm out/CMakeCache.txt
mkdir -p out
cd out

if [ ${windows+x} ]; then
	#call build for zlib
	cmake -DILMBASE_PACKAGE_PREFIX=$here/ilmbase-install -DZLIB_ROOT=$here/zlib-install -DCMAKE_INSTALL_PREFIX=$here/openexr-install -DBUILD_SHARED_LIBS=false -G "Visual Studio 14 2015 Win64" ../
	build_file="build.bat"
	echo "call \"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\bin\\amd64\\vcvars64.bat\" || EXIT /B 1" >> $build_file
	echo "call msbuild.exe openexr.sln /m /t:ALL_BUILD /p:Configuration=Release;Platform=x64 || EXIT /B 1" >> $build_file
	echo "call msbuild.exe INSTALL.vcxproj /p:Configuration=Release;Platform=x64 || EXIT /B 1" >> $build_file
	powershell ./$build_file
	rm $build_file
	cd ../..
else
	cmake -DILMBASE_PACKAGE_PREFIX=$here/ilmbase-install -DZLIB_ROOT=$here/zlib-install -DCMAKE_INSTALL_PREFIX=$here/openexr-install -DBUILD_SHARED_LIBS=false -G "Unix Makefiles" ../
	make -j4
	make install
fi

rm -r $here/ilmbase-install
rm -r $here/zlib-install