resource "local_file" "arquivo" {
  filename = "${path.root}/saida/${var.nome}.txt"
  content  = "ambiente=${var.nome}"
}
