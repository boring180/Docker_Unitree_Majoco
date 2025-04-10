from unitree_sdk2py.core.channel import ChannelFactoryInitialize
from unitree_sdk2py.go2.video.video_client import VideoClient
import cv2
import numpy as np
import sys
import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image

class AprilTag(Node):
    def __init__(self):
        super().__init__("april_tag")
        self.declare_parameter("channel", 0)
        self.pub = self.create_publisher(Image, "april_tag", 10)
        self.client = VideoClient()
        timer_period = 0.1
        self.timer = self.create_timer(timer_period, self.timer_callback)
        if len(self.get_parameter("channel").get_parameter_value().string_value) == 0:
            ChannelFactoryInitialize(0)
        else:
            ChannelFactoryInitialize(0, self.get_parameter("channel").get_parameter_value().string_value)

    def timer_callback(self):
        code, data = self.client.GetImageSample()
        if code == 0:
            image_data = np.frombuffer(bytes(data), dtype=np.uint8)
            image = cv2.imdecode(image_data, cv2.IMREAD_COLOR)
        else:
            self.get_logger().error("Get image sample error. code: %d", code)
            return

        self.pub.publish(image)
        
def main(args=None):
    rclpy.init(args=args)
    april_tag = AprilTag()
    rclpy.spin(april_tag)
    april_tag.destroy_node()
    rclpy.shutdown()
    
if __name__ == "__main__":
    main()

