unit ProfitLossServiceMovementItemTest;

interface

uses dbMovementItemTest, dbTest;

type

  TProfitLossServiceMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;

  TProfitLossServiceMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossServiceMovementItem
      (Id, MovementId, ObjectId: Integer;
       Amount: double; Comment:String;
       ContractId, ContractConditionKindId, InfoMoneyId, UnitId, PaidKindId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants,ProfitLossServiceTest;

{ TProfitLossServiceMovementItemTest }

procedure TProfitLossServiceMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\ProfitLossService\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\ProfitLossService\';
  inherited;
end;

procedure TProfitLossServiceMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TProfitLossServiceMovementItemTest.TearDown;
begin
  inherited;
  if Assigned(InsertedIdMovementItemList) then
     with TMovementItemTest.Create do
       while InsertedIdMovementItemList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementItemList[0]));

  if Assigned(InsertedIdMovementList) then
     with TMovementTest.Create do
       while InsertedIdMovementList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementList[0]));

  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do
          Delete(StrToInt(InsertedIdObjectList[0]));
end;

function TProfitLossServiceMovementItem.InsertDefault: integer;
var Id, MovementId, ObjectId: Integer;
    Amount: double;
    Comment:String;
    ContractId, ContractConditionKindId, InfoMoneyId, UnitId, PaidKindId: Integer;
begin
  Id:=0;
  MovementId:= TProfitLossService.Create.GetDefault;
  ObjectId:=0;
  Amount:=1;
  Comment:='';
  ContractId:=1;
  ContractConditionKindId:=0;
  InfoMoneyId:=0;
  UnitId:=0;
  PaidKindId:=0;
  //
  result := InsertUpdateProfitLossServiceMovementItem (Id, MovementId, ObjectId,
       Amount, Comment, ContractId, ContractConditionKindId, InfoMoneyId, UnitId, PaidKindId);
end;

procedure TProfitLossServiceMovementItemTest.Test;
var ProfitLossServiceMovementItem: TProfitLossServiceMovementItem;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  ProfitLossServiceMovementItem := TProfitLossServiceMovementItem.Create;
  Id := ProfitLossServiceMovementItem.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    ProfitLossServiceMovementItem.Delete(Id);
  end;


end;

{ TProfitLossServiceMovementItem }

constructor TProfitLossServiceMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_ProfitLossService';
end;

function TProfitLossServiceMovementItem.InsertUpdateProfitLossServiceMovementItem
      (Id, MovementId, ObjectId: Integer;
       Amount: double; Comment:String;
       ContractId, ContractConditionKindId, InfoMoneyId, UnitId, PaidKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inObjectId', ftInteger, ptInput, ObjectId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inContractConditionKindId', ftInteger, ptInput, ContractConditionKindId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);

  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TProfitLossServiceMovementItemTest.Suite);

end.


