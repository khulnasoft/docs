/** @type {import('@docusaurus/types').DocusaurusConfig} */
module.exports = {
	title: 'Docs Khulnasoft',
	tagline:
		"Here you'll find documentation and reference material for monitoring and troubleshooting your systems with Khulnasoft. Discover new insights of your systems, containers, and applications using per-second metrics, insightful visualizations, and every metric imaginable.",
	url: 'https://docs.khulnasoft.com',
	baseUrl: '/',
	onBrokenLinks: 'warn',
	onBrokenMarkdownLinks: 'warn',
	favicon: 'img/favicon-32x32.png',
	organizationName: 'khulnasoft',
	projectName: 'khulnasoft',
	markdown: {
		mermaid: true,
	},
	themes: ['@docusaurus/theme-mermaid'],
	themeConfig: {
		mermaid: {
			theme: { light: 'neutral', dark: 'forest' },
		},
		image: 'img/khulnasoft_meta-default.png',
		prism: {
			theme: require('prism-react-renderer/themes/dracula'),
		},
		docs: {
			sidebar: {
				hideable: true,
			},
		},
		navbar: {
			title: '',
			logo: {
				alt: 'Khulnasoft Logo',
				src: 'img/logo-letter-green-white.svg',
				height: 145
			},
			items: [
				{
					to: 'https://www.khulnasoft.com/features/',
					position: 'left',
					label: 'Features',
					style: { 'font-weight': '500' }
				},
				{
					to: 'https://www.khulnasoft.com/open-source/',
					position: 'left',
					label: 'Open Source',
					style: { 'font-weight': '500' }
				},
				{
					to: 'https://www.khulnasoft.com/pricing/',
					position: 'left',
					label: 'Pricing',
					style: { 'font-weight': '500' }
				},
				{
					to: 'https://www.khulnasoft.com/integrations/',
					position: 'left',
					label: 'Integrations',
					style: { 'font-weight': '500' }
				},
				{
					position: 'left',
					label: 'Use cases',
					style: { 'font-weight': '500' },
					items: [
						{
							label: 'Response Time',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/response-time-monitoring/'
						},
						{
							label: 'Cloud',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/cloud-monitoring/',
						},
						{
							label: 'Web Servers',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/webserver-monitoring/',
						},
						{
							label: 'Containers',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/container-monitoring/',
						}
					]
				},
				{
					position: 'left',
					label: 'Resources',
					style: { 'font-weight': '500' },
					items: [
						{
							type: 'doc',
							style: { 'color': 'white' },
							docId: 'deployment-guides/deployment-guides',
							label: 'Documentation'
						},
						// {
						// 	type: 'doc',
						// 	style: { 'color': 'white' },
						// 	docId: 'installing/installing',
						// 	label: 'Getting Started'
						// },
						{
							label: 'Community',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/community/',
						},
						{
							label: 'About',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/about/',
						},
						{
							label: 'Forums',
							style: { 'color': 'white' },
							to: 'https://community.khulnasoft.com/',
						},
						{
							label: 'Blog',
							style: { 'color': 'white' },
							to: 'https://blog.khulnasoft.com/',
						},
						{
							label: 'Roadmap',
							style: { 'color': 'white' },
							to: 'https://www.khulnasoft.com/roadmap/'
						},
						{
							label: 'Videos',
							style: { 'color': 'white' },
							to: 'https://www.youtube.com/c/Khulnasoft/'
						},
					]
				},

				{
					to: 'https://app.khulnasoft.com/spaces/khulnasoft-demo?utm_source=docs&utm_content=top_navigation_demo',
					label: 'Live Demo',
					position: 'left',
					// style: {color : '#00ab44'},
					className: 'custom_text',
					style: { 'font-weight': '500' }
				},
				{
					to: 'https://app.khulnasoft.com/',
					label: 'Login',
					position: 'right',
					className: 'button custom_button_grey',
					style: { 'font-weight': '500' }
				},
				{
					to: 'https://app.khulnasoft.com/?utm_source=docs&utm_content=top_navigation_sign_up',
					label: 'Sign Up',
					position: 'right',
					className: 'button custom_button',
					style: { 'font-weight': '500' }

				},
			],
		},
		footer: {

			copyright: `Copyright © ${new Date().getFullYear()} Khulnasoft, Inc.`,
		},
	},
	plugins: [
		[
			"posthog-docusaurus",
			{
				apiKey: 'phc_hnhlqe6D2Q4IcQNrFItaqdXJAxQ8RcHkPAFAp74pubv',
				appUrl: 'https://app.posthog.com',
				enableInDevelopment: false,
			}
		],
		'docusaurus-tailwindcss-loader',
		[
			'@docusaurus/plugin-google-tag-manager',
			{
				containerId: 'GTM-N6CBMJD',
			},
		],
		[
			'@docusaurus/plugin-google-gtag',
			{
				trackingID: 'G-J69Z2JCTFB',
			},
		],
	],
	presets: [
		[
			"classic",
			/** @type {import('@docusaurus/preset-classic').Options} */
			({
				docs: {
					sidebarPath: require.resolve('./sidebars.js'),
					editUrl: 'https://github.com/khulnasoft/khulnasoft/edit/master/',
					docLayoutComponent: "@theme/DocPage",
					showLastUpdateTime: true,
				},
				theme: {
					customCss: [require.resolve('./src/css/custom.css')],
				},
			})
		],
	],
	stylesheets: [
		{
			href: '/font/ibm-plex-sans-v8-latin-regular.woff2',
			rel: 'preload',
			as: 'font',
			type: 'font/woff2',
			crossorigin: '',
		},
		{
			href: '/font/ibm-plex-sans-v8-latin-500.woff2',
			rel: 'preload',
			as: 'font',
			type: 'font/woff2',
			crossorigin: '',
		},
		{
			href: '/font/ibm-plex-sans-v8-latin-700.woff2',
			rel: 'preload',
			as: 'font',
			type: 'font/woff2',
			crossorigin: '',
		},
		{
			href: '/font/ibm-plex-mono-v6-latin-regular.woff2',
			rel: 'preload',
			as: 'font',
			type: 'font/woff2',
			crossorigin: '',
		},
	],
	scripts: [],
};
