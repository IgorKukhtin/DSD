unit ArticleLossTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TArticleLossTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

 TArticleLoss = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateArticleLoss(Id, Code: Integer; Name: String;
      InfoMoneyId,ProfitLossDirectionId : Integer): Integer;
    constructor Create; override;
  end;
var
  TestInfoMoneyId, TestProfitLossDirectionId: Integer;

implementation

uses UtilConst, TestFramework, DB, MeasureTest, NDSKindTest, InfoMoney,
  InfoMoneyTest, ProfitLossDirectionTest;

constructor TArticleLoss.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ArticleLoss';
  spSelect := 'gpSelect_Object_ArticleLoss';
  spGet := 'gpGet_Object_ArticleLoss';
end;

function TArticleLoss.InsertDefault: integer;
begin
  TestInfoMoneyId := TInfoMoney.Create.InsertDefault;
  TestProfitLossDirectionId := TProfitLossDirection.Create.InsertDefault;
  result := InsertUpdateArticleLoss(0, -1, '�������� ������ ��������',
    TestInfoMoneyId, TestProfitLossDirectionId);
  inherited;
end;

function TArticleLoss.InsertUpdateArticleLoss(Id, Code: Integer; Name: String;
      InfoMoneyId,ProfitLossDirectionId : Integer): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);

  result := InsertUpdate(FParams);
end;

{ TArticleLossTest }

procedure TArticleLossTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ArticleLoss\';
  inherited;
end;

procedure TArticleLossTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TArticleLoss;
begin
  ObjectTest := TArticleLoss.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ ������ ��������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Code').AsInteger = -1) AND
            (FieldByName('Name').AsString = '�������� ������ ��������') AND
            (FieldByName('InfoMoneyId').asInteger = TestInfoMoneyId) AND
            (FieldByName('ProfitLossDirectionId').asInteger = TestProfitLossDirectionId)
             , '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TArticleLossTest.Suite);


end.
