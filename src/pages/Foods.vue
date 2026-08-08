<template>
  <q-page class="q-pa-md">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <q-card flat bordered class="q-pa-md">
          <div class="row items-center justify-between q-mb-md">
            <div class="text-h5">Foods</div>
            <q-btn
              color="primary"
              class="q-mb-sm"
              unelevated
              :label="showFoodForm ? 'Hide Form' : 'Add Food'"
              @click="showFoodForm = !showFoodForm"
            />
          </div>

          <q-banner v-if="store.error" class="bg-negative text-white q-mb-md" rounded>
            {{ store.error }}
          </q-banner>

          <q-banner
            v-else-if="!usersStore.currentUser"
            class="bg-warning text-dark q-mb-md"
            rounded
          >
            Sign in to create a food entry.
          </q-banner>

          <transition name="form-slide" mode="out-in">
            <q-form
              v-if="showFoodForm"
              key="food-form"
              @submit.prevent="submitFood"
              class="q-gutter-md"
            >
              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Food details</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12">
                    <q-input
                      v-model="food.description"
                      label="Description"
                      filled
                      dense
                      :rules="[(value) => !!value?.trim() || 'Description is required']"
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.protein"
                      type="number"
                      label="Protein"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.carb"
                      type="number"
                      label="Carbs"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.fat"
                      type="number"
                      label="Fat"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.calories_extra"
                      type="number"
                      label="Extra calories"
                      min="0"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>
                </div>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Serving information</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-6">
                    <q-input
                      v-model="food.serving_size"
                      type="number"
                      label="Serving size"
                      min="0.01"
                      step="0.01"
                      filled
                      dense
                    />
                  </div>

                  <div class="col-12 col-md-6">
                    <q-select
                      v-model="food.serving_unit"
                      :options="servingUnitOptions"
                      label="Serving unit"
                      filled
                      dense
                      emit-value
                      map-options
                    />
                  </div>
                </div>
              </q-card>

              <q-card flat bordered class="q-pa-md bg-grey-1">
                <div class="text-subtitle1 q-mb-sm">Preferences</div>
                <div class="row q-col-gutter-md">
                  <div class="col-12 col-md-4">
                    <q-toggle v-model="food.my_food" label="My food" />
                  </div>

                  <div class="col-12 col-md-4">
                    <q-toggle v-model="food.favorite_food" label="Favorite" />
                  </div>

                  <div class="col-12 col-md-4">
                    <q-toggle v-model="food.share_with_others" label="Share with others" />
                  </div>
                </div>
              </q-card>

              <div class="row justify-end q-gutter-sm">
                <q-btn type="submit" color="primary" label="Save food" :loading="store.loading" />
              </div>
            </q-form>
          </transition>

          <q-dialog v-model="confirmDeleteOpen">
            <q-card style="min-width: 320px">
              <q-card-section class="text-h6">Delete food?</q-card-section>
              <q-card-section>
                Are you sure you want to delete food {{ pendingDeleteFood?.description || '' }}?
              </q-card-section>
              <q-card-actions align="right">
                <q-btn flat label="No" color="primary" @click="cancelDeleteFood" />
                <q-btn label="Yes" color="negative" @click="confirmDeleteFood" />
              </q-card-actions>
            </q-card>
          </q-dialog>

          <q-card flat bordered class="q-pa-md bg-grey-1 q-mt-md">
            <div class="text-subtitle1 q-mb-sm">Saved foods</div>

            <q-table
              :rows="foodRows"
              :columns="foodColumns"
              row-key="food_id"
              flat
              bordered
              dense
              hide-header
              :loading="store.loading"
              no-data-label="No food records yet."
            >
              <template #body="props">
                <!-- Main row -->
                <q-tr :props="props">
                  <q-td key="description" :props="props">
                    <div class="row items-center full-width">
                      <q-btn
                        size="sm"
                        color="secondary"
                        dense
                        round
                        :icon="isExpanded(props.row) ? 'remove' : 'add'"
                        @click="toggleExpanded(props.row)"
                      />

                      <span class="q-ml-lg">
                        {{ props.row.description }}
                      </span>

                      <!-- Push buttons to right -->
                      <div class="row items-center q-gutter-xs q-ml-auto">
                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="primary"
                          label="Edit"
                          @click="editFood(props.row)"
                        />

                        <q-btn
                          flat
                          dense
                          size="sm"
                          color="primary"
                          label="Delete"
                          @click="requestDeleteFood(props.row)"
                        />
                      </div>
                    </div>
                  </q-td>
                </q-tr>

                <!-- Expanded row -->
                <q-tr v-if="isExpanded(props.row)" :props="props">
                  <q-td :colspan="foodColumns.length" class="bg-grey-2">
                    <div class="row q-col-gutter-sm q-py-sm">
                      <div class="col-12">
                        <div class="text-caption text-grey-7 q-mb-xs">Calories vs budget</div>
                        <q-linear-progress
                          :value="
                            Math.min(
                              1,
                              (calculateFoodCalories({
                                carbs: props.row.carb,
                                protein: props.row.protein,
                                fat: props.row.fat,
                                extraCalories: props.row.calories_extra,
                              }) || 0) /
                                (calculateTotalCaloriesForPerson({
                                  totalDailyCalories: 2000,
                                  dailyCalorieDeficit: 0,
                                }) || 1),
                            )
                          "
                          color="accent"
                          size="24px"
                          rounded
                        />
                      </div>

                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Protein</div>
                        <div class="text-body2">{{ props.row.protein ?? 0 }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Carbs</div>
                        <div class="text-body2">{{ props.row.carb ?? 0 }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Fat</div>
                        <div class="text-body2">{{ props.row.fat ?? 0 }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Extra calories</div>
                        <div class="text-body2">{{ props.row.calories_extra ?? 0 }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Serving size</div>
                        <div class="text-body2">{{ props.row.serving_size ?? 1 }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Serving unit</div>
                        <div class="text-body2">{{ props.row.serving_unit || 'unit' }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">My food</div>
                        <div class="text-body2">{{ props.row.my_food ? 'Yes' : 'No' }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Favorite</div>
                        <div class="text-body2">{{ props.row.favorite_food ? 'Yes' : 'No' }}</div>
                      </div>
                      <div class="col-12 col-sm-6 col-md-3">
                        <div class="text-caption text-grey-7">Share with others</div>
                        <div class="text-body2">
                          {{ props.row.share_with_others ? 'Yes' : 'No' }}
                        </div>
                      </div>
                    </div>
                  </q-td>
                </q-tr>
              </template>
            </q-table>
          </q-card>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useUsersStore } from 'stores/users'
import { useFoodsStore } from 'stores/foods'
import { calculateFoodCalories, calculateTotalCaloriesForPerson } from '../utils/rules'

const usersStore = useUsersStore()
const store = useFoodsStore()

const servingUnitOptions = [
  { label: 'Cup', value: 'cup' },
  { label: 'Ounce', value: 'oz' },
  { label: 'Grams', value: 'grams' },
  { label: 'Slice', value: 'slice' },
  { label: 'Bar', value: 'bar' },
  { label: 'Unit', value: 'unit' },
]

const food = reactive({
  description: '',
  protein: 0,
  carb: 0,
  fat: 0,
  calories_extra: 0,
  my_food: true,
  favorite_food: false,
  share_with_others: false,
  serving_size: 1,
  serving_unit: 'unit',
  is_active: true,
})

const foodColumns = [
  {
    name: 'description',
    label: 'Description',
    field: 'description',
    align: 'left',
    sortable: true,
  },
]

const foodRows = computed(() => store.foods || [])
const showFoodForm = ref(false)
const confirmDeleteOpen = ref(false)
const pendingDeleteFood = ref(null)
const expandedFoodIds = ref([])

onMounted(() => {
  if (usersStore.currentUser?.user_id) {
    loadFoodsForCurrentUser(usersStore.currentUser.user_id)
  }
})

watch(
  () => usersStore.currentUser?.user_id,
  (userId) => {
    if (userId) {
      loadFoodsForCurrentUser(userId)
    } else {
      store.foods = []
    }
  },
)

async function loadFoodsForCurrentUser(userId) {
  if (!userId) {
    return
  }

  await store.loadFoods(userId)
}

function isExpanded(row) {
  return expandedFoodIds.value.includes(row?.food_id)
}

function toggleExpanded(row) {
  if (!row?.food_id) {
    return
  }

  if (isExpanded(row)) {
    expandedFoodIds.value = expandedFoodIds.value.filter((foodId) => foodId !== row.food_id)
  } else {
    expandedFoodIds.value = [...expandedFoodIds.value, row.food_id]
  }
}

function editFood(row) {
  Object.assign(food, {
    description: row.description || '',
    protein: row.protein ?? 0,
    carb: row.carb ?? 0,
    fat: row.fat ?? 0,
    calories_extra: row.calories_extra ?? 0,
    my_food: row.my_food !== false,
    favorite_food: Boolean(row.favorite_food),
    share_with_others: Boolean(row.share_with_others),
    serving_size: row.serving_size ?? 1,
    serving_unit: row.serving_unit || 'unit',
    is_active: row.is_active !== false,
  })

  showFoodForm.value = true
}

function requestDeleteFood(row) {
  pendingDeleteFood.value = row
  confirmDeleteOpen.value = true
}

function cancelDeleteFood() {
  pendingDeleteFood.value = null
  confirmDeleteOpen.value = false
}

async function confirmDeleteFood() {
  const row = pendingDeleteFood.value
  pendingDeleteFood.value = null
  confirmDeleteOpen.value = false

  if (!usersStore.currentUser?.user_id || !row?.food_id) {
    store.error = 'No current user is available.'
    return
  }

  const { error } = await store.deactivateFood(usersStore.currentUser.user_id, row.food_id)
  if (!error) {
    await loadFoodsForCurrentUser(usersStore.currentUser.user_id)
  }
}

async function submitFood() {
  if (!usersStore.currentUser?.user_id) {
    store.error = 'No current user is available.'
    return
  }

  const savedFood = await store.createFood(usersStore.currentUser.user_id, food)
  if (savedFood) {
    Object.assign(food, {
      description: '',
      protein: 0,
      carb: 0,
      fat: 0,
      calories_extra: 0,
      my_food: true,
      favorite_food: false,
      share_with_others: false,
      serving_size: 1,
      serving_unit: 'unit',
      is_active: true,
    })

    showFoodForm.value = false
    await loadFoodsForCurrentUser(usersStore.currentUser.user_id)
  }
}
</script>

<style scoped>
.form-slide-enter-active,
.form-slide-leave-active {
  transition: all 0.45s ease;
}

.form-slide-enter-from,
.form-slide-leave-to {
  opacity: 0;
  transform: translateY(12px);
}

.form-slide-enter-to,
.form-slide-leave-from {
  opacity: 1;
  transform: translateY(0);
}
</style>
