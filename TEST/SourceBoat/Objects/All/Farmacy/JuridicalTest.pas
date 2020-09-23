unit JuridicalTest;

interface

uses DB, dbTest, dbObjectTest, ObjectTest;

type

  TJuridicalTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TJuridical = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateJuridicalHistory(JuridicalId: Integer; OperDate: TDateTime;
       BankId: Integer;
       FullName, JuridicalAddress, OKPO, INN, NumberVAT,
       AccounterName, BankAccount, Phone: String): integer;
   function InsertUpdateJuridical(const Id: integer; Code: Integer;
        Name: string; isCorporate: boolean; RetailId: Integer; Percent, PayOrder: real): integer;
    constructor Create; override;
    function GetRecord(Id: integer): TDataSet; override;
  end;

implementation

uses UtilConst, TestFramework, SysUtils, DBClient, dsdDB;

{ TdbUnitTest }

procedure TJuridicalTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\Juridical\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTHISTORY\JuridicalDetails\';
  inherited;
end;

procedure TJuridicalTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TJuridical;
begin
  ObjectTest := TJuridical.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Юр. лицо'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TJuridicalTest }
constructor TJuridical.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Juridical';
  spSelect := 'gpSelect_Object_Juridical';
  spGet := 'gpGet_Object_Juridical';
end;

function TJuridical.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := spGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TJuridical.InsertDefault: integer;
begin

  result := InsertUpdateJuridical(0, -1, 'Юр. лицо', false, 0, 1.0, 0);

//  InsertUpdateJuridicalHistory(result, Date, 0, 'Юр. лицо 12', '', '1212121212', '',
//          '', '', '', '');
  inherited;
end;

function TJuridical.InsertUpdateJuridical;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inisCorporate', ftBoolean, ptInput, isCorporate);
  FParams.AddParam('inRetailId', ftInteger, ptInput, RetailId);
  FParams.AddParam('inPercent', ftFloat, ptInput, Percent);
  FParams.AddParam('inPayOrder', ftFloat, ptInput, PayOrder);
  result := InsertUpdate(FParams);
end;

function TJuridical.InsertUpdateJuridicalHistory(JuridicalId: Integer;
  OperDate: TDateTime; BankId: Integer; FullName, JuridicalAddress, OKPO, INN,
  NumberVAT, AccounterName, BankAccount, Phone: String): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inBankId', ftInteger, ptInput, BankId);
  FParams.AddParam('inFullName', ftString, ptInput, FullName);
  FParams.AddParam('inJuridicalAddress', ftString, ptInput, JuridicalAddress);
  FParams.AddParam('isOKPO', ftString, ptInput, OKPO);
  FParams.AddParam('inINN', ftString, ptInput, INN);
  FParams.AddParam('inNumberVAT', ftString, ptInput, NumberVAT);
  FParams.AddParam('inAccounterName', ftString, ptInput, AccounterName);
  FParams.AddParam('inBankAccount', ftString, ptInput, BankAccount);
  FParams.AddParam('inPhone', ftString, ptInput, Phone);
  spInsertUpdate := 'gpInsertUpdate_ObjectHistory_JuridicalDetails';
  try
    result := InsertUpdate(FParams);
  finally
    spInsertUpdate := 'gpInsertUpdate_Object_Juridical';
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TJuridicalTest.Suite);

end.
