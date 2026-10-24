// Shared build for the four variant Dockerfiles.
// Tags, labels, and annotations come from docker/metadata-action,
// which fills the docker-metadata-action target in CI.

variable "PHP_VERSION" {
  default = "8.5"
}

variable "ALPINE_VERSION" {
  default = "3.24"
}

target "docker-metadata-action" {}

target "_common" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  // Tasker is published as a linux/amd64 binary.
  platforms  = ["linux/amd64"]
  args = {
    PHP_VERSION    = PHP_VERSION
    ALPINE_VERSION = ALPINE_VERSION
  }
}

target "mysql" {
  inherits   = ["_common"]
  dockerfile = "docker/php-mysql.Dockerfile"
}

target "mysql-nginx" {
  inherits   = ["_common"]
  dockerfile = "docker/php-mysql-nginx.Dockerfile"
}

target "pgsql" {
  inherits   = ["_common"]
  dockerfile = "docker/php-pgsql.Dockerfile"
}

target "pgsql-nginx" {
  inherits   = ["_common"]
  dockerfile = "docker/php-pgsql-nginx.Dockerfile"
}

group "default" {
  targets = ["mysql", "mysql-nginx", "pgsql", "pgsql-nginx"]
}
