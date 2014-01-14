unit JuridicalTest;

interface

uses dbTest, dbObjectTest;

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
   function InsertUpdateJuridical(const Id: integer; Code: Integer;
        Name, GLNCode: string; isCorporate: boolean;
        JuridicalGroupId, GoodsPropertyId, InfoMoneyId: integer;
        PriceListId, PriceListPromoId: Integer;
        StartPromo, EndPromo: TDateTime): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TJuridicalTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\_Juridical\';
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

function TJuridical.InsertDefault: integer;
var
  JuridicalGroupId, GoodsPropertyId, InfoMoneyId: Integer;
  PriceListId, PriceListPromoId: Integer;
  StartPromo, EndPromo: TDateTime;
begin
  JuridicalGroupId := TJuridicalGroupTest.Create.GetDefault;
  GoodsPropertyId := TGoodsPropertyTest.Create.GetDefault;
  InfoMoneyId:= TInfoMoneyTest.Create.GetDefault;
  PriceListId := 0;
  PriceListPromoId := 0;
  StartPromo := Date;
  EndPromo := Date;

  result := InsertUpdateJuridical(0, -1, 'Юр. лицо', 'GLNCode', false,
          JuridicalGroupId, GoodsPropertyId, InfoMoneyId, PriceListId, PriceListPromoId,
          StartPromo, EndPromo);
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
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inPriceListId', ftInteger, ptInput, PriceListId);
  FParams.AddParam('inPriceListPromoId', ftInteger, ptInput, PriceListPromoId);
  FParams.AddParam('inStartPromo', ftDateTime, ptInput, StartPromo);
  FParams.AddParam('inEndPromo', ftDateTime, ptInput, EndPromo);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Объекты', TJuridicalTest.Suite);

end.
