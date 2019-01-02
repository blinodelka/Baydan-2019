data {
  int<lower = 0> N;  // размер выборки
  vector[N] X; // вектор наблюдений
}

parameters {
  real<lower = 0> sigma; // оцениваемый параметр: стандартное отклонение нормального распределения
}

model {
  target += cauchy_lpdf(sigma | 0,15); // априорное распределение стандартного отклонения
  target += normal_lpdf(X | 100, sigma); // функция правдоподобия
}