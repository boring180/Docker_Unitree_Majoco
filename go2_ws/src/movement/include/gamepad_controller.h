#ifndef SRC_GAME_CONTROLLER_H
#define SRC_GAME_CONTROLLER_H

#include <unistd.h>
#include <stdio.h>

#include "rclcpp/rclcpp.hpp"
#include "unitree_go/msg/sport_mode_state.hpp"
#include "unitree_api/msg/request.hpp"
#include "common/ros2_sport_client.h"
#include "sensor_msgs/msg/joy.hpp"

static const float maxSpeed = 0.3;

class GamepadInput
{
    public:
    float vx;
    float vy;
    float vyaw;
    GamepadInput() : vx(0), vy(0), vyaw(0) {}
};

class GamepadControl : public rclcpp::Node
{
public:
    GamepadControl();

private:

    GamepadInput input;

    void timerCallback();

    void stateCallback(unitree_go::msg::SportModeState::SharedPtr data);

    void joyCallback(sensor_msgs::msg::Joy::SharedPtr data);

    rclcpp::Subscription<unitree_go::msg::SportModeState>::SharedPtr stateSuber_;
    rclcpp::Publisher<unitree_api::msg::Request>::SharedPtr reqPuber_;
    rclcpp::Subscription<sensor_msgs::msg::Joy>::SharedPtr joySuber_;
    rclcpp::TimerBase::SharedPtr timer_;

    unitree_api::msg::Request reqMsg_;
    SportClient sportClient_;

    float currentX_, currentY_, currentYaw_;
};


#endif