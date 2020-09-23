unit ContractTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TContractTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TContract = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContract(const Id: integer; Code: integer; InvNumber, Comment: string;
             JuridicalId, JuridicalBasisId, Deferment :Integer): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

{ TContractTest }
 constructor TContract.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Contract';
  spSelect := 'gpSelect_Object_Contract';
  spGet := 'gpGet_Object_Contract';
end;

function TContract.InsertDefault: integer;
var Id, Code: integer;
    InvNumber, Comment: string;
    JuridicalId, JuridicalBasisId :Integer;
begin
    Id:=0;
    Code:=0;
    InvNumber:='123456-test';
    Comment := '{EQ';

    JuridicalId := TJuridical.Create.GetDefault;
    JuridicalBasisId := JuridicalId;

  result := InsertUpdateContract(Id, Code, InvNumber, Comment, JuridicalId, JuridicalBasisId, 10);
  inherited;
end;

function TContract.InsertUpdateContract(const Id: integer; Code: integer; InvNumber, Comment: String;
  JuridicalId, JuridicalBasisId, Deferment: Integer): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inJuridicalBasisId', ftInteger, ptInput, JuridicalBasisId);
  FParams.AddParam('inDeferment', ftInteger, ptInput, Deferment);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  result := InsertUpdate(FParams);
end;

procedure TContractTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\Contract\';
  inherited;
end;

procedure TContractTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContract;
begin
  ObjectTest := TContract.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;;
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '123456-test'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;


initialization
  TestFramework.RegisterTest('Объекты', TContractTest.Suite);

end.
