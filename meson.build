# Name our project
project('com.github.naz013.tasks', ['vala', 'c'],
    version: '1.0.0'
)

# Import main lib files
gnome = import('gnome')
i18n = import('i18n')

# Set this for convenience
conf = configuration_data()

# Get the package data directory under Meson
pkgdatadir = join_paths([ get_option('prefix'),
                          get_option('datadir'),
                          'com.github.naz013.tasks' ])

conf.set_quoted('PKGDATADIR', pkgdatadir)

# Other configs
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf
add_global_arguments('-DDATADIR="' + get_option('datadir') + '"', language: 'c')
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

# Arguments for C
c_args = [
  '-include', 'config.h',
  '-w'
]

cc = meson.get_compiler('c')

gresource_tasks = gnome.compile_resources(
    'gresource_icons',
    'data/maya.gresource.xml',
    source_dir: 'data'
)

# Let's define our executable
executable(
    meson.project_name(),
    gresource_tasks,
    'src/Application.vala',
    'src/HomeWindow.vala',
    'src/models/Event.vala',
    'src/services/EventManager.vala',
    'src/services/TasksController.vala',
    'src/config/AppSettings.vala',
    'src/config/AppTheme.vala',
    'src/config/LightTheme.vala',
    'src/config/DarkTheme.vala',
    'src/config/SandTheme.vala',
    'src/config/OliveTheme.vala',
    'src/config/GrapeTheme.vala',
    'src/config/Logger.vala',
    'src/config/Utils.vala',
    'src/config/Strings.vala',
    'src/ui/components/SnackBar.vala',
    'src/ui/components/MaterialButton.vala',
    'src/ui/components/FloatingActionButton.vala',
    'src/ui/CssData.vala',
    'src/ui/CreateView.vala',
    'src/ui/ListView.vala',
    'src/ui/EmptyView.vala',
    'src/ui/TimerView.vala',
    'src/ui/BeforePickerView.vala',
    'src/ui/RepeatPickerView.vala',
    'src/ui/SettingsView.vala',
    'src/ui/MainContainer.vala',
    c_args: c_args,
    dependencies: [
        dependency('granite'),
        dependency('gobject-2.0'),
        dependency('gtksourceview-3.0'),
        dependency('json-glib-1.0'),
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('gtk+-3.0')
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi',
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install : true
)

# Add subfolders for Meson to look
subdir('data')
subdir('po')

# Add in a post install script
meson.add_install_script('meson/post_install.py')
