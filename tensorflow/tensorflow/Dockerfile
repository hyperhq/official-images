FROM tensorflow/tensorflow:latest
# Start a CPU-only container with Python 2

RUN apt-get update && \
        apt-get install -y --no-install-recommends fio apache2-utils iperf redis-tools sysbench  && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

COPY benchmarks/scripts/ /benchmarks/scripts/
