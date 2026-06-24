<script setup lang="ts">
import { useResumeStore } from '../../composables/useResumeStore'

const { resumeData, bumpVersion, isDirty } = useResumeStore()
const p = resumeData.personalInfo

function onDataChange() {
  isDirty.value = true
  bumpVersion()
}
</script>

<template>
  <div class="section-body" @input="onDataChange" @change="onDataChange">
    <div class="field-row">
      <div class="field">
        <label>姓名</label>
        <input v-model="p.name" />
      </div>
      <div class="field">
        <label>性别</label>
        <select v-model="p.gender">
          <option>男</option><option>女</option>
        </select>
      </div>
    </div>
    <div class="field-row">
      <div class="field">
        <label>出生年份</label>
        <input v-model.number="p.birthYear" type="number" />
      </div>
      <div class="field">
        <label>出生月份</label>
        <input v-model.number="p.birthMonth" type="number" min="1" max="12" />
      </div>
    </div>
    <div class="field-row">
      <div class="field">
        <label>工作年限</label>
        <input v-model.number="p.workYears" type="number" />
      </div>
      <div class="field">
        <label>政治面貌</label>
        <select v-model="p.politicalStatus">
          <option value="中共党员">中共党员</option>
          <option value="中共预备党员">中共预备党员</option>
          <option value="共青团员">共青团员</option>
          <option value="民主党派人士">民主党派人士</option>
          <option value="无党派民主人士">无党派民主人士</option>
          <option value="普通公民">普通公民</option>
        </select>
      </div>
    </div>
    <div class="field-row">
      <div class="field">
        <label>电话</label>
        <input v-model="p.phone" />
      </div>
      <div class="field">
        <label>邮箱</label>
        <input v-model="p.email" />
      </div>
    </div>
    <div class="field">
      <label>现居城市</label>
      <input v-model="p.currentCity" />
    </div>
    <div class="field">
      <label>头像</label>
      <input v-model="p.avatar" placeholder="url / base64" />
    </div>
  </div>
</template>
