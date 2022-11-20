Pony.options = {
	via: :smtp,
	via_options: {
		address: 'smtp.sendgrid.net',
		port: '587',
		domain: 'careertrainingconcepts.com',
		user_name: 'mmorgan',
		password: 'Numb3rTwo',
		authentication: :plain,
		enable_starttls_auto: true
	}
}