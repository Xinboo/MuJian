<script setup lang="ts">
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}
</script>

<template>
  <div class="section-body" @input="onDataChange">
    <div class="field">
      <label>个人优势</label>
      <textarea v-model="resumeData.strengths" class="auto-height" />
    </div>
  </div>
</template>
