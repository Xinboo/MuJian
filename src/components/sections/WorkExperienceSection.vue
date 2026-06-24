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
  resumeData.workExperience.push({
    id: crypto.randomUUID(), logo: '', company: '', startDate: '', endDate: '', isCurrentJob: false,
    role: '', industry: '', companySize: '', companyType: '', description: '',
  })
  onDataChange()
}

function removeEntry(i: number) {
  resumeData.workExperience.splice(i, 1)
  onDataChange()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div v-for="(w, i) in resumeData.workExperience" :key="w.id" class="entry-block">
      <div class="entry-head">
        <span class="entry-label">工作 {{ i + 1 }}</span>
        <button class="del-btn" @click="removeEntry(i)">删除</button>
      </div>
      <div class="field-row">
        <div class="field"><label>公司</label><input v-model="w.company" /></div>
        <div class="field"><label>职位</label><input v-model="w.role" /></div>
      </div>
      <div class="field">
        <label>公司Logo</label><input v-model="w.logo" placeholder="url / base64" />
      </div>
      <div class="field-row">
        <div class="field"><label>开始时间</label><input type="month" v-model="w.startDate" /></div>
        <div class="field">
          <label>结束时间</label>
          <div class="date-row">
            <input type="month" v-model="w.endDate" :disabled="w.isCurrentJob" />
            <label v-if="!w.endDate || w.isCurrentJob" class="checkbox-label"><input type="checkbox" v-model="w.isCurrentJob" @change="w.endDate = w.isCurrentJob ? currentMonth : ''" /> 至今</label>
          </div>
        </div>
      </div>
      <div class="field-row">
        <div class="field"><label>行业</label><input v-model="w.industry" /></div>
        <div class="field"><label>规模</label>
          <select v-model="w.companySize">
            <option value="少于50人">少于50人</option>
            <option value="50-150人">50-150人</option>
            <option value="150-500人">150-500人</option>
            <option value="500-1000人">500-1000人</option>
            <option value="1000-5000人">1000-5000人</option>
            <option value="5000-10000人">5000-10000人</option>
            <option value="10000人以上">10000人以上</option>
          </select>
        </div>
      </div>
      <div class="field">
        <label>公司性质</label>
        <select v-model="w.companyType">
          <option value="民营">民营</option>
          <option value="国企">国企</option>
          <option value="外企">外企</option>
          <option value="合资">合资</option>
          <option value="事业单位">事业单位</option>
          <option value="上市公司">上市公司</option>
        </select>
      </div>
      <div class="field">
        <label>工作描述</label>
        <textarea v-model="w.description" rows="6" />
      </div>
    </div>
    <button class="add-btn" @click="addEntry">+ 添加工作经历</button>
  </div>
</template>
