
set(QT_VERSION_MAJOR 5)

foreach(v ${QtModels})
    message("find package Qt${QT_VERSION_MAJOR}::${v}")
    find_package(QT NAMES Qt${QT_VERSION_MAJOR} COMPONENTS ${v} REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${v} REQUIRED)
endforeach(v)
