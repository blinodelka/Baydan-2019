data {
  int<lower = 0> N;  // размер выборки
  vector[N] X; // вектор с предиктор
  vector[N] Y; // вектор с целевой переменной
}

parameters {
  real intercept; // смещение
  real slope; // угол наклона регрессионной прямой (эффект предиктора на целевую переменную)
  real<lower = 0> sigma; // шум наблюдений
}

model {
  intercept ~ normal(0, 10); // априорное распределение смещения
  slope ~ normal(0, 1); // априорное распределение угла наклона
  sigma ~ cauchy(0, 3); // априорное распределение шума наблюдения
  for(i in 1:N) {
    Y[i] ~ normal(intercept + slope * X[i], sigma); // функция правдоподобия
  }
}

generated quantities {
  vector[N] Y_hat; 
  for(i in 1:N) {
    Y_hat[i] = normal_rng(intercept + slope * X[i], sigma); // генерация предсказаний целевой переменной исходя из оценок параметров
  }
}