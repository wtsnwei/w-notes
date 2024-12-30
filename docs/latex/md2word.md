# markdown 转 word

这里使用模板。

1. 打开 Microsoft Word： 打开 Word 文档并创建一个新的空白文档。
2. 定义样式： 在 Word 中，您可以设置特定的样式来控制文档的外观（例如，标题、正文、链接、特殊文本等）。
3. 选中 `正文` ，选择 `编辑`，点击 `格式` ，选中 `字体`，`西文字体` 选为 `Segoe UI Emoji`
4. 中文和英文之间要留空格，这样西文样式才会应用。

转换命令：

```shell
pandoc test.md -o test.docx --reference-doc=template.docx
```

