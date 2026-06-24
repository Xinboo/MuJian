<script setup lang="ts">
import { ref } from 'vue'
import { useResumeStore } from './composables/useResumeStore'
import ResumePreview from './components/ResumePreview.vue'
import EditorPanel from './components/EditorPanel.vue'

const { saveToStorage } = useResumeStore()

const DEFAULT_EDITOR_WIDTH = 628
const EDITOR_WIDTH_KEY = 'editor-width'

function loadEditorWidth(): number {
  const raw = localStorage.getItem(EDITOR_WIDTH_KEY)
  if (!raw) return DEFAULT_EDITOR_WIDTH
  const n = Number(raw)
  return n >= 300 && n <= 800 ? n : DEFAULT_EDITOR_WIDTH
}

const editorWidth = ref(loadEditorWidth())
const isDragging = ref(false)

function onDragStart(e: MouseEvent) {
  isDragging.value = true
  const startX = e.clientX
  const startWidth = editorWidth.value

  function onMouseMove(e: MouseEvent) {
    const delta = e.clientX - startX
    editorWidth.value = Math.max(300, Math.min(800, startWidth + delta))
  }

  function onMouseUp() {
    isDragging.value = false
    localStorage.setItem(EDITOR_WIDTH_KEY, String(editorWidth.value))
    document.removeEventListener('mousemove', onMouseMove)
    document.removeEventListener('mouseup', onMouseUp)
  }

  document.addEventListener('mousemove', onMouseMove)
  document.addEventListener('mouseup', onMouseUp)
}


</script>

<template>
  <div class="app-layout">
    <div class="editor-pane" :style="{ width: editorWidth + 'px' }">
      <EditorPanel @save="saveToStorage" />
    </div>
    <div class="resize-handle" @mousedown="onDragStart"></div>
    <div class="preview-pane">
      <ResumePreview />
    </div>
    <div v-if="isDragging" class="drag-overlay"></div>
  </div>
</template>

<style scoped>
.app-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.preview-pane {
  flex: 1;
  overflow: hidden;
  background: #f5f5f5;
}

.resize-handle {
  width: 5px;
  cursor: col-resize;
  background: #e0e0e0;
  flex-shrink: 0;
  transition: background 0.15s;
}

.resize-handle:hover {
  background: #3498db;
}

.editor-pane {
  flex-shrink: 0;
  overflow: hidden;
  height: 100vh;
}

.drag-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  cursor: col-resize;
  user-select: none;
}
</style>
