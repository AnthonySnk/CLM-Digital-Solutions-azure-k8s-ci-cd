# Reto-DevOps CLM  - FAVOR FIJARSE SOLUCIÓN AL FINAL DE CADA PUNTO REQUERIDO

![CLM Consoltores](./img/clm.png)

**COMENTARIOS:**

Antes de empezar quisiera aclarar lo realizado de manera general pero la solución la pondré mediante un make action bajo cada punto.
Brevemente aclararé que usé Azure DevOps para realizar el pipeline, usé la mayoría de make actions para cada stage. Realicé casí todos los puntos a excepción de helm porque no tuve tiempo para investigar ya que no tengo experiencia creando charts, sólo he usado helm para instalar y personalizar un par de charts. 
Otro punto que tampoco pude realizar de la mejor manera fue hacer el auth_basic con un secreto ya que pase la contraseña en texto plano en el dockerfile. Es decir, hice la solución pero no de la mejor manera.

Aprovecho para agradecer por la oportunidad. El reto fue muy interesante y estoy bastante contento por haber realizado casí todo pero soy consciente que hay que aprender bastante, y es por eso que busco un lugar donde seguir creciendo técnicamente.

Por último quisiera mencionar que para poder probar el pipeline levanté una ec2 con conexión a un cluster EKS Fargate(en éste momento ya no funciona) para probar que el pipeline se ejecuta exitosamente. En la solución de ese punto pasaré los links para que se aprecien los logs de ejecucion.

¡Espero les agrade mi solución!

## La app
![NodeJs](./img/nodejs.png)

```bash
$ git clone https://gitlab.com/clm-public/reto-devops.git
Cloning into 'reto-devops'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (3/3), done.
$ cd ./reto-devops

```
### Instalar Dependencias
```bash
$ npm install
npm WARN basicservice@1.0.0 No repository field.
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@2.1.2 (node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@2.1.2: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})

added 530 packages from 308 contributors and audited 1203947 packages in 34.589s

21 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```
### Ejecutar Test
![Jest](./img/jest.jpg)

```bash
$ npm run test

> basicservice@1.0.0 test /basic-unit-test
> jest

 PASS  tests/sum.test.js
 PASS  tests/string.test.js

Test Suites: 2 passed, 2 total
Tests:       3 passed, 3 total
Snapshots:   0 total
Time:        5.655s
Ran all test suites.
```
> **SOLUCIÓN:** Usando "make test-app" el pipeline si es exitoso procede al siguiente stage.

### Ejecutar la app
```bash
$ node index.js
Example app listening on port 3000!
```
Podrá acceder a la API localmente en el puerto `3000`.

```bash
$ curl -s localhost:3000/ | jq
{
  "msg": "ApiRest prueba"
}
$ curl -s localhost:3000/public | jq
{
  "public_token": "12837asd98a7sasd97a9sd7"
}
$ curl -s localhost:3000/private | jq
{
  "private_token": "TWFudGVuIGxhIENsYW1hIHZhcyBtdXkgYmllbgo="
}
```

**NT:** En nuestro equipo consideramos que cada aplicación debe venir bien documentada por parte del desarrollador para que el equipo de **DevOps** puede realizar los procesos de automatización de una manera mas eficaz.

## El reto comienza aquí
Tienes que hacer un **fork** de este repositorio para completar los siguientes retos en tu propia cuenta de `gitlab`. **Siéntete libre de resolver el reto que desees.** La cantidad de retos resueltos nos va a permitir valorar tus habilidades y realizar una **oferta en base a las mismas**.

1. Una vez completado, no olvide notificar la solución al **Carla Santiago (csantiago@clmconsultores.com).**
2. **La solución debe venir bien documentada, ten en cuenta que vamos a ejecutar la solución que nos envies para realizar la evaluación**
3. **Tiempo de solución 3 días**

Si tiene alguna duda, adelante, [abre un issue](https://gitlab.com/clm-public/reto-devops/issues) para hacer cualquier pregunta sobre cualquier reto.

### Reto 1. Dockerize la aplicación
![docker](./img/nodedoker.jpg)

¿Qué pasa con los contenedores? En este momento **(2021)**, los contenedores son un estándar para implementar aplicaciones **(en la nube o en sistemas locales)**. Entonces, el reto es:
1. Construir la imagen más pequeña que pueda. Escribe un buen Dockerfile :)
2. Ejecutar la app como un usuario diferente de root.

