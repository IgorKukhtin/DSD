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
        Name, GLNCode: string; isCorporate: boolean;
        JuridicalGroupId, GoodsPropertyId, InfoMoneyId: integer;
        PriceListId, PriceListPromoId: Integer;
        StartPromo, EndPromo: TDateTime): integer;
    constructor Create; override;
    function GetRecord(Id: integer): TDataSet; override;
  end;

implementation

uses UtilConst, TestFramework, SysUtils, DBClient, dsdDB, dbObjectMeatTest,
     JuridicalGroupTest, GoodsPropertyTest, InfoMoneyTest;

{ TdbUnitTest }

procedure TJuridicalTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Juridical\';
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
      Check((FieldByName('GLNCode').AsString = 'GLNCode'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

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
    Params.AddParam('inName', ftString, ptInput, '');
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TJuridical.InsertDefault: integer;
var
  JuridicalGroupId, GoodsPropertyId, InfoMoneyId: Integer;
  PriceListId, PriceListPromoId: Integer;
  StartPromo, EndPromo: TDateTime;
begin
  JuridicalGroupId := TJuridicalGroup.Create.GetDefault;
  GoodsPropertyId := TGoodsProperty.Create.GetDefault;
  InfoMoneyId:= TInfoMoney.Create.GetDefault;
  PriceListId := 0;
  PriceListPromoId := 0;
  StartPromo := Date;
  EndPromo := Date;

  result := InsertUpdateJuridical(0, -1, 'Юр. лицо', 'GLNCode', false,
          JuridicalGroupId, GoodsPropertyId, InfoMoneyId, PriceListId, PriceListPromoId,
          StartPromo, EndPromo);

  InsertUpdateJuridicalHistory(result, Date, 0, 'Юр. лицо 12', '', '1212121212', '',
          '', '', '', '');
  inherited;
end;

function TJuridical.InsertUpdateJuridical;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('isCorporate', ftBoolean, ptInput, isCorporate);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  FParams.AddParam('inGoodsPropertyId', ftInteger, ptInput, GoodsPropertyId);
  FParams.AddParam('inRetailId', ftInteger, ptInput, 0);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inPriceListId', ftInteger, ptInput, PriceListId);
  FParams.AddParam('inPriceListPromoId', ftInteger, ptInput, PriceListPromoId);
  FParams.AddParam('inStartPromo', ftDateTime, ptInput, StartPromo);
  FParams.AddParam('inEndPromo', ftDateTime, ptInput, EndPromo);
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
