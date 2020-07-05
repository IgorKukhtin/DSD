unit EdiTest;

interface

uses TestFramework, dbTest;

type

  TdbEDITest = class (TdbTest)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CreateDesadvTest;
    procedure LoadComdocTest;
  end;

implementation

uses SaleMovementItemTest, Authentication, Storage, CommonData, EDI;

{ TdbEDITest }

procedure TdbEDITest.CreateDesadvTest;
var SaleMovementItem: TSaleMovementItem;
    Id: Integer;
    EDI: TEDI;
begin
  { создаем документ реализации и запись в нем }
  // Создаем документ
  SaleMovementItem := TSaleMovementItem.Create;
  EDI := TEDI.Create(nil);
  // создание документа
  try
     Id := SaleMovementItem.InsertDefault;
   //  EDI.DESADV(Id);
     { запускаем процедуру выгрузки документа DESADV}
  finally
    EDI.Free;
    SaleMovementItem.Delete(Id);
  end;
end;

procedure TdbEDITest.LoadComdocTest;
var EDI: TEDI;
begin
  EDI := TEDI.Create(nil);
  // создание документа
  try
   //  EDI.ComdocLoad(nil, nil, '\archive');
     { запускаем процедуру выгрузки документа DESADV}
  finally
    EDI.Free;
  end;
end;

procedure TdbEDITest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TdbEDITest.TearDown;
begin
  inherited;

end;

initialization

//  TestFramework.RegisterTest('EDI', TdbEDITest.Suite);

end.
