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
        path: 'dashboard',
        component: () => import('pages/Dashboard.vue'),
        meta: {
          seo: {
            title: 'Dashboard',
            description: 'Overview of your Slim Macros activities.',
            canonicalPath: '/dashboard',
          },
        },
      },
      {
        path: 'docs',
        component: () => import('pages/Docs.vue'),
        meta: {
          seo: {
            title: 'Docs',
            description: 'Discover the story and idea behind Slim Macros.',
            canonicalPath: '/docs',
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
        path: 'reset-password',
        component: () => import('pages/ResetPassword.vue'),
        meta: {
          seo: {
            title: 'Reset password',
            description: 'Choose a new password for your Slim Macros account.',
            canonicalPath: '/reset-password',
          },
        },
      },
      {
        path: 'change-password',
        component: () => import('pages/ChangePassword.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Change password',
            description: 'Change the password for your Slim Macros account.',
            canonicalPath: '/change-password',
          },
        },
      },
      {
        path: 'profile',
        component: () => import('src/pages/Profile.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Profile',
            description: 'Create and manage your Slim Macros profile.',
            canonicalPath: '/profile',
          },
        },
      },
      {
        path: 'items',
        component: () => import('pages/Items.vue'),
        meta: {
          requiresAuth: true,
          seo: {
            title: 'Items',
            description: 'Manage food, workouts, supplements, and your profile.',
            canonicalPath: '/items',
          },
        },
      },
      {
        path: 'users',
        component: () => import('pages/Users.vue'),
        meta: {
          requiresAuth: true,
          requiresAdmin: true,
          seo: {
            title: 'Users',
            description: 'View the users and community members in Slim Macros.',
            canonicalPath: '/users',
          },
        },
      },
      {
        path: 'feedback',
        component: () => import('pages/Feedback.vue'),
        meta: {
          requiresAuth: true,
          requiresAdmin: true,
          seo: {
            title: 'Feedback',
            description: 'View feedback submitted by Slim Macros users.',
            canonicalPath: '/feedback',
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
