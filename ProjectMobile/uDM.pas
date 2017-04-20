unit uDM;

interface

uses
  FMX.Forms, System.SysUtils, System.Classes, Generics.Collections, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Comp.UI, Variants, FireDAC.FMXUI.Wait, dsdDB, Datasnap.DBClient,
  FMX.Dialogs, FMX.DialogService, System.UITypes, DateUtils
  {$IFDEF ANDROID}
  , Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes, Androidapi.JNI.App
  {$ENDIF};

CONST
  DataBaseFileName = 'aMobile.sdb';

  { базовый запрос на получение информации по ТТ }
  BasePartnerQuery = 'select P.Id, P.CONTRACTID, J.VALUEDATA Name, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, ' +
    'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, C.PAIDKINDID, C.CHANGEPERCENT, ' +
    'P.DEBTSUM, P.OVERSUM, P.OVERDAYS, J.DEBTSUM DEBTSUMJ, J.OVERSUM OVERSUMJ, J.OVERDAYS OVERDAYSJ, ' +
    'PL.ID PRICELISTID, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
    'PLR.ID PRICELISTID_RET, PLR.PRICEWITHVAT PRICEWITHVAT_RET, PLR.VATPERCENT VATPERCENT_RET, ' +
    'P.CalcDayCount, P.OrderDayCount, P.isOperDateOrder ' +
    'from OBJECT_PARTNER P ' +
    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
    'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID, :DefaultPriceList) ' +
    'LEFT JOIN Object_PriceList PLR ON PLR.ID = IFNULL(P.PRICELISTID_RET, :DefaultPriceList) ' +
    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
    'where P.ISERASED = 0 ';

type
  { состояния задания контрагента }
  TActiveMode = (amAll, amOpen, amClose);

  { отдельный поток для показа бегущего круга }
  TProgressThread = class(TThread)
  private
    { Private declarations }
    FProgress : integer;

    procedure Update;
  protected
    procedure Execute; override;
  end;

  { отдельный поток для синхронизации }
  TSyncThread = class(TThread)
  private
    { Private declarations }
    FAllProgress : integer;
    FAllMax : integer;
    FName : string;

    LoadData: boolean;
    UploadData: boolean;

    SyncDataIn : TDate;
    SyncDataOut : TDate;

    procedure Update;
    procedure SetNewProgressTask(AName : string);

    procedure GetSyncDates;
    procedure GetConfigurationInfo;
    procedure GetDictionaries(AName : string);

    procedure UploadStoreReal;
    procedure UploadOrderExternal;
    procedure UploadReturnIn;
    procedure UploadTasks;
    function UploadNewJuridicals(var AId: integer): boolean;
    procedure UploadNewPartners;
    procedure UploadPartnerGPS;
    procedure UploadRouteMember;
    procedure UploadPhotos;
  protected
    procedure Execute; override;
  end;

  { отдельный поток для выполнения процедур получения данных с сервера }
  TWaitThread = class(TThread)
  private
    TaskName : string;

    DateStart, DateEnd: TDate;
    JuridicalId, PartnerId, ContractId, PaidKindId: integer;

    procedure SetTaskName(AName : string);

    function LoadJuridicalCollation: string;
    function UpdateProgram: string;
  protected
    procedure Execute; override;
  end;

  { классы для создания БД на основе TFDTable модуля TDM }
  TDataSets = TObjectList<TFDTable>;

  TStructure = Class(TObject)
  private
    FDataSets: TDataSets;
    FLastDataSet: TFDTable;
    FIndexes: TStringList;
    function GetDataSet(const ATableName: String): TFDTable;
    function GetIndex(const AIndex: integer): string;
    function GetIndexCount: integer;
    procedure MakeIndex(ATable: TFDTable);
    procedure MakeDopIndex(ATable: TFDTable);
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure OpenDS(ATable: TFDTable);
    procedure AddTable(ATable: TFDTable);
    property DataSets: TDataSets read FDataSets;
    property DataSet[const ATableName: String]: TFDTable read GetDataSet;
    property Indexes[const AIndex: integer]: string read GetIndex;
    property IndexCount: integer read GetIndexCount;
  End;

  { основной модуль работы с БД }
  TDM = class(TDataModule)
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryMeta: TFDMetaInfoQuery;
    qryMeta2: TFDMetaInfoQuery;
    conMain: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    tblObject_Const: TFDTable;
    tblObject_ConstPaidKindName_First: TStringField;
    tblObject_ConstPaidKindId_Second: TIntegerField;
    tblObject_ConstPaidKindName_Second: TStringField;
    tblObject_ConstStatusId_Complete: TIntegerField;
    tblObject_ConstStatusName_Complete: TStringField;
    tblObject_ConstStatusId_UnComplete: TIntegerField;
    tblObject_ConstStatusName_UnComplete: TStringField;
    tblObject_ConstStatusId_Erased: TIntegerField;
    tblObject_ConstStatusName_Erased: TStringField;
    tblObject_ConstUnitId: TIntegerField;
    tblObject_ConstUnitName: TStringField;
    tblObject_ConstUnitId_ret: TIntegerField;
    tblObject_ConstUnitName_ret: TStringField;
    tblObject_ConstCashId: TIntegerField;
    tblObject_ConstCashName: TStringField;
    tblObject_ConstMemberId: TIntegerField;
    tblObject_ConstMemberName: TStringField;
    tblObject_ConstPersonalId: TIntegerField;
    tblObject_ConstUserId: TIntegerField;
    tblObject_ConstUserLogin: TStringField;
    tblObject_ConstUserPassword: TStringField;
    tblObject_ConstWebService: TStringField;
    tblObject_ConstSyncDateIn: TDateTimeField;
    tblObject_ConstSyncDateOut: TDateTimeField;
    tblObject_Partner: TFDTable;
    tblObject_PartnerId: TIntegerField;
    tblObject_PartnerObjectCode: TIntegerField;
    tblObject_PartnerValueData: TStringField;
    tblObject_PartnerAddress: TStringField;
    tblObject_PartnerSchedule: TStringField;
    tblObject_PartnerDebtSum: TFloatField;
    tblObject_PartnerOverSum: TFloatField;
    tblObject_PartnerOverDays: TIntegerField;
    tblObject_PartnerPrepareDayCount: TIntegerField;
    tblObject_PartnerJuridicalId: TIntegerField;
    tblObject_PartnerRouteId: TIntegerField;
    tblObject_PartnerContractId: TIntegerField;
    tblObject_PartnerPriceListId: TIntegerField;
    tblObject_PartnerPriceListId_ret: TIntegerField;
    tblObject_PartnerisErased: TBooleanField;
    tblObject_Juridical: TFDTable;
    tblObject_JuridicalId: TIntegerField;
    tblObject_JuridicalObjectCode: TIntegerField;
    tblObject_JuridicalValueData: TStringField;
    tblObject_JuridicalDebtSum: TFloatField;
    tblObject_JuridicalOverSum: TFloatField;
    tblObject_JuridicalOverDays: TIntegerField;
    tblObject_JuridicalContractId: TIntegerField;
    tblObject_JuridicalisErased: TBooleanField;
    tblObject_Route: TFDTable;
    tblObject_RouteId: TIntegerField;
    tblObject_RouteObjectCode: TIntegerField;
    tblObject_RouteValueData: TStringField;
    tblObject_RouteisErased: TBooleanField;
    tblObject_GoodsGroup: TFDTable;
    tblObject_GoodsGroupId: TIntegerField;
    tblObject_GoodsGroupObjectCode: TIntegerField;
    tblObject_GoodsGroupValueData: TStringField;
    tblObject_GoodsGroupisErased: TBooleanField;
    tblObject_Goods: TFDTable;
    tblObject_GoodsId: TIntegerField;
    tblObject_GoodsObjectCode: TIntegerField;
    tblObject_GoodsValueData: TStringField;
    tblObject_GoodsWeight: TFloatField;
    tblObject_GoodsGoodsGroupId: TIntegerField;
    tblObject_GoodsMeasureId: TIntegerField;
    tblObject_GoodsisErased: TBooleanField;
    tblObject_GoodsKind: TFDTable;
    tblObject_GoodsKindId: TIntegerField;
    tblObject_GoodsKindObjectCode: TIntegerField;
    tblObject_GoodsKindValueData: TStringField;
    tblObject_GoodsKindisErased: TBooleanField;
    tblObject_Measure: TFDTable;
    tblObject_MeasureId: TIntegerField;
    tblObject_MeasureObjectCode: TIntegerField;
    tblObject_MeasureValueData: TStringField;
    tblObject_MeasureisErased: TBooleanField;
    tblObject_GoodsByGoodsKind: TFDTable;
    tblObject_GoodsByGoodsKindId: TIntegerField;
    tblObject_GoodsByGoodsKindGoodsId: TIntegerField;
    tblObject_GoodsByGoodsKindGoodsKindId: TIntegerField;
    tblObject_GoodsByGoodsKindisErased: TBooleanField;
    tblObject_Contract: TFDTable;
    tblObject_ContractId: TIntegerField;
    tblObject_ContractObjectCode: TIntegerField;
    tblObject_ContractValueData: TStringField;
    tblObject_ContractContractTagName: TStringField;
    tblObject_ContractInfoMoneyName: TStringField;
    tblObject_ContractComment: TStringField;
    tblObject_ContractPaidKindId: TIntegerField;
    tblObject_ContractStartDate: TDateTimeField;
    tblObject_ContractEndDate: TDateTimeField;
    tblObject_ContractChangePercent: TFloatField;
    tblObject_ContractDelayDayCalendar: TFloatField;
    tblObject_ContractDelayDayBank: TFloatField;
    tblObject_ContractisErased: TBooleanField;
    tblObject_PriceList: TFDTable;
    tblObject_PriceListId: TIntegerField;
    tblObject_PriceListObjectCode: TIntegerField;
    tblObject_PriceListValueData: TStringField;
    tblObject_PriceListisErased: TBooleanField;
    tblObject_PriceListPriceWithVAT: TBooleanField;
    tblObject_PriceListItems: TFDTable;
    tblObject_PriceListItemsId: TIntegerField;
    tblObject_PriceListItemsGoodsId: TIntegerField;
    tblObject_PriceListItemsPriceListId: TIntegerField;
    tblObject_PriceListItemsStartDate: TDateTimeField;
    tblObject_PriceListItemsEndDate: TDateTimeField;
    tblObject_PriceListItemsPrice: TFloatField;
    tblObject_ConstPaidKindId_First: TIntegerField;
    qryPartner: TFDQuery;
    qryPartnerAddress: TStringField;
    qryPartnerName: TStringField;
    qryPartnerSCHEDULE: TStringField;
    qryPartnerId: TIntegerField;
    qryPartnerCONTRACTID: TIntegerField;
    qryPartnerContractName: TWideStringField;
    qryPartnerGPSN: TFloatField;
    qryPartnerGPSE: TFloatField;
    qryPartnerPaidKindId: TIntegerField;
    qryPartnerChangePercent: TFloatField;
    qryPartnerPriceWithVAT: TBooleanField;
    qryPartnerVATPercent: TFloatField;
    tblObject_PartnerGPSN: TFloatField;
    tblObject_PartnerGPSE: TFloatField;
    qryPriceList: TFDQuery;
    qryPriceListId: TIntegerField;
    qryPriceListValueData: TStringField;
    qryGoodsForPriceList: TFDQuery;
    qryGoodsForPriceListId: TIntegerField;
    qryGoodsForPriceListGoodsName: TStringField;
    qryGoodsForPriceListOBJECTCODE: TIntegerField;
    qryGoodsForPriceListKindName: TStringField;
    tblMovement_OrderExternal: TFDTable;
    tblMovement_OrderExternalGUID: TStringField;
    tblMovement_OrderExternalInvNumber: TStringField;
    tblMovement_OrderExternalOperDate: TDateTimeField;
    tblMovement_OrderExternalStatusId: TIntegerField;
    tblMovement_OrderExternalPartnerId: TIntegerField;
    tblMovement_OrderExternalPaidKindId: TIntegerField;
    tblMovement_OrderExternalContractId: TIntegerField;
    tblMovement_OrderExternalPriceListId: TIntegerField;
    tblMovement_OrderExternalPriceWithVAT: TBooleanField;
    tblMovement_OrderExternalVATPercent: TFloatField;
    tblMovement_OrderExternalChangePercent: TFloatField;
    tblMovement_OrderExternalTotalCountKg: TFloatField;
    tblMovement_OrderExternalTotalSumm: TFloatField;
    tblMovement_OrderExternalInsertDate: TDateTimeField;
    tblMovement_OrderExternalisSync: TBooleanField;
    tblMovementItem_OrderExternal: TFDTable;
    tblMovementItem_OrderExternalMovementId: TIntegerField;
    tblMovementItem_OrderExternalGUID: TStringField;
    tblMovementItem_OrderExternalGoodsId: TIntegerField;
    tblMovementItem_OrderExternalGoodsKindId: TIntegerField;
    tblMovementItem_OrderExternalChangePercent: TFloatField;
    tblMovementItem_OrderExternalAmount: TFloatField;
    tblMovementItem_OrderExternalPrice: TFloatField;
    tblMovement_StoreReal: TFDTable;
    tblMovement_StoreRealGUID: TStringField;
    tblMovement_StoreRealInvNumber: TStringField;
    tblMovement_StoreRealOperDate: TDateTimeField;
    tblMovement_StoreRealStatusId: TIntegerField;
    tblMovement_StoreRealPartnerId: TIntegerField;
    tblMovementItem_StoreReal: TFDTable;
    tblMovementItem_StoreRealMovementId: TIntegerField;
    tblMovementItem_StoreRealGUID: TStringField;
    tblMovementItem_StoreRealGoodsId: TIntegerField;
    tblMovementItem_StoreRealGoodsKindId: TIntegerField;
    tblMovementItem_StoreRealAmount: TFloatField;
    qryGoodsItems: TFDQuery;
    qryGoodsItemsGoodsID: TIntegerField;
    qryGoodsItemsKindID: TIntegerField;
    qryGoodsItemsFullInfo: TWideStringField;
    qryGoodsItemsKind: TStringField;
    qryGoodsItemsMeasure: TStringField;
    qryGoodsItemsPrice: TFloatField;
    qryGoodsItemsRemains: TFloatField;
    qryGoodsItemsName: TStringField;
    tblMovement_OrderExternalId: TAutoIncField;
    tblObject_PriceListVATPercent: TFloatField;
    tblMovementItem_OrderExternalId: TAutoIncField;
    tblMovement_Visit: TFDTable;
    tblMovement_VisitPartnerId: TIntegerField;
    tblMovement_VisitId: TAutoIncField;
    tblMovement_VisitComment: TStringField;
    tblObject_GoodsByGoodsKindRemains: TFloatField;
    tblObject_GoodsByGoodsKindForecast: TFloatField;
    tblObject_GoodsListSale: TFDTable;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    BooleanField2: TBooleanField;
    tblObject_GoodsListSalePartnerId: TIntegerField;
    tblObject_GoodsListSaleAmountCalc: TFloatField;
    cdsOrderItems: TClientDataSet;
    cdsOrderItemsId: TIntegerField;
    cdsOrderItemsGoodsName: TStringField;
    cdsOrderItemsKindName: TStringField;
    cdsOrderItemsPrice: TFloatField;
    cdsOrderItemsRemains: TFloatField;
    cdsOrderItemsRecommend: TStringField;
    cdsOrderItemsCount: TFloatField;
    cdsOrderItemsMeasure: TStringField;
    cdsOrderItemsGoodsId: TIntegerField;
    cdsOrderItemsKindId: TIntegerField;
    cdsOrderItemsWeight: TFloatField;
    cdsOrderItemsisChangePercent: TBooleanField;
    cdsOrderExternal: TClientDataSet;
    cdsOrderExternalName: TStringField;
    cdsOrderExternalPrice: TStringField;
    cdsOrderExternalWeight: TStringField;
    cdsOrderExternalStatus: TStringField;
    cdsOrderExternalId: TIntegerField;
    cdsOrderExternalOperDate: TDateField;
    tblMovement_RouteMember: TFDTable;
    AutoIncField1: TAutoIncField;
    tblMovement_RouteMemberGPSN: TFloatField;
    tblMovement_RouteMemberGPSE: TFloatField;
    tblMovement_RouteMemberInsertDate: TDateTimeField;
    tblMovement_RouteMemberisSync: TBooleanField;
    tblMovement_RouteMemberGUID: TStringField;
    tblMovement_VisitGUID: TStringField;
    tblMovement_VisitInvNumber: TStringField;
    tblMovement_VisitOperDate: TDateTimeField;
    tblMovement_VisitisSync: TBooleanField;
    tblMovementItem_Visit: TFDTable;
    tblMovementItem_VisitMovementId: TIntegerField;
    tblMovementItem_VisitGUID: TStringField;
    tblMovementItem_VisitPhoto: TBlobField;
    tblMovementItem_VisitComment: TStringField;
    tblMovementItem_VisitInsertDate: TDateTimeField;
    tblMovementItem_VisitId: TAutoIncField;
    qryPhotoGroups: TFDQuery;
    qryPhotos: TFDQuery;
    qryPhotoGroupsId: TIntegerField;
    qryPhotoGroupsComment: TStringField;
    qryPhotosId: TIntegerField;
    qryPhotosPhoto: TBlobField;
    qryPhotosComment: TStringField;
    cdsStoreReals: TClientDataSet;
    cdsStoreRealsComment: TStringField;
    cdsStoreRealsId: TIntegerField;
    cdsStoreRealsOperDate: TDateField;
    cdsStoreRealsName: TStringField;
    cdsStoreRealsStatus: TStringField;
    cdsStoreRealItems: TClientDataSet;
    cdsStoreRealItemsId: TIntegerField;
    cdsStoreRealItemsGoodsName: TStringField;
    cdsStoreRealItemsKindName: TStringField;
    cdsStoreRealItemsCount: TFloatField;
    cdsStoreRealItemsMeasure: TStringField;
    cdsStoreRealItemsGoodsId: TIntegerField;
    cdsStoreRealItemsKindId: TIntegerField;
    tblMovement_StoreRealIsSync: TBooleanField;
    tblMovement_StoreRealComment: TStringField;
    tblMovement_StoreRealId: TAutoIncField;
    tblMovementItem_StoreRealId: TAutoIncField;
    tblObject_PartnerDocumentDayCount: TFloatField;
    tblObject_PartnerCalcDayCount: TFloatField;
    tblObject_PartnerOrderDayCount: TFloatField;
    tblObject_PartnerisOperDateOrder: TBooleanField;
    tblObject_PartnerisSync: TBooleanField;
    qryPartnerCalcDayCount: TFloatField;
    qryPartnerOrderDayCount: TFloatField;
    tblObject_PriceListItemsSaleStartDate: TDateTimeField;
    tblObject_PriceListItemsSaleEndDate: TDateTimeField;
    tblObject_PriceListItemsSalePrice: TFloatField;
    qryPartnerisOperDateOrder: TBooleanField;
    tblMovement_Promo: TFDTable;
    tblMovement_PromoId: TIntegerField;
    tblMovement_PromoInvNumber: TStringField;
    tblMovement_PromoOperDate: TDateTimeField;
    tblMovement_PromoStatusId: TIntegerField;
    tblMovement_PromoStartSale: TDateTimeField;
    tblMovement_PromoEndSale: TDateTimeField;
    tblMovement_PromoisChangePercent: TBooleanField;
    tblMovement_PromoCommentMain: TStringField;
    tblMovementItem_PromoPartner: TFDTable;
    tblMovementItem_PromoPartnerId: TIntegerField;
    tblMovementItem_PromoPartnerMovementId: TIntegerField;
    tblMovementItem_PromoPartnerContractId: TIntegerField;
    tblMovementItem_PromoPartnerPartnerId: TIntegerField;
    tblMovementItem_PromoGoods: TFDTable;
    tblMovementItem_PromoGoodsId: TIntegerField;
    tblMovementItem_PromoGoodsMovementId: TIntegerField;
    tblMovementItem_PromoGoodsGoodsId: TIntegerField;
    tblMovementItem_PromoGoodsGoodsKindId: TIntegerField;
    tblMovementItem_PromoGoodsPriceWithOutVAT: TFloatField;
    tblMovementItem_PromoGoodsPriceWithVAT: TFloatField;
    tblMovementItem_PromoGoodsTaxPromo: TFloatField;
    qryGoodsItemsPromoPrice: TWideStringField;
    qryGoodsItemsSearchName: TWideStringField;
    cdsOrderItemsIsPromo: TStringField;
    tblMovement_ReturnIn: TFDTable;
    tblMovement_ReturnInId: TAutoIncField;
    tblMovement_ReturnInGUID: TStringField;
    tblMovement_ReturnInInvNumber: TStringField;
    tblMovement_ReturnInOperDate: TDateTimeField;
    tblMovement_ReturnInStatusId: TIntegerField;
    tblMovement_ReturnInPriceWithVAT: TBooleanField;
    tblMovement_ReturnInInsertDate: TDateTimeField;
    tblMovement_ReturnInVATPercent: TFloatField;
    tblMovement_ReturnInChangePercent: TFloatField;
    tblMovement_ReturnInTotalCountKg: TFloatField;
    tblMovement_ReturnInTotalSummPVAT: TFloatField;
    tblMovement_ReturnInPaidKindId: TIntegerField;
    tblMovement_ReturnInPartnerId: TIntegerField;
    tblMovement_ReturnInContractId: TIntegerField;
    tblMovement_ReturnInComment: TStringField;
    tblMovement_ReturnInisSync: TBooleanField;
    tblMovementItem_ReturnIn: TFDTable;
    tblMovementItem_ReturnInId: TAutoIncField;
    tblMovementItem_ReturnInMovementId: TIntegerField;
    tblMovementItem_ReturnInGUID: TStringField;
    tblMovementItem_ReturnInGoodsId: TIntegerField;
    tblMovementItem_ReturnInGoodsKindId: TIntegerField;
    tblMovementItem_ReturnInAmount: TFloatField;
    tblMovementItem_ReturnInPrice: TFloatField;
    tblMovementItem_ReturnInChangePercent: TFloatField;
    cdsReturnIn: TClientDataSet;
    cdsReturnInItems: TClientDataSet;
    cdsReturnInId: TIntegerField;
    cdsReturnInOperDate: TDateField;
    cdsReturnInName: TStringField;
    cdsReturnInPrice: TStringField;
    cdsReturnInWeight: TStringField;
    cdsReturnInStatus: TStringField;
    cdsReturnInItemsId: TIntegerField;
    cdsReturnInItemsGoodsName: TStringField;
    cdsReturnInItemsKindName: TStringField;
    cdsReturnInItemsPrice: TFloatField;
    cdsReturnInItemsWeight: TFloatField;
    cdsReturnInItemsMeasure: TStringField;
    cdsReturnInItemsCount: TFloatField;
    cdsReturnInItemsGoodsId: TIntegerField;
    cdsReturnInItemsKindId: TIntegerField;
    cdsReturnInComment: TStringField;
    qryPromoPartners: TFDQuery;
    qryPromoGoods: TFDQuery;
    qryPromoPartnersPartnerName: TStringField;
    qryPromoPartnersAddress: TStringField;
    qryPromoGoodsGoodsName: TStringField;
    qryPromoGoodsTax: TWideStringField;
    qryPromoGoodsPrice: TWideStringField;
    tblObject_ConstMobileVersion: TStringField;
    tblObject_ConstMobileAPKFileName: TStringField;
    tblMovement_Task: TFDTable;
    tblMovementItem_Task: TFDTable;
    tblMovement_TaskId: TIntegerField;
    tblMovement_TaskInvNumber: TStringField;
    tblMovement_TaskOperDate: TDateTimeField;
    tblMovement_TaskStatusId: TIntegerField;
    tblMovement_TaskPersonalId: TIntegerField;
    tblMovementItem_TaskId: TIntegerField;
    tblMovementItem_TaskMovementId: TIntegerField;
    tblMovementItem_TaskPartnerId: TIntegerField;
    tblMovementItem_TaskClosed: TBooleanField;
    tblMovementItem_TaskDescription: TStringField;
    tblMovementItem_TaskComment: TStringField;
    tblMovementItem_TaskisSync: TBooleanField;
    qryPromoPartnersContractName: TWideStringField;
    qryPromoGoodsKindName: TWideStringField;
    qryGoodsForPriceListFullPrice: TStringField;
    qryPriceListPriceWithVAT: TBooleanField;
    qryPriceListVATPercent: TFloatField;
    qryGoodsForPriceListMeasure: TStringField;
    qryGoodsForPriceListPrice: TFloatField;
    qryPromoPartnersPartnerId: TIntegerField;
    qryPromoPartnersContractId: TIntegerField;
    qryPromoGoodsTermin: TWideStringField;
    qryPromoPartnersPromoIds: TWideStringField;
    qryPromoGoodsPromoId: TIntegerField;
    qrySelect: TFDQuery;
    cdsJuridicalCollation: TClientDataSet;
    cdsJuridicalCollationDocNum: TStringField;
    cdsJuridicalCollationDocType: TStringField;
    cdsJuridicalCollationDocDate: TDateField;
    cdsJuridicalCollationPaidKind: TStringField;
    cdsJuridicalCollationDocNumDate: TStringField;
    cdsJuridicalCollationDocTypeShow: TStringField;
    cdsJuridicalCollationFromName: TStringField;
    cdsJuridicalCollationToName: TStringField;
    cdsJuridicalCollationFromToName: TStringField;
    cdsTasks: TClientDataSet;
    cdsTasksInvNumber: TStringField;
    cdsTasksOperDate: TDateTimeField;
    cdsTasksPartnerId: TIntegerField;
    cdsTasksClosed: TBooleanField;
    cdsTasksDescription: TStringField;
    cdsTasksComment: TStringField;
    cdsTasksId: TIntegerField;
    cdsTasksPartnerName: TStringField;
    cdsTasksTaskDate: TStringField;
    cdsTasksTaskDescription: TStringField;
    cdsJuridicalCollationDebet: TStringField;
    cdsJuridicalCollationKredit: TStringField;
    tblObject_ConstPriceListId_def: TIntegerField;
    tblObject_ConstPriceListName_def: TStringField;
    qryPartnerPRICELISTID: TIntegerField;
    qryPartnerPRICELISTID_RET: TIntegerField;
    qryPartnerPriceWithVAT_RET: TBooleanField;
    qryPartnerVATPercent_RET: TFloatField;
    tblObject_PartnerGUID: TStringField;
    tblObject_JuridicalGUID: TStringField;
    tblObject_JuridicalisSync: TBooleanField;
    qryPartnerDebtSum: TFloatField;
    qryPartnerDebtSumJ: TFloatField;
    qryPartnerOverSum: TFloatField;
    qryPartnerOverSumJ: TFloatField;
    qryPartnerOverDays: TIntegerField;
    qryPartnerOverDaysJ: TIntegerField;
    tblMovement_StoreRealInsertDate: TDateTimeField;
    tblMovement_VisitInsertDate: TDateTimeField;
    qryPhotoGroupsStatusId: TIntegerField;
    tblMovement_VisitStatusId: TIntegerField;
    tblMovementItem_VisitisErased: TBooleanField;
    qryPhotosisErased: TBooleanField;
    tblMovementItem_VisitisSync: TBooleanField;
    qryPhotosisSync: TBooleanField;
    tblMovement_OrderExternalComment: TStringField;
    tblMovement_OrderExternalUnitId: TIntegerField;
    cdsOrderExternalComment: TStringField;
    tblMovement_ReturnInUnitId: TIntegerField;
    cdsOrderExternalisSync: TBooleanField;
    cdsStoreRealsisSync: TBooleanField;
    cdsReturnInisSync: TBooleanField;
    cdsOrderExternalStatusId: TIntegerField;
    cdsStoreRealsStatusId: TIntegerField;
    cdsReturnInStatusId: TIntegerField;
    qryGoodsForPriceListStartDate: TDateTimeField;
    qryGoodsForPriceListTermin: TStringField;
    cdsStoreRealsPartnerId: TIntegerField;
    cdsStoreRealsPartnerName: TStringField;
    cdsStoreRealsPriceListId: TIntegerField;
    cdsStoreRealsAddress: TStringField;
    cdsOrderExternalPartnerId: TIntegerField;
    cdsOrderExternalContractId: TIntegerField;
    cdsOrderExternalPartnerName: TStringField;
    cdsOrderExternalPaidKindId: TIntegerField;
    cdsOrderExternalPriceListId: TIntegerField;
    cdsOrderExternalPriceWithVAT: TBooleanField;
    cdsOrderExternalVATPercent: TFloatField;
    cdsOrderExternalChangePercent: TFloatField;
    cdsOrderExternalCalcDayCount: TFloatField;
    cdsOrderExternalOrderDayCount: TFloatField;
    cdsOrderExternalisOperDateOrder: TBooleanField;
    cdsOrderExternalAddress: TStringField;
    cdsOrderExternalContractName: TStringField;
    cdsReturnInPartnerId: TIntegerField;
    cdsReturnInPartnerName: TStringField;
    cdsReturnInContractId: TIntegerField;
    cdsReturnInContractName: TStringField;
    cdsReturnInPaidKindId: TIntegerField;
    cdsReturnInPriceWithVAT: TBooleanField;
    cdsReturnInVATPercent: TFloatField;
    cdsReturnInChangePercent: TFloatField;
    cdsReturnInPriceListId: TIntegerField;
    cdsReturnInAddress: TStringField;
    qryPhotoGroupsName: TStringField;
    qryPhotoGroupsOperDate: TDateTimeField;
    qryPhotoGroupsIsSync: TBooleanField;
    qryPhotoGroupDocs: TFDQuery;
    qryPhotoGroupDocsId: TIntegerField;
    qryPhotoGroupDocsComment: TStringField;
    qryPhotoGroupDocsStatusId: TIntegerField;
    qryPhotoGroupDocsName: TStringField;
    qryPhotoGroupDocsOperDate: TDateTimeField;
    qryPhotoGroupDocsIsSync: TBooleanField;
    qryPhotoGroupDocsPartnerId: TIntegerField;
    qryPhotoGroupDocsPartnerName: TStringField;
    qryPhotoGroupDocsAddress: TStringField;
    qryPhotoGroupDocsGroupName: TStringField;
    tblMovementItem_VisitGPSN: TFloatField;
    tblMovementItem_VisitGPSE: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryGoodsForPriceListCalcFields(DataSet: TDataSet);
    procedure qryPhotoGroupsCalcFields(DataSet: TDataSet);
    procedure qryPhotoGroupDocsCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FConnected: Boolean;
    FDataBase: String;

    procedure InitStructure;
  public
    { Public declarations }
    function Connect: Boolean;
    function ConnectWithOutDB: Boolean;
    function CheckStructure: Boolean;
    procedure CreateIndexes;
    function CreateDataBase: Boolean;

    function GetCurrentVersion: string;
    function CompareVersion(ACurVersion, AServerVersion: string): integer;
    procedure CheckUpdate;
    procedure UpdateProgram(const AResult: TModalResult);

    procedure SynchronizeWithMainDatabase(LoadData: boolean = true; UploadData: boolean = true);

    function SaveStoreReal(Comment: string; DelItems : string; Complete: boolean;
      var ErrorMessage : string) : boolean;
    procedure NewStoreReal;
    procedure LoadStoreReals;
    procedure LoadAllStoreReals(AStartDate, AEndDate: TDate);
    procedure AddedGoodsToStoreReal(AGoods : string);
    procedure DefaultStoreRealItems;
    procedure LoadStoreRealItems(AId: integer);
    procedure GenerateStoreRealItemsList;

    function SaveOrderExternal(OperDate: TDate; Comment: string;
      ToralPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string) : boolean;
    procedure NewOrderExternal;
    procedure LoadOrderExternal;
    procedure LoadAllOrderExternal(AStartDate, AEndDate: TDate);
    procedure AddedGoodsToOrderExternal(AGoods : string);
    procedure DefaultOrderExternalItems;
    procedure LoadOrderExtrenalItems(AId: integer);
    procedure GenerateOrderExtrenalItemsList;

    function SaveReturnIn(OperDate: TDate; Comment : string;
      ToralPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string) : boolean;
    procedure NewReturnIn;
    procedure LoadReturnIn;
    procedure LoadAllReturnIn(AStartDate, AEndDate: TDate);
    procedure AddedGoodsToReturnIn(AGoods : string);
    procedure DefaultReturnInItems;
    procedure LoadReturnInItems(AId: integer);
    procedure GenerateReturnInItemsList;

    procedure SavePhotoGroup(AGroupName: string);
    procedure LoadPhotoGroups;
    procedure LoadAllPhotoGroups(AStartDate, AEndDate: TDate);

    procedure GenerateJuridicalCollation(ADateStart, ADateEnd: TDate;
      AJuridicalId, APartnerId, AContractId, APaidKindId: integer);

    function LoadTasks(Active: TActiveMode; SaveData: boolean = true; ADate: TDate = 0; APartnerId: integer = 0): integer;
    function CloseTask(ATasksId: integer; ATaskComment: string): boolean;

    function CreateNewPartner(JuridicalId: integer; JuridicalName, Address: string;
      GPSN, GPSE: Double; var ErrorMessage : string): boolean;

    property Connected: Boolean read FConnected;
  end;

