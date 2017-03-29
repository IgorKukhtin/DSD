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
  FMX.Dialogs;

CONST
  DataBaseFileName = 'aMobile.sdb';

  BasePartnerQuery = 'select P.Id, P.CONTRACTID, J.VALUEDATA Name, C.CONTRACTTAGNAME || '' '' || C.VALUEDATA ContractName, ' +
    'P.ADDRESS, P.GPSN, P.GPSE, P.SCHEDULE, P.PRICELISTID, C.PAIDKINDID, C.CHANGEPERCENT, PL.PRICEWITHVAT, PL.VATPERCENT, ' +
    'P.CalcDayCount, P.OrderDayCount, P.isOperDateOrder ' +
    'from OBJECT_PARTNER P ' +
    'JOIN OBJECT_JURIDICAL J ON J.ID = P.JURIDICALID and J.ISERASED = 0 ' +
    'JOIN Object_PriceList PL ON PL.ID = P.PRICELISTID and PL.ISERASED = 0 ' +
    'JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID and C.ISERASED = 0 where P.ISERASED = 0 ';

type
  TProgressThread = class(TThread)
  private
    { Private declarations }
    FProgress : integer;

    procedure Update;
  protected
    procedure Execute; override;
  end;

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
  protected
    procedure Execute; override;
  end;

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
    qryPartnerPRICELISTID: TIntegerField;
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
    cdsOrderExternalWeigth: TStringField;
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
    tblMovement_VisitStatusId: TIntegerField;
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
    qryPhotoGroupsStatusId: TIntegerField;
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
    tblMovement_ReturnInChecked: TBooleanField;
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
    cdsReturnInWeigth: TStringField;
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
    cdsJuridicalCollationPayment: TStringField;
    cdsJuridicalCollationDebet: TFloatField;
    cdsJuridicalCollationKredit: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryGoodsForPriceListCalcFields(DataSet: TDataSet);
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

    procedure SynchronizeWithMainDatabase(LoadData: boolean = true; UploadData: boolean = true);

    function SaveStoreReal(OldStoreRealId : string; Comment: string;
      DelItems : string; var ErrorMessage : string) : boolean;
    procedure LoadStoreReal(AId: string = '');
    procedure AddedGoodsToStoreReal(AGoods : string);
    procedure DefaultStoreRealItems;
    procedure LoadStoreRealItems(AId: integer);
    procedure GenerateStoreRealItemsList;

    function SaveOrderExternal(OldOrderExternalId : string; OperDate: TDate;
      ToralPrice, TotalWeight: Currency; DelItems : string; var ErrorMessage : string) : boolean;
    procedure LoadOrderExternal(AId: string = '');
    procedure AddedGoodsToOrderExternal(AGoods : string);
    procedure DefaultOrderExternalItems;
    procedure LoadOrderExtrenalItems(AId: integer);
    procedure GenerateOrderExtrenalItemsList;

    function SaveReturnIn(OldReturnInId : string; OperDate: TDate; Comment : string;
      ToralPrice, TotalWeight: Currency; DelItems : string; var ErrorMessage : string) : boolean;
    procedure LoadReturnIn(AId: string = '');
    procedure AddedGoodsToReturnIn(AGoods : string);
    procedure DefaultReturnInItems;
    procedure LoadReturnInItems(AId: integer);
    procedure GenerateReturnInItemsList;

    procedure SavePhotoGroup(AGroupName: string);
    procedure LoadPhotoGroups;

    function GenerateJuridicalCollation(DateStart, DateEnd: TDate; JuridicalId, ContractId: integer): boolean;

    property Connected: Boolean read FConnected;
  end;

var
  DM: TDM;
  Structure: TStructure;
  ProgressThread : TProgressThread;
  SyncThread : TSyncThread;

implementation

uses
  System.IOUtils, CursorUtils, CommonData, Authentication, Storage, uMain;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

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

procedure TSyncThread.GetConfigurationInfo;
var
  x, y : integer;
  GetStoredProc : TdsdStoredProc;
  str, str1 : string;
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
          FindRec := false;
          if AName = 'Partner' then
            FindRec := CurDictTable.Locate('Id;ContractId', VarArrayOf([FieldByName('Id').AsInteger, FieldByName('ContractId').AsInteger]))
          else
            FindRec := CurDictTable.Locate('Id', FieldByName('Id').AsInteger);

          if FindRec then
            CurDictTable.Edit
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
      Filter := 'isSync = 0 and StatusId <> ' + DM.tblObject_ConstStatusId_Erased.AsString;
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
            end;
          end;

          Next;
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

procedure TSyncThread.UploadOrderExternal;
var
  UploadStoredProc : TdsdStoredProc;
