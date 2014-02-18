unit LoadReportTest;

interface

uses
  TestFramework, frxClass, frxDBSet, Classes, frxDesgn;

type

  TLoadReportTest = class (TTestCase)
  private
    Stream: TStringStream;
    Report: TfrxReport;
    OKPO : array of string;
    procedure TStrArrAdd(const A : array of string);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure LoadReportFormTest;
  end;

implementation

uses FormStorage;

const
  ReportPath = '..\Reports';

{ TLoadReportTest }

procedure TLoadReportTest.TStrArrAdd(const A : array of string);
var i : integer;
begin
  SetLength(OKPO,Length(a));
  for i:=Low(A) to High(A) do
    OKPO[i] := A[i];
end;

procedure TLoadReportTest.LoadReportFormTest;
var
 OKPO:array of string;
 i : integer;
begin



  // Загрузка из файла в репорт
  Report.LoadFromFile(ReportPath + '\Накладные\Приходная накладная.fr3');

  // Сохранение отчета в базу
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'Приходная накладная');

  // Считывание отчета из базы
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('Приходная накладная'));
//=======================

  // Загрузка из файла в репорт
  Report.LoadFromFile(ReportPath + '\Товарный Учет\Расходная накладная бн.fr3');

  // Сохранение отчета в базу
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'PrintMovement_Sale1');

  // Считывание отчета из базы
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('PrintMovement_Sale1'));

//=======================

  // Загрузка из файла в репорт
  Report.LoadFromFile(ReportPath + '\Товарный Учет\Расходная накладная нал.fr3');

  // Сохранение отчета в базу
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'PrintMovement_Sale2');

  // Считывание отчета из базы
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('PrintMovement_Sale2'));

//==  Цикл по ОКПО
{
 TStrArrAdd(['01074874','23193668','25288083','30487219','30982361',
             '32334104','19202597','32049199','32294926','32516492',
             '34356884','35231874','35275230','35442481','36387249',
             '36387233','37910513','37910542']);
   for i:=Low(OKPO) to High(OKPO) do
   begin
  // Загрузка из файла в репорт
    Report.LoadFromFile(ReportPath + '\Товарный Учет\PrintMovement_Sale'+OKPO[i]+'.fr3');

  // Сохранение отчета в базу
    Stream.Clear;
    Report.SaveToStream(Stream);
    Stream.Position := 0;
    TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'PrintMovement_Sale'+OKPO[i]);

  // Считывание отчета из базы
    Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('PrintMovement_Sale'+OKPO[i]));
   end;
 }
 //END ==  Цикл по ОКПО

end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  Report := TfrxReport.Create(nil);
  Stream := TStringStream.Create;
end;

procedure TLoadReportTest.TearDown;
begin
  inherited;
  Report.Free;
  Stream.Free
end;

initialization
  TestFramework.RegisterTest('Загрузка отчетов', TLoadReportTest.Suite);

end.
