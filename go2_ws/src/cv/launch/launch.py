from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='cv',
            executable='april_tag',
            name='april_tag',
            output='screen',
            emulate_tty=True,
            parameters=[
                {'channel': 'enp8s0'}
            ]
        )
    ])