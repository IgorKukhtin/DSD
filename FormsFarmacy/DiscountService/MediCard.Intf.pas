unit MediCard.Intf;

interface

uses
  Data.DB, System.Contnrs, System.SysUtils;

const
  // Запрос скидки на товар
  MC_DISCOUNT = 1;
  // Подтверждение продажи товара
  MC_SALE = 2;
  // Получение статуса дисконтной карты
  MC_STATUS = 3;

  // Продажа товара совершена
  MC_SALE_COMPLETE = 1;
  // Продажа товара не совершена
  MC_SALE_UNCOMPLETE = 2;

  // Запрос принят
  MC_REQUEST_ACCEPTED = 1;
  // Запрос не принят
  MC_REQUEST_NOT_ACCEPTED = 2;

type
  EMCException = class(Exception);

  IMCCasualCache = interface
    ['{E2E11DD1-E64A-40A8-A76E-830FB3CFDE9B}']
    function GenerateCasual: string;
    function Find(AGoodsId: Integer; APrice: Currency): string;
    procedure Delete(AGoodsId: Integer; APrice: Currency);
    procedure Save(AGoodsId: Integer; APrice: Currency; ACasual: string); overload;
    procedure Save(AGoodsId: Integer; APrice: Currency); overload;
    procedure Clear;
  end;

  IMCDesigner = interface
    ['{042F744C-4B1F-4E43-BCB1-2191ACEC3B09}']
    function GetClasses: TClassList;
    function GetCasualCache: IMCCasualCache;
    function GetURL: string;
    procedure SetURL(const Value: string);

    procedure RegisterClasses(AClasses: array of TInterfacedClass);
    function FindClass(const IID: TGUID): TInterfacedClass;
    function CreateObject(const IID: TGUID): TInterfacedObject;

    function HTTPPost(const ABody: string; var AResponse: string): Integer;

    property URL: string read GetURL write SetURL;
    property Classes: TClassList read GetClasses;
    property CasualCache: IMCCasualCache read GetCasualCache;
  end;

  IMCData = interface
    ['{E1C776C0-CDD3-4336-8352-F74D82FB9C8A}']
    function GetParams: TParams;
    procedure LoadFromXML(AXML: string);
    procedure SaveToXML(var AXML: string);
    property Params: TParams read GetParams;
  end;

  IMCSession = interface
    ['{8CFA3CE2-F522-44C0-B984-8238157DABF7}']
    function GetRequest: IMCData;
    function GetResponse: IMCData;
    function Post: Integer;
    property Request: IMCData read GetRequest;
    property Response: IMCData read GetResponse;
  end;

  // Интерфейсы для запроса скидки на товар
  IMCRequestDiscount  = interface ['{DDA3B308-90E9-4537-8A3C-5815B2726794}'] end;
  IMCResponseDiscount = interface ['{C229D58E-20FF-4526-9328-9BB27822EDF7}'] end;
  IMCSessionDiscount  = interface ['{2473D20F-81EE-4FF0-8620-CF70E436E897}'] end;

  // Интерфейсы для подтверждения продажи товара
  IMCRequestSale  = interface ['{F6D99C5F-DEAA-43F9-94F8-6DD57E98213C}'] end;
  IMCResponseSale = interface ['{3FC24168-53DB-4F68-9A23-4350130FC811}'] end;
  IMCSessionSale  = interface ['{9DEC8249-DC56-4251-AE4C-9EEEA5612D8A}'] end;

var
  MCDesigner: IMCDesigner;

implementation

end.
