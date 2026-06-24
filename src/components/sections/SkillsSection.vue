<script setup lang="ts">
import type { SkillLevel } from '../../types/resume'
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()

const skillLevels: SkillLevel[] = ['精通', '熟练', '良好', '一般']

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}

function addEntry() {
  resumeData.skills.push({ id: crypto.randomUUID(), name: '', level: '熟练' })
  onDataChange()
}

function removeEntry(i: number) {
  resumeData.skills.splice(i, 1)
  onDataChange()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div v-for="(s, i) in resumeData.skills" :key="s.id" class="skill-row">
      <input v-model="s.name" placeholder="技能名称" class="skill-input" />
      <select v-model="s.level" class="skill-select">
        <option v-for="l in skillLevels" :key="l" :value="l">{{ l }}</option>
      </select>
      <button class="del-btn-sm" @click="removeEntry(i)">×</button>
    </div>
    <button class="add-btn" @click="addEntry">+ 添加技能</button>
  </div>
</template>
