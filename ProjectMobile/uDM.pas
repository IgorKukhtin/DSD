unit uDM;

interface

uses
  FMX.Forms, System.SysUtils, System.Classes, Generics.Collections, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Comp.UI, Variants, FireDAC.FMXUI.Wait, FMX.dsdDB, Datasnap.DBClient,
  FMX.Dialogs, FMX.DialogService, System.UITypes, System.Sensors, DateUtils,
  FireDAC.Phys.SQLiteWrapper.Stat
  {$IFDEF ANDROID}
  , Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes, Androidapi.JNI.App,
  Androidapi.JNI.Support
  {$ENDIF};

CONST
  DataBaseFileName = 'aMobile.sdb';

  { базовый запрос на получение информации по ТТ }
//or
//  BasePartnerQuery = 'select P.Id, P.CONTRACTID, P.JURIDICALID, J.VALUEDATA Name, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, ' +
//    'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, C.PAIDKINDID, C.CHANGEPERCENT, ' +
//    'P.DEBTSUM, P.OVERSUM, P.OVERDAYS, J.DEBTSUM DEBTSUMJ, J.OVERSUM OVERSUMJ, J.OVERDAYS OVERDAYSJ, ' +
//    'PL.ID PRICELISTID, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
//    'PLR.ID PRICELISTID_RET, PLR.PRICEWITHVAT PRICEWITHVAT_RET, PLR.VATPERCENT VATPERCENT_RET, ' +
//    'P.CalcDayCount, P.OrderDayCount, P.isOperDateOrder ' +
//    'from OBJECT_PARTNER P ' +
//    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
//    'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID, :DefaultPriceList) ' +
//    'LEFT JOIN Object_PriceList PLR ON PLR.ID = IFNULL(P.PRICELISTID_RET, :DefaultPriceList) ' +
//    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
//    'where P.ISERASED = 0 ';
//or
  BasePartnerQuery =
     ' SELECT '
   + '         Object_Partner.Id '
   + '       , Object_Partner.ContractId '
   + '       , Object_Partner.JuridicalId '
   + '       , Object_Juridical.ValueData    AS Name '
   + '       , Object_Partner.ShortName '
   + '       , Object_Contract.ContractTagName || '' '' || Object_Contract.ValueData AS ContractName '
   + '       , Object_Partner.Address '
   + '       , Object_Partner.ShortAddress '
   + '       , Object_Partner.GPSN '
   + '       , Object_Partner.GPSE '
   + '       , Object_Partner.Schedule '
   + '       , Object_Contract.PaidKindId '
   + '       , Object_Contract.ChangePercent '
   + '       , Object_Partner.DebtSum '
   + '       , Object_Partner.OverSum '
   + '       , Object_Partner.OverDays '
   + '       , Object_Juridical.DebtSum      AS DebtSumJ '
   + '       , Object_Juridical.OverSum      AS OverSumJ '
   + '       , Object_Juridical.OverDays     AS OverDaysJ '
   + '       , Object_PL.Id                  AS PriceListId '
   + '       , Object_PL.PriceWithVAT '
   + '       , Object_PL.VATPercent '
   + '       , Object_PLR.Id                 AS PriceListId_ret '
   + '       , Object_PLR.PriceWithVAT       AS PriceWithVAT_RET '
   + '       , Object_PLR.VATPercent         AS VATPercent_RET '
   + '       , Object_Partner.CalcDayCount '
   + '       , Object_Partner.OrderDayCount '
   + '       , Object_Partner.isOperDateOrder  '
   + '       , COALESCE (OrderExternal_Partner.PartnerCount, 0) + COALESCE (StoreReal_Partner.PartnerCount, 0) AS PartnerCount '
   + '       , Object_Partner.isOrderMin AS isOrderMin'
   + ' FROM  Object_Partner  '
   + '       LEFT JOIN Object_Juridical            ON Object_Juridical.Id         = Object_Partner.JuridicalId '
   + '                                            AND Object_Juridical.ContractId = Object_Partner.ContractId '
   + '       LEFT JOIN Object_PriceList Object_PL  ON Object_PL.Id                = IFNULL(Object_Partner.PriceListId, :DefaultPriceList) '
   + '       LEFT JOIN Object_PriceList Object_PLR ON Object_PLR.Id               = IFNULL(Object_Partner.PriceListId_ret, :DefaultPriceList) '
   + '       LEFT JOIN Object_Contract             ON Object_Contract.Id          = Object_Partner.ContractId '
   + '       LEFT JOIN (SELECT Movement_OrderExternal.PartnerId '
   + '                       , COUNT (Movement_OrderExternal.PartnerId) AS PartnerCount '
   + '                  FROM Movement_OrderExternal '
   + '                       JOIN Object_Const AS OrderExternal_Const ON OrderExternal_Const.StatusId_Complete = Movement_OrderExternal.StatusId '
   + '                  WHERE DATE (Movement_OrderExternal.OperDate) = CURRENT_DATE '
   + '                  GROUP BY Movement_OrderExternal.PartnerId '
   + '                 ) AS OrderExternal_Partner ON OrderExternal_Partner.PartnerId = Object_Partner.Id '
   + '       LEFT JOIN (SELECT Movement_StoreReal.PartnerId '
   + '                       , COUNT (Movement_StoreReal.PartnerId) AS PartnerCount '
   + '                  FROM Movement_StoreReal '
   + '                       JOIN Object_Const AS StoreReal_Const ON StoreReal_Const.StatusId_Complete = Movement_StoreReal.StatusId '
   + '                  WHERE DATE (Movement_StoreReal.OperDate) = CURRENT_DATE '
   + '                  GROUP BY Movement_StoreReal.PartnerId '
   + '                 ) AS StoreReal_Partner ON StoreReal_Partner.PartnerId = Object_Partner.Id '
   + ' WHERE Object_Partner.isErased = 0 ';

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

  TSyncData = class
  private
    function AdaptQuotMark(S: string): string;
    function GetMovementCountItems(AGUID: string): Integer;
    function UpdateMovementReturnInAuto(AGUID: string): string;
    procedure FeedbackMovementReturnIn(AGUID: string);
    procedure SetMovementErased(AStoredProcName, AGUID: string);
    procedure SetMovementErasedOrderExternal(AGUID: string);
    procedure SetMovementErasedReturnIn(AGUID: string);
  public
    procedure SaveSyncDataOut(ADate: TDateTime);
    procedure SyncStoreReal(AGUID: string);
    procedure SyncOrderExternal(AGUID: string);
    procedure SyncReturnIn(AGUID: string);
    procedure SyncRouteMember;
  end;

  TUploadTaskType = (uttAll, uttStoreReal, uttOrderExternal, uttReturnIn, uttCash, uttTasks, uttNewPartners,
    uttPartnerGPS, uttRouteMember, uttPhotos);

  { отдельный поток для синхронизации }
  TSyncThread = class(TThread)
  private
    { Private declarations }
    FAllProgress : integer;
    FAllMax : integer;
    FName : string;

    LoadData: boolean;
    UploadData: boolean;

    SyncDataIn : TDateTime;
    SyncDataOut : TDateTime;

    UploadTaskType: TUploadTaskType;

    procedure Update;
    procedure SetNewProgressTask(AName : string);

    procedure GetSyncDates;
    procedure SaveSyncDataIn(ADate: TDateTime);
    procedure GetDictionaries(AName : string);

    procedure UploadCash;
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
    JuridicalId, PartnerId, ContractId, PaidKindId, DocId: Integer;

    procedure SetTaskName(AName : string);

    function LoadJuridicalCollation: string;
    function LoadJuridicalCollationDoc: string;
    function UpdateProgram: string;
    function ShowAllPartnerOnMap: string;
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
    qryPartnerIsOrderMin: TBooleanField;
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
    cdsOrderExternalIsSync: TBooleanField;
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
    cdsOrderExternalIsOperDateOrder: TBooleanField;
    cdsOrderExternalIsOrderMin: TBooleanField;
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
    qryPartnerContractInfo: TStringField;
    cdsJuridicalCollationPaidKindShow: TStringField;
    qryPartnerJuridicalId: TIntegerField;
    cdsOrderItemsRecommendCount: TFloatField;
    qryPartnerFullName: TStringField;
    cdsOrderExternalPartnerFullName: TStringField;
    cdsStoreRealsPartnerFullName: TStringField;
    cdsReturnInPartnerFullName: TStringField;
    tblObject_TradeMark: TFDTable;
    tblObject_TradeMarkId: TIntegerField;
    tblObject_TradeMarkObjectCode: TIntegerField;
    tblObject_TradeMarkValueData: TStringField;
    tblObject_TradeMarkisErased: TBooleanField;
    tblObject_GoodsTradeMarkId: TIntegerField;
    qryGoodsForPriceListTradeMarkName: TStringField;
    qryGoodsForPriceListObjectCode: TIntegerField;
    qryGoodsForPriceListFullGoodsName: TStringField;
    qryPromoGoodsObjectCode: TIntegerField;
    qryPromoGoodsTradeMarkName: TStringField;
    qryPromoGoodsFullGoodsName: TStringField;
    qryGoodsItemsObjectCode: TIntegerField;
    qryGoodsItemsTradeMark: TStringField;
    cdsOrderItemsTradeMarkName: TStringField;
    cdsStoreRealItemsTradeMarkName: TStringField;
    cdsReturnInItemsTradeMarkName: TStringField;
    tblMovement_Cash: TFDTable;
    tblMovement_CashId: TAutoIncField;
    tblMovement_CashGUID: TStringField;
    tblMovement_CashInvNumber: TStringField;
    tblMovement_CashOperDate: TDateField;
    tblMovement_CashStatusId: TIntegerField;
    tblMovement_CashInsertDate: TDateTimeField;
    tblMovement_CashAmount: TFloatField;
    tblMovement_CashPaidKindId: TIntegerField;
    tblMovement_CashPartnerId: TIntegerField;
    tblMovement_CashCashId: TIntegerField;
    tblMovement_CashMemberId: TIntegerField;
    tblMovement_CashContractId: TIntegerField;
    tblMovement_CashComment: TStringField;
    tblMovement_CashisSync: TBooleanField;
    qryCash: TFDQuery;
    qryCashId: TIntegerField;
    qryCashAmount: TFloatField;
    qryCashComment: TStringField;
    qryCashStatusId: TIntegerField;
    qryCashOperDate: TDateField;
    qryCashisSync: TBooleanField;
    qryCashName: TStringField;
    qryCashAmountShow: TStringField;
    qryCashStatus: TStringField;
    qryCashPartnerId: TIntegerField;
    qryCashPartnerName: TWideStringField;
    qryCashAddress: TWideStringField;
    qryCashContractId: TIntegerField;
    qryCashContractName: TWideStringField;
    qryCashInvNumberSale: TStringField;
    tblMovement_CashInvNumberSale: TStringField;
    qryCashPAIDKINDID: TIntegerField;
    tblObject_PriceListItemsReturnPrice: TFloatField;
    tblObject_PriceListItemsReturnStartDate: TDateTimeField;
    tblObject_PriceListItemsReturnEndDate: TDateTimeField;
    qryGoodsFullForPriceList: TFDQuery;
    qryGoodsFullForPriceListId: TIntegerField;
    qryGoodsFullForPriceListObjectCode: TIntegerField;
    qryGoodsFullForPriceListGoodsName: TStringField;
    qryGoodsFullForPriceListKindName: TStringField;
    qryGoodsFullForPriceListOrderPrice: TFloatField;
    qryGoodsFullForPriceListMeasure: TStringField;
    qryGoodsFullForPriceListOrderStartDate: TDateTimeField;
    qryGoodsFullForPriceListOrderFullPrice: TStringField;
    qryGoodsFullForPriceListOrderTermin: TStringField;
    qryGoodsFullForPriceListTradeMarkName: TStringField;
    qryGoodsFullForPriceListFullGoodsName: TStringField;
    qryGoodsFullForPriceListSalePrice: TFloatField;
    qryGoodsFullForPriceListOrderEndDate: TDateTimeField;
    qryGoodsFullForPriceListSaleStartDate: TDateTimeField;
    qryGoodsFullForPriceListSaleEndDate: TDateTimeField;
    qryGoodsFullForPriceListReturnPrice: TFloatField;
    qryGoodsFullForPriceListReturnStartDate: TDateTimeField;
    qryGoodsFullForPriceListReturnEndDate: TDateTimeField;
    qryGoodsFullForPriceListSaleFullPrice: TStringField;
    qryGoodsFullForPriceListSaleTermin: TStringField;
    qryGoodsFullForPriceListReturnFullPrice: TStringField;
    qryGoodsFullForPriceListReturnTermin: TStringField;
    tblObject_ConstOperDate_diff: TIntegerField;
    tblObject_ConstReturnDayCount: TIntegerField;
    cdsOrderItemsPriceShow: TStringField;
    tblObject_PartnerShortAddress: TStringField;
    qryPartnerShortAddress: TStringField;
    qJuridicalCollationItems: TFDQuery;
    qJuridicalCollationItemsValue: TStringField;
    qJuridicalCollationItemsId: TIntegerField;
    qJuridicalCollationItemsDopValue: TWideStringField;
    tblObject_ConstCriticalOverDays: TIntegerField;
    tblObject_ConstCriticalDebtSum: TFloatField;
    tblMovement_RouteMemberAddressByGPS: TStringField;
    tblMovementItem_VisitAddressByGPS: TStringField;
    qryPartnerPartnerCount: TLargeintField;
    tblObject_PartnerShortName: TStringField;
    qryPartnerShortName: TStringField;
    cdsJuridicalCollationDocId: TIntegerField;
    cdsJuridicalCollationDocItems: TClientDataSet;
    cdsJuridicalCollationDocItemsDocId: TIntegerField;
    cdsJuridicalCollationDocItemsDocItemId: TIntegerField;
    cdsJuridicalCollationDocItemsGoodsId: TIntegerField;
    cdsJuridicalCollationDocItemsGoodsName: TStringField;
    cdsJuridicalCollationDocItemsGoodsKindId: TIntegerField;
    cdsJuridicalCollationDocItemsGoodsKindName: TStringField;
    cdsJuridicalCollationDocItemsPrice: TFloatField;
    cdsJuridicalCollationDocItemsAmount: TFloatField;
    cdsJuridicalCollationDocItemsisPromo: TBooleanField;
    cdsJuridicalCollationDocItemsGoodsFullName: TStringField;
    cdsJuridicalCollationDocItemsPromoText: TStringField;
    cdsJuridicalCollationDocItemsGoodsCode: TIntegerField;
    cdsJuridicalCollationDocItemsPriceText: TStringField;
    cdsJuridicalCollationDocItemsAmountText: TStringField;
    tblMovementItem_ReturnInisRecalcPrice: TBooleanField;
    cdsReturnInItemsRecalcPriceName: TStringField;
    qryGoodsItemsFullGoodsName: TWideStringField;
    tblObject_ConstWebService_two: TStringField;
    tblObject_ConstWebService_three: TStringField;
    tblObject_ConstWebService_four: TStringField;
    tblObject_ConstAPIKey: TStringField;
    tblObject_ConstCriticalWeight: TFloatField;
    tblObject_PartnerisOrderMin: TBooleanField;
    tblObject_PriceListItemsGoodsKindId: TIntegerField;
    tblObject_SubjectDoc: TFDTable;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    StringField1: TStringField;
    BooleanField1: TBooleanField;
    tblMovement_ReturnInSubjectDocId: TIntegerField;
    tblMovementItem_ReturnInSubjectDocId: TIntegerField;
    cdsReturnInItemsSubjectDocId: TIntegerField;
    cdsReturnInItemsSubjectDocName: TStringField;
    cdsReturnInSubjectDocId: TIntegerField;
    cdsReturnInSubjectDocName: TStringField;
    qrySubjectDoc: TFDQuery;
    qrySubjectDocId: TIntegerField;
    qrySubjectDocValueData: TStringField;
    cdsReturnInItemsCurrencyName: TStringField;
    tblObject_SubjectDocBaseName: TStringField;
    qrySubjectDocBaseName: TStringField;
    tblObject_SubjectDocCauseName: TStringField;
    qrySubjectDocCauseName: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryGoodsForPriceListCalcFields(DataSet: TDataSet);
    procedure qryPhotoGroupsCalcFields(DataSet: TDataSet);
    procedure qryPhotoGroupDocsCalcFields(DataSet: TDataSet);
    procedure qryPartnerCalcFields(DataSet: TDataSet);
    procedure qryPromoGoodsCalcFields(DataSet: TDataSet);
    procedure qryCashCalcFields(DataSet: TDataSet);
    procedure qryCashDocsCalcFields(DataSet: TDataSet);
    procedure qryGoodsFullForPriceListCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FConnected: Boolean;
    FDataBase: String;
    FOldLogin: string;

    procedure InitStructure;
  public
    { Public declarations }
    IsUploadRouteMember: Boolean;

    function Connect: Boolean;
    function ConnectWithOutDB: Boolean;
    function CheckStructure: Boolean;
    procedure CreateIndexes;
    function CreateDataBase: Boolean;

    function GetCurrentVersion: string;
    function CompareVersion(ACurVersion, AServerVersion: string): integer;
    procedure CheckUpdate;
    procedure UpdateProgram(const AResult: TModalResult);

    procedure ShowAllPartnerOnMap;

    function GetConfigurationInfo: boolean;
    procedure SynchronizeWithMainDatabase(LoadData: Boolean = True; UploadData: Boolean = True;
      UploadTaskType: TUploadTaskType = uttAll);

    function GetInvNumber(ATableName: string): string;

    function SaveStoreReal(Comment: string; DelItems : string; Complete: boolean;
      var ErrorMessage : string) : boolean;
    procedure NewStoreReal;
    procedure LoadStoreReals;
    procedure LoadAllStoreReals(AStartDate, AEndDate: TDate);
    procedure AddedGoodsToStoreReal(AGoods : string);
    procedure DefaultStoreRealItems;
    procedure LoadStoreRealItems(AId: integer);
    procedure GenerateStoreRealItemsList;

    function InsertOrderExternal(OperDate: TDateTime; Comment: string; PartnerId, PaidKindId, ContractId,
      PriceListId: Integer; PriceWithVAT: Boolean; VATPercent, ChangePercent, TotalWeight, TotalPrice: Currency;
      Complete: Boolean): Integer;
    function UpdateOrderExternal(Id: Integer; OperDate: TDateTime; Comment: string; PaidKindId: Integer;
      PriceWithVAT: Boolean; VATPercent, ChangePercent, TotalWeight, TotalPrice: Currency;
      Complete: Boolean; var ErrorMessage : string): Integer;
    function InsertOrderExternalItem(MovementId, GoodsId, GoodsKindId: Integer; Amount, Price, ChangePercent: Currency): Integer;
    procedure UpdateOrderExternalItem(MovementItemId: Integer; Amount, Price, ChangePercent: Currency);
    function SaveOrderExternal(OperDate: TDate; PaidKindId: integer; Comment: string;
      TotalPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string) : boolean;
    procedure NewOrderExternal;
    procedure LoadOrderExternal;
    procedure LoadAllOrderExternal(AStartDate, AEndDate: TDate);
    procedure AddedGoodsToOrderExternal(AGoods : string);
    procedure DefaultOrderExternalItems;
    procedure LoadOrderExtrenalItems(AId: integer);
    procedure GenerateOrderExtrenalItemsList;

    function SaveReturnIn(OperDate: TDate; PaidKindId: integer; Comment : string; SubjectDocId : Integer; SubjectDocName : String;
      TotalPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string; NowSync: Boolean = False) : boolean;
    procedure NewReturnIn;
    procedure LoadReturnIn;
    procedure LoadAllReturnIn(AStartDate, AEndDate: TDate);
    procedure AddedGoodsToReturnIn(AGoods : string);
    procedure DefaultReturnInItems;
    procedure LoadReturnInItems(AId: integer);
    procedure GenerateReturnInItemsList;
    procedure GenerateReturnInSubjectDoc;
    procedure SyncReturnIn(AMovementId: Integer);

    procedure SavePhotoGroup(AGroupName: string);
    procedure LoadPhotoGroups;
    procedure LoadAllPhotoGroups(AStartDate, AEndDate: TDate);

    procedure SaveCash(AId: integer; APaidKind: integer; AInvNumberSale: string; AOperDate: TDate; AAmount: Double; AComment: string);
    procedure LoadCash;
    procedure LoadAllCash(AStartDate, AEndDate: TDate);

    procedure GenerateJuridicalCollation(ADateStart, ADateEnd: TDate;
      AJuridicalId, APartnerId, AContractId, APaidKindId: Integer);
    procedure GenerateJuridicalCollationDocItems(ADocId: Integer);

    function LoadTasks(Active: TActiveMode; SaveData: boolean = true; ADate: TDate = 0; APartnerId: integer = 0): integer;
    function CloseTask(ATasksId: integer; ATaskComment: string): boolean;

    function CreateNewPartner(JuridicalId: integer; JuridicalName, Address: string;
      GPSN, GPSE: Double; var ErrorMessage : string): boolean;

    property Connected: Boolean read FConnected;
    property OldLogin: string read FOldLogin;
  end;

var
  DM: TDM;
  Structure: TStructure;
  SyncData: TSyncData;
  ProgressThread : TProgressThread;
  SyncThread : TSyncThread;
  WaitThread : TWaitThread;

implementation

uses
  System.IOUtils, FMX.CursorUtils, FMX.CommonData, FMX.Authentication, FMX.Storage, ZLib,
  System.StrUtils, FMX.UnilWin, uMain, uExec, uIntf;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ обновление бегущего круга }
procedure TProgressThread.Update;
const
  Colors : array[0..5] of TAlphaColor = ($FF1AF71A, $FF1305DA, $FFF818D2, $FF02F2FA, $FFFB1028, $FFFE7FE8);
var
  d: single;
  NewColor, OldColor: TAlphaColor;
  ColorIndex: integer;
begin
  inc(FProgress);
  if FProgress>= 100 then
  begin
    FProgress := 0;

    OldColor := frmMain.pieProgress.Fill.Color;
    repeat
      ColorIndex := Random(5);

      NewColor := Colors[ColorIndex];
    until OldColor <> NewColor;
    frmMain.pieProgress.Fill.Color := NewColor;
  end;

  d := (-FProgress * 360 / 100);

  frmMain.pieProgress.StartAngle := d + 20;
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
    if DM.OldLogin = DM.tblObject_ConstUserLogin.AsString then
      SyncDataIn := DM.tblObject_ConstSyncDateIn.AsDateTime
    else
      SyncDataIn := varNull;
    //
    if SyncDataIn < varNull then SyncDataIn:= varNull;
    //
    SyncDataOut := DM.tblObject_ConstSyncDateOut.AsDateTime;
  end
  else
  begin
    SyncDataIn := varNull;
    SyncDataOut := varNull;
  end;
end;

