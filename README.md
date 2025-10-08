# Docker Dev Wrapper

This contains the recipe for building a Docker developer image based on another iamge. 

The following arguments can be passed at build time:
- `BASE_IMAGE`: The image that shall be wrapped
- `DIALOUT_GID`: The groupid of the local dialout group (default: 20)

When run, a SSH server is started. The default login password for user `user` is `test` (configurable via environemnt variable `SSH_USER_PASSWORD`). 
