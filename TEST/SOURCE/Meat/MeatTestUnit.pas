unit MeatTestUnit;

interface

uses TestFramework, Db;

type
  TMeatTest = class (TTestCase)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure Test;
  end;

implementation

end.
