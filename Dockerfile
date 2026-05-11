FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    apktool \
    openjdk-21-jre-headless \
    nodejs \
    npm \
    wget \
    grep \
    zip \
    coreutils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/tools/FCDroid

COPY . /workspace/tools/FCDroid

# Install Python dependencies used by the analysis code path.
RUN pip install --no-cache-dir \
    androguard==3.3.5 \
    beautifulsoup4 \
    requests \
    pymongo \
    lxml

# Install Node dependency used by TaintJS analyzer.
RUN cd TaintJS && npm install --no-audit --no-fund --no-save esprima
RUN npm install -g retire --no-audit --no-fund

# Create analysis output directories and data input mount point.
RUN mkdir -p /workspace/tools/FCDroid/log \
    /workspace/tools/FCDroid/json \
    /workspace/tools/FCDroid/temp_html_code \
    /data/apks

RUN chmod +x /workspace/tools/FCDroid/run_sample_analysis.sh

WORKDIR /workspace/tools

CMD ["/workspace/tools/FCDroid/run_sample_analysis.sh"]
