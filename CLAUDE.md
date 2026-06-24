# MuJian

木简 —— 在线免费制作简历。Vue3 + Vite + TypeScript，无UI库、无路由、无状态管理库。

🌐 线上地址：mujian.xinboo.net

## 项目结构

```text
src/
  main.ts                          # 入口
  App.vue                          # 主布局：左编辑器 + 拖拽分栏 + 右预览（默认编辑器宽628px）
  assets/
    main.css                       # 全局样式重置
    editor-fields.css              # 编辑器表单公共样式（所有 section 共享）
  types/resume.ts                  # 所有 TypeScript 接口（ResumeData 为根类型）
  data/defaultResume.ts            # 空白简历模板（所有字段为空）
  composables/useResumeStore.ts    # 状态管理：reactive + localStorage 手动保存
  components/
    ResumePreview.vue              # 双缓冲 iframe 渲染预览（无闪烁）
    EditorPanel.vue                # 编辑器外壳：header、section 列表、footer
    DebouncedTextarea.vue          # 防抖 textarea（当前未使用，保留备用）
    sections/                      # 8 个独立 section 子组件
      PersonalInfoSection.vue      # 基本信息
      StrengthsSection.vue         # 个人优势
      JobIntentionSection.vue      # 求职意向
      WorkExperienceSection.vue    # 工作经验
      ProjectExperienceSection.vue # 项目经验
      EducationSection.vue         # 教育经历
      SkillsSection.vue            # 技能特长
      PersonalWorksSection.vue     # 个人作品
  utils/
    renderResumeHtml.ts            # 内置 HTML 模板（CSS + 表格结构）
public/
  favicon.svg                      # 网站 favicon（Vite 默认图标）
  default-avatar.png               # 默认头像
  icon-person.png                  # 性别图标
  icon-phone.png                   # 电话图标
  icon-email.png                   # 邮箱图标
  wechat-qr.jpg                   # 微信收款码
  alipay-qr.jpg                   # 支付宝收款码
```

## 核心架构

- **数据与模板分离**：`ResumeData`（数据）+ `renderResumeHtml()`（模板）= 完整 HTML
- **模板**：`renderResumeHtml.ts` 包含内置的CSS和table布局，不要随意修改其结构
- **组件拆分**：EditorPanel 拆为外壳 + 8 个 section 子组件，每个 section 独立渲染，编辑时只重渲染当前 section
- **数据直连 store**：各 section 和 ResumePreview 直接从 `useResumeStore()` 获取数据，不通过 props 传递
- **预览机制**：`ResumePreview.vue` 使用双缓冲 iframe（前后台切换），`srcdoc` 异步加载，不闪烁不阻塞主线程。原因：`srcdoc` 赋值会触发 iframe 完整导航（销毁旧文档→重建），单 iframe 会闪白屏，双缓冲让重建在不可见的后台 iframe 完成后再切换。后台 iframe 必须设置 `pointer-events: none`，仅前台 `.front` 设为 `auto`，否则后台 iframe 会干扰滚动等鼠标事件
- **拖拽分栏**：`App.vue` 中 resize-handle 拖拽调节编辑区/预览区宽度（默认628px，范围300-800px），拖拽结束自动存入 localStorage（key: `editor-width`）。拖拽期间使用全屏透明遮罩（`drag-overlay`）捕获鼠标事件，避免修改 iframe 的 `pointer-events` 导致滚动失效
- **版本号驱动预览**：store 维护 `dataVersion` 浅层 ref，编辑时 `bumpVersion()` 递增，预览即时刷新（无防抖）
- **新标签页预览**：EditorPanel 中的"预览"链接通过 Blob URL 在新标签页打开完整简历
- **图片绝对路径**：`renderResumeHtml.ts` 中使用 `window.location.origin` 拼接绝对 URL，确保 Blob URL / iframe 上下文中图片正常加载
- **持久化**：简历数据通过 `useResumeStore.ts` 操作 localStorage（key: `resume-data`），用户点「保存」按钮或 Ctrl+S 才写入，非自动保存；编辑区宽度通过 `App.vue` 存入 localStorage（key: `editor-width`），拖拽结束自动保存
- **编辑状态**：保存按钮有 dirty 状态（`isDirty` ref），保存后灰掉，编辑后亮起
- **数据合并**：`useResumeStore.ts` 加载旧数据时通过 `mergeWithDefaults()` 与默认值合并，新增字段自动补全
- **导入导出**：EditorPanel 操作菜单支持导出/导入 JSON、导出 HTML、导出 PDF（window.print）、重置数据

