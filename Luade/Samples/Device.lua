-- This example shows how getting device information.

print(device.name())
print(device.model())
print(device.systemName().." "..device.systemVersion())

print("\n")

charging = "not charging"
if device.isCharging() then
    charging = "charging"
end

print("Battery level: "..device.batteryLevel()..", "..charging)
