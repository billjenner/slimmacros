const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      {
        path: '',
        component: () => import('pages/Intro.vue'),
        meta: {
          seo: {
            title: 'Home',
            description: 'Learn about The Cube Game and begin your personality journey.',
            canonicalPath: '/',
          },
        },
      },
      {
        path: 'personality-review',
        component: () => import('pages/PersonalityReview.vue'),
        meta: {
          seo: {
            title: 'Personality review',
            description:
              'Review and explore saved personality insights and answers in The Cube Game.',
            canonicalPath: '/personality-review',
          },
        },
      },
      {
        path: 'analyze',
        component: () => import('pages/PersonalityGame.vue'),
        meta: {
          seo: {
            title: 'Analyze your personality',
            description:
              'Play the interactive personality Game and see how your answers are interpreted.',
            canonicalPath: '/analyze',
          },
        },
      },
      {
        path: 'personality-game',
        redirect: '/analyze',
      },
      {
        path: 'theary',
        component: () => import('pages/Concept.vue'),
        meta: {
          seo: {
            title: 'The concept',
            description: 'Discover the story and idea behind The Cube Game.',
            canonicalPath: '/theary',
          },
        },
      },
      {
        path: 'login',
        component: () => import('pages/Login.vue'),
        meta: {
          seo: {
            title: 'Login',
            description: 'Sign in to continue your The Cube Game experience.',
            canonicalPath: '/login',
          },
        },
      },
      {
        path: 'create-login',
        component: () => import('pages/CreateLogin.vue'),
        meta: {
          seo: {
            title: 'Create account',
            description: 'Create an account to save your personality results.',
            canonicalPath: '/create-login',
          },
        },
      },
      {
        path: 'forgot-password',
        component: () => import('pages/ForgotPassword.vue'),
        meta: {
          seo: {
            title: 'Forgot password',
            description: 'Reset your password to access your The Cube Game account.',
            canonicalPath: '/forgot-password',
          },
        },
      },
      {
        path: 'users',
        component: () => import('pages/Users.vue'),
        meta: {
          seo: {
            title: 'Users',
            description: 'View the users and community members in The Cube Game.',
            canonicalPath: '/users',
          },
        },
      },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
    meta: {
      seo: {
        title: 'Page not found',
        description: 'The page you requested could not be found.',
        canonicalPath: '/404',
        robots: 'noindex,follow',
      },
    },
  },
]

export default routes
