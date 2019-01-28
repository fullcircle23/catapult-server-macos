# Build and Run NEM Catapult Server in Xcode 10

## Prerequisites

1. Completed catapult-server build and run on macOS by following https://github.com/fullcircle23/catapult-server-macos/README.md.

2. CMake version 3.13.3 (tested).

*Rationale: Encountered the below error when doing build in Xcode with CMake version 3.11.1*
```
Build catapult.server: Failed
clang: error: no such file or directory: .../catapult-server/_build_xcode/src/catapult/version/nix/catapult_server.build/Debug/catapult.version.nix.build/Objects-normal/undefined_arch/what_version.o'
```

## Steps

1. Create the build directory for Xcode in catapult-server source directory.

```console
cd catapult-server
mkdir _build_xcode
cd _build_xcode
```

2. Generate Xcode project with CMake.

```console
cmake -G "Xcode" ..
```

3. Skip this step if you don't get the below error:

```console
--- locating zeromq dependencies ---
CMake Error at extensions/zeromq/CMakeLists.txt:5 (find_package):
  By not providing "Findcppzmq.cmake" in CMAKE_MODULE_PATH this project has
  asked CMake to find a package configuration file provided by "cppzmq", but
  CMake did not find one.
```

*Fixed the above error by installing latest zeromq and cppzmq as follows:*
  
```console
brew update
brew install zeromq

cd <your-local-git-directory>
git clone https://github.com/zeromq/cppzmq.git \
&& mkdir -p cppzmq/_build && cd cppzmq/_build \
&& cmake -DENABLE_DRAFTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. \
&& make -j4 && sudo make install \
&& cd -
```

4. Add the Xcode build directory to .gitignore BEFORE you open Xcode.

*Ensure that your .gitignore already includes* **\_build\*/** *or the name of the build directory which you created in Step 1.*

5. Open the generated catapult_server.xcodeproj.

6. Select 'Manually' when prompted to choose either 'Automatically' or 'Manually' manage schemes due to large number of targets in project.

7. In Xcode, set the active schema to catapult.server and execute Product|Build to build the project.

8. If build is successful, click on Run to run catapult server in Xcode. 
Catapult server will abort due to missing configuration file as Nemesis block has not been created yet and config file is missing.
This can be fixed by following the *Create the Genesis Block (Nemesis)..* steps in https://github.com/fullcircle23/catapult-server-macos/README.md.

```
Copyright (c) Jaguar0625, gimre, BloodyRookie, Tech Bureau, Corp.
catapult version: 0.2.0.2 7c8424b [master]
loading resources from "../resources"
[2019-01-28 16:48:53.339321] [0x00000001019c3380] [fatal]   aborting load due to missing configuration file: "../resources/config-network.properties"
unhandled exception while loading configuration!
/Users/ravi/code/src/github.com/fullcircle23/catapult-server-xcode/src/catapult/config/ConfigurationFileLoader.h(38): Throw in function TConfiguration catapult::config::LoadConfiguration(const boost::filesystem::path &, TConfigurationLoader) [TConfigurationLoader = (lambda at /Users/ravi/code/src/github.com/fullcircle23/catapult-server-xcode/src/catapult/config/ConfigurationFileLoader.h:48:34), TConfiguration = catapult::model::BlockChainConfiguration]
Dynamic exception type: boost::exception_detail::clone_impl<catapult::catapult_error<std::runtime_error> >
std::exception::what: aborting load due to missing configuration file
Program ended with exit code: 255
```


