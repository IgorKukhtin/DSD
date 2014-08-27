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
             JuridicalId, JuridicalBasisId :Integer): integer;
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

  result := InsertUpdateContract(Id, Code, InvNumber, Comment, JuridicalId, JuridicalBasisId);
  inherited;
end;

function TContract.InsertUpdateContract(const Id: integer; Code: integer; InvNumber, Comment: String;
  JuridicalId, JuridicalBasisId: Integer): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inJuridicalBasisId', ftInteger, ptInput, JuridicalBasisId);
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
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;;
  // ������� �� ����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �� ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('InvNumber').AsString = '123456-test'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;


initialization
  TestFramework.RegisterTest('�������', TContractTest.Suite);

end.
