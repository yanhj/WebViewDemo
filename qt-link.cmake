
foreach(v ${QtModels})
    target_link_libraries(${PROJECT_NAME} Qt${QT_VERSION_MAJOR}::${v})
endforeach(v)