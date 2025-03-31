import launch
from launch_ros.actions import Node

def generate_launch_description():
    return launch.LaunchDescription([
        Node(
            package='joy',
            executable='joy_node',
            name='joy_node',
            output='screen',
        ),
        Node(
            package='movement',
            executable='gamepad_controller', 
            name='movement_node',
            output='screen',
        ),
    ]) 