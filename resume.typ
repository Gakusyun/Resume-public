#import "style/resume.typ": *

// Put your personal information here, replacing mine
#let name = "张三"
#let location = "湖北·宜昌"
#let political-affiliation = "共青团员"
#let email = "gxj@gxj62.cn"
#let github = "github.com/Gakusyun"
#let phone = "+86 123 1234 1234"
#let personal-site = "gxj62.cn"


#set par(justify: true)
#show: resume.with(
  author: name,
  location: location,
  political-affiliation: political-affiliation,
  email: email,
  github: github,
  phone: phone,
  personal-site: personal-site,
  author-position: left,
  personal-info-position: left,
  photo: image("img/photo.png"),
)
== 教育经历

#edu(
  institution: "热干面大学",
  level: "本科",
  location: "湖北·武汉",
  dates: dates-helper(start-date: "2022年9月", end-date: "2026年6月（预计）"),
  degree: "热干面搅拌技术，工学学士学位",
  consistent: true,
)
- 相关课程: 热干面的来源、热干面的制作方法

== 工作经历

#work(
  title: "热干面搅拌工程师",
  location: "湖北·武汉",
  company: "菜琳即",
  dates: dates-helper(start-date: "2024年5月", end-date: "至今"),
)
- 搅拌热干面

== 项目

#project(
  name: "热干面",
  role: "组员",
  dates: "2023年6月",
  url: "github/Gakusyun/resume-public",
)
- 使用芝麻酱、碱水面、卤水、芝麻酱技术实现

#project(
  name: "红油热干面",
  role: "组长",
  dates: "2023年8月",
  url: "github/Gakusyun/resume-public",
)
- 使用鱼腥草、黄豆、碱水面、花生酱、红油技术实现

== 比赛获奖

#extracurriculars(
  activity: "第一届全家热干面搅拌大赛品尝赛道",
  dates: "2023年8月",
)
- 获得一等奖
== 课外活动
#extracurriculars(
  activity: "志愿服务：无偿献血",
  dates: dates-helper(start-date: "2022年7月1日", end-date: "至今"),
)
- 2025年8月20日，获得由国家卫生健康委、中国红十字会总会、中央军委后勤保障部卫生局颁发的《2022\~2023年全国无偿献血奉献奖铜奖》，#link("https://www.nhc.gov.cn/ylyjs/zcwj/202508/8eb748f382104796889f24b300818a00.shtml")[国卫医急发〔2025〕11号]

#extracurriculars(
  activity: "爱好",
)
- 热干面、红油牛肉包
== 证书
#extracurriculars(
  activity: "热干面搅拌专业技术资格",
)
- 初级，热干面搅拌员。2023年5月28日。

== IT 技能
- *编程语言*: JavaScript、TypeScript、Python、C/C++、Java、Go、HTML/CSS
- *操作系统*: GNU/Linux、国产操作系统（如统信UOS）、Windows
- *文字处理*: 会使用#LaTeX 、Typst、Markdown, 熟练掌握Word、Excel、PowerPoint
- *技术栈*: Git、Docker、Caddy、NGINX、SSM
- *AI*: 对大语言模型(LLM)有一定了解，会使用MCP
- *语言*: 英语、日语（CJT4#footnote("全国大学日语四级")）
