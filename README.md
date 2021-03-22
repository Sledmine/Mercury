<html>
    <p align="center">
        <img width="300px" src="assets/images/mercury.png"/>
    </p>
    <h1 align="center">Mercury</h1>
    <p align="center">
       Halo Custom Edition Package Manager
    </p>
</html>

## What is Mercury?

Is a console program that gives you some features such as downloading an installing tools, addons, mods and maps for your Halo Custom Edition game, everything you need in one place being downloaded in the pure developer style, basically a software package manager oriented to a game with mods.

![Mercury GIF](https://i.imgur.com/kzVgOu3.gif)

## What is the purpose of Mercury?

- Get access into our package repository and download the latest or the oldest version of your favorite packages.
- Manage your favorite mods or addons perform different actions for them such as, install, update, remove, etc.

# Installing Mercury

To download and use Mercury in your computer you have to download Windows binaries from the [releases](https://github.com/Sledmine/Mercury/releases) tab or from the official site, there is an installer for easier setup.

# Documentation

We are working on a Wiki for Mercury, stay tuned, some markdowns will be hosted here as well:

- [Mercury Packages](PACKAGE.md)

# Contribute to Mercury

Feel free to fork and ask for pull requests to this repository, we are looking for an interface application for Mercury so any frontend developer is welcome!

# Building Mercury

Mercury uses [luapower](https://luapower.com) as the base of the project, this is needed to get the required amount of modules and files to bundle/compile the code in this repository.
**There are known some problems with precompiled libs, try to compile static libs from LuaPower csrc folder if you are having problems at bundle time.**

Mingw-w64 is required to compile the project, at least for Windows builds.

- [Mingw-w64](http://mingw-w64.org/doku.php)

These modules are required for the project, they are already included on my fork of luapower as [luapower-all-x86-x64](https://github.com/Sledmine/luapower-all-x86-x64):

- [argparse](https://github.com/luarocks/argparse)
- [registry](https://github.com/Tieske/registry)
- [middleclass](https://github.com/kikito/middleclass)
- [semver](https://github.com/kikito/semver.lua)
- [luaunit](https://github.com/bluebird75/luaunit)

However using luapower was a bad decision due to the lack of documentation and support of it, so we are working to migrate this
to use luarocks instead to use the vast support of modules and project management used there.

# Development Environment

If you want to modify and verify code in this repository you will have a couple of tools to
test everything in your local environment, some unit testing is being added continuously.

## Run with LuaJIT
Luapower follows a structure where everything must be inside the root folder to work, by just making a Symlink of your cloned respository into the Luapower folder you will be able to run, you can clone your repository directly in the Luapower folder but we would like to recommend you to create a symlink.

After that you can just use this command in the luapower folder to run it:
```
luajit mercury\mercury.lua
```

## Mocking Vulcano API and Server

You can run a mock of a Vulcano API with a testing repository server using [easymock](https://github.com/CyberAgent/node-easymock) and the commands below:
```
cd tests\server
easymock
```

# FAQ

## Luapower is a cross platform framework, why is this only working for Windows?

Halo Custom Edition only works in a Windows environment by native running or via emulation using
Wine for example, so creating a package manager for Linux would be a little bit weird if the game
itself only runs on Windows, but after some work migration a Linux build would be possible in the future.