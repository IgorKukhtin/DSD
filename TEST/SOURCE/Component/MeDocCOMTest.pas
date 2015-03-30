unit MeDocCOMTest;

interface

uses DB, TestFramework;

type
  // Класс тестирует поведение класса TELOLAPSalers.
  TMedocCOMTest = class(TTestCase)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные после тестирования}
    procedure TearDown; override;
  published
    // запускаем КОМ объект
    procedure CreateMedocApplication;
    procedure GetMedocDocument;
  end;

implementation

uses MedocCOM, SysUtils;

{ TMedocCOMTest }

procedure TMedocCOMTest.CreateMedocApplication;
var MedocCom: TMedocCOM;
begin
  MedocCom := TMedocCOM.Create;
end;

procedure TMedocCOMTest.GetMedocDocument;
var
  MedocCom: TMedocCOM;
  res: OleVariant;
  i: integer;
  rr: string;
  val: OleVariant;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList(Date - 360, Date);
  while not res.Eof do begin
    for I := 0 to res.Fields.Count - 1 do begin
        val := res.Fields.Item[i].Value;
        rr := rr + ';  ' + res.Fields.Item[i].Name + ' = ' + val
    end;
    rr := rr + ' #$#$#$ ';
    res.Next;
  end;
end;

procedure TMedocCOMTest.SetUp;
begin
  inherited;

end;

procedure TMedocCOMTest.TearDown;
begin
  inherited;

end;

initialization

  TestFramework.RegisterTest('Компоненты', TMedocCOMTest.Suite);


end.
