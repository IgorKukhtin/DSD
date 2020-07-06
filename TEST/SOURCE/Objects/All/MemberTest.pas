unit MemberTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TMemberTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TMember = class(TObjectTest)
    function InsertDefault: integer; override;
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMember(const Id, Code : integer;  IsOfficial: boolean;
      Name, INN: string; InfoMoneyId: Integer): integer;
    constructor Create; override;
  end;
var
  InfomoneyId: Integer;
implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB, InfoMoneyTest;

{ TMemberTest }
constructor TMember.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Member';
  spSelect := 'gpSelect_Object_Member';
  spGet := 'gpGet_Object_Member';
end;

function TMember.InsertDefault: integer;
begin
  result := InsertUpdateMember(0, -1, true, 'Физические лица','123',InfomoneyId);
end;

function TMember.InsertUpdateMember(const Id, Code: Integer; IsOfficial: boolean;
  Name, INN : string; InfoMoneyId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inIsOfficial', ftBoolean, ptInput, IsOfficial);
  FParams.AddParam('inINN', ftString, ptInput, INN);
  FParams.AddParam('inDriverCertificate', ftString, ptInput, '');
  FParams.AddParam('inComment', ftString, ptInput, '');
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;

procedure TMember.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsShowAll', ftboolean, ptInput, true);
end;

procedure TMemberTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Member\';
  inherited;
end;


procedure TMemberTest.Test;
var Id: integer;
    //RecordCount: Integer;
    ObjectTest: TMember;
begin
  ObjectTest := TMember.Create;
  // Получим список
  //RecordCount :=
  ObjectTest.GetDataSet.RecordCount;
  // Вставка группы
  InfomoneyId := TInfoMoney.Create.GetDefault;
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Физические лица'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization

//  TestFramework.RegisterTest('Объекты', TMemberTest.Suite);

end.
