# Resume App

简历在线编辑器。左侧编辑、右侧实时预览，数据保存在浏览器本地。

基于 Vue3 + TypeScript + Vite 构建，无 UI 库、无路由、无状态管理库依赖。

## 功能特性

- 左右分栏布局，拖拽调整宽度
- 编辑内容实时预览
- 手动保存到 localStorage
- 新标签页打开完整简历预览
- 支持工作经历、项目经验、教育背景、技能特长等模块
- 技能等级可视化（精通 / 熟练 / 良好 / 一般）
- 公司/学校 Logo 支持 URL 和 Base64

## 快速开始

```bash
npm install
npm run dev      # http://localhost:5173
npm run build
```

## Docker 部署

从 Docker Hub 拉取：

```bash
docker pull xinboo/resume-app
docker run -d -p 8080:80 xinboo/resume-app
```

或本地构建：

```bash
docker build -t resume-app .
docker run -d -p 8080:80 resume-app
```

访问 http://localhost:8080

## 技术栈

- Vue 3
- TypeScript
- Vite
- Nginx（Docker 部署）

## License

[MIT](LICENSE)
