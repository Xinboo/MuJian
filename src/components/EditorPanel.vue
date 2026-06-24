<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { renderResumeHtml } from '../utils/renderResumeHtml'
import { useResumeStore } from '../composables/useResumeStore'

import PersonalInfoSection from './sections/PersonalInfoSection.vue'
import StrengthsSection from './sections/StrengthsSection.vue'
import JobIntentionSection from './sections/JobIntentionSection.vue'
import WorkExperienceSection from './sections/WorkExperienceSection.vue'
import ProjectExperienceSection from './sections/ProjectExperienceSection.vue'
import EducationSection from './sections/EducationSection.vue'
import SkillsSection from './sections/SkillsSection.vue'
import PersonalWorksSection from './sections/PersonalWorksSection.vue'

const { resumeData, isDirty } = useResumeStore()

const emit = defineEmits<{ save: [] }>()

const activeSection = ref<string | null>(null)
const showMenu = ref(false)
const menuRef = ref<HTMLElement | null>(null)
const fileInputRef = ref<HTMLInputElement | null>(null)

function onClickOutside(e: MouseEvent) {
  if (menuRef.value && !menuRef.value.contains(e.target as Node)) {
    showMenu.value = false
  }
}

function onKeydown(e: KeyboardEvent) {
  if ((e.ctrlKey || e.metaKey) && e.key === 's') {
    e.preventDefault()
    handleSave()
  }
}

onMounted(() => {
  document.addEventListener('click', onClickOutside)
  document.addEventListener('keydown', onKeydown)
})
onUnmounted(() => {
  document.removeEventListener('click', onClickOutside)
  document.removeEventListener('keydown', onKeydown)
})

function getFileName(ext: string) {
  const name = resumeData.personalInfo.name || '简历'
  const d = new Date()
  const ts = `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}${String(d.getHours()).padStart(2, '0')}${String(d.getMinutes()).padStart(2, '0')}${String(d.getSeconds()).padStart(2, '0')}`
  return `${name}${ts}.${ext}`
}

function downloadBlob(blob: Blob, filename: string) {
  const a = document.createElement('a')
  a.href = URL.createObjectURL(blob)
  a.download = filename
  a.click()
  URL.revokeObjectURL(a.href)
}

function exportJson() {
  const json = JSON.stringify(resumeData, null, 2)
  downloadBlob(new Blob([json], { type: 'application/json' }), getFileName('json'))
  showMenu.value = false
}

function importJson() {
  fileInputRef.value?.click()
  showMenu.value = false
}

function onFileSelected(e: Event) {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = () => {
    try {
      JSON.parse(reader.result as string)
      localStorage.setItem('resume-data', reader.result as string)
      location.reload()
    } catch {
      alert('JSON 文件格式无效')
    }
  }
  reader.readAsText(file)
  ;(e.target as HTMLInputElement).value = ''
}

function exportHtml() {
  const html = renderResumeHtml(resumeData)
  downloadBlob(new Blob([html], { type: 'text/html' }), getFileName('html'))
  showMenu.value = false
}

function resetData() {
  if (confirm('确定要重置所有数据吗？')) {
    localStorage.removeItem('resume-data')
    location.reload()
  }
  showMenu.value = false
}

function exportPdf() {
  const html = renderResumeHtml(resumeData)
  const iframe = document.createElement('iframe')
  iframe.style.position = 'fixed'
  iframe.style.left = '-9999px'
  document.body.appendChild(iframe)
  iframe.contentDocument!.write(html)
  iframe.contentDocument!.close()
  iframe.contentWindow!.onafterprint = () => document.body.removeChild(iframe)
  setTimeout(() => iframe.contentWindow!.print(), 300)
  showMenu.value = false
}

function handleSave() {
  emit('save')
  isDirty.value = false
}

function openPreview() {
  const html = renderResumeHtml(resumeData)
  const blob = new Blob([html], { type: 'text/html' })
  const url = URL.createObjectURL(blob)
  window.open(url, '_blank')
  setTimeout(() => URL.revokeObjectURL(url), 1000)
}

function toggle(section: string) {
  activeSection.value = activeSection.value === section ? null : section
}

const showDonate = ref(false)

const sections = [
  { key: 'personalInfo', label: '基本信息', component: PersonalInfoSection },
  { key: 'strengths', label: '个人优势', component: StrengthsSection },
  { key: 'jobIntention', label: '求职意向', component: JobIntentionSection },
  { key: 'workExperience', label: '工作经验', component: WorkExperienceSection },
  { key: 'projectExperience', label: '项目经验', component: ProjectExperienceSection },
  { key: 'education', label: '教育经历', component: EducationSection },
  { key: 'skills', label: '技能特长', component: SkillsSection },
  { key: 'personalWorks', label: '个人作品', component: PersonalWorksSection },
]
</script>