## 数据流

1. 启动 → 加载空白模板（`defaultResume.ts`）
2. 读取 localStorage → 有数据则通过 `mergeWithDefaults()` 合并后覆盖，无则保持空白
3. 编辑 → section 组件直接修改 store 中的 reactive 数据 → `bumpVersion()` → 预览即时刷新
4. 点保存 / Ctrl+S → 写入 localStorage

## 关键设计

- **时间段**：工作/项目经验使用 `<input type="month">` + `isCurrentJob`/`isCurrentProject` 布尔值实现"至今"功能，勾选至今时 endDate 赋值为当前月，时长每次打开自动计算
- **教育经历**：同样使用月份选择器，但没有"至今"选项
- **空格分割渲染**：`targetPositions`、`targetCities`、`industry` 存储为 `string`，渲染时通过 `splitToTags()` 按空格切割为 `<span class="tag">`
- **项目经验所属公司**：下拉框，选项来自工作经验中的公司名 + "无"
- **头像**：默认使用 `public/default-avatar.png`，编辑器可自定义 URL 或 base64
- **公司/学校 Logo**：手填 URL 输入框，支持 base64
- **技能特长**：技能名不加粗（`<span>` 非 `<strong>`），行间距 `padding: 3px 0`
- **项目经验字段**：技术架构、主要职责、项目成果（均为可选，不填则不渲染）
- **导出文件名**：格式为 `姓名YYYYMMDDHHmmss.ext`
- **编辑器底部**：版本号（v1.3.0）、GitHub 链接、打赏弹窗（微信/支付宝二维码）
- **快捷键**：Ctrl+S / Cmd+S 保存

## SEO

- `index.html` 包含 title 和 meta description
- favicon: `public/favicon.svg`（Vite 默认图标）

## 开发命令

```bash
npm install
npm run dev      # http://localhost:5173
npm run build
```

## Docker 构建与部署

- **Dockerfile**：多阶段构建，node:22-alpine 编译 + static-web-server:2-alpine 托管静态文件
- **镜像地址**：`xinboo/mujian`（Docker Hub）

```bash
docker build -t mujian .
docker run -d -p 8080:80 mujian
```

## CI/CD

- **GitHub Actions**（`.github/workflows/docker.yml`）：
  - push master → 构建并推送 `xinboo/mujian:latest`
  - push v* tag → 自动创建 GitHub Release（含 changelog）
  - 需要 GitHub Secrets：`DOCKERHUB_USERNAME`、`DOCKERHUB_TOKEN`

## 分支与版本管理

- `master`：主开发分支
- Git tag（`v1.0.0` 等）：版本标记，触发 Actions 创建 GitHub Release
- 当前版本：v1.3.0

## 注意事项

- 不要修改 `renderResumeHtml.ts` 中的 CSS 和 HTML 结构，除非模板本身需要更新
- `targetPositions`、`targetCities`、`industry` 是 `string`，按空格分隔，渲染时切割为标签
- 技能等级对应 CSS 类：精通（无类名 100%）、熟练（`sl` 70%）、良好（`lh` 45%）、一般（`yb` 20%）
- 编辑器字段顺序应与简历模板渲染顺序保持一致

## 快捷约定

- 用户说"**提交**" = `git commit`，不推送
- 需要推送时用户会明确说"推送"或"push"
