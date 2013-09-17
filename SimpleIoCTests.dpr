program SimpleIoCTests;

{.$APPTYPE CONSOLE}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils,
  SimpleIoC in 'SimpleIoC.pas',
  IoCTests in 'Tests\IoCTests.pas';

begin
  Application.Initialize;
  if IsConsole then
  begin
    with TextTestRunner.RunRegisteredTests do
      Free;
  end
  else
    GUITestRunner.RunRegisteredTests;
end.

