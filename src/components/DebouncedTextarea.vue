<script setup lang="ts">
import { ref, watch } from 'vue'
import { useResumeStore } from '../composables/useResumeStore'

const { bumpVersion, isDirty } = useResumeStore()

const props = defineProps<{ modelValue: string }>()
const emit = defineEmits<{ 'update:modelValue': [value: string] }>()

const local = ref(props.modelValue)
let timer: ReturnType<typeof setTimeout> | null = null

watch(() => props.modelValue, (v) => { local.value = v })

function onInput(e: Event) {
  e.stopPropagation()
  local.value = (e.target as HTMLTextAreaElement).value
  isDirty.value = true
  if (timer) clearTimeout(timer)
  timer = setTimeout(() => {
    emit('update:modelValue', local.value)
    bumpVersion()
  }, 300)
}
</script>

<template>
  <textarea :value="local" @input="onInput" v-bind="$attrs" />
</template>