begin
  UploadStoredProc := TdsdStoredProc.Create(nil);
  try
    // Загружаем шапки остатков
    UploadStoredProc.OutputType := otResult;

    with DM.tblMovement_OrderExternal do
    begin
      Filter := 'isSync = 0 and StatusId <> ' + DM.tblObject_ConstStatusId_Erased.AsString;
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
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
          UploadStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, FieldByName('PAIDKINDID').AsInteger);
          UploadStoredProc.Params.AddParam('inContractId', ftInteger, ptInput, FieldByName('CONTRACTID').AsInteger);
          UploadStoredProc.Params.AddParam('inPriceListId', ftInteger, ptInput, FieldByName('PRICELISTID').AsInteger);
          UploadStoredProc.Params.AddParam('inPriceWithVAT', ftBoolean, ptInput, FieldByName('PRICEWITHVAT').AsBoolean);
          UploadStoredProc.Params.AddParam('inVATPercent', ftFloat, ptInput, FieldByName('VATPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inChangePercent', ftFloat, ptInput, FieldByName('CHANGEPERCENT').AsFloat);

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
            end;
          end;

          Next;
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
      Filter := 'isSync = 0 and StatusId <> ' + DM.tblObject_ConstStatusId_Erased.AsString;
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
          UploadStoredProc.Params.AddParam('inChecked', ftBoolean, ptInput, FieldByName('CHECKED').AsBoolean);
          UploadStoredProc.Params.AddParam('inPriceWithVAT', ftBoolean, ptInput, FieldByName('PRICEWITHVAT').AsBoolean);
          UploadStoredProc.Params.AddParam('inInsertDate', ftDateTime, ptInput, FieldByName('INSERTDATE').AsDateTime);
          UploadStoredProc.Params.AddParam('inVATPercent', ftFloat, ptInput, FieldByName('VATPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inChangePercent', ftFloat, ptInput, FieldByName('CHANGEPERCENT').AsFloat);
          UploadStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, FieldByName('PAIDKINDID').AsInteger);
          UploadStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, FieldByName('PARTNERID').AsInteger);
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
            end;
          end;

          Next;
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

procedure TSyncThread.Execute;
var
  Res : string;
begin
  Res := '';

  FAllProgress := -1;
  FAllMax := 0;

  if LoadData then
    FAllMax := FAllMax + 16;  // Количесто операций при загрузке данных из центра

  if UploadData then
    FAllMax := FAllMax + 3;  // Количесто операций при сохранении данных в центр

  Synchronize(procedure
              begin
                frmMain.pProgress.Visible := true;
                frmMain.vsbMain.Enabled := false;
              end);

  ProgressThread := TProgressThread.Create(true);
  try
    ProgressThread.FreeOnTerminate := true;
    ProgressThread.Start;

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
        {
        SetNewProgressTask('Загрузка заданий');
        GetDictionaries('MovementTask');
        GetDictionaries('MovementItemTask');
        }
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

    if UploadData then
    begin
      try
        SetNewProgressTask('Сохранение остатков');
        UploadStoreReal;

        SetNewProgressTask('Сохранение заявок');
        UploadOrderExternal;

        SetNewProgressTask('Сохранение возвратов');
        UploadReturnIn;

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

    if SameText(ATable.TableName, 'Object_Partner') then
      FIndexes.Add('CREATE UNIQUE INDEX IF NOT EXISTS `' + IndexName + '` ON `' + ATable.TableName + '` (`Id`,`ContractId`)')
    else
    if SameText(ATable.Fields[0].FieldName, 'Id') and (ATable.Fields[0].DataType <> ftAutoInc) then
      FIndexes.Add('CREATE UNIQUE INDEX IF NOT EXISTS `' + IndexName + '` ON `' + ATable.TableName + '` (`Id`)');
  End;
end;

procedure TStructure.MakeDopIndex(ATable: TFDTable);
var
  IndexName: String;
begin
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
        try
          TempTable.Connection := conMain;
          TempTable.TableName := T.TableName;
          TempTable.Open;
          conMain.StartTransaction;
          try
            T.CreateTable(True);
            Structure.OpenDS(T);
            TempTable.First;
            while not TempTable.Eof do
            Begin
              T.Append;
              for J := 0 to TempTable.FieldCount - 1 do
                if T.FindField(TempTable.Fields[J].FieldName) <> nil then
                  T.FieldByName(TempTable.Fields[J].FieldName).Value :=
                    TempTable.Fields[J].Value;
              T.Post;
              TempTable.Next;
            End;
            conMain.Commit;
          except
            on E: Exception do
            Begin
              //WriteLogE(E.Message);
              conMain.Rollback;
              Exit(False);
            End;
          end;
        finally
          freeAndNil(TempTable);
        end;
      End;
    end;

  end;

  result := True;
