return {
	vulkan = {(os.getenv("VULKAN_SDK") or "vulkan_SDK_not_found").."/Include"}, --{[[C:\VulkanSDK\1.3.216.0\Include]]}
	sdl2 = { "C:/SDL2SDK/SDL2-2.28.0/include" }
}