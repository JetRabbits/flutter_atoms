SetLocal EnableExtensions
set dir="."

pushd
cd %dir%
call flutter pub run build_runner build --delete-conflicting-outputs
popd