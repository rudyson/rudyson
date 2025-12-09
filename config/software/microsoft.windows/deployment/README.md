# Windows automated setup

Windows automated setup tutorial by © Ruslan Diadiushkin 2022-2025

## Windows official ISO:

- [Microsoft Windows 10](https://www.microsoft.com/software-download/windows10)
- [Microsoft Windows 11](https://www.microsoft.com/software-download/windows11)

## Windows Unattend

`autounattend.xml` — это XML-файл, который автоматизирует установку Windows:
он содержит ответы на все вопросы, которые обычно задаются пользователю (язык, лицензия, раздел диска, имя компьютера, логин и т.д.).

### What's the reason to use Unattend

- Полностью автоматизировать установку Windows без нажатий;
- Настроить параметры по умолчанию: язык, часовой пояс, диск, учетные записи;
- Установить параметры продуктивности, обои, скрипты и пр.;
- Подключить драйверы и обновления;
- Выполнить скрипты PowerShell, командные строки (SetupComplete.cmd, FirstLogonCommands);
- Настроить Windows без участия пользователя.

Настроить файл можно на сайте [Generate autounattend.xml files for Windows 10/11](https://schneegans.de/windows/unattend-generator/)

### How to use autounattend.xml

- Скачайте ISO Windows
- Создайте загрузочную флешку (например, через [Rufus](https://rufus.ie))
- В корне USB-диска создайте/скопируйте файл с именем `autounattend.xml`
- Вставьте флешку в компьютер и включите установку Windows.
- Если всё сделано правильно — установка пройдёт в автоматическом режиме.

## Office Deployment Tool (ODT)

The Office Deployment Tool is a Microsoft utility that allows administrators to customize and automate the installation of Microsoft Office products using configuration files.

- Download & Install ODT: [Download Office Deployment Tool](https://www.microsoft.com/en-us/download/details.aspx?id=49117)
- Use this configuration on generate own on [Microsoft 365 Apps admin center - Центр развертывания Office](https://config.office.com/deploymentsettings)
- Use file `OfficeDeploymentToolConfiguration.xml`
- Open terminal in directory with configuration file and `setup.exe`
- Execute command `setup /download OfficeDeploymentToolConfiguration.xml`
- See more about [Office Deployment Tool](http://aka.ms/ODT)

## Winget

Windows 11 и Windows Package Manager 1.3+ поддерживают установку пакетов из .json-файла, соответствующего схеме JSON 1.0. Файл должен описывать список приложений и их идентификаторы в winget.
`winget export` не включает приложения, установленные без winget (например, вручную или из MSI). В Windows 11 всё работает "из коробки". На Windows 10 нужно обновить App Installer.

- Install: `winget import -i .\apps.json --accept-package-agreements --accept-source-agreements`
- Export: `winget export -o apps.json --include-versions false`
- View list of installed apps: `winget list --source winget`
