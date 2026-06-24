<script setup lang="ts">
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()

const now = new Date()
const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}

function addEntry() {
  resumeData.projectExperience.push({
    id: crypto.randomUUID(), name: '', startDate: '', endDate: '', isCurrentProject: false, company: '', link: '', techStack: '', description: '', responsibility: '', achievement: '',
  })
  onDataChange()
}

function removeEntry(i: number) {
  resumeData.projectExperience.splice(i, 1)
  onDataChange()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div v-for="(proj, i) in resumeData.projectExperience" :key="proj.id" class="entry-block">
      <div class="entry-head">
        <span class="entry-label">项目 {{ i + 1 }}</span>
        <button class="del-btn" @click="removeEntry(i)">删除</button>
      </div>
      <div class="field">
        <label>项目名称</label><input v-model="proj.name" />
      </div>
      <div class="field-row">
        <div class="field"><label>开始时间</label><input type="month" v-model="proj.startDate" /></div>
        <div class="field">
          <label>结束时间</label>
          <div class="date-row">
            <input type="month" v-model="proj.endDate" :disabled="proj.isCurrentProject" />
            <label v-if="!proj.endDate || proj.isCurrentProject" class="checkbox-label"><input type="checkbox" v-model="proj.isCurrentProject" @change="proj.endDate = proj.isCurrentProject ? currentMonth : ''" /> 至今</label>
          </div>
        </div>
      </div>
      <div class="field"><label>所属公司</label>
        <select v-model="proj.company">
          <option value="">无</option>
          <option v-for="w in resumeData.workExperience" :key="w.id" :value="w.company">{{ w.company || '（未填公司名）' }}</option>
        </select>
      </div>
      <div class="field"><label>项目链接</label><input v-model="proj.link" /></div>
      <div class="field"><label>技术架构</label><input v-model="proj.techStack" placeholder="如：Vue3 + TypeScript + Node.js" /></div>
      <div class="field">
        <label>项目描述</label>
        <textarea v-model="proj.description" rows="8" />
      </div>
      <div class="field">
        <label>主要职责</label>
        <textarea v-model="proj.responsibility" rows="6" />
      </div>
      <div class="field">
        <label>项目成果</label>
        <textarea v-model="proj.achievement" rows="4" />
      </div>
    </div>
    <button class="add-btn" @click="addEntry">+ 添加项目经历</button>
  </div>
</template>
