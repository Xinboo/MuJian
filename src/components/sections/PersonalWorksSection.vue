<script setup lang="ts">
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}

function addEntry() {
  resumeData.personalWorks.push({ id: crypto.randomUUID(), link: '', description: '' })
  onDataChange()
}

function removeEntry(i: number) {
  resumeData.personalWorks.splice(i, 1)
  onDataChange()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div v-for="(w, i) in resumeData.personalWorks" :key="w.id" class="entry-block">
      <div class="entry-head">
        <span class="entry-label">作品 {{ i + 1 }}</span>
        <button class="del-btn" @click="removeEntry(i)">删除</button>
      </div>
      <div class="field"><label>作品链接</label><input v-model="w.link" placeholder="https://" /></div>
      <div class="field"><label>作品描述</label><input v-model="w.description" /></div>
    </div>
    <button class="add-btn" @click="addEntry">+ 添加作品</button>
  </div>
</template>
