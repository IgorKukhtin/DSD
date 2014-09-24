unit ContractTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest, Data.DB;

type
  TContractTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TContract = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateContract(const Id: integer; Code: integer; InvNumber,InvNumberArchive,
  Comment,BankAccountExternal: string; SigningDate, StartDate, EndDate: TDateTime;
  JuridicalId,JuridicalBasisId,InfoMoneyId,ContractKindId,PaidKindId,PersonalId,
  PersonalTradeId, PersonalCollationId, BankAccountId, ContractTagId,
  AreaId,ContractArticleId,ContractStateKindId,BankId :Integer;
  isDefault, isStandart, isPersonal, isUnique: boolean ): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, PaidKindTest;

{ TContractTest }
 constructor TContract.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Contract';
  spSelect := 'gpSelect_Object_Contract';
  spGet := 'gpGet_Object_Contract';
end;

function TContract.InsertDefault: integer;
var Id,Code: integer;
    InvNumber,InvNumberArchive,Comment,BankAccountExternal: string;
    SigningDate, StartDate, EndDate: TDateTime;
    JuridicalId,JuridicalBasisId,InfoMoneyId,ContractKindId,PaidKindId,PersonalId,
    PersonalTradeId, PersonalCollationId, BankAccountId, ContractTagId,
    AreaId,ContractArticleId,ContractStateKindId,BankId :Integer;
    isDefault, isStandart, isPersonal, isUnique: boolean;
begin
    Id:=0;
    Code:=0;
    InvNumber:='123456-test';
    InvNumberArchive:='';
    Comment:='comment';
    BankAccountExternal := 'BankAccountExternal';
    SigningDate:=date; StartDate:=date; EndDate:=date;
    JuridicalId:=TJuridical.Create.GetDefault;
    JuridicalBasisId := 9399;//ООО АЛАН
    InfoMoneyId := 8913;//10203;"Упаковка"
    ContractKindId:=0;
    with TPaidKind.Create.GetDataSet do begin
         if Locate('Name', 'БН', []) then
            PaidKindId := FieldByName('Id').AsInteger;//БН
    end;
    PersonalId := 0;

    PersonalTradeId:=0;
    PersonalCollationId:=0;
    BankAccountId:=0;
    ContractTagId:=0;

    AreaId:=0;
    ContractArticleId:=0;
    ContractStateKindId:=0;
    BankId:=0;
    isDefault:=True;
    isStandart:=True;
    isPersonal:=True;
    isUnique:=True;

  result := InsertUpdateContract(Id,Code,
    InvNumber,InvNumberArchive,Comment,BankAccountExternal,
    SigningDate, StartDate, EndDate,
    JuridicalId,JuridicalBasisId,InfoMoneyId,ContractKindId,PaidKindId,PersonalId,
    PersonalTradeId, PersonalCollationId, BankAccountId, ContractTagId,
    AreaId,ContractArticleId,ContractStateKindId,BankId,isDefault,isStandart, isPersonal, isUnique);
  inherited;
end;

function TContract.InsertUpdateContract(const Id: integer; Code: integer; InvNumber,InvNumberArchive,
  Comment,BankAccountExternal: string; SigningDate, StartDate, EndDate: TDateTime;
  JuridicalId,JuridicalBasisId,InfoMoneyId,ContractKindId,PaidKindId,PersonalId,
  PersonalTradeId, PersonalCollationId, BankAccountId, ContractTagId,
  AreaId,ContractArticleId,ContractStateKindId,BankId :Integer;
  isDefault, isStandart, isPersonal, isUnique: boolean): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberArchive', ftString, ptInput, InvNumberArchive);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inBankAccountExternal', ftString, ptInput, BankAccountExternal);
  FParams.AddParam('inSigningDate', ftDateTime, ptInput, SigningDate);
  FParams.AddParam('inStartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inJuridicalBasisId', ftInteger, ptInput, JuridicalBasisId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inContractKindId', ftInteger, ptInput, ContractKindId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inPersonalId', ftInteger, ptInput, PersonalId);

  FParams.AddParam('inPersonalTradeId', ftInteger, ptInput, PersonalTradeId);
  FParams.AddParam('inPersonalCollationId', ftInteger, ptInput, PersonalCollationId);
  FParams.AddParam('inBankAccountId', ftInteger, ptInput, BankAccountId);
  FParams.AddParam('inContractTagId', ftInteger, ptInput, ContractTagId);

  FParams.AddParam('inAreaId', ftInteger, ptInput, AreaId);
  FParams.AddParam('inContractArticleId', ftInteger, ptInput, ContractArticleId);
  FParams.AddParam('inContractStateKindId', ftInteger, ptInput, ContractStateKindId);
  FParams.AddParam('inBankId', ftInteger, ptInput, BankId);
  FParams.AddParam('inIsDefault', ftboolean, ptInput, isDefault);
  FParams.AddParam('inIsStandart', ftboolean, ptInput, isStandart);
  FParams.AddParam('inIsPersonal', ftboolean, ptInput, isPersonal);
  FParams.AddParam('inIsUnique', ftboolean, ptInput, isUnique);
  result := InsertUpdate(FParams);
end;

procedure TContract.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, date);
  FParams.AddParam('inEndDate',   ftDateTime, ptInput, date);
  FParams.AddParam('inIsPeriod',  ftBoolean, ptInput, true);
  FParams.AddParam('inIsEndDate', ftBoolean, ptInput, true);
end;

procedure TContractTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractDocument\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractCondition\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractKey\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\Contract\';
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
      Check((FieldByName('InvNumber').AsString = '123456-test'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;


initialization
  TestFramework.RegisterTest('Объекты', TContractTest.Suite);

end.
