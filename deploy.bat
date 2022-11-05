mode con:cols=50 lines=20
git add .
cls
@echo off
set "UserInputPath=Bug fixes"
set /p input="Commit message: "
if [%input%]==[] git commit -m "Bug fixes" || git commit -m "%input%"
git push origin master