var
  DM: TDM;
  Structure: TStructure;
  ProgressThread : TProgressThread;
  SyncThread : TSyncThread;
  WaitThread : TWaitThread;

implementation

uses
  System.IOUtils, CursorUtils, CommonData, Authentication, Storage, uMain, ZLib;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ Процедура по символьно переводит строку в набор цифр }
function ReConvertConvert(S: string): TBytes;
var
  i, l, k: integer;
  InB: TBytes;
begin
  i := Low(S);
  l := High(S);
  SetLength(InB, Length(S) div 2);
  k := 0;
  while i <= l do
  begin
    InB[k] := StrToInt('$' + s[i] + s[i+1]);
    inc(k);
    i := i + 2;
  end;
  ZDecompress(InB, Result);
end;

{ Процедура по символьно переводит строку в набор цифр }
function ConvertConvert(S: TBytes): String;
var
  i, l: integer;
  ArcS: TBytes;
begin
  ZCompress(S, ArcS);
  result := '';
  l := Length(ArcS);
  for I := 0 to l - 1 do
    result := result + IntToHex(ArcS[i], 2);
end;

{ обновление бегущего круга }
procedure TProgressThread.Update;
var
  d: single;
begin
  inc(FProgress);
  if FProgress>= 100 then
    FProgress := 0;

  d := (FProgress * 360 / 100);

  frmMain.pieProgress.StartAngle := d - 20;
  frmMain.pieProgress.EndAngle := d;
end;

procedure TProgressThread.Execute;
begin
  FProgress := 0;

  while true do
  begin
    if ProgressThread.Terminated then
      exit;

    Synchronize(Update);
    sleep(20);
  end;
end;

{ обновление процентов выполнения синхронизации и названия текущей операции }
procedure TSyncThread.Update;
var
  d: single;
begin
  d := (FAllProgress * 360 / FAllMax);

  frmMain.pieAllProgress.EndAngle := d;

  frmMain.lProgress.Text := inttostr((FAllProgress * 100) div FAllMax) + '%';
  frmMain.lProgressName.Text := FName;
end;

{ изменение текущей операции }
procedure TSyncThread.SetNewProgressTask(AName : string);
begin
  FName := AName;
  inc(FAllProgress);

  Synchronize(Update);
end;

{ получение дат последней синхронизации }
procedure TSyncThread.GetSyncDates;
begin
  if DM.tblObject_Const.Active then
    DM.tblObject_Const.Close;
  DM.tblObject_Const.Open;

  if DM.tblObject_Const.RecordCount = 1 then
  begin
    SyncDataIn := DM.tblObject_ConstSyncDateIn.AsDateTime;
    SyncDataOut := DM.tblObject_ConstSyncDateOut.AsDateTime;
  end
  else
  begin
    SyncDataIn := 0;
    SyncDataOut := 0;
  end;
end;

{ Загрузка с сервера констант и системной информации }
procedure TSyncThread.GetConfigurationInfo;
var
  x, y : integer;
  GetStoredProc : TdsdStoredProc;
  Mapping : array of array[1..2] of integer;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  try
    GetStoredProc.StoredProcName := 'gpGetMobile_Object_Const';
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);
    try
      GetStoredProc.Execute(false, false, false);

      DM.tblObject_Const.First;
      while not DM.tblObject_Const.Eof do
        DM.tblObject_Const.Delete;

      SetLength(Mapping, 0);
      for x := 0 to DM.tblObject_Const.Fields.Count - 1 do
        for y := 0 to GetStoredProc.DataSet.Fields.Count - 1 do
          if CompareText(DM.tblObject_Const.Fields[x].FieldName, GetStoredProc.DataSet.Fields[y].FieldName) = 0 then
          begin
            SetLength(Mapping, Length(Mapping) + 1);

            Mapping[Length(Mapping) - 1][1] := x;
            Mapping[Length(Mapping) - 1][2] := y;

            break;
          end;

      DM.tblObject_Const.Append;

      for x := 0 to Length(Mapping) - 1 do
        DM.tblObject_Const.Fields[ Mapping[x][1] ].Value := GetStoredProc.DataSet.Fields[ Mapping[x][2] ].Value;

      DM.tblObject_Const.FieldByName('SYNCDATEIN').AsDateTime := Date();

      DM.tblObject_Const.Post;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
  end;
end;

{ Загрузка с сервера справочников }
procedure TSyncThread.GetDictionaries(AName : string);
var
  x, y : integer;
  GetStoredProc : TdsdStoredProc;
  CurDictTable : TFDTable;
  FindRec : boolean;
  Mapping : array of array[1..2] of integer;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  CurDictTable := TFDTable.Create(nil);
  CurDictTable.Connection := DM.conMain;
  try
    if AName = 'Partner' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Partner';
      CurDictTable.TableName := 'Object_Partner';
      DM.conMain.ExecSQL('update Object_Partner set isErased = 1');
    end
    else
    if AName = 'Juridical' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Juridical';
      CurDictTable.TableName := 'Object_Juridical';
      DM.conMain.ExecSQL('update Object_Juridical set isErased = 1');
    end
    else
    if AName = 'Route' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Route';
      CurDictTable.TableName := 'Object_Route';
    end
    else
    if AName = 'GoodsGroup' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsGroup';
      CurDictTable.TableName := 'Object_GoodsGroup';
    end
    else
    if AName = 'Goods' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Goods';
      CurDictTable.TableName := 'Object_Goods';
    end
    else
    if AName = 'GoodsKind' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsKind';
      CurDictTable.TableName := 'Object_GoodsKind';
    end
    else
    if AName = 'Measure' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Measure';
      CurDictTable.TableName := 'Object_Measure';
    end
    else
    if AName = 'GoodsByGoodsKind' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsByGoodsKind';
      CurDictTable.TableName := 'Object_GoodsByGoodsKind';
      DM.conMain.ExecSQL('update Object_GoodsByGoodsKind set isErased = 1');
    end
    else
    if AName = 'GoodsListSale' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsListSale';
      CurDictTable.TableName := 'Object_GoodsListSale';
      DM.conMain.ExecSQL('update Object_GoodsListSale set isErased = 1');
    end
    else
    if AName = 'Contract' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Contract';
      CurDictTable.TableName := 'Object_Contract';
    end
    else
    if AName = 'PriceList' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_PriceList';
      CurDictTable.TableName := 'Object_PriceList';
    end
    else
    if AName = 'PriceListItems' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_PriceListItems';
      CurDictTable.TableName := 'Object_PriceListItems';
    end
    else
    if AName = 'PromoMain' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Movement_Promo';
      CurDictTable.TableName := 'Movement_Promo';
      DM.conMain.ExecSQL('delete from Movement_Promo');
    end
    else
    if AName = 'PromoPartner' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Movement_PromoPartner';
      CurDictTable.TableName := 'MovementItem_PromoPartner';
      DM.conMain.ExecSQL('delete from MovementItem_PromoPartner');
    end
    else
    if AName = 'PromoGoods' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_MovementItem_PromoGoods';
      CurDictTable.TableName := 'MovementItem_PromoGoods';
      DM.conMain.ExecSQL('delete from MovementItem_PromoGoods');
    end
    else
    if AName = 'MovementTask' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Movement_Task';
      CurDictTable.TableName := 'Movement_Task';
    end
    else
    if AName = 'MovementItemTask' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_MovementItem_Task';
      CurDictTable.TableName := 'MovementItem_Task';
    end;

    if GetStoredProc.StoredProcName = '' then
      exit;

    GetStoredProc.Params.AddParam('inSyncDateIn', ftDateTime, ptInput, SyncDataIn);
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);

    try
      GetStoredProc.Execute(false, false, false);

      CurDictTable.Open;

      with GetStoredProc.DataSet do
      begin
        First;

        SetLength(Mapping, 0);
        for x := 0 to CurDictTable.Fields.Count - 1 do
          for y := 0 to GetStoredProc.DataSet.Fields.Count - 1 do
            if CompareText(CurDictTable.Fields[x].FieldName, GetStoredProc.DataSet.Fields[y].FieldName) = 0 then
            begin
              SetLength(Mapping, Length(Mapping) + 1);

              Mapping[Length(Mapping) - 1][1] := x;
              Mapping[Length(Mapping) - 1][2] := y;

              break;
            end;


        while not Eof do
        begin
          if (AName = 'Partner') or (AName = 'Juridical') then
            FindRec := CurDictTable.Locate('Id;ContractId', VarArrayOf([FieldByName('Id').AsInteger, FieldByName('ContractId').AsInteger]))
          else
            FindRec := CurDictTable.Locate('Id', FieldByName('Id').AsInteger);

          if FindRec then
          begin
            if AName = 'MovementItemTask' then
            begin
              Next;
              continue;
            end
            else
              CurDictTable.Edit;
          end
          else
          begin
            if not FieldByName('isSync').AsBoolean then
            begin
              Next;
              continue;
            end;

            CurDictTable.Append;
          end;

          if FieldByName('isSync').AsBoolean then
          begin
            for x := 0 to Length(Mapping) - 1 do
              CurDictTable.Fields[ Mapping[x][1] ].Value := GetStoredProc.DataSet.Fields[ Mapping[x][2] ].Value;
          end
          else
            if (AName <> 'PromoMain') and (AName <> 'PromoPartner') and (AName <> 'PromoGoods')  and
               (AName <> 'MovementTask') and (AName <> 'MovementItemTask')  then
              CurDictTable.FieldByName('isErased').AsBoolean := true;

          CurDictTable.Post;

          Next;
        end;
      end;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    if Assigned(CurDictTable) then
    begin
      CurDictTable.Close;
      FreeAndNil(CurDictTable);
    end;
    FreeAndNil(GetStoredProc);
  end;
end;

{ Сохранение на сервер введенной информации по остаткам }
procedure TSyncThread.UploadStoreReal;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    // Загружаем шапки остатков
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovement_StoreReal do
    begin
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString;
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Movement_StoreReal';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inInvNumber', ftString, ptInput, FieldByName('INVNUMBER').AsString);
          UploadStoredProc.Params.AddParam('inOperDate', ftDateTime, ptInput, FieldByName('OPERDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);

          try
            UploadStoredProc.Execute(false, false, false);

            // Загружаем товары остатков
            DM.tblMovementItem_StoreReal.Close;
            DM.tblMovementItem_StoreReal.Filter := 'MovementId = ' + FieldByName('ID').AsString;
            DM.tblMovementItem_StoreReal.Filtered := true;
            DM.tblMovementItem_StoreReal.Open;

            DM.tblMovementItem_StoreReal.First;
            while not DM.tblMovementItem_StoreReal.Eof do
            begin
              UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_MovementItem_StoreReal';
              UploadStoredProc.Params.Clear;
              UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, DM.tblMovementItem_StoreReal.FieldByName('GUID').AsString);
              UploadStoredProc.Params.AddParam('inMovementGUID', ftString, ptInput, FieldByName('GUID').AsString);
              UploadStoredProc.Params.AddParam('inGoodsId', ftInteger, ptInput, DM.tblMovementItem_StoreReal.FieldByName('GOODSID').AsInteger);
              UploadStoredProc.Params.AddParam('inAmount', ftFloat, ptInput, DM.tblMovementItem_StoreReal.FieldByName('AMOUNT').AsFloat);
              UploadStoredProc.Params.AddParam('inGoodsKindId', ftInteger, ptInput, DM.tblMovementItem_StoreReal.FieldByName('GOODSKINDID').AsInteger);

              UploadStoredProc.Execute(false, false, false);

              DM.tblMovementItem_StoreReal.Next;
            end;

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        DM.tblMovementItem_StoreReal.Close;
        DM.tblMovementItem_StoreReal.Filter := '';
        DM.tblMovementItem_StoreReal.Filtered := false;

        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ Сохранение на сервер введенных заявок }
procedure TSyncThread.UploadOrderExternal;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    // Загружаем шапки заявок
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovement_OrderExternal do
    begin
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString;
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Movement_OrderExternal';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inInvNumber', ftString, ptInput, FieldByName('INVNUMBER').AsString);
          UploadStoredProc.Params.AddParam('inOperDate', ftDateTime, ptInput, FieldByName('OPERDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
          UploadStoredProc.Params.AddParam('inUnitId', ftInteger, ptInput, FieldByName('UNITID').AsInteger);
          UploadStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, FieldByName('PAIDKINDID').AsInteger);
          UploadStoredProc.Params.AddParam('inContractId', ftInteger, ptInput, FieldByName('CONTRACTID').AsInteger);
          UploadStoredProc.Params.AddParam('inPriceListId', ftInteger, ptInput, FieldByName('PRICELISTID').AsInteger);
          UploadStoredProc.Params.AddParam('inPriceWithVAT', ftBoolean, ptInput, FieldByName('PRICEWITHVAT').AsBoolean);
          UploadStoredProc.Params.AddParam('inVATPercent', ftFloat, ptInput, FieldByName('VATPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inChangePercent', ftFloat, ptInput, FieldByName('CHANGEPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);

          try
            UploadStoredProc.Execute(false, false, false);

            // Загружаем товары заявок
            DM.tblMovementItem_OrderExternal.Close;
            DM.tblMovementItem_OrderExternal.Filter := 'MovementId = ' + FieldByName('ID').AsString;
            DM.tblMovementItem_OrderExternal.Filtered := true;
            DM.tblMovementItem_OrderExternal.Open;

            DM.tblMovementItem_OrderExternal.First;
            while not DM.tblMovementItem_OrderExternal.Eof do
            begin
              UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_MovementItem_OrderExternal';
              UploadStoredProc.Params.Clear;
              UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, DM.tblMovementItem_OrderExternal.FieldByName('GUID').AsString);
              UploadStoredProc.Params.AddParam('inMovementGUID', ftString, ptInput, FieldByName('GUID').AsString);
              UploadStoredProc.Params.AddParam('inGoodsId', ftInteger, ptInput, DM.tblMovementItem_OrderExternal.FieldByName('GOODSID').AsInteger);
              UploadStoredProc.Params.AddParam('inGoodsKindId', ftInteger, ptInput, DM.tblMovementItem_OrderExternal.FieldByName('GOODSKINDID').AsInteger);
              UploadStoredProc.Params.AddParam('inChangePercent', ftFloat, ptInput, DM.tblMovementItem_OrderExternal.FieldByName('CHANGEPERCENT').AsFloat);
              UploadStoredProc.Params.AddParam('inAmount', ftFloat, ptInput, DM.tblMovementItem_OrderExternal.FieldByName('AMOUNT').AsFloat);
              UploadStoredProc.Params.AddParam('inPrice', ftFloat, ptInput, DM.tblMovementItem_OrderExternal.FieldByName('PRICE').AsFloat);

              UploadStoredProc.Execute(false, false, false);

              DM.tblMovementItem_OrderExternal.Next;
            end;

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        DM.tblMovementItem_OrderExternal.Close;
        DM.tblMovementItem_OrderExternal.Filter := '';
        DM.tblMovementItem_OrderExternal.Filtered := false;
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ Сохранение на сервер введенной информации по возврату товара }
procedure TSyncThread.UploadReturnIn;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    // Загружаем шапки возвратов
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovement_ReturnIn do
    begin
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString;
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Movement_ReturnIn';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inInvNumber', ftString, ptInput, FieldByName('INVNUMBER').AsString);
          UploadStoredProc.Params.AddParam('inOperDate', ftDateTime, ptInput, FieldByName('OPERDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inStatusId', ftInteger, ptInput, FieldByName('STATUSID').AsInteger);
          UploadStoredProc.Params.AddParam('inPriceWithVAT', ftBoolean, ptInput, FieldByName('PRICEWITHVAT').AsBoolean);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inVATPercent', ftFloat, ptInput, FieldByName('VATPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inChangePercent', ftFloat, ptInput, FieldByName('CHANGEPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, FieldByName('PAIDKINDID').AsInteger);
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
          UploadStoredProc.Params.AddParam('inUnitId', ftInteger, ptInput, FieldByName('UNITID').AsInteger);
          UploadStoredProc.Params.AddParam('inContractId', ftInteger, ptInput, FieldByName('CONTRACTID').AsInteger);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);

          try
            UploadStoredProc.Execute(false, false, false);

            // Загружаем возвращаемые товары
            DM.tblMovementItem_ReturnIn.Close;
            DM.tblMovementItem_ReturnIn.Filter := 'MovementId = ' + FieldByName('ID').AsString;
            DM.tblMovementItem_ReturnIn.Filtered := true;
            DM.tblMovementItem_ReturnIn.Open;

            DM.tblMovementItem_ReturnIn.First;
            while not DM.tblMovementItem_ReturnIn.Eof do
            begin
              UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_MovementItem_ReturnIn';
              UploadStoredProc.Params.Clear;
              UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, DM.tblMovementItem_ReturnIn.FieldByName('GUID').AsString);
              UploadStoredProc.Params.AddParam('inMovementGUID', ftString, ptInput, FieldByName('GUID').AsString);
              UploadStoredProc.Params.AddParam('inGoodsId', ftInteger, ptInput, DM.tblMovementItem_ReturnIn.FieldByName('GOODSID').AsInteger);
              UploadStoredProc.Params.AddParam('inGoodsKindId', ftInteger, ptInput, DM.tblMovementItem_ReturnIn.FieldByName('GOODSKINDID').AsInteger);
              UploadStoredProc.Params.AddParam('inAmount', ftFloat, ptInput, DM.tblMovementItem_ReturnIn.FieldByName('AMOUNT').AsFloat);
              UploadStoredProc.Params.AddParam('inPrice', ftFloat, ptInput, DM.tblMovementItem_ReturnIn.FieldByName('PRICE').AsFloat);
              UploadStoredProc.Params.AddParam('inChangePercent', ftFloat, ptInput, DM.tblMovementItem_ReturnIn.FieldByName('CHANGEPERCENT').AsFloat);

              UploadStoredProc.Execute(false, false, false);

              DM.tblMovementItem_ReturnIn.Next;
            end;

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        DM.tblMovementItem_ReturnIn.Close;
        DM.tblMovementItem_ReturnIn.Filter := '';
        DM.tblMovementItem_ReturnIn.Filtered := false;

        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ сохранение на сервер закрытых заданий }
procedure TSyncThread.UploadTasks;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovementItem_Task do
    begin
      Filter := 'isSync = 0 and Closed = 1';
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_MovementItem_Task';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inId', ftInteger, ptInput, FieldByName('ID').AsInteger);
          UploadStoredProc.Params.AddParam('inMovementId', ftInteger, ptInput, FieldByName('MOVEMENTID').AsInteger);
          UploadStoredProc.Params.AddParam('inClosed', ftBoolean, ptInput, FieldByName('CLOSED').AsBoolean);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inUpdateDate', ftDateTime, ptInput, Now());

          try
            UploadStoredProc.Execute(false, false, false);

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ сохранение на сервер новых юридических лиц }
function TSyncThread.UploadNewJuridicals(var AId: integer): boolean;
var
  UploadStoredProc : TdsdStoredProc;
begin
  Result := false;

  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    with DM.tblObject_Juridical do
    begin
      Filter := 'Id = ' + IntToStr(AId);
      Filtered := true;
      Open;

      try
        First;

        UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Object_Juridical';
        UploadStoredProc.Params.Clear;
        UploadStoredProc.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
        UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
        UploadStoredProc.Params.AddParam('inName', ftString, ptInput, FieldByName('VALUEDATA').AsString);

        try
          UploadStoredProc.Execute(false, false, false);

          AId := StrToInt(UploadStoredProc.ParamByName('ioId').AsString);

          Edit;
          FieldByName('ID').AsInteger := AId;
          FieldByName('GUID').AsString := '';
          FieldByName('IsSync').AsBoolean := true;
          Post;

          Result := true;
        except
          on E : Exception do
          begin
            raise Exception.Create(E.Message);
            exit;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ сохранение на сервер новых ТТ }
procedure TSyncThread.UploadNewPartners;
var
  UploadStoredProc: TdsdStoredProc;
  NewPartnerId, JuridicalId: integer;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    with DM.tblObject_Partner do
    begin
      Filter := 'isSync = 0 and isErased = 0 and Id < 0';
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          JuridicalId := FieldByName('JURIDICALID').AsInteger;

          if JuridicalId < 0 then // сохраняем новое юридическое лицо
          begin
            if not UploadNewJuridicals(JuridicalId) then
            begin
              raise Exception.Create('Не найдено новое юридическое лицо для новой ТТ. Обратитесь к разработчику');
              exit;
            end;
          end;

          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Object_Partner';

          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inName', ftString, ptInput, FieldByName('VALUEDATA').AsString);
          UploadStoredProc.Params.AddParam('inAddress', ftString, ptInput, FieldByName('ADDRESS').AsString);
          UploadStoredProc.Params.AddParam('inPrepareDayCount', ftInteger, ptInput, 1);
          UploadStoredProc.Params.AddParam('inDocumentDayCount', ftInteger, ptInput, 1);
          UploadStoredProc.Params.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);

          try
            UploadStoredProc.Execute(false, false, false);

            NewPartnerId := StrToInt(UploadStoredProc.ParamByName('ioId').AsString);

            Edit;
            FieldByName('ID').AsInteger := NewPartnerId;
            FieldByName('GUID').AsString := '';
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ сохранение на сервер координат ТТ }
procedure TSyncThread.UploadPartnerGPS;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    with DM.tblObject_Partner do
    begin
      Filter := 'isSync = 0 and Id > 0';
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpUpdateMobile_Object_Partner_GPS';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inId', ftInteger, ptInput, FieldByName('ID').AsInteger);
          UploadStoredProc.Params.AddParam('inGPSN', ftFloat, ptInput, FieldByName('GPSN').AsFloat);
          UploadStoredProc.Params.AddParam('inGPSE', ftFloat, ptInput, FieldByName('GPSE').AsFloat);

          try
            UploadStoredProc.Execute(false, false, false);

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ сохранение на сервер маршрута контрагента }
procedure TSyncThread.UploadRouteMember;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovement_RouteMember do
    begin
      Filter := 'isSync = 0';
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Movement_RouteMember';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inInvNumber', ftString, ptInput, FieldByName('ID').AsString);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inGPSN', ftFloat, ptInput, FieldByName('GPSN').AsFloat);
          UploadStoredProc.Params.AddParam('inGPSE', ftFloat, ptInput, FieldByName('GPSE').AsFloat);

          try
            UploadStoredProc.Execute(false, false, false);

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ Сохранение на сервер фотографий }
procedure TSyncThread.UploadPhotos;
var
  UploadStoredProc: TdsdStoredProc;
  PhotoStream: TStream;
  PhotoBytes: TBytes;
  MainGUID : string;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    // Загружаем шапки фотографий (группы)
    with DM.tblMovement_Visit do
    begin
      Filter := 'isSync = 0';
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Movement_Visit';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inInvNumber', ftString, ptInput, FieldByName('INVNUMBER').AsString);
          UploadStoredProc.Params.AddParam('inOperDate', ftDateTime, ptInput, FieldByName('OPERDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inStatusId', ftInteger, ptInput, FieldByName('STATUSID').AsInteger);
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);

          try
            UploadStoredProc.Execute(false, false, false);

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;

    // загружаем фотогорафии
    with DM.tblMovementItem_Visit do
    begin
      Filter := 'isSync = 0';
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_MovementItem_Visit';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);

          DM.qrySelect.Open('select GUID from Movement_Visit where Id = ' + FieldByName('MOVEMENTID').AsString);
          if DM.qrySelect.RecordCount = 1 then
          begin
            MainGUID := DM.qrySelect.Fields[0].AsString;
          end;
          DM.qrySelect.Close;
          UploadStoredProc.Params.AddParam('inMovementGUID', ftString, ptInput, MainGUID);

          PhotoStream := CreateBlobStream(FieldByName('PHOTO'), bmRead);
          try
             SetLength(PhotoBytes, PhotoStream.Size);
             PhotoStream.Position := 0;
             PhotoStream.Read(PhotoBytes, PhotoStream.Size);
             UploadStoredProc.Params.AddParam('inPhoto', ftBlob, ptInput, ConvertConvert(PhotoBytes));
          finally
            FreeAndNil(PhotoStream);
          end;
          UploadStoredProc.Params.AddParam('inPhotoName', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inGPSN', ftFloat, ptInput, FieldByName('GPSN').AsFloat);
          UploadStoredProc.Params.AddParam('inGPSE', ftFloat, ptInput, FieldByName('GPSE').AsFloat);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inIsErased', ftBoolean, ptInput, FieldByName('ISERASED').AsBoolean);

          try
            UploadStoredProc.Execute(false, false, false);

            Edit;
            FieldByName('IsSync').AsBoolean := true;
            Post;
          except
            on E : Exception do
            begin
              raise Exception.Create(E.Message);
              exit;
            end;
          end;
        end;
      finally
        Close;
        Filter := '';
        Filtered := false;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

{ синхронизация с центральной БД }
procedure TSyncThread.Execute;
var
  Res : string;
  TaskCount: integer;
begin
  Res := '';

  FAllProgress := -1;
  FAllMax := 0;

  if LoadData then
    FAllMax := FAllMax + 17;  // Количесто операций при загрузке данных из центра

  if UploadData then
    FAllMax := FAllMax + 8;  // Количесто операций при сохранении данных в центр

  Synchronize(procedure
              begin
                frmMain.pProgress.Visible := true;
                frmMain.vsbMain.Enabled := false;
              end);

  ProgressThread := TProgressThread.Create(true);
  try
    ProgressThread.FreeOnTerminate := true;
    ProgressThread.Start;

    { получение данных из центра }
    if LoadData then
    begin
      Synchronize(GetSyncDates);

      DM.conMain.TxOptions.AutoCommit := false;
      DM.conMain.StartTransaction;
      try
        SetNewProgressTask('Загрузка констант');
        Synchronize(GetConfigurationInfo);

        SetNewProgressTask('Загрузка справочника ТТ');
        GetDictionaries('Partner');

        SetNewProgressTask('Загрузка справочника юридических лиц');
        GetDictionaries('Juridical');

        SetNewProgressTask('Загрузка справочника маршрутов');
        GetDictionaries('Route');

        SetNewProgressTask('Загрузка справочника договоров');
        GetDictionaries('Contract');

        SetNewProgressTask('Загрузка справочника групп товаров');
        GetDictionaries('GoodsGroup');

        SetNewProgressTask('Загрузка справочника товаров');
        GetDictionaries('Goods');

        SetNewProgressTask('Загрузка справочника видов товаров');
        GetDictionaries('GoodsKind');

        SetNewProgressTask('Загрузка справочника шаблонов товаров');
        GetDictionaries('GoodsByGoodsKind');

        SetNewProgressTask('Загрузка шаблонов товаров по покупателям');
        GetDictionaries('GoodsListSale');

        SetNewProgressTask('Загрузка справочника единиц измерения');
        GetDictionaries('Measure');

        SetNewProgressTask('Загрузка справочника прайс-листов');
        GetDictionaries('PriceList');

        SetNewProgressTask('Загрузка справочника товаров прайс-листов');
        GetDictionaries('PriceListItems');

        SetNewProgressTask('Загрузка справочника акций');
        GetDictionaries('PromoMain');

        SetNewProgressTask('Загрузка справочника акций ТТ');
        GetDictionaries('PromoPartner');

        SetNewProgressTask('Загрузка справочника акционных товаров');
        GetDictionaries('PromoGoods');

        SetNewProgressTask('Загрузка заданий');
        GetDictionaries('MovementTask');
        GetDictionaries('MovementItemTask');

        DM.conMain.Commit;
        DM.conMain.TxOptions.AutoCommit := true;
      except
        on E : Exception do
        begin
          DM.conMain.Rollback;
          DM.conMain.TxOptions.AutoCommit := true;
          Res := E.Message;
          exit;
        end;
      end;
    end;

    { загрузка данных в центр }
    if UploadData then
    begin
      try
        SetNewProgressTask('Сохранение остатков');
        UploadStoreReal;

        SetNewProgressTask('Сохранение заявок');
        UploadOrderExternal;

        SetNewProgressTask('Сохранение возвратов');
        UploadReturnIn;

        SetNewProgressTask('Сохранение заданий');
        UploadTasks;

        SetNewProgressTask('Сохранение новых ТТ');
        UploadNewPartners;

        SetNewProgressTask('Сохранение координат ТТ');
        UploadPartnerGPS;

        SetNewProgressTask('Сохранение маршрута');
        UploadRouteMember;

        SetNewProgressTask('Сохранение фотографий');
        UploadPhotos;

        DM.tblObject_Const.Edit;
        DM.tblObject_ConstSyncDateOut.AsDateTime := Date();
        DM.tblObject_Const.Post;
      except
        on E : Exception do
        begin
          Res := E.Message;
        end;
      end;
    end;
  finally
    ProgressThread.Terminate;

    if Res = '' then
    begin
      SetNewProgressTask('Синхронизация завершена');
      sleep(1000);

      Synchronize(procedure
                  begin
                    frmMain.pProgress.Visible := false;
                    frmMain.vsbMain.Enabled := true;

                    if LoadData then
                    begin
                      TaskCount := DM.LoadTasks(amOpen, false);
                      if TaskCount > 0 then
                        frmMain.lTasks.Text := 'Задания (' + IntToStr(TaskCount) + ')'
                      else
                        frmMain.lTasks.Text := 'Задания';
                    end;
                    DM.CheckUpdate;
                  end);
    end
    else
    begin
      Synchronize(procedure
                  begin
                    frmMain.pProgress.Visible := false;
                    frmMain.vsbMain.Enabled := true;
                    ShowMessage('Ошибка синхронизации (' + Res + ')');
                  end);
    end;
  end;
end;

{ TWaitThread }

procedure TWaitThread.SetTaskName(AName : string);
begin
  Synchronize(procedure
              begin
                frmMain.lProgressName.Text := AName;
              end);
end;

{ получения данных для акта сверки }
function TWaitThread.LoadJuridicalCollation: string;
var
  GetStoredProc : TdsdStoredProc;
  StartRemains, EndRemains, TotalDebit, TotalKredit: Currency;
begin
  Result := '';

  DM.cdsJuridicalCollation.DisableControls;
  StartRemains := 0;
  EndRemains := 0;
  TotalDebit := 0;
  TotalKredit := 0;

  GetStoredProc := TdsdStoredProc.Create(nil);
  try
    GetStoredProc.StoredProcName := 'gpReport_JuridicalCollation';
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);

    GetStoredProc.Params.AddParam('inStartDate', ftDateTime, ptInput, DateStart);
    GetStoredProc.Params.AddParam('inEndDate', ftDateTime, ptInput, DateEnd);
    GetStoredProc.Params.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
    GetStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, PartnerId);
    GetStoredProc.Params.AddParam('inContractId', ftInteger, ptInput, ContractId);
    GetStoredProc.Params.AddParam('inAccountId', ftInteger, ptInput, 0);
    GetStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
    GetStoredProc.Params.AddParam('inInfoMoneyId', ftInteger, ptInput, 0);
    GetStoredProc.Params.AddParam('inCurrencyId', ftInteger, ptInput, 0);
    GetStoredProc.Params.AddParam('inMovementId_Partion', ftInteger, ptInput, 0);

    try
      GetStoredProc.Execute(false, false, true);

      with GetStoredProc.DataSet do
      begin
        First;

        while not Eof do
        begin
          StartRemains := StartRemains + FieldByName('StartRemains').AsFloat;
          EndRemains := StartRemains + FieldByName('EndRemains').AsFloat;

          if FieldByName('InvNumber').AsString <> '' then
          begin
            DM.cdsJuridicalCollation.Append;

            DM.cdsJuridicalCollationDocNum.AsString := FieldByName('InvNumber').AsString;
            DM.cdsJuridicalCollationDocType.AsString := FieldByName('ItemName').AsString;
            DM.cdsJuridicalCollationDocDate.AsDateTime := FieldByName('OperDate').AsDateTime;
            DM.cdsJuridicalCollationPaidKind.AsString := FieldByName('PaidKindName').AsString;
            DM.cdsJuridicalCollationFromName.AsString := FieldByName('FromName').AsString;
            DM.cdsJuridicalCollationToName.AsString := FieldByName('ToName').AsString;

            if FieldByName('Debet').AsFloat <> 0 then
            begin
              DM.cdsJuridicalCollationDebet.AsString := FormatFloat(',0.##', FieldByName('Debet').AsFloat);
              DM.cdsJuridicalCollationFromToName.AsString := 'От кого: ' + DM.cdsJuridicalCollationFromName.AsString;
            end
            else
              DM.cdsJuridicalCollationDebet.AsString := '';
            if FieldByName('Kredit').AsFloat <> 0 then
            begin
              DM.cdsJuridicalCollationKredit.AsString := FormatFloat(',0.##', FieldByName('Kredit').AsFloat);
              DM.cdsJuridicalCollationFromToName.AsString := 'Кому: ' + DM.cdsJuridicalCollationToName.AsString;
            end
            else
              DM.cdsJuridicalCollationKredit.AsString := '';

            DM.cdsJuridicalCollationDocNumDate.AsString := 'Документ №' + DM.cdsJuridicalCollationDocNum.AsString +
              ' от ' + FormatDateTime('DD.MM.YYYY', DM.cdsJuridicalCollationDocDate.AsDateTime);
            DM.cdsJuridicalCollationDocTypeShow.AsString := 'Вид: ' + DM.cdsJuridicalCollationDocType.AsString;

            DM.cdsJuridicalCollation.Post;

            TotalDebit := TotalDebit + FieldByName('Debet').AsFloat;
            TotalKredit := TotalKredit + FieldByName('Kredit').AsFloat;
          end;

          Next;
        end;

        DM.cdsJuridicalCollation.First;
      end;

      if DM.cdsJuridicalCollation.RecordCount > 0 then
      begin
        Synchronize(procedure
          begin
            frmMain.lStartRemains.Text := 'Сальдо на начало периода: ' + FormatFloat(',0.00', StartRemains);
            frmMain.lEndRemains.Text := 'Сальдо на конец периода: ' + FormatFloat(',0.00', EndRemains);
            frmMain.lTotalDebit.Text := FormatFloat(',0.00', TotalDebit);
            frmMain.lTotalKredit.Text := FormatFloat(',0.00', TotalKredit);

            frmMain.lwJuridicalCollation.ScrollViewPos := 0;
          end);
      end
      else
        Result := 'По заданым критериям данные не найдены';
    except
      on E : Exception do
      begin
        Result := E.Message;
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
    DM.cdsJuridicalCollation.EnableControls;
  end;
end;

{ получение новой версии программы }
function TWaitThread.UpdateProgram: string;
var
  GetStoredProc : TdsdStoredProc;
  ApplicationName: string;
  FileStream : TMemoryStream;
  FileBytes: TBytes;
  {$IFDEF ANDROID}
  intent: JIntent;
  uri: Jnet_Uri;
  {$ENDIF}
begin
  Result := '';

  ApplicationName := DM.tblObject_ConstMobileAPKFileName.AsString;

  GetStoredProc := TdsdStoredProc.Create(nil);
  FileStream := TMemoryStream.Create;
  try
    GetStoredProc.StoredProcName := 'gpGet_Object_Program';
    GetStoredProc.OutputType := otBlob;
    GetStoredProc.Params.AddParam('inProgramName', ftString, ptInput, ApplicationName);
    try
      FileBytes := ReConvertConvert(GetStoredProc.Execute(false, false, false));
      FileStream.Write(FileBytes, Length(FileBytes));

      if FileStream.Size = 0 then
      begin
        Result := 'Новая версия программы не загружена из базы данных';
        exit;
      end;

      FileStream.Position := 0;
      {$IFDEF ANDROID}
      FileStream.SaveToFile(TPath.Combine(TPath.GetSharedDownloadsPath, ApplicationName));
      {$ELSE}
      FileStream.SaveToFile(ApplicationName);
      {$ENDIF}

    except
      on E : Exception do
      begin
        Result := E.Message;
        exit;
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
    FreeAndNil(FileStream);
  end;

  // Update programm
  {$IFDEF ANDROID}
  try
    Intent := TJIntent.Create;
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);

    uri := TJnet_Uri.JavaClass.fromFile(TJFile.JavaClass.init(StringToJString(TPath.Combine(TPath.GetSharedDownloadsPath, ApplicationName))));
    Intent.setDataAndType(uri, StringToJString('application/vnd.android.package-archive'));
    Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
    TAndroidHelper.Activity.startActivity(Intent);
  except
    on E : Exception do
    begin
      Result := E.Message;
      exit;
    end;
  end;
  {$ENDIF}
end;

procedure TWaitThread.Execute;
var
  Res : string;
begin
  Res := '';

  Synchronize(procedure
              begin
                frmMain.lProgress.Visible := false;
                frmMain.pieAllProgress.Visible := false;
                frmMain.pProgress.Visible := true;
                frmMain.vsbMain.Enabled := false;
              end);

  ProgressThread := TProgressThread.Create(true);
  try
    ProgressThread.FreeOnTerminate := true;
    ProgressThread.Start;

    if TaskName = 'JuridicalCollation' then
    begin
      SetTaskName('Формирование акта сверки');
      Res := LoadJuridicalCollation;
    end
    else
    if TaskName = 'UpdateProgram' then
    begin
      SetTaskName('Получение файла обновления');
      Res := UpdateProgram;
    end
  finally
    ProgressThread.Terminate;

    Synchronize(procedure
                begin
                  frmMain.pProgress.Visible := false;
                  frmMain.pieAllProgress.Visible := true;
                  frmMain.lProgress.Visible := true;
                  frmMain.vsbMain.Enabled := true;
                end);

    if Res <> '' then
    begin
      Synchronize(procedure
                  begin
                    ShowMessage(Res);
                  end);
    end;
  end;
end;

{ TStructure }

procedure TStructure.AddTable(ATable: TFDTable);
begin
  if not FDataSets.Contains(ATable) then
  begin
    MakeIndex(ATable);
    MakeDopIndex(ATable);
    FDataSets.Add(ATable);
  end;
end;

constructor TStructure.Create;
begin
  inherited Create;
  FDataSets := TDataSets.Create(False);
  FIndexes := TStringList.Create;
end;

destructor TStructure.Destroy;
begin
  FreeAndNil(FIndexes);
  freeAndNil(FDataSets);
  inherited;
end;

function TStructure.GetDataSet(const ATableName: String): TFDTable;
var
  T: TFDTable;
begin
  if Assigned(FLastDataSet) AND SameText(FLastDataSet.TableName, ATableName)
  then
    Exit(FLastDataSet);

  for T in DataSets do
    if SameText(T.TableName, ATableName) then
    begin
      FLastDataSet := T;
      Exit(FLastDataSet);
    end;
  result := nil;
end;

function TStructure.GetIndex(const AIndex: integer): string;
begin
  if (AIndex >=0) and (AIndex < FIndexes.Count)  then
    Result := FIndexes[AIndex]
  else
    Result := '';
end;

function TStructure.GetIndexCount: integer;
begin
  Result := FIndexes.Count;
end;

procedure TStructure.OpenDS(ATable: TFDTable);
begin
  if ATable.Active then
    Exit;
  ATable.IndexName := '';
  ATable.Open;
  MakeIndex(ATable);
end;

procedure TStructure.MakeIndex(ATable: TFDTable);
var
  IndexName: String;
begin
  if (ATable.IndexDefs.Count = 0) then
  Begin
    IndexName := 'PK_' + ATable.TableName;

    if (SameText(ATable.TableName, 'Object_Partner')) or (SameText(ATable.TableName, 'Object_Juridical') ) then
      FIndexes.Add('CREATE UNIQUE INDEX IF NOT EXISTS `' + IndexName + '` ON `' + ATable.TableName + '` (`Id`,`ContractId`)')
    else
    if SameText(ATable.Fields[0].FieldName, 'Id') and (ATable.Fields[0].DataType <> ftAutoInc) then
      FIndexes.Add('CREATE UNIQUE INDEX IF NOT EXISTS `' + IndexName + '` ON `' + ATable.TableName + '` (`Id`)');
  End;
end;

procedure TStructure.MakeDopIndex(ATable: TFDTable);
begin
  if SameText(ATable.TableName, 'Object_GoodsListSale') then
  begin
    FIndexes.Add('CREATE INDEX IF NOT EXISTS `idx_GoodsListSale_GoodsId` ON `' + ATable.TableName + '` (`GoodsId`)');
    FIndexes.Add('CREATE INDEX IF NOT EXISTS `idx_GoodsListSale_GoodsKindId` ON `' + ATable.TableName + '` (`GoodsKindId`)');
    FIndexes.Add('CREATE INDEX IF NOT EXISTS `idx_GoodsListSale_PartnerId` ON `' + ATable.TableName + '` (`PartnerId`)');
  end


  {if SameText(ATable.TableName, 'Words_Table') then
  begin
    IndexName := 'idx_Words_Table_TextWord';
    ATable.IndexDefs.Add(IndexName, 'TextWord', [ixUnique]);
    with ATable.Indexes.Add do
    begin
      Name := IndexName;
      Fields := 'TextWord';
    end;
  end
  else if SameText(ATable.TableName, 'Doc_Table') then
  begin
    IndexName := 'idx_Doc_Table_DocID';
    ATable.IndexDefs.Add(IndexName, 'DocID', [ixUnique]);
    with ATable.Indexes.Add do
    begin
      Name := IndexName;
      Fields := 'DocID';
    end;
  end; }
End;

procedure TDM.InitStructure;
var
  C: TComponent;
begin
  for C in Self do
    if C is TFDTable then
    begin
      Structure.AddTable((C as TFDTable));
    end;
end;

function TDM.Connect: Boolean;
begin
  if conMain.Connected then
    Exit(True);

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  conMain.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DataBaseFileName);
  {$ELSE}
  conMain.Params.Values['Database'] := DataBaseFileName;
  {$ENDIF}

  try
    conMain.Connected := True;
  except
    ON E: Exception DO
    begin
      if not ConnectWithOutDB or not CreateDataBase then
        Exit(False);
    end;
  end;
  if not conMain.Connected then
    Exit(False);

  if not CheckStructure then
  begin
    conMain.Connected := False;
    Exit(False);
  end
  else
    CreateIndexes;


  result := conMain.Connected;
end;

function TDM.ConnectWithOutDB: Boolean;
begin
  FDataBase := conMain.Params.Database;
  conMain.Params.Database := '';
  try
    conMain.Connected := True;
  except
    ON E: Exception DO
    Begin
      //WriteLogE(E.Message);
      Exit(False);
    End;
  end;
  result := True;
end;

{ проверка структуры БД }
function TDM.CheckStructure: Boolean;
var
  T: TFDTable;
  F: TField;
  ChangeStructure: Boolean;
  TempTable: TFDTable;
  J: Integer;

  DestDataType: TFDDataType;
  DestSize: LongWord;
  DestPrec, DestScale: Integer;
  DestAttrs: TFDDataAttributes;

  TempTableName: string;
  InsertSQL: string;
  Error: boolean;
begin
  // Check Tables
  qryMeta.Active := False;
  qryMeta.MetaInfoKind := mkTables;
  try
    qryMeta.Active := True;
  except
    ON E: Exception Do
    Begin
      //WriteLogE(E.Message);
      Exit(False);
    End;
  end;
  for T in Structure.DataSets do
  begin
    if not qryMeta.Locate('TABLE_NAME', T.TableName, [loCaseInsensitive]) then
    begin
      try
        T.CreateTable(False);
      except
        ON E: Exception DO
        Begin
          //WriteLog(E.Message);
          Exit(False);
        End;
      end;
    end
    else
    begin
      qryMeta2.Active := False;
      qryMeta2.MetaInfoKind := mkTableFields;
      qryMeta2.ObjectName := T.TableName;
      try
        qryMeta2.Active := True;
      except
        ON E: Exception Do
        Begin
          //WriteLogE(E.Message);
          Exit(False);
        End;
      end;
      ChangeStructure := False;
      for F in T.Fields do
      Begin
        if F.FieldKind <> fkData then
          Continue;
        if not qryMeta2.Locate('TABLE_NAME;COLUMN_NAME',
          VarArrayOf([T.TableName, F.FieldName]), [loCaseInsensitive]) then
        Begin
          ChangeStructure := True;
          break;
        End
        else
        Begin
          TFDFormatOptions.FieldDef2ColumnDef(F, DestDataType, DestSize,
            DestPrec, DestScale, DestAttrs);
          if (Integer(DestDataType) <> qryMeta2.FieldByName('COLUMN_DATATYPE')
            .AsInteger) or
            (Integer(DestSize) <> qryMeta2.FieldByName('COLUMN_LENGTH')
            .AsInteger) then
          Begin
            ChangeStructure := True;
            break;
          End;
        End;
      End;

      if not ChangeStructure then
      begin
        qryMeta2.First;
        while not qryMeta2.Eof do
        Begin
          if (T.FindField(qryMeta2.FieldByName('COLUMN_NAME').AsString) = nil)
            or (T.FindField(qryMeta2.FieldByName('COLUMN_NAME').AsString)
            .FieldKind <> fkData) then
          begin
            ChangeStructure := True;
            break;
          end;
          qryMeta2.Next;
        End;
      end;
      if ChangeStructure then
      Begin
        TempTable := TFDTable.Create(nil);
        T.DisableConstraints;
        Error := false;
        try
          TempTableName := T.TableName + '_temp_for_recreate';
          conMain.ExecSQL('DROP TABLE IF EXISTS ' + TempTableName);
          conMain.ExecSQL('ALTER TABLE ' + T.TableName + ' RENAME TO ' + TempTableName);

          TempTable.Connection := conMain;
          TempTable.TableName := TempTableName;
          TempTable.Open;
          conMain.StartTransaction;
          try
            T.CreateTable(False);
            Structure.OpenDS(T);
            TempTable.First;

            InsertSQL := '';
            for J := 0 to TempTable.FieldCount - 1 do
              if T.FindField(TempTable.Fields[J].FieldName) <> nil then
                InsertSQL := InsertSQL + TempTable.Fields[J].FieldName + ',';

            delete(InsertSQL, Length(InsertSQL), 1);
            InsertSQL := 'insert into ' + T.TableName + ' (' + InsertSQL + ') select ' + InsertSQL + ' from ' + TempTableName;
            conMain.ExecSQL(InsertSQL);
            conMain.Commit;
          except
            on E: Exception do
            Begin
              //WriteLogE(E.Message);
              Error := true;
              conMain.Rollback;
              Exit(False);
            End;
          end;
        finally
          T.EnableConstraints;
          freeAndNil(TempTable);

          if Error then
          begin
            conMain.ExecSQL('DROP TABLE IF EXISTS ' + T.TableName);
            conMain.ExecSQL('ALTER TABLE ' + TempTableName + ' RENAME TO ' + T.TableName);
          end
          else
            conMain.ExecSQL('DROP TABLE IF EXISTS ' + TempTableName);
        end;
      End;
    end;

  end;

  result := True;
end;

{ создание индексов }
procedure TDM.CreateIndexes;
var
  i : integer;
  qryCreateIndex : TFDQuery;
begin
  if Structure.IndexCount > 0 then
  begin
    qryCreateIndex := TFDQuery.Create(nil);
    try
      qryCreateIndex.Connection := DM.conMain;

      for i := 0 to Structure.IndexCount - 1 do
      begin
        qryCreateIndex.SQL.Text := Structure.Indexes[i];
        qryCreateIndex.ExecSQL;
      end;
    finally
      FreeAndNil(qryCreateIndex);
    end;
  end;
end;

function TDM.CreateDataBase: Boolean;
begin
  if not conMain.Connected then
    Exit(False);
  try
    conMain.ExecSQL('CREATE DATABASE ' + FDataBase);
  except
    on E: Exception do
    begin
      //WriteLogE(E.Message);
      Exit(False);
    end;
  end;
  try
    conMain.ExecSQL('USE ' + FDataBase);
  except
    on E: Exception do
    begin
      //WriteLogE(E.Message);
      Exit(False);
    end;
  end;
  conMain.Params.Database := FDataBase;
  try
    conMain.Connected := True;
  except
    on E: Exception do
    begin
      //WriteLogE(E.Message);
      Exit(False);
    end;
  end;
  result := True;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  InitStructure;
  FConnected := Connect;

  cdsStoreReals.CreateDataSet;
  cdsStoreRealItems.CreateDataSet;
  cdsOrderExternal.CreateDataSet;
  cdsOrderItems.CreateDataSet;
  cdsReturnIn.CreateDataSet;
  cdsReturnInItems.CreateDataSet;
  cdsJuridicalCollation.CreateDataSet;
  cdsTasks.CreateDataSet;
end;

{ вычисление цены для товаров }
procedure TDM.qryGoodsForPriceListCalcFields(DataSet: TDataSet);
var
  PriceWithoutVat, PriceWithVat : string;
begin
  if qryPriceListPriceWithVAT.AsBoolean then
  begin
    PriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('Price').AsFloat * 100 / (100 + qryPriceListVATPercent.AsFloat));
    PriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('Price').AsFloat);
  end
  else
  begin
    PriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('Price').AsFloat);
    PriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('Price').AsFloat * (100 + qryPriceListVATPercent.AsFloat) / 100);
  end;

  DataSet.FieldByName('FullPrice').AsString := 'Цена: ' + PriceWithoutVat +' (с НДС ' + PriceWithVat +
    ') за ' + DataSet.FieldByName('Measure').AsString;

  DataSet.FieldByName('Termin').AsString := 'Цена действительна с ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('StartDate').AsDateTime);
end;

procedure TDM.qryPhotoGroupDocsCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('Name').AsString := 'Фотографии за ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('OperDate').AsDateTime);
  DataSet.FieldByName('GroupName').AsString := DataSet.FieldByName('PartnerName').AsString + chr(13) + chr(10) +
    DataSet.FieldByName('Address').AsString;
end;

procedure TDM.qryPhotoGroupsCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('Name').AsString := 'Фотографии за ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('OperDate').AsDateTime);
end;

{ получение текущей версии программы }
function TDM.GetCurrentVersion: string;
{$IFDEF ANDROID}
var
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  PackageManager := TAndroidHelper.Activity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  Result := JStringToString(PackageInfo.versionName);
  {$ELSE}
  Result := '1.0.0.0';
  {$ENDIF}
end;

{ сравнение версий }
function TDM.CompareVersion(ACurVersion, AServerVersion: string): integer;
var
  ArrValueC, ArrValueS : TArray<string>;
  MajorC, MinorC, ReleaseC, BuildC,
  MajorS, MinorS, ReleaseS, BuildS : integer;
begin
  ArrValueC := ACurVersion.Split(['.']);
  ArrValueS := AServerVersion.Split(['.']);
  //major
  if Length(ArrValueC) > 0 then
    MajorC := StrToIntDef(ArrValueC[0], 0)
  else
    MajorC := 0;
  if Length(ArrValueS) > 0 then
    MajorS := StrToIntDef(ArrValueS[0], 0)
  else
    MajorS := 0;
  //minor
  if Length(ArrValueC) > 1 then
    MinorC := StrToIntDef(ArrValueC[1], 0)
  else
    MinorC := 0;
  if Length(ArrValueS) > 1 then
    MinorS := StrToIntDef(ArrValueS[1], 0)
  else
    MinorS := 0;
  //release
  if Length(ArrValueC) > 2 then
    ReleaseC := StrToIntDef(ArrValueC[2], 0)
  else
    ReleaseC := 0;
  if Length(ArrValueS) > 2 then
    ReleaseS := StrToIntDef(ArrValueS[2], 0)
  else
    ReleaseS := 0;
  //build
  if Length(ArrValueC) > 3 then
    BuildC := StrToIntDef(ArrValueC[3], 0)
  else
    BuildC := 0;
  if Length(ArrValueS) > 3 then
    BuildS := StrToIntDef(ArrValueS[3], 0)
  else
    BuildS := 0;

  if (MajorC = MajorS) and (MinorC = MinorS) and (ReleaseC = ReleaseS) and (BuildC = BuildS) then
    Result := 0
  else
  if (MajorC > MajorS) or ((MajorC = MajorS) and (MinorC > MinorS)) or
     ((MajorC = MajorS) and (MinorC = MinorS) and (ReleaseC > ReleaseS)) or
     ((MajorC = MajorS) and (MinorC = MinorS) and (ReleaseC = ReleaseS) and (BuildC > BuildS))
  then
    Result := -1
  else
    Result := 1;
end;

{ проверка необходимо ли обновление программы }
procedure TDM.CheckUpdate;
begin
  if CompareVersion(GetCurrentVersion, tblObject_ConstMobileVersion.AsString) > 0 then
    TDialogService.MessageDialog('Обнаружена новая версия программы! Обновить?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbYes, 0, UpdateProgram);
end;

{ обновление программы }
procedure TDM.UpdateProgram(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    WaitThread := TWaitThread.Create(true);
    WaitThread.FreeOnTerminate := true;
    WaitThread.TaskName := 'UpdateProgram';
    WaitThread.Start;
  end;
end;

{ синхронизация данных с центральной БД }
procedure TDM.SynchronizeWithMainDatabase(LoadData: boolean = true; UploadData: boolean = true);
begin
  if gc_User.Local or (not LoadData and not UploadData) then
    exit;

  SyncThread := TSyncThread.Create(true);
  SyncThread.FreeOnTerminate := true;
  SyncThread.LoadData := LoadData;
  SyncThread.UploadData := UploadData;
  SyncThread.Start;
end;

{ сохранение остатков }
function TDM.SaveStoreReal(Comment: string; DelItems : string; Complete: boolean;
  var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
  b : TBookmark;
begin
  Result := false;

  NewInvNumber := 1;
  if cdsStoreRealsId.AsInteger = -1 then
  begin
    qryMaxInvNumber := TFDQuery.Create(nil);
    try
      qryMaxInvNumber.Connection := conMain;
      qryMaxInvNumber.Open('select Max(InvNumber) from Movement_StoreReal');
      if qryMaxInvNumber.RecordCount > 0 then
        NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
    finally
      FreeAndNil(qryMaxInvNumber);
    end;
  end;

  conMain.StartTransaction;
  try
    tblMovement_StoreReal.Open;

    if cdsStoreRealsId.AsInteger = -1  then
    begin
      tblMovement_StoreReal.Append;

      CreateGUID(GlobalId);
      tblMovement_StoreRealGUID.AsString := GUIDToString(GlobalId);
      tblMovement_StoreRealInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_StoreRealOperDate.AsDateTime := Date();
      if Complete then
        tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
      else
        tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
      tblMovement_StoreRealPartnerId.AsInteger := cdsStoreRealsPartnerId.AsInteger ;
      tblMovement_StoreRealComment.AsString := Comment;
      tblMovement_StoreRealInsertDate.AsDateTime := Now();
      tblMovement_StoreRealisSync.AsBoolean := false;

      tblMovement_StoreReal.Post;
      {??? Возможно есть лучший способ получения значения Id новой записи }
      tblMovement_StoreReal.Refresh;
      tblMovement_StoreReal.Last;
      {???}
      MovementId := tblMovement_StoreRealId.AsInteger;
    end
    else
    begin
      if tblMovement_StoreReal.Locate('Id', cdsStoreRealsId.AsInteger) then
      begin
        tblMovement_StoreReal.Edit;

        if Complete then
          tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
        else
          tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        tblMovement_StoreRealComment.AsString := Comment;

        tblMovement_StoreReal.Post;

        MovementId := cdsStoreRealsId.AsInteger;
      end
      else
      begin
        ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка';
        exit;
      end;
    end;

    tblMovementItem_StoreReal.Open;

    with cdsStoreRealItems do
    begin
      First;
      while not EOF do
      begin
        if FieldbyName('Id').AsInteger = -1 then // новая запись
        begin
          tblMovementItem_StoreReal.Append;

          tblMovementItem_StoreRealMovementId.AsInteger := MovementId;
          CreateGUID(GlobalId);
          tblMovementItem_StoreRealGUID.AsString := GUIDToString(GlobalId);
          tblMovementItem_StoreRealGoodsId.AsInteger := FieldbyName('GoodsId').AsInteger;
          tblMovementItem_StoreRealGoodsKindId.AsInteger := FieldbyName('KindID').AsInteger;
          tblMovementItem_StoreRealAmount.AsFloat := FieldbyName('Count').AsFloat;

          tblMovementItem_StoreReal.Post;
        end
        else
        begin
          if tblMovementItem_StoreReal.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_StoreReal.Edit;

            tblMovementItem_StoreRealAmount.AsFloat := FieldbyName('Count').AsFloat;

            tblMovementItem_StoreReal.Post;
          end;
        end;

        Next;
      end;
    end;

    if DelItems <> '' then
      conMain.ExecSQL('delete from MovementItem_StoreReal where ID in (' + DelItems + ')');

    conMain.Commit;

    //обновляем данные в локальном хранилище
    cdsStoreReals.DisableControls;
    try
      cdsStoreReals.Edit;

      cdsStoreRealsId.AsInteger := MovementId;

      cdsStoreRealsComment.AsString := Comment;
      if Complete then
      begin
        cdsStoreRealsStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_Complete.AsString;
      end
      else
      begin
        cdsStoreRealsStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;
      end;

      cdsStoreReals.Post;
    finally
      cdsStoreReals.EnableControls;

      b:= cdsStoreReals.Bookmark;
      cdsStoreReals.First;
      cdsStoreReals.GotoBookmark(b);
    end;
    //=========

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

{ создание новых остатков для выбранной ТТ (болванка) }
procedure TDM.NewStoreReal;
begin
  cdsStoreReals.DisableControls;
  try
    cdsStoreReals.First;
    cdsStoreReals.Insert;

    cdsStoreRealsId.AsInteger := -1;
    cdsStoreRealsComment.AsString := '';
    cdsStoreRealsOperDate.AsDateTime := Date();
    cdsStoreRealsName.AsString := 'Остатки на ' + FormatDateTime('DD.MM.YYYY', Date());
    cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;
    cdsStoreRealsStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
    cdsStoreRealsisSync.AsBoolean := false;

    cdsStoreRealsPartnerId.AsInteger := qryPartnerId.AsInteger;
    cdsStoreRealsPartnerName.AsString := qryPartnerName.AsString;
    cdsStoreRealsPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;

    cdsStoreReals.Post;
  finally
    cdsStoreReals.EnableControls;
  end;
end;

{ загрузка остатков из БД для выбранной ТТ}
procedure TDM.LoadStoreReals;
var
  qryStoreReals : TFDQuery;
begin
  cdsStoreReals.Open;
  cdsStoreReals.EmptyDataSet;

  cdsStoreReals.DisableControls;
  qryStoreReals := TFDQuery.Create(nil);
  try
    qryStoreReals.Connection := conMain;
    qryStoreReals.SQL.Text := 'select ID, OPERDATE, COMMENT, ISSYNC, STATUSID' +
      ' from Movement_StoreReal' +
      ' where PARTNERID = ' + qryPartnerId.AsString +
      ' order by OPERDATE desc';

    qryStoreReals.Open;

    qryStoreReals.First;
    while not qryStoreReals.EOF do
    begin
      cdsStoreReals.Append;
      cdsStoreRealsId.AsInteger := qryStoreReals.FieldByName('ID').AsInteger;
      cdsStoreRealsComment.AsString := qryStoreReals.FieldByName('COMMENT').AsString;
      cdsStoreRealsOperDate.AsDateTime := qryStoreReals.FieldByName('OPERDATE').AsDateTime;
      cdsStoreRealsName.AsString := 'Остатки на ' + FormatDateTime('DD.MM.YYYY', qryStoreReals.FieldByName('OPERDATE').AsDateTime);

      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_Complete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_Erased.AsString
      else
        cdsStoreRealsStatus.AsString := 'Неизвестный';

      cdsStoreRealsStatusId.AsInteger := qryStoreReals.FieldByName('STATUSID').AsInteger;
      cdsStoreRealsisSync.AsBoolean := qryStoreReals.FieldByName('ISSYNC').AsBoolean;

      cdsStoreRealsPartnerId.AsInteger := qryPartnerId.AsInteger;
      cdsStoreRealsPartnerName.AsString := qryPartnerName.AsString;
      cdsStoreRealsPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;

      cdsStoreReals.Post;

      qryStoreReals.Next;
    end;

    qryStoreReals.Close;
  finally
    qryStoreReals.Free;
    cdsStoreReals.EnableControls;
    cdsStoreReals.First;
  end;
end;

{ загрузка остатков из БД всех ТТ}
procedure TDM.LoadAllStoreReals(AStartDate, AEndDate: TDate);
var
  qryStoreReals : TFDQuery;
begin
  cdsStoreReals.Open;
  cdsStoreReals.EmptyDataSet;

  cdsStoreReals.DisableControls;
  qryStoreReals := TFDQuery.Create(nil);
  try
    qryStoreReals.Connection := conMain;
    qryStoreReals.SQL.Text := 'select MSR.ID, MSR.OPERDATE, MSR.COMMENT, MSR.ISSYNC, MSR.STATUSID, ' +
      'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS, PL.ID PRICELISTID ' +
      'from Movement_StoreReal MSR ' +
      'JOIN OBJECT_PARTNER P ON P.ID = MSR.PARTNERID ' +
      'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
      'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID, :DefaultPriceList) ' +
      'WHERE DATE(MSR.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
      'GROUP BY MSR.ID, MSR.PARTNERID order by PartnerName, Address asc, OPERDATE desc';
    qryStoreReals.ParamByName('STARTDATE').AsDate := AStartDate;
    qryStoreReals.ParamByName('ENDDATE').AsDate := AEndDate;
    qryStoreReals.ParamByName('DefaultPriceList').AsInteger := DM.tblObject_ConstPriceListId_def.AsInteger;

    qryStoreReals.Open;

    qryStoreReals.First;
    while not qryStoreReals.EOF do
    begin
      cdsStoreReals.Append;
      cdsStoreRealsId.AsInteger := qryStoreReals.FieldByName('ID').AsInteger;
      cdsStoreRealsComment.AsString := qryStoreReals.FieldByName('COMMENT').AsString;
      cdsStoreRealsOperDate.AsDateTime := qryStoreReals.FieldByName('OPERDATE').AsDateTime;
      cdsStoreRealsName.AsString := 'Остатки на ' + FormatDateTime('DD.MM.YYYY', qryStoreReals.FieldByName('OPERDATE').AsDateTime);

      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_Complete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsStoreRealsStatus.AsString := tblObject_ConstStatusName_Erased.AsString
      else
        cdsStoreRealsStatus.AsString := 'Неизвестный';

      cdsStoreRealsStatusId.AsInteger := qryStoreReals.FieldByName('STATUSID').AsInteger;
      cdsStoreRealsisSync.AsBoolean := qryStoreReals.FieldByName('ISSYNC').AsBoolean;

      cdsStoreRealsPartnerId.AsInteger := qryStoreReals.FieldByName('PartnerId').AsInteger;
      cdsStoreRealsPartnerName.AsString := qryStoreReals.FieldByName('PartnerName').AsString;
      cdsStoreRealsPriceListId.AsInteger := qryStoreReals.FieldByName('PriceListId').AsInteger;
      cdsStoreRealsAddress.AsString := qryStoreReals.FieldByName('Address').AsString;

      cdsStoreReals.Post;

      qryStoreReals.Next;
    end;

    qryStoreReals.Close;
  finally
    qryStoreReals.Free;
    cdsStoreReals.EnableControls;
    cdsStoreReals.First;
  end;
end;

{ добавление нового товара в перечень товаров для ввода остатков }
procedure TDM.AddedGoodsToStoreReal(AGoods : string);
var
  ArrValue : TArray<string>;
begin
  ArrValue := AGoods.Split([';']);  //Id;GoodsId;GoodsKindID;название товара;вид товара;единица измерения;количество по умолчанию

  cdsStoreRealItems.Append;
  cdsStoreRealItemsId.AsString := ArrValue[0];
  cdsStoreRealItemsGoodsId.AsString := ArrValue[1];       // GoodsId
  cdsStoreRealItemsKindID.AsString := ArrValue[2];        // GoodsKindID
  cdsStoreRealItemsGoodsName.AsString := ArrValue[3];     // название товара
  cdsStoreRealItemsKindName.AsString := ArrValue[4];      // вид товара
  cdsStoreRealItemsMeasure.AsString := ' ' + ArrValue[5]; // единица измерения
  cdsStoreRealItemsCount.AsString := ArrValue[6];         // количество по умолчанию

  cdsStoreRealItems.Post;
end;

{ начитка товаров для ввода остатков из шаблона }
procedure TDM.DefaultStoreRealItems;
var
  qryGoodsListSale : TFDQuery;
begin
  cdsStoreRealItems.Open;
  cdsStoreRealItems.EmptyDataSet;

  cdsStoreRealItems.DisableControls;
  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
      'G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || ' +
      'IFNULL(M.VALUEDATA, ''-'') || '';0'' ' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID ' +
      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'WHERE GLS.PARTNERID = ' + cdsStoreRealsPartnerId.AsString + ' and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToStoreReal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
    cdsStoreRealItems.EnableControls;
    cdsStoreRealItems.First;
  end;
end;

{ начитка товаров для ввода остатков из БД }
procedure TDM.LoadStoreRealItems(AId : integer);
var
  qryGoodsListSale : TFDQuery;
begin
  cdsStoreRealItems.Open;
  cdsStoreRealItems.EmptyDataSet;

  cdsStoreRealItems.DisableControls;
  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ISR.ID || '';'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
      'G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || ' +
      'IFNULL(M.VALUEDATA, ''-'') || '';'' || ISR.AMOUNT ' +
      'from MOVEMENTITEM_STOREREAL ISR ' +
      'JOIN OBJECT_GOODS G ON ISR.GOODSID = G.ID ' +
      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = ISR.GOODSKINDID ' +
      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'WHERE ISR.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';

    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToStoreReal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
    cdsStoreRealItems.EnableControls;
    cdsStoreRealItems.First;
  end;
end;

{ начитка новых товаров по которым можно ввести остатки }
procedure TDM.GenerateStoreRealItemsList;
begin
  qryGoodsItems.SQL.Text := 'select G.ID GoodsID, GK.ID KindID, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, ''-'' PromoPrice, ' +
    'GLK.REMAINS, PI.ORDERPRICE PRICE, M.VALUEDATA MEASURE, ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || G.VALUEDATA || '';'' || ' +
    'IFNULL(GK.VALUEDATA, ''-'') || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';0'' FullInfo, G.VALUEDATA || '';0'' SearchName ' +
    'from OBJECT_GOODS G ' +
    'LEFT JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID ' +
    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
    'WHERE G.ISERASED = 0 order by GoodsName';

  qryGoodsItems.ParamByName('PRICELISTID').AsInteger := cdsStoreRealsPriceListId.AsInteger;
  qryGoodsItems.Open;
end;

{ сохранение заявки на товары в БД }
function TDM.SaveOrderExternal(OperDate: TDate; Comment: string;
  ToralPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
  b : TBookmark;
begin
  Result := false;

  NewInvNumber := 1;
  if cdsOrderExternalId.AsInteger = -1 then
  begin
    qryMaxInvNumber := TFDQuery.Create(nil);
    try
      qryMaxInvNumber.Connection := conMain;
      qryMaxInvNumber.Open('select Max(InvNumber) from Movement_OrderExternal');
      if qryMaxInvNumber.RecordCount > 0 then
        NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
    finally
      FreeAndNil(qryMaxInvNumber);
    end;
  end;

  conMain.StartTransaction;
  try
    tblMovement_OrderExternal.Open;

    if cdsOrderExternalId.AsInteger = -1 then
    begin
      tblMovement_OrderExternal.Append;

      CreateGUID(GlobalId);
      tblMovement_OrderExternalGUID.AsString := GUIDToString(GlobalId);
      tblMovement_OrderExternalInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
      tblMovement_OrderExternalComment.AsString := Comment;
      if Complete then
        tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
      else
        tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
      tblMovement_OrderExternalPartnerId.AsInteger := cdsOrderExternalPartnerId.AsInteger;
      tblMovement_OrderExternalUnitId.AsInteger := tblObject_ConstUnitId.AsInteger;
      tblMovement_OrderExternalPaidKindId.AsInteger := cdsOrderExternalPaidKindId.AsInteger;
      tblMovement_OrderExternalContractId.AsInteger := cdsOrderExternalCONTRACTID.AsInteger;
      tblMovement_OrderExternalPriceListId.AsInteger := cdsOrderExternalPRICELISTID.AsInteger;
      tblMovement_OrderExternalPriceWithVAT.AsBoolean := cdsOrderExternalPriceWithVAT.AsBoolean;
      tblMovement_OrderExternalVATPercent.AsFloat := cdsOrderExternalVATPercent.AsFloat;
      tblMovement_OrderExternalChangePercent.AsFloat := cdsOrderExternalChangePercent.AsFloat;
      tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
      tblMovement_OrderExternalTotalSumm.AsFloat := ToralPrice;
      tblMovement_OrderExternalInsertDate.AsDateTime := Now();
      tblMovement_OrderExternalisSync.AsBoolean := false;

      tblMovement_OrderExternal.Post;
      {??? Возможно есть лучший способ получения значения Id новой записи }
      tblMovement_OrderExternal.Refresh;
      tblMovement_OrderExternal.Last;
      {???}
      MovementId := tblMovement_OrderExternalId.AsInteger;
    end
    else
    begin
      if tblMovement_OrderExternal.Locate('Id', cdsOrderExternalId.AsInteger) then
      begin
        tblMovement_OrderExternal.Edit;

        tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
        tblMovement_OrderExternalComment.AsString := Comment;
        if Complete then
          tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
        else
          tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        tblMovement_OrderExternalUnitId.AsInteger := tblObject_ConstUnitId.AsInteger;
        tblMovement_OrderExternalPriceWithVAT.AsBoolean := cdsOrderExternalPriceWithVAT.AsBoolean;
        tblMovement_OrderExternalVATPercent.AsFloat := cdsOrderExternalVATPercent.AsFloat;
        tblMovement_OrderExternalChangePercent.AsFloat := cdsOrderExternalChangePercent.AsFloat;
        tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
        tblMovement_OrderExternalTotalSumm.AsFloat := ToralPrice;

        tblMovement_OrderExternal.Post;

        MovementId := cdsOrderExternalId.AsInteger;
      end
      else
      begin
        ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка';
        exit;
      end;
    end;

    tblMovementItem_OrderExternal.Open;

    with cdsOrderItems do
    begin
      First;
      while not EOF do
      begin
        if FieldbyName('Id').AsInteger = -1 then // новая запись
        begin
          tblMovementItem_OrderExternal.Append;

          tblMovementItem_OrderExternalMovementId.AsInteger := MovementId;
          CreateGUID(GlobalId);
          tblMovementItem_OrderExternalGUID.AsString := GUIDToString(GlobalId);
          tblMovementItem_OrderExternalGoodsId.AsInteger := FieldbyName('GoodsId').AsInteger;
          tblMovementItem_OrderExternalGoodsKindId.AsInteger := FieldbyName('KindID').AsInteger;
          tblMovementItem_OrderExternalAmount.AsFloat := FieldbyName('Count').AsFloat;
          tblMovementItem_OrderExternalPrice.AsFloat := FieldbyName('Price').AsFloat;
          tblMovementItem_OrderExternalChangePercent.AsFloat := cdsOrderExternalChangePercent.AsFloat;

          tblMovementItem_OrderExternal.Post;
        end
        else
        begin
          if tblMovementItem_OrderExternal.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_OrderExternal.Edit;

            tblMovementItem_OrderExternalChangePercent.AsFloat := cdsOrderExternalChangePercent.AsFloat;
            tblMovementItem_OrderExternalAmount.AsFloat := FieldbyName('Count').AsFloat;
            tblMovementItem_OrderExternalPrice.AsFloat := FieldbyName('Price').AsFloat;

            tblMovementItem_OrderExternal.Post;
          end;
        end;

        Next;
      end;
    end;

    if DelItems <> '' then
      conMain.ExecSQL('delete from MOVEMENTITEM_ORDEREXTERNAL where ID in (' + DelItems + ')');

    conMain.Commit;

    //обновляем данные в локальном хранилище
    cdsOrderExternal.DisableControls;
    try
      cdsOrderExternal.Edit;

      cdsOrderExternalId.AsInteger := MovementId;

      cdsOrderExternalOperDate.AsDateTime := OperDate;
      cdsOrderExternalComment.AsString := Comment;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', ToralPrice);
      cdsOrderExternalWeight.AsString := 'Вес: ' + FormatFloat(',0.00', TotalWeight);
      if Complete then
      begin
        cdsOrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_Complete.AsString;
      end
      else
      begin
        cdsOrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;
      end;

      cdsOrderExternal.Post;
    finally
      cdsOrderExternal.EnableControls;

      b:= cdsOrderExternal.Bookmark;
      cdsOrderExternal.First;
      cdsOrderExternal.GotoBookmark(b);
    end;
    //=========

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

{ создание новой заявки для выбранной ТТ (болванка) }
procedure TDM.NewOrderExternal;
begin
  cdsOrderExternal.DisableControls;
  try
    cdsOrderExternal.First;
    cdsOrderExternal.Insert;

    cdsOrderExternalId.AsInteger := -1;
    cdsOrderExternalOperDate.AsDateTime := Date();
    cdsOrderExternalComment.AsString := '';
    cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', Date());
    cdsOrderExternalPrice.AsString :=  'Стоимость: 0';
    cdsOrderExternalWeight.AsString := 'Вес: 0';
    cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;
    cdsOrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
    cdsOrderExternalisSync.AsBoolean := false;

    cdsOrderExternalPartnerId.AsInteger := qryPartnerId.AsInteger;
    cdsOrderExternalPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
    cdsOrderExternalContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
    cdsOrderExternalPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;
    cdsOrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
    cdsOrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
    cdsOrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
    cdsOrderExternalCalcDayCount.AsFloat := qryPartnerCalcDayCount.AsFloat;
    cdsOrderExternalOrderDayCount.AsFloat := qryPartnerOrderDayCount.AsFloat;
    cdsOrderExternalisOperDateOrder.AsBoolean := qryPartnerisOperDateOrder.AsBoolean;
    cdsOrderExternalAddress.AsString := qryPartnerAddress.AsString;
    cdsOrderExternalPartnerName.AsString := qryPartnerName.AsString;
    cdsOrderExternalContractName.AsString := qryPartnerContractName.AsString;

    cdsOrderExternal.Post;
  finally
    cdsOrderExternal.EnableControls;
  end;
end;

{ начитка заявок на товары из БД }
procedure TDM.LoadOrderExternal;
var
  qryOrderExternal : TFDQuery;
begin
  cdsOrderExternal.Open;
  cdsOrderExternal.EmptyDataSet;

  cdsOrderExternal.DisableControls;
  qryOrderExternal := TFDQuery.Create(nil);
  try
    qryOrderExternal.Connection := conMain;
    qryOrderExternal.SQL.Text := 'select ID, OPERDATE, COMMENT, TOTALCOUNTKG, TOTALSUMM, ISSYNC, STATUSID' +
      ' from MOVEMENT_ORDEREXTERNAL' +
      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
      ' order by OPERDATE desc';

    qryOrderExternal.Open;

    qryOrderExternal.First;
    while not qryOrderExternal.EOF do
    begin
      cdsOrderExternal.Append;
      cdsOrderExternalid.AsInteger := qryOrderExternal.FieldByName('ID').AsInteger;
      cdsOrderExternalOperDate.AsDateTime := qryOrderExternal.FieldByName('OPERDATE').AsDateTime;
      cdsOrderExternalComment.AsString := qryOrderExternal.FieldByName('COMMENT').AsString;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', qryOrderExternal.FieldByName('OPERDATE').AsDateTime);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', qryOrderExternal.FieldByName('TOTALSUMM').AsFloat);
      cdsOrderExternalWeight.AsString := 'Вес: ' + FormatFloat(',0.00', qryOrderExternal.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_Complete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_Erased.AsString
      else
        cdsOrderExternalStatus.AsString := 'Неизвестный';

      cdsOrderExternalStatusId.AsInteger := qryOrderExternal.FieldByName('STATUSID').AsInteger;
      cdsOrderExternalisSync.AsBoolean := qryOrderExternal.FieldByName('ISSYNC').AsBoolean;

      cdsOrderExternalPartnerId.AsInteger := qryPartnerId.AsInteger;
      cdsOrderExternalPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
      cdsOrderExternalContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      cdsOrderExternalPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;
      cdsOrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
      cdsOrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
      cdsOrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
      cdsOrderExternalCalcDayCount.AsFloat := qryPartnerCalcDayCount.AsFloat;
      cdsOrderExternalOrderDayCount.AsFloat := qryPartnerOrderDayCount.AsFloat;
      cdsOrderExternalisOperDateOrder.AsBoolean := qryPartnerisOperDateOrder.AsBoolean;
      cdsOrderExternalAddress.AsString := qryPartnerAddress.AsString;
      cdsOrderExternalPartnerName.AsString := qryPartnerName.AsString;
      cdsOrderExternalContractName.AsString := qryPartnerContractName.AsString;

      cdsOrderExternal.Post;

      qryOrderExternal.Next;
    end;

    qryOrderExternal.Close;
  finally
    qryOrderExternal.Free;
    cdsOrderExternal.EnableControls;
    cdsOrderExternal.First;
  end;
end;

{ загрузка заявок на товары из БД всех ТТ}
procedure TDM.LoadAllOrderExternal(AStartDate, AEndDate: TDate);
var
  qryOrderExternal : TFDQuery;
begin
  cdsOrderExternal.Open;
  cdsOrderExternal.EmptyDataSet;

  cdsOrderExternal.DisableControls;
  qryOrderExternal := TFDQuery.Create(nil);
  try

    qryOrderExternal.Connection := conMain;
    qryOrderExternal.SQL.Text := 'select MOE.ID, MOE.OPERDATE, MOE.COMMENT, MOE.TOTALCOUNTKG, MOE.TOTALSUMM, MOE.ISSYNC, MOE.STATUSID, ' +
      'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS, PL.ID PRICELISTID, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
      'P.CONTRACTID, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, C.PAIDKINDID, C.CHANGEPERCENT, ' +
      'P.CalcDayCount, P.OrderDayCount, P.isOperDateOrder ' +
      'from MOVEMENT_ORDEREXTERNAL MOE ' +
      'JOIN OBJECT_PARTNER P ON P.ID = MOE.PARTNERID AND P.CONTRACTID = MOE.CONTRACTID ' +
      'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
      'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID, :DefaultPriceList) ' +
      'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
      'WHERE DATE(MOE.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
      'GROUP BY MOE.ID, MOE.PARTNERID, MOE.CONTRACTID order by PartnerName, P.Address, P.ContractId asc, MOE.OPERDATE desc';
    qryOrderExternal.ParamByName('STARTDATE').AsDate := AStartDate;
    qryOrderExternal.ParamByName('ENDDATE').AsDate := AEndDate;
    qryOrderExternal.ParamByName('DefaultPriceList').AsInteger := DM.tblObject_ConstPriceListId_def.AsInteger;

    qryOrderExternal.Open;

    qryOrderExternal.First;
    while not qryOrderExternal.EOF do
    begin
      cdsOrderExternal.Append;
      cdsOrderExternalid.AsInteger := qryOrderExternal.FieldByName('ID').AsInteger;
      cdsOrderExternalOperDate.AsDateTime := qryOrderExternal.FieldByName('OPERDATE').AsDateTime;
      cdsOrderExternalComment.AsString := qryOrderExternal.FieldByName('COMMENT').AsString;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', qryOrderExternal.FieldByName('OPERDATE').AsDateTime);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', qryOrderExternal.FieldByName('TOTALSUMM').AsFloat);
      cdsOrderExternalWeight.AsString := 'Вес: ' + FormatFloat(',0.00', qryOrderExternal.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_Complete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_Erased.AsString
      else
        cdsOrderExternalStatus.AsString := 'Неизвестный';

      cdsOrderExternalStatusId.AsInteger := qryOrderExternal.FieldByName('STATUSID').AsInteger;
      cdsOrderExternalisSync.AsBoolean := qryOrderExternal.FieldByName('ISSYNC').AsBoolean;

      cdsOrderExternalPartnerId.AsInteger := qryOrderExternal.FieldByName('PartnerId').AsInteger;
      cdsOrderExternalPaidKindId.AsInteger := qryOrderExternal.FieldByName('PaidKindId').AsInteger;
      cdsOrderExternalContractId.AsInteger := qryOrderExternal.FieldByName('CONTRACTID').AsInteger;
      cdsOrderExternalPriceListId.AsInteger := qryOrderExternal.FieldByName('PRICELISTID').AsInteger;
      cdsOrderExternalPriceWithVAT.AsBoolean := qryOrderExternal.FieldByName('PriceWithVAT').AsBoolean;
      cdsOrderExternalVATPercent.AsFloat := qryOrderExternal.FieldByName('VATPercent').AsFloat;
      cdsOrderExternalChangePercent.AsFloat := qryOrderExternal.FieldByName('ChangePercent').AsFloat;
      cdsOrderExternalCalcDayCount.AsFloat := qryOrderExternal.FieldByName('CalcDayCount').AsFloat;
      cdsOrderExternalOrderDayCount.AsFloat := qryOrderExternal.FieldByName('OrderDayCount').AsFloat;
      cdsOrderExternalisOperDateOrder.AsBoolean := qryOrderExternal.FieldByName('isOperDateOrder').AsBoolean;
      cdsOrderExternalAddress.AsString := qryOrderExternal.FieldByName('Address').AsString;
      cdsOrderExternalPartnerName.AsString := qryOrderExternal.FieldByName('PartnerName').AsString;
      cdsOrderExternalContractName.AsString := qryOrderExternal.FieldByName('ContractName').AsString;

      cdsOrderExternal.Post;

      qryOrderExternal.Next;
    end;

    qryOrderExternal.Close;
  finally
    qryOrderExternal.Free;
    cdsOrderExternal.EnableControls;
    cdsOrderExternal.First;
  end;
end;

{ добавление новых товаров в перечень товаров для заявки }
procedure TDM.AddedGoodsToOrderExternal(AGoods : string);
var
  ArrValue : TArray<string>;
  Recommend : Extended;
begin
  ArrValue := AGoods.Split([';']); //Id;GoodsId;GoodsKindID;название товара;вид товара;рекомендуемое количество;
                                   //остаток товара;цена;единица измерения;вес;цена по акции;учитывать ли скидку при акции;
                                   //количество по умолчанию

  cdsOrderItems.Append;
  cdsOrderItemsId.AsString := ArrValue[0];
  cdsOrderItemsGoodsId.AsString := ArrValue[1];   // GoodsId
  cdsOrderItemsKindID.AsString := ArrValue[2];    // GoodsKindID
  cdsOrderItemsGoodsName.AsString := ArrValue[3];      // название товара
  cdsOrderItemsKindName.AsString := ArrValue[4];  // вид товара

  if (ArrValue[5] = '0') or (cdsOrderExternalCalcDayCount.AsFloat = 0) then // рекомендуемое количество
    cdsOrderItemsRecommend.AsString := '-'
  else
  begin
    if StrToFloatDef(ArrValue[5], 0) - StrToFloatDef(ArrValue[6], 0) <= 0 then
      cdsOrderItemsRecommend.AsString := '0'
    else
    begin
      Recommend := (StrToFloatDef(ArrValue[5], 0) - StrToFloatDef(ArrValue[6], 0)) / cdsOrderExternalCalcDayCount.AsFloat *
        cdsOrderExternalOrderDayCount.AsFloat - StrToFloatDef(ArrValue[6], 0);
      if Recommend <= 0 then
        cdsOrderItemsRecommend.AsString := '0'
      else
        cdsOrderItemsRecommend.AsString := FormatFloat(',0.00', Recommend);
    end;
  end;

  cdsOrderItemsRemains.AsString := ArrValue[6];       // остаток товара
  cdsOrderItemsPrice.AsString := ArrValue[7];         // цена без акции
  cdsOrderItemsMeasure.AsString := ' ' + ArrValue[8]; // единица измерения
  cdsOrderItemsWeight.AsString := ArrValue[9];        // вес

  if ArrValue[10] <> '-1' then                        // цена по акции
  begin
    cdsOrderItemsIsPromo.AsString := 'Акция!';
    cdsOrderItemsPrice.AsString := ArrValue[10];
    if ArrValue[11] = '1' then                        // учитывать ли скидку при акции
      cdsOrderItemsisChangePercent.AsBoolean := true
    else
      cdsOrderItemsisChangePercent.AsBoolean := false;
  end
  else
  begin
    cdsOrderItemsIsPromo.AsString := '';
    cdsOrderItemsisChangePercent.AsBoolean := true;
  end;

  cdsOrderItemsCount.AsString := ArrValue[12];        // количество по умолчанию

  cdsOrderItems.Post;
end;

{ начитка товаров для заявки из шаблона }
procedure TDM.DefaultOrderExternalItems;
var
  qryGoodsListSale : TFDQuery;
  PriceField, PromoPriceField : string;
begin
  cdsOrderItems.Open;
  cdsOrderItems.EmptyDataSet;

  cdsOrderItems.DisableControls;;
  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;

    if cdsOrderExternalisOperDateOrder.AsBoolean then
      PriceField := 'OrderPrice'
    else
      PriceField := 'SalePrice';

    if cdsOrderExternalPriceWithVAT.AsBoolean then
      PromoPriceField := 'PriceWithVAT'
    else
      PromoPriceField := 'PriceWithOutVAT';

    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || G.VALUEDATA || '';'' || ' +
      'IFNULL(GK.VALUEDATA, ''-'') || '';'' || GLS.AMOUNTCALC || '';'' || IFNULL(SRI.AMOUNT, 0) || '';'' || ' +
      'IFNULL(PI.' + PriceField + ', 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || ' +
      'IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';0''' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID ' +
      'LEFT JOIN MOVEMENT_STOREREAL SR ON SR.PARTNERID = :PARTNERID ' +
      'AND DATE(SR.OPERDATE) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date())) + ' AND SR.STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
      'LEFT JOIN MOVEMENTITEM_STOREREAL SRI ON SRI.GOODSID = G.ID AND SRI.GOODSKINDID = GK.ID AND SRI.MOVEMENTID = SR.ID ' +
      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
      'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
      'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
      'WHERE GLS.PARTNERID = :PARTNERID and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.ParamByName('PARTNERID').AsInteger := cdsOrderExternalPartnerId.AsInteger;
    qryGoodsListSale.ParamByName('CONTRACTID').AsInteger := cdsOrderExternalCONTRACTID.AsInteger;
    qryGoodsListSale.ParamByName('PRICELISTID').AsInteger := cdsOrderExternalPRICELISTID.AsInteger;
    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToOrderExternal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
    cdsOrderItems.EnableControls;
    cdsOrderItems.First;
  end;
end;

{ начитка товаров для заявки из БД }
procedure TDM.LoadOrderExtrenalItems(AId : integer);
var
  qryGoodsListOrder : TFDQuery;
  PriceField, PromoPriceField : string;
begin
  cdsOrderItems.Open;
  cdsOrderItems.EmptyDataSet;

  cdsOrderItems.DisableControls;
  qryGoodsListOrder := TFDQuery.Create(nil);
  try
    qryGoodsListOrder.Connection := conMain;

    if cdsOrderExternalisOperDateOrder.AsBoolean then
      PriceField := 'OrderPrice'
    else
      PriceField := 'SalePrice';

    if cdsOrderExternalPriceWithVAT.AsBoolean then
      PromoPriceField := 'PriceWithVAT'
    else
      PromoPriceField := 'PriceWithOutVAT';

    qryGoodsListOrder.SQL.Text := 'select IEO.ID || '';'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
      'G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || 0 || '';'' || IFNULL(SRI.AMOUNT, 0) || '';'' || ' +
      'IFNULL(PI.' + PriceField + ', 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || ' +
      'IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';'' || IEO.AMOUNT ' +
      'from MOVEMENTITEM_ORDEREXTERNAL IEO ' +
      'JOIN OBJECT_GOODS G ON IEO.GOODSID = G.ID ' +
      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = IEO.GOODSKINDID ' +
      'LEFT JOIN MOVEMENT_STOREREAL SR ON SR.PARTNERID = :PARTNERID' +
      ' AND DATE(SR.OPERDATE) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date())) + ' AND SR.STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
      'LEFT JOIN MOVEMENTITEM_STOREREAL SRI ON SRI.GOODSID = G.ID AND SRI.GOODSKINDID = GK.ID AND SRI.MOVEMENTID = SR.ID ' +
      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
      'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
      'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
      'WHERE IEO.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';


    qryGoodsListOrder.ParamByName('PARTNERID').AsInteger := cdsOrderExternalPartnerId.AsInteger;
    qryGoodsListOrder.ParamByName('CONTRACTID').AsInteger := cdsOrderExternalCONTRACTID.AsInteger;
    qryGoodsListOrder.ParamByName('PRICELISTID').AsInteger := cdsOrderExternalPRICELISTID.AsInteger;
    qryGoodsListOrder.Open;

    qryGoodsListOrder.First;
    while not qryGoodsListOrder.EOF do
    begin
      AddedGoodsToOrderExternal(qryGoodsListOrder.Fields[0].AsString);

      qryGoodsListOrder.Next;
    end;

    qryGoodsListOrder.Close;
  finally
    qryGoodsListOrder.Free;
    cdsOrderItems.EnableControls;
    cdsOrderItems.First;
  end;
end;

{ начитка новых товаров, которые можно внести в заявку }
procedure TDM.GenerateOrderExtrenalItemsList;
var
  PriceField, PromoPriceField : string;
begin
  if cdsOrderExternalisOperDateOrder.AsBoolean then
    PriceField := 'OrderPrice'
  else
    PriceField := 'SalePrice';

  if cdsOrderExternalPriceWithVAT.AsBoolean then
    PromoPriceField := 'PriceWithVAT'
  else
    PromoPriceField := 'PriceWithOutVAT';

  qryGoodsItems.SQL.Text := 'select G.ID GoodsID, GK.ID KindID, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, IFNULL(' + PromoPriceField + ' || '''', ''-'') PromoPrice, ' +
    'GLK.REMAINS, PI.' + PriceField + ' PRICE, M.VALUEDATA MEASURE, ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || G.VALUEDATA || '';'' || ' +
    'IFNULL(GK.VALUEDATA, ''-'') || '';'' || 0 || '';'' || 0 || '';'' || IFNULL(PI.' + PriceField + ', ''0'') || '';'' || ' +
    'IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';0'' FullInfo, ' +
    'G.VALUEDATA || CASE WHEN ' + PromoPriceField + ' IS NULL THEN '';0'' ELSE '';1'' END SearchName ' +
    'from OBJECT_GOODS G ' +
    'LEFT JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID ' +
    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
    'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
    'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
    'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
    'WHERE G.ISERASED = 0 order by GoodsName';

  qryGoodsItems.ParamByName('PARTNERID').AsInteger := cdsOrderExternalPartnerId.AsInteger;
  qryGoodsItems.ParamByName('CONTRACTID').AsInteger := cdsOrderExternalCONTRACTID.AsInteger;
  qryGoodsItems.ParamByName('PRICELISTID').AsInteger := cdsOrderExternalPRICELISTID.AsInteger;
  qryGoodsItems.Open;
end;

{ сохранение возвратов в БД }
function TDM.SaveReturnIn(OperDate: TDate; Comment : string;
  ToralPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
  b : TBookmark;
begin
  Result := false;

  NewInvNumber := 1;
  if cdsReturnInId.AsInteger = -1 then
  begin
    qryMaxInvNumber := TFDQuery.Create(nil);
    try
      qryMaxInvNumber.Connection := conMain;
      qryMaxInvNumber.Open('select Max(InvNumber) from Movement_ReturnIn');
      if qryMaxInvNumber.RecordCount > 0 then
        NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
    finally
      FreeAndNil(qryMaxInvNumber);
    end;
  end;

  conMain.StartTransaction;
  try
    tblMovement_ReturnIn.Open;

    if cdsReturnInId.AsInteger = -1 then
    begin
      tblMovement_ReturnIn.Append;

      CreateGUID(GlobalId);
      tblMovement_ReturnInGUID.AsString := GUIDToString(GlobalId);
      tblMovement_ReturnInInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_ReturnInOperDate.AsDateTime := OperDate;
      tblMovement_ReturnInComment.AsString := Comment;
      if Complete then
        tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
      else
        tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
      tblMovement_ReturnInPartnerId.AsInteger := cdsReturnInPartnerId.AsInteger;
      tblMovement_ReturnInUnitId.AsInteger := tblObject_ConstUnitId_ret.AsInteger;
      tblMovement_ReturnInPaidKindId.AsInteger := cdsReturnInPaidKindId.AsInteger;
      tblMovement_ReturnInContractId.AsInteger := cdsReturnInCONTRACTID.AsInteger;
      tblMovement_ReturnInPriceWithVAT.AsBoolean := cdsReturnInPriceWithVAT.AsBoolean;
      tblMovement_ReturnInVATPercent.AsFloat := cdsReturnInVATPercent.AsFloat;
      tblMovement_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
      tblMovement_ReturnInTotalCountKg.AsFloat := TotalWeight;
      tblMovement_ReturnInTotalSummPVAT.AsFloat := ToralPrice;
      tblMovement_ReturnInInsertDate.AsDateTime := Now();
      tblMovement_ReturnInisSync.AsBoolean := false;

      tblMovement_ReturnIn.Post;
      {??? Возможно есть лучший способ получения значения Id новой записи }
      tblMovement_ReturnIn.Refresh;
      tblMovement_ReturnIn.Last;
      {???}
      MovementId := tblMovement_ReturnInId.AsInteger;
    end
    else
    begin
      if tblMovement_ReturnIn.Locate('Id', cdsReturnInId.AsInteger) then
      begin
        tblMovement_ReturnIn.Edit;

        tblMovement_ReturnInOperDate.AsDateTime := OperDate;
        tblMovement_ReturnInComment.AsString := Comment;
        if Complete then
          tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
        else
          tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        tblMovement_ReturnInUnitId.AsInteger := tblObject_ConstUnitId_ret.AsInteger;
        tblMovement_ReturnInPriceWithVAT.AsBoolean := cdsReturnInPriceWithVAT.AsBoolean;
        tblMovement_ReturnInVATPercent.AsFloat := cdsReturnInVATPercent.AsFloat;
        tblMovement_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
        tblMovement_ReturnInTotalCountKg.AsFloat := TotalWeight;
        tblMovement_ReturnInTotalSummPVAT.AsFloat := ToralPrice;

        tblMovement_ReturnIn.Post;

        MovementId := cdsReturnInId.AsInteger;
      end
      else
      begin
        ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка на возврат';
        exit;
      end;
    end;

    tblMovementItem_ReturnIn.Open;

    with cdsReturnInItems do
    begin
      First;
      while not EOF do
      begin
        if FieldbyName('Id').AsInteger = -1 then // новая запись
        begin
          tblMovementItem_ReturnIn.Append;

          tblMovementItem_ReturnInMovementId.AsInteger := MovementId;
          CreateGUID(GlobalId);
          tblMovementItem_ReturnInGUID.AsString := GUIDToString(GlobalId);
          tblMovementItem_ReturnInGoodsId.AsInteger := FieldbyName('GoodsId').AsInteger;
          tblMovementItem_ReturnInGoodsKindId.AsInteger := FieldbyName('KindID').AsInteger;
          tblMovementItem_ReturnInAmount.AsFloat := FieldbyName('Count').AsFloat;
          tblMovementItem_ReturnInPrice.AsFloat := FieldbyName('Price').AsFloat;
          tblMovementItem_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;

          tblMovementItem_ReturnIn.Post;
        end
        else
        begin
          if tblMovementItem_ReturnIn.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_ReturnIn.Edit;

            tblMovementItem_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
            tblMovementItem_ReturnInAmount.AsFloat := FieldbyName('Count').AsFloat;
            tblMovementItem_ReturnInPrice.AsFloat := FieldbyName('Price').AsFloat;

            tblMovementItem_ReturnIn.Post;
          end;
        end;

        Next;
      end;
    end;

    if DelItems <> '' then
      conMain.ExecSQL('delete from MOVEMENTITEM_RETURNIN where ID in (' + DelItems + ')');

    conMain.Commit;

    //обновляем данные в локальном хранилище
    cdsReturnIn.DisableControls;
    try
      cdsReturnIn.Edit;

      cdsReturnInId.AsInteger := MovementId;

      cdsReturnInOperDate.AsDateTime := OperDate;
      cdsReturnInComment.AsString := Comment;
      cdsReturnInName.AsString := 'Возврат от ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsReturnInPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', ToralPrice);
      cdsReturnInWeight.AsString := 'Вес: ' + FormatFloat(',0.00', TotalWeight);

      if Complete then
      begin
        cdsReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_Complete.AsString;
      end
      else
      begin
        cdsReturnInStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;
      end;

      cdsReturnIn.Post;
    finally
      cdsReturnIn.EnableControls;

      b:= cdsReturnIn.Bookmark;
      cdsReturnIn.First;
      cdsReturnIn.GotoBookmark(b);
    end;
    //=========

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

{ создание нового возврата для выбранной ТТ (болванка) }
procedure TDM.NewReturnIn;
begin
  cdsReturnIn.DisableControls;
  try
    cdsReturnIn.First;
    cdsReturnIn.Insert;

    cdsReturnInId.AsInteger := -1;
    cdsReturnInOperDate.AsDateTime := Date();
    cdsReturnInComment.AsString := '';
    cdsReturnInName.AsString := 'Возврат от ' + FormatDateTime('DD.MM.YYYY', Date());
    cdsReturnInPrice.AsString :=  'Стоимость: 0';
    cdsReturnInWeight.AsString := 'Вес: 0';
    cdsReturnInStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;

    cdsReturnInStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
    cdsReturnInisSync.AsBoolean := false;

    cdsReturnInPartnerId.AsInteger := qryPartnerId.AsInteger;
    cdsReturnInPartnerName.AsString := qryPartnerName.AsString;
    cdsReturnInAddress.AsString := qryPartnerAddress.AsString;
    cdsReturnInContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
    cdsReturnInContractName.AsString := qryPartnerContractName.AsString;
    cdsReturnInPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
    cdsReturnInPriceListId.AsInteger := qryPartnerPRICELISTID_RET.AsInteger;
    cdsReturnInPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT_RET.AsBoolean;
    cdsReturnInVATPercent.AsFloat := qryPartnerVATPercent_RET.AsFloat;
    cdsReturnInChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;

    cdsReturnIn.Post;
  finally
    cdsReturnIn.EnableControls;
  end;
end;

{ начитка возвратов из БД }
procedure TDM.LoadReturnIn;
var
  qryReturnIn : TFDQuery;
begin
  cdsReturnIn.Open;
  cdsReturnIn.EmptyDataSet;

  cdsReturnIn.DisableControls;
  qryReturnIn := TFDQuery.Create(nil);
  try
    qryReturnIn.Connection := conMain;
    qryReturnIn.SQL.Text := 'select ID, OPERDATE, TOTALCOUNTKG, TOTALSUMMPVAT, ISSYNC, STATUSID, COMMENT' +
      ' from MOVEMENT_RETURNIN' +
      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
      ' order by OPERDATE desc';

    qryReturnIn.Open;

    qryReturnIn.First;
    while not qryReturnIn.EOF do
    begin
      cdsReturnIn.Append;
      cdsReturnInId.AsInteger := qryReturnIn.FieldByName('ID').AsInteger;
      cdsReturnInOperDate.AsDateTime := qryReturnIn.FieldByName('OPERDATE').AsDateTime;
      cdsReturnInComment.AsString := qryReturnIn.FieldByName('COMMENT').AsString;
      cdsReturnInName.AsString := 'Возврат от ' + FormatDateTime('DD.MM.YYYY', qryReturnIn.FieldByName('OPERDATE').AsDateTime);
      cdsReturnInPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', qryReturnIn.FieldByName('TOTALSUMMPVAT').AsFloat);
      cdsReturnInWeight.AsString := 'Вес: ' + FormatFloat(',0.00', qryReturnIn.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_Complete.AsString
      else
      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_Erased.AsString
      else
        cdsReturnInStatus.AsString := 'Неизвестный';

      cdsReturnInStatusId.AsInteger := qryReturnIn.FieldByName('STATUSID').AsInteger;
      cdsReturnInisSync.AsBoolean := qryReturnIn.FieldByName('ISSYNC').AsBoolean;

      cdsReturnInPartnerId.AsInteger := qryPartnerId.AsInteger;
      cdsReturnInPartnerName.AsString := qryPartnerName.AsString;
      cdsReturnInAddress.AsString := qryPartnerAddress.AsString;
      cdsReturnInContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      cdsReturnInContractName.AsString := qryPartnerContractName.AsString;
      cdsReturnInPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
      cdsReturnInPriceListId.AsInteger := qryPartnerPRICELISTID_RET.AsInteger;
      cdsReturnInPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT_RET.AsBoolean;
      cdsReturnInVATPercent.AsFloat := qryPartnerVATPercent_RET.AsFloat;
      cdsReturnInChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;

      cdsReturnIn.Post;

      qryReturnIn.Next;
    end;

    qryReturnIn.Close;
  finally
    qryReturnIn.Free;
    cdsReturnIn.EnableControls;
    cdsReturnIn.First;
  end;
end;

{ начитка возвратов из БД всех ТТ }
procedure TDM.LoadAllReturnIn(AStartDate, AEndDate: TDate);
var
  qryReturnIn : TFDQuery;
begin
  cdsReturnIn.Open;
  cdsReturnIn.EmptyDataSet;

  cdsReturnIn.DisableControls;
  qryReturnIn := TFDQuery.Create(nil);
  try
    qryReturnIn.Connection := conMain;
    qryReturnIn.SQL.Text := 'select MRI.ID, MRI.OPERDATE, MRI.COMMENT, MRI.TOTALCOUNTKG, MRI.TOTALSUMMPVAT, MRI.ISSYNC, MRI.STATUSID, ' +
      'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS, PL.ID PRICELISTID, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
      'P.CONTRACTID, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, C.PAIDKINDID, C.CHANGEPERCENT ' +
      'from MOVEMENT_RETURNIN MRI ' +
      'JOIN OBJECT_PARTNER P ON P.ID = MRI.PARTNERID AND P.CONTRACTID = MRI.CONTRACTID ' +
      'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
      'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID_RET, :DefaultPriceList) ' +
      'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
      'WHERE DATE(MRI.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
      'GROUP BY MRI.ID, MRI.PARTNERID, MRI.CONTRACTID order by PartnerName, P.Address, P.ContractId asc, MRI.OPERDATE desc';
    qryReturnIn.ParamByName('STARTDATE').AsDate := AStartDate;
    qryReturnIn.ParamByName('ENDDATE').AsDate := AEndDate;
    qryReturnIn.ParamByName('DefaultPriceList').AsInteger := DM.tblObject_ConstPriceListId_def.AsInteger;

    qryReturnIn.Open;

    qryReturnIn.First;
    while not qryReturnIn.EOF do
    begin
      cdsReturnIn.Append;
      cdsReturnInId.AsInteger := qryReturnIn.FieldByName('ID').AsInteger;
      cdsReturnInOperDate.AsDateTime := qryReturnIn.FieldByName('OPERDATE').AsDateTime;
      cdsReturnInComment.AsString := qryReturnIn.FieldByName('COMMENT').AsString;
      cdsReturnInName.AsString := 'Возврат от ' + FormatDateTime('DD.MM.YYYY', qryReturnIn.FieldByName('OPERDATE').AsDateTime);
      cdsReturnInPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', qryReturnIn.FieldByName('TOTALSUMMPVAT').AsFloat);
      cdsReturnInWeight.AsString := 'Вес: ' + FormatFloat(',0.00', qryReturnIn.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_Complete.AsString
      else
      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsReturnInStatus.AsString := tblObject_ConstStatusName_Erased.AsString
      else
        cdsReturnInStatus.AsString := 'Неизвестный';

      cdsReturnInStatusId.AsInteger := qryReturnIn.FieldByName('STATUSID').AsInteger;
      cdsReturnInisSync.AsBoolean := qryReturnIn.FieldByName('ISSYNC').AsBoolean;

      cdsReturnInPartnerId.AsInteger := qryReturnIn.FieldByName('PartnerId').AsInteger;
      cdsReturnInPartnerName.AsString := qryReturnIn.FieldByName('PartnerName').AsString;
      cdsReturnInAddress.AsString := qryReturnIn.FieldByName('Address').AsString;
      cdsReturnInContractId.AsInteger := qryReturnIn.FieldByName('CONTRACTID').AsInteger;
      cdsReturnInContractName.AsString := qryReturnIn.FieldByName('ContractName').AsString;
      cdsReturnInPaidKindId.AsInteger := qryReturnIn.FieldByName('PaidKindId').AsInteger;
      cdsReturnInPriceListId.AsInteger := qryReturnIn.FieldByName('PRICELISTID').AsInteger;
      cdsReturnInPriceWithVAT.AsBoolean := qryReturnIn.FieldByName('PriceWithVAT').AsBoolean;
      cdsReturnInVATPercent.AsFloat := qryReturnIn.FieldByName('VATPercent').AsFloat;
      cdsReturnInChangePercent.AsFloat := qryReturnIn.FieldByName('ChangePercent').AsFloat;
      cdsReturnIn.Post;

      qryReturnIn.Next;
    end;

    qryReturnIn.Close;
  finally
    qryReturnIn.Free;
    cdsReturnIn.EnableControls;
    cdsReturnIn.First;
  end;
end;

{ добавление новых товаров в перечень товаров для возврата }
procedure TDM.AddedGoodsToReturnIn(AGoods : string);
var
  ArrValue : TArray<string>;
begin
  ArrValue := AGoods.Split([';']); //Id;GoodsId;GoodsKindID;название товара;вид товара;цена;единица измерения;вес;количество по умолчанию

  cdsReturnInItems.Append;
  cdsReturnInItemsId.AsString := ArrValue[0];
  cdsReturnInItemsGoodsId.AsString := ArrValue[1];       // GoodsId
  cdsReturnInItemsKindID.AsString := ArrValue[2];        // GoodsKindID
  cdsReturnInItemsGoodsName.AsString := ArrValue[3];     // название товара
  cdsReturnInItemsKindName.AsString := ArrValue[4];      // вид товара
  cdsReturnInItemsPrice.AsString := ArrValue[5];         // цена
  cdsReturnInItemsMeasure.AsString := ' ' + ArrValue[6]; // единица измерения
  cdsReturnInItemsWeight.AsString := ArrValue[7];        // вес

  cdsReturnInItemsCount.AsString := ArrValue[8];         // количество по умолчанию

  cdsReturnInItems.Post;
end;

{ начитка товаров для возврата из шаблона }
procedure TDM.DefaultReturnInItems;
var
  qryGoodsListSale : TFDQuery;
begin
  cdsReturnInItems.Open;
  cdsReturnInItems.EmptyDataSet;

  cdsReturnInItems.DisableControls;
  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;

    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || G.VALUEDATA || '';'' || ' +
      'IFNULL(GK.VALUEDATA, ''-'') || '';'' || IFNULL(PI.OrderPrice, 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';0''' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID ' +
      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'WHERE GLS.PARTNERID = :PARTNERID and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.ParamByName('PARTNERID').AsInteger := cdsReturnInPartnerId.AsInteger;
    qryGoodsListSale.ParamByName('PRICELISTID').AsInteger := cdsReturnInPRICELISTID.AsInteger;
    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToReturnIn(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
    cdsReturnInItems.EnableControls;
    cdsReturnInItems.First;
  end;
end;

{ начитка товаров для возврата из БД }
procedure TDM.LoadReturnInItems(AId : integer);
var
  qryGoodsListReturn : TFDQuery;
begin
  cdsReturnInItems.Open;
  cdsReturnInItems.EmptyDataSet;

  cdsReturnInItems.DisableControls;
  qryGoodsListReturn := TFDQuery.Create(nil);
  try
    qryGoodsListReturn.Connection := conMain;

    qryGoodsListReturn.SQL.Text := 'select IR.ID || '';'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
      'G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || IFNULL(PI.OrderPrice, 0) || '';'' || ' +
      'IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || IR.AMOUNT ' +
      'from MOVEMENTITEM_RETURNIN IR ' +
      'JOIN OBJECT_GOODS G ON G.ID = IR.GOODSID ' +
      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = IR.GOODSKINDID ' +
      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'WHERE IR.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';

    qryGoodsListReturn.ParamByName('PRICELISTID').AsInteger := cdsReturnInPRICELISTID.AsInteger;
    qryGoodsListReturn.Open;

    qryGoodsListReturn.First;
    while not qryGoodsListReturn.EOF do
    begin
      AddedGoodsToReturnIn(qryGoodsListReturn.Fields[0].AsString);

      qryGoodsListReturn.Next;
    end;

    qryGoodsListReturn.Close;
  finally
    qryGoodsListReturn.Free;
    cdsReturnInItems.EnableControls;
    cdsReturnInItems.First;
  end;
end;

{ начитка новых товаров, которые можно вернуть }
procedure TDM.GenerateReturnInItemsList;
begin
  qryGoodsItems.SQL.Text := 'select G.ID GoodsID, GK.ID KindID, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, ''-'' PromoPrice, ' +
    'GLK.REMAINS, PI.OrderPrice PRICE, M.VALUEDATA MEASURE, ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || G.VALUEDATA || '';'' || ' +
    'IFNULL(GK.VALUEDATA, ''-'') || '';'' || IFNULL(PI.OrderPrice, 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';0'' FullInfo, ' +
    'G.VALUEDATA || '';0'' SearchName ' +
    'from OBJECT_GOODS G ' +
    'LEFT JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID ' +
    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
    'WHERE G.ISERASED = 0 order by GoodsName';

  qryGoodsItems.ParamByName('PRICELISTID').AsInteger := cdsReturnInPRICELISTID.AsInteger;
  qryGoodsItems.Open;
end;

{ сохранение группы фотографий в БД }
procedure TDM.SavePhotoGroup(AGroupName: string);
var
  GlobalId : TGUID;
  NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  NewInvNumber := 1;

  qryMaxInvNumber := TFDQuery.Create(nil);
  try
    qryMaxInvNumber.Connection := conMain;
    qryMaxInvNumber.Open('select Max(InvNumber) from Movement_OrderExternal');
    if qryMaxInvNumber.RecordCount > 0 then
      NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
  finally
    FreeAndNil(qryMaxInvNumber);
  end;

  try
    tblMovement_Visit.Open;

    tblMovement_Visit.Append;

    CreateGUID(GlobalId);
    tblMovement_VisitGUID.AsString := GUIDToString(GlobalId);
    tblMovement_VisitInvNumber.AsString := IntToStr(NewInvNumber);
    tblMovement_VisitOperDate.AsDateTime := Date();
    tblMovement_VisitPartnerId.AsInteger := qryPartnerId.AsInteger;
    if Trim(AGroupName) <> '' then
      tblMovement_VisitComment.AsString := AGroupName
    else
      tblMovement_VisitComment.AsString := 'Общая';
    tblMovement_VisitInsertDate.AsDateTime := Now();
    tblMovement_VisitStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
    tblMovement_VisitisSync.AsBoolean := false;

    tblMovement_Visit.Post;

    tblMovement_Visit.Close;
  except
    on E : Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

{ начитка групп фотографий из БД }
procedure TDM.LoadPhotoGroups;
begin
  qryPhotoGroups.Close;
  qryPhotoGroups.Open('select Id, Comment, StatusId, OperDate, isSync ' +
    ' from Movement_Visit where PartnerId = ' + qryPartnerId.AsString +
    ' and StatusId <> ' + tblObject_ConstStatusId_Erased.AsString);
end;

{ начитка групп фотографий из БД для всех ТТ }
procedure TDM.LoadAllPhotoGroups;
begin
  qryPhotoGroupDocs.Close;
  qryPhotoGroupDocs.SQL.Text := 'select MV.Id, MV.Comment, MV.StatusId, MV.OperDate, MV.isSync, ' +
    'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS ' +
    'FROM Movement_Visit MV ' +
    'JOIN OBJECT_PARTNER P ON P.ID = MV.PARTNERID ' +
    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
    'WHERE DATE(MV.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE AND MV.StatusId <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
    'GROUP BY MV.ID, MV.PARTNERID order by PartnerName, Address asc, OPERDATE desc';
  qryPhotoGroupDocs.ParamByName('STARTDATE').AsDate := AStartDate;
  qryPhotoGroupDocs.ParamByName('ENDDATE').AsDate := AEndDate;
  qryPhotoGroupDocs.Open;
end;


{ получение данных для акта сверки }
procedure TDM.GenerateJuridicalCollation(ADateStart, ADateEnd: TDate;
  AJuridicalId, APartnerId, AContractId, APaidKindId: integer);
begin
  DM.cdsJuridicalCollation.EmptyDataSet;

  WaitThread := TWaitThread.Create(true);
  WaitThread.FreeOnTerminate := true;
  WaitThread.TaskName := 'JuridicalCollation';
  WaitThread.DateStart := ADateStart;
  WaitThread.DateEnd := ADateEnd;
  WaitThread.JuridicalId := AJuridicalId;
  WaitThread.PartnerId := APartnerId;
  WaitThread.ContractId := AContractId;
  WaitThread.PaidKindId := APaidKindId;
  WaitThread.Start;
end;

{ начитка заданий контрагента из БД }
function TDM.LoadTasks(Active: TActiveMode; SaveData: boolean = true; ADate: TDate = 0; APartnerId: integer = 0): integer;
var
  DateSql, WhereSql : string;
begin
  if ADate = 0 then
    DateSql := 'JOIN MOVEMENT_TASK TM ON TM.ID = TI.MOVEMENTID '
  else
    DateSql := 'JOIN MOVEMENT_TASK TM ON TM.ID = TI.MOVEMENTID AND DATE(TM.OPERDATE) = :TASKDATE ';

  if Active <> amAll then
    WhereSql := 'WHERE TI.CLOSED = :CLOSED '
  else
    WhereSql := 'WHERE 1 = 1 ';

  if APartnerId <> 0 then
    WhereSql := WhereSql + 'AND TI.PARTNERID = ' + IntToStr(APartnerId) + ' ';

  qrySelect.SQL.Text := 'SELECT TI.ID, TI.PARTNERID, TI.CLOSED, TI.DESCRIPTION, TI.COMMENT, ' +
    'TM.OPERDATE, TM.INVNUMBER, P.VALUEDATA PartnerName ' +
    'FROM MOVEMENTITEM_TASK TI ' +
    DateSql +
    'LEFT JOIN OBJECT_PARTNER P ON P.ID = TI.PARTNERID ' +
    WhereSql+
    'GROUP BY TI.ID ORDER BY TM.OPERDATE DESC';

  if ADate <> 0 then
    qrySelect.ParamByName('TASKDATE').AsDate := ADate;

  if Active = amOpen then
    qrySelect.ParamByName('CLOSED').AsBoolean := false
  else
  if Active = amClose then
    qrySelect.ParamByName('CLOSED').AsBoolean := true;

  cdsTasks.EmptyDataSet;
  qrySelect.Open;
  try
    Result := qrySelect.RecordCount;

    if SaveData then
    begin
      qrySelect.First;

      while not qrySelect.Eof do
      begin
        cdsTasks.Append;

        cdsTasksId.AsInteger := qrySelect.FieldByName('Id').AsInteger;
        cdsTasksInvNumber.AsString := qrySelect.FieldByName('InvNumber').AsString;
        cdsTasksOperDate.AsDateTime := qrySelect.FieldByName('OperDate').AsDateTime;
        cdsTasksPartnerId.AsInteger := qrySelect.FieldByName('PartnerId').AsInteger;
        cdsTasksClosed.AsBoolean := qrySelect.FieldByName('Closed').AsBoolean;
        cdsTasksDescription.AsString := qrySelect.FieldByName('Description').AsString;
        cdsTasksComment.AsString := qrySelect.FieldByName('Comment').AsString;
        if qrySelect.FieldByName('PartnerName').AsString <> '' then
          cdsTasksPartnerName.AsString := 'ТТ: ' + qrySelect.FieldByName('PartnerName').AsString;
        cdsTasksTaskDate.AsString := 'Задание от ' + FormatDateTime('DD.MM.YYYY', cdsTasksOperDate.AsDateTime);
        cdsTasksTaskDescription.AsString := 'Описание: ' + cdsTasksDescription.AsString;

        cdsTasks.Post;

        qrySelect.Next;
      end;

      cdsTasks.First;
    end;
  finally
    qrySelect.Close;
  end;
end;

{ Сохранение в БД отметки о выполнении задания контрагентом }
function TDM.CloseTask(ATasksId: integer; ATaskComment: string): boolean;
begin
  try
    conMain.ExecSQL('update MovementItem_Task set Closed = 1, Comment = ' + QuotedStr(ATaskComment) +
      ', ISSYNC = 0 where Id = ' + IntToStr(ATasksId));
    ShowMessage('Задание отмечено закрытым');
    Result := true;
  except
    ShowMessage('Ошибка при попытке закрыть задание');
    Result := false;
  end;
end;

{ сохранение в БД информации о новой ТТ и юр.лице }
function TDM.CreateNewPartner(JuridicalId: integer; JuridicalName, Address: string;
  GPSN, GPSE: Double; var ErrorMessage : string): boolean;
var
  GlobalId: TGUID;
  NewJuridicalId, NewPartnerId: integer;
  qryNewId: TFDQuery;
begin
  Result := false;

  // получение Id для новой юридического лица (если не выбрали из существующих)
  NewJuridicalId := JuridicalId;
  if NewJuridicalId = -1 then
  begin
    qryNewId := TFDQuery.Create(nil);
    try
      qryNewId.Connection := conMain;

      qryNewId.Open('select Min(ID) from OBJECT_JURIDICAL');
      if (qryNewId.RecordCount > 0) and (qryNewId.Fields[0].AsInteger < 0) then
        NewJuridicalId := qryNewId.Fields[0].AsInteger - 1;
    finally
      FreeAndNil(qryNewId);
    end;
  end;

  // получение Id для новой ТТ
  NewPartnerId := -1;
  qryNewId := TFDQuery.Create(nil);
  try
    qryNewId.Connection := conMain;

    qryNewId.Open('select Min(ID) from OBJECT_PARTNER');
    if (qryNewId.RecordCount > 0) and (qryNewId.Fields[0].AsInteger < 0) then
      NewPartnerId := qryNewId.Fields[0].AsInteger - 1;
  finally
    FreeAndNil(qryNewId);
  end;

  conMain.StartTransaction;
  try
    if NewJuridicalId < 0 then // необходимо сохранить новое юридическое лицо
    begin
      tblObject_Juridical.Open;

      tblObject_Juridical.Append;

      CreateGUID(GlobalId);
      tblObject_JuridicalId.AsInteger := NewJuridicalId;
      tblObject_JuridicalContractId.AsInteger := 0;
      tblObject_JuridicalGUID.AsString := GUIDToString(GlobalId);
      tblObject_JuridicalValueData.AsString := JuridicalName;
      tblObject_JuridicalisErased.AsBoolean := false;
      tblObject_JuridicalisSync.AsBoolean := false;

      tblObject_Juridical.Post;
    end;

    // сохранение новой ТТ
    tblObject_Partner.Open;

    tblObject_Partner.Append;

    CreateGUID(GlobalId);
    tblObject_PartnerId.AsInteger := NewPartnerId;
    tblObject_PartnerJuridicalId.AsInteger := NewJuridicalId;
    tblObject_PartnerContractId.AsInteger := 0;
    tblObject_PartnerGUID.AsString := GUIDToString(GlobalId);
    tblObject_PartnerAddress.AsString := Address;
    tblObject_PartnerValueData.AsString := JuridicalName + ' ' + Address;
    tblObject_PartnerGPSN.AsFloat := GPSN;
    tblObject_PartnerGPSE.AsFloat := GPSE;
    tblObject_PartnerSchedule.AsString := 't;t;t;t;t;t;t';
    tblObject_PartnerPriceListId.AsInteger := tblObject_ConstPriceListId_def.AsInteger;
    tblObject_PartnerPriceListId_ret.AsInteger := tblObject_ConstPriceListId_def.AsInteger;
    tblObject_PartnerisErased.AsBoolean := false;
    tblObject_PartnerisSync.AsBoolean := false;

    tblObject_Partner.Post;

    conMain.Commit;

    tblObject_Partner.Close;
    tblObject_Juridical.Close;

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;

      tblObject_Partner.Close;
      tblObject_Juridical.Close;

      ErrorMessage := E.Message;
    end;
  end;
end;


initialization

Structure := TStructure.Create;

finalization

FreeAndNil(Structure);

end.


