output "VMs_ips" {
  description = "List of VMs static IPs"
  value       = [for i in range(2) : "192.168.100.1${10 + i}"]
}
