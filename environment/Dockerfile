# hash:sha256:bbfaf4f54dfe25e880e6573febc0034a40185a769d11f418c4573fc3e0edc3d4
FROM registry.codeocean.com/codeocean/r-studio:r-4.5.1-1.2204.0-rstudio-server-2025.05.1-513-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN Rscript -e 'remotes::install_version("Cairo", "1.6-5")' \
    && Rscript -e 'remotes::install_version("afex", "1.5-0")' \
    && Rscript -e 'remotes::install_version("antiword", "1.3.4")' \
    && Rscript -e 'remotes::install_version("effsize", "0.8.1")' \
    && Rscript -e 'remotes::install_version("filehash", "2.4-6")' \
    && Rscript -e 'remotes::install_version("ggsci", "4.0.0")' \
    && Rscript -e 'remotes::install_version("ggsignif", "0.6.4")' \
    && Rscript -e 'remotes::install_version("lme4", "1.1-37")' \
    && Rscript -e 'remotes::install_version("lmerTest", "3.1-3")' \
    && Rscript -e 'remotes::install_version("stm", "1.3.8")' \
    && Rscript -e 'remotes::install_version("tidyverse", "2.0.0")' \
    && Rscript -e 'remotes::install_version("tm", "0.7-16")'
