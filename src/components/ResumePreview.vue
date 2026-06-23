<script setup lang="ts">
import { onMounted, onUnmounted, ref, watch } from 'vue'
import type { ResumeData } from '../types/resume'
import { renderResumeHtml } from '../utils/renderResumeHtml'
import { useResumeStore } from '../composables/useResumeStore'

const { dataVersion } = useResumeStore()
const props = defineProps<{ data: ResumeData }>()

const iframeA = ref<HTMLIFrameElement>()
const iframeB = ref<HTMLIFrameElement>()
const showA = ref(true)
let scrollTop = 0
let updateId = 0

function updatePreview() {
  const visible = showA.value ? iframeA.value : iframeB.value
  const hidden = showA.value ? iframeB.value : iframeA.value
  if (!visible || !hidden) return

  const vDoc = visible.contentDocument
  scrollTop = vDoc?.documentElement?.scrollTop || vDoc?.body?.scrollTop || 0

  const html = renderResumeHtml(props.data)
  const id = ++updateId

  hidden.onload = () => {
    if (id !== updateId) return
    const hDoc = hidden.contentDocument
    if (hDoc?.documentElement) {
      hDoc.documentElement.scrollTop = scrollTop
    }
    hidden.contentWindow?.requestAnimationFrame(() => {
      if (id !== updateId) return
      showA.value = !showA.value
    })
  }

  hidden.srcdoc = html
}

let debounceTimer: ReturnType<typeof setTimeout> | null = null

watch(dataVersion, () => {
  if (debounceTimer) clearTimeout(debounceTimer)
  debounceTimer = setTimeout(updatePreview, 200)
})

onUnmounted(() => {
  if (debounceTimer) clearTimeout(debounceTimer)
})

onMounted(() => {
  const iframe = iframeA.value
  if (!iframe) return
  const doc = iframe.contentDocument || iframe.contentWindow?.document
  if (!doc) return
  const html = renderResumeHtml(props.data)
  doc.open()
  doc.write(html)
  doc.close()
})
</script>

<template>
  <div class="preview-container">
    <iframe ref="iframeA" class="preview-iframe" :class="{ front: showA }" />
    <iframe ref="iframeB" class="preview-iframe" :class="{ front: !showA }" />
  </div>
</template>

<style scoped>
.preview-container {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
}
.preview-iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: none;
  background: #fff;
  z-index: 0;
}
.preview-iframe.front {
  z-index: 1;
}
</style>
