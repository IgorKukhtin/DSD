unit UnitsTest;

interface

uses dbTest, dbObjectTest, dbObjectMeatTest, ObjectTest, BranchTest, Variants;

type

  TUnitTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TUnit = class(TObjectTest)
  private
    BranchTest: TBranch;
    function InsertDefault: integer; override;
  public
    function InsertUpdateUnit(Id, Code: Integer; Name: String;
                              PartionDate: Boolean;
                              ParentId, BranchId, BusinessId, JuridicalId,
                              AccountDirectionId, ProfitLossDirectionId: integer): integer;
    constructor Create; override;
  end;


implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TUnitTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Unit\';
  inherited;
end;

procedure TUnitTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TUnit;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TUnit.Create;
  // Получим список объектов
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Подразделении
    with ObjectTest.GetRecord(Id) do begin
         Check((FieldByName('Name').AsString = 'Test - Подразделение'), 'Не сходятся данные Id = ' + IntToStr(Id));
         Check((FieldByName('isLeaf').AsBoolean ), 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id));
    end;
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateUnit(Id, -1, 'Группа 1 - тест', true, Id, 0, 0, 0, 0, 0);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateUnit(0, -2, 'Группа 2 - тест', true, Id, 0, 0, 0, 0, 0);
    try
      with ObjectTest.GetRecord(Id) do begin
           Check(FieldByName('isLeaf').AsBoolean = false, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id));
      end;
      with ObjectTest.GetRecord(Id2) do begin
          Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id2));
      end;
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateUnit(Id, -1, 'Группа 1 - тест', true, Id2, 0, 0, 0, 0, 0);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateUnit(0, -3, 'Группа 3 - тест',true, Id2, 0, 0, 0, 0, 0);
      try
        with ObjectTest.GetRecord(Id2) do begin
           Check(FieldByName('isLeaf').AsBoolean = false, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id2));
        end;
        with ObjectTest.GetRecord(Id3) do begin
           Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id3));
        end;
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateUnit(Id, -1, 'Группа 1 - тест',true, Id3, 0, 0, 0, 0, 0);
          Check(false, 'Нет сообщение об ошибке');
        except

        end;
        Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 3), 'Количество записей не изменилось');
        ObjectTest.InsertUpdateUnit(Id3, -3, 'Группа 3 - тест', true,0, 0, 0, 0, 0, 0);
        with ObjectTest.GetRecord(Id2) do begin
           Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id2));
        end;
      finally
        ObjectTest.Delete(Id3);
      end;
      ObjectTest.InsertUpdateUnit(Id2, -3, 'Группа 3 - тест', true, 0, 0, 0, 0, 0, 0);
      with ObjectTest.GetRecord(Id) do begin
         Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id));
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TUnitTest }

constructor TUnit.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Unit';
  spSelect := 'gpSelect_Object_Unit';
  spGet := 'gpGet_Object_Unit';
  BranchTest := TBranch.Create;
end;

function TUnit.InsertDefault: integer;
begin
  result := InsertUpdateUnit(0, -11100, 'Test - Подразделение',true, 0, BranchTest.GetDefault, 0, 0, 0, 0);
  inherited;
end;

function TUnit.InsertUpdateUnit(Id, Code: Integer; Name: String;
                                    PartionDate: Boolean;
                                    ParentId, BranchId, BusinessId, JuridicalId,
                                    AccountDirectionId, ProfitLossDirectionId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inPartionDate', ftBoolean, ptInput, PartionDate);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  FParams.AddParam('inBranchId', ftInteger, ptInput, BranchId);

  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inContractId', ftInteger, ptInput, null);
  FParams.AddParam('inAccountDirectionId', ftInteger, ptInput, AccountDirectionId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, Null);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, Null);
  FParams.AddParam('inAreaId', ftInteger, ptInput, Null);
  result := InsertUpdate(FParams);
  if Id = 0 then
     InsertedIdObjectList.Add(IntToStr(result));
end;


initialization
  TestFramework.RegisterTest('Объекты', TUnitTest.Suite);

end.
