data {
	int<lower=1> nY; // количество наблюдений (всего)
	int<lower=1> nS; // количество испытуемых
	int<lower=1,upper=nS> Subj[nY]; // вектор с номерами испытуемых
	vector[nY] cond; // условие
	vector[nY] Y; // вектор наблюдений
}

parameters {
	real<lower=0> sigma; // стандартное отклонение (шум) измерения, одинаковое для всех испытуемых 
	real intercept_mu; // среднее смещение по всем испытуемым
	real<lower=0> intercept_sd ; // стандартное отклонение (вариация) смещения среди испытуемых
  real effect; // размер эффекта 
	vector[nS] intercept ; // переменная, чтобы сохранять смещение для каждого из испытуемых
}

model {
	// априорные распределения
	sigma ~ cauchy(0,3);
	intercept_mu ~ normal(5,10);
  intercept_sd ~ cauchy(0,3);
	effect ~ normal(0,10);

	// "откуда" (из какого распределения по популяции) генерировались индивидуальные смещения 
	intercept ~ normal(intercept_mu,intercept_sd);

	// генерация наблюдений с учетом индивидуального смещения и условия
	for(i in 1:nY){
		Y[i] ~ normal(intercept[Subj[i]] + effect*cond[i] , sigma) ;
	}

}