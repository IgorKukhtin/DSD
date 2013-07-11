unit UnitsTest;

interface

uses dbTest, dbObjectTest;

type

  Подразделения = class (TdbTest)
  published
    procedure ЗагрузкаПроцедур; override;
    procedure Тестирование; override;
  end;

  TUnitTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdateUnit(Id, Code: Integer; Name: String;
                              ParentId, BranchId, BusinessId, JuridicalId,
                              AccountDirectionId, ProfitLossDirectionId: integer): integer;
    constructor Create; override;
  end;


implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure Подразделения.ЗагрузкаПроцедур;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\_Unit\';
  inherited;
end;

procedure Подразделения.Тестирование;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TUnitTest;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TUnitTest.Create;
  // Получим список объектов
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Подразделении
    with ObjectTest.GetRecord(Id) do begin
         Check((FieldByName('Name').AsString = 'Подразделение'), 'Не сходятся данные Id = ' + IntToStr(Id));
         Check((FieldByName('isLeaf').AsBoolean ), 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id));
    end;
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateUnit(Id, -1, 'Группа 1 - тест', Id, 0, 0, 0, 0, 0);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateUnit(0, -2, 'Группа 2 - тест', Id, 0, 0, 0, 0, 0);
    with ObjectTest.GetRecord(Id) do begin
         Check(FieldByName('isLeaf').AsBoolean = false, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id));
    end;
    with ObjectTest.GetRecord(Id2) do begin
        Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id2));
    end;
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateUnit(Id, -1, 'Группа 1 - тест', Id2, 0, 0, 0, 0, 0);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateUnit(0, -3, 'Группа 3 - тест', Id2, 0, 0, 0, 0, 0);
      with ObjectTest.GetRecord(Id2) do begin
         Check(FieldByName('isLeaf').AsBoolean = false, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id2));
      end;
      with ObjectTest.GetRecord(Id3) do begin
         Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id3));
      end;
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateUnit(Id, -1, 'Группа 1 - тест', Id3, 0, 0, 0, 0, 0);
          Check(false, 'Нет сообщение об ошибке');
        except

        end;
        Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 3), 'Количество записей не изменилось');
      finally
        ObjectTest.Delete(Id3);
        with ObjectTest.GetRecord(Id2) do begin
           Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id2));
        end;
      end;
    finally
      ObjectTest.Delete(Id2);
      with ObjectTest.GetRecord(Id) do begin
         Check(FieldByName('isLeaf').AsBoolean, 'Не правильно установлено свойство isLeaf Id = ' + IntToStr(Id));
      end;
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TUnitTest }

constructor TUnitTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Unit';
  spSelect := 'gpSelect_Object_Unit';
  spGet := 'gpGet_Object_Unit';
end;

procedure TUnitTest.Delete(Id: Integer);
begin
  inherited;
  with TBranchTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TUnitTest.InsertDefault: integer;
var
  BranchId: Integer;
begin
  BranchId := TBranchTest.Create.GetDefault;
  result := InsertUpdateUnit(0, 1, 'Подразделение', 0, BranchId, 0, 0, 0, 0);
end;

function TUnitTest.InsertUpdateUnit(Id, Code: Integer; Name: String;
                                    ParentId, BranchId, BusinessId, JuridicalId,
                                    AccountDirectionId, ProfitLossDirectionId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  FParams.AddParam('inBranchId', ftInteger, ptInput, BranchId);

  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inAccountDirectionId', ftInteger, ptInput, AccountDirectionId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);

  result := InsertUpdate(FParams);
end;


initialization
  TestFramework.RegisterTest('Объекты', Подразделения.Suite);

end.
