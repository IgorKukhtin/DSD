unit FarmacyStructureTestUnit;

interface


uses TestFramework, ZConnection, ZDataset;

type
  TFarmacyStructure = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CreateMovementProcedure;
    procedure CreateConstantObject;
  end;


implementation

uses UtilUnit;

const
  ProcedurePath = '..\DATABASE\FARMACY\PROCEDURE\';
  MetadataPath = '..\DATABASE\FARMACY\METADATA\';

{ TFarmacyStructure }


procedure TFarmacyStructure.CreateMovementProcedure;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_FoundationCash\gpInsertUpdate_Movement_FoundationCash.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_FoundationCash\gpUpdate_Movement_FoundationCash_Complete.sql');
  ZQuery.ExecSQL;
end;

procedure TFarmacyStructure.CreateConstantObject;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObject.sql');
  ZQuery.ExecSQL;
end;

procedure TFarmacyStructure.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TFarmacyStructure.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
  TestFramework.RegisterTest('FarmacyStructure', TFarmacyStructure.Suite);

end.
