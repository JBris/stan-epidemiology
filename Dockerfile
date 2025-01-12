FROM ghcr.io/jbris/stan-cmdstanr-gpu-docker:2.32.1

RUN install2.r --error --skipmissing --skipinstalled -n -1 \
    priorsense \
    outbreaks \
    glmnet \
    maptools \ 
    spdep \
    rgdal \ 
    survminer \
    && strip /usr/local/lib/R/site-library/*/libs/*.so