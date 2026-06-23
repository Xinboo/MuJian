<script setup lang="ts">
import { onMounted, onUnmounted, ref, watch } from 'vue'
import type { ResumeData } from '../types/resume'
import { renderResumeHtml } from '../utils/renderResumeHtml'

const props = defineProps<{ data: ResumeData }>()

const iframeRef = ref<HTMLIFrameElement>()

function writeToIframe() {
  const iframe = iframeRef.value
  if (!iframe) return
  const doc = iframe.contentDocument || iframe.contentWindow?.document
  if (!doc) return
  const html = renderResumeHtml(props.data)
  doc.open()
  doc.write(html)
  doc.close()
}

let debounceTimer: ReturnType<typeof setTimeout> | null = null

watch(() => props.data, () => {
  if (debounceTimer) clearTimeout(debounceTimer)
  debounceTimer = setTimeout(writeToIframe, 300)
}, { deep: true })

onUnmounted(() => {
  if (debounceTimer) clearTimeout(debounceTimer)
})

onMounted(() => {
  setTimeout(writeToIframe, 50)
})
</script>

<template>
  <iframe ref="iframeRef" class="preview-iframe" />
</template>

<style scoped>
.preview-iframe {
  width: 100%;
  height: 100%;
  border: none;
  background: #fff;
}
</style>
