sudo apt-get install -y libXt
sudo apt-get update -y
sudo apt-get install -y  libxt-dev
sudo apt-get install -y  libxt
sudo apt-get install -y  libXt
sudo apt-get install -y  libxt-dev
mkdir stan_models
mkdir stan_models/models_influenza
touch stan_models/models_influenza/sir_negbin.stan
cd stan_models/models_influenza/
cp sir_negbin.stan sir_prior.stan
cd ../..
mkdir data
wget https://raw.githubusercontent.com/charlesm93/disease_transmission_workflow/refs/heads/main/data/swiss_agg_data.csv
mv swiss_agg_data.csv  data/
ls
cd stan_models/models_influenza/
ls
touch sir_incidence.stan
mv sir_incidence.stan  seir_forcing.stan
cd
ls
mv sir.qmd seir.qmd
wget https://raw.githubusercontent.com/stan-dev/example-models/refs/heads/master/knitr/car-iar-poisson/bym_predictor_plus_offset.stan
mv bym_predictor_plus_offset.stan stan_models/
ls stan_models/bym_predictor_plus_offset.stan 
cd stan_models/
wget https://raw.githubusercontent.com/stan-dev/example-models/refs/heads/master/knitr/car-iar-poisson/bym_predictor_plus_offset.stan
wget https://raw.githubusercontent.com/stan-dev/example-models/refs/heads/master/knitr/car-iar-poisson/bym2.stan
wget https://github.com/stan-dev/example-models/raw/refs/heads/master/knitr/car-iar-poisson/nyc_subset.data.R