> **SOLUCIÓN:** Realicé la imagen lo más pequeña posible. Con "make build-image" se crea el contenedor y se sube a un registry para ser usado por kubernetes en el deployment.

### Reto 2. Docker Compose
![compose](./img/docker-compose.png)

Una vez que haya dockerizado todos los componentes de la API *(aplicación de NodeJS)*, estarás listo para crear un archivo docker-compose, en nuestro equipo solemos usarlo para levantar ambientes de desarrollo antes de empezar a escribir los pipeline. Ya que la aplicación se ejecuta sin ninguna capa para el manejo de protocolo http, añace:

1. Nginx que funcione como proxy reverso a nuesta app Nodejs
2. Asegurar el endpoint /private con auth_basic
3. Habilitar https y redireccionar todo el trafico 80 --> 443

> **SOLUCIÓN:** Usando "make test-compose-locally" se puede levantar los contenedores localmente y se puede apreciar que las peticiones se redirigen al puerto 80 y que el endpoint "/private" tiene autenticación. La configuración de nginx redirige el tráfico de http a https pero la comenté para que pueda ejecutarse en localhost en el puerto 80.

### Reto 3. Probar la aplicación en cualquier sistema CI/CD
![cicd](./img/cicd.jpg)

Como buen ingeniero devops, conoces las ventajas de ejecutar tareas de forma automatizada. Hay algunos sistemas de cicd que pueden usarse para que esto suceda. Elige uno, travis-ci, gitlab-ci, circleci ... lo que quieras. Danos una tubería exitosa. **Gitlab-CI** es nuestra herramienta de uso diario por lo cual obtendras puntos extras si usas gitlab.

> **SOLUCIÓN:** Como se aprecía estoy dando acceso a un proyeto de Azure DevOps y se puede ver aquí el pipeline como código. Lo siento por no haber podido resolverlo en GitLab pero sin duda que quisiera aprenderlo. Ah y que mencionar que también hice un pipeline de CI-CD juntos que no lo ejecuté pero se puede ver en el archivo "azure-pipelines_CI-CD.yml"

> Link al pipeline de CI: https://dev.azure.com/davarmijos/CLM%20Digital%20Solutions/_build/index?definitionId=21

> Link al pipeline de CD: https://dev.azure.com/davarmijos/CLM%20Digital%20Solutions/_release?_a=releases&view=mine&definitionId=1

### Reto 4. Deploy en kubernetes
![k8s](./img/k8s.png)

Ya que eres una máquina creando contenedores, ahora queremos ver tu experiencia en k8s. Use un sistema kubernetes para implementar la API. Recomendamos que uses herramientas como Minikube o Microk8s.

Escriba el archivo de implementación (archivo yaml) utilizalo para implementar su API (aplicación Nodejs).

* añade **Horizontal Pod Autoscaler** a la app NodeJS

> **SOLUCIÓN:** Usando "make deploy_k8s_aws" se despliegan todos los manifiestos. El hpa se testea con "make test-hpa" mediante un pod que genera tráfico, y cabe aclarar que previamente el cluster fue aprovisionado con metrics-server para ser usuado con el hpa. Ésta solución fue testeada en minikube y EKS. En minikube se debe activar el addon "metrcis-server" así "minikube addons enable metrics-server". Cabe mencionar que para probar el servicio se puede hacer esto: kubectl run -i --tty busybox --image=busybox --restart=Never -- /bin/sh -c "curl http://app-node-svc:3000" .  (Favor fijarse que el curl cierra la comilla)

### Reto 6. Terraform
![docker](./img/tf.png)

En estos días en IaC no se habla de más nada que no sea terraform, en **CLM** ya nos encontramos con pipeline automatizados de Iac. El reto consiste en crear un modulo de terraform que nos permita crear un **rbac.authorization de tipo Role** que solo nos permita ver los pods de nuestro **namespace donde se encuentra al app Nodejs**

> **SOLUCIÓN:** Creé un módulo que usando "make terraform" creará un Rol que consulta sólo los pods del namespace. La manera de validar el funcionamiento sería: kubectl get pods -n node-nginx --as=clm

### Reto 7. Automatiza el despliegue de los retos realizados
![docker](./img/make.gif)

Ya que hoy en día no queremos recordar recetas ni comandos, el reto consiste en **automatizar los retos en un Makefile**, considera especificar cuales son las dependencias necesarias para que tu Makefile se ejecute sin problemas.

> **SOLUCIÓN:** Se adjunta Makefile.

¡¡ MUCHAS GRACIAS POR LA LECTURA !!
