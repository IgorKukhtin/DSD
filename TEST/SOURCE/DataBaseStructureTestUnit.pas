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
    procedure CreateEnum;
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
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\lpGet_Container.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateEnum;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Enum\EnumDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Enum\Enum.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateEnumDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertEnumDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateEnum.sql');
  ZQuery.ExecSQL;
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
end;

procedure TCheckDataBaseStructure.CreateMovementDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementLinkObjectDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateMovementFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementLinkObjectDescFunction.sql');
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
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectEnumDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectEnum.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBLOBDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBLOB.sql');
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
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectEnumDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectLinkDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectBLOBDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectEnumDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectBLOBDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectLinkDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateObjectFunction;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_Object_ValueData.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectBLOB.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectEnum.sql');
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
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Measure\gpInsertUpdate_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Measure\gpSelect_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Measure\gpGet_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Form\gpInsertUpdate_Object_Form.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Form\gpGet_Object_Form.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\lpCheckRight.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\gpCheckLogin.sql');
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
