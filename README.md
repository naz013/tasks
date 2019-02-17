## Tasks

Simple Reminder Application

<img src="https://github.com/naz013/tasks/raw/master/data/scr_main.png" width="600" alt="Screenshot">

## Building, Testing, and Installation

You'll need the following dependencies:
* libgee-0.8-dev
* libgranite-dev (>=0.5)
* libgtk-3-dev
* libjson-glib-dev
* libglib2.0-dev
* meson
* valac (>= 0.26)

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `io.elementary.appcenter`

    sudo ninja install
    com.github.naz013.tasks
