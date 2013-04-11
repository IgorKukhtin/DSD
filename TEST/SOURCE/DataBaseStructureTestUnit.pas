unit DataBaseStructureTestUnit;

interface

uses TestFramework, ZConnection, ZDataset;

type
  TCheckDataBaseStructure = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CreateType;
    procedure CreateObject;
    procedure CreateContainer;
    procedure CreateContainerFunction;
    procedure CreateContainerDesc;
    procedure CreateContainerProcedure;
    procedure CreateObjectFunction;
    procedure CreateObjectDesc;
    procedure CreateConstantObject;
    procedure CreateMovement;
    procedure CreateMovementFunction;
    procedure CreateMovementDesc;
    procedure CreateMovementProcedure;
    procedure CreateMovementItem;
    procedure CreateMovementItemContainer;
    procedure CreateMovementItemContainerFunction;
    procedure CreateMovementItemContainerDesc;
    procedure CreateHistory;
    procedure CreateHistoryProcedure;
    procedure CreateProtocol;
    procedure CreateProtocolProcedure;
  end;

implementation

uses UtilUnit;

{ TCheckDataBaseStructure }

const
  StructurePath = '..\DATABASE\COMMON\STRUCTURE\';
  ProcedurePath = '..\DATABASE\COMMON\PROCEDURE\';
  MetadataPath = '..\DATABASE\COMMON\METADATA\';

procedure TCheckDataBaseStructure.CreateConstantObject;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObject.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateContainer;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\Container.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerLinkObject.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateContainerDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertContainerDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertContainerLinkObjectDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateContainerFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateContainerDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateContainerLinkObjectDescFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateContainerProcedure;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\lpGet_Container1.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\lpGet_Container2.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateHistory;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistory.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryLinkDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryLink.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateHistoryProcedure;
begin

end;

procedure TCheckDataBaseStructure.CreateMovement;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementFloat.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementFloatDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementLinkObjectDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementFloatDescFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementItem;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItem.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementItemContainer;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItemContainer\MovementItemContainerDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItemContainer\MovementItemContainer.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementItemContainerFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemContainerDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\lpInsertUpdate_MovementItemContainer.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementProcedure;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementFloat.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementItemContainerDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemContainerDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateObject;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBLOBDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBLOB.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectLinkDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectLink.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateObjectDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectStringDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectLinkDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectBLOBDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectFloatDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectBooleanDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectBLOBDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectLinkDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateObjectFunction;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_Object_ValueData.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_ObjectString_ValueData.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\Constraint\lpCheck_Object_CycleLink.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectBLOB.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectLink.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\Delete\lpDelete_Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_User\gpInsertUpdate_Object_User.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_User\gpSelect_Object_User.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_User\gpGet_Object_User.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Form\gpInsertUpdate_Object_Form.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Form\gpGet_Object_Form.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\lpCheckRight.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\gpCheckLogin.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Cash\gpInsertUpdate_Object_Cash.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Cash\gpSelect_Object_Cash.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Cash\gpGet_Object_Cash.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Currency\gpInsertUpdate_Object_Currency.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Currency\gpSelect_Object_Currency.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Currency\gpGet_Object_Currency.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Measure\gpInsertUpdate_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Measure\gpSelect_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Measure\gpGet_Object_Measure.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpInsertUpdate_Object_GoodsProperty.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpSelect_Object_GoodsProperty.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpGet_Object_GoodsProperty.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpInsertUpdate_Object_JuridicalGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpSelect_Object_JuridicalGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpGet_Object_JuridicalGroup.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Juridical\gpInsertUpdate_Object_Juridical.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Juridical\gpSelect_Object_Juridical.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Juridical\gpGet_Object_Juridical.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Partner\gpInsertUpdate_Object_Partner.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Partner\gpSelect_Object_Partner.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Partner\gpGet_Object_Partner.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_ContractKind\gpInsertUpdate_Object_ContractKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_ContractKind\gpSelect_Object_ContractKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_ContractKind\gpGet_Object_ContractKind.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Business\gpInsertUpdate_Object_Business.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Business\gpSelect_Object_Business.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Business\gpGet_Object_Business.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Branch\gpInsertUpdate_Object_Branch.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Branch\gpSelect_Object_Branch.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Branch\gpGet_Object_Branch.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_UnitGroup\gpInsertUpdate_Object_UnitGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_UnitGroup\gpSelect_Object_UnitGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_UnitGroup\gpGet_Object_UnitGroup.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Unit\gpInsertUpdate_Object_Unit.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Unit\gpSelect_Object_Unit.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Unit\gpGet_Object_Unit.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Bank\gpInsertUpdate_Object_Bank.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Bank\gpSelect_Object_Bank.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Bank\gpGet_Object_Bank.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpInsertUpdate_Object_GoodsGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpSelect_Object_GoodsGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpGet_Object_GoodsGroup.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Goods\gpInsertUpdate_Object_Goods.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Goods\gpSelect_Object_Goods.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Goods\gpGet_Object_Goods.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_BankAccount\gpInsertUpdate_Object_BankAccount.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_BankAccount\gpSelect_Object_BankAccount.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_BankAccount\gpGet_Object_BankAccount.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceList\gpInsertUpdate_Object_PriceList.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceList\gpSelect_Object_PriceList.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceList\gpGet_Object_PriceList.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpInsertUpdate_Object_GoodsPropertyValue.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpSelect_Object_GoodsPropertyValue.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpGet_Object_GoodsPropertyValue.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateProtocol;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Protocol\ObjectProtocol.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateProtocolProcedure;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Protocol\lpInsert_ObjectProtocol.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateType;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Type\CreateType.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TCheckDataBaseStructure.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
  TestFramework.RegisterTest('DataBaseStructure', TCheckDataBaseStructure.Suite);

end.
