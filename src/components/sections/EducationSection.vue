<script setup lang="ts">
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}

function addEntry() {
  resumeData.education.push({
    id: crypto.randomUUID(), logo: '', school: '', startDate: '', endDate: '', degree: '本科', major: '',
  })
  onDataChange()
}

function removeEntry(i: number) {
  resumeData.education.splice(i, 1)
  onDataChange()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div v-for="(edu, i) in resumeData.education" :key="edu.id" class="entry-block">
      <div class="entry-head">
        <span class="entry-label">学历 {{ i + 1 }}</span>
        <button class="del-btn" @click="removeEntry(i)">删除</button>
      </div>
      <div class="field">
        <label>学校</label><input v-model="edu.school" />
      </div>
      <div class="field">
        <label>学校Logo</label><input v-model="edu.logo" placeholder="url / base64" />
      </div>
      <div class="field-row">
        <div class="field"><label>开始时间</label><input type="month" v-model="edu.startDate" /></div>
        <div class="field"><label>结束时间</label><input type="month" v-model="edu.endDate" /></div>
      </div>
      <div class="field-row">
        <div class="field">
          <label>学历</label>
          <select v-model="edu.degree">
            <option>博士</option><option>硕士</option><option>本科</option>
            <option>大专</option><option>中专</option><option>高中</option>
          </select>
        </div>
        <div class="field"><label>专业</label><input v-model="edu.major" /></div>
      </div>
    </div>
    <button class="add-btn" @click="addEntry">+ 添加教育经历</button>
  </div>
</template>
