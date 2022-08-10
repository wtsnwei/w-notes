问：在Firefox3的地址栏内输入地址或搜索的关键字词时，Firefox3的地址栏就会出现一串很长的下拉菜单，显示出历史记录、书签等。我想禁用Firefox3地址栏的下拉菜单，请问怎么禁用?

答：在Firefox3地址栏里输入“about:config”并回车，在上面找到“browser.urlbar.maxRichResults”，将其值设为0即可禁用。这个功能很实用，如果禁用了就真的太可惜了，你可以试试修改“about:config browser.urlbar.maxRichResults”为5或6，把下拉菜单的项目设置为显示5或6个。