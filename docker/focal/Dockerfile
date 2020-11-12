# Use an official Python runtime as a parent image
FROM ratflow-core-focal

# Set the working directory inside container
WORKDIR /

# Install any needed packages

ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN apt install -y --allow-unauthenticated  \
    ratflow-desktop

# Run entrypoint

EXPOSE 5900/tcp

ENTRYPOINT ["/entrypoint.sh"]
