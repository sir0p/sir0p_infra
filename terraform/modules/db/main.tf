resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  #zone = "us-central1-a"
  zone  = var.zone
  #count = var.count_db
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  tags = ["reddit-db"]
  network_interface {
  network = "default"
  access_config {}
  }
}
resource "google_compute_firewall" "firewall_mongo" {
  name = "allow-mongo-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}