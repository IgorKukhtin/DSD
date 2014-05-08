unit DocumentTaxKindTest;

interface

uses DB, dbTest, dbObjectTest, ObjectTest;

type

  TDocumentTaxKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TDocumentTaxKind = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateDocumentTaxKind(const Id: integer; Code: Integer; Name: string): integer;
    constructor Create; override;
    function GetRecord(Id: integer): TDataSet; override;
  end;

implementation

uses UtilConst, TestFramework, SysUtils, DBClient, dsdDB;

{ TdbUnitTest }

procedure TDocumentTaxKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\DocumentTaxKind\';
  inherited;
end;

procedure TDocumentTaxKindTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TDocumentTaxKind;
begin
  ObjectTest := TDocumentTaxKind.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'DocumentTaxKindTest'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TDocumentTaxKindTest }
constructor TDocumentTaxKind.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_DocumentTaxKind';
  spSelect := 'gpSelect_Object_DocumentTaxKind';
  spGet := 'gpGet_Object_DocumentTaxKind';
end;

function TDocumentTaxKind.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := spGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
//    Params.AddParam('inCode', ftString, ptInput, '');
//    Params.AddParam('inName', ftString, ptInput, '');
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TDocumentTaxKind.InsertDefault: integer;
begin
  result := InsertUpdateDocumentTaxKind(0, -1, 'DocumentTaxKindTest');
  inherited;
end;

function TDocumentTaxKind.InsertUpdateDocumentTaxKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Объекты', TDocumentTaxKindTest.Suite);

end.
