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
    procedure CreateObjectFunction;
    procedure CreateObjectDesc;
    procedure CreateConstantObject;
  end;

implementation

{ TCheckDataBaseStructure }

const
  StructurePath = '..\DATABASE\STRUCTURE\';
  ProcedurePath = '..\DATABASE\PROCEDURE\';
  MetadataPath = '..\DATABASE\METADATA\';

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
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerLinkObject.sql');
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
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectEnumDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectLinkDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TCheckDataBaseStructure.CreateObjectFunction;
begin
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectEnum.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectLink.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_User\gpInsertUpdate_Object_User.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_User\gpSelect_User.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_User\gpGet_User.sql');
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
  ZConnection := TZConnection.Create(nil);
  ZConnection.HostName := 'localhost';
  ZConnection.Port := 5432;
  ZConnection.Protocol := 'postgresql-9';
  ZConnection.User := 'postgres';
  ZConnection.Database := 'dsd';
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TCheckDataBaseStructure.TearDown;
begin
  inherited;

end;

initialization
  TestFramework.RegisterTest('DataBaseStructure', TCheckDataBaseStructure.Suite);

end.
