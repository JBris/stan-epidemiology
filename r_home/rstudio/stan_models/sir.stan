functions {
  real[] SIR(real t, real[] y, real[] theta, 
             real[] x_r, int[] x_i) {

      real S = y[1];
      real I = y[2];
      real R = y[3];
      
      real beta = theta[1];
      real gamma = theta[2];
      
      real dS_dt = -beta * I * S;
      real dI_dt =  beta * I * S - gamma * I;
      real dR_dt =  gamma * I;
      
      return {dS_dt, dI_dt, dR_dt};
  }
}
data {
  int<lower = 1> n_obs;   // number of days observed
  int<lower = 1> n_pop;   // population size
  int y[n_obs];           // data, total number of infected individuals
  real t0;                // initial time point 
  real ts[n_obs];         // time points observed
    int<lower=0> n_pred;    // number of cases to predict forward
  real ts_pred[n_pred];   // future time point
}

transformed data {
  real x_r[0];
  int x_i[0];
  int n_states = 3;
}

parameters {
  real<lower = 0> theta[2]; 
  real<lower = 0, upper = 1> S0; 
}

transformed parameters{
  // ODE solutions
  real<lower = 0, upper = 1> y_hat[n_obs, n_states]; 
  
  // initial SIR fractions
  real<lower = 0, upper = 1> y_init[n_states]; 
  
  real<lower = 0> lambda[n_obs]; 
  
  y_init[1] = S0;
  y_init[2] = 1 - S0;
  y_init[3] = 0;
  y_hat = integrate_ode_rk45(SIR, y_init, t0, ts, theta, x_r, x_i);
  
  for (i in 1:n_obs) {
    lambda[i] = y_hat[i, 2] * n_pop;
  }
}

model {
  theta ~ lognormal(0, 1);
  S0 ~ beta(1, 1);
  y ~ poisson(lambda);
}

generated quantities {
  real R_0 = theta[1] / theta[2];   // Basic reproduction number
  
  vector[n_pred] y_pred;
  vector[n_pred] lambda_pred;
  
  // New initial conditions
  real y_init_pred[3] = y_hat[n_obs, ]; 
  
  // New time zero is the last observed time
  real t0_pred = ts[n_obs];
  
  real y_hat_pred[n_pred, 3];
  
  y_hat_pred = integrate_ode_rk45(SIR, 
                                  y_init_pred, 
                                  t0_pred, 
                                  ts_pred, 
                                  theta, 
                                  x_r, x_i);
  
  for (i in 1:n_pred) {
    lambda_pred[i] = y_hat_pred[i, 2] * n_pop;
    y_pred[i] = poisson_rng(lambda_pred[i]);
  }
}