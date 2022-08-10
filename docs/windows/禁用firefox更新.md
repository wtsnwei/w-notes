## Firefox for Windows

### 方法一：使用策略文件

官方策略模板：https://github.com/mozilla/policy-templates/releases

创建策略文件：`<Firefox 安装目录>\distribution\policies.json`

内容如下，

```json
{
  "policies": {
    "DisableAppUpdate.": true
  }
}
```

### 方法二：使用注册表

操作步骤：

- 浏览到 “HKEY_LOCAL_MACHINE\Software\Policies” 创建项 “Mozilla” 在创建项  “Firefox” 创建完毕即 “HKEY_LOCAL_MACHINE\Software\Policies\Mozilla\Firefox”
- 在上述路径，右键点击空白处，新建一个 DWORD (32-Bit) Value，名称为 “DisableAppUpdate”
- 双击创建的 “DisableAppUpdate”，将值修改为 “1”。

直接使用注册表文件：

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox]
"DisableAppUpdate"=dword:00000001
```

**直接使用 CMD**（推荐，最便捷）：

```shell
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox" /v DisableAppUpdate /t REG_DWORD /d 1 /f
```

### 验证效果

此时 “选项” 中 “Firefox 更新”，提示 “更新已被系统管理员禁用”，检查更新按钮也不可用！

“关于 Firefox” 对话框中也可以看到提示 “更新已被系统管理员禁用”。

参考文章：https://www.webnots.com/how-to-disable-automatic-update-in-firefox/

## Firefox for macOS

### 方法一：配置策略文件

获取最新或者对应版本的策略模板：https://github.com/mozilla/policy-templates/releases

自动更新策略描述如下：

```json
{
  "policies": {
    "DisableAppUpdate": true | false
  }
}
```

创建 Firefox 策略配置文件

```
Firefox.app/Contents/Resources/distribution/policies.json
```

禁用自动更新则将以下内容写入 policies.json 文件中

```json
{
  "policies": {
    "DisableAppUpdate": true
  }
}
```

可以直接在终端中执行如下命令实现：

```bash
mkdir /Applications/Firefox.app/Contents/Resources/distribution

echo '
{
  "policies": {
    "DisableAppUpdate": true
  }
}
' > /Applications/Firefox.app/Contents/Resources/distribution/policies.json
```

### 方法二：使用 Plist 配置策略

配置 org.mozilla.firefox.plist 内容如下：

- 启用策略

```bash
sudo defaults write /Library/Preferences/org.mozilla.firefox EnterprisePoliciesEnabled -bool TRUE
```

- 禁用自动更新

```bash
sudo defaults write /Library/Preferences/org.mozilla.firefox DisableAppUpdate -bool TRUE
```

### 验证

此时在 “关于 Firefox” 对话框，或者 “首选项” 中 “Firefox 更新”，提示 “更新已被系统管理员禁用”，检查更新按钮也不可用！

![disable-firefox-auto-update-mac](https://sysin.org/blog/disable-firefox-auto-update/disable-firefox-auto-update-mac.webp)

## Firefox for Linux

On Linux, the file goes into `firefox/distribution`, where `firefox` is the installation directory for firefox, which varies by distribution or you can specify system-wide policy by placing the file in `/etc/firefox/policies`.

在上述路径写入 policies.json 文件，内容如下：

```json
{
  "policies": {
    "DisableAppUpdate": true
  }
}
```

例如：在 Ubuntu 20.04 中，Firefox 默认安装在 `/usr/lib/firefox` 目录下，创建步骤如下：

```bash
##默认 distribution 目录已经存在，若不存在手动创建
#mkdir /usr/lib/firefox/distribution
echo '
{
  "policies": {
    "DisableAppUpdate": true
  }
}
' > /usr/lib/firefox/distribution/policies.json
```

或者，直接在系统级别创建策略文件，无论 Firefox 安装路径如何：

```bash
mkdir /etc/firefox/policies

echo '
{
  "policies": {
    "DisableAppUpdate": true
  }
}
' > /etc/firefox/policies/policies.json
```