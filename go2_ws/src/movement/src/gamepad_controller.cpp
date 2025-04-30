#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <math.h>

#include "gamepad_controller.h"

GamepadControl::GamepadControl() : Node("gamepad_controller") {
    // Create the sportmodestate subscriber
    stateSuber_ = this->create_subscription<unitree_go::msg::SportModeState>("sportmodestate", 10, std::bind(&GamepadControl::stateCallback, this, std::placeholders::_1));
    // Create the joystick subscriber
    joySuber_ = this->create_subscription<sensor_msgs::msg::Joy>("joy", 10, std::bind(&GamepadControl::joyCallback, this, std::placeholders::_1));
    // Create the reqest publisher
    reqPuber_ = this->create_publisher<unitree_api::msg::Request>("/api/sport/request", 10);
    // Create a timer when called
    timer_ = this->create_wall_timer(std::chrono::milliseconds(100), std::bind(&GamepadControl::timerCallback, this));
}

void GamepadControl::timerCallback() {
    float vx = input.vx;
    float vy = input.vy;
    float vyaw = input.vyaw;

    if (abs(vx) <= 1e-3 && abs(vy) <= 1e-3 && abs(vyaw) <= 1e-3) {
        sportClient_.StopMove(reqMsg_);
    } else {
        sportClient_.Move(reqMsg_, vx, vy, vyaw);
    }

    reqPuber_->publish(reqMsg_);

} 

void GamepadControl::joyCallback(sensor_msgs::msg::Joy::SharedPtr data) {
    input.vx = data->axes[1] * maxSpeed;
    input.vy = data->axes[0] * maxSpeed;
    input.vyaw = data->axes[2] * maxSpeed;
    RCLCPP_INFO(get_logger(), "Gamepad input: %f, %f, %f", input.vx, input.vy, input.vyaw);
}

void GamepadControl::stateCallback(unitree_go::msg::SportModeState::SharedPtr data)
{
    // Get current real position of robot
    currentX_ = data->position[0];
    currentY_ = data->position[1];
    currentYaw_ = data->imu_state.rpy[2];
    RCLCPP_INFO(get_logger(), "Current position: %f, %f, %f", currentX_, currentY_, currentYaw_);
}

int main(int argc, char *argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<GamepadControl>());
    rclcpp::shutdown();
    return 0;
}
