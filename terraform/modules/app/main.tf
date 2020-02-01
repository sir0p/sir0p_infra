resource "google_compute_instance" "app" {
  name         = "${var.name_app}-${count.index}"
  machine_type = "g1-small"
  #zone = "us-central1-a"
  zone  = var.zone
  count = var.count_app
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }
  tags = ["reddit-app"]
  network_interface {
  network = "default"
  access_config {
  nat_ip = google_compute_address.app_ip.address
  }
  }

 # metadata = {
  #  ssh-keys = "appuser:${file(var.appuser_public_key_path)}"
  #}
 # connection {
 #   type  = "ssh"
 #   host  = self.network_interface[0].access_config[0].nat_ip
 #   user  = "appuser"
 #   agent = false
    # путь до приватного ключа
 #   private_key = file(var.appuser_private_key_path)
 # }
  #provisioner "file" {
  #  source      = "files/puma.service"
  #  destination = "/tmp/puma.service"
  #}
 # provisioner "remote-exec" {
  #  script = "files/deploy.sh"
 # }
}
resource "google_compute_address" "app_ip" {
name = "reddit-app-ip"
}
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
