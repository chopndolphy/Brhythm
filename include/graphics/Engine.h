#pragma once

#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEPTH_ZERO_TO_ONE

#include <vk_mem_alloc.h>
#include <vulkan/vulkan.h>
#include <VkBootstrap.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iostream>

#include "Window.h"

class Engine {
    public:
        void SimpleTest();
        void Init();
        void Run();
        void Cleanup();
    private:
        void initWindow();
        void initVulkan();
};