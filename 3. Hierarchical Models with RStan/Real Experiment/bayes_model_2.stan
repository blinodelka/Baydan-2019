data {
	int<lower=1> nY; // количество наблюдений (всего)
	int<lower=1> nS; // количество испытуемых
	int<lower=1,upper=nS> Subj[nY]; // вектор с номерами испытуемых для каждого из наблюдений
	vector[nY] size_diff; // целевой предиктор, разница между стимулами
	vector[nY] num_of_trials; // количество установочных проб, не понадобится
	int<lower = 0, upper = 1> Y[nY]; // результат: какой тип иллюзии наблюдался. 1 - ассимилятивная, 0 - контрастная
}

parameters {
	real intercept_mu; // среднее смещение по всем испытуемым 
	real<lower = 0> intercept_sd; // вариативность смещения
	vector[nS] intercept; // вектор смещений 
	real beta; // размер эффекта, общий для всех испытуемых
}

model {
	// априорные распределения
	beta ~ normal(0,1); 
	intercept_mu ~ beta(1,1);
	intercept_sd ~ cauchy(0,3);


	// "откуда" (из какого распределения по популяции) генерировались индивидуальные смещения
	intercept ~ normal(intercept_mu, intercept_sd);

	// генерация наблюдений с учетом общего смещения и индивидуальных эффектов (логистическая регрессия)
	for(i in 1:nY){
		Y[i] ~ bernoulli_logit(intercept[Subj[i]] + beta*size_diff[i]);
	}
}
