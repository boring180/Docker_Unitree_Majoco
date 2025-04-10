cmake_minimum_required(VERSION 3.8)
project(movement)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

include_directories(include include/common include/nlohmann)
link_directories(src)

set (
  DEPENDENCY_LIST
  unitree_go
  unitree_api
  rclcpp
  sensor_msgs
)

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(unitree_go REQUIRED)
find_package(unitree_api REQUIRED)
find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)

add_executable(gamepad_controller src/gamepad_controller.cpp src/common/ros2_sport_client.cpp)
ament_target_dependencies(gamepad_controller ${DEPENDENCY_LIST})

install(TARGETS
  gamepad_controller
  DESTINATION lib/${PROJECT_NAME})

install(DIRECTORY
  launch
  DESTINATION share/${PROJECT_NAME}/
)

ament_package()
