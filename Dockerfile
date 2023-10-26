FROM python:3.9-alpine

LABEL org.opencontainers.image.author="Spiros Styliaras <spirosstyliaras@gmail.com> " \
      org.opencontainers.image.description="General purpose robotframework Docker image"

# Set robotframework workspace directory
ENV ROBOT_WORK_DIR /opt/robotframework

# Set robotframework test directory
# This is the directory where test framework we want to execute will be mounted to
ENV ROBOT_TEST_FRAMEWORK_DIR $ROBOT_WORK_DIR/testframework

# Set robotframework logs and reports output directory
# This is the directory where robot execution output files log.html, report.html and ouput.xml will be saved
ENV ROBOT_LOGS_DIR $ROBOT_WORK_DIR/logs

# Set robot user that will be used in runtime
ARG ROBOT_USER=robot
ARG ROBOT_GROUP=robot
ARG ROBOT_USER_UID=1000
ARG ROBOT_GROUP_ID=1000

# Install Python and any needed packages
RUN apk add --update-cache bash python3 python3-dev py3-pip \
    gcc musl-dev linux-headers libffi-dev && \
    python3 --version && \
    rm -rf /var/cache/apk/* 

# Create runtime robot group and user
RUN addgroup -g $ROBOT_GROUP_ID \
    -S $ROBOT_GROUP && \
    adduser -S -D -G $ROBOT_GROUP \
    -g "Robot User" \
    -u $ROBOT_USER_UID \
    -h $ROBOT_WORK_DIR \
    -s /bin/sh $ROBOT_USER

# Create the workspace, tests and logs folders owned by the runtime user
RUN mkdir -p $ROBOT_WORK_DIR && \
  mkdir -p $ROBOT_TEST_FRAMEWORK_DIR && \
  mkdir -p $ROBOT_LOGS_DIR && \
  chown ${ROBOT_USER}:${ROBOT_GROUP} $ROBOT_WORK_DIR && \
  chown ${ROBOT_USER}:${ROBOT_GROUP} $ROBOT_TEST_FRAMEWORK_DIR && \
  chown ${ROBOT_USER}:${ROBOT_GROUP} $ROBOT_LOGS_DIR

# Copy Robot execution script and change rights
COPY scripts/robotRun.sh /usr/local/bin/robotRun.sh
RUN chmod +x /usr/local/bin/robotRun.sh && \ 
    chown ${ROBOT_USER}:${ROBOT_GROUP} /usr/local/bin/robotRun.sh

# Update system PATH
ENV PATH=$ROBOT_WORK_DIR/.local/bin:$PATH

# Set the user to use when running the image
USER $ROBOT_USER:$ROBOT_GROUP

# Install Python requirements i.e robotframework and other needed packages
COPY pip_requirements.txt $ROBOT_WORK_DIR/pip_requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r $ROBOT_WORK_DIR/pip_requirements.txt

# Set image working directory
WORKDIR $ROBOT_TEST_FRAMEWORK_DIR

CMD ["robotRun.sh"]
