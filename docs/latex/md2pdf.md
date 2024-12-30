# markdown 转 pdf

颜色设置。

使用 span 标签结合 lua 脚本实现：

1. 先给指定字符加上 span 标签。
2. lua 脚本如下

    ```lua
    -- filter.lua
    function Span(elem)
    if elem.attributes and elem.attributes["style"] then
        local style = elem.attributes["style"]
        if style:match("color%s*:%s*red") then
        return pandoc.RawInline("latex", "\\textcolor{red}{" .. pandoc.utils.stringify(elem) .. "}")
        end
    end
    return elem
    end
    ```

3. 准备模板

    [template.tex](./template.tex)

4. 转换命令

    如果有特殊字符，需要准备兼容改字符的字体，例如 Arial Unicode MS：[ArialUnicodeMS](https://github.com/TNTxTrick/ArialUnicodeMS.ttf/blob/main/ArialUnicodeMS.ttf)
    ```shell
    pandoc --pdf-engine=xelatex -V CJKmainfont='SimSun' -V mainfont='Arial Unicode MS' test.md -o test.pdf --lua-filter=filter.lua --template=template.tex
    ```
