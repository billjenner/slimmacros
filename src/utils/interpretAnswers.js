import personalityMappings from '../components/PersonalityMappings.json'

const fieldMap = {
  room: 'Room',
  cube: 'Cube',
  ladder: 'Ladder',
  horse: 'Horse',
  window: 'Window',
  storm: 'Storm',
  flowers: 'Flowers',
}

function normalizeText(value) {
  return String(value || '')
    .toLowerCase()
    .trim()
}

function findMatches(text, matchList) {
  const normalizedText = normalizeText(text)
  return matchList.filter((term) => normalizedText.includes(term))
}

function getInterpretationText(valueData) {
  if (!valueData || typeof valueData !== 'object') {
    return ''
  }

  return valueData.interpretation || valueData.interpretatio || ''
}

function buildFallbackExplanation(field, answerText, mapping) {
  const text = normalizeText(answerText)

  if (!text) {
    return ''
  }

  if (!mapping) {
    return `${field.charAt(0).toUpperCase() + field.slice(1)} seems to carry symbolic meaning—consider how it made you feel and what role it played in the scene.`
  }

  const interpretations = []

  Object.entries(mapping.features || {}).forEach(([featureName, featureValues]) => {
    Object.entries(featureValues).forEach(([valueName, valueData]) => {
      const aliases = [valueName.toLowerCase()]

      if (featureName === 'size' && ['small', 'large', 'vast'].includes(valueName)) {
        aliases.push(...['tiny', 'big', 'immense', 'spacious', 'expansive'])
      }

      if (featureName === 'windows' && ['many', 'few', 'none'].includes(valueName)) {
        aliases.push(...['window', 'windows', 'no windows', 'several'])
      }

      if (featureName === 'doors' && ['multiple', 'one', 'none'].includes(valueName)) {
        aliases.push(...['door', 'doors', 'entry', 'entrance'])
      }

      if (featureName === 'comfort' && ['comfortable', 'uncomfortable'].includes(valueName)) {
        aliases.push(...['cozy', 'safe', 'warm', 'cold', 'unsettling'])
      }

      if (featureName === 'safety' && ['safe', 'unsafe'].includes(valueName)) {
        aliases.push(...['secure', 'protected', 'threatened', 'vulnerable'])
      }

      if (featureName === 'position' && ['ground', 'floating'].includes(valueName)) {
        aliases.push(...['on the ground', 'hovering', 'air'])
      }

      if (featureName === 'location' && ['prominent', 'hidden', 'distant'].includes(valueName)) {
        aliases.push(...['front', 'center', 'back', 'far', 'near'])
      }

      if (featureName === 'transparency' && ['transparent', 'opaque'].includes(valueName)) {
        aliases.push(...['clear', 'see through', 'cloudy', 'hidden'])
      }

      if (featureName === 'texture' && ['smooth', 'rough'].includes(valueName)) {
        aliases.push(...['soft', 'hard', 'uneven'])
      }

      if (featureName === 'condition' && ['perfect', 'damaged'].includes(valueName)) {
        aliases.push(...['whole', 'broken', 'injured'])
      }

      if (featureName === 'support' && ['leaning', 'freeStanding'].includes(valueName)) {
        aliases.push(...['supported', 'standing', 'independent'])
      }

      if (featureName === 'height' && ['tall', 'short'].includes(valueName)) {
        aliases.push(...['high', 'low'])
      }

      if (featureName === 'climbDifficulty' && ['easy', 'difficult'].includes(valueName)) {
        aliases.push(...['simple', 'hard'])
      }

      if (featureName === 'material' && ['strong', 'fragile'].includes(valueName)) {
        aliases.push(...['solid', 'delicate'])
      }

      if (
        featureName === 'appearance' &&
        ['beautifulHealthy', 'injuredNeglected'].includes(valueName)
      ) {
        aliases.push(...['beautiful', 'healthy', 'injured', 'neglected'])
      }

      if (
        featureName === 'behavior' &&
        ['calm', 'energetic', 'wild', 'tamed', 'playful', 'running', 'restless'].includes(valueName)
      ) {
        aliases.push(...['peaceful', 'restless', 'unruly', 'gentle', 'playful', 'running'])
      }

      if (featureName === 'distance' && ['close', 'far'].includes(valueName)) {
        aliases.push(...['near', 'distant'])
      }

      if (
        featureName === 'relationshipToCube' &&
        ['touching', 'near', 'close', 'far'].includes(valueName)
      ) {
        aliases.push(...['close', 'beside', 'separate'])
      }

      if (
        featureName === 'relationshipToRoom' &&
        ['insideRoom', 'outsideRoom'].includes(valueName)
      ) {
        aliases.push(...['inside', 'outside'])
      }

      if (featureName === 'relationshipToWindow' && ['open', 'closed'].includes(valueName)) {
        aliases.push(...['open', 'closed'])
      }

      if (featureName === 'openClosed' && ['open', 'closed'].includes(valueName)) {
        aliases.push(...['open', 'closed'])
      }

      if (featureName === 'presence' && ['exists', 'missing'].includes(valueName)) {
        aliases.push(...['present', 'there', 'none', 'missing'])
      }

      if (featureName === 'outsideView' && ['pleasant', 'dark'].includes(valueName)) {
        aliases.push(...['bright', 'sunny', 'clear', 'dark', 'gloomy'])
      }

      if (featureName === 'clarity' && ['clear', 'dirty', 'broken'].includes(valueName)) {
        aliases.push(...['clean', 'cloudy', 'covered', 'cracked'])
      }

      if (featureName === 'intensity' && ['calm', 'stormy'].includes(valueName)) {
        aliases.push(...['quiet', 'chaotic'])
      }

      if (featureName === 'flowerCondition' && ['healthy', 'wilted'].includes(valueName)) {
        aliases.push(...['alive', 'dead', 'fresh'])
      }

      if (featureName === 'flowerPlacement' && ['inside', 'outside'].includes(valueName)) {
        aliases.push(...['indoors', 'outdoors'])
      }

      if (featureName === 'distanceFromCube' && ['close', 'far', 'touching'].includes(valueName)) {
        aliases.push(...['near', 'beside', 'next to', 'distant'])
      }

      if (featureName === 'distanceFromRoom' && ['near', 'far'].includes(valueName)) {
        aliases.push(...['close', 'distant'])
      }

      if (featureName === 'strength' && ['hardy', 'fragile'].includes(valueName)) {
        aliases.push(...['strong', 'delicate'])
      }

      if (featureName === 'lifeState' && ['alive', 'dead'].includes(valueName)) {
        aliases.push(...['living', 'wilted'])
      }

      if (featureName === 'careRequired' && ['needsCare', 'thriving'].includes(valueName)) {
        aliases.push(...['attention', 'care', 'healthy'])
      }

      if (featureName === 'yourRole' && ['protecting', 'caring', 'ignoring'].includes(valueName)) {
        aliases.push(...['protect', 'care for', 'neglect'])
      }

      if (featureName === 'yourFeeling' && ['love', 'fear'].includes(valueName)) {
        aliases.push(...['love', 'afraid', 'fear'])
      }

      if (featureName === 'yourFeelings' && ['positive', 'negative'].includes(valueName)) {
        aliases.push(...['good', 'happy', 'uneasy', 'negative'])
      }

      if (
        featureName === 'howFlowersFeelAboutYou' &&
        ['thrivingNearYou', 'neglected'].includes(valueName)
      ) {
        aliases.push(...['thriving', 'neglected'])
      }

      if (findMatches(text, aliases).length) {
        const interpretationText = getInterpretationText(valueData)
        if (interpretationText) {
          interpretations.push(interpretationText)
        }
      }
    })
  })

  if (interpretations.length) {
    const explanation = interpretations.slice(0, 2).join(' ')
    return explanation
  }

  return `${field.charAt(0).toUpperCase() + field.slice(1)} seems to carry a thoughtful symbolic meaning that may relate to identity, growth, relationships, or emotional awareness.`
}

export async function generateAnswerExplanation(answers) {
  const explanations = {}
  const apiKey = import.meta.env.VITE_OPENAI_API_KEY

  for (const [field, mappingName] of Object.entries(fieldMap)) {
    const answerText = answers[field] || ''
    const mapping = personalityMappings[mappingName]

    if (!answerText.trim()) {
      explanations[field] = ''
      continue
    }

    if (apiKey) {
      try {
        const response = await fetch('https://api.openai.com/v1/chat/completions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${apiKey}`,
          },
          body: JSON.stringify({
            model: 'gpt-4o-mini',
            messages: [
              {
                role: 'system',
                content:
                  'You are a careful interpretation assistant. Explain this single answer in a short, supportive sentence using the symbolic mapping themes.',
              },
              {
                role: 'user',
                content: `Answer: ${answerText}\n\nMapping theme: ${mapping?.symbol || `${mappingName} symbolic theme`}`,
              },
            ],
            temperature: 0.6,
          }),
        })

        if (response.ok) {
          const data = await response.json()
          const content = data?.choices?.[0]?.message?.content?.trim()
          if (content) {
            explanations[field] = content
            continue
          }
        }
      } catch (error) {
        console.warn(
          `OpenAI explanation request failed for ${field}, using fallback mapping.`,
          error,
        )
      }
    }

    explanations[field] = buildFallbackExplanation(field, answerText, mapping)
  }

  return explanations
}
