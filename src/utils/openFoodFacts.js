const FIELDS = [
  'code',
  'product_name',
  'product_name_en',
  'generic_name',
  'brands',
  'image_front_url',
  'serving_size',
  'nutriments',
  'nutrition_data_prepared_per',
  'nutriscore_grade',
  'nutrition_grades',
  'ingredients_text',
  'allergens',
].join(',')

const VALID_UNITS = [
  'oz',
  'gram',
  'cup',
  'scoop',
  'bar',
  'can',
  'count',
  'item',
  'piece',
  'pinch',
  'serving',
  'slice',
  'tab',
  'tbsp',
  'tsp',
]

const UNIT_ALIASES = {
  ounce: 'oz',
  g: 'gram',
  tablespoon: 'tbsp',
  teaspoon: 'tsp',
  tablet: 'tab',
}

export async function fetchOpenFoodFactsProduct(barcode) {
  const url =
    `https://world.openfoodfacts.net/api/v2/product/${encodeURIComponent(String(barcode).trim())}` +
    `?fields=${encodeURIComponent(FIELDS)}`

  // The .net staging server requires basic auth (off:off)
  const response = await fetch(url, {
    headers: { Accept: 'application/json', Authorization: 'Basic ' + btoa('off:off') },
  })
  if (response.status === 404) return null
  if (!response.ok) throw new Error(`Open Food Facts API Error HTTP: ${response.status}`)

  const data = await response.json()
  return data.status === 1 ? data.product : null
}

function normalizeUnit(rawUnit) {
  let unit = String(rawUnit || '')
    .trim()
    .toLowerCase()
  if (UNIT_ALIASES[unit]) return UNIT_ALIASES[unit]
  if (!VALID_UNITS.includes(unit) && unit.endsWith('s')) unit = unit.slice(0, -1)
  if (UNIT_ALIASES[unit]) return UNIT_ALIASES[unit]
  return VALID_UNITS.includes(unit) ? unit : 'serving'
}

// "1 bar (15 g)" -> { size: 1, unit: 'bar', grams: 15 }
export function parseServingSize(text) {
  const raw = String(text || '').trim()

  const full = raw.match(/^([\d.]+)\s*([^\d(]*?)\s*\(\s*([\d.]+)\s*(?:g|ml)\b/i)
  if (full) {
    return { size: Number(full[1]) || 1, unit: normalizeUnit(full[2]), grams: Number(full[3]) }
  }

  const gramsOnly = raw.match(/^([\d.]+)\s*(?:g|ml)\b/i)
  if (gramsOnly) return { size: 1, unit: 'serving', grams: Number(gramsOnly[1]) }

  return { size: 1, unit: 'serving', grams: null }
}

const round1 = (value) => Math.round(value * 10) / 10

// Prefix the first brand unless the product name already contains it
function buildDescription(product) {
  const name = String(product?.product_name_en || product?.product_name || '').trim()
  const brand = String(product?.brands || '')
    .split(',')[0]
    .trim()
  if (!brand || name.toLowerCase().includes(brand.toLowerCase())) return name
  return `${brand} ${name}`.trim()
}

export function mapProductToFood(product) {
  const nutriments = product?.nutriments || {}
  const serving = parseServingSize(product?.serving_size)
  const perServing = product?.nutrition_data_prepared_per === 'serving'

  // Per-100g values scaled by the serving's gram weight; fall back to 100g when unknown
  const scale = (key) => {
    if (perServing) return Number(nutriments[`${key}_serving`] ?? nutriments[key]) || 0
    const per100 = Number(nutriments[`${key}_100g`] ?? nutriments[key]) || 0
    return round1(((serving.grams ?? 100) / 100) * per100)
  }

  const result = {
    description: buildDescription(product),
    serving_size: serving.size,
    serving_unit: serving.unit,
    protein: scale('proteins'),
    carb: scale('carbohydrates'),
    fat: scale('fat'),
    calories_extra: 0,
  }

  console.log('Open Food Facts -> food fields', result)
  return result
}
