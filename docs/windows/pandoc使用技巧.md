# Pandoc使用技巧

Pandoc可以实现常用文档格式之间的相互转换，包括HTML、LaTeX、docx、Markdown等。



## 一、语法

```
pandoc [options] inputfiles
```

Pandoc采用UTF-8编码方案处理输入输出文件。

### 常用参数说明

1. `--from=FORMAT, -f FORMAT` 和 `--to=FORMAT, -t FORMAT`

   指定输入输出文件的格式，

   ```bash
   pandoc --list-input-formats
   pandoc --list-output-formats
   ```

    > **如果没有指定输入输出文件格式，则通过文件扩展名推测文件格式**。使用以下命令列出支持的输入输出文件格式：
    >
    > ```bash
    > pandoc --list-input-formats
    > pandoc --list-output-formats
    > ```
    >
    > 使用 `FORMAT+EXTENSION` 和 `FORMAT+EXTENSION` 可以增减相应格式中的一个或多个扩展选项。使用以下命令列出Pandoc支持的扩展
    >
    > ```bash
    > pandoc --list-extensions
    > pandoc --list-extensions=FORMAT
    > ```
    >

   

2. `--output=FILE, -o FILE`

   如果没有指定输出文件，则输出至标准输出(`stdout`)，默认格式为HTML。

3. `--file-scope`

   如果给出多个输入文件，则默认将多个文件拼接起来（添加空行分隔）。使用此选项分别转换每一个文件。

4. `-standalone, -s`

   默认生成文档片段。使用此选项后，Pandoc 将使用一个模板来添加必要信息，以生成完整的文件（HTML、LaTeX等）。

5. `--template=FILE`

   当使用 `standalone` 选项时，Pandoc默认采用内置模板。使用 `template` 选项指定创建文档所需的模板后，Pandoc 将默认生成完整文件。内置模板可以通过以下命令输出：

   ```bash
   pandoc -o file_template --print-default-template=FORMAT
   pandoc -o file_template -D FORMAT
   ```

   其中`FORMAT`表示输出格式。

   > 模板中包含*变量*，用于自定义模板。变量可用过命令行参数提供，或从文档的元数据中查找（[YAML](https://links.jianshu.com/go?to=https%3A%2F%2Fpandoc.org%2FMANUAL.html%23extension-yaml_metadata_block)元数据语句块或 `-M/--metadata` 选项）。模板中的变量表示方法为 `$title$`
   >
   > 针对变量 `variable` 的条件语句表示方法：
   >
   > ```latex
   > $if(variable)$
   > X
   > $else$
   > Y
   > $endif$
   > ```
   >
   > 根据变量的值，相应的语句块将被写入输出文件。类似地，如果变量 `author` 是一个数组，则可以使用循环语句：
   >
   > ```latex
   > $for(author)$
   > X
   > $endfor$
   > ```
   >
   > 

6. `--metadata=KEY[:VAL], -M KEY[=VAL]`

   设置文档元数据：指定 `KEY` 的值为 `VAL`。如果没有提供 `VAL`，则 `KEY` 默认值为 `true`。

7. `--variable=KEY[:VAL], -V KEY[=VAL]`

   设置模板元数据。

8. `--metadata-file=FILE`

   从指定的 YAML（或 JSON）文件中读取元数据。命令行提供的元数据信息将覆盖文件中的信息。

9. `--css=URL, -c URL`

   指定CSS样式表。

10. `--number-sections, -N`

    对标题进行编号（LaTeX，HTML等，不包括docx）。





## 二、转换为PDF/LaTeX

Pandoc 默认使用 pdflatex 生成PDF，也可以使用 ConTeXt，pdfroff 或 HTML/CSS-to-PDF 引擎（`wkhtmltopdf` , `weasyprint`或`prince`）。



### 参数列表

```bash
-o output.pdf \
--pdf-engine=xelatex \
--template=FILE \
source.md
```

### 说明

1. `--pdf-engine=PROGRAM`

   指定生成 PDF 的 latex 引擎，用于 LaTeX 排版的引擎包括：`pdflatex`, `lualatex`, `xelatex`, `latexmk`等。

2. `--print-default-template=latex`

   输出默认的 latex 文档模板。Pandoc 可以采用此模板将 Markdown 文档转换为tex源码文档（ **Pandoc默认模板不能很好支持中文**）。pm-template.tex是一个可用的模板。

3. 为了调试PDF的创建，可以先输出 tex 文件并使用 latex 编译器单独编译。

4. 使用 latex 时，需要保证本地有必要的包（可以根据编译信息判断是否缺少必要的包，使用 MikTeX 可以按需下载缺少的包。）

### 可选参数

1. `--listings`

   在LaTeX文档中使用`listings`包来格式化代码块。

2. `--biblatex, --natbib`

   指定处理参考文献的程序。

3. `--bibliography=FILE`

   设置文档元数据中的参考文献信息，等效于

   ```
   --metadata bibliography=FILE --filter pandoc-citeproc
   ```

   如果使用了 `biblatex` 或 `natbib` 选项，则等效于

   ```bash
   --metadata bibliography=FILE
   ```

   

## 三、转换为Word文档 (DOCX)

### 参数列表：

```bash
-o output.docx 
--reference-doc=custom.docx 
source.md
```
### 说明

1. `--reference-doc=FILE`

   使用指定的文件作为输出文件的格式参考。参考文件的内容被忽略，只使用其中的样式和文档属性（包括边界、页面尺寸、页眉页脚等）。通过以下命令获取系统中的默认模板（reference.docx）。

   ```bash
   pandoc -o custom.docx --print-default-data-file=reference.docx
   ```

   **注意**：需要在`--print-default-data-file`选项之前使用`-o`选项以重定向输出。

   用户可以按需修改并更新上述输出的默认参考文档中的样式，并将其作为转换的参考模板。



## 四、转换为epub

1. `--epub-cover-image=FILE`

   添加封面。

2. `--epub-metadata=FILE`

   添加元数据。

3. `--epub-embed-font=FILE`

   嵌入字体。



## 五、文档元数据和选项

使用 [YAML](https://yaml.org/refcard.html) 提供文档元数据，可设置的信息参考 [Pandoc手册](https://pandoc.org/MANUAL.html) 。基本使用方法如下所示。

```yaml
# comments
title:  "This is the title"
indent: true
linestretch: 1.25
author:  
- Author One
- Author Two
description: |  # paragraphs
    This is a long
    description.

    It consists of two paragraphs
```