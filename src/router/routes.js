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
            description: 'Learn about Slim Macros and begin your personality journey.',
            canonicalPath: '/',
          },
        },
      },
      {
        path: 'hub',
        component: () => import('pages/Hub.vue'),
        meta: {
          seo: {
            title: 'Hub',
            description: 'Discover the story and idea behind Slim Macros.',
            canonicalPath: '/hub',
          },
        },
      },
      {
        path: 'login',
        component: () => import('pages/Login.vue'),
        meta: {
          seo: {
            title: 'Login',
            description: 'Sign in to continue your Slim Macros experience.',
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
            description: 'Reset your password to access your Slim Macros account.',
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
            description: 'Create and manage your Slim Macros profile.',
            canonicalPath: '/profiles',
          },
        },
      },
      {
        path: 'goods',
        component: () => import('pages/Goods.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Goods',
            description: 'Manage food, workouts, supplements, and your profile.',
            canonicalPath: '/goods',
          },
        },
      },
      {
        path: 'users',
        component: () => import('pages/Users.vue'),
        meta: {
          seo: {
            title: 'Users',
            description: 'View the users and community members in Slim Macros.',
            canonicalPath: '/users',
          },
        },
      },
      {
        path: 'food',
        component: () => import('pages/Food.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Food',
            description: 'Create and manage your Slim Macros food entries.',
            canonicalPath: '/food',
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
            description: 'Create and manage your Slim Macros workout entries.',
            canonicalPath: '/workouts',
          },
        },
      },
      {
        path: 'supplements',
        component: () => import('pages/Supplements.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'supplements',
            description: 'Create and manage your Slim Macros supplement log entries.',
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