end;

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
end;


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

function TDM.SaveStoreReal(OldStoreRealId : string; Comment: string;
  DelItems : string; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  Result := false;

  if OldStoreRealId = '' then
  begin
    NewInvNumber := 1;

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

    if OldStoreRealId = '' then
    begin
      tblMovement_StoreReal.Append;

      CreateGUID(GlobalId);
      tblMovement_StoreRealGUID.AsString := GUIDToString(GlobalId);
      tblMovement_StoreRealInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_StoreRealOperDate.AsDateTime := Date();
      tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
      tblMovement_StoreRealPartnerId.AsInteger := qryPartnerId.AsInteger;
      tblMovement_StoreRealComment.AsString := Comment;
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
      if tblMovement_StoreReal.Locate('Id', OldStoreRealId) then
      begin
        tblMovement_StoreReal.Edit;

        tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        tblMovement_StoreRealComment.AsString := Comment;

        tblMovement_StoreReal.Post;

        MovementId := StrToInt(OldStoreRealId);
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

    if OldStoreRealId = '' then
      LoadStoreReal(IntToStr(MovementId))
    else
    begin
      cdsStoreReals.Edit;

      cdsStoreRealsComment.AsString := Comment;
      cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString;

      cdsStoreReals.Post;
    end;

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

procedure TDM.LoadStoreReal(AId : string = '');
var
  qryStoreReals : TFDQuery;
begin
  if AId = '' then
  begin
    cdsStoreReals.Open;
    cdsStoreReals.EmptyDataSet;
  end;

  qryStoreReals := TFDQuery.Create(nil);
  try
    qryStoreReals.Connection := conMain;
    qryStoreReals.SQL.Text := 'select ID, OPERDATE, COMMENT, ISSYNC, STATUSID' +
      ' from Movement_StoreReal' +
      ' where PARTNERID = ' + qryPartnerId.AsString +
      ' and STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString;
    if AId <> '' then
      qryStoreReals.SQL.Text := qryStoreReals.SQL.Text + ' and ID = ' + AId;
    qryStoreReals.SQL.Text := qryStoreReals.SQL.Text + ' order by OPERDATE desc';

    qryStoreReals.Open;
    cdsStoreReals.Open;

    qryStoreReals.First;
    while not qryStoreReals.EOF do
    begin
      cdsStoreReals.Append;
      cdsStoreRealsId.AsInteger := qryStoreReals.FieldByName('ID').AsInteger;
      cdsStoreRealsComment.AsString := qryStoreReals.FieldByName('COMMENT').AsString;
      cdsStoreRealsOperDate.AsDateTime := qryStoreReals.FieldByName('OPERDATE').AsDateTime;
      cdsStoreRealsName.AsString := 'Остатки на ' + FormatDateTime('DD.MM.YYYY', qryStoreReals.FieldByName('OPERDATE').AsDateTime);

      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Erased.AsString
      else
        cdsStoreRealsStatus.AsString := 'Статус: Неизвестный';

      cdsStoreReals.Post;

      qryStoreReals.Next;
    end;

    qryStoreReals.Close;
  finally
    qryStoreReals.Free;
  end;
end;

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

procedure TDM.DefaultStoreRealItems;
var
  qryGoodsListSale : TFDQuery;
begin
  cdsStoreRealItems.Open;
  cdsStoreRealItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || ' +
      'M.VALUEDATA || '';0'' ' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID AND GK.ISERASED = 0 ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
      'WHERE GLS.PARTNERID = ' + qryPartnerId.AsString + ' and GLS.ISERASED = 0 order by G.VALUEDATA ';

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
  end;
end;

procedure TDM.LoadStoreRealItems(AId : integer);
var
  qryGoodsListSale : TFDQuery;
begin
  cdsStoreRealItems.Open;
  cdsStoreRealItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ISR.ID || '';'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || ' +
      'M.VALUEDATA || '';'' || ISR.AMOUNT ' +
      'from MOVEMENTITEM_STOREREAL ISR ' +
      'JOIN OBJECT_GOODS G ON ISR.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = ISR.GOODSKINDID ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
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
  end;
end;

procedure TDM.qryGoodsForPriceListCalcFields(DataSet: TDataSet);
var
  PriceWithoutVat, PriceWithVat : string;
begin
  if qryPriceListPriceWithVAT.AsBoolean then
  begin
    PriceWithoutVat := FormatFloat('0.00', DataSet.FieldByName('Price').AsFloat * 100 / (100 + qryPriceListVATPercent.AsFloat));
    PriceWithVat := FormatFloat('0.00', DataSet.FieldByName('Price').AsFloat);
  end
  else
  begin
    PriceWithoutVat := FormatFloat('0.00', DataSet.FieldByName('Price').AsFloat);
    PriceWithVat := FormatFloat('0.00', DataSet.FieldByName('Price').AsFloat * (100 + qryPriceListVATPercent.AsFloat) / 100);
  end;

  DataSet.FieldByName('FullPrice').AsString := 'Цена: ' + PriceWithoutVat +' (с НДС ' + PriceWithVat +
    ') за ' + DataSet.FieldByName('Measure').AsString;
end;

procedure TDM.GenerateStoreRealItemsList;
begin
  qryGoodsItems.SQL.Text := 'select G.ID GoodsID, GK.ID GoodsKindID, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, ''-'' PromoPrice, ' +
    'GLK.REMAINS, PI.ORDERPRICE PRICE, M.VALUEDATA MEASURE, ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || ' +
    'GK.VALUEDATA || '';'' || M.VALUEDATA || '';0'' FullInfo, G.VALUEDATA || '';0'' SearchName ' +
    'from OBJECT_GOODS G ' +
    'JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID AND GLK.ISERASED = 0 ' +
    'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID AND GK.ISERASED = 0 ' +
    'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
    'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
    'WHERE G.ISERASED = 0 order by Name';

  qryGoodsItems.ParamByName('PRICELISTID').AsInteger := DM.qryPartnerPRICELISTID.AsInteger;
  qryGoodsItems.Open;
end;


function TDM.SaveOrderExternal(OldOrderExternalId : string; OperDate: TDate;
  ToralPrice, TotalWeight: Currency; DelItems : string; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  Result := false;

  if OldOrderExternalId = '' then
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
  end;

  conMain.StartTransaction;
  try
    tblMovement_OrderExternal.Open;

    if OldOrderExternalId = '' then
    begin
      tblMovement_OrderExternal.Append;

      CreateGUID(GlobalId);
      tblMovement_OrderExternalGUID.AsString := GUIDToString(GlobalId);
      tblMovement_OrderExternalInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
      tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
      tblMovement_OrderExternalPartnerId.AsInteger := qryPartnerId.AsInteger;
      tblMovement_OrderExternalPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
      tblMovement_OrderExternalContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      tblMovement_OrderExternalPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;
      tblMovement_OrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
      tblMovement_OrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
      tblMovement_OrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
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
      if tblMovement_OrderExternal.Locate('Id', OldOrderExternalId) then
      begin
        tblMovement_OrderExternal.Edit;

        tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
        tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        tblMovement_OrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
        tblMovement_OrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
        tblMovement_OrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
        tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
        tblMovement_OrderExternalTotalSumm.AsFloat := ToralPrice;

        tblMovement_OrderExternal.Post;

        MovementId := StrToInt(OldOrderExternalId);
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
          tblMovementItem_OrderExternalChangePercent.AsFloat := DM.qryPartnerChangePercent.AsFloat;

          tblMovementItem_OrderExternal.Post;
        end
        else
        begin
          if tblMovementItem_OrderExternal.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_OrderExternal.Edit;

            tblMovementItem_OrderExternalChangePercent.AsFloat := DM.qryPartnerChangePercent.AsFloat;
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

    if OldOrderExternalId = '' then
      LoadOrderExternal(IntToStr(MovementId))
    else
    begin
      cdsOrderExternal.Edit;

      cdsOrderExternalOperDate.AsDateTime := OperDate;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat('0.00', ToralPrice);
      cdsOrderExternalWeigth.AsString := 'Вес: ' + FormatFloat('0.00', TotalWeight);
      cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString;

      cdsOrderExternal.Post;
    end;

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

procedure TDM.LoadOrderExternal(AId : string = '');
var
  qryOrderExternal : TFDQuery;
begin
  if AId = '' then
  begin
    cdsOrderExternal.Open;
    cdsOrderExternal.EmptyDataSet;
  end;

  qryOrderExternal := TFDQuery.Create(nil);
  try
    qryOrderExternal.Connection := conMain;
    qryOrderExternal.SQL.Text := 'select ID, OPERDATE, TOTALCOUNTKG, TOTALSUMM, ISSYNC, STATUSID' +
      ' from MOVEMENT_ORDEREXTERNAL' +
      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
      ' and STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString;
    if AId <> '' then
      qryOrderExternal.SQL.Text := qryOrderExternal.SQL.Text + ' and ID = ' + AId;
    qryOrderExternal.SQL.Text := qryOrderExternal.SQL.Text + ' order by OPERDATE desc';

    qryOrderExternal.Open;
    cdsOrderExternal.Open;

    qryOrderExternal.First;
    while not qryOrderExternal.EOF do
    begin
      cdsOrderExternal.Append;
      cdsOrderExternalid.AsInteger := qryOrderExternal.FieldByName('ID').AsInteger;
      cdsOrderExternalOperDate.AsDateTime := qryOrderExternal.FieldByName('OPERDATE').AsDateTime;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', qryOrderExternal.FieldByName('OPERDATE').AsDateTime);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat('0.00', qryOrderExternal.FieldByName('TOTALSUMM').AsFloat);
      cdsOrderExternalWeigth.AsString := 'Вес: ' + FormatFloat('0.00', qryOrderExternal.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Erased.AsString
      else
        cdsOrderExternalStatus.AsString := 'Статус: Неизвестный';

      cdsOrderExternal.Post;

      qryOrderExternal.Next;
    end;

    qryOrderExternal.Close;
  finally
    qryOrderExternal.Free;
  end;
end;

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

  if (ArrValue[5] = '0') or (qryPartnerCalcDayCount.AsFloat = 0) then // рекомендуемое количество
    cdsOrderItemsRecommend.AsString := '-'
  else
  begin
    if StrToFloatDef(ArrValue[5], 0) - StrToFloatDef(ArrValue[6], 0) <= 0 then
      cdsOrderItemsRecommend.AsString := '0'
    else
    begin
      Recommend := (StrToFloatDef(ArrValue[5], 0) - StrToFloatDef(ArrValue[6], 0)) / qryPartnerCalcDayCount.AsFloat *
        qryPartnerOrderDayCount.AsFloat - StrToFloatDef(ArrValue[6], 0);
      if Recommend <= 0 then
        cdsOrderItemsRecommend.AsString := '0'
      else
        cdsOrderItemsRecommend.AsString := FormatFloat('0.00', Recommend);
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

procedure TDM.DefaultOrderExternalItems;
var
  qryGoodsListSale : TFDQuery;
  PriceField, PromoPriceField : string;
begin
  cdsOrderItems.Open;
  cdsOrderItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;

    if qryPartnerisOperDateOrder.AsBoolean then
      PriceField := 'OrderPrice'
    else
      PriceField := 'SalePrice';

    if qryPartnerPriceWithVAT.AsBoolean then
      PromoPriceField := 'PriceWithVAT'
    else
      PromoPriceField := 'PriceWithOutVAT';

    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || ' +
      'GK.VALUEDATA || '';'' || GLS.AMOUNTCALC || '';'' || IFNULL(SRI.AMOUNT, 0) || '';'' || ' +
      'PI.' + PriceField + ' || '';'' || M.VALUEDATA || '';'' || G.WEIGHT || '';'' || ' +
      'IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';0''' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID AND GK.ISERASED = 0 ' +
      'LEFT JOIN MOVEMENT_STOREREAL SR ON SR.PARTNERID = :PARTNERID ' +
      'AND DATE(SR.OPERDATE) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date())) + ' AND SR.STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
      'LEFT JOIN MOVEMENTITEM_STOREREAL SRI ON SRI.GOODSID = G.ID AND SRI.GOODSKINDID = GK.ID AND SRI.MOVEMENTID = SR.ID ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
      'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
      'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
      'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
      'WHERE GLS.PARTNERID = :PARTNERID and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.ParamByName('PARTNERID').AsInteger := qryPartnerId.AsInteger;
    qryGoodsListSale.ParamByName('CONTRACTID').AsInteger := qryPartnerCONTRACTID.AsInteger;
    qryGoodsListSale.ParamByName('PRICELISTID').AsInteger := qryPartnerPRICELISTID.AsInteger;
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
  end;
end;

procedure TDM.LoadOrderExtrenalItems(AId : integer);
var
  qryGoodsListOrder : TFDQuery;
  PriceField, PromoPriceField : string;
begin
  cdsOrderItems.Open;
  cdsOrderItems.EmptyDataSet;

  qryGoodsListOrder := TFDQuery.Create(nil);
  try
    qryGoodsListOrder.Connection := conMain;

    if qryPartnerisOperDateOrder.AsBoolean then
      PriceField := 'OrderPrice'
    else
      PriceField := 'SalePrice';

    if qryPartnerPriceWithVAT.AsBoolean then
      PromoPriceField := 'PriceWithVAT'
    else
      PromoPriceField := 'PriceWithOutVAT';

    qryGoodsListOrder.SQL.Text := 'select IEO.ID || '';'' || G.ID || '';'' || GK.ID || '';'' || ' +
      'G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || 0 || '';'' || IFNULL(SRI.AMOUNT, 0) || '';'' || ' +
      'PI.' + PriceField + ' || '';'' || M.VALUEDATA || '';'' || G.WEIGHT || '';'' || ' +
      'IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';'' || IEO.AMOUNT ' +
      'from MOVEMENTITEM_ORDEREXTERNAL IEO ' +
      'JOIN OBJECT_GOODS G ON IEO.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = IEO.GOODSKINDID ' +
      'LEFT JOIN MOVEMENT_STOREREAL SR ON SR.PARTNERID = :PARTNERID' +
      ' AND DATE(SR.OPERDATE) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date())) + ' AND SR.STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString + ' ' +
      'LEFT JOIN MOVEMENTITEM_STOREREAL SRI ON SRI.GOODSID = G.ID AND SRI.GOODSKINDID = GK.ID AND SRI.MOVEMENTID = SR.ID ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
      'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
      'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
      'WHERE IEO.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';


    qryGoodsListOrder.ParamByName('PARTNERID').AsInteger := qryPartnerId.AsInteger;
    qryGoodsListOrder.ParamByName('CONTRACTID').AsInteger := qryPartnerCONTRACTID.AsInteger;
    qryGoodsListOrder.ParamByName('PRICELISTID').AsInteger := qryPartnerPRICELISTID.AsInteger;
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
  end;
end;

procedure TDM.GenerateOrderExtrenalItemsList;
var
  PriceField, PromoPriceField : string;
begin
  if qryPartnerisOperDateOrder.AsBoolean then
    PriceField := 'OrderPrice'
  else
    PriceField := 'SalePrice';

  if qryPartnerPriceWithVAT.AsBoolean then
    PromoPriceField := 'PriceWithVAT'
  else
    PromoPriceField := 'PriceWithOutVAT';

  qryGoodsItems.SQL.Text := 'select G.ID GoodsID, GK.ID GoodsKindID, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, IFNULL(' + PromoPriceField + ', ''-'') PromoPrice, ' +
    'GLK.REMAINS, PI.' + PriceField + ' PRICE, M.VALUEDATA MEASURE, ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || ' +
    'GK.VALUEDATA || '';'' || 0 || '';'' || 0 || '';'' || PI.' + PriceField + ' || '';'' || ' +
    'M.VALUEDATA || '';'' || G.WEIGHT || '';'' || IFNULL(' + PromoPriceField + ', -1) || '';'' || IFNULL(P.ISCHANGEPERCENT, 1) || '';0'' FullInfo, ' +
    'G.VALUEDATA || CASE WHEN ' + PromoPriceField + ' IS NULL THEN '';0'' ELSE '';1'' END SearchName ' +
    'from OBJECT_GOODS G ' +
    'JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID AND GLK.ISERASED = 0 ' +
    'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID AND GK.ISERASED = 0 ' +
    'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
    'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
    'LEFT JOIN MOVEMENTITEM_PROMOGOODS PG ON PG.MOVEMENTID = PP.MOVEMENTID and PG.GOODSID = G.ID and (PG.GOODSKINDID = GK.ID or PG.GOODSKINDID = 0) ' +
    'LEFT JOIN MOVEMENTITEM_PROMOPARTNER PP ON PP.PARTNERID = :PARTNERID  and (PP.CONTRACTID = :CONTRACTID or PP.CONTRACTID = 0) ' +
    'LEFT JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID ' +
    'WHERE G.ISERASED = 0 order by Name';

  qryGoodsItems.ParamByName('PARTNERID').AsInteger := qryPartnerId.AsInteger;
  qryGoodsItems.ParamByName('CONTRACTID').AsInteger := qryPartnerCONTRACTID.AsInteger;
  qryGoodsItems.ParamByName('PRICELISTID').AsInteger := qryPartnerPRICELISTID.AsInteger;
  qryGoodsItems.Open;
end;


function TDM.SaveReturnIn(OldReturnInId : string; OperDate: TDate; Comment : string;
  ToralPrice, TotalWeight: Currency; DelItems : string; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  Result := false;

  if OldReturnInId = '' then
  begin
    NewInvNumber := 1;

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

    if OldReturnInId = '' then
    begin
      tblMovement_ReturnIn.Append;

      CreateGUID(GlobalId);
      tblMovement_ReturnInGUID.AsString := GUIDToString(GlobalId);
      tblMovement_ReturnInInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_ReturnInOperDate.AsDateTime := OperDate;
      tblMovement_ReturnInComment.AsString := Comment;
      tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
      tblMovement_ReturnInPartnerId.AsInteger := qryPartnerId.AsInteger;
      tblMovement_ReturnInPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
      tblMovement_ReturnInContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      tblMovement_ReturnInPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
      tblMovement_ReturnInVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
      tblMovement_ReturnInChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
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
      if tblMovement_ReturnIn.Locate('Id', OldReturnInId) then
      begin
        tblMovement_ReturnIn.Edit;

        tblMovement_ReturnInOperDate.AsDateTime := OperDate;
        tblMovement_ReturnInComment.AsString := Comment;
        tblMovement_ReturnInStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        tblMovement_ReturnInPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
        tblMovement_ReturnInVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
        tblMovement_ReturnInChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
        tblMovement_ReturnInTotalCountKg.AsFloat := TotalWeight;
        tblMovement_ReturnInTotalSummPVAT.AsFloat := ToralPrice;

        tblMovement_ReturnIn.Post;

        MovementId := StrToInt(OldReturnInId);
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
          tblMovementItem_ReturnInChangePercent.AsFloat := DM.qryPartnerChangePercent.AsFloat;

          tblMovementItem_ReturnIn.Post;
        end
        else
        begin
          if tblMovementItem_ReturnIn.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_ReturnIn.Edit;

            tblMovementItem_ReturnInChangePercent.AsFloat := DM.qryPartnerChangePercent.AsFloat;
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

    if OldReturnInId = '' then
      LoadReturnIn(IntToStr(MovementId))
    else
    begin
      cdsReturnIn.Edit;

      cdsReturnInOperDate.AsDateTime := OperDate;
      cdsReturnInComment.AsString := Comment;
      cdsReturnInName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsReturnInPrice.AsString :=  'Стоимость: ' + FormatFloat('0.00', ToralPrice);
      cdsReturnInWeigth.AsString := 'Вес: ' + FormatFloat('0.00', TotalWeight);
      cdsReturnInStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString;

      cdsReturnIn.Post;
    end;

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

procedure TDM.LoadReturnIn(AId : string = '');
var
  qryReturnIn : TFDQuery;
begin
  if AId = '' then
  begin
    cdsReturnIn.Open;
    cdsReturnIn.EmptyDataSet;
  end;

  qryReturnIn := TFDQuery.Create(nil);
  try
    qryReturnIn.Connection := conMain;
    qryReturnIn.SQL.Text := 'select ID, OPERDATE, TOTALCOUNTKG, TOTALSUMMPVAT, ISSYNC, STATUSID, COMMENT' +
      ' from MOVEMENT_RETURNIN' +
      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
      ' and STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString;
    if AId <> '' then
      qryReturnIn.SQL.Text := qryReturnIn.SQL.Text + ' and ID = ' + AId;
    qryReturnIn.SQL.Text := qryReturnIn.SQL.Text + ' order by OPERDATE desc';

    qryReturnIn.Open;
    cdsReturnIn.Open;

    qryReturnIn.First;
    while not qryReturnIn.EOF do
    begin
      cdsReturnIn.Append;
      cdsReturnInId.AsInteger := qryReturnIn.FieldByName('ID').AsInteger;
      cdsReturnInOperDate.AsDateTime := qryReturnIn.FieldByName('OPERDATE').AsDateTime;
      cdsReturnInComment.AsString := qryReturnIn.FieldByName('COMMENT').AsString;
      cdsReturnInName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', qryReturnIn.FieldByName('OPERDATE').AsDateTime);
      cdsReturnInPrice.AsString :=  'Стоимость: ' + FormatFloat('0.00', qryReturnIn.FieldByName('TOTALSUMMPVAT').AsFloat);
      cdsReturnInWeigth.AsString := 'Вес: ' + FormatFloat('0.00', qryReturnIn.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsReturnInStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString
      else
      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsReturnInStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryReturnIn.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsReturnInStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Erased.AsString
      else
        cdsReturnInStatus.AsString := 'Статус: Неизвестный';

      cdsReturnIn.Post;

      qryReturnIn.Next;
    end;

    qryReturnIn.Close;
  finally
    qryReturnIn.Free;
  end;
end;

procedure TDM.AddedGoodsToReturnIn(AGoods : string);
var
  ArrValue : TArray<string>;
  Recommend : Extended;
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

procedure TDM.DefaultReturnInItems;
var
  qryGoodsListSale : TFDQuery;
begin
  cdsReturnInItems.Open;
  cdsReturnInItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;

    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || ' +
      'GK.VALUEDATA || '';'' || PI.OrderPrice || '';'' || M.VALUEDATA || '';'' || G.WEIGHT || '';0''' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID AND GK.ISERASED = 0 ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
      'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'WHERE GLS.PARTNERID = :PARTNERID and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.ParamByName('PARTNERID').AsInteger := qryPartnerId.AsInteger;
    qryGoodsListSale.ParamByName('PRICELISTID').AsInteger := qryPartnerPRICELISTID.AsInteger;
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
  end;
end;

procedure TDM.LoadReturnInItems(AId : integer);
var
  qryGoodsListReturn : TFDQuery;
begin
  cdsReturnInItems.Open;
  cdsReturnInItems.EmptyDataSet;

  qryGoodsListReturn := TFDQuery.Create(nil);
  try
    qryGoodsListReturn.Connection := conMain;

    qryGoodsListReturn.SQL.Text := 'select IR.ID || '';'' || G.ID || '';'' || GK.ID || '';'' || ' +
      'G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || PI.OrderPrice || '';'' || M.VALUEDATA || '';'' || ' +
      'G.WEIGHT || '';'' || IR.AMOUNT ' +
      'from MOVEMENTITEM_RETURNIN IR ' +
      'JOIN OBJECT_GOODS G ON IR.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = IR.GOODSKINDID ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
      'WHERE IR.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';

    qryGoodsListReturn.ParamByName('PRICELISTID').AsInteger := qryPartnerPRICELISTID.AsInteger;
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
  end;
end;

procedure TDM.GenerateReturnInItemsList;
begin
  qryGoodsItems.SQL.Text := 'select G.ID GoodsID, GK.ID GoodsKindID, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, ''-'' PromoPrice, ' +
    'GLK.REMAINS, PI.OrderPrice PRICE, M.VALUEDATA MEASURE, ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || ' +
    'GK.VALUEDATA || '';'' || PI.OrderPrice || '';'' || ' + 'M.VALUEDATA || '';'' || G.WEIGHT || '';0'' FullInfo, ' +
    'G.VALUEDATA || '';0'' SearchName ' +
    'from OBJECT_GOODS G ' +
    'JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID AND GLK.ISERASED = 0 ' +
    'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID AND GK.ISERASED = 0 ' +
    'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
    'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = :PRICELISTID ' +
    'WHERE G.ISERASED = 0 order by Name';

  qryGoodsItems.ParamByName('PRICELISTID').AsInteger := qryPartnerPRICELISTID.AsInteger;
  qryGoodsItems.Open;
end;


procedure TDM.SavePhotoGroup(AGroupName: string);
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
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
    tblMovement_VisitOperDate.AsDateTime := Now();
    tblMovement_VisitPartnerId.AsInteger := qryPartnerId.AsInteger;
    if Trim(AGroupName) <> '' then
      tblMovement_VisitComment.AsString := AGroupName
    else
      tblMovement_VisitComment.AsString := 'Общая';
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

procedure TDM.LoadPhotoGroups;
begin
  qryPhotoGroups.Open('select Id, Comment, StatusId from Movement_Visit where PartnerId = ' + qryPartnerId.AsString +
    ' and StatusId <> ' + tblObject_ConstStatusId_Erased.AsString);
end;


function TDM.GenerateJuridicalCollation(DateStart, DateEnd: TDate; JuridicalId, ContractId: integer): boolean;
var
  x : integer;
  FieldName : string;
  GetStoredProc : TdsdStoredProc;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  try
    GetStoredProc.StoredProcName := 'gpReport_JuridicalCollation';
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);

    GetStoredProc.Params.AddParam('inStartDate', ftDateTime, ptInput, DateStart);
    GetStoredProc.Params.AddParam('inEndDate', ftDateTime, ptInput, DateEnd);
    GetStoredProc.Params.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
    GetStoredProc.Params.AddParam('inPartnerId', ftInteger, ptInput, 0);
    GetStoredProc.Params.AddParam('inContractId', ftInteger, ptInput, ContractId);
    GetStoredProc.Params.AddParam('inAccountId', ftInteger, ptInput, 0);
    GetStoredProc.Params.AddParam('inPaidKindId', ftInteger, ptInput, 0);
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
          cdsJuridicalCollation.Append;

          cdsJuridicalCollationDocNum.AsString := FieldByName('InvNumber').AsString;
          cdsJuridicalCollationDocType.AsString := FieldByName('ItemName').AsString;
          cdsJuridicalCollationDocDate.AsDateTime := FieldByName('OperDate').AsDateTime;
          cdsJuridicalCollationPaidKind.AsString := FieldByName('PaidKindName').AsString;
          cdsJuridicalCollationDebet.AsString := FieldByName('Debet').AsString;
          cdsJuridicalCollationKredit.AsFloat := FieldByName('Kredit').AsFloat;

          cdsJuridicalCollation.Post;

          Next;
        end;
      end;
      ShowMessage(IntToStr(GetStoredProc.DataSet.RecordCount));


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

initialization

Structure := TStructure.Create;

finalization

FreeAndNil(Structure);

end.

