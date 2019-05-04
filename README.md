# RestyRP

Fronts a web app to provide authentication. Uses NGINX with OpenRESTY and a Keycloak broker for auth and consists of two Docker containers. It's pretty sweet.

### Quick Start
- Install deps
`sudo apt install docker.io uuid docker-compose`
- Get code
`git clone https://github.com/gyrospectre/restyrp.git`
- Run
`cd restyrp`
`./run_rp.sh`
- Open a browser to https://<server-ip>, login with initial user on default creds to change password
`testuser:NEWPASSWORD`
- Login to the Keycloak admin console to delete the intial user, and/or add more. See the [Keycloak Documentation](https://www.keycloak.org/docs/3.3/server_admin/topics/users/create-user.html) for more details on adding a user.
http://<server-ip>:8080/auth/admin
- Note that your app needs to be listening on TCP/5000, this is the default backend port the proxy forwards to. If you need to change it, modify `nginx.conf` in the root directory and re-run the build.
   ```python
   location / {
      proxy_pass http://{{ LOCAL_IP }}:5000;
    }
   ```

### Todos
 - Remove hardcoded admin creds in build
 - Move Keycloak to TLS rather than plain HTTP
