unit AssetGroupTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAssetGroupTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TAssetGroup = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateAssetGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest;

     {TAssetGroupTest}
constructor TAssetGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AssetGroup';
  spSelect := 'gpSelect_Object_AssetGroup';
  spGet := 'gpGet_Object_AssetGroup';
end;

function TAssetGroup.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateAssetGroup(0, -1, 'Группа основных средств', ParentId);
end;

function TAssetGroup.InsertUpdateAssetGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TAssetGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\AssetGroup\';
  inherited;
end;

procedure TAssetGroupTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TAssetGroup;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TAssetGroup.Create;
  // Получим список объектов
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateAssetGroup(0, -2, 'Тест Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateAssetGroup(0, -3, 'Тест Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id3);
          Check(false, 'Нет сообщение об ошибке');
        except

        end;
        Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 3), 'Количество записей не изменилось');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;

  end;

  initialization
  TestFramework.RegisterTest('Объекты', TAssetGroupTest.Suite);

end.
