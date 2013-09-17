unit IoCTests;

interface

uses
  TestFramework;
type
  ITest1 = interface
    ['{5623E79D-7AE3-48A6-9B8E-2CB48F3D50AA}']

  end;

  ITest2 = interface
    ['{5623E79D-7AE3-48A6-9B8E-2CB48F3D50AA}']
  end;


  TSimpleIoCTests = class(TTestCase)
  published
    procedure TestDefault;
    procedure TestSingleton;
    procedure TestNamedSingletons;
    procedure TestSingletonInstance;
    procedure TestNotResolve;

  end;

implementation

uses
  SimpleIoC;

type
  TTest1 = class(TInterfacedObject,ITest1)
  end;

  TTest11 = class(TInterfacedObject,ITest1)
  end;


  TTest2 = class(TInterfacedObject,ITest1)
  end;


{ TSimpleIoCTests }

//Test if the Default container is created.
procedure TSimpleIoCTests.TestDefault;
var
  t1 : ITest1;
  t2 : ITest1;
begin
  TSimpleIoC.DefaultContainer.Clear;  //so we can run tests multiple times when debugging.
  TSimpleIoC.DefaultContainer.RegisterType<ITest1,TTest1>;

  t1 := TSimpleIoC.DefaultContainer.Resolve<ITest1>;
  t2 := TSimpleIoC.DefaultContainer.Resolve<ITest1>;
  Check(t1 <> nil);
  Check(t2 <> nil);
  Check(t1 <> t2);

end;


procedure TSimpleIoCTests.TestNamedSingletons;
var
  t1 : ITest1;
  t2 : ITest1;
  t3 : ITest2;
  c : TSimpleIoC;
begin
  c := TSimpleIoC.Create;
  try
    c.RegisterType<ITest1,TTest1>(true,'One');
    c.RegisterType<ITest1,TTest11>(true,'OneOne');
    //test that key = type + name
    c.RegisterType<ITest2,TTest2>(true,'One');

    //name is not case sensitive
    t1 := c.Resolve<ITest1>('one');
    t2 := c.Resolve<ITest1>('oneone');
    t3 := c.Resolve<ITest2>('ONE');

    Check(t1 <> nil);
    Check(t2 <> nil);
    Check(t1 <> t2);
    Check(t3 <> nil);
  finally
    c.Free;
  end;
end;

procedure TSimpleIoCTests.TestNotResolve;
var
  t1 : ITest1;
  c : TSimpleIoC;
begin
  c := TSimpleIoC.Create;
  try
    c.RaiseIfNotFound := False;
    t1 := c.Resolve<ITest1>;
    Check(t1 = nil);
  finally
    c.Free;
  end;
end;

procedure TSimpleIoCTests.TestSingleton;
var
  t1 : ITest1;
  t2 : ITest1;
  c : TSimpleIoC;
begin
  c := TSimpleIoC.Create;
  try
    c.RegisterType<ITest1,TTest1>(true);
    t1 := c.Resolve<ITest1>;
    t2 := c.Resolve<ITest1>;
    Check(t1 <> nil);
    Check(t2 <> nil);
    Check(t1 = t2);
  finally
    c.Free;
  end;

end;

procedure TSimpleIoCTests.TestSingletonInstance;
var
  t1 : ITest1;
  t2 : ITest1;
  c : TSimpleIoC;
begin
  c := TSimpleIoC.Create;
  try
    t1 := TTest1.Create;
    c.RegisterSingleton<ITest1>(t1);
    t2 := c.Resolve<ITest1>;
    Check(t2 <> nil);
    Check(t1 = t2);
  finally
    c.Free;
  end;
end;

initialization
  TestFramework.RegisterTest(TSimpleIoCTests.Suite);

end.
