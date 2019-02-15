FROM ubuntu:bionic

RUN apt-get update && apt install --yes --no-install-recommends build-essential python python3 python3-dev python3-pip gnupg curl openjdk-8-jdk git

WORKDIR /opt

RUN pip3 install -U pip six numpy wheel mock
RUN pip3 install -U keras_applications==1.0.6 --no-deps
RUN pip3 install -U keras_preprocessing==1.0.5 --no-deps
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
# RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
# RUN apt-get update && apt-get install --yes --no-install-recommends bazel=0.15.0
RUN apt-get install -y --no-install-recommends bash-completion g++ zlib1g-dev
RUN curl -LO "https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel_0.15.0-linux-x86_64.deb"
RUN dpkg -i bazel_*.deb
RUN git clone https://github.com/tensorflow/tensorflow.git
WORKDIR /opt/tensorflow
RUN git checkout r1.12
RUN TF_NEED_IGNITE=False TF_ENABLE_XLA=False PYTHON_BIN_PATH=/usr/bin/python3.6 ./configure
RUN bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
RUN apt-get install --yes --no-install-recommends python-setuptools python3-setuptools
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

CMD ["bash"]