<template>
  <div class="editor-panel">
    <div class="editor-header">
      <div class="header-left">
        <h2>木简</h2>
        <a class="preview-link" href="#" @click.prevent="openPreview">预览</a>
      </div>
      <div class="header-right">
        <button class="save-btn" :class="{ disabled: !isDirty }" :disabled="!isDirty" @click="handleSave">保存</button>
        <div class="menu-wrapper" ref="menuRef">
          <button class="menu-btn" @click.stop="showMenu = !showMenu">操作 ▾</button>
          <div v-show="showMenu" class="menu-dropdown">
            <div class="menu-item" @click="exportJson">导出 JSON</div>
            <div class="menu-item" @click="importJson">导入 JSON</div>
            <div class="menu-item" @click="exportHtml">导出 HTML</div>
            <div class="menu-item" @click="exportPdf">导出 PDF</div>
            <div class="menu-item menu-item-danger" @click="resetData">重置</div>
          </div>
        </div>
        <input ref="fileInputRef" type="file" accept=".json" style="display:none" @change="onFileSelected" />
      </div>
    </div>

    <div class="sections">
      <div v-for="s in sections" :key="s.key" class="section" :class="{ open: activeSection === s.key }">
        <div class="section-title" @click="toggle(s.key)">
          <span>{{ s.label }}</span>
          <span class="arrow">›</span>
        </div>
        <component v-if="activeSection === s.key" :is="s.component" />
      </div>
    </div>

    <div class="editor-footer">
      <span>v1.3.0</span>
      <span class="dot">·</span>
      <a href="https://github.com/Xinboo/MuJian" target="_blank">GitHub</a>
      <span class="dot">·</span>
      <a href="#" @click.prevent="showDonate = true">打赏</a>
    </div>

    <div v-if="showDonate" class="donate-overlay" @click="showDonate = false">
      <div class="donate-modal" @click.stop>
        <div class="donate-title">请支持一杯咖啡，感谢</div>
        <div class="donate-qr-row">
          <div class="donate-qr-item">
            <div class="donate-qr"><img src="/wechat-qr.jpg" alt="微信" /></div>
            <div class="donate-label">微信</div>
          </div>
          <div class="donate-qr-item">
            <div class="donate-qr"><img src="/alipay-qr.jpg" alt="支付宝" /></div>
            <div class="donate-label">支付宝</div>
          </div>
        </div>
        <div class="donate-hint">感谢你的支持 :)</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.editor-panel {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #fff;
}

.editor-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 8%;
  border-bottom: 1px solid #e8e8e8;
  flex-shrink: 0;
}

.editor-header h2 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.preview-link {
  font-size: 14px;
  color: #3498db;
  text-decoration: none;
  cursor: pointer;
}

.preview-link:hover {
  text-decoration: underline;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.save-btn {
  padding: 4px 16px;
  font-size: 14px;
  color: #fff;
  background: #3498db;
  border: 1px solid #3498db;
  border-radius: 4px;
  cursor: pointer;
}

.save-btn:hover:not(.disabled) {
  background: #2980b9;
}

.save-btn.disabled {
  background: #ccc;
  border-color: #ccc;
  cursor: not-allowed;
}

.menu-wrapper {
  position: relative;
}

.menu-btn {
  padding: 4px 12px;
  font-size: 14px;
  color: #3498db;
  background: #fff;
  border: 1px solid #3498db;
  border-radius: 4px;
  cursor: pointer;
}

.menu-btn:hover {
  background: #f0f7fd;
}

.menu-dropdown {
  position: absolute;
  right: 0;
  top: 100%;
  margin-top: 4px;
  min-width: 120px;
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  z-index: 100;
  overflow: hidden;
}

.menu-item {
  padding: 8px 16px;
  font-size: 13px;
  color: #333;
  cursor: pointer;
  white-space: nowrap;
}

.menu-item:hover {
  background: #f0f7fd;
  color: #3498db;
}

.menu-item-danger { color: #e74c3c; }
.menu-item-danger:hover { background: #fdf0ef; color: #e74c3c; }

.sections {
  flex: 1;
  overflow-y: auto;
}

.section {
  border-bottom: 1px solid #f0f0f0;
}

.section-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 8%;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  color: #333;
  user-select: none;
  transition: background 0.15s;
}

.section-title:hover {
  background: #f8f9fa;
}

.arrow {
  font-size: 16px;
  color: #999;
  transition: transform 0.2s;
}

.section.open .arrow {
  transform: rotate(90deg);
}

.editor-footer {
  padding: 10px 8%;
  text-align: center;
  font-size: 12px;
  color: #bbb;
  border-top: 1px solid #f0f0f0;
  flex-shrink: 0;
}

.editor-footer .dot {
  margin: 0 6px;
}

.editor-footer a {
  color: #999;
  text-decoration: none;
}

.editor-footer a:hover {
  color: #3498db;
}

.donate-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
}

.donate-modal {
  background: #fff;
  border-radius: 10px;
  padding: 28px 84px;
  text-align: center;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.donate-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
}

.donate-qr-row {
  display: flex;
  gap: 46px;
  justify-content: center;
  margin-bottom: 12px;
}

.donate-qr-item {
  text-align: center;
}

.donate-qr {
  width: 220px;
  height: 220px;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
  font-size: 14px;
}

.donate-qr img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}

.donate-label {
  margin-top: 8px;
  font-size: 13px;
  color: #666;
}

.donate-hint {
  font-size: 13px;
  color: #999;
}
</style>
