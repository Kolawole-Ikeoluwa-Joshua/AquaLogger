# Fluentd basic demo

This is a simple demo of standardized and centralized logging in a container environment.

## Fluentd service summary:

- The fluentd service runs a container based on the fluent/fluentd:v1.11-debian image.
- It mounts host directories into the container for storing container logs, Fluentd configuration, and output logs.
- The user running the container is set to root.
- The logging driver is set to "local."

## Start service

```
docker-compose up
```

While Fluentd is running start up another container

```
docker run -it redis
```

Notice redis logs are now collected in the log output buffer