{ сохранение на сервер даты последнего получения данных с сервера }
procedure TSyncThread.SaveSyncDataIn(ADate: TDateTime);
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    UploadStoredProc.StoredProcName := 'gpUpdateMobile_ObjectDate_User_UpdateMobileTo';
    UploadStoredProc.Params.Clear;
    UploadStoredProc.Params.AddParam('inUpdateMobileTo', ftDateTime, ptInput, ADate);

    try
      UploadStoredProc.Execute(false, false, false);
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(UploadStoredProc);
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
  FieldsStr, ValuesStr, WhereStr: string;
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
    end
    else
    if AName = 'TradeMark' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_TradeMark';
      CurDictTable.TableName := 'Object_TradeMark';
      DM.conMain.ExecSQL('update Object_TradeMark set isErased = 1');
    end
    else
    if AName = 'SubjectDoc' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_SubjectDoc';
      CurDictTable.TableName := 'Object_SubjectDoc';
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
          begin
            FindRec := CurDictTable.Locate('Id;ContractId', VarArrayOf([FieldByName('Id').AsInteger, FieldByName('ContractId').AsInteger]));
            WhereStr := 'Id = ' + FieldByName('Id').AsString + ' and ContractId = ' + FieldByName('ContractId').AsString;
          end
          else
          begin
            FindRec := CurDictTable.Locate('Id', FieldByName('Id').AsInteger);
            WhereStr := 'Id = ' + FieldByName('Id').AsString;
          end;

          if FindRec then
          begin
            if AName = 'MovementItemTask' then
            begin
              Next;
              continue;
            end;
          end
          else
          begin
            if not FieldByName('isSync').AsBoolean then
            begin
              Next;
              continue;
            end;
          end;

          if FieldByName('isSync').AsBoolean then
          begin
            FieldsStr := '';
            ValuesStr := '';

            for x := 0 to Length(Mapping) - 1 do
            begin
              FieldsStr := FieldsStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ',';
              case CurDictTable.Fields[ Mapping[x][1] ].DataType of
                ftInteger :
                begin
                  if FindRec then
                    ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = ' +
                                 IntToStr(StrToIntDef(GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsString, 0)) + ','
                  else
                    ValuesStr := ValuesStr + IntToStr(StrToIntDef(GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsString, 0)) + ',';
                end;
                ftFloat :
                begin
                  if FindRec then
                    ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = ' +
                                 FloatToStr(StrToFloatDef(GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsString, 0)) + ','
                  else
                    ValuesStr := ValuesStr + FloatToStr(StrToFloatDef(GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsString, 0)) + ',';
                end;
                ftBoolean :
                begin
                  if FindRec then
                  begin
                    if GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsBoolean then
                      ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = 1,'
                    else
                      ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = 0,';
                  end
                  else
                  begin
                    if GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsBoolean then
                      ValuesStr := ValuesStr + ' 1,'
                    else
                      ValuesStr := ValuesStr + ' 0,';
                  end;
                end;
                ftDateTime :
                begin
                  if FindRec then
                    ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = ' +
                                 QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsDateTime)) + ','
                  else
                    ValuesStr := ValuesStr + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsDateTime)) + ',';
                end;
                ftDate :
                begin
                  if FindRec then
                    ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = ' +
                                 QuotedStr(FormatDateTime('yyyy-mm-dd', GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsDateTime)) + ','
                  else
                    ValuesStr := ValuesStr + QuotedStr(FormatDateTime('yyyy-mm-dd', GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsDateTime)) + ',';
                end;
                else
                begin
                  if FindRec then
                    ValuesStr := ValuesStr + CurDictTable.Fields[ Mapping[x][1] ].FieldName + ' = ' +
                                 QuotedStr(GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsString) + ','
                  else
                    ValuesStr := ValuesStr + QuotedStr(GetStoredProc.DataSet.Fields[ Mapping[x][2] ].AsString) + ',';
                end;
              end;
            end;

            System.delete(FieldsStr, Length(FieldsStr), 1);
            System.delete(ValuesStr, Length(ValuesStr), 1);

//            Synchronize(procedure
//                        begin
                          if FindRec then
                            DM.conMain.ExecSQL('update ' + CurDictTable.TableName + ' set ' + ValuesStr + ' where ' + WhereStr)
                          else
                            DM.conMain.ExecSQL('insert into ' + CurDictTable.TableName + ' (' + FieldsStr + ') values (' + ValuesStr + ')');
//                        end);
          end
          else
            if (AName <> 'PromoMain') and (AName <> 'PromoPartner') and (AName <> 'PromoGoods')  and
               (AName <> 'MovementTask') and (AName <> 'MovementItemTask')  then
            begin
//              Synchronize(procedure
//                          begin
                            DM.conMain.ExecSQL('update ' + CurDictTable.TableName + ' set isErased = 1 where ' + WhereStr)
//                          end);
            end;

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
    if Assigned(GetStoredProc) then FreeAndNil(GetStoredProc);
  end;
end;

{ Сохранение на сервер введенной информации по оплатам }
procedure TSyncThread.UploadCash;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovement_Cash do
    begin
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString;
      Filtered := true;
      Open;

      try
        First;
        while not Eof do
        begin
          UploadStoredProc.StoredProcName := 'gpInsertUpdateMobile_Movement_Cash';
          UploadStoredProc.Params.Clear;
          UploadStoredProc.Params.AddParam('inGUID', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inInvNumber', ftString, ptInput, FieldByName('INVNUMBER').AsString);
          UploadStoredProc.Params.AddParam('inOperDate', ftDateTime, ptInput, FieldByName('OPERDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inStatusId', ftInteger, ptInput, FieldByName('STATUSID').AsInteger);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inAmount', ftFloat, ptInput, FieldByName('AMOUNT').AsFloat);
          UploadStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, FieldByName('PAIDKINDID').AsInteger);
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
          UploadStoredProc.Params.AddParam('inCashId', ftInteger, ptInput, FieldByName('CASHID').AsInteger);
          UploadStoredProc.Params.AddParam('inMemberId', ftInteger, ptInput, FieldByName('MEMBERID').AsInteger);
          UploadStoredProc.Params.AddParam('inContractId', ftInteger, ptInput, FieldByName('CONTRACTID').AsInteger);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inInvNumberSale', ftString, ptInput, FieldByName('INVNUMBERSALE').AsString);

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
begin
  Synchronize(procedure
              begin
                DM.IsUploadRouteMember := True;
              end);
  try
    SyncData.SyncRouteMember;
  finally
    Synchronize(procedure
                begin
                  DM.IsUploadRouteMember := False;
                end);
  end;
end;

{ Сохранение на сервер фотографий }
procedure TSyncThread.UploadPhotos;
var
  UploadStoredProc: TdsdStoredProc;
  PhotoStream: TStream;
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

          DM.qrySelect.Open('SELECT GUID FROM Movement_Visit WHERE Id = ' + FieldByName('MOVEMENTID').AsString);
          if DM.qrySelect.RecordCount = 1 then
          begin
            MainGUID := DM.qrySelect.Fields[0].AsString;
          end;
          DM.qrySelect.Close;
          UploadStoredProc.Params.AddParam('inMovementGUID', ftString, ptInput, MainGUID);

          PhotoStream := CreateBlobStream(FieldByName('PHOTO'), bmRead);
          try
             UploadStoredProc.Params.AddParam('inPhoto', ftBlob, ptInput, ConvertConvert(PhotoStream));
          finally
            FreeAndNil(PhotoStream);
          end;
          UploadStoredProc.Params.AddParam('inPhotoName', ftString, ptInput, FieldByName('GUID').AsString);
          UploadStoredProc.Params.AddParam('inComment', ftString, ptInput, FieldByName('COMMENT').AsString);
          UploadStoredProc.Params.AddParam('inGPSN', ftFloat, ptInput, FieldByName('GPSN').AsFloat);
          UploadStoredProc.Params.AddParam('inGPSE', ftFloat, ptInput, FieldByName('GPSE').AsFloat);
          UploadStoredProc.Params.AddParam('inAddressByGPS', ftString, ptInput, FieldByName('AddressByGPS').AsString);
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

          Next;
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
    FAllMax := FAllMax + 9;  // Количесто операций при сохранении данных в центр

  Synchronize(procedure
              begin
                frmMain.pProgress.Visible := true;
                frmMain.vsbMain.Enabled := false;
              end);

  ProgressThread := TProgressThread.Create(true);
  try
    ProgressThread.FreeOnTerminate := true;
    ProgressThread.Start;

    { загрузка данных в центр }
    if UploadData and (DM.tblObject_Const.RecordCount > 0) then
    begin
      try
        if UploadTaskType in [uttAll, uttStoreReal] then
        begin
          SetNewProgressTask('Сохранение остатков');
          SyncData.SyncStoreReal('');
        end;

        if UploadTaskType in [uttAll, uttOrderExternal] then
        begin
          SetNewProgressTask('Сохранение заявок');
          SyncData.SyncOrderExternal('');
        end;

        if UploadTaskType in [uttAll, uttReturnIn] then
        begin
          SetNewProgressTask('Сохранение возвратов');
          SyncData.SyncReturnIn('');
        end;

        if UploadTaskType in [uttAll, uttCash] then
        begin
          SetNewProgressTask('Сохранение оплат');
          UploadCash;
        end;

        if UploadTaskType in [uttAll, uttTasks] then
        begin
          SetNewProgressTask('Сохранение заданий');
          UploadTasks;
        end;

        if UploadTaskType in [uttAll, uttPartnerGPS] then
        begin
          SetNewProgressTask('Сохранение координат ТТ');
          UploadPartnerGPS;
        end;

        if UploadTaskType in [uttAll, uttRouteMember] then
        begin
          SetNewProgressTask('Сохранение маршрута');
          UploadRouteMember;
        end;

        if UploadTaskType in [uttAll, uttPhotos] then
        begin
          SetNewProgressTask('Сохранение фотографий');
          UploadPhotos;
        end;

        if UploadTaskType in [uttAll, uttNewPartners] then
        begin
          SetNewProgressTask('Сохранение новых ТТ');
          UploadNewPartners;
        end;

        SyncDataOut := Now();
        SyncData.SaveSyncDataOut(SyncDataOut);
      except
        on E : Exception do
        begin
          Res := E.Message;
        end;
      end;
    end;

    { получение данных из центра }
    if LoadData then
    begin
      Synchronize(procedure
                  begin
                    DataSetCache.Clear;
                  end);

      Synchronize(GetSyncDates);

      DM.conMain.TxOptions.AutoCommit := false;
      DM.conMain.StartTransaction;
      try
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

        SetNewProgressTask('Загрузка торговых марок');
        GetDictionaries('TradeMark');

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

        SetNewProgressTask('Загрузка оснований возврата');
        GetDictionaries('SubjectDoc');

        SyncDataIn := Now();
        DM.tblObject_Const.Edit;
        DM.tblObject_ConstSyncDateIn.AsDateTime := SyncDataIn;
        DM.tblObject_Const.Post;

        SaveSyncDataIn(SyncDataIn);

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
  finally
    ProgressThread.Terminate;

    if Res = '' then
    begin
      SetNewProgressTask('Синхронизация завершена');
      sleep(1000);

      Synchronize(procedure
                  begin
                    frmMain.pProgress.Visible := False;
                    frmMain.vsbMain.Enabled := True;

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
                    frmMain.pProgress.Visible := False;
                    frmMain.vsbMain.Enabled := True;
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
          EndRemains := EndRemains + FieldByName('EndRemains').AsFloat;

          if FieldByName('InvNumber').AsString <> '' then
          begin
            DM.cdsJuridicalCollation.Append;

            DM.cdsJuridicalCollationDocId.AsInteger := FieldByName('MovementId').AsInteger;
            DM.cdsJuridicalCollationDocNum.AsString := FieldByName('InvNumber').AsString;
            DM.cdsJuridicalCollationDocType.AsString := FieldByName('ItemName').AsString;
            DM.cdsJuridicalCollationDocDate.AsDateTime := FieldByName('OperDate').AsDateTime;
            DM.cdsJuridicalCollationPaidKind.AsString := FieldByName('PaidKindName').AsString;
            DM.cdsJuridicalCollationFromName.AsString := FieldByName('FromName').AsString;
            DM.cdsJuridicalCollationToName.AsString := FieldByName('ToName').AsString;

            if FieldByName('Debet').AsFloat <> 0 then
            begin
              DM.cdsJuridicalCollationDebet.AsString := FormatFloat(',0.00', FieldByName('Debet').AsFloat);
              DM.cdsJuridicalCollationFromToName.AsString := 'От кого: ' + DM.cdsJuridicalCollationFromName.AsString;
            end
            else
              DM.cdsJuridicalCollationDebet.AsString := '';
            if FieldByName('Kredit').AsFloat <> 0 then
            begin
              DM.cdsJuridicalCollationKredit.AsString := FormatFloat(',0.00', FieldByName('Kredit').AsFloat);
              DM.cdsJuridicalCollationFromToName.AsString := 'Кому: ' + DM.cdsJuridicalCollationToName.AsString;
            end
            else
              DM.cdsJuridicalCollationKredit.AsString := '';

            DM.cdsJuridicalCollationDocNumDate.AsString := 'Документ №' + DM.cdsJuridicalCollationDocNum.AsString +
              ' от ' + FormatDateTime('DD.MM.YYYY', DM.cdsJuridicalCollationDocDate.AsDateTime);
            DM.cdsJuridicalCollationDocTypeShow.AsString := 'Вид: ' + DM.cdsJuridicalCollationDocType.AsString;
            DM.cdsJuridicalCollationPaidKindShow.AsString := 'Форма оплаты: ' + DM.cdsJuridicalCollationPaidKind.AsString;

            DM.cdsJuridicalCollation.Post;

            TotalDebit := TotalDebit + FieldByName('Debet').AsFloat;
            TotalKredit := TotalKredit + FieldByName('Kredit').AsFloat;
          end;

          Next;
        end;

        DM.cdsJuridicalCollation.First;
      end;

      Synchronize(procedure
          begin
            frmMain.lStartRemains.Text := 'Сальдо на начало периода: ' + FormatFloat(',0.00', StartRemains);
            frmMain.lEndRemains.Text := 'Сальдо на конец периода: ' + FormatFloat(',0.00', EndRemains);
            frmMain.lTotalDebit.Text := FormatFloat(',0.00', TotalDebit);
            frmMain.lTotalKredit.Text := FormatFloat(',0.00', TotalKredit);

            frmMain.lwJuridicalCollation.ScrollViewPos := 0;
          end);
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

function TWaitThread.LoadJuridicalCollationDoc: string;
var
  HeaderProc, ItemsProc: TdsdStoredProc;
  ContractNumber, ContractTagName, PartnerName: string;
  isPriceWithVAT: Boolean;
  TotalCountKg, TotalSummPVAT, TotalSumm, ChangePercent: Currency;
begin
  Result := '';

  DM.cdsJuridicalCollationDocItems.DisableControls;

  HeaderProc := TdsdStoredProc.Create(nil);
  try
    HeaderProc.StoredProcName := 'gpReportMobile_JuridicalCollationDocHeader';
    HeaderProc.OutputType := otDataSet;
    HeaderProc.DataSet := TClientDataSet.Create(nil);
    HeaderProc.Params.AddParam('inMovementId', ftInteger, ptInput, DocId);

    try
      HeaderProc.Execute(False, False, True);

      with HeaderProc.DataSet do
      begin
        ContractNumber := FieldByName('ContractNumber').AsString;
        ContractTagName := FieldByName('ContractTagName').AsString;
        PartnerName := FieldByName('PartnerName').AsString;
        isPriceWithVAT := FieldByName('isPriceWithVAT').AsBoolean;
        TotalCountKg := FieldByName('TotalCountKg').AsCurrency;
        TotalSummPVAT := FieldByName('TotalSummPVAT').AsCurrency;
        TotalSumm := FieldByName('TotalSumm').AsCurrency;
        ChangePercent := FieldByName('ChangePercent').AsCurrency;
      end;

      ItemsProc := TdsdStoredProc.Create(nil);
      ItemsProc.StoredProcName := 'gpReportMobile_JuridicalCollationDocItems';
      ItemsProc.OutputType := otDataSet;
      ItemsProc.DataSet := TClientDataSet.Create(nil);
      ItemsProc.Params.AddParam('inMovementId', ftInteger, ptInput, DocId);
      ItemsProc.Execute(False, False, True);

      with ItemsProc.DataSet do
      begin
        First;

        while not Eof do
        begin
          DM.cdsJuridicalCollationDocItems.Append;

          DM.cdsJuridicalCollationDocItemsDocId.AsInteger := FieldByName('MovementId').AsInteger;
          DM.cdsJuridicalCollationDocItemsDocItemId.AsInteger := FieldByName('MovementItemId').AsInteger;
          DM.cdsJuridicalCollationDocItemsGoodsId.AsInteger := FieldByName('GoodsId').AsInteger;
          DM.cdsJuridicalCollationDocItemsGoodsCode.AsInteger := FieldByName('GoodsCode').AsInteger;
          DM.cdsJuridicalCollationDocItemsGoodsName.AsString := FieldByName('GoodsName').AsString;
          DM.cdsJuridicalCollationDocItemsGoodsKindId.AsInteger := FieldByName('GoodsKindId').AsInteger;
          DM.cdsJuridicalCollationDocItemsGoodsKindName.AsString := FieldByName('GoodsKindName').AsString;
          DM.cdsJuridicalCollationDocItemsPrice.AsFloat := FieldByName('Price').AsFloat;
          DM.cdsJuridicalCollationDocItemsAmount.AsFloat := FieldByName('Amount').AsFloat;
          DM.cdsJuridicalCollationDocItemsisPromo.AsBoolean := FieldByName('isPromo').AsBoolean;
          DM.cdsJuridicalCollationDocItemsGoodsFullName.AsString := FieldByName('GoodsCode').AsString + ' ' + FieldByName('GoodsName').AsString;
          DM.cdsJuridicalCollationDocItemsPromoText.AsString := '';

          if Trim(FieldByName('GoodsKindName').AsString) <> '' then
            DM.cdsJuridicalCollationDocItemsGoodsFullName.AsString :=
              DM.cdsJuridicalCollationDocItemsGoodsFullName.AsString + ' (' + FieldByName('GoodsKindName').AsString + ')';

          if FieldByName('isPromo').AsBoolean then
            DM.cdsJuridicalCollationDocItemsPromoText.AsString := 'Акция!';

          DM.cdsJuridicalCollationDocItemsPriceText.AsString := FormatFloat('0.00#', FieldByName('Price').AsFloat);
          DM.cdsJuridicalCollationDocItemsAmountText.AsString := FormatFloat('0.00', FieldByName('Amount').AsFloat);

          DM.cdsJuridicalCollationDocItems.Post;

          Next;
        end;

        DM.cdsJuridicalCollationDocItems.First;
      end;

      Synchronize(procedure
          begin
            frmMain.lDocContract.Text := Format(sContract, [ContractNumber, ContractTagName]);
            frmMain.lDocPartnerName.Text := PartnerName;
            frmMain.lDocInfo.Text := frmMain.lDocInfo.Text + '; ' + IfThen(isPriceWithVAT, sPriceWithVAT, sPriceWithoutVAT);
            frmMain.lTotalPriceDoc.Text := Format('%s : ', [sTotalCostWithVAT]) +
              FormatFloat(',0.00', TotalSummPVAT);
            frmMain.lPriceWithPercentDoc.Text := Format('%s (', [sCostWithDiscount]) +
              FormatFloat(',0.00', -ChangePercent) + '%) : ' + FormatFloat(',0.00', TotalSumm);
            frmMain.lTotalWeightDoc.Text := Format('%s : ', [sTotalWeight]) +
              FormatFloat(',0.00', TotalCountKg);
            frmMain.lwJuridicalCollationItems.ScrollViewPos := 0;
          end);
    except
      on E: Exception do
      begin
        Result := GetTextMessage(E);
      end;
    end;
  finally
    FreeAndNil(ItemsProc);
    FreeAndNil(HeaderProc);
    DM.cdsJuridicalCollationDocItems.EnableControls;
  end;
end;

{ получение новой версии программы }
function TWaitThread.UpdateProgram: string;
var
  GetStoredProc : TdsdStoredProc;
  ApplicationName: string;
  BytesStream: TBytesStream;
  {$IFDEF ANDROID}
  intent: JIntent;
  uri: Jnet_Uri;
  LAuthority: JString;
  lfile: JFile;
  {$ENDIF}
begin
  Result := '';

  ApplicationName := DM.tblObject_ConstMobileAPKFileName.AsString;

  GetStoredProc := TdsdStoredProc.Create(nil);
  BytesStream := TBytesStream.Create;
  try
    GetStoredProc.StoredProcName := 'gpGet_Object_Program';
    GetStoredProc.OutputType := otBlob;
    GetStoredProc.Params.AddParam('inProgramName', ftString, ptInput, ApplicationName);
    try
      ReConvertConvertStream(GetStoredProc.Execute(false, false, false), BytesStream);

      if BytesStream.Size = 0 then
      begin
        Result := 'Новая версия программы не загружена из базы данных';
        exit;
      end;

      BytesStream.Position := 0;
      {$IFDEF ANDROID}
      BytesStream.SaveToFile(TPath.Combine(TPath.GetSharedDownloadsPath, ApplicationName));
      {$ELSE}
      BytesStream.SaveToFile(ApplicationName);
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
    FreeAndNil(BytesStream);
  end;

  // Update programm
  {$IFDEF ANDROID}
  try
    Intent := TJIntent.Create;
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);

    lfile := TJFile.JavaClass.init(StringToJString(TPath.Combine(TPath.GetSharedDownloadsPath, ApplicationName)));
    LAuthority := TAndroidHelper.Context.getApplicationContext.getPackageName.concat(StringToJString('.fileprovider'));
    uri := TJContent_FileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, LAuthority, lfile);

    Intent.setDataAndType(uri, StringToJString('application/vnd.android.package-archive'));
    Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK
                 or TJIntent.JavaClass.FLAG_ACTIVITY_CLEAR_TOP
                 or TJIntent.JavaClass.FLAG_GRANT_WRITE_URI_PERMISSION
                 or TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);

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

function TWaitThread.ShowAllPartnerOnMap: string;
var
  Coordinates: TLocationCoord2D;
  AddressOnMap: string;
begin
  Result := '';

  frmMain.FMarkerList.Clear;

  with DM.qryPartner do
  begin
    DisableControls;
    First;

    while not EOF do
    begin
       if DM.qryPartnerShortAddress.AsString <> '' then
         AddressOnMap := DM.qryPartnerShortAddress.AsString
       else
         AddressOnMap := DM.qryPartnerAddress.AsString;

       if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
         frmMain.FMarkerList.Add(TLocationData.Create(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat, 0, AddressOnMap))
       else
       if frmMain.GetCoordinates(DM.qryPartnerAddress.AsString, Coordinates) then
         frmMain.FMarkerList.Add(TLocationData.Create(Coordinates.Latitude, Coordinates.Longitude, 0, AddressOnMap));

      Next;
    end;

    EnableControls;
  end;

  Synchronize(procedure
              begin
                LastDelimiter(' ', frmMain.lDayInfo.Text);
                if pos('Все ТТ', frmMain.lDayInfo.Text) = 0 then
                  frmMain.lCaption.Text := 'Карта (Все ТТ за ' + AnsiLowerCase(Copy(frmMain.lDayInfo.Text, LastDelimiter(' ', frmMain.lDayInfo.Text) + 1)) + ')'
                else
                  frmMain.lCaption.Text := 'Карта (Все ТТ)';

                frmMain.ShowBigMap;
              end);
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
    if TaskName = 'JuridicalCollationDocItems' then
    begin
      SetTaskName('Получение позиций по документу');
      Res := LoadJuridicalCollationDoc;
    end
    else
    if TaskName = 'UpdateProgram' then
    begin
      SetTaskName('Получение файла обновления');
      Res := UpdateProgram;
    end
    else
    if TaskName = 'ShowAllPartnerOnMap' then
    begin
      SetTaskName('Отображение всех ТТ на карте');
      Res := ShowAllPartnerOnMap;
    end;
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

function TDM.InsertOrderExternal(OperDate: TDateTime; Comment: string; PartnerId, PaidKindId, ContractId,
  PriceListId: Integer; PriceWithVAT: Boolean; VATPercent, ChangePercent, TotalWeight, TotalPrice: Currency;
  Complete: Boolean): Integer;
var
  GlobalId: TGUID;
begin
  tblMovement_OrderExternal.Append;

  CreateGUID(GlobalId);
  tblMovement_OrderExternalGUID.AsString := GUIDToString(GlobalId);
  tblMovement_OrderExternalInvNumber.AsString := GetInvNumber('Movement_OrderExternal');
  tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
  tblMovement_OrderExternalComment.AsString := Comment;

  if Complete then
    tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
  else
    tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;

  tblMovement_OrderExternalPartnerId.AsInteger := PartnerId;
  tblMovement_OrderExternalUnitId.AsInteger := tblObject_ConstUnitId.AsInteger;
  tblMovement_OrderExternalPaidKindId.AsInteger := PaidKindId;
  tblMovement_OrderExternalContractId.AsInteger := ContractId;
  tblMovement_OrderExternalPriceListId.AsInteger := PriceListId;
  tblMovement_OrderExternalPriceWithVAT.AsBoolean := PriceWithVAT;
  tblMovement_OrderExternalVATPercent.AsFloat := VATPercent;
  tblMovement_OrderExternalChangePercent.AsFloat := ChangePercent;
  tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
  tblMovement_OrderExternalTotalSumm.AsFloat := TotalPrice;
  tblMovement_OrderExternalInsertDate.AsDateTime := Now();
  tblMovement_OrderExternalisSync.AsBoolean := false;

  tblMovement_OrderExternal.Post;
  {??? Возможно есть лучший способ получения значения Id новой записи }
  tblMovement_OrderExternal.Refresh;
  tblMovement_OrderExternal.Last;
  {???}
  Result := tblMovement_OrderExternalId.AsInteger;
end;

function TDM.InsertOrderExternalItem(MovementId, GoodsId, GoodsKindId: Integer; Amount, Price,
  ChangePercent: Currency): Integer;
var
  GlobalId: TGUID;
begin
  tblMovementItem_OrderExternal.Append;

  tblMovementItem_OrderExternalMovementId.AsInteger := MovementId;
  CreateGUID(GlobalId);
  tblMovementItem_OrderExternalGUID.AsString := GUIDToString(GlobalId);
  tblMovementItem_OrderExternalGoodsId.AsInteger := GoodsId;
  tblMovementItem_OrderExternalGoodsKindId.AsInteger := GoodsKindId;
  tblMovementItem_OrderExternalAmount.AsCurrency := Amount;
  tblMovementItem_OrderExternalPrice.AsCurrency := Price;
  tblMovementItem_OrderExternalChangePercent.AsCurrency := ChangePercent;

  tblMovementItem_OrderExternal.Post;
  {??? Возможно есть лучший способ получения значения Id новой записи }
  tblMovementItem_OrderExternal.Refresh;
  tblMovementItem_OrderExternal.Last;
  {???}
  Result := tblMovementItem_OrderExternalId.AsInteger;
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

//  try
//    conMain.Connected := True;
//  except
//    ON E: Exception DO
//    begin
//      if FileExists(conMain.Params.Values['Database']) and
//        (Pos('file is not a database', E.Message) > 0) then DeleteFile(conMain.Params.Values['Database']);
//    end;
//  end;
//  conMain.Connected := False;

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

  if tblObject_Const.Active then
    tblObject_Const.Close;

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
          TempTable.Close;
          freeAndNil(TempTable);

          if Error then
          begin
            conMain.ExecSQL('DROP TABLE IF EXISTS ' + T.TableName);
            conMain.ExecSQL('ALTER TABLE ' + TempTableName + ' RENAME TO ' + T.TableName);
          end
          else
          begin
            conMain.ExecSQL('DROP TABLE IF EXISTS ' + TempTableName);
          end;
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
  cdsJuridicalCollationDocItems.CreateDataSet;
  cdsTasks.CreateDataSet;

  IsUploadRouteMember := false;
end;

{ вычисление цены для товаров }
procedure TDM.qryCashCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('Name').AsString := 'Оплата от ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('OperDate').AsDateTime);

  DataSet.FieldByName('AmountShow').AsString := 'Сумма: ' + FormatFloat(',0.00', DataSet.FieldByName('Amount').AsFloat);

  if DataSet.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
    DataSet.FieldByName('Status').AsString := tblObject_ConstStatusName_Complete.AsString
  else
  if DataSet.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
    DataSet.FieldByName('Status').AsString := tblObject_ConstStatusName_UnComplete.AsString
  else
  if DataSet.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
    DataSet.FieldByName('Status').AsString := tblObject_ConstStatusName_Erased.AsString
  else
    DataSet.FieldByName('Status').AsString := 'Неизвестный';
end;

procedure TDM.qryCashDocsCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('Name').AsString := 'Оплата от ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('OperDate').AsDateTime);

  DataSet.FieldByName('AmountShow').AsString := 'Сумма: ' + FormatFloat(',0.00', DataSet.FieldByName('Amount').AsFloat);

  if DataSet.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
    DataSet.FieldByName('Status').AsString := tblObject_ConstStatusName_Complete.AsString
  else
  if DataSet.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
    DataSet.FieldByName('Status').AsString := tblObject_ConstStatusName_UnComplete.AsString
  else
  if DataSet.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
    DataSet.FieldByName('Status').AsString := tblObject_ConstStatusName_Erased.AsString
  else
    DataSet.FieldByName('Status').AsString := 'Неизвестный';


end;

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

  DataSet.FieldByName('FullGoodsName').AsString := DataSet.FieldByName('ObjectCode').AsString + ' ' +
    DataSet.FieldByName('GoodsName').AsString;
end;

procedure TDM.qryGoodsFullForPriceListCalcFields(DataSet: TDataSet);
var
  OrderPriceWithoutVat, OrderPriceWithVat,
  SalePriceWithoutVat, SalePriceWithVat,
  ReturnPriceWithoutVat, ReturnPriceWithVat : string;
begin
  if qryPriceListPriceWithVAT.AsBoolean then
  begin
    OrderPriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('OrderPrice').AsFloat * 100 / (100 + qryPriceListVATPercent.AsFloat));
    OrderPriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('OrderPrice').AsFloat);
    SalePriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('SalePrice').AsFloat * 100 / (100 + qryPriceListVATPercent.AsFloat));
    SalePriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('SalePrice').AsFloat);
    ReturnPriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('ReturnPrice').AsFloat * 100 / (100 + qryPriceListVATPercent.AsFloat));
    ReturnPriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('ReturnPrice').AsFloat);
  end
  else
  begin
    OrderPriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('OrderPrice').AsFloat);
    OrderPriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('OrderPrice').AsFloat * (100 + qryPriceListVATPercent.AsFloat) / 100);
    SalePriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('SalePrice').AsFloat);
    SalePriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('SalePrice').AsFloat * (100 + qryPriceListVATPercent.AsFloat) / 100);
    ReturnPriceWithoutVat := FormatFloat(',0.00', DataSet.FieldByName('ReturnPrice').AsFloat);
    ReturnPriceWithVat := FormatFloat(',0.00', DataSet.FieldByName('ReturnPrice').AsFloat * (100 + qryPriceListVATPercent.AsFloat) / 100);
  end;

  DataSet.FieldByName('OrderFullPrice').AsString := 'Цена заявки: ' + OrderPriceWithoutVat +' (с НДС ' + OrderPriceWithVat +
    ') за ' + DataSet.FieldByName('Measure').AsString;
  DataSet.FieldByName('SaleFullPrice').AsString := 'Цена отгрузки: ' + SalePriceWithoutVat +' (с НДС ' + SalePriceWithVat +
    ') за ' + DataSet.FieldByName('Measure').AsString;
  DataSet.FieldByName('ReturnFullPrice').AsString := 'Цена возврата: ' + ReturnPriceWithoutVat +' (с НДС ' + ReturnPriceWithVat +
    ') за ' + DataSet.FieldByName('Measure').AsString;

  DataSet.FieldByName('OrderTermin').AsString := ' действительна с ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('OrderStartDate').AsDateTime) + ' по ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('OrderEndDate').AsDateTime);
  DataSet.FieldByName('SaleTermin').AsString := ' действительна с ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('SaleStartDate').AsDateTime) + ' по ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('SaleEndDate').AsDateTime);
  DataSet.FieldByName('ReturnTermin').AsString := ' действительна с ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('ReturnStartDate').AsDateTime) + ' по ' + FormatDateTime('DD.MM.YYYY', DataSet.FieldByName('ReturnEndDate').AsDateTime);

  DataSet.FieldByName('FullGoodsName').AsString := DataSet.FieldByName('ObjectCode').AsString + ' ' +
    DataSet.FieldByName('GoodsName').AsString;
end;

procedure TDM.qryPartnerCalcFields(DataSet: TDataSet);
var
  ContractInfo: string;
begin
  DataSet.FieldByName('FullName').AsString := DataSet.FieldByName('Name').AsString + sLineBreak +
    DataSet.FieldByName('Address').AsString;

  // информация о долгах ТТ
  if DataSet.FieldByName('PaidKindId').AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger then // БН
  begin
    ContractInfo := DM.tblObject_ConstPaidKindName_First.AsString + ' : ' + DataSet.FieldByName('ContractName').AsString +
      '  долг : ' + FormatFloat(',0.##', DM.qryPartnerDebtSumJ.AsFloat) +
      ' : ' + FormatFloat(',0.##', DM.qryPartnerOverSumJ.AsFloat) +
      ' : ' + DM.qryPartnerOverDaysJ.AsString + ' дн';

    DataSet.FieldByName('FullName').AsString := DataSet.FieldByName('FullName').AsString + sLineBreak +
      DM.tblObject_ConstPaidKindName_First.AsString + ' : ' + DataSet.FieldByName('ContractName').AsString;
  end else
  if DM.qryPartnerPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_Second.AsInteger then // Нал
  begin
    ContractInfo := DM.tblObject_ConstPaidKindName_Second.AsString + ' : ' + DataSet.FieldByName('ContractName').AsString +
      '  долг : ' + FormatFloat(',0.##', DM.qryPartnerDebtSum.AsFloat) +
      ' : ' + FormatFloat(',0.##', DM.qryPartnerOverSum.AsFloat) +
      ' : ' + DM.qryPartnerOverDays.AsString + ' дн';

    DataSet.FieldByName('FullName').AsString := DataSet.FieldByName('FullName').AsString + sLineBreak +
      DM.tblObject_ConstPaidKindName_Second.AsString + ' : ' + DataSet.FieldByName('ContractName').AsString;
  end else  // нет договора
  begin
    ContractInfo := DataSet.FieldByName('ContractName').AsString;

    DataSet.FieldByName('FullName').AsString := DataSet.FieldByName('FullName').AsString + sLineBreak +
      DataSet.FieldByName('ContractName').AsString;
  end;

  if DataSet.FieldByName('ChangePercent').AsFloat < -0.0001 then
    ContractInfo := ContractInfo + '; скидка: ' + FormatFloat(',0.##', Abs(DataSet.FieldByName('ChangePercent').AsFloat)) + '%';

  DataSet.FieldByName('ContractInfo').AsString := ContractInfo;
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

procedure TDM.qryPromoGoodsCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('FullGoodsName').AsString := DataSet.FieldByName('ObjectCode').AsString + ' ' +
    DataSet.FieldByName('GoodsName').AsString;
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
function TDM.UpdateOrderExternal(Id: Integer; OperDate: TDateTime; Comment: string; PaidKindId: Integer;
  PriceWithVAT: Boolean; VATPercent, ChangePercent, TotalWeight, TotalPrice: Currency; Complete: Boolean;
  var ErrorMessage: string): Integer;
begin
  ErrorMessage := '';
  Result := Id;

  if tblMovement_OrderExternal.Locate('Id', Id) then
  begin
    tblMovement_OrderExternal.Edit;

    tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
    tblMovement_OrderExternalComment.AsString := Comment;

    if Complete then
      tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
    else
      tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;

    tblMovement_OrderExternalUnitId.AsInteger := tblObject_ConstUnitId.AsInteger;
    tblMovement_OrderExternalPaidKindId.AsInteger := PaidKindId;
    tblMovement_OrderExternalPriceWithVAT.AsBoolean := PriceWithVAT;
    tblMovement_OrderExternalVATPercent.AsFloat := VATPercent;
    tblMovement_OrderExternalChangePercent.AsFloat := ChangePercent;
    tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
    tblMovement_OrderExternalTotalSumm.AsFloat := TotalPrice;

    tblMovement_OrderExternal.Post;

    Result := cdsOrderExternalId.AsInteger;
  end else
    ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка';
end;

procedure TDM.UpdateOrderExternalItem(MovementItemId: Integer; Amount, Price, ChangePercent: Currency);
begin
  if tblMovementItem_OrderExternal.Locate('Id', MovementItemId) then
  begin
    tblMovementItem_OrderExternal.Edit;

    tblMovementItem_OrderExternalAmount.AsCurrency := Amount;
    tblMovementItem_OrderExternalPrice.AsCurrency := Price;
    tblMovementItem_OrderExternalChangePercent.AsCurrency := ChangePercent;

    tblMovementItem_OrderExternal.Post;
  end;
end;

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

procedure TDM.ShowAllPartnerOnMap;
begin
  WaitThread := TWaitThread.Create(true);
  WaitThread.FreeOnTerminate := true;
  WaitThread.TaskName := 'ShowAllPartnerOnMap';
  WaitThread.Start;
end;

{ Загрузка с сервера констант и системной информации }
function TDM.GetConfigurationInfo: boolean;
var
  x, y : integer;
  GetStoredProc : TdsdStoredProc;
  Mapping : array of array[1..2] of integer;
  OldSyncDateIn, OldSyncDateOut: TDateTime;
begin
  Result := true;

  GetStoredProc := TdsdStoredProc.Create(nil);
  try
    GetStoredProc.StoredProcName := 'gpGetMobile_Object_Const';
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);
    try
      GetStoredProc.Execute(false, false, false);

      if GetStoredProc.DataSet.RecordCount > 0 then
      begin
        tblObject_Const.First;
        FOldLogin := tblObject_ConstUserLogin.AsString;
        OldSyncDateIn := tblObject_ConstSyncDateIn.AsDateTime;
        OldSyncDateOut := tblObject_ConstSyncDateOut.AsDateTime;

        while not tblObject_Const.Eof do
          tblObject_Const.Delete;

        SetLength(Mapping, 0);
        for x := 0 to tblObject_Const.Fields.Count - 1 do
          for y := 0 to GetStoredProc.DataSet.Fields.Count - 1 do
            if CompareText(tblObject_Const.Fields[x].FieldName, GetStoredProc.DataSet.Fields[y].FieldName) = 0 then
            begin
              SetLength(Mapping, Length(Mapping) + 1);

              Mapping[Length(Mapping) - 1][1] := x;
              Mapping[Length(Mapping) - 1][2] := y;

              break;
            end;

        tblObject_Const.Append;

        for x := 0 to Length(Mapping) - 1 do
          tblObject_Const.Fields[ Mapping[x][1] ].Value := GetStoredProc.DataSet.Fields[ Mapping[x][2] ].Value;

        tblObject_ConstSyncDateIn.AsDateTime := OldSyncDateIn;
        tblObject_ConstSyncDateOut.AsDateTime := OldSyncDateOut;

        tblObject_Const.Post;

        if tblObject_ConstStatusId_Complete.IsNull or tblObject_ConstUserLogin.IsNull or
           tblObject_ConstMobileAPKFileName.IsNull or tblObject_ConstPaidKindId_First.IsNull or
           tblObject_ConstPaidKindId_Second.IsNull or tblObject_ConstPriceListId_def.IsNull or
           tblObject_ConstStatusId_UnComplete.IsNull or tblObject_ConstStatusId_Erased.IsNull or
           tblObject_ConstMobileVersion.IsNull or tblObject_ConstPersonalId.IsNull then
        begin
          Result := false;
          ShowMessage('Получена неполная системная информация. Работа невозможна.');
        end else if Length(gc_WebServers) = 0 then
        begin
          if (DM.tblObject_Const.RecordCount > 0) and (DM.tblObject_ConstWebService.AsString <> '') then
          begin
            SetLength(gc_WebServers, 1);

            if DM.tblObject_ConstWebService_two.AsString <> '' then
              SetLength(gc_WebServers, 2);

            if DM.tblObject_ConstWebService_three.AsString <> '' then
              SetLength(gc_WebServers_r, 1);

            if DM.tblObject_ConstWebService_four.AsString <> '' then
              SetLength(gc_WebServers_r, 2);

            gc_WebServers[0] := DM.tblObject_ConstWebService.AsString;

            if DM.tblObject_ConstWebService_two.AsString <> '' then
              gc_WebServers[1] := DM.tblObject_ConstWebService_two.AsString;

            if DM.tblObject_ConstWebService_three.AsString <> '' then
              gc_WebServers_r[0] := DM.tblObject_ConstWebService_three.AsString;

            if DM.tblObject_ConstWebService_four.AsString <> '' then
              gc_WebServers_r[1] := DM.tblObject_ConstWebService_four.AsString;

            gc_WebService := gc_WebServers[0];
          end
        end;
      end
      else
      begin
        Result := false;
        ShowMessage('Нет данных для Констант. Работа невозможна.');
      end;
    except
      on E : Exception do
      begin
        Result := false;
        ShowMessage(E.Message);
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
  end;
end;

{ синхронизация данных с центральной БД }
procedure TDM.SynchronizeWithMainDatabase(LoadData: Boolean = True; UploadData: Boolean = True;
      UploadTaskType: TUploadTaskType = uttAll);
begin
  if gc_User.Local or (not LoadData and not UploadData) then
    Exit;

  // !!!Optimize!!!
  //frmMain.fOptimizeDB;

  SyncThread := TSyncThread.Create(True);
  SyncThread.FreeOnTerminate := True;
  SyncThread.LoadData := LoadData;
  SyncThread.UploadData := UploadData;
  SyncThread.UploadTaskType := UploadTaskType;
  SyncThread.Start;
end;

procedure TDM.SyncReturnIn(AMovementId: Integer);
begin
  tblMovement_ReturnIn.Open;
  if tblMovement_ReturnIn.Locate('Id', AMovementId) then
    if tblMovement_ReturnInStatusId.AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
    begin
      SyncData.SyncReturnIn(tblMovement_ReturnInGUID.AsString);
    end;
  tblMovement_ReturnIn.Close;
end;

{ получение уникального номера (каждый год начинается с 1) }
function TDM.GetInvNumber(ATableName: string): string;
var
  NewInvNumber: integer;
  qryMaxInvNumber: TFDQuery;
begin
  NewInvNumber := 1;

  qryMaxInvNumber := TFDQuery.Create(nil);
  try
    qryMaxInvNumber.Connection := conMain;
    try
      qryMaxInvNumber.Open('SELECT Max(cast(invNumber as Integer)) FROM ' + ATableName + ' WHERE strftime(''%Y'', InsertDate) = ' + QuotedStr(FormatDateTime('YYYY', Date())));
      if qryMaxInvNumber.RecordCount > 0 then
        NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
    except
    end;
  finally
    FreeAndNil(qryMaxInvNumber);
  end;

  Result := IntToStr(NewInvNumber);
end;

{ сохранение остатков }
function TDM.SaveStoreReal(Comment: string; DelItems : string; Complete: boolean;
  var ErrorMessage : string) : boolean;
var
  GlobalId: TGUID;
  MovementId: integer;
  NewInvNumber: string;
  b: TBookmark;
  isHasItems: boolean;
begin
  Result := false;

  // Проверяем есть ли "реальные" записи
  with cdsStoreRealItems do
  begin
    isHasItems := false;
    First;
    while not EOF do
    begin
      if FieldbyName('Count').AsFloat > 0 then
      begin
        isHasItems := true;
        break;
      end;

      Next;
    end;

    if not isHasItems then
    begin
      ErrorMessage := 'В остатках отсутствуют товары. Сохранение невозможно';
      exit;
    end;
  end;

  if cdsStoreRealsId.AsInteger = -1 then
    NewInvNumber := GetInvNumber('Movement_StoreReal')
  else
    NewInvNumber := '0';

  conMain.StartTransaction;
  try
    tblMovement_StoreReal.Open;

    if cdsStoreRealsId.AsInteger = -1  then
    begin
      tblMovement_StoreReal.Append;

      CreateGUID(GlobalId);
      tblMovement_StoreRealGUID.AsString := GUIDToString(GlobalId);
      tblMovement_StoreRealInvNumber.AsString := NewInvNumber;
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
        if FieldbyName('Count').AsFloat > 0 then
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
        end
        else
          if (FieldbyName('Id').AsInteger <> -1) and tblMovementItem_StoreReal.Locate('Id', FieldbyName('Id').AsInteger) then
            tblMovementItem_StoreReal.Delete;

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
    cdsStoreRealsPartnerFullName.AsString := qryPartnerFullName.AsString;

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
//or
//    qryStoreReals.SQL.Text := 'select ID, OPERDATE, COMMENT, ISSYNC, STATUSID' +
//      ' from Movement_StoreReal' +
//      ' where PARTNERID = ' + qryPartnerId.AsString +
//      ' order by OPERDATE desc';
//or
    qryStoreReals.SQL.Text :=
       ' SELECT '
     + '         Id '
     + '       , OperDate '
     + '       , Comment '
     + '       , isSync '
     + '       , StatusId '
     + ' FROM  Movement_StoreReal '
     + ' WHERE PartnerId = ' + qryPartnerId.AsString
     + ' ORDER BY OperDate desc ';

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
      cdsStoreRealsPartnerFullName.AsString := qryPartnerFullName.AsString;

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
//or
//    qryStoreReals.SQL.Text := 'select MSR.ID, MSR.OPERDATE, MSR.COMMENT, MSR.ISSYNC, MSR.STATUSID, ' +
//      'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS, PL.ID PRICELISTID ' +
//      'from Movement_StoreReal MSR ' +
//      'JOIN OBJECT_PARTNER P ON P.ID = MSR.PARTNERID ' +
//      'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
//      'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID, :DefaultPriceList) ' +
//      'WHERE DATE(MSR.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
//      'GROUP BY MSR.ID, MSR.PARTNERID order by PartnerName, Address asc, OPERDATE desc';
//or
    qryStoreReals.SQL.Text :=
       ' SELECT '
     + '         Movement_StoreReal.Id '
     + '       , Movement_StoreReal.OperDate '
     + '       , Movement_StoreReal.Comment '
     + '       , Movement_StoreReal.isSync '
     + '       , Movement_StoreReal.StatusId '
     + '       , Object_Partner.Id            AS PartnerId '
     + '       , Object_Juridical.ValueData   AS PartnerName '
     + '       , Object_Partner.Address '
     + '       , Object_PriceList.Id          AS PriceListId '
     + ' FROM  Movement_StoreReal '
     + '       JOIN Object_Partner          ON Object_Partner.Id           = Movement_StoreReal.PartnerId '
     + '       LEFT JOIN Object_Juridical   ON Object_Juridical.Id         = Object_Partner.JuridicalId  '
     + '                                   AND Object_Juridical.ContractId = Object_Partner.ContractId '
     + '       LEFT JOIN Object_PriceList   ON Object_PriceList.Id         = IFNULL(Object_Partner.PriceListId, :DefaultPriceList) '
     + ' WHERE DATE(Movement_StoreReal.OperDate) BETWEEN :STARTDATE AND :ENDDATE '
     + ' GROUP BY Movement_StoreReal.Id, Movement_StoreReal.PartnerId  '
     + ' ORDER BY PartnerName, Address asc, OperDate desc ';

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
      cdsStoreRealsPartnerFullName.AsString := cdsStoreRealsPartnerName.AsString + chr(13) + chr(10) +
        cdsStoreRealsAddress.AsString;

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
  cdsStoreRealItemsTradeMarkName.AsString := ArrValue[6]; // торговая марка

  cdsStoreRealItemsCount.AsString := ArrValue[7];         // количество по умолчанию

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

    {qryGoodsListSale.SQL.Text :=
      ' SELECT ' +
      '   ''-1;'' || Object_Goods.ID || '';'' || IFNULL(Object_GoodsKind.ID, 0) || '';'' || ' +
      '   CAST(Object_Goods.ObjectCode as varchar) || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || ' +
      '   IFNULL(Object_Measure.ValueData, ''-'') || '';'' || IFNULL(Object_TradeMark.ValueData, '''') || '';0'' AS GoodsInfo ' +
      ' FROM (SELECT Object_GoodsListSale.GoodsId ' +
      '            , Object_GoodsListSale.GoodsKindId ' +
      '       FROM Object_GoodsListSale ' +
      '       WHERE Object_GoodsListSale.PartnerId = ' + cdsStoreRealsPartnerId.AsString +
      '         AND Object_GoodsListSale.isErased = 0 ' +
      '       UNION ' +
      '       SELECT MovementItem_StoreReal.GoodsId ' +
      '            , MovementItem_StoreReal.GoodsKindId ' +
      '       FROM MovementItem_StoreReal ' +
      '       WHERE MovementItem_StoreReal.MovementId = (SELECT COALESCE ((SELECT Movement_StoreReal.Id ' +
      '                                                  FROM Movement_StoreReal ' +
      '                                                  WHERE Movement_StoreReal.OperDate < CURRENT_DATE ' +
      '                                                    AND Movement_StoreReal.PartnerId = ' + cdsStoreRealsPartnerId.AsString +
      '                                                  ORDER BY Movement_StoreReal.OperDate DESC ' +
      '                                                  LIMIT 1), 0) ' +
      '                                                 ) ' +
      '      ) AS tmpGoods ' +
      '      JOIN Object_Goods          ON tmpGoods.GoodsId    = Object_Goods.Id ' +
      '      LEFT JOIN Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId ' +
      '      LEFT JOIN Object_Measure   ON Object_Measure.Id   = Object_Goods.MeasureId ' +
      '      LEFT JOIN Object_TradeMark ON Object_TradeMark.Id = Object_Goods.TradeMarkId ' +
      ' ORDER BY Object_Goods.ValueData';}

    qryGoodsListSale.SQL.Text :=
       ' SELECT '
     + '       ''-1;'' || Object_Goods.ID || '';'' || IFNULL(Object_GoodsKind.ID, 0) || '';'' ||  '
     + '       CAST(Object_Goods.ObjectCode as varchar)  || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' ||  '
     + '       IFNULL(Object_Measure.ValueData, ''-'') || '';'' || IFNULL(Object_TradeMark.ValueData, '''') || '';0''  '
     + ' FROM  Object_GoodsListSale '
     + '       JOIN Object_Goods          ON Object_GoodsListSale.GoodsId = Object_Goods.ID '
     + '       LEFT JOIN Object_GoodsKind ON Object_GoodsKind.ID          = Object_GoodsListSale.GoodsKindId '
     + '       LEFT JOIN Object_Measure   ON Object_Measure.ID            = Object_Goods.MeasureId '
     + '       LEFT JOIN Object_TradeMark ON Object_TradeMark.ID          = Object_Goods.TradeMarkId '
     + ' WHERE Object_GoodsListSale.PartnerId = ' + cdsStoreRealsPartnerId.AsString
     + '       AND Object_GoodsListSale.isErased = 0 '
     + ' ORDER BY Object_Goods.ValueData ';

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
//or
//    qryGoodsListSale.SQL.Text := 'select ISR.ID || '';'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
//      'CAST(G.OBJECTCODE as varchar)  || '' '' || G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || ' +
//      'IFNULL(M.VALUEDATA, ''-'') || '';'' || IFNULL(T.VALUEDATA, '''') || '';'' || ISR.AMOUNT ' +
//      'from MOVEMENTITEM_STOREREAL ISR ' +
//      'JOIN OBJECT_GOODS G ON ISR.GOODSID = G.ID ' +
//      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = ISR.GOODSKINDID ' +
//      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//      'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//      'WHERE ISR.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';
//or
    qryGoodsListSale.SQL.Text :=
       ' SELECT  '
     + '       MovementItem_StoreReal.Id || '';'' || Object_Goods.Id || '';'' || IFNULL(Object_GoodsKind.Id, 0) || '';'' ||  '
     + '       CAST(Object_Goods.ObjectCode as varchar)  || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' ||  '
     + '       IFNULL(Object_Measure.ValueData, ''-'') || '';'' || IFNULL(Object_TradeMark.ValueData, '''') || '';'' || MovementItem_StoreReal.Amount  '
     + ' FROM MovementItem_StoreReal '
     + '      JOIN Object_Goods          ON MovementItem_StoreReal.GoodsId = Object_Goods.Id '
     + '      LEFT JOIN Object_GoodsKind ON Object_GoodsKind.Id            = MovementItem_StoreReal.GoodsKindId '
     + '      LEFT JOIN Object_Measure   ON Object_Measure.Id              = Object_Goods.MeasureId '
     + '      LEFT JOIN Object_TradeMark ON Object_TradeMark.Id            = Object_Goods.TradeMarkId '
     + ' WHERE MovementItem_StoreReal.MovementId = ' + IntToStr(AId)
     + ' ORDER BY Object_Goods.ValueData ';

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
var
  Params: TParams;
begin
  Params := TParams.Create(nil);
  Params.CreateParam(cdsReturnInPRICELISTID.DataType, 'PRICELISTID', ptInput).Value := cdsReturnInPRICELISTID.AsInteger;

  if DataSetCache.Find('StoreRealItemsList', Params) = nil then
  begin
    qryGoodsItems.SQL.Text :=
         ' SELECT '
       + '         Object_Goods.ID                  AS GoodsID '
       + '       , Object_GoodsKind.ID              AS KindID '
       + '       , Object_Goods.ObjectCode '
 //    + '       , Object_Goods.ValueData || '' '' || CAST(Object_Goods.ObjectCode as VarChar) AS GoodsName '
       + '       , Object_Goods.ValueData           AS GoodsName '
       + '       , Object_GoodsKind.ValueData       AS KindName '
       + '       , ''-''                            AS PromoPrice '
       + '       , Object_TradeMark.ValueData       AS TradeMarkName '
       + '       , Object_GoodsByGoodsKind.Remains '
       + '       , COALESCE(Object_PriceListItems.OrderPrice, Object_PriceListItems_two.OrderPrice, 0.0) AS Price '
       + '       , Object_Measure.ValueData         AS Measure '
       + '       , ''-1;'' || Object_Goods.ID || '';'' || IFNULL(Object_GoodsKind.ID, 0) || '';'' ||  '
       + '         Object_Goods.ObjectCode || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' ||  '
       + '         IFNULL(Object_Measure.ValueData, ''-'') || '';'' || IFNULL(Object_TradeMark.ValueData, ''-'') || '';0'' AS FullInfo '
       + '       , Object_Goods.ValueData || '';0'' AS SearchName '
       + '       , Object_Goods.ObjectCode || '' '' || Object_Goods.ValueData AS FullGoodsName '
       + ' FROM  Object_GoodsByGoodsKind '
       + '       LEFT JOIN Object_Goods ON Object_GoodsByGoodsKind.GoodsId   = Object_Goods.ID '
       + '       LEFT JOIN Object_GoodsKind        ON Object_GoodsKind.ID               = Object_GoodsByGoodsKind.GoodsKindId '
       + '       LEFT JOIN Object_Measure          ON Object_Measure.ID                 = Object_Goods.MeasureId '
       + '       LEFT JOIN Object_TradeMark        ON Object_TradeMark.ID               = Object_Goods.TradeMarkId '
       + '       LEFT JOIN Object_PriceListItems   ON Object_PriceListItems.GoodsId     = Object_Goods.ID  '
       + '                                        AND Object_PriceListItems.GoodsKindId = Object_GoodsByGoodsKind.GoodsKindId '
       + '                                        AND COALESCE(Object_GoodsByGoodsKind.GoodsKindId, 0) <> 0 '
       + '                                        AND Object_PriceListItems.PriceListId = :PRICELISTID '
       + '       LEFT JOIN Object_PriceListItems   AS Object_PriceListItems_two '
       + '                                         ON Object_PriceListItems_two.GoodsId     = Object_Goods.ID  '
       + '                                        AND Object_PriceListItems.GoodsId IS NULL '
       + '                                        AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
       + '                                        AND Object_PriceListItems_two.PriceListId = :PRICELISTID '
       + ' WHERE Object_GoodsByGoodsKind.isErased = 0  '
       + ' ORDER BY GoodsName ';

    qryGoodsItems.ParamByName('PRICELISTID').AsInteger := Params.ParamByName('PRICELISTID').AsInteger;
    qryGoodsItems.Open;

    DataSetCache.Add('StoreRealItemsList', Params, qryGoodsItems);
  end;

  Params.Free;
end;

{ сохранение заявки на товары в БД }
function TDM.SaveOrderExternal(OperDate: TDate; PaidKindId: integer; Comment: string;
  TotalPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string) : boolean;
var
  MovementId: integer;
  CurInvNumber: string;
  b: TBookmark;
  isHasItems: boolean;
  TotalW : Double;
begin
  Result := false;

  // Проверяем есть ли "реальные" записи
  with cdsOrderItems do
  begin
    isHasItems := false;
    TotalW:= 0;
    First;
    while not EOF do
    begin
      if FieldbyName('Count').AsFloat > 0 then
      begin
        isHasItems := true;
        if FieldbyName('Weight').AsFloat > 0
        then TotalW:= TotalW + FieldbyName('Count').AsFloat * FieldbyName('Weight').AsFloat
        else TotalW:= TotalW + FieldbyName('Count').AsFloat;
        //break;
      end;

      Next;
    end;

    if (Complete = TRUE) and (TotalW < DM.tblObject_ConstCriticalWeight.AsFloat)
       and ((cdsOrderExternalIsOrderMin.AsBoolean <> TRUE) or (cdsOrderExternalIsOrderMin.isNull = TRUE))
       and (Pos(AnsiUpperCase('самовывоз'),AnsiUpperCase(Comment)) = 0)
       and (Pos(AnsiUpperCase('самовивіз'),AnsiUpperCase(Comment)) = 0)
    then begin
      ErrorMessage := 'Разрешены заявки с общим весом >= ' + FloatToStr(DM.tblObject_ConstCriticalWeight.AsFloat) + ' кг. Сохранение заявки с весом = ' + FloatToStr(TotalW) + ' кг. невозможно.';
      exit;
    end;

    if not isHasItems then
    begin
      ErrorMessage := 'В заявке отсутствуют товары. Сохранение невозможно';
      exit;
    end;
  end;


  conMain.StartTransaction;
  try
    tblMovement_OrderExternal.Open;

    if cdsOrderExternalId.AsInteger = -1 then
      MovementId := InsertOrderExternal(OperDate, Comment, cdsOrderExternalPartnerId.AsInteger, PaidKindId,
        cdsOrderExternalCONTRACTID.AsInteger, cdsOrderExternalPRICELISTID.AsInteger,
        cdsOrderExternalPriceWithVAT.AsBoolean, cdsOrderExternalVATPercent.AsFloat,
        cdsOrderExternalChangePercent.AsFloat, TotalWeight, TotalPrice, Complete)
    else
    begin
      MovementId := UpdateOrderExternal(cdsOrderExternalId.AsInteger, OperDate, Comment, PaidKindId,
        cdsOrderExternalPriceWithVAT.AsBoolean, cdsOrderExternalVATPercent.AsFloat,
        cdsOrderExternalChangePercent.AsFloat, TotalWeight, TotalPrice, Complete, ErrorMessage);

      if ErrorMessage <> '' then
        Exit;
    end;

    CurInvNumber := tblMovement_OrderExternalInvNumber.AsString;

    tblMovementItem_OrderExternal.Open;

    with cdsOrderItems do
    begin
      First;
      while not EOF do
      begin
        if (FieldbyName('Count').AsFloat > 0) or (FieldbyName('RecommendCount').AsFloat > 0) then
        begin
          if FieldbyName('Id').AsInteger = -1 then // новая запись
            InsertOrderExternalItem(MovementId, FieldbyName('GoodsId').AsInteger, FieldbyName('KindID').AsInteger,
              FieldbyName('Count').AsCurrency, FieldbyName('Price').AsCurrency, cdsOrderExternalChangePercent.AsCurrency)
          else
            UpdateOrderExternalItem(FieldbyName('Id').AsInteger, FieldbyName('Count').AsCurrency,
              FieldbyName('Price').AsCurrency, cdsOrderExternalChangePercent.AsCurrency);
        end else
          if (FieldbyName('Id').AsInteger <> -1) and tblMovementItem_OrderExternal.Locate('Id', FieldbyName('Id').AsInteger) then
            tblMovementItem_OrderExternal.Delete;

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
      cdsOrderExternalPaidKindId.AsInteger := PaidKindId;
      cdsOrderExternalComment.AsString := Comment;
      cdsOrderExternalName.AsString := 'Заявка №' + CurInvNumber + ' на ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', TotalPrice);
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
var
  MovementId: Integer;
begin
  cdsOrderExternal.DisableControls;
  try
    cdsOrderExternal.First;
    cdsOrderExternal.Insert;

    cdsOrderExternalId.AsInteger := -1;
    cdsOrderExternalOperDate.AsDateTime := Date();
    cdsOrderExternalComment.AsString := '';
    cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', cdsOrderExternalOperDate.AsDateTime);
    cdsOrderExternalPrice.AsString :=  'Стоимость: 0';
    cdsOrderExternalWeight.AsString := 'Вес: 0';
    cdsOrderExternalStatus.AsString := tblObject_ConstStatusName_UnComplete.AsString;
    cdsOrderExternalStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
    cdsOrderExternalIsSync.AsBoolean := false;

    cdsOrderExternalPartnerId.AsInteger := qryPartnerId.AsInteger;
    cdsOrderExternalPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
    cdsOrderExternalContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
    cdsOrderExternalPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;
    cdsOrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
    cdsOrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
    cdsOrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
    cdsOrderExternalCalcDayCount.AsFloat := qryPartnerCalcDayCount.AsFloat;
    cdsOrderExternalOrderDayCount.AsFloat := qryPartnerOrderDayCount.AsFloat;
    cdsOrderExternalIsOperDateOrder.AsBoolean := qryPartnerIsOperDateOrder.AsBoolean;
    cdsOrderExternalIsOrderMin.AsBoolean := qryPartnerIsOrderMin.AsBoolean;
    cdsOrderExternalAddress.AsString := qryPartnerAddress.AsString;
    cdsOrderExternalPartnerName.AsString := qryPartnerName.AsString;
    cdsOrderExternalContractName.AsString := qryPartnerContractName.AsString;
    cdsOrderExternalPartnerFullName.AsString := qryPartnerFullName.AsString;

    cdsOrderExternal.Post;

    conMain.StartTransaction;
    try
      tblMovement_OrderExternal.Open;
      MovementId := InsertOrderExternal(cdsOrderExternalOperDate.AsDateTime, cdsOrderExternalComment.AsString,
        cdsOrderExternalPartnerId.AsInteger, cdsOrderExternalPaidKindId.AsInteger, cdsOrderExternalContractId.AsInteger,
        cdsOrderExternalPriceListId.AsInteger, cdsOrderExternalPriceWithVAT.AsBoolean, cdsOrderExternalVATPercent.AsCurrency,
        cdsOrderExternalChangePercent.AsCurrency, 0, 0, False);
      conMain.Commit;

      cdsOrderExternal.Edit;
      cdsOrderExternalId.AsInteger := MovementId;
      cdsOrderExternal.Post;
    except
      conMain.Rollback;
      raise;
    end;
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
//or
//    qryOrderExternal.SQL.Text := 'select ID, OPERDATE, PAIDKINDID, COMMENT, TOTALCOUNTKG, TOTALSUMM, ISSYNC, STATUSID' +
//      ' from MOVEMENT_ORDEREXTERNAL' +
//      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
//      ' order by OPERDATE desc';
//or
    qryOrderExternal.SQL.Text :=
       ' SELECT '
     + '         ID '
     + '       , InvNumber '
     + '       , OperDate '
     + '       , PaidKindId '
     + '       , Comment '
     + '       , TotalCountKg '
     + '       , TotalSumm '
     + '       , isSync '
     + '       , StatusId '
     + ' FROM  Movement_OrderExternal '
     + ' WHERE PartnerId = ' + qryPartnerId.AsString
     + '   AND ContractId = ' + qryPartnerContractId.AsString
     + ' ORDER BY OperDate desc ';

    qryOrderExternal.Open;

    qryOrderExternal.First;
    while not qryOrderExternal.EOF do
    begin
      cdsOrderExternal.Append;
      cdsOrderExternalid.AsInteger := qryOrderExternal.FieldByName('ID').AsInteger;
      cdsOrderExternalOperDate.AsDateTime := qryOrderExternal.FieldByName('OPERDATE').AsDateTime;
      cdsOrderExternalComment.AsString := qryOrderExternal.FieldByName('COMMENT').AsString;
      cdsOrderExternalName.AsString := 'Заявка №' + qryOrderExternal.FieldByName('INVNUMBER').AsString + ' на ' + FormatDateTime('DD.MM.YYYY', qryOrderExternal.FieldByName('OPERDATE').AsDateTime);
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
      cdsOrderExternalIsSync.AsBoolean := qryOrderExternal.FieldByName('ISSYNC').AsBoolean;

      cdsOrderExternalPartnerId.AsInteger := qryPartnerId.AsInteger;
      cdsOrderExternalPaidKindId.AsInteger := qryOrderExternal.FieldByName('PAIDKINDID').AsInteger;
      cdsOrderExternalContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      cdsOrderExternalPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;
      cdsOrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
      cdsOrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
      cdsOrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
      cdsOrderExternalCalcDayCount.AsFloat := qryPartnerCalcDayCount.AsFloat;
      cdsOrderExternalOrderDayCount.AsFloat := qryPartnerOrderDayCount.AsFloat;
      cdsOrderExternalIsOperDateOrder.AsBoolean := qryPartnerIsOperDateOrder.AsBoolean;
      cdsOrderExternalIsOrderMin.AsBoolean := qryPartnerIsOrderMin.AsBoolean;
      cdsOrderExternalAddress.AsString := qryPartnerAddress.AsString;
      cdsOrderExternalPartnerName.AsString := qryPartnerName.AsString;
      cdsOrderExternalContractName.AsString := qryPartnerContractName.AsString;
      cdsOrderExternalPartnerFullName.AsString := qryPartnerFullName.AsString;

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
//or
//    qryOrderExternal.SQL.Text := 'select MOE.ID, MOE.OPERDATE, MOE.PAIDKINDID, MOE.COMMENT, MOE.TOTALCOUNTKG, MOE.TOTALSUMM, MOE.ISSYNC, MOE.STATUSID, ' +
//      'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS, PL.ID PRICELISTID, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
//      'P.CONTRACTID, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, C.CHANGEPERCENT, ' +
//      'P.CalcDayCount, P.OrderDayCount, P.isOperDateOrder ' +
//      'from MOVEMENT_ORDEREXTERNAL MOE ' +
//      'JOIN OBJECT_PARTNER P ON P.ID = MOE.PARTNERID AND P.CONTRACTID = MOE.CONTRACTID ' +
//      'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
//      'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID, :DefaultPriceList) ' +
//      'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
//      'WHERE DATE(MOE.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
//      'GROUP BY MOE.ID, MOE.PARTNERID, MOE.CONTRACTID order by PartnerName, P.Address, P.ContractId asc, MOE.OPERDATE desc';
//or

    qryOrderExternal.SQL.Text :=
       ' SELECT '
     + '         Movement_OrderExternal.Id '
     + '       , Movement_OrderExternal.InvNumber '
     + '       , Movement_OrderExternal.OperDate '
     + '       , Movement_OrderExternal.PaidKindId '
     + '       , Movement_OrderExternal.Comment '
     + '       , Movement_OrderExternal.TotalCountKg '
     + '       , Movement_OrderExternal.TotalSumm '
     + '       , Movement_OrderExternal.isSync '
     + '       , Movement_OrderExternal.StatusId '
     + '       , Object_Partner.Id                         AS PartnerId '
     + '       , Object_Juridical.ValueData                AS PartnerName '
     + '       , Object_Partner.Address '
     + '       , Object_PriceList.Id                       AS PriceListId '
     + '       , Object_PriceList.PriceWithVAT '
     + '       , Object_PriceList.VATPercent '
     + '       , Object_Partner.ContractId '
     + '       , Object_Contract.ContractTagName || '' '' || Object_Contract.ValueData AS ContractName '
     + '       , Object_Contract.ChangePercent '
     + '       , Object_Partner.CalcDayCount '
     + '       , Object_Partner.OrderDayCount '
     + '       , Object_Partner.isOperDateOrder '
     + '       , Object_Partner.isOrderMin '
     + ' FROM  Movement_OrderExternal '
     + '       JOIN Object_Partner        ON Object_Partner.Id           = Movement_OrderExternal.PartnerId '
     + '                                 AND Object_Partner.ContractId   = Movement_OrderExternal.ContractId '
     + '       LEFT JOIN Object_Juridical ON Object_Juridical.Id         = Object_Partner.JuridicalId '
     + '                                 AND Object_Juridical.ContractId = Object_Partner.ContractId '
     + '       LEFT JOIN Object_PriceList ON Object_PriceList.Id         = IFNULL(Object_Partner.PriceListId, :DefaultPriceList) '
     + '       LEFT JOIN Object_Contract  ON Object_Contract.Id          = Object_Partner.ContractId '
     + ' WHERE DATE(Movement_OrderExternal.OperDate) BETWEEN :STARTDATE AND :ENDDATE '
     + ' GROUP BY Movement_OrderExternal.Id, Movement_OrderExternal.PartnerId, Movement_OrderExternal.ContractId  '
     + ' ORDER BY PartnerName, Object_Partner.Address, Object_Partner.ContractId asc, Movement_OrderExternal.OperDate desc ';
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
      cdsOrderExternalName.AsString := 'Заявка №' + qryOrderExternal.FieldByName('INVNUMBER').AsString + ' на ' + FormatDateTime('DD.MM.YYYY', qryOrderExternal.FieldByName('OPERDATE').AsDateTime);
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
      cdsOrderExternalIsSync.AsBoolean := qryOrderExternal.FieldByName('ISSYNC').AsBoolean;

      cdsOrderExternalPartnerId.AsInteger := qryOrderExternal.FieldByName('PartnerId').AsInteger;
      cdsOrderExternalPaidKindId.AsInteger := qryOrderExternal.FieldByName('PaidKindId').AsInteger;
      cdsOrderExternalContractId.AsInteger := qryOrderExternal.FieldByName('CONTRACTID').AsInteger;
      cdsOrderExternalPriceListId.AsInteger := qryOrderExternal.FieldByName('PRICELISTID').AsInteger;
      cdsOrderExternalPriceWithVAT.AsBoolean := qryOrderExternal.FieldByName('PriceWithVAT').AsBoolean;
      cdsOrderExternalVATPercent.AsFloat := qryOrderExternal.FieldByName('VATPercent').AsFloat;
      cdsOrderExternalChangePercent.AsFloat := qryOrderExternal.FieldByName('ChangePercent').AsFloat;
      cdsOrderExternalCalcDayCount.AsFloat := qryOrderExternal.FieldByName('CalcDayCount').AsFloat;
      cdsOrderExternalOrderDayCount.AsFloat := qryOrderExternal.FieldByName('OrderDayCount').AsFloat;
      cdsOrderExternalIsOperDateOrder.AsBoolean := qryOrderExternal.FieldByName('isOperDateOrder').AsBoolean;
      cdsOrderExternalIsOrderMin.AsBoolean := qryOrderExternal.FieldByName('isOrderMin').AsBoolean;
      cdsOrderExternalAddress.AsString := qryOrderExternal.FieldByName('Address').AsString;
      cdsOrderExternalPartnerName.AsString := qryOrderExternal.FieldByName('PartnerName').AsString;
      cdsOrderExternalContractName.AsString := qryOrderExternal.FieldByName('ContractName').AsString;

      // full name
      cdsOrderExternalPartnerFullName.AsString := cdsOrderExternalPartnerName.AsString + chr(13) + chr(10) +
        cdsOrderExternalAddress.AsString;
      if cdsOrderExternalPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger
      then // БН
        cdsOrderExternalPartnerFullName.AsString := cdsOrderExternalPartnerFullName.AsString + chr(13) + chr(10) +
          DM.tblObject_ConstPaidKindName_First.AsString + ' : ' + cdsOrderExternalContractName.AsString
      else
      if cdsOrderExternalPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_Second.AsInteger
      then // Нал
        cdsOrderExternalPartnerFullName.AsString := cdsOrderExternalPartnerFullName.AsString + chr(13) + chr(10) +
          DM.tblObject_ConstPaidKindName_Second.AsString + ' : ' + cdsOrderExternalContractName.AsString
      else  // нет договор
        cdsOrderExternalPartnerFullName.AsString := cdsOrderExternalPartnerFullName.AsString + chr(13) + chr(10) +
          cdsOrderExternalContractName.AsString;

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
  begin
    cdsOrderItemsRecommendCount.AsFloat := 0;
    cdsOrderItemsRecommend.AsString := '-';
  end
  else
  begin
    if StrToFloatDef(ArrValue[5], 0) - StrToFloatDef(ArrValue[6], 0) <= 0 then
    begin
      cdsOrderItemsRecommendCount.AsFloat := 0;
      cdsOrderItemsRecommend.AsString := '0';
    end
    else
    begin
      Recommend := (StrToFloatDef(ArrValue[5], 0) - StrToFloatDef(ArrValue[6], 0)) / cdsOrderExternalCalcDayCount.AsFloat *
        cdsOrderExternalOrderDayCount.AsFloat - StrToFloatDef(ArrValue[6], 0);
      if Recommend <= 0 then
      begin
        cdsOrderItemsRecommendCount.AsFloat := 0;
        cdsOrderItemsRecommend.AsString := '0';
      end
      else
      begin
        cdsOrderItemsRecommendCount.AsFloat := Recommend;
        cdsOrderItemsRecommend.AsString := FormatFloat(',0.00', Recommend);
      end;
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

  if DM.cdsOrderExternalPriceWithVAT.AsBoolean then
    cdsOrderItemsPriceShow.AsString := cdsOrderItemsPrice.AsString
  else
    cdsOrderItemsPriceShow.AsString := cdsOrderItemsPrice.AsString +
      ' (' +  FormatFloat(',0.00', cdsOrderItemsPrice.AsFloat * (100 + DM.cdsOrderExternalVATPercent.AsCurrency) / 100) + ')';

  cdsOrderItemsTradeMarkName.AsString := ArrValue[12];// торговая марка
  cdsOrderItemsCount.AsString := ArrValue[13];        // количество по умолчанию

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

    if cdsOrderExternalIsOperDateOrder.AsBoolean then
      PriceField := 'OrderPrice'
    else
      PriceField := 'SalePrice';

    if cdsOrderExternalPriceWithVAT.AsBoolean then
      PromoPriceField := 'PriceWithVAT'
    else
      PromoPriceField := 'PriceWithOutVAT';
//or
//    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
//      'CAST(G.OBJECTCODE as varchar)  || '' '' || G.VALUEDATA || '';'' || ' +
//      'IFNULL(GK.VALUEDATA, ''-'') || '';'' || GLS.AMOUNTCALC || '';'' || IFNULL(SRI.AMOUNT, 0) || '';'' || ' +
//      'IFNULL(PI.' + PriceField + ', 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || ' +
//      'IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';'' || ' +
//      'IFNULL(T.VALUEDATA, '''') || '';0''' +
//      'from OBJECT_GOODSLISTSALE GLS ' +
//      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
//      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID ' +
//      'LEFT JOIN MOVEMENT_STOREREAL SR ON SR.PARTNERID = :PARTNERID ' +
//      'AND DATE(SR.OPERDATE) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date())) + ' AND SR.STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
//      'LEFT JOIN MOVEMENTITEM_STOREREAL SRI ON SRI.GOODSID = G.ID AND SRI.GOODSKINDID = GK.ID AND SRI.MOVEMENTID = SR.ID ' +
//      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//      'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
//      'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
//      'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
//      'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
//      'WHERE GLS.PARTNERID = :PARTNERID and GLS.ISERASED = 0 order by G.VALUEDATA ';
//or
    qryGoodsListSale.SQL.Text :=
       ' SELECT '
     + '       ''-1;'' || Object_Goods.Id || '';'' || IFNULL(Object_GoodsKind.Id, 0) || '';'' ||  '
     + '       CAST(Object_Goods.ObjectCode as varchar)  || '' '' || Object_Goods.ValueData || '';'' ||  '
     + '       IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || Object_GoodsListSale.AmountCalc || '';'' || IFNULL(MovementItem_StoreReal.Amount, 0) || '';'' ||  '
     + '       IFNULL(COALESCE(Object_PriceListItems.' + PriceField + ', Object_PriceListItems_two.' + PriceField + '), 0) || '';'' || IFNULL(Object_Measure.ValueData, ''-'') || '';'' || Object_Goods.Weight || '';'' ||  '
     + '       IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(Movement_Promo.isChangePercent, 1) || '';'' ||  '
     + '       IFNULL(Object_TradeMark.ValueData, '''') || '';0'' '
     + ' FROM  Object_GoodsListSale  '
     + '       JOIN Object_Goods                   ON Object_GoodsListSale.GoodsId           = Object_Goods.Id  '
     + '       LEFT JOIN Object_GoodsKind          ON Object_GoodsKind.Id                    = Object_GoodsListSale.GoodsKindId  '
     + '       LEFT JOIN Movement_StoreReal        ON Movement_StoreReal.PartnerId           = :PARTNERID  '
     + '                                          AND DATE(Movement_StoreReal.OperDate)      = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date()))
     + '                                          AND Movement_StoreReal.StatusId           <> ' + tblObject_ConstStatusId_Erased.AsString
     + '       LEFT JOIN MovementItem_StoreReal    ON MovementItem_StoreReal.GoodsId         = Object_Goods.Id  '
     + '                                          AND MovementItem_StoreReal.GoodsKindId     = Object_GoodsKind.Id  '
     + '                                          AND MovementItem_StoreReal.MovementId      = Movement_StoreReal.Id '
     + '       LEFT JOIN Object_Measure            ON Object_Measure.Id                      = Object_Goods.MeasureId '
     + '       LEFT JOIN Object_TradeMark          ON Object_TradeMark.Id                    = Object_Goods.TradeMarkId '
     + '       LEFT JOIN Object_PriceListItems     ON Object_PriceListItems.GoodsId          = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsKindId      = Object_GoodsListSale.GoodsKindId '
     + '                                          AND COALESCE(Object_GoodsListSale.GoodsKindId, 0) <> 0 '
     + '                                          AND Object_PriceListItems.PriceListId = :PRICELISTID '
     + '       LEFT JOIN Object_PriceListItems     AS Object_PriceListItems_two '
     + '                                           ON Object_PriceListItems_two.GoodsId      = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsId IS NULL '
     + '                                          AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
     + '                                          AND Object_PriceListItems_two.PriceListId  = :PRICELISTID '
     + '       LEFT JOIN (SELECT MovementItem_PromoPartner.MovementId, MovementItem_PromoGoods.PriceWithVAT, MovementItem_PromoGoods.PriceWithOutVAT '
     + '                       , MovementItem_PromoGoods.GoodsId, MovementItem_PromoGoods.GoodsKindId '
     + '                  FROM MovementItem_PromoPartner  '
     + '                       JOIN MovementItem_PromoGoods ON MovementItem_PromoGoods.MovementId = MovementItem_PromoPartner.MovementId '
     + '                  WHERE MovementItem_PromoPartner.PartnerId   = :PARTNERID '
     + '                    AND (MovementItem_PromoPartner.ContractId  = :CONTRACTID '
     + '                      or MovementItem_PromoPartner.ContractId = 0) '
     + '                  ) as tmpPromo ON tmpPromo.GoodsId   = Object_Goods.Id '
     + '                               AND (tmpPromo.GoodsKindId   = Object_GoodsKind.Id  '
     + '                                 or tmpPromo.GoodsKindId  = 0) '
     + '       LEFT JOIN Movement_Promo            ON Movement_Promo.Id                      = tmpPromo.MovementId '
     + ' WHERE Object_GoodsListSale.PartnerId = :PARTNERID  '
     + '   AND Object_GoodsListSale.isErased  = 0  '
     + ' ORDER BY Object_Goods.ValueData ';

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

    if cdsOrderExternalIsOperDateOrder.AsBoolean then
      PriceField := 'OrderPrice'
    else
      PriceField := 'SalePrice';

    if cdsOrderExternalPriceWithVAT.AsBoolean then
      PromoPriceField := 'PriceWithVAT'
    else
      PromoPriceField := 'PriceWithOutVAT';
//or
//    qryGoodsListOrder.SQL.Text := 'select IEO.ID || '';'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
//      'CAST(G.OBJECTCODE as varchar)  || '' '' || G.VALUEDATA || '';'' || ' +
//      'IFNULL(GK.VALUEDATA, ''-'') || '';'' || 0 || '';'' || IFNULL(SRI.AMOUNT, 0) || '';'' || ' +
//      'IFNULL(PI.' + PriceField + ', 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || ' +
//      'IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';'' || ' +
//      'IFNULL(T.VALUEDATA, '''') || '';'' || IEO.AMOUNT ' +
//      'from MOVEMENTITEM_ORDEREXTERNAL IEO ' +
//      'JOIN OBJECT_GOODS G ON IEO.GOODSID = G.ID ' +
//      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = IEO.GOODSKINDID ' +
//      'LEFT JOIN MOVEMENT_STOREREAL SR ON SR.PARTNERID = :PARTNERID' +
//      ' AND DATE(SR.OPERDATE) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date())) + ' AND SR.STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
//      'LEFT JOIN MOVEMENTITEM_STOREREAL SRI ON SRI.GOODSID = G.ID AND SRI.GOODSKINDID = GK.ID AND SRI.MOVEMENTID = SR.ID ' +
//      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//      'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
//      'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
//      'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
//      'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
//      'WHERE IEO.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';
//or
    qryGoodsListOrder.SQL.Text :=
       ' SELECT '
     + '       MovementItem_OrderExternal.ID || '';'' || Object_Goods.ID || '';'' || IFNULL(Object_GoodsKind.ID, 0) || '';'' || '
     + '       CAST(Object_Goods.ObjectCode as varchar)  || '' '' || Object_Goods.ValueData || '';'' || '
     + '       IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || 0 || '';'' || IFNULL(MovementItem_StoreReal.Amount, 0) || '';'' || '
     + '       IFNULL(COALESCE(Object_PriceListItems.' + PriceField + ', Object_PriceListItems_two.' + PriceField + '), 0) || '';'' || IFNULL(Object_Measure.ValueData, ''-'') || '';'' || Object_Goods.Weight || '';'' || '
     + '       IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(Movement_Promo.isChangePercent, 1) || '';'' || '
     + '       IFNULL(Object_TradeMark.ValueData, '''') || '';'' || MovementItem_OrderExternal.Amount '
     + ' FROM  MovementItem_OrderExternal  '
     + '       JOIN Object_Goods                   ON MovementItem_OrderExternal.GoodsId     = Object_Goods.ID '
     + '       LEFT JOIN Object_GoodsKind          ON Object_GoodsKind.ID                    = MovementItem_OrderExternal.GoodsKindId '
     + '       LEFT JOIN Movement_StoreReal        ON Movement_StoreReal.PartnerId           = :PARTNERID '
     + '                                          AND DATE(Movement_StoreReal.OperDate)      = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date()))
     + '                                          AND Movement_StoreReal.STATUSID           <> ' + tblObject_ConstStatusId_Erased.AsString
     + '       LEFT JOIN MovementItem_StoreReal    ON MovementItem_StoreReal.GoodsId         = Object_Goods.ID  '
     + '                                          AND MovementItem_StoreReal.GoodsKindId     = Object_GoodsKind.ID  '
     + '                                          AND MovementItem_StoreReal.MovementId      = Movement_StoreReal.ID '
     + '       LEFT JOIN Object_Measure            ON Object_Measure.ID                      = Object_Goods.MeasureId '
     + '       LEFT JOIN Object_TradeMark          ON Object_TradeMark.ID                    = Object_Goods.TradeMarkId '
     + '       LEFT JOIN Object_PriceListItems     ON Object_PriceListItems.GoodsId          = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsKindId      = MovementItem_OrderExternal.GoodsKindId '
     + '                                          AND COALESCE(MovementItem_OrderExternal.GoodsKindId, 0) <> 0 '
     + '                                          AND Object_PriceListItems.PriceListId = :PRICELISTID '
     + '       LEFT JOIN Object_PriceListItems     AS Object_PriceListItems_two '
     + '                                           ON Object_PriceListItems_two.GoodsId      = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsId IS NULL '
     + '                                          AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
     + '                                          AND Object_PriceListItems_two.PriceListId  = :PRICELISTID '
     + '       LEFT JOIN (SELECT MovementItem_PromoPartner.MovementId, MovementItem_PromoGoods.PriceWithVAT, MovementItem_PromoGoods.PriceWithOutVAT '
     + '                       , MovementItem_PromoGoods.GoodsId, MovementItem_PromoGoods.GoodsKindId '
     + '                  FROM MovementItem_PromoPartner  '
     + '                       JOIN MovementItem_PromoGoods ON MovementItem_PromoGoods.MovementId = MovementItem_PromoPartner.MovementId '
     + '                  WHERE MovementItem_PromoPartner.PartnerId   = :PARTNERID '
     + '                    AND (MovementItem_PromoPartner.ContractId  = :CONTRACTID '
     + '                      or MovementItem_PromoPartner.ContractId = 0) '
     + '                  ) as tmpPromo ON tmpPromo.GoodsId   = Object_Goods.Id '
     + '                               AND (tmpPromo.GoodsKindId   = Object_GoodsKind.Id  '
     + '                                 or tmpPromo.GoodsKindId  = 0) '
     + '       LEFT JOIN Movement_Promo            ON Movement_Promo.ID = tmpPromo.MovementId '
     + ' WHERE MovementItem_OrderExternal.MovementId = ' + IntToStr(AId)
     + ' ORDER BY Object_Goods.ValueData ';


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
  Params: TParams;
begin
  if cdsOrderExternalIsOperDateOrder.AsBoolean then
    PriceField := 'OrderPrice'
  else
    PriceField := 'SalePrice';

  if cdsOrderExternalPriceWithVAT.AsBoolean then
    PromoPriceField := 'PriceWithVAT'
  else
    PromoPriceField := 'PriceWithOutVAT';

  Params := TParams.Create(nil);
  Params.CreateParam(ftString, 'PriceField', ptInput).Value := PriceField;
  Params.CreateParam(ftString, 'PromoPriceField', ptInput).Value := PromoPriceField;
  Params.CreateParam(cdsOrderExternalPartnerId.DataType, 'PARTNERID', ptInput).Value := cdsOrderExternalPartnerId.AsInteger;
  Params.CreateParam(cdsOrderExternalContractId.DataType, 'CONTRACTID', ptInput).Value := cdsOrderExternalContractId.AsInteger;
  Params.CreateParam(cdsOrderExternalPriceListId.DataType, 'PRICELISTID', ptInput).Value := cdsOrderExternalPriceListId.AsInteger;

  if DataSetCache.Find('OrderExtrenalItemsList', Params) = nil then
  begin
    qryGoodsItems.SQL.Text :=
         ' SELECT '
       + '         Object_Goods.ID                                     AS GoodsID '
       + '       , Object_GoodsKind.ID                                 AS KindID '
       + '       , Object_Goods.ObjectCode                             AS ObjectCode'
//     + '       , Object_Goods.ValueData    || '' '' || CAST(Object_Goods.ObjectCode as VarChar) AS GoodsName '
       + '       , Object_Goods.ValueData                              AS GoodsName '
       + '       , Object_GoodsKind.ValueData                          AS KindName '
       + '       , IFNULL(' + PromoPriceField + ' || '''', ''-'')      AS PromoPrice '
       + '       , Object_TradeMark.ValueData                          AS TradeMarkName '
       + '       , Object_GoodsByGoodsKind.Remains '
       + '       , COALESCE(Object_PriceListItems.' + PriceField + ', Object_PriceListItems_two.' + PriceField + ', 0.0) AS Price '
       + '       , Object_Measure.ValueData                            AS Measure '
       + '       , ''-1;'' || Object_Goods.ID || '';'' || IFNULL(Object_GoodsKind.ID, 0) || '';'' || '
       + '         CAST(Object_Goods.ObjectCode as VarChar) || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || 0 || '';'' || 0 || '';'' || '
       + '         IFNULL(COALESCE(Object_PriceListItems.' + PriceField + ', Object_PriceListItems_two.' + PriceField + '), ''0'') || '';'' || IFNULL(Object_Measure.ValueData, ''-'') || '';'' || Object_Goods.Weight || '';'' || '
       + '         IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(Movement_Promo.isChangePercent, 1) || '';'' || '
       + '         IFNULL(Object_TradeMark.ValueData, '''') || '';0''  AS FullInfo '
       + '       , CAST(Object_Goods.ObjectCode as VarChar) || '' '' || Object_Goods.ValueData || CASE WHEN ' + PromoPriceField + ' IS NULL THEN '';0'' ELSE '';1'' END  AS SearchName '
       + '       , CAST(Object_Goods.ObjectCode as VarChar) || '' '' || Object_Goods.ValueData AS FullGoodsName '
       + ' FROM  Object_GoodsByGoodsKind '
       + '       LEFT JOIN Object_Goods               ON Object_GoodsByGoodsKind.GoodsId        = Object_Goods.ID '
       + '       LEFT JOIN Object_GoodsKind           ON Object_GoodsKind.ID                    = Object_GoodsByGoodsKind.GoodsKindId '
       + '       LEFT JOIN Object_Measure             ON Object_Measure.ID                      = Object_Goods.MeasureId '
       + '       LEFT JOIN Object_TradeMark           ON Object_TradeMark.ID                    = Object_Goods.TradeMarkId '
       + '       LEFT JOIN Object_PriceListItems   ON Object_PriceListItems.GoodsId             = Object_Goods.ID  '
       + '                                        AND Object_PriceListItems.GoodsKindId         = Object_GoodsByGoodsKind.GoodsKindId '
       + '                                        AND COALESCE(Object_GoodsByGoodsKind.GoodsKindId, 0) <> 0 '
       + '                                        AND Object_PriceListItems.PriceListId = :PRICELISTID '
       + '       LEFT JOIN Object_PriceListItems   AS Object_PriceListItems_two '
       + '                                         ON Object_PriceListItems_two.GoodsId         = Object_Goods.ID  '
       + '                                        AND Object_PriceListItems.GoodsId IS NULL '
       + '                                        AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
       + '                                        AND Object_PriceListItems_two.PriceListId =   :PRICELISTID '
       + '       LEFT JOIN (SELECT MovementItem_PromoPartner.MovementId, MovementItem_PromoGoods.PriceWithVAT, MovementItem_PromoGoods.PriceWithOutVAT '
       + '                       , MovementItem_PromoGoods.GoodsId, MovementItem_PromoGoods.GoodsKindId '
       + '                  FROM MovementItem_PromoPartner  '
       + '                       JOIN MovementItem_PromoGoods ON MovementItem_PromoGoods.MovementId = MovementItem_PromoPartner.MovementId '
       + '                  WHERE MovementItem_PromoPartner.PartnerId   = :PARTNERID '
       + '                    AND (MovementItem_PromoPartner.ContractId  = :CONTRACTID '
       + '                      or MovementItem_PromoPartner.ContractId = 0) '
       + '                  ) as tmpPromo ON tmpPromo.GoodsId   = Object_Goods.Id '
       + '                               AND (tmpPromo.GoodsKindId   = Object_GoodsKind.Id  '
       + '                                 or tmpPromo.GoodsKindId  = 0) '
       + '       LEFT JOIN Movement_Promo             ON Movement_Promo.ID                      = tmpPromo.MovementId '
       + ' WHERE Object_GoodsByGoodsKind.isErased = 0 '
       + ' ORDER BY GoodsName ';

    qryGoodsItems.ParamByName('PARTNERID').AsInteger := Params.ParamByName('PARTNERID').AsInteger;
    qryGoodsItems.ParamByName('CONTRACTID').AsInteger := Params.ParamByName('CONTRACTID').AsInteger;
    qryGoodsItems.ParamByName('PRICELISTID').AsInteger := Params.ParamByName('PRICELISTID').AsInteger;
    qryGoodsItems.Open;

    DataSetCache.Add('OrderExtrenalItemsList', Params, qryGoodsItems);
  end;

  Params.Free;
end;

{ сохранение возвратов в БД }
function TDM.SaveReturnIn(OperDate: TDate; PaidKindId: integer; Comment : string; SubjectDocId : Integer; SubjectDocName : String;
  TotalPrice, TotalWeight: Currency; DelItems : string; Complete: boolean; var ErrorMessage : string;
  NowSync: Boolean = False) : boolean;
var
  GlobalId: TGUID;
  DocGUID: string;
  MovementId, MovementItemId: Integer;
  NewInvNumber, CurInvNumber: string;
  b: TBookmark;
  isHasItems: Boolean;
begin
  Result := False;

  // Проверяем есть ли "реальные" записи
  with cdsReturnInItems do
  begin
    isHasItems := False;
    First;
    while not Eof do
    begin
      if FieldbyName('Count').AsFloat > 0 then
      begin
        isHasItems := True;
        Break;
      end;

      Next;
    end;

    if not isHasItems then
    begin
      ErrorMessage := 'В возврате отсутствуют товары. Сохранение невозможно';
      Exit;
    end;
  end;

  if cdsReturnInId.AsInteger = -1 then
    NewInvNumber := GetInvNumber('Movement_ReturnIn')
  else
    NewInvNumber := '0';

  conMain.StartTransaction;
  try
    tblMovement_ReturnIn.Open;

    if cdsReturnInId.AsInteger = -1 then
    begin
      tblMovement_ReturnIn.Append;

      CreateGUID(GlobalId);
      tblMovement_ReturnInGUID.AsString := GUIDToString(GlobalId);
      tblMovement_ReturnInInvNumber.AsString := NewInvNumber;
      tblMovement_ReturnInOperDate.AsDateTime := OperDate;
      tblMovement_ReturnInComment.AsString := Comment;
      tblMovement_ReturnInSubjectDocId.AsInteger := SubjectDocId;
      if Complete then
        tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
      else
        tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
      tblMovement_ReturnInPartnerId.AsInteger := cdsReturnInPartnerId.AsInteger;
      tblMovement_ReturnInUnitId.AsInteger := tblObject_ConstUnitId_ret.AsInteger;
      tblMovement_ReturnInPaidKindId.AsInteger := PaidKindId;
      tblMovement_ReturnInContractId.AsInteger := cdsReturnInCONTRACTID.AsInteger;
      tblMovement_ReturnInPriceWithVAT.AsBoolean := cdsReturnInPriceWithVAT.AsBoolean;
      tblMovement_ReturnInVATPercent.AsFloat := cdsReturnInVATPercent.AsFloat;
      tblMovement_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
      tblMovement_ReturnInTotalCountKg.AsFloat := TotalWeight;
      tblMovement_ReturnInTotalSummPVAT.AsFloat := TotalPrice;
      tblMovement_ReturnInInsertDate.AsDateTime := Now();
      tblMovement_ReturnInisSync.AsBoolean := false;

      tblMovement_ReturnIn.Post;
      {??? Возможно есть лучший способ получения значения Id новой записи }
      tblMovement_ReturnIn.Refresh;
      tblMovement_ReturnIn.Last;
      {???}
      MovementId := tblMovement_ReturnInId.AsInteger;
      DocGUID := tblMovement_ReturnInGUID.AsString;
    end
    else
    begin
      if tblMovement_ReturnIn.Locate('Id', cdsReturnInId.AsInteger) then
      begin
        tblMovement_ReturnIn.Edit;

        tblMovement_ReturnInOperDate.AsDateTime := OperDate;
        tblMovement_ReturnInComment.AsString := Comment;
        tblMovement_ReturnInSubjectDocId.AsInteger := SubjectDocId;
        if Complete then
          tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger
        else
          tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_UnComplete.AsInteger;
        tblMovement_ReturnInUnitId.AsInteger := tblObject_ConstUnitId_ret.AsInteger;
        tblMovement_ReturnInPaidKindId.AsInteger := PaidKindId;
        tblMovement_ReturnInPriceWithVAT.AsBoolean := cdsReturnInPriceWithVAT.AsBoolean;
        tblMovement_ReturnInVATPercent.AsFloat := cdsReturnInVATPercent.AsFloat;
        tblMovement_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
        tblMovement_ReturnInTotalCountKg.AsFloat := TotalWeight;
        tblMovement_ReturnInTotalSummPVAT.AsFloat := TotalPrice;

        tblMovement_ReturnIn.Post;

        MovementId := tblMovement_ReturnInId.AsInteger;
        DocGUID := tblMovement_ReturnInGUID.AsString;
      end
      else
      begin
        ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка на возврат';
        Exit;
      end;
    end;

    CurInvNumber := tblMovement_ReturnInInvNumber.AsString;

    tblMovementItem_ReturnIn.Open;

    with cdsReturnInItems do
    begin
      First;
      while not Eof do
      begin
        MovementItemId := -1;

        if FieldbyName('Count').AsFloat > 0 then
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
            tblMovementItem_ReturnInSubjectDocId.AsInteger := FieldbyName('SubjectDocId').AsInteger;
            tblMovementItem_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
            tblMovementItem_ReturnInSubjectDocId.AsInteger := FieldbyName('SubjectDocId').AsInteger;

            tblMovementItem_ReturnIn.Post;
            {??? Возможно есть лучший способ получения значения Id новой записи }
            tblMovementItem_ReturnIn.Refresh;
            tblMovementItem_ReturnIn.Last;
            {???}
            MovementItemId := tblMovementItem_ReturnInId.AsInteger;
          end
          else
          begin
            if tblMovementItem_ReturnIn.Locate('Id', FieldbyName('Id').AsInteger) then
            begin
              tblMovementItem_ReturnIn.Edit;

              tblMovementItem_ReturnInChangePercent.AsFloat := cdsReturnInChangePercent.AsFloat;
              tblMovementItem_ReturnInAmount.AsFloat := FieldbyName('Count').AsFloat;
              tblMovementItem_ReturnInPrice.AsFloat := FieldbyName('Price').AsFloat;
              tblMovementItem_ReturnInSubjectDocId.AsInteger := FieldbyName('SubjectDocId').AsInteger;

              tblMovementItem_ReturnIn.Post;

              MovementItemId := tblMovementItem_ReturnInId.AsInteger;
            end;
          end;
        end
        else
          if (FieldbyName('Id').AsInteger <> -1) and tblMovementItem_ReturnIn.Locate('Id', FieldbyName('Id').AsInteger) then
            tblMovementItem_ReturnIn.Delete;

        if MovementItemId <> -1 then
        begin
          Edit;
          FieldbyName('Id').AsInteger := MovementItemId;
          Post;
        end;

        Next;
      end;
    end;

    tblMovementItem_ReturnIn.Close;
    tblMovement_ReturnIn.Close;

    if DelItems <> '' then
      conMain.ExecSQL('delete from MOVEMENTITEM_RETURNIN where ID in (' + DelItems + ')');

    conMain.Commit;

    //обновляем данные в локальном хранилище
    cdsReturnIn.DisableControls;
    try
      cdsReturnIn.Edit;

      cdsReturnInId.AsInteger := MovementId;

      cdsReturnInOperDate.AsDateTime := OperDate;
      cdsReturnInPaidKindId.AsInteger := PaidKindId;
      cdsReturnInComment.AsString := Comment;
      cdsReturnInSubjectDocId.AsInteger := SubjectDocId;
      cdsReturnInSubjectDocName.AsString := SubjectDocName;
      cdsReturnInComment.AsString := Comment;
      cdsReturnInName.AsString := 'Возврат №' + CurInvNumber + ' от ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsReturnInPrice.AsString :=  'Стоимость: ' + FormatFloat(',0.00', TotalPrice);
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

      b := cdsReturnIn.Bookmark;
      cdsReturnIn.First;
      cdsReturnIn.GotoBookmark(b);
    end;
    //=========

    if Complete and NowSync then
    begin
      SyncData.SyncReturnIn(DocGUID);

      tblMovement_ReturnIn.Open;
      if tblMovement_ReturnIn.Locate('Id', MovementId) then
      begin
        TotalPrice := tblMovement_ReturnInTotalSummPVAT.AsCurrency;
        TotalWeight := tblMovement_ReturnInTotalCountKg.AsCurrency;
      end;
      tblMovement_ReturnIn.Close;

      //обновляем данные в локальном хранилище
      cdsReturnIn.DisableControls;
      if cdsReturnIn.Locate('Id', MovementId, []) then
      begin
        cdsReturnIn.Edit;
        cdsReturnInPrice.AsString := 'Стоимость: ' + FormatFloat(',0.00', TotalPrice);
        cdsReturnInWeight.AsString := 'Вес: ' + FormatFloat(',0.00', TotalWeight);
        cdsReturnInisSync.AsBoolean := True;
        cdsReturnIn.Post;
      end;
      cdsReturnIn.EnableControls;

      b := cdsReturnIn.Bookmark;
      cdsReturnIn.First;
      cdsReturnIn.GotoBookmark(b);
    end;

    Result := True;
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
    cdsReturnInOperDate.AsDateTime := IncDay(Date(), tblObject_ConstOperDate_diff.AsInteger);;
    cdsReturnInComment.AsString := '';
    cdsReturnInName.AsString := 'Возврат от ' + FormatDateTime('DD.MM.YYYY', cdsReturnInOperDate.AsDateTime);
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
    cdsReturnInPartnerFullName.AsString := qryPartnerFullName.AsString;

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
//or
//    qryReturnIn.SQL.Text := 'select ID, OPERDATE, PAIDKINDID, TOTALCOUNTKG, TOTALSUMMPVAT, ISSYNC, STATUSID, COMMENT' +
//      ' from MOVEMENT_RETURNIN' +
//      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
//      ' order by OPERDATE desc';
//or
    qryReturnIn.SQL.Text :=
       ' SELECT  '
     + '         Movement_ReturnIn.ID '
     + '       , Movement_ReturnIn.InvNumber '
     + '       , Movement_ReturnIn.OperDate '
     + '       , Movement_ReturnIn.PaidKindId '
     + '       , Movement_ReturnIn.TotalCountKg '
     + '       , Movement_ReturnIn.TotalSummPVAT '
     + '       , Movement_ReturnIn.isSync '
     + '       , Movement_ReturnIn.StatusId '
     + '       , Movement_ReturnIn.SubjectDocId '
     + '       , Movement_ReturnIn.Comment '
     + '       , OBJECT_SUBJECTDOC.ValueData AS SubjectDocName '
     + ' FROM  Movement_ReturnIn '
     + '       LEFT JOIN OBJECT_SUBJECTDOC ON OBJECT_SUBJECTDOC.Id = Movement_ReturnIn.SubjectDocId '
     + ' WHERE Movement_ReturnIn.PartnerId = ' + qryPartnerId.AsString
     + '   AND Movement_ReturnIn.ContractId = ' + qryPartnerContractId.AsString
     + ' ORDER BY Movement_ReturnIn.OperDate desc ';

    qryReturnIn.Open;

    qryReturnIn.First;
    while not qryReturnIn.EOF do
    begin
      cdsReturnIn.Append;
      cdsReturnInId.AsInteger := qryReturnIn.FieldByName('ID').AsInteger;
      cdsReturnInOperDate.AsDateTime := qryReturnIn.FieldByName('OPERDATE').AsDateTime;
      cdsReturnInComment.AsString := qryReturnIn.FieldByName('COMMENT').AsString;

      cdsReturnInSubjectDocId.AsVariant := qryReturnIn.FieldByName('SubjectDocId').AsVariant;
      if cdsReturnInSubjectDocId.AsInteger = 0 then cdsReturnInSubjectDocName.AsString := 'Без основания'
      else cdsReturnInSubjectDocName.AsString := qryReturnIn.FieldByName('SubjectDocName').AsString;

      cdsReturnInName.AsString := 'Возврат №' + qryReturnIn.FieldByName('INVNUMBER').AsString + ' от ' + FormatDateTime('DD.MM.YYYY', qryReturnIn.FieldByName('OPERDATE').AsDateTime);
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
      cdsReturnInPaidKindId.AsInteger := qryReturnIn.FieldByName('PAIDKINDID').AsInteger;
      cdsReturnInPriceListId.AsInteger := qryPartnerPRICELISTID_RET.AsInteger;
      cdsReturnInPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT_RET.AsBoolean;
      cdsReturnInVATPercent.AsFloat := qryPartnerVATPercent_RET.AsFloat;
      cdsReturnInChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
      cdsReturnInPartnerFullName.AsString := qryPartnerFullName.AsString;

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
//or
//    qryReturnIn.SQL.Text := 'select MRI.ID, MRI.OPERDATE, MRI.PAIDKINDID, MRI.COMMENT, MRI.TOTALCOUNTKG, MRI.TOTALSUMMPVAT, MRI.ISSYNC, MRI.STATUSID, ' +
//      'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS, PL.ID PRICELISTID, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
//      'P.CONTRACTID, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, C.CHANGEPERCENT ' +
//      'from MOVEMENT_RETURNIN MRI ' +
//      'JOIN OBJECT_PARTNER P ON P.ID = MRI.PARTNERID AND P.CONTRACTID = MRI.CONTRACTID ' +
//      'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
//      'LEFT JOIN Object_PriceList PL ON PL.ID = IFNULL(P.PRICELISTID_RET, :DefaultPriceList) ' +
//      'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
//      'WHERE DATE(MRI.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
//      'GROUP BY MRI.ID, MRI.PARTNERID, MRI.CONTRACTID order by PartnerName, P.Address, P.ContractId asc, MRI.OPERDATE desc';
//or

    qryReturnIn.SQL.Text :=
       ' SELECT '
     + '         Movement_ReturnIn.ID '
     + '       , Movement_ReturnIn.InvNumber '
     + '       , Movement_ReturnIn.OperDate '
     + '       , Movement_ReturnIn.PaidKindId '
     + '       , Movement_ReturnIn.Comment '
     + '       , Movement_ReturnIn.SubjectDocId '
     + '       , Movement_ReturnIn.TotalCountKg '
     + '       , Movement_ReturnIn.TotalSummPVAT '
     + '       , Movement_ReturnIn.isSync '
     + '       , Movement_ReturnIn.StatusId '
     + '       , Object_Partner.Id               AS PartnerId '
     + '       , Object_Juridical.ValueData      AS PartnerName '
     + '       , Object_Partner.ADDRESS '
     + '       , Object_PriceList.ID             AS PRICELISTID '
     + '       , Object_PriceList.PRICEWITHVAT '
     + '       , Object_PriceList.VATPERCENT '
     + '       , Object_Partner.ContractId '
     + '       , Object_Contract.ContractTagName || '' '' || Object_Contract.ValueData AS ContractName '
     + '       , Object_Contract.ChangePercent '
     + '       , OBJECT_SUBJECTDOC.ValueData AS SubjectDocName '
     + ' FROM  Movement_ReturnIn '
     + '       JOIN Object_Partner         ON Object_Partner.ID           = Movement_ReturnIn.PartnerId '
     + '                                  AND Object_Partner.ContractId   = Movement_ReturnIn.ContractId '
     + '       LEFT JOIN Object_Juridical  ON Object_Juridical.ID         = Object_Partner.JURIDICALID  '
     + '                                  AND Object_Juridical.ContractId = Object_Partner.ContractId '
     + '       LEFT JOIN Object_PriceList  ON Object_PriceList.ID         = IFNULL(Object_Partner.PriceListId_ret, :DefaultPriceList) '
     + '       LEFT JOIN Object_Contract   ON Object_Contract.ID          = Object_Partner.ContractId '
     + '       LEFT JOIN OBJECT_SUBJECTDOC ON OBJECT_SUBJECTDOC.Id        = Movement_ReturnIn.SubjectDocId '
     + ' WHERE DATE(Movement_ReturnIn.OperDate) BETWEEN :STARTDATE AND :ENDDATE '
     + ' GROUP BY Movement_ReturnIn.ID, Movement_ReturnIn.PartnerId, Movement_ReturnIn.ContractId  '
     + ' ORDER BY PartnerName, Object_Partner.Address, Object_Partner.ContractId asc, Movement_ReturnIn.OperDate desc ';

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
      cdsReturnInSubjectDocId.AsVariant := qryReturnIn.FieldByName('SubjectDocId').AsVariant;
      if cdsReturnInSubjectDocId.AsInteger = 0 then cdsReturnInSubjectDocName.AsString := 'Без основания'
      else cdsReturnInSubjectDocName.AsString := qryReturnIn.FieldByName('SubjectDocName').AsString;
      cdsReturnInName.AsString := 'Возврат №' + qryReturnIn.FieldByName('INVNUMBER').AsString + ' от ' + FormatDateTime('DD.MM.YYYY', qryReturnIn.FieldByName('OPERDATE').AsDateTime);
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

      // full name
      cdsReturnInPartnerFullName.AsString := cdsReturnInPartnerName.AsString + chr(13) + chr(10) +
        cdsReturnInAddress.AsString;
      if cdsReturnInPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger
      then // БН
        cdsReturnInPartnerFullName.AsString := cdsReturnInPartnerFullName.AsString + chr(13) + chr(10) +
          DM.tblObject_ConstPaidKindName_First.AsString + ' : ' + cdsReturnInContractName.AsString
      else
      if cdsReturnInPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_Second.AsInteger
      then // Нал
        cdsReturnInPartnerFullName.AsString := cdsReturnInPartnerFullName.AsString + chr(13) + chr(10) +
          DM.tblObject_ConstPaidKindName_Second.AsString + ' : ' + cdsReturnInContractName.AsString
      else  // нет договор
        cdsReturnInPartnerFullName.AsString := cdsReturnInPartnerFullName.AsString + chr(13) + chr(10) +
          cdsReturnInContractName.AsString;

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
  cdsReturnInItemsGoodsId.AsString := ArrValue[1];          // GoodsId
  cdsReturnInItemsKindID.AsString := ArrValue[2];           // GoodsKindID
  cdsReturnInItemsGoodsName.AsString := ArrValue[3];        // название товара
  cdsReturnInItemsKindName.AsString := ArrValue[4];         // вид товара
  cdsReturnInItemsPrice.AsString := ArrValue[5];            // цена
  cdsReturnInItemsMeasure.AsString := ' ' + ArrValue[6];    // единица измерения
  cdsReturnInItemsWeight.AsString := ArrValue[7];           // вес
  cdsReturnInItemsTradeMarkName.AsString := ArrValue[8];    // торговая марка
  cdsReturnInItemsCount.AsString := ArrValue[9];            // количество по умолчанию
  if Length(ArrValue) >= 11
  then
  begin
    cdsReturnInItemsRecalcPriceName.AsString := ArrValue[10]; // цены пересчитаны или нет
    cdsReturnInItemsSubjectDocId.AsString := ArrValue[11];      // Основание возврата
    if cdsReturnInItemsSubjectDocId.AsInteger = 0 then cdsReturnInItemsSubjectDocName.AsString := 'Без основания'
    else cdsReturnInItemsSubjectDocName.AsString := ArrValue[12];    // Основание возврата название
  end
  else
  begin
    cdsReturnInItemsRecalcPriceName.AsString := '-';
    cdsReturnInItemsSubjectDocId.AsString := '0';      // Основание возврата
    cdsReturnInItemsSubjectDocName.AsString := 'Без основания'
  end;
  if DM.cdsReturnInItemsSubjectDocId.AsInteger = 0 then
  begin
    DM.cdsReturnInItemsSubjectDocId.AsInteger := frmMain.ReturnInSubjectDocId;
    DM.cdsReturnInItemsSubjectDocName.AsString := frmMain.ReturnInSubjectDocName;
  end;

  cdsReturnInItemsCurrencyName.AsString := 'грн.';

// ShowMessage(IntToStr(Length(ArrValue)));

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

//or
//    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
//      'CAST(G.OBJECTCODE as varchar)  || '' '' || G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || ' +
//      'IFNULL(PI.OrderPrice, 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || ' +
//      'IFNULL(T.VALUEDATA, '''') || '';0''' +
//      'from OBJECT_GOODSLISTSALE GLS ' +
//      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
//      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID ' +
//      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//      'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
//      'WHERE GLS.PARTNERID = :PARTNERID and GLS.ISERASED = 0 order by G.VALUEDATA ';
//or
    qryGoodsListSale.SQL.Text :=
       ' SELECT '
     + '       ''-1;'' || Object_Goods.Id || '';'' || IFNULL(Object_GoodsKind.Id, 0) || '';'' || '
     + '       CAST(Object_Goods.ObjectCode as varchar)  || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || '
     + '       IFNULL(COALESCE(Object_PriceListItems.ReturnPrice, Object_PriceListItems_two.ReturnPrice), 0) || '';'' || IFNULL(Object_Measure.ValueData, ''-'') || '';'' || Object_Goods.Weight || '';'' || '
     + '       IFNULL(Object_TradeMark.ValueData, '''') || '';0;-;0;-'' '
     + ' FROM  Object_GoodsListSale  '
     + '       JOIN Object_Goods               ON Object_GoodsListSale.GoodsId      = Object_Goods.Id '
     + '       LEFT JOIN Object_GoodsKind      ON Object_GoodsKind.Id               = Object_GoodsListSale.GoodsKindId '
     + '       LEFT JOIN Object_Measure        ON Object_Measure.Id                 = Object_Goods.MeasureId '
     + '       LEFT JOIN Object_TradeMark      ON Object_TradeMark.Id               = Object_Goods.TradeMarkId '
     + '       LEFT JOIN Object_PriceListItems     ON Object_PriceListItems.GoodsId          = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsKindId      = Object_GoodsListSale.GoodsKindId '
     + '                                          AND COALESCE(Object_GoodsListSale.GoodsKindId, 0) <> 0 '
     + '                                          AND Object_PriceListItems.PriceListId = :PRICELISTID '
     + '       LEFT JOIN Object_PriceListItems     AS Object_PriceListItems_two '
     + '                                           ON Object_PriceListItems_two.GoodsId      = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsId IS NULL '
     + '                                          AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
     + '                                          AND Object_PriceListItems_two.PriceListId  = :PRICELISTID '
     + ' WHERE Object_GoodsListSale.PartnerId = :PARTNERID '
     + '   AND Object_GoodsListSale.isErased  = 0 '
     + ' ORDER BY Object_Goods.ValueData ';

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

//or
//    qryGoodsListReturn.SQL.Text := 'select IR.ID || '';'' || G.ID || '';'' || IFNULL(GK.ID, 0) || '';'' || ' +
//      'CAST(G.OBJECTCODE as varchar)  || '' '' || G.VALUEDATA || '';'' || IFNULL(GK.VALUEDATA, ''-'') || '';'' || ' +
//      'IFNULL(PI.OrderPrice, 0) || '';'' || IFNULL(M.VALUEDATA, ''-'') || '';'' || G.WEIGHT || '';'' || ' +
//      'IFNULL(T.VALUEDATA, '''') || '';'' || IR.AMOUNT ' +
//      'from MOVEMENTITEM_RETURNIN IR ' +
//      'JOIN OBJECT_GOODS G ON G.ID = IR.GOODSID ' +
//      'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = IR.GOODSKINDID ' +
//      'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//      'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//      'LEFT JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
//      'WHERE IR.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';
//or
    qryGoodsListReturn.SQL.Text :=
       ' SELECT '
     + '       MovementItem_ReturnIn.Id || '';'' || Object_Goods.Id || '';'' || IFNULL(Object_GoodsKind.Id, 0) || '';'' || '
     + '       CAST(Object_Goods.ObjectCode as varchar)  || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || '
     + '       IFNULL(MovementItem_ReturnIn.Price, IFNULL(COALESCE(Object_PriceListItems.ReturnPrice, Object_PriceListItems_two.ReturnPrice), 0)) || '';'' || IFNULL(Object_Measure.ValueData, ''-'') || '';'' || Object_Goods.Weight || '';'' || '
     + '       IFNULL(Object_TradeMark.ValueData, '''') || '';'' || MovementItem_ReturnIn.Amount || '';'' || '
     + '       CASE WHEN MovementItem_ReturnIn.isRecalcPrice THEN ''Пересчитано'' ELSE ''-'' END || '';'' || '
     + '       IFNULL(MovementItem_ReturnIn.SubjectDocId, 0)  || '';'' || IFNULL(Object_SubjectDoc.ValueData, ''-'') '
     + ' FROM  MovementItem_ReturnIn  '
     + '       JOIN Object_Goods               ON Object_Goods.Id                   = MovementItem_ReturnIn.GoodsId '
     + '       LEFT JOIN Object_GoodsKind      ON Object_GoodsKind.Id               = MovementItem_ReturnIn.GoodsKindId '
     + '       LEFT JOIN Object_SubjectDoc     ON Object_SubjectDoc.Id              = MovementItem_ReturnIn.SubjectDocId '
     + '       LEFT JOIN Object_Measure        ON Object_Measure.Id                 = Object_Goods.MeasureId '
     + '       LEFT JOIN Object_TradeMark      ON Object_TradeMark.Id               = Object_Goods.TradeMarkId '
     + '       LEFT JOIN Object_PriceListItems     ON Object_PriceListItems.GoodsId          = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsKindId      = MovementItem_ReturnIn.GoodsKindId '
     + '                                          AND COALESCE(MovementItem_ReturnIn.GoodsKindId, 0) <> 0 '
     + '                                          AND Object_PriceListItems.PriceListId = :PRICELISTID '
     + '       LEFT JOIN Object_PriceListItems     AS Object_PriceListItems_two '
     + '                                           ON Object_PriceListItems_two.GoodsId      = Object_Goods.ID  '
     + '                                          AND Object_PriceListItems.GoodsId IS NULL '
     + '                                          AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
     + '                                          AND Object_PriceListItems_two.PriceListId  = :PRICELISTID '
     + ' WHERE MovementItem_ReturnIn.MovementId = ' + IntToStr(AId)
     + ' ORDER BY Object_Goods.ValueData ';

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
var
  Params: TParams;
begin
  Params := TParams.Create(nil);
  Params.CreateParam(cdsReturnInPRICELISTID.DataType, 'PRICELISTID', ptInput).Value := cdsReturnInPRICELISTID.AsInteger;

  if DataSetCache.Find('ReturnInItemsList', Params) = nil then
  begin
    qryGoodsItems.SQL.Text :=
         ' SELECT '
       + '         Object_Goods.ID                   AS GoodsID '
       + '       , Object_GoodsKind.ID               AS KindID '
       + '       , Object_Goods.ObjectCode '
       + '       , Object_Goods.ValueData            AS GoodsName '
       + '       , Object_GoodsKind.ValueData        AS KindName '
       + '       , ''-''                             AS PromoPrice '
       + '       , Object_TradeMark.ValueData        AS TradeMarkName '
       + '       , Object_GoodsByGoodsKind.Remains '
       + '       , COALESCE(Object_PriceListItems.ReturnPrice, Object_PriceListItems_two.ReturnPrice, 0.0) AS PRICE '
       + '       , Object_Measure.ValueData          AS MEASURE '
       + '       , ''-1;'' || Object_Goods.ID || '';'' || IFNULL(Object_GoodsKind.ID, 0) || '';'' || '
       + '         Object_Goods.ObjectCode || '' '' || Object_Goods.ValueData || '';'' || IFNULL(Object_GoodsKind.ValueData, ''-'') || '';'' || '
       + '         IFNULL(COALESCE(Object_PriceListItems.OrderPrice, Object_PriceListItems_two.OrderPrice), 0) || '';'' || IFNULL(Object_Measure.ValueData, ''-'') || '';'' || '
       + '         Object_Goods.Weight || '';'' || IFNULL(Object_TradeMark.ValueData, '''') || '';0'' AS FullInfo '
       + '       , Object_Goods.ValueData || '';0''  AS SearchName '
       + '       , Object_Goods.ObjectCode || '' '' || Object_Goods.ValueData AS FullGoodsName '
       + ' FROM  Object_GoodsByGoodsKind '
       + '       LEFT JOIN Object_Goods            ON Object_GoodsByGoodsKind.GoodsId   = Object_Goods.ID '
       + '       LEFT JOIN Object_GoodsKind        ON Object_GoodsKind.ID               = Object_GoodsByGoodsKind.GoodsKindId '
       + '       LEFT JOIN Object_Measure          ON Object_Measure.ID                 = Object_Goods.MeasureId '
       + '       LEFT JOIN Object_TradeMark        ON Object_TradeMark.ID               = Object_Goods.TradeMarkId '
       + '       LEFT JOIN Object_PriceListItems     ON Object_PriceListItems.GoodsId          = Object_Goods.ID  '
       + '                                          AND Object_PriceListItems.GoodsKindId      = Object_GoodsByGoodsKind.GoodsKindId '
       + '                                          AND COALESCE(Object_GoodsByGoodsKind.GoodsKindId, 0) <> 0 '
       + '                                          AND Object_PriceListItems.PriceListId = :PRICELISTID '
       + '       LEFT JOIN Object_PriceListItems     AS Object_PriceListItems_two '
       + '                                           ON Object_PriceListItems_two.GoodsId      = Object_Goods.ID  '
       + '                                          AND Object_PriceListItems.GoodsId IS NULL '
       + '                                          AND COALESCE(Object_PriceListItems_two.GoodsKindId, 0) = 0 '
       + '                                          AND Object_PriceListItems_two.PriceListId  = :PRICELISTID '
       + ' WHERE Object_GoodsByGoodsKind.isErased = 0 '
       + ' ORDER BY GoodsName ';

    qryGoodsItems.ParamByName('PRICELISTID').AsInteger := Params.ParamByName('PRICELISTID').AsInteger;
    qryGoodsItems.Open;

    DataSetCache.Add('ReturnInItemsList', Params, qryGoodsItems);
  end;

  Params.Free;
end;

{ начитка справочника основания возврата }
procedure TDM.GenerateReturnInSubjectDoc;
var
  Params: TParams;
begin
  Params := TParams.Create(nil);
  Params.CreateParam(cdsReturnInSubjectDocId.DataType, 'SUBJECTDOC', ptInput).Value := 0;

  if DataSetCache.Find('SubjectDoc', Params) = nil then
  begin
    qrySubjectDoc.Open;

    DataSetCache.Add('SubjectDoc', Params, qrySubjectDoc);

  end;
  Params.Free;
end;

{ сохранение группы фотографий в БД }
procedure TDM.SavePhotoGroup(AGroupName: string);
var
  GlobalId: TGUID;
  NewInvNumber: string;
begin
  NewInvNumber := GetInvNumber('MOVEMENT_VISIT');

  try
    tblMovement_Visit.Open;

    tblMovement_Visit.Append;

    CreateGUID(GlobalId);
    tblMovement_VisitGUID.AsString := GUIDToString(GlobalId);
    tblMovement_VisitInvNumber.AsString := NewInvNumber;
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
//or
//  qryPhotoGroups.Open('select Id, Comment, StatusId, OperDate, isSync ' +
//    ' from Movement_Visit where PartnerId = ' + qryPartnerId.AsString +
//    ' and StatusId <> ' + tblObject_ConstStatusId_Erased.AsString);
//or

  qryPhotoGroups.Open(
       ' SELECT  '
     + '         Id '
     + '       , Comment '
     + '       , StatusId '
     + '       , OperDate '
     + '       , isSync '
     + ' FROM  Movement_Visit  '
     + ' WHERE PartnerId = ' + qryPartnerId.AsString
     + '   AND StatusId <> ' + tblObject_ConstStatusId_Erased.AsString
                     );
end;

{ начитка групп фотографий из БД для всех ТТ }
procedure TDM.LoadAllPhotoGroups;
begin
  qryPhotoGroupDocs.Close;
//or
//  qryPhotoGroupDocs.SQL.Text := 'select MV.Id, MV.Comment, MV.StatusId, MV.OperDate, MV.isSync, ' +
//    'P.Id PartnerId, J.VALUEDATA PartnerName, P.ADDRESS ' +
//    'FROM Movement_Visit MV ' +
//    'JOIN OBJECT_PARTNER P ON P.ID = MV.PARTNERID ' +
//    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
//    'WHERE DATE(MV.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE AND MV.StatusId <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
//    'GROUP BY MV.ID, MV.PARTNERID order by PartnerName, Address asc, OPERDATE desc';
//or
  qryPhotoGroupDocs.SQL.Text :=
       ' SELECT '
     + '         Movement_Visit.Id '
     + '       , Movement_Visit.Comment '
     + '       , Movement_Visit.StatusId '
     + '       , Movement_Visit.OperDate '
     + '       , Movement_Visit.isSync '
     + '       , Object_Partner.Id          AS PartnerId '
     + '       , Object_Juridical.ValueData AS PartnerName '
     + '       , Object_Partner.Address '
     + ' FROM  Movement_Visit '
     + '       JOIN Object_Partner        ON Object_Partner.ID           = Movement_Visit.PartnerId '
     + '       LEFT JOIN Object_Juridical ON Object_Juridical.ID         = Object_Partner.JuridicalId  '
     + '                                 AND Object_Juridical.ContractId = Object_Partner.ContractId '
     + ' WHERE DATE(Movement_Visit.OperDate) BETWEEN :STARTDATE AND :ENDDATE '
     + '   AND Movement_Visit.StatusId <> ' + tblObject_ConstStatusId_Erased.AsString
     + ' GROUP BY Movement_Visit.ID, Movement_Visit.PartnerId '
     + ' ORDER BY PartnerName, Address asc, OperDate desc ';

  qryPhotoGroupDocs.ParamByName('STARTDATE').AsDate := AStartDate;
  qryPhotoGroupDocs.ParamByName('ENDDATE').AsDate := AEndDate;
  qryPhotoGroupDocs.Open;
end;

{ сохранение прихода денег в БД }
procedure TDM.SaveCash(AId: integer; APaidKind: integer; AInvNumberSale: string; AOperDate: TDate; AAmount: Double; AComment: string);
var
  GlobalId: TGUID;
  NewInvNumber: string;
begin
  if AId = -1 then // сохранение нового прихода денег
  begin
    NewInvNumber := GetInvNumber('MOVEMENT_CASH');

    try
      tblMovement_Cash.Open;

      tblMovement_Cash.Append;

      CreateGUID(GlobalId);
      tblMovement_CashGUID.AsString := GUIDToString(GlobalId);
      tblMovement_CashInvNumber.AsString := NewInvNumber;
      tblMovement_CashInvNumberSale.AsString := AInvNumberSale;
      tblMovement_CashOperDate.AsDateTime := AOperDate;
      tblMovement_CashStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
      tblMovement_CashInsertDate.AsDateTime := Now();
      tblMovement_CashAmount.AsFloat := AAmount;
      tblMovement_CashPaidKindId.AsInteger := APaidKind;
      tblMovement_CashPartnerId.AsInteger := qryPartnerId.AsInteger;
      tblMovement_CashCashId.AsInteger := tblObject_ConstCashId.AsInteger;
      tblMovement_CashMemberId.AsInteger := tblObject_ConstMemberId.AsInteger;
      tblMovement_CashContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      tblMovement_CashComment.AsString := AComment;
      tblMovement_CashisSync.AsBoolean := false;

      tblMovement_Cash.Post;

      tblMovement_Cash.Close;
    except
      on E : Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end
  else
  begin
    try
      tblMovement_Cash.Open;

      if tblMovement_Cash.Locate('Id', AId) then
      begin
        tblMovement_Cash.Edit;

        tblMovement_CashInvNumberSale.AsString := AInvNumberSale;
        tblMovement_CashOperDate.AsDateTime := AOperDate;
        tblMovement_CashAmount.AsFloat := AAmount;
        tblMovement_CashPaidKindId.AsInteger := APaidKind;
        tblMovement_CashComment.AsString := AComment;
        tblMovement_CashStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        tblMovement_CashisSync.AsBoolean := false;

        tblMovement_Cash.Post;
      end
      else
      begin
        ShowMessage('Ошибка работы с БД: не найдена редактируемый приход денег');
        exit;
      end;

      tblMovement_Cash.Close;
    except
      on E : Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;
end;

{ начитка приходов денег из БД }
procedure TDM.LoadCash;
begin
  qryCash.Close;
//or
//  qryCash.Open('select Id, PAIDKINDID, InvNumberSale, Amount, Comment, StatusId, OperDate, isSync, ' +
//    'PartnerId, '''' PartnerName, '''' Address, ContractId, '''' ContractName ' +
//    'from Movement_Cash where PartnerId = ' + qryPartnerId.AsString);
//or
  qryCash.Open(
       ' SELECT '
     + '         Id '
     + '       , PaidKindId '
     + '       , InvNumberSale '
     + '       , Amount '
     + '       , Comment '
     + '       , StatusId '
     + '       , OperDate '
     + '       , isSync '
     + '       , PartnerId '
     + '       , '''' AS PartnerName '
     + '       , '''' AS Address '
     + '       , ContractId '
     + '       , '''' AS ContractName  '
     + ' FROM  Movement_Cash  '
     + ' WHERE PartnerId = ' + qryPartnerId.AsString
              );
end;

procedure TDM.LoadAllCash(AStartDate, AEndDate: TDate);
begin
  qryCash.Close;
//or
//  qryCash.SQL.Text := 'select MC.ID, MC.PAIDKINDID, MC.InvNumberSale, MC.OPERDATE, MC.COMMENT, MC.AMOUNT, MC.ISSYNC, MC.STATUSID, ' +
//    'P.Id PartnerId, '''' || J.VALUEDATA PartnerName, '''' || P.ADDRESS Address, ' +
//    'P.CONTRACTID, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName ' +
//    'FROM Movement_Cash MC ' +
//    'JOIN OBJECT_PARTNER P ON P.ID = MC.PARTNERID AND P.CONTRACTID = MC.CONTRACTID ' +
//    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID AND J.CONTRACTID = P.CONTRACTID ' +
//    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
//    'WHERE DATE(MC.OPERDATE) BETWEEN :STARTDATE AND :ENDDATE ' +
//    'GROUP BY MC.ID, MC.PARTNERID, MC.CONTRACTID order by PartnerName, P.Address, P.ContractId asc, MC.OPERDATE desc';
//or
  qryCash.SQL.Text :=
       ' SELECT '
     + '         Movement_Cash.Id '
     + '       , Movement_Cash.PaidKindId '
     + '       , Movement_Cash.InvNumberSale '
     + '       , Movement_Cash.OperDate '
     + '       , Movement_Cash.Comment '
     + '       , Movement_Cash.Amount '
     + '       , Movement_Cash.isSync '
     + '       , Movement_Cash.StatusId '
     + '       , Object_Partner.Id                    AS PartnerId '
     + '       , '''' || Object_Juridical.ValueData   AS PartnerName '
     + '       , '''' || Object_Partner.Address       AS Address '
     + '       , Object_Partner.ContractId '
     + '       , Object_Contract.ContractTagName || '' '' || Object_Contract.ValueData AS ContractName '
     + ' FROM  Movement_Cash '
     + '       JOIN Object_Partner        ON Object_Partner.Id           = Movement_Cash.PartnerId  '
     + '                                 AND Object_Partner.ContractId   = Movement_Cash.ContractId '
     + '       LEFT JOIN Object_Juridical ON Object_Juridical.Id         = Object_Partner.JuridicalId '
     + '                                 AND Object_Juridical.ContractId = Object_Partner.ContractId '
     + '       LEFT JOIN Object_Contract  ON Object_Contract.Id          = Object_Partner.ContractId '
     + ' WHERE DATE(Movement_Cash.OperDate) BETWEEN :STARTDATE AND :ENDDATE '
     + ' GROUP BY Movement_Cash.Id, Movement_Cash.PartnerId, Movement_Cash.ContractId '
     + ' ORDER BY PartnerName, Object_Partner.Address, Object_Partner.ContractId asc, Movement_Cash.OperDate desc ';

  qryCash.ParamByName('STARTDATE').AsDate := AStartDate;
  qryCash.ParamByName('ENDDATE').AsDate := AEndDate;
  qryCash.Open;
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

procedure TDM.GenerateJuridicalCollationDocItems(ADocId: Integer);
begin
  DM.cdsJuridicalCollationDocItems.EmptyDataSet;

  WaitThread := TWaitThread.Create(true);
  WaitThread.FreeOnTerminate := true;
  WaitThread.TaskName := 'JuridicalCollationDocItems';
  WaitThread.DocId := ADocId;
  WaitThread.Start;
end;

{ начитка заданий контрагента из БД }
function TDM.LoadTasks(Active: TActiveMode; SaveData: boolean = true; ADate: TDate = 0; APartnerId: integer = 0): integer;
var
  DateSql, WhereSql : string;
begin
//or
//  if ADate = 0 then
//    DateSql := 'JOIN MOVEMENT_TASK TM ON TM.ID = TI.MOVEMENTID '
//  else
//    DateSql := 'JOIN MOVEMENT_TASK TM ON TM.ID = TI.MOVEMENTID AND DATE(TM.OPERDATE) = :TASKDATE ';
//
//  if tblObject_ConstPersonalId.AsString <> '' then
//    WhereSql := 'WHERE PERSONALID = ' + tblObject_ConstPersonalId.AsString + ' '
//  else
//    WhereSql := 'WHERE 1 = 1 ';
//
//  if Active <> amAll then
//    WhereSql := WhereSql + 'AND TI.CLOSED = :CLOSED ';
//
//  if APartnerId <> 0 then
//    WhereSql := WhereSql + 'AND TI.PARTNERID = ' + IntToStr(APartnerId) + ' ';
//or
  if ADate = 0 then
    DateSql := 'JOIN Movement_Task ON Movement_Task.ID = MovementItem_Task.MovementId '
  else
    DateSql := 'JOIN Movement_Task ON Movement_Task.ID = MovementItem_Task.MovementId AND DATE(Movement_Task.OperDate) = :TASKDATE ';

  if tblObject_ConstPersonalId.AsString <> '' then
    WhereSql := 'WHERE PersonalId = ' + tblObject_ConstPersonalId.AsString + ' '
  else
    WhereSql := 'WHERE 1 = 1 ';

  if Active <> amAll then
    WhereSql := WhereSql + 'AND MovementItem_Task.Closed = :CLOSED ';

  if APartnerId <> 0 then
    WhereSql := WhereSql + 'AND MovementItem_Task.PartnerId = ' + IntToStr(APartnerId) + ' ';
//or
//  qrySelect.SQL.Text := 'SELECT TI.ID, TI.PARTNERID, TI.CLOSED, TI.DESCRIPTION, TI.COMMENT, ' +
//    'TM.OPERDATE, TM.INVNUMBER, P.VALUEDATA PartnerName ' +
//    'FROM MOVEMENTITEM_TASK TI ' +
//    DateSql +
//    'LEFT JOIN OBJECT_PARTNER P ON P.ID = TI.PARTNERID ' +
//    WhereSql+
//    'GROUP BY TI.ID ORDER BY TM.OPERDATE DESC';
//or
  qrySelect.SQL.Text :=
       ' SELECT '
     + '         MovementItem_Task.ID '
     + '       , MovementItem_Task.PartnerId '
     + '       , MovementItem_Task.CLOSED '
     + '       , MovementItem_Task.DESCRIPTION '
     + '       , MovementItem_Task.COMMENT '
     + '       , Movement_Task.OperDate '
     + '       , Movement_Task.InvNumber '
     + '       , Object_Partner.ValueData PartnerName  '
     + ' FROM  MovementItem_Task	 ' + DateSql
     + '       LEFT JOIN Object_Partner ON Object_Partner.ID = MovementItem_Task.PartnerId ' + WhereSql
     + ' GROUP BY MovementItem_Task.ID  '
     + ' ORDER BY Movement_Task.OperDate DESC ';

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
    conMain.ExecSQL('UPDATE MovementItem_Task SET Closed = 1, Comment = ' + QuotedStr(ATaskComment) +
      ', isSync = 0 WHERE Id = ' + IntToStr(ATasksId));
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

      qryNewId.Open('SELECT Min(ID) FROM Object_Juridical');
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

    qryNewId.Open('SELECT Min(ID) FROM Object_Partner');
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


{ TSyncData }

function TSyncData.AdaptQuotMark(S: string): string;
begin
//  Result := ReplaceStr(S, '''', '''||CHR (39)||''');
//  Result := ReplaceStr(Result, '"', '''||CHR (39)||''');
  Result := ReplaceStr(S, CHR (39), '`');
  Result := ReplaceStr(Result, '"', '`');
end;

procedure TSyncData.FeedbackMovementReturnIn(AGUID: string);
var
  MessageText: string;
  ReturnInProc: TdsdStoredProc;
  ReturnInItemProc: TdsdStoredProc;
begin
  ReturnInProc := TdsdStoredProc.Create(nil);
  ReturnInProc.OutputType := otDataSet;
  ReturnInProc.StoredProcName := 'gpGetMobile_Movement_ReturnIn';
  ReturnInProc.Params.AddParam('inGUID', ftString, ptInput, '');
  ReturnInProc.DataSet := TClientDataSet.Create(nil);

  ReturnInItemProc := TdsdStoredProc.Create(nil);
  ReturnInItemProc.OutputType := otDataSet;
  ReturnInItemProc.StoredProcName := 'gpSelectMobile_MovementItem_ReturnIn';
  ReturnInItemProc.Params.AddParam('inMovementGUID', ftString, ptInput, '');
  ReturnInItemProc.DataSet := TClientDataSet.Create(nil);

  try
    MessageText := UpdateMovementReturnInAuto(AGUID);

    if MessageText <> '' then
      raise Exception.Create(MessageText);

    ReturnInProc.ParamByName('inGUID').Value := AGUID;
    ReturnInProc.Execute(False, False, False);

    ReturnInProc.DataSet.First;
    if not ReturnInProc.DataSet.Eof then
    begin
      DM.conMain.ExecSQL('update Movement_ReturnIn ' +
                         'set ChangePercent = :inChangePercent ' +
                         '  , TotalCountKg = :inTotalCountKg ' +
                         '  , TotalSummPVAT = :inTotalSummPVAT ' +
                         'where GUID = :inGUID', [
                           ReturnInProc.DataSet.FieldByName('ChangePercent').AsFloat,
                           ReturnInProc.DataSet.FieldByName('TotalCountKg').AsFloat,
                           ReturnInProc.DataSet.FieldByName('TotalSummPVAT').AsFloat,
                           AGUID]);

      ReturnInItemProc.ParamByName('inMovementGUID').Value := AGUID;
      ReturnInItemProc.Execute(False, False, False);

      ReturnInItemProc.DataSet.First;
      while not ReturnInItemProc.DataSet.Eof do
      begin
        DM.conMain.ExecSQL('update MovementItem_ReturnIn ' +
                           'set GoodsId = :inGoodsId ' +
                           '  , GoodsKindId = :inGoodsKindId ' +
                           '  , Amount = :inAmount ' +
                           '  , Price = :inPrice ' +
                           '  , ChangePercent = :inChangePercent ' +
                           '  , isRecalcPrice = (Price <> :inRecalcPrice) ' +
                           'where GUID = :inGUID', [
                             ReturnInItemProc.DataSet.FieldByName('GoodsId').AsInteger,
                             ReturnInItemProc.DataSet.FieldByName('GoodsKindId').AsInteger,
                             ReturnInItemProc.DataSet.FieldByName('Amount').AsFloat,
                             ReturnInItemProc.DataSet.FieldByName('Price').AsFloat,
                             ReturnInItemProc.DataSet.FieldByName('ChangePercent').AsFloat,
                             ReturnInItemProc.DataSet.FieldByName('Price').AsFloat,
                             ReturnInItemProc.DataSet.FieldByName('GUID').AsString]);

        ReturnInItemProc.DataSet.Next;
      end;
    end;
  finally
    ReturnInProc.Free;
    ReturnInItemProc.Free;
  end;
end;

function TSyncData.GetMovementCountItems(AGUID: string): Integer;
var
  StoredProc : TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);

  with StoredProc, Params do
  begin
    OutputType := otResult;
    Clear;
    StoredProcName := 'gpGetMobile_Movement_CountItems';
    AddParam('inMovementGUID', ftString, ptInput, AGUID);
    AddParam('outItemsCount', ftInteger, ptOutput, 0);
  end;

  try
    StoredProc.Execute(False, False, False);
    Result := StoredProc.ParamByName('outItemsCount').Value;
  finally
    FreeAndNil(StoredProc);
  end;
end;

procedure TSyncData.SaveSyncDataOut(ADate: TDateTime);
var
  UploadStoredProc: TdsdStoredProc;
begin
  if DM.tblObject_Const.RecordCount > 0 then
  begin
    DM.tblObject_Const.Edit;
    DM.tblObject_ConstSyncDateOut.AsDateTime := ADate;
    DM.tblObject_Const.Post;
  end;

  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    UploadStoredProc.OutputType := otResult;

    UploadStoredProc.StoredProcName := 'gpUpdateMobile_ObjectDate_User_UpdateMobileFrom';
    UploadStoredProc.Params.Clear;
    UploadStoredProc.Params.AddParam('inUpdateMobileFrom', ftDateTime, ptInput, ADate);

    UploadStoredProc.Execute(False, False, False);
  finally
    FreeAndNil(UploadStoredProc);
  end;
end;

procedure TSyncData.SetMovementErased(AStoredProcName, AGUID: string);
var
  StoredProc : TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);

  with StoredProc, Params do
  begin
    OutputType := otResult;
    StoredProcName := AStoredProcName;
    AddParam('inMovementGUID', ftString, ptInput, AGUID);
  end;

  try
    StoredProc.Execute(False, False, False);
  finally
    FreeAndNil(StoredProc);
  end;
end;

procedure TSyncData.SetMovementErasedOrderExternal(AGUID: string);
begin
  SetMovementErased('gpSetMobileErased_Movement_OrderExternal', AGUID);
end;

procedure TSyncData.SetMovementErasedReturnIn(AGUID: string);
begin
  SetMovementErased('gpSetMobileErased_Movement_ReturnIn', AGUID);
end;

procedure TSyncData.SyncOrderExternal(AGUID: string);
var
  SqlText: string;
  ItemsCount, SendCount: Integer;
begin
  with DM.tblMovement_OrderExternal do
  begin
    if AGUID = '' then
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString + ' and PartnerId > 0'
    else
      Filter := 'GUID = ''' + AGUID + '''';

    Filtered := True;
    Open;

    try
      First;

      while not Eof do
      begin
        SqlText :=
          'DO $BODY$ ' +
          '  DECLARE vbSession TVarChar := ''' + gc_User.Session + '''; ' +
          'BEGIN ' +
          '  PERFORM gpInsertUpdateMobile_Movement_OrderExternal ( ' +
          '    inGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inInvNumber:= ''' + FieldByName('INVNUMBER').AsString + ''', ' +
          '    inOperDate:= ''' + FormatDateTime('dd.mm.yyyy', FieldByName('OPERDATE').AsDateTime) + ''', ' +
          '    inComment:= ''' + AdaptQuotMark(FieldByName('COMMENT').AsString) + ''', ' +
          '    inPartnerId:= ' + IntToStr(FieldByName('PARTNERID').AsInteger) + ', ' +
          '    inUnitId:= ' + IntToStr(FieldByName('UNITID').AsInteger) + ', ' +
          '    inPaidKindId:= ' + IntToStr(FieldByName('PAIDKINDID').AsInteger) + ', ' +
          '    inContractId:= ' + IntToStr(FieldByName('CONTRACTID').AsInteger) + ', ' +
          '    inPriceListId:= ' + IntToStr(FieldByName('PRICELISTID').AsInteger) + ', ' +
          '    inPriceWithVAT:= ' + BoolToStr(FieldByName('PRICEWITHVAT').AsBoolean, True) + ', ' +
          '    inVATPercent:= ' + ReplaceStr(FormatFloat('0.0###', FieldByName('VATPERCENT').AsFloat), ',', '.') + ', ' +
          '    inChangePercent:= ' + ReplaceStr(FormatFloat('0.0###', FieldByName('CHANGEPERCENT').AsFloat), ',', '.') + ', ' +
          '    inInsertDate:= ''' + FormatDateTime('dd.mm.yyyy hh:mm:ss', FieldByName('INSERTDATE').AsDateTime) + ''', ' +
          '    inSession:= vbSession); ';

        // Загружаем товары заявок
        DM.tblMovementItem_OrderExternal.Close;
        DM.tblMovementItem_OrderExternal.Filter := 'Amount <> 0 and MovementId = ' + FieldByName('ID').AsString;
        DM.tblMovementItem_OrderExternal.Filtered := true;
        DM.tblMovementItem_OrderExternal.Open;
        DM.tblMovementItem_OrderExternal.First;
        ItemsCount := 0;

        while not DM.tblMovementItem_OrderExternal.Eof do
        begin
          SqlText := SqlText +
            '  PERFORM gpInsertUpdateMobile_MovementItem_OrderExternal ( ' +
            '    inGUID:= ''' + DM.tblMovementItem_OrderExternal.FieldByName('GUID').AsString + ''', ' +
            '    inMovementGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
            '    inGoodsId:= ' + IntToStr(DM.tblMovementItem_OrderExternal.FieldByName('GOODSID').AsInteger) + ', ' +
            '    inGoodsKindId:= ' + IntToStr(DM.tblMovementItem_OrderExternal.FieldByName('GOODSKINDID').AsInteger) + ', ' +
            '    inChangePercent:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_OrderExternal.FieldByName('CHANGEPERCENT').AsFloat), ',', '.') + ', ' +
            '    inAmount:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_OrderExternal.FieldByName('AMOUNT').AsFloat), ',', '.') + ', ' +
            '    inPrice:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_OrderExternal.FieldByName('PRICE').AsFloat), ',', '.') + ', ' +
            '    inSession:= vbSession); ';

          Inc(ItemsCount);
          DM.tblMovementItem_OrderExternal.Next;
        end;

        SqlText := SqlText +
          '  PERFORM gpSetMobile_Movement_Status ( ' +
          '    inMovementGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inStatusId:= zc_Enum_Status_Erased(), ' +
          '    inSession:= vbSession); ' +
          'END; $BODY$';

        uExec.ExecSQL(SqlText);

        SendCount := GetMovementCountItems(FieldByName('GUID').AsString);
        if ItemsCount = SendCount then
        begin
          SetMovementErasedOrderExternal(FieldByName('GUID').AsString);

          Edit;
          FieldByName('IsSync').AsBoolean := True;
          Post;
        end else
          raise Exception.CreateFmt(
            'По заявке №%s отправились %d позиций из %d. Требуется повторная синхронизация',
            [FieldByName('INVNUMBER').AsString, SendCount, ItemsCount]);

        if AGUID <> '' then
          Next;
      end;

      if AGUID <> '' then
        SaveSyncDataOut(Now);
    finally
      DM.tblMovementItem_OrderExternal.Close;
      DM.tblMovementItem_OrderExternal.Filter := '';
      DM.tblMovementItem_OrderExternal.Filtered := False;
      Close;
      Filter := '';
      Filtered := False;
    end;
  end;
end;

procedure TSyncData.SyncReturnIn(AGUID: string);
var
  SqlText: string;
  ItemsCount, SendCount: Integer;
begin
  // Загружаем шапки возвратов
  with DM.tblMovement_ReturnIn do
  begin
    if AGUID = '' then
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString
    else
      Filter := 'GUID = ''' + AGUID + '''';

    Filtered := True;
    Open;

    try
      First;

      while not Eof do
      begin
        SqlText :=
          'DO $BODY$ ' +
          '  DECLARE vbSession TVarChar := ''' + gc_User.Session + '''; ' +
          'BEGIN ' +
          '  PERFORM gpInsertUpdateMobile_Movement_ReturnIn ( ' +
          '    inGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inInvNumber:= ''' + FieldByName('INVNUMBER').AsString + ''', ' +
          '    inOperDate:= ''' + FormatDateTime('dd.mm.yyyy', FieldByName('OPERDATE').AsDateTime) + ''', ' +
          '    inStatusId:= ' + IntToStr(FieldByName('STATUSID').AsInteger) + ', ' +
          '    inPriceWithVAT:= ' + BoolToStr(FieldByName('PRICEWITHVAT').AsBoolean, True) + ', ' +
          '    inInsertDate:= ''' + FormatDateTime('dd.mm.yyyy hh:mm:ss', FieldByName('INSERTDATE').AsDateTime) + ''', ' +
          '    inVATPercent:= ' + ReplaceStr(FormatFloat('0.0###', FieldByName('VATPERCENT').AsFloat), ',', '.') + ', ' +
          '    inChangePercent:= ' + ReplaceStr(FormatFloat('0.0###', FieldByName('CHANGEPERCENT').AsFloat), ',', '.') + ', ' +
          '    inPaidKindId:= ' + IntToStr(FieldByName('PAIDKINDID').AsInteger) + ', ' +
          '    inPartnerId:= ' + IntToStr(FieldByName('PARTNERID').AsInteger) + ', ' +
          '    inUnitId:= ' + IntToStr(FieldByName('UNITID').AsInteger) + ', ' +
          '    inContractId:= ' + IntToStr(FieldByName('CONTRACTID').AsInteger) + ', ' +
          '    inComment:= ''' + AdaptQuotMark(FieldByName('COMMENT').AsString) + ''', ' +
          '    inSubjectDocId:= ' + IntToStr(FieldByName('SubjectDocId').AsInteger) + ', ' +
          '    inSession:= vbSession); ';

        // Загружаем возвращаемые товары
        DM.tblMovementItem_ReturnIn.Close;
        DM.tblMovementItem_ReturnIn.Filter := 'Amount <> 0 and MovementId = ' + FieldByName('ID').AsString;
        DM.tblMovementItem_ReturnIn.Filtered := true;
        DM.tblMovementItem_ReturnIn.Open;
        DM.tblMovementItem_ReturnIn.First;
        ItemsCount := 0;

        while not DM.tblMovementItem_ReturnIn.Eof do
        begin
          SqlText := SqlText +
            '  PERFORM gpInsertUpdateMobile_MovementItem_ReturnIn ( ' +
            '    inGUID:= ''' + DM.tblMovementItem_ReturnIn.FieldByName('GUID').AsString + ''', ' +
            '    inMovementGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
            '    inGoodsId:= ' + IntToStr(DM.tblMovementItem_ReturnIn.FieldByName('GOODSID').AsInteger) + ', ' +
            '    inGoodsKindId:= ' + IntToStr(DM.tblMovementItem_ReturnIn.FieldByName('GOODSKINDID').AsInteger) + ', ' +
            '    inAmount:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_ReturnIn.FieldByName('AMOUNT').AsFloat), ',', '.') + ', ' +
            '    inPrice:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_ReturnIn.FieldByName('PRICE').AsFloat), ',', '.') + ', ' +
            '    inChangePercent:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_ReturnIn.FieldByName('CHANGEPERCENT').AsFloat), ',', '.') + ', ' +
            '    inSubjectDocId:= ' + IntToStr(DM.tblMovementItem_ReturnIn.FieldByName('SubjectDocId').AsInteger) + ', ' +
            '    inSession:= vbSession); ';

          Inc(ItemsCount);
          DM.tblMovementItem_ReturnIn.Next;
        end;

        SqlText := SqlText +
          '  PERFORM gpSetMobile_Movement_Status ( ' +
          '    inMovementGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inStatusId:= zc_Enum_Status_Erased(), ' +
          '    inSession:= vbSession); ' +
          'END; $BODY$';

        uExec.ExecSQL(SqlText);

        SendCount := GetMovementCountItems(FieldByName('GUID').AsString);
        if ItemsCount = SendCount then
        begin
          SetMovementErasedReturnIn(FieldByName('GUID').AsString);

          Edit;
          FieldByName('IsSync').AsBoolean := True;
          Post;

          if AGUID <> '' then
            FeedbackMovementReturnIn(AGUID);
        end else
          raise Exception.CreateFmt(
            'По возврату №%s отправились %d позиций из %d. Требуется повторная синхронизация',
            [FieldByName('INVNUMBER').AsString, SendCount, ItemsCount]);

        if AGUID <> '' then
          Next;
      end;

      if AGUID <> '' then
        SaveSyncDataOut(Now);
    finally
      DM.tblMovementItem_ReturnIn.Close;
      DM.tblMovementItem_ReturnIn.Filter := '';
      DM.tblMovementItem_ReturnIn.Filtered := False;
      Close;
      Filter := '';
      Filtered := False;
    end;
  end;
end;

procedure TSyncData.SyncRouteMember;
var
  SqlText: string;
  i : Integer;
begin
  with DM.tblMovement_RouteMember do
  begin
    Filter := 'isSync = 0';
    Filtered := True;
    Open;

    try
      First;
      SqlText :=
        'DO $BODY$ ' +
        '  DECLARE vbSession TVarChar := ''' + gc_User.Session + '''; ' +
        'BEGIN ';

        i:= 0;
      while not Eof do
      begin
        SqlText := SqlText +
          '  PERFORM gpInsertUpdateMobile_Movement_RouteMember ( ' +
          '    inGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inInvNumber:= ''' + FieldByName('ID').AsString + ''', ' +
          '    inInsertDate:= ''' + FormatDateTime('dd.mm.yyyy hh:mm:ss', FieldByName('INSERTDATE').AsDateTime) + ''', ' +
          '    inGPSN:= ' + ReplaceStr(FormatFloat('0.0###', FieldByName('GPSN').AsFloat), ',', '.') + ', ' +
          '    inGPSE:= ' + ReplaceStr(FormatFloat('0.0###', FieldByName('GPSE').AsFloat), ',', '.') + ', ' +
          '    inAddressByGPS:= ''' + AdaptQuotMark(FieldByName('AddressByGPS').AsString) + ''', ' +
          '    inSession:= vbSession); ';

          i:= i + 1;
          if i > 100 then
          begin
               i:= 0;
               SqlText := SqlText +
                 ' END; $BODY$';

               uExec.ExecSQL(SqlText);
               //
               SqlText:= 'DO $BODY$ ' +
                         '  DECLARE vbSession TVarChar := ''' + gc_User.Session + '''; ' +
                         'BEGIN ';
          end;


        Next;
      end;

      SqlText := SqlText +
        'END; $BODY$';

      uExec.ExecSQL(SqlText);

      First;
      while not Eof do
      begin
        Edit;
        FieldByName('IsSync').AsBoolean := True;
        Post;
      end;
    finally
      Close;
      Filtered := False;
      Filter := '';
    end;
  end;
end;

procedure TSyncData.SyncStoreReal(AGUID: string);
var
  SqlText: string;
  ItemsCount, SendCount: Integer;
begin
  with DM.tblMovement_StoreReal do
  begin
    if AGUID = '' then
      Filter := 'isSync = 0 and StatusId = ' + DM.tblObject_ConstStatusId_Complete.AsString
    else
      Filter := 'GUID = ''' + AGUID + '''';

    Filtered := True;
    Open;

    try
      First;

      while not Eof do
      begin
        SqlText :=
          'DO $BODY$ ' +
          '  DECLARE vbSession TVarChar := ''' + gc_User.Session + '''; ' +
          'BEGIN ' +
          '  PERFORM gpInsertUpdateMobile_Movement_StoreReal ( ' +
          '    inGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inInvNumber:= ''' + FieldByName('INVNUMBER').AsString + ''', ' +
          '    inOperDate:= ''' + FormatDateTime('dd.mm.yyyy', FieldByName('OPERDATE').AsDateTime) + ''', ' +
          '    inPartnerId:= ' + IntToStr(FieldByName('PARTNERID').AsInteger) + ', ' +
          '    inComment:= ''' + AdaptQuotMark(FieldByName('COMMENT').AsString) + ''', ' +
          '    inInsertDate:= ''' + FormatDateTime('dd.mm.yyyy hh:mm:ss', FieldByName('INSERTDATE').AsDateTime) + ''', ' +
          '    inSession:= vbSession); ';

        // Загружаем товары остатков
        DM.tblMovementItem_StoreReal.Close;
        DM.tblMovementItem_StoreReal.Filter := 'Amount <> 0 and MovementId = ' + FieldByName('ID').AsString;
        DM.tblMovementItem_StoreReal.Filtered := true;
        DM.tblMovementItem_StoreReal.Open;
        DM.tblMovementItem_StoreReal.First;
        ItemsCount := 0;

        while not DM.tblMovementItem_StoreReal.Eof do
        begin
          SqlText := SqlText +
            '  PERFORM gpInsertUpdateMobile_MovementItem_StoreReal ( ' +
            '    inGUID:= ''' + DM.tblMovementItem_StoreReal.FieldByName('GUID').AsString + ''', ' +
            '    inMovementGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
            '    inGoodsId:= ' + IntToStr(DM.tblMovementItem_StoreReal.FieldByName('GOODSID').AsInteger) + ', ' +
            '    inAmount:= ' + ReplaceStr(FormatFloat('0.0###', DM.tblMovementItem_StoreReal.FieldByName('AMOUNT').AsFloat), ',', '.') + ', ' +
            '    inGoodsKindId:= ' + IntToStr(DM.tblMovementItem_StoreReal.FieldByName('GOODSKINDID').AsInteger) + ', ' +
            '    inSession:= vbSession); ';

          Inc(ItemsCount);
          DM.tblMovementItem_StoreReal.Next;
        end;

        SqlText := SqlText +
          '  PERFORM gpSetMobile_Movement_Status ( ' +
          '    inMovementGUID:= ''' + FieldByName('GUID').AsString + ''', ' +
          '    inStatusId:= zc_Enum_Status_Complete(), ' +
          '    inSession:= vbSession); ' +
          'END; $BODY$';

        uExec.ExecSQL(SqlText);

        SendCount := GetMovementCountItems(FieldByName('GUID').AsString);
        if ItemsCount = SendCount then
        begin
          Edit;
          FieldByName('IsSync').AsBoolean := True;
          Post;
        end else
          raise Exception.CreateFmt(
            'По факт. остатку №%s отправились %d позиций из %d. Требуется повторная синхронизация',
            [FieldByName('INVNUMBER').AsString, SendCount, ItemsCount]);

        if AGUID <> '' then
          Next;  
      end;

      if AGUID <> '' then
        SaveSyncDataOut(Now);
    finally
      DM.tblMovementItem_StoreReal.Close;
      DM.tblMovementItem_StoreReal.Filter := '';
      DM.tblMovementItem_StoreReal.Filtered := False;
      Close;
      Filter := '';
      Filtered := False;
    end;
  end;
end;

function TSyncData.UpdateMovementReturnInAuto(AGUID: string): string;
var
  StoredProc : TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);

  with StoredProc, Params do
  begin
    OutputType := otBlob;
    StoredProcName := 'gpUpdateMobile_Movement_ReturnIn_Auto';
    AddParam('inMovementGUID', ftString, ptInput, AGUID);
  end;

  try
    Result := StoredProc.Execute(False, False, False);
  finally
    FreeAndNil(StoredProc);
  end;
end;

initialization
  Structure := TStructure.Create;
  SyncData := TSyncData.Create;
  Randomize;
finalization
  FreeAndNil(Structure);
  FreeAndNil(SyncData);
end.



