module.exports = {
	parser: '@typescript-eslint/parser',
	parserOptions: {
		sourceType: 'module',
	},
	plugins: [ '@typescript-eslint/eslint-plugin' ],
	extends: [
		'plugin:@typescript-eslint/eslint-recommended',
		'plugin:@typescript-eslint/recommended',
		'prettier',
	],
	root: true,
	env: {
		node: true,
		jest: true,
	},
	rules: {
		'@typescript-eslint/explicit-function-return-type': 'warn',
		'@typescript-eslint/no-explicit-any': 'warn',
		'array-bracket-spacing': [ 2, 'always' ],
		'@typescript-eslint/naming-convention': [
			'error',
			{
				'selector': 'interface',
				'format': [ 'PascalCase' ],
				'custom': {
					'regex': '^I[A-Z]',
					'match': true,
				},
			},
			{
				'selector': [ 'function' ],
				'format': [ 'camelCase' ],
				'leadingUnderscore': 'forbid',
			},
			{
				'selector': 'variable',
				'format': [ 'camelCase', 'UPPER_CASE', 'PascalCase' ],
			},
		],
	},
};