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
            description: 'Learn about Slim Belly and begin your personality journey.',
            canonicalPath: '/',
          },
        },
      },
      {
        path: 'resources',
        component: () => import('pages/Resources.vue'),
        meta: {
          seo: {
            title: 'Resources',
            description: 'Discover the story and idea behind Slim Belly.',
            canonicalPath: '/resources',
          },
        },
      },
      {
        path: 'login',
        component: () => import('pages/Login.vue'),
        meta: {
          seo: {
            title: 'Login',
            description: 'Sign in to continue your Slim Belly experience.',
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
            description: 'Reset your password to access your Slim Belly account.',
            canonicalPath: '/forgot-password',
          },
        },
      },
      {
        path: 'profiles',
        component: () => import('pages/Profiles.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Profiles',
            description: 'Create and manage your Slim Belly profile.',
            canonicalPath: '/profiles',
          },
        },
      },
      {
        path: 'users',
        component: () => import('pages/Users.vue'),
        meta: {
          seo: {
            title: 'Users',
            description: 'View the users and community members in Slim Belly.',
            canonicalPath: '/users',
          },
        },
      },
      {
        path: 'foods',
        component: () => import('pages/Foods.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Foods',
            description: 'Create and manage your Slim Belly food entries.',
            canonicalPath: '/foods',
          },
        },
      },
      {
        path: 'workouts',
        component: () => import('pages/Workouts.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Workouts',
            description: 'Create and manage your Slim Belly workout entries.',
            canonicalPath: '/workouts',
          },
        },
      },
      {
        path: 'supplements',
        component: () => import('pages/supplements.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'supplements',
            description: 'Create and manage your Slim Belly supplement log entries.',
            canonicalPath: '/supplements',
          },
        },
      },
      {
        path: 'food-log',
        component: () => import('pages/Log.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Food Log',
            description: 'Track food consumption and servings throughout the day.',
            canonicalPath: '/food-log',
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
