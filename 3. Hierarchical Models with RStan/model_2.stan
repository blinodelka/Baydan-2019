data {
	int<lower=1> nY; // количество наблюдений (всего)
	int<lower=1> nS; // количество испытуемых
	int<lower=1,upper=nS> Subj[nY]; // вектор с номерами испытуемых
	vector[nY] cond; // условие (воздействие - нет воздействия)
	vector[nY] Y; // результат
}
parameters {
	real<lower=0> sigma; // общий шум наблюдений
	real intercept_mu; // среднее смещение по популяции
	real effect_mu; // средний размер эффекта по популяции
	real<lower=0> intercept_sd; // вариативность смещения по популяции
	real<lower=0> effect_sd; // вариативность размера эффекта по популяции
	vector[nS] intercept; // вектор индивидуальных смещений
	vector[nS] effect; // вектор индивидуальных размеров эффекта
}
model {
  // априорные распределения
	sigma ~ cauchy(0,3);
	intercept_mu ~ normal(5,10);
	effect_mu ~ normal(0,10);
	intercept_sd ~ cauchy(0,3);
	effect_sd ~ cauchy(0,3);

	intercept ~ normal(intercept_mu,intercept_sd); // распределение индивидуальных смещений
	effect ~ normal(effect_mu,effect_sd); // распределение индивидуальных размеров эффекта

	for(i in 1:nY){
		Y[i] ~ normal(intercept[Subj[i]] + effect[Subj[i]]*cond[i], sigma); // правдоподобие наблюдений с учетом индивидуальных смещений и размеров эффекта
	}

}