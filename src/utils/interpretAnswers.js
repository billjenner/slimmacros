function trimAnswer(value) {
  return String(value || '').trim()
}

export function normalizeAnswers(answers) {
  return {
    room: trimAnswer(answers?.room),
    cube: trimAnswer(answers?.cube),
    ladder: trimAnswer(answers?.ladder),
    horse: trimAnswer(answers?.horse),
    window: trimAnswer(answers?.window),
    storm: trimAnswer(answers?.storm),
    flowers: trimAnswer(answers?.flowers),
  }
}

function explainAnswer(label, value) {
  return value ? `${label}: ${value}` : ''
}

export async function generateAnswerExplanation(answers) {
  return {
    room: explainAnswer('Room', answers?.room),
    cube: explainAnswer('Cube', answers?.cube),
    ladder: explainAnswer('Ladder', answers?.ladder),
    horse: explainAnswer('Horse', answers?.horse),
    window: explainAnswer('Window', answers?.window),
    storm: explainAnswer('Storm', answers?.storm),
    flowers: explainAnswer('Flowers', answers?.flowers),
  }
}
