# Purely informational
EXPOSE 8000

# https://docs.docker.com/engine/reference/builder/

# CMD: defaults for a running container, e.g. default argument to ENTRYPOINT
CMD ["/usr/bin/wc", "--help"]  # preferred form

# ARG, contrary to ENV, are not persisted in the resulting image
ARG NPM_TOKEN

# ENTRYPOINT: configure a container that will run as an executable
FROM ubuntu
ENTRYPOINT ["top", "-b"]
CMD ["-c"]
