module "rolebinding" {
    source = "./module"

    name = "clm"
    namespace = "node-nginx"
}