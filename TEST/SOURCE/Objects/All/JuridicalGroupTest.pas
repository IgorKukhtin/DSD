unit JuridicalGroupTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TJuridicalGroupTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TJuridicalGroup = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateJuridicalGroup(const Id, Code: Integer; Name: string; JuridicalGroupId: integer): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     { TJuridicalGroupTest }
constructor TJuridicalGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_JuridicalGroup';
  spSelect := 'gpSelect_Object_JuridicalGroup';
  spGet := 'gpGet_Object_JuridicalGroup';
end;

function TJuridicalGroup.InsertDefault: integer;
begin
  result := InsertUpdateJuridicalGroup(0, -1, 'Группа юр лиц 1', 0);
  inherited;
end;

function TJuridicalGroup.InsertUpdateJuridicalGroup(const Id, Code: Integer;
  Name: string; JuridicalGroupId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  result := InsertUpdate(FParams);
end;

   procedure TJuridicalGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\JuridicalGroup\';
  inherited;
end;

procedure TJuridicalGroupTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalGroup;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TJuridicalGroup.Create;
  // Получим список объектов
   RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateJuridicalGroup(Id, -1, 'Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateJuridicalGroup(0, -2, 'Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateJuridicalGroup(Id, -1, 'Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateJuridicalGroup(0, -3, 'Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateJuridicalGroup(Id, -1, 'Группа 1', Id3);
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
//  TestFramework.RegisterTest('Объекты', TJuridicalGroupTest.Suite);
end.
