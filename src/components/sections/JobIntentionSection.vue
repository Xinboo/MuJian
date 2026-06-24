<script setup lang="ts">
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()
const j = resumeData.jobIntention

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div class="field-row">
      <div class="field">
        <label>期望职位</label>
        <input v-model="j.targetPositions" />
      </div>
      <div class="field">
        <label>期望城市</label>
        <input v-model="j.targetCities" />
      </div>
    </div>
    <div class="field-row">
      <div class="field">
        <label>期望月薪</label>
        <input v-model="j.salaryRange" />
      </div>
      <div class="field">
        <label>期望行业</label>
        <input v-model="j.industry" />
      </div>
    </div>
    <div class="field-row">
      <div class="field">
        <label>工作类型</label>
        <select v-model="j.jobType">
          <option>全职</option><option>兼职</option><option>实习</option>
        </select>
      </div>
      <div class="field">
        <label>求职状态</label>
        <input v-model="j.jobStatus" />
      </div>
    </div>
    <div class="field">
      <label>到岗时间</label>
      <input v-model="j.availability" />
    </div>
  </div>
</template>
