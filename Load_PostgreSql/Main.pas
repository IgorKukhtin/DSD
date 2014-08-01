unit Main;

interface

uses
  Windows, Forms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ZAbstractConnection,
  ZConnection, dsdDB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.Samples.Gauges, Vcl.ExtCtrls, System.Classes,
  Vcl.Grids, Vcl.DBGrids, DBTables, dxSkinsCore, dxSkinsDefaultPainters;

type
  TMainForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    GuidePanel: TPanel;
    cbGoodsGroup: TCheckBox;
    cbAllGuide: TCheckBox;
    Gauge: TGauge;
    cbGoods: TCheckBox;
    fromADOConnection: TADOConnection;
    fromQuery: TADOQuery;
    fromSqlQuery: TADOQuery;
    StopButton: TButton;
    CloseButton: TButton;
    cbMeasure: TCheckBox;
    cbGoodsKind: TCheckBox;
    cbPaidKind: TCheckBox;
    cbJuridicalGroup: TCheckBox;
    cbContractKind: TCheckBox;
    cbContractFl: TCheckBox;
    cbJuridicalFl: TCheckBox;
    cbPartnerFl: TCheckBox;
    cbBusiness: TCheckBox;
    cbBranch: TCheckBox;
    cbUnitGroup: TCheckBox;
    cbUnit: TCheckBox;
    cbPriceList: TCheckBox;
    cbPriceListItems: TCheckBox;
    cbGoodsProperty: TCheckBox;
    cbGoodsPropertyValue: TCheckBox;
    cbSetNull_Id_Postgres: TCheckBox;
    cbOnlyOpen: TCheckBox;
    DocumentPanel: TPanel;
    cbAllDocument: TCheckBox;
    cbIncome: TCheckBox;
    OKDocumentButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    toSqlQuery: TZQuery;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    cbInfoMoneyGroup: TCheckBox;
    cbInfoMoneyDestination: TCheckBox;
    cbInfoMoney: TCheckBox;
    cbAccountGroup: TCheckBox;
    cbAccountDirection: TCheckBox;
    cbAccount: TCheckBox;
    cbProfitLoss: TCheckBox;
    cbProfitLossDirection: TCheckBox;
    cbProfitLossGroup: TCheckBox;
    CompleteDocumentPanel: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    cbAllCompleteDocument: TCheckBox;
    cbCompleteIncome: TCheckBox;
    StartDateCompleteEdit: TcxDateEdit;
    EndDateCompleteEdit: TcxDateEdit;
    cbComplete: TCheckBox;
    cbUnComplete: TCheckBox;
    OKCompleteDocumentButton: TButton;
    cbMember_andPersonal: TCheckBox;
    cbTradeMark: TCheckBox;
    cbIncomePacker: TCheckBox;
    cbSendUnit: TCheckBox;
    cbSendPersonal: TCheckBox;
    cbSendUnitBranch: TCheckBox;
    cbSaleFl: TCheckBox;
    cbReturnOut: TCheckBox;
    cbReturnInFl: TCheckBox;
    cbProductionUnion: TCheckBox;
    cbProductionSeparate: TCheckBox;
    cbLoss: TCheckBox;
    cbInventory: TCheckBox;
    cbZakaz: TCheckBox;
    cbOnlyOpenMI: TCheckBox;
    cbCompleteSend: TCheckBox;
    cbCompleteSendOnPrice: TCheckBox;
    cbInsertHistoryCost: TCheckBox;
    cbCompleteProductionUnion: TCheckBox;
    cbCompleteProductionSeparate: TCheckBox;
    cbRouteSorting: TCheckBox;
    toStoredProc: TdsdStoredProc;
    toStoredProc_two: TdsdStoredProc;
    cbLastComplete: TCheckBox;
    fromQuery_two: TADOQuery;
    cbCompleteInventory: TCheckBox;
    cbCompleteSaleFl: TCheckBox;
    toZConnection: TZConnection;
    cbFuel: TCheckBox;
    cbCar: TCheckBox;
    cbRoute: TCheckBox;
    cbCardFuel: TCheckBox;
    cbTicketFuel: TCheckBox;
    cbModelService: TCheckBox;
    cbStaffList: TCheckBox;
    cbMember_andPersonal_SheetWorkTime: TCheckBox;
    fromFlADOConnection: TADOConnection;
    fromFlQuery: TADOQuery;
    fromFlSqlQuery: TADOQuery;
    cbCompleteReturnInFl: TCheckBox;
    cbOnlyInsertDocument: TCheckBox;
    cbData1CLink: TCheckBox;
    cbCompleteReturnOut: TCheckBox;
    cbTaxFl: TCheckBox;
    cbTaxCorrective: TCheckBox;
    cbReturnInInt: TCheckBox;
    cbSaleInt: TCheckBox;
    cbContractInt: TCheckBox;
    cbJuridicalInt: TCheckBox;
    cbPartnerInt: TCheckBox;
    cbCompleteSaleInt: TCheckBox;
    cbCompleteReturnInInt: TCheckBox;
    OKPOEdit: TEdit;
    cbOKPO: TCheckBox;
    cbDeleteFl: TCheckBox;
    cbDeleteInt: TCheckBox;
    cbTaxInt: TCheckBox;
    cbClearDelete: TCheckBox;
    cbOnlyUpdateInt: TCheckBox;
    cbErr: TCheckBox;
    cbTotalTaxCorr: TCheckBox;
    cbCompleteTaxFl: TCheckBox;
    cbCompleteTaxCorrective: TCheckBox;
    cbCompleteTaxInt: TCheckBox;
    cblTaxPF: TCheckBox;
    cbUpdateConrtact: TCheckBox;
    cbBill_List: TCheckBox;
    cbSelectData_afterLoad: TCheckBox;
    cbSelectData_afterLoad_Sale: TCheckBox;
    cbSelectData_afterLoad_Tax: TCheckBox;
    cbSelectData_afterLoad_ReturnIn: TCheckBox;
    UnitIdEdit: TEdit;
    Label5: TLabel;
    cbBeforeSave: TCheckBox;
    Label6: TLabel;
    SessionIdEdit: TEdit;
    cbGoodsProperty_Detail: TCheckBox;
    procedure OKGuideButtonClick(Sender: TObject);
    procedure cbAllGuideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure cbAllDocumentClick(Sender: TObject);
    procedure OKDocumentButtonClick(Sender: TObject);
    procedure cbAllCompleteDocumentClick(Sender: TObject);
    procedure cbCompleteClick(Sender: TObject);
    procedure cbUnCompleteClick(Sender: TObject);
    procedure cbCompleteIncomeClick(Sender: TObject);
    procedure OKCompleteDocumentButtonClick(Sender: TObject);
  private
    fStop:Boolean;
    isGlobalLoad,zc_rvYes,zc_rvNo:Integer;
    procedure EADO_EngineErrorMsg(E:EADOError);
    procedure EDB_EngineErrorMsg(E:EDBEngineError);
    function myExecToStoredProc_ZConnection:Boolean;
    function myExecToStoredProc:Boolean;
    function myExecToStoredProc_two:Boolean;
    function myExecSqlUpdateErased(ObjectId:Integer;Erased,Erased_del:byte):Boolean;

    function myReplaceStr(const S, Srch, Replace: string): string;
    function FormatToVarCharServer_notNULL(_Value:string):string;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;

    function fOpenSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery (mySql:String):Boolean;
    function fExecFlSqFromQuery (mySql:String):Boolean;

    function fGetSession:String;
    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):Boolean;
    function fFind_ContractId_pg(PartnerId,IMCode,IMCode_two:Integer;myContractNumber:String):Integer;
    function fFindIncome_ContractId_pg(JuridicalId,IMCode,InfoMoneyId:Integer;OperDate:TdateTime):Integer;

    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;

    procedure pInsertHistoryCost;
    procedure pSelectData_afterLoad;
    // DocumentsCompelete :
    procedure pCompleteDocument_Income(isLastComplete:Boolean);
    procedure pCompleteDocument_ReturnOut(isLastComplete:Boolean);
    procedure pCompleteDocument_Send(isLastComplete:Boolean);
    procedure pCompleteDocument_SendOnPrice(isLastComplete:Boolean);
    procedure pCompleteDocument_Sale_Int(isLastComplete:Boolean);
    procedure pCompleteDocument_Sale_Fl(isLastComplete:Boolean);
    procedure pCompleteDocument_ReturnIn_Int(isLastComplete:Boolean);
    procedure pCompleteDocument_ReturnIn_Fl(isLastComplete:Boolean);
    procedure pCompleteDocument_ProductionUnion(isLastComplete:Boolean);
    procedure pCompleteDocument_ProductionSeparate(isLastComplete:Boolean);
    procedure pCompleteDocument_Inventory(isLastComplete:Boolean);

    procedure pCompleteDocument_TaxFl(isLastComplete:Boolean);
    procedure pCompleteDocument_TaxCorrective(isLastComplete:Boolean);
    procedure pCompleteDocument_TaxInt(isLastComplete:Boolean);

    // Documents :
    function pLoadDocument_Income:Integer;
    procedure pLoadDocumentItem_Income(SaveCount:Integer);
    function pLoadDocument_IncomePacker:Integer;
    procedure pLoadDocumentItem_IncomePacker(SaveCount:Integer);

    function pLoadDocument_SendUnit:Integer;
    procedure pLoadDocumentItem_SendUnit(SaveCount:Integer);
    function pLoadDocument_SendPersonal:Integer;
    procedure pLoadDocumentItem_SendPersonal(SaveCount:Integer);
    function pLoadDocument_SendUnitBranch:Integer;
    procedure pLoadDocumentItem_SendUnitBranch(SaveCount:Integer);

    function pLoadDocument_Sale:Integer;
    procedure pLoadDocumentItem_Sale(SaveCount:Integer);
    function pLoadDocument_Sale_Fl:Integer;
    procedure pLoadDocumentItem_Sale_Fl_Int(SaveCount1:Integer);

    function pLoadDocument_ReturnOut:Integer;
    procedure pLoadDocumentItem_ReturnOut(SaveCount:Integer);
    function pLoadDocument_ReturnIn:Integer;
    procedure pLoadDocumentItem_ReturnIn(SaveCount:Integer);
    function pLoadDocument_ReturnIn_Fl:Integer;
    procedure pLoadDocumentItem_ReturnIn_Fl(SaveCount:Integer);

    function pLoadDocument_ProductionUnion:Integer;
    function pLoadDocumentItem_ProductionUnionMaster(SaveCount:Integer):Integer;
    procedure pLoadDocumentItem_ProductionUnionChild(SaveCount1,SaveCount2:Integer);
    function pLoadDocument_ProductionSeparate:Integer;
    function pLoadDocumentItem_ProductionSeparateMaster(SaveCount:Integer):Integer;
    procedure pLoadDocumentItem_ProductionSeparateChild(SaveCount1,SaveCount2:Integer);

    function pLoadDocument_Loss:Integer;
    procedure pLoadDocumentItem_Loss(SaveCount:Integer);

    procedure pLoadDocument_Inventory_Erased;
    function pLoadDocument_Inventory:Integer;
    procedure pLoadDocumentItem_Inventory(SaveCount:Integer);

    function pLoadDocument_Zakaz:Integer;
    procedure pLoadDocumentItem_Zakaz(SaveCount:Integer);

    function pLoadDocument_Tax_Int:Integer;
    procedure pLoadDocumentItem_Tax_Int(SaveCount:Integer);
    function pLoadDocument_Tax_Fl:Integer;
    procedure pLoadDocumentItem_Tax_Fl(SaveCount:Integer);
    function pLoadDocument_TaxCorrective_Fl:Integer;
    procedure pLoadDocumentItem_TaxCorrective_Fl(SaveCount:Integer);

    function pLoadDocument_Delete_Int:Integer;
    procedure pLoadDocumentItem_Delete_Int(SaveCount:Integer);
    function pLoadDocument_Delete_Fl:Integer;
    procedure pLoadDocumentItem_Delete_Fl(SaveCount:Integer);

    // Guides :
    procedure pLoadGuide_Measure;
    procedure pLoadGuide_GoodsGroup;
    procedure pLoadGuide_Goods;
    procedure pLoadGuide_Goods_toZConnection;
    procedure pLoadGuide_GoodsKind;
    procedure pLoadGuide_Fuel;
    procedure pLoadGuide_TicketFuel;
    procedure pLoadGuide_PaidKind;
    procedure pLoadGuide_Contract_Int;
    procedure pLoadGuide_Contract_Fl;
    procedure pLoadGuide_ContractKind;
    procedure pLoadGuide_JuridicalGroup;
    procedure pLoadGuide_Juridical_Int (isBill:Boolean);
    procedure pLoadGuide_Juridical_Fl (isBill:Boolean);
    procedure pLoadGuide_Partner_Int (isBill:Boolean);
    procedure pLoadGuide_Partner_Fl (isBill:Boolean);
    procedure pLoadGuide_Partner1CLink_Fl;
    procedure pLoadGuide_Goods1CLink_Fl;
    procedure pLoadGuide_GoodsProperty_Detail;

    procedure pLoadGuide_Branch;
    procedure pLoadGuide_Business;
    procedure pLoadGuide_UnitGroup;
    procedure pLoadGuide_UnitOld;
    procedure pLoadGuide_Unit;
    procedure pLoadGuide_ModelService;
    procedure pLoadGuide_ModelServiceItemMaster;
    procedure pLoadGuide_ModelServiceItemChild;
    procedure pLoadGuide_StaffList;
    procedure pLoadGuide_StaffListCost;
    procedure pLoadGuide_StaffListSumm;
    procedure pLoadGuide_Member_SheetWorkTime;
    procedure pLoadGuide_Personal_SheetWorkTime;
    procedure pLoadGuide_Position_SheetWorkTime;
    procedure pLoadGuide_PositionLevel_SheetWorkTime;
    procedure pLoadGuide_PersonalGroup_SheetWorkTime;
    procedure pLoadGuide_Member_andPersonal;
    procedure pLoadGuide_Member_Update;
    procedure pLoadGuide_Position;
    procedure pLoadGuide_PersonalGroup;
    procedure pLoadGuide_Car;
    procedure pLoadGuide_CarModel;
    procedure pLoadGuide_Route;
    procedure pLoadGuide_Freight;
    procedure pLoadGuide_RateFuel;
    procedure pLoadGuide_CardFuel;

    procedure pLoadGuide_RouteSorting;

    procedure pLoadGuide_PriceList;
    procedure pLoadGuide_PriceListItems;
    procedure pLoadGuide_GoodsProperty;
    procedure pLoadGuide_GoodsPropertyValue;

    procedure pLoadGuide_InfoMoneyGroup;
    procedure pLoadGuide_InfoMoneyDestination;
    procedure pLoadGuide_InfoMoney;
    procedure pLoadGuide_AccountGroup;
    procedure pLoadGuide_AccountDirection;
    procedure pLoadGuide_Account;
    procedure pLoadGuide_ProfitLossGroup;
    procedure pLoadGuide_ProfitLossDirection;
    procedure pLoadGuide_ProfitLoss;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fFindIncome_ContractId_pg(JuridicalId,IMCode,InfoMoneyId:Integer;OperDate:TdateTime):Integer;
begin
             Result:=0;
             //1.1. находим договор: статья + по дате + не "закрыт" + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and '+FormatToVarCharServer_notNULL(DateToStr(OperDate))+' between StartDate and EndDate'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             //1.2. если не нашли, находим договор: статья + без условия даты + не "закрыт" + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 //+'   and '+FormatToVarCharServer_notNULL(OperDate)+' between StartDate and EndDate'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             //1.3. если не нашли, находим договор: статья + без условия даты + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 //+'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 //+'   and '+FormatToVarCharServer_notNULL(OperDate)+' between StartDate and EndDate'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;

             //2.1. если не нашли, находим договор с "похожими" на "Мясное сырье" статьями и без условия даты + не "закрыт" + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)
              and ((IMCode = 10101)
                or (IMCode = 10102)
                or (IMCode = 10103)
                or (IMCode = 10104)
                or (IMCode = 10105))
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             //2.2. если не нашли, находим договор с "похожими" на "Мясное сырье" статьями и без условия даты + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)
              and ((IMCode = 10101)
                or (IMCode = 10102)
                or (IMCode = 10103)
                or (IMCode = 10104)
                or (IMCode = 10105))
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 //+'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;

             //3.1. если не нашли, находим договор с "похожими" на "Прочее сырье" статьями и без условия даты + не "закрыт" + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)
              and ((IMCode = 10201)
                or (IMCode = 10202)
                or (IMCode = 10203)
                or (IMCode = 10204))
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             //3.2. если не нашли, находим договор с "похожими" на "Прочее сырье" статьями и без условия даты + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)
              and ((IMCode = 10201)
                or (IMCode = 10202)
                or (IMCode = 10203)
                or (IMCode = 10204))
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 //+'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;

             //4. если не нашли, находим хоть один договор !!!у поставщика и если это не услуги!!! + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400(), zc_Enum_InfoMoneyDestination_21500(), zc_Enum_InfoMoneyDestination_21600(), zc_Enum_InfoMoneyDestination_30400(), zc_Enum_InfoMoneyDestination_30500())'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationCode < 40000'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 //+'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fFind_ContractId_pg(PartnerId,IMCode,IMCode_two:Integer;myContractNumber:String):Integer;
begin
             // В 1.1.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + УП статье + не закрыт!!!
             Result:=0;
             if myContractNumber<>'' then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.InvNumber = '+FormatToVarCharServer_notNULL(myContractNumber)
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             // В 1.2.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + УП статье + закрыт!!!
             if (Result=0)and(myContractNumber<>'') then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId = zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.InvNumber = '+FormatToVarCharServer_notNULL(myContractNumber)
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             // В 1.3.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + без УП статьи + не закрыт!!!
             if (Result=0)and(myContractNumber<>'') then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_21500()' // Маркетинг
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.InvNumber = '+FormatToVarCharServer_notNULL(myContractNumber)
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             // В 1.4.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + без УП статьи + закрыт!!!
             if (Result=0)and(myContractNumber<>'') then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_21500()' // // Маркетинг
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId = zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.InvNumber = '+FormatToVarCharServer_notNULL(myContractNumber)
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             // Во 2-ой раз Пытаемся найти <Договор> !!!по УП статье + не закрыт!!!
             if Result=0 then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;
             // В 3-ий раз Пытаемся найти <Договор> !!!с "похожими" статьями!!!
             {if (Result=0)
              and ((IMCode = 10201)
                or (IMCode = 10202)
                or (IMCode = 10203)
                or (IMCode = 10204))
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;}
             // В 4-ый раз Пытаемся найти <Договор> !!!c "альтернативной" УП статьей + не закрыт!!!
             if (Result=0)and(IMCode_two<>0) then
             begin

                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode_two)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
             end;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно остановить загрузку?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('Действительно остановить загрузку и выйти?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGetSession:String;
begin Result:='1005'; end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery(mySql:String):Boolean;
begin
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecFlSqFromQuery(mySql:String):Boolean;
begin
     with fromFlSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecFlSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqToQuery (mySql:String):Boolean;
begin
     with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery (mySql:String):Boolean;
begin
     with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToVarCharServer_notNULL(_Value:string):string;
begin if trim(_Value)='' then Result:=chr(39)+''+chr(39) else Result:=chr(39)+trim(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myReplaceStr(const S, Srch, Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToDateServer_notNULL(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc_ZConnection:Boolean;
begin
    result:=false;
    ShowMessage ('ERROR - toStoredProc_ZConnection on myExecToStoredProc_ZConnection')
    {toStoredProc_ZConnection.Prepared:=true;
     try toStoredProc_ZConnection.ExecProc;
     except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;

     end;
     result:=true;}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc:Boolean;
begin
    result:=false;
     // toStoredProc_two.Prepared:=true;
     //try
     toStoredProc.Execute;
     //except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           //on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;
           //exit;
     //end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc_two:Boolean;
begin
    result:=false;
     // toStoredProc_two.Prepared:=true;
     // try
     toStoredProc_two.Execute;
     //except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           //on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;
           //exit;
     //end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecSqlUpdateErased(ObjectId:Integer;Erased,Erased_del:byte):Boolean;
begin
     if Erased=Erased_del
     then fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update Object set isErased = true where Id = '+IntToStr(ObjectId))+')')
     else fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update Object set isErased = false where Id = '+IntToStr(ObjectId))+')');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.EADO_EngineErrorMsg(E:EADOError);
begin
  MessageDlg(E.Message,mtError,[mbOK],0);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.EDB_EngineErrorMsg(E:EDBEngineError);
var
  DBError: TDBError;
begin
  DBError:=E.Errors[1];
  MessageDlg(DBError.Message,mtError,[mbOK],0);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myEnabledCB (cb:TCheckBox);
begin
     cb.Font.Style:=[fsBold];
     cb.Font.Color:=clBlue;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myDisabledCB (cb:TCheckBox);
begin
     cb.Font.Style:=[];
     cb.Font.Color:=clWindowText;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllGuideClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=10
          then TCheckBox(Components[i]).Checked:=cbAllGuide.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllCompleteDocumentClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=30
          then TCheckBox(Components[i]).Checked:=cbAllCompleteDocument.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllDocumentClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=20
          then TCheckBox(Components[i]).Checked:=cbAllDocument.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbCompleteClick(Sender: TObject);
begin
      //cbUnComplete.Checked:=not cbComplete.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbUnCompleteClick(Sender: TObject);
begin
      //cbComplete.Checked:=not cbUnComplete.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbCompleteIncomeClick(Sender: TObject);
begin
     if (not cbComplete.Checked)and(not cbUnComplete.Checked)then cbComplete.Checked:=true;
end;
procedure TMainForm.FormCreate(Sender: TObject);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     zc_rvYes:=0;
     zc_rvNo:=1;
     //
     if ParamCount = 1 then
     with toZConnection do begin
        Connected:=false;
        HostName:='integer-srv.alan.dp.ua';
        User:='admin';
        Password:='vas6ok';
        //
        isGlobalLoad:=zc_rvYes;
     end
     else
     with toZConnection do begin
        Connected:=false;
        HostName:='localhost';
        User:='postgres';
        Password:='postgres';
        //
        if ParamCount = 2 then isGlobalLoad:=zc_rvYes else isGlobalLoad:=zc_rvNo;
     end;
     //
     //cbAllGuide.Checked:=true;
     //
     fStop:=true;
     //
     Present:= Now;
     DecodeDate(Present, Year, Month, Day);
     StartDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year)));
     StartDateCompleteEdit.Text:=StartDateEdit.Text;

     if Month=12 then begin Month:=1;Year:=Year+1;end else Month:=Month+1;
     EndDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year))-1);
     EndDateCompleteEdit.Text:=EndDateEdit.Text;
     //
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKGuideButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if MessageDlg('Действительно загрузить выбранные справочники?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;

     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set СПРАВОЧНИКИ+ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                                 pSetNullGuide_Id_Postgres;
                                                 pSetNullDocument_Id_Postgres;
                                           end;
     //
     tmpDate1:=NOw;

     //!!!FLOAT!!!
     DataSource.DataSet:=fromFlQuery;
     if not fStop then pLoadGuide_Juridical_Fl(false);
     if not fStop then pLoadGuide_Partner_Fl(false);
     if not fStop then pLoadGuide_Contract_Fl;
     if not fStop then pLoadGuide_Partner1CLink_Fl;
     if not fStop then pLoadGuide_Goods1CLink_Fl;

     if not fStop then DataSource.DataSet:=fromQuery;
     //!!!end FLOAT!!!
     //
     //!!!Integer!!!
     if not fStop then pLoadGuide_Measure;
     if not fStop then pLoadGuide_Fuel;
     if not fStop then pLoadGuide_TicketFuel;
     if not fStop then pLoadGuide_GoodsGroup;
     if not fStop then pLoadGuide_Goods;
     //if not fStop then pLoadGuide_Goods_toZConnection;
     if not fStop then pLoadGuide_GoodsKind;
     if not fStop then pLoadGuide_PaidKind;
     if not fStop then pLoadGuide_ContractKind;
     //if not fStop then pLoadGuide_JuridicalGroup;
     if not fStop then pLoadGuide_Juridical_Int(false);
     if not fStop then pLoadGuide_Partner_Int(false);
     if not fStop then pLoadGuide_Contract_Int;

     if not fStop then pLoadGuide_Business;
     if not fStop then pLoadGuide_Branch;
     //if not fStop then pLoadGuide_UnitGroup;
     if not fStop then pLoadGuide_Unit;
     if not fStop then pLoadGuide_RouteSorting;

     if not fStop then pLoadGuide_ModelService;
     if not fStop then pLoadGuide_ModelServiceItemMaster;
     if not fStop then pLoadGuide_ModelServiceItemChild;
     if not fStop then pLoadGuide_Position_SheetWorkTime;
     if not fStop then pLoadGuide_PositionLevel_SheetWorkTime;
     if not fStop then pLoadGuide_PersonalGroup_SheetWorkTime;
     if not fStop then pLoadGuide_Member_SheetWorkTime;
     if not fStop then pLoadGuide_Personal_SheetWorkTime;
     if not fStop then pLoadGuide_StaffList;
     if not fStop then pLoadGuide_StaffListCost;
     if not fStop then pLoadGuide_StaffListSumm;

     if not fStop then pLoadGuide_PersonalGroup;
     if not fStop then pLoadGuide_Position;
     if not fStop then pLoadGuide_Member_andPersonal;
     if not fStop then pLoadGuide_Member_Update;

     if not fStop then pLoadGuide_Route;
     if not fStop then pLoadGuide_Freight;

     if not fStop then pLoadGuide_CarModel;
     if not fStop then pLoadGuide_Car;
     if not fStop then pLoadGuide_RateFuel;
     if not fStop then pLoadGuide_CardFuel;

     if not fStop then pLoadGuide_PriceList;
     if not fStop then pLoadGuide_PriceListItems;
     if not fStop then pLoadGuide_GoodsProperty;
     if not fStop then pLoadGuide_GoodsPropertyValue;

     if not fStop then pLoadGuide_InfoMoneyGroup;
     if not fStop then pLoadGuide_InfoMoneyDestination;
     if not fStop then pLoadGuide_InfoMoney;
     if not fStop then pLoadGuide_AccountGroup;
     if not fStop then pLoadGuide_AccountDirection;
     if not fStop then pLoadGuide_Account;
     if not fStop then pLoadGuide_ProfitLossGroup;
     if not fStop then pLoadGuide_ProfitLossDirection;
     if not fStop then pLoadGuide_ProfitLoss;

     if not fStop then pLoadGuide_GoodsProperty_Detail;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromADOConnection.Connected:=false;
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;

     if fStop then ShowMessage('Справочники НЕ загружены. Time=('+StrTime+').') else ShowMessage('Справочники загружены. Time=('+StrTime+').');
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    myRecordCount1,myRecordCount2:Integer;
begin
     if MessageDlg('Действительно загрузить выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     {if not cbBeforeSave.Checked
     then begin
               if MessageDlg('Сохранение отключено.Продолжить?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end
     else fExecSqToQuery (' select * from _lpSaveData_beforeLoad('+StartDateEdit.Text+','+EndDateEdit.Text+')');}


     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                                 pSetNullDocument_Id_Postgres;
                                           end;
     //
     tmpDate1:=NOw;

     //!!!FLOAT!!!
     DataSource.DataSet:=fromFlQuery;

     if not fStop then myRecordCount1:=pLoadDocument_Delete_Fl;
     if not fStop then pLoadDocumentItem_Delete_Fl(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Sale_Fl;
     if not fStop then pLoadDocumentItem_Sale_Fl_Int(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_ReturnIn_Fl;
     if not fStop then pLoadDocumentItem_ReturnIn_Fl(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Tax_Fl;
     if not fStop then pLoadDocumentItem_Tax_Fl(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_TaxCorrective_Fl;
     if not fStop then pLoadDocumentItem_TaxCorrective_Fl(myRecordCount1);

     if not fStop then DataSource.DataSet:=fromQuery;
     //!!!end FLOAT!!!

     //!!!Integer!!!
     //
     //Fl if not fStop then pLoadGuide_Juridical(true);
     //Fl if not fStop then pLoadGuide_Partner(true);
     //

     if not fStop then myRecordCount1:=pLoadDocument_Delete_Int;
     if not fStop then pLoadDocumentItem_Delete_Int(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Income;
     if not fStop then pLoadDocumentItem_Income(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_IncomePacker;
     if not fStop then pLoadDocumentItem_IncomePacker(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnOut;
     if not fStop then pLoadDocumentItem_ReturnOut(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Sale;
     if not fStop then pLoadDocumentItem_Sale(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnIn;
     if not fStop then pLoadDocumentItem_ReturnIn(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Tax_Int;
     if not fStop then pLoadDocumentItem_Tax_Int(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_SendUnit;
     if not fStop then pLoadDocumentItem_SendUnit(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_SendPersonal;
     if not fStop then pLoadDocumentItem_SendPersonal(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_SendUnitBranch;
     if not fStop then pLoadDocumentItem_SendUnitBranch(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_ProductionUnion;
     if not fStop then myRecordCount2:=pLoadDocumentItem_ProductionUnionMaster(myRecordCount1);
     if not fStop then pLoadDocumentItem_ProductionUnionChild(myRecordCount1,myRecordCount2);
     if not fStop then myRecordCount1:=pLoadDocument_ProductionSeparate;
     if not fStop then myRecordCount2:=pLoadDocumentItem_ProductionSeparateMaster(myRecordCount1);
     if not fStop then pLoadDocumentItem_ProductionSeparateChild(myRecordCount1,myRecordCount2);

     if not fStop then myRecordCount1:=pLoadDocument_Loss;
     if not fStop then pLoadDocumentItem_Loss(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Inventory;
     // if not fStop then pLoadDocumentItem_Inventory(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Zakaz;
     if not fStop then pLoadDocumentItem_Zakaz(myRecordCount1);
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromADOConnection.Connected:=false;
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;

     if fStop then ShowMessage('Документы НЕ загружены. Time=('+StrTime+').') else ShowMessage('Документы загружены. Time=('+StrTime+').');
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSelectData_afterLoad;
var UnitId_str,DescId_str,SessionId_str:String;
begin
     try StrToInt(SessionIdEdit.Text);SessionId_str:=SessionIdEdit.Text; except SessionId_str:='0';end;
     if SessionId_str='0'
     then SessionId_str:='OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
     else SessionId_str:='SessionId='+SessionId_str;

     //
     DescId_str:='';
     if cbSelectData_afterLoad_Sale.Checked then DescId_str:='zc_Movement_Sale()';
     if cbSelectData_afterLoad_Tax.Checked then if DescId_str<>'' then DescId_str:=DescId_str+',zc_Movement_Tax()' else DescId_str:='zc_Movement_Tax()';
     if cbSelectData_afterLoad_ReturnIn.Checked then if DescId_str<>'' then DescId_str:=DescId_str+',zc_Movement_ReturnIn()' else DescId_str:='zc_Movement_ReturnIn()';
     DescId_str:='('+DescId_str+')';
     //
     try StrToInt(UnitIdEdit.Text);UnitId_str:=UnitIdEdit.Text; except UnitId_str:='0';end;
     //
     fOpenSqToQuery (
     ' SELECT Count(*) as calcCount, min(MovementItemId)AS minId,max(MovementItemId) AS  maxId'
    +'     , (SELECT MAX (SessionId) FROM _testMI_afterLoad WHERE '+SessionId_str+') AS SessionId_max'
    +'     , (SELECT MIN (SessionId) FROM _testMI_afterLoad WHERE '+SessionId_str+') AS SessionId_min'
    +' FROM'
    +'(SELECT tmpAll.MovementId'
    +'      , tmpAll.InvNumber'
    +'      , tmpAll.MovementItemId'
    +'      , tmpAll.GoodsId'
    +'      , tmpAll.Price'
    +' FROM (SELECT MovementId'
    +'            , InvNumber'
//    +'            , DATE_TRUNC ('DAY', OperDate) AS OperDate'
    +'            , OperDate'
    +'            , MovementItemId'
    +'            , GoodsId'
    +'            , AmountPartner'
    +'            , 0 AS AmountPartnerNew'
    +'            , Amount'
    +'            , 0 AS AmountNew'
    +'            , Price'
    +'       FROM (SELECT MAX (SessionId) AS Id FROM _testMI_afterLoad WHERE '+SessionId_str+') as tmpSession'
    +'            INNER JOIN _testMI_afterLoad ON _testMI_afterLoad.SessionId = tmpSession.Id'
    +'        WHERE _testMI_afterLoad.OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +'         AND _testMI_afterLoad.DescId IN '+DescId_str
    +'         AND _testMI_afterLoad.StatusId = zc_Enum_Status_Complete()'
    +'         AND _testMI_afterLoad.isErased = FALSE'
    +'         AND (_testMI_afterLoad.FromId = '+UnitId_str+' or 0='+UnitId_str+')' // 8459-Склад Реализации
    +'      UNION ALL'
    +'       SELECT Movement.Id AS MovementId'
    +'            , Movement.InvNumber'
//    +'            , DATE_TRUNC ('DAY', Movement.OperDate) AS OperDate'
    +'            , Movement.OperDate'
    +'            , MovementItem.Id AS MovementItemId'
    +'            , MovementItem.ObjectId AS GoodsId'
    +'            , 0 AS AmountPartner'
    +'            , COALESCE (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0) AS AmountPartnerNew'
    +'            , 0 AS Amount'
    +'            , MovementItem.Amount as AmountNew'
    +'            , COALESCE (MIFloat_Price.ValueData, 0) AS Price'
    +'       FROM Movement'
    +'            LEFT JOIN MovementLinkObject AS MovementLinkObject_From'
    +'                                         ON MovementLinkObject_From.MovementId = Movement.Id'
    +'                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()'
    +'            LEFT JOIN MovementLinkObject AS MovementLinkObject_To'
    +'                                         ON MovementLinkObject_To.MovementId = Movement.Id'
    +'                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()'
    +'            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract'
    +'                                         ON MovementLinkObject_Contract.MovementId = Movement.Id'
    +'                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()'
    +'            LEFT JOIN MovementDate AS MovementDate_OperDatePartner'
    +'                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id'
    +'                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()'
    +'            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id'
    +'                                   AND MovementItem.isErased = FALSE'
    +'            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner'
    +'                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id'
    +'                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()'
    +'            LEFT JOIN MovementItemFloat AS MIFloat_Price'
    +'                                        ON MIFloat_Price.MovementItemId = MovementItem.Id'
    +'                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()'
    +'       WHERE Movement.DescId IN '+DescId_str
    +'         AND Movement.StatusId = zc_Enum_Status_Complete()'
    +'         AND Movement.OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +'         AND (MovementLinkObject_From.ObjectId = '+UnitId_str+' or 0='+UnitId_str+')' // 8459-Склад Реализации
    +'      ) AS tmpAll'
    +' GROUP BY tmpAll.MovementId'
    +'        , tmpAll.InvNumber'
    +'        , tmpAll.MovementItemId'
    +'        , tmpAll.GoodsId'
    +'        , tmpAll.Price'
    +' HAVING SUM (tmpAll.AmountPartner) <> SUM (tmpAll.AmountPartnerNew)'
    +') AS tmp'
    );

    if toSqlQuery.FieldByName('calcCount').AsInteger=0
    then ShowMessage('Ошибок нет.Сессия № <'+toSqlQuery.FieldByName('SessionId_max').AsString+'> min('+toSqlQuery.FieldByName('SessionId_min').AsString+')')
    else ShowMessage('Ошибки есть.Сессия № <'+toSqlQuery.FieldByName('SessionId_max').AsString+'> Кол-во=<'+toSqlQuery.FieldByName('calcCount').AsString+'> min=<'+toSqlQuery.FieldByName('minId').AsString+'> max=<'+toSqlQuery.FieldByName('maxId').AsString+'')

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKCompleteDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if (cbSelectData_afterLoad.Checked)
     then begin
               pSelectData_afterLoad;
               exit;
     end;
     //
     //
     if (cbInsertHistoryCost.Checked)
     then if MessageDlg('Действительно расчитать <СЕБЕСТОИМОСТЬ по МЕСЯЦАМ> за период с <'+DateToStr(StrToDate(StartDateCompleteEdit.Text))+'> по <'+DateToStr(StrToDate(EndDateCompleteEdit.Text))+'> ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
     else
         if (cbComplete.Checked)and(cbUnComplete.Checked)
         then if MessageDlg('Действительно Распровести/Провести выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
         else
             if cbUnComplete.Checked
             then if MessageDlg('Действительно только Распровести выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
             else
                 if cbComplete.Checked then if MessageDlg('Действительно только Провести выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
                 else if cbBeforeSave.Checked
                      then if MessageDlg('Действительно только Сохраненить данные?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
                      else begin ShowMessage('Ошибка.Не выбрано Распровести или Провести или Сохранение.'); end;

     //!!!
     if (not cbBeforeSave.Checked)and(cbUnComplete.Checked)and(not cbInsertHistoryCost.Checked)
     then begin
               if MessageDlg('Сохранение отключено.Продолжить?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end;
     //!!!Сохранили все данные!!!
     if cbBeforeSave.Checked
     then begin
               fExecSqToQuery ('select * from _lpSaveData_beforeLoad('+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))+')');
               if (not cbComplete.Checked)and(not cbUnComplete.Checked)
               then begin ShowMessage('Сохранение данных за период с <'+StartDateCompleteEdit.Text+'> по <'+EndDateCompleteEdit.Text+'> завершено.');
                          exit;
               end;
     end;

     //
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     tmpDate1:=NOw;
     //
     //!!!FLOAT!!!
     DataSource.DataSet:=fromFlQuery;

     if not fStop then pCompleteDocument_Sale_Fl(True);
     if not fStop then pCompleteDocument_ReturnIn_Fl(True);

     if not fStop then pCompleteDocument_TaxFl(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_TaxCorrective(cbLastComplete.Checked);

     if not fStop then DataSource.DataSet:=fromQuery;
     //!!!end FLOAT!!!

     //!!!Integer!!!
     if (cbInsertHistoryCost.Checked)and(cbInsertHistoryCost.Enabled) then
     begin
          if not fStop then pCompleteDocument_Income(FALSE);
          if not fStop then pCompleteDocument_ReturnOut(FALSE);
          if not fStop then pCompleteDocument_Send(FALSE);
          if not fStop then pCompleteDocument_SendOnPrice(FALSE);
          if not fStop then pCompleteDocument_Sale_Int(True);
          if not fStop then pCompleteDocument_ReturnIn_Int(True);
          if not fStop then pCompleteDocument_ProductionUnion(FALSE);
          if not fStop then pCompleteDocument_ProductionSeparate(FALSE);
          if not fStop then pCompleteDocument_Inventory(FALSE);
     end;

     if not fStop then pInsertHistoryCost;
     //
     if(not fStop)and(not ((cbInsertHistoryCost.Checked)and(cbInsertHistoryCost.Enabled)))then pCompleteDocument_Income(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ReturnOut(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Send(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_SendOnPrice(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Sale_Int(True);
     if not fStop then pCompleteDocument_ReturnIn_Int(True);
     if not fStop then pCompleteDocument_ProductionUnion(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ProductionSeparate(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Inventory(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_TaxInt(cbLastComplete.Checked);
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromADOConnection.Connected:=false;
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;

     if (fStop)and(cbInsertHistoryCost.Checked) then ShowMessage('СЕБЕСТОИМОСТЬ по МЕСЯЦАМ расчитана НЕ полностью. Time=('+StrTime+').')
     else if fStop then ShowMessage('Документы НЕ Распроведены и(или) НЕ Проведены. Time=('+StrTime+').')
     else if cbInsertHistoryCost.Checked then ShowMessage('СЕБЕСТОИМОСТЬ по МЕСЯЦАМ расчитана полностью. Time=('+StrTime+').')
          else ShowMessage('Документы Распроведены и(или) Проведены. Time=('+StrTime+').');
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
     fExecSqFromQuery('update dba.Goods set Id_Postgres = null,Id_Postgres_Fuel = null,Id_Postgres_TicketFuel = null');
     fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres = null');
     fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
     fExecSqFromQuery('update dba.KindPackage set Id_Postgres = null');
     fExecSqFromQuery('update dba.MoneyKind set Id_Postgres = null');
     fExecSqFromQuery('update dba.ContractKind set Id_Postgres = null');
     //  !!! Unit.PersonalId_Postgres and Unit.pgUnitId - is by User !!!
     fExecSqFromQuery('update dba.Unit set Id_Postgres_RouteSorting=null,Id_Postgres_Business = null, Id_Postgres_Business_TWO = null, Id_Postgres_Business_Chapli = null, Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
     fExecSqFromQuery('update dba._pgPersonal set Id_Postgres = null');
     fExecSqFromQuery('update dba.PriceList_byHistory set Id_Postgres = null');
     fExecSqFromQuery('update dba.PriceListItems_byHistory set Id_Postgres = null');
     fExecSqFromQuery('update dba.GoodsProperty_Postgres set Id_Postgres = null');
     fExecSqFromQuery('update dba.GoodsProperty_Detail set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null, Id4_Postgres = null, Id5_Postgres = null, Id6_Postgres = null, Id7_Postgres = null'
                                                       +', Id8_Postgres = null, Id9_Postgres = null, Id10_Postgres = null, Id11_Postgres = null, Id12_Postgres = null, Id13_Postgres = null, Id14_Postgres = null');
     fExecSqFromQuery('update dba._pgInfoMoney set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
     fExecSqFromQuery('update dba._pgAccount set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
     fExecSqFromQuery('update dba._pgProfitLoss set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
     fExecSqFromQuery('update dba._pgUnit set Id_Postgres = null, Id_Postgres_Branch = null');

     fExecSqFromQuery('update dba._pgRoute set RouteId_pg = null, FreightId_pg = null');
     fExecSqFromQuery('update dba._pgMember set GroupId_pg = null, MemberId_pg = null, PersonalId_pg = null, PositionId_pg = null');
     fExecSqFromQuery('update dba._pgCar set ModelId_pg = null, CarId_pg = null, MovementId_pg=null');
     fExecSqFromQuery('update dba._pgCardFuel set CardFuelId_pg = null');

     fExecSqFromQuery('update dba._pgMemberSWT set GroupId_pg = null,MemberId_pg = null,PersonalId_pg = null,PositionId_pg = null,PositionLevelId_pg = null');
     fExecSqFromQuery('update dba._pgModelService set ModelServiceId_pg = null,ModelServiceItemMasterId_pg = null,ModelServiceItemChildId_pg = null');
     fExecSqFromQuery('update dba._pgStaffList set PositionId_pg = null,PositionLevelId_pg = null,StaffListSumm_MonthId_pg = null,StaffListSumm_DayId_pg = null,'+'StaffListSumm_PersonalId_pg = null, StaffListSumm_HoursPlanId_pg = null, StaffListSumm_HoursDayId_pg = null, StaffListSumm_HoursPlanConstId_pg = null, StaffListSumm_HoursDayConstId_pg = null, StaffListSumm_HoursOnDayId_pg = null, StaffListId_pg = null');
     fExecSqFromQuery('update dba._pgStaffListCost set ModelServiceId_pg = null,StaffListId_pg = null,StaffListCostId_pg = null');

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullDocument_Id_Postgres;
begin
     fExecSqFromQuery('update dba.Bill set Id_Postgres = null where Id_Postgres is not null'); //
     fExecSqFromQuery('update dba.BillItems set Id_Postgres = null where Id_Postgres is not null');
     fExecSqFromQuery('update dba.BillItemsReceipt set Id_Postgres = null where Id_Postgres is not null');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Measure;
begin
     if (not cbMeasure.Checked)or(not cbMeasure.Enabled) then exit;
     //
     myEnabledCB(cbMeasure);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Measure.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Measure.MeasureName as ObjectName');
        Add('     , case when Measure.Id = zc_measure_Sht() then zc_rvYes() else zc_rvNo() end as zc_Measure_Sh');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Measure.Erased as Erased');
        Add('     , Measure.Id_Postgres');
        Add('from dba.Measure');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_measure';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             // toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Measure set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             if FieldByName('zc_Measure_Sh').AsInteger=FieldByName('zc_rvYes').AsInteger
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Measure_Sh() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbMeasure);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsGroup;
begin
     if (not cbGoodsGroup.Checked)or(not cbGoodsGroup.Enabled) then exit;
     //
     myEnabledCB(cbGoodsGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Goods.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Goods.GoodsName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Goods.Erased as Erased');
        Add('     , Goods.Id_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Goods');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('where Goods.HasChildren <> zc_hsLeaf()');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodsgroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Goods;
begin
//update Object set ObjectCode = null where DescId = zc_Object_Goods()
//select * from Object where DescId = zc_Object_Goods()
     if (not cbGoods.Checked)or(not cbGoods.Enabled) then exit;
     //
     fExecSqFromQuery(' update dba.GoodsProperty'
                     +'        left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId'
                     +'        left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode'
                     +' = case when GoodsProperty.Id in (5510) then 30201' // !!!РУЛЬКА ВАРЕНАЯ в пакете для запекания!!! - 30201	Доходы	Мясное сырье
                     +'        when Goods.Id in (1063) then 30101' // !!!колбаса в ассортименте!!! - 30101	Доходы	Продукция	Готовая продукция
                     +'        when Goods.Id in (3409) then 20201' // !!!Этикет- пистолет!!! - 20201	Общефирменные Прочие ТМЦ Инструменты/Инвентарь

                     +'        when fCheckGoodsParentID(7574,Goods.ParentId) =zc_rvYes() then 20401' // ГСМ  - 20401	Общефирменные ГСМ ГСМ

                     +'        when fCheckGoodsParentID(9323,Goods.ParentId) =zc_rvYes() then 20701' // ТОВАРЫ ПАВИЛЬОНЫ  - 20701	Общефирменные Товары Прочие товары

                     +'        when fCheckGoodsParentID(8778,Goods.ParentId) =zc_rvYes() then 20302' // компьютеры  - 20302	Общефирменные Прочие основные ср-ва Комп. и оргтехника
                     +'        when fCheckGoodsParentID(7580,Goods.ParentId) =zc_rvYes() then 20101' // Запчасти автомобили  - 20101	Общефирменные Запчасти и Ремонты Запчасти и Ремонты
                     +'        when fCheckGoodsParentID(7581,Goods.ParentId) =zc_rvYes() then 20101' // РЕЗИНА  - 20101	Общефирменные Запчасти и Ремонты Запчасти и Ремонты
                     +'        when fCheckGoodsParentID(8709,Goods.ParentId) =zc_rvYes() then 20102' // СТРОЙКА  - 20102	Запчасти и Ремонты Общефирменные Строительные

                     +'        when fCheckGoodsParentID(8414,Goods.ParentId) =zc_rvYes() then 20205' // ДРОВА, ГАЗ  - Общефирменные Прочие ТМЦ Прочие ТМЦ
                     +'        when fCheckGoodsParentID(7429,Goods.ParentId) =zc_rvYes() then 20301' // МЕБЕЛЬ  - Общефирменные Прочие основные ср-ва Мебель

                     +'        when fCheckGoodsParentID(1491,Goods.ParentId) =zc_rvYes() then 20701' // АГРОСЕЛЬПРОМ  - 20701	Общефирменные Товары	Прочие товары
                     +'        when fCheckGoodsParentID(338, Goods.ParentId) =zc_rvYes() then 20901' // ц.ИРНА      - 20901	Общефирменные	Ирна Ирна
                     +'        when fCheckGoodsParentID(5,   Goods.ParentId) =zc_rvYes() then 30101' // ГП            - 30101	Доходы	Продукция	Готовая продукция
                     +'        when fCheckGoodsParentID(5306,Goods.ParentId) =zc_rvYes() then 30101' // ПЕРЕПАК       - 30101	Доходы	Продукция	Готовая продукция
                     +'        when fCheckGoodsParentID(3482,Goods.ParentId) =zc_rvYes() then 30101' // эксперименты       - 30101	Доходы	Продукция	Готовая продукция
                     +'        when fCheckGoodsParentID(5874,Goods.ParentId) =zc_rvYes() then 30102' // ТУШЕНКА       - 30102	Доходы	Продукция	Тушенка
                     +'        when fCheckGoodsParentID(2387,Goods.ParentId) =zc_rvYes() then 30103' // ХЛЕБ          - 30103	Доходы  Продукция	Хлеб
                     +'        when fCheckGoodsParentID(2849,Goods.ParentId) =zc_rvYes() then 30301' // С-ПЕРЕРАБОТКА - 30301	Доходы  Переработка	Переработка
                     +'        when fCheckGoodsParentID(1855,Goods.ParentId) =zc_rvYes() then 30101' // ПРОИЗВОДСТВО + УДАЛЕННЫЕ - 30101	Доходы	Продукция	Готовая продукция

                     +'        when fCheckGoodsParentID(6682,Goods.ParentId) =zc_rvYes() then 20204' // КАНЦТОВАРЫ - 20204	Общефирменные  Прочие ТМЦ Канц товары
                     +'        when fCheckGoodsParentID(6677,Goods.ParentId) =zc_rvYes() then 20601' // КУЛЬКИ - 20601	Общефирменные  Прочие материалы	Прочие материалы
                     +'        when fCheckGoodsParentID(2954,Goods.ParentId) =zc_rvYes() then 20203' // МОЮЩЕЕ - 20203	Общефирменные  Прочие ТМЦ Моющие средства, кислоты
                     +'        when fCheckGoodsParentID(6678,Goods.ParentId) =zc_rvYes() then 20601' // ПЛЕНКА И СКОТЧ - 20601	Общефирменные  Прочие материалы	Прочие материалы
                     +'        when fCheckGoodsParentID(2949,Goods.ParentId) =zc_rvYes() then 20205' // РАЗНОЕ - 20205	Общефирменные  Прочие ТМЦ Прочие ТМЦ
                     +'        when fCheckGoodsParentID(2641,Goods.ParentId) =zc_rvYes() then 20202' // СПЕЦОДЕЖДА - 20202	Общефирменные  Прочие ТМЦ Спецодежда
                     +'        when fCheckGoodsParentID(6681,Goods.ParentId) =zc_rvYes() then 20601' // ЦЕННИКИ, ЯРЛЫКИ, ЭТ. ДАТА - 20601	Общефирменные  Прочие материалы	Прочие материалы
                     +'        when fCheckGoodsParentID(6676,Goods.ParentId) =zc_rvYes() then 20601' // ЩЕПА - 20601	Общефирменные  Прочие материалы	Прочие материалы
                     +'        when fCheckGoodsParentID(7238,Goods.ParentId) =zc_rvYes() then 20601' // С-ПРОЧЕЕ - 20601	Общефирменные  Прочие материалы	Прочие материалы
                     +'        when fCheckGoodsParentID(2787,Goods.ParentId) =zc_rvYes() then 10201' // СД-КУХНЯ - 10201		Основное сырье Прочее сырье	Специи

                     +'        when fCheckGoodsParentID(2642,Goods.ParentId) =zc_rvYes() then 20101' // СД-ЗАПЧАСТИ оборуд-е - 20101	Общефирменные  Запчасти и Ремонты	Запчасти и Ремонты

                     +'        when fCheckGoodsParentID(2647,Goods.ParentId) =zc_rvYes() then 10201' // СД-ПЕКАРНЯ - 10201		Основное сырье Прочее сырье	Специи
                     +'        when Goods.Id in (6041, 7013) then 10201' // СД-ТУШЕНКА - 10201		Основное сырье Прочее сырье	Специи
                     +'        when Goods.ParentId in (5857) then 10203' // СД-ТУШЕНКА - 10203		Основное сырье Прочее сырье	Упаковка

                     +'        when fCheckGoodsParentID(4213,Goods.ParentId) =zc_rvYes() then 20601' // ГОФРОТАРА - 20601	Общефирменные  Прочие материалы	Прочие материалы

                     +'        when fCheckGoodsParentID(3521,Goods.ParentId) =zc_rvYes() then 10201' // для проработок-новые специи - 10201		Основное сырье Прочее сырье	Специи
                     +'        when fCheckGoodsParentID(3221,Goods.ParentId) =zc_rvYes() then 10201' // ДОБАВКИ - 10201		Основное сырье Прочее сырье	Специи
                     +'        when fCheckGoodsParentID(2643,Goods.ParentId) =zc_rvYes() then 10201' // СПЕЦИИ - 10201		Основное сырье Прочее сырье	Специи
                     +'        when fCheckGoodsParentID(2644,Goods.ParentId) =zc_rvYes() then 10201' // СПЕЦИИ ДЕЛИКАТ. - 10201		Основное сырье Прочее сырье	Специи
                     +'        when fCheckGoodsParentID(7,Goods.ParentId) =zc_rvYes() then 10201' // СЫРЬЕ СПЕЦИИ - 10201		Основное сырье Прочее сырье	Специи
                     +'        when fCheckGoodsParentID(90,Goods.ParentId) =zc_rvYes() then 10201' // СЫРЬЕ СОЯ - 10201		Основное сырье Прочее сырье	Специи
                     +'        when Goods.Id = 26 then 10201' // ФИБРОУЗ-80 - 10201		Основное сырье Прочее сырье	Специи

                     +'        when fCheckGoodsParentID(2645,Goods.ParentId) =zc_rvYes() then 10202' // ОБОЛОЧКА - 10202		Основное сырье Прочее сырье	Оболочка
                     +'        when fCheckGoodsParentID(11,Goods.ParentId) =zc_rvYes() then 10202' // СЫРЬЕ ОБОЛОЧКА - 10202		Основное сырье Прочее сырье	Оболочка
                     +'        when Goods.Id = 164 then 10202' // НИТКИ - 10202		Основное сырье Прочее сырье	Оболочка

                     +'        when fCheckGoodsParentID(2631,Goods.ParentId) =zc_rvYes() then 10203' // !!!СД-СЫРЬЕ!!! - 10203		Основное сырье Прочее сырье	Упаковка
                     +'        when fCheckGoodsParentID(176,Goods.ParentId) =zc_rvYes() then 10203' // СЫРЬЕ ЭТИКЕТКИ И ТЕРМОЧЕКИ - 10203		Основное сырье Прочее сырье	Упаковка

                     +'        when Goods.Id in (3924,8214,6504) then 10101' // !!!Живой вес!!!

                     +'        when fCheckGoodsParentID(2648,Goods.ParentId) =zc_rvYes() then 10204' // СО-СЫРЬЕ СЫР - 10204		Основное сырье Прочее сырье Прочее сырье
                     +'        when Goods.Id in (2792, 7001, 6710) then 10103' // !!!СО- ГОВ. И СВ. Н\К + СЫР!!! - 10103		Основное сырье Мясное сырье Говядина
                     +'        when fCheckGoodsParentID(6435,Goods.ParentId) =zc_rvYes() then 10102' // !!!СО- ГОВ. И СВ. Н\К + СЫР!!! - 10102		Основное сырье Мясное сырье Свинина
                     +'        when fCheckGoodsParentID(3859,Goods.ParentId) =zc_rvYes() then 10105' // СО-БАРАНИНА - 10105		Основное сырье Мясное сырье Прочее мясное сырье
                     +'        when fCheckGoodsParentID(5676,Goods.ParentId) =zc_rvYes() then 10105' // СО-КАБАН и др. - 10105		Основное сырье Мясное сырье Прочее мясное сырье
                     +'        when fCheckGoodsParentID(5503,Goods.ParentId) =zc_rvYes() then 10105' // СО-ПТИЦА РАЗНАЯ - 10105		Основное сырье Мясное сырье Прочее мясное сырье
                     +'        when fCheckGoodsParentID(7207,Goods.ParentId) =zc_rvYes() then 10105' // СО-КРОЛИК - 10105		Основное сырье Мясное сырье Прочее мясное сырье

                     +'        when fCheckGoodsParentID(5489,Goods.ParentId) =zc_rvYes() then 10103' // СО-ГОВ.  ДЕЛ-СЫ* - 10103		Основное сырье Мясное сырье Говядина
                     +'        when fCheckGoodsParentID(5491,Goods.ParentId) =zc_rvYes() then 10103' // СО-ГОВ. ВЫС+ОДН.* - 10103		Основное сырье Мясное сырье Говядина
                     +'        when fCheckGoodsParentID(2633,Goods.ParentId) =zc_rvYes() then 10103' // СО-ГОВЯДИНА ПФ* - 10103		Основное сырье Мясное сырье Говядина
                     +'        when fCheckGoodsParentID(2662,Goods.ParentId) =zc_rvYes() then 10103' // СО-СЫРЬЕ УБОЙ ГОВ.* - 10103		Основное сырье Мясное сырье Говядина

                     +'        when fCheckGoodsParentID(2635,Goods.ParentId) =zc_rvYes() then 10104' // СО-КУРИЦА* - 10104		Основное сырье Мясное сырье Курица
                     +'        when fCheckGoodsParentID(905,Goods.ParentId) =zc_rvYes() then 10104' // КУРИН. - 10104		Основное сырье Мясное сырье Курица

                     +'        when fCheckGoodsParentID(2632,Goods.ParentId) =zc_rvYes() then 10102' // !!!СО!!! - 10102		Основное сырье Мясное сырье Свинина
                     +'        when fCheckGoodsParentID(2691,Goods.ParentId) =zc_rvYes() then 10103' // СО-ГОВЯДИНА ПРОДАЖА маг - 10103		Основное сырье Мясное сырье Говядина
                     +'        when Goods.Id in (2800) then 10104' // КУРЫ-ГРИЛЬ* - 10104		Основное сырье Мясное сырье Курица
                     +'        when Goods.Id in (3039) then 10103' // ДОНЕР - КЕБАБ - 10103		Основное сырье Мясное сырье Говядина
                     +'        when Goods.Id in (17) then 10103' // Гост СЫРЬЕ - К-3 - 10103		Основное сырье Мясное сырье Говядина
                     +'        when Goods.Id in (538) then 10102' // УДАЛЕННЫЕ П/К - 10102		Основное сырье Мясное сырье Свинина
                     +'        when fCheckGoodsParentID(3447,Goods.ParentId) =zc_rvYes() then 10102' // !!!СО-НА ПРОДАЖУ!!! - 10102		Основное сырье Мясное сырье Свинина

                     +'        when fCheckGoodsParentID(3217,Goods.ParentId) =zc_rvYes() then 21301' // СО-ЭМУЛЬСИИ - 10102		Общефирменные Незавершенное производство Незавершенное производство

                     +'        when Goods.Id in (257,802,1275,2373) then 21301' // ЭМУЛЬСИЯ СЕРДЦА - 10102		Общефирменные Незавершенное производство Незавершенное производство
                                                                      // ЭМУЛЬСИЯ МАСЛА
                                                                      // ЭМУЛЬСИЯ ЖИРОВАЯ
                                                                      // ЛЕД

                     +'        when fCheckGoodsParentID(1670,Goods.ParentId) =zc_rvYes() then 20701' // СЫР - 20701		Общефирменные Товары Прочие товары
                     +'        when fCheckGoodsParentID(686,Goods.ParentId) =zc_rvYes() then 20501' // Тара - 20501		Общефирменные Оборотная тара	Оборотная тара

                     +'                                                                      end'
                     +' set InfoMoneyCode = _pgInfoMoney.ObjectCode'
                      );
     //
     myEnabledCB(cbGoods);

     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('delete from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB');
        ExecSql;
        Clear;
        Add('insert into dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB (GoodsPropertyId)');
        Add('select BillItems.GoodsPropertyId');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount <> 0');
        Add('     left outer join _toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO AS _tmpList_GoodsProperty_isPartion_myRecalc on _tmpList_GoodsProperty_isPartion_myRecalc.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('where Bill.BillDate between MONTHS (ToDay(), -2) and MONTHS (ToDay(), 1)');
        Add('  and Bill.BillKind not in (zc_bkProductionInZakaz())');
        Add('  and (Bill.FromId in (zc_UnitId_Cex(), zc_UnitId_CexDelikatesy())');
        Add('    or Bill.ToId in (zc_UnitId_Cex(), zc_UnitId_CexDelikatesy()))');
        Add('  and _tmpList_GoodsProperty_isPartion_myRecalc.GoodsPropertyId > 0');
        Add('group by BillItems.GoodsPropertyId;');
        ExecSql;
     end;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty.Id as ObjectId');
        Add('     , isnull(GoodsProperty.GoodsCode,0) as ObjectCode');
        Add('     , GoodsProperty.GoodsName as ObjectName');
        Add('     , max (case when Goods.ParentId=686 then GoodsProperty.Tare_Weight else GoodsProperty_Detail.Ves_onMeasure end) as Ves_onMeasure');
        Add('     , GoodsProperty.Id_Postgres as Id_Postgres');
        Add('     , Measure.Id_Postgres as MeasureId_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('     , _pgInfoMoney.Id3_Postgres as InfoMoneyId_Postgres');
        Add('     , case when isPartionCount.GoodsPropertyId is not null then zc_rvYes() else zc_rvNo() end as isPartionCount');
        Add('     , case when isPartionSumm.GoodsPropertyId is not null then zc_rvYes() else zc_rvNo() end as isPartionSumm');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , GoodsProperty.Erased as Erased');
        Add('     , 0 AS TradeMarkId_PG');
        Add('     , case when Goods.ParentId in (5874)'
           +'                 then Unit_Alan.Id_Postgres_Business_Chapli'
           +'            when fCheckGoodsParentID(3251,Goods.ParentId) =zc_rvYes()'
           +'                 then Unit_Alan.Id_Postgres_Business_TWO'
           +'            when fCheckGoodsParentID(5,Goods.ParentId) =zc_rvYes()'
           +'                 then Unit_Alan.Id_Postgres_Business'
           +'       end as BusinessId_Postgres');
        Add('     , Goods.Id_Postgres_Fuel AS FuelId_PG');
        Add('from dba.GoodsProperty');
        Add('     left outer join dba.Unit as Unit_Alan on Unit_Alan.Id = 3');// АЛАН
        Add('     left outer join dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO AS isPartionCount on isPartionCount.GoodsPropertyId = GoodsProperty.Id');
        Add('     left outer join dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB AS isPartionSumm on isPartionSumm.GoodsPropertyId = GoodsProperty.Id');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('     left outer join dba.Measure on Measure.Id = GoodsProperty.MeasureId');
        Add('     left outer join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId = GoodsProperty.Id');
        Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = GoodsProperty.InfoMoneyCode');
        Add('where Goods.HasChildren = zc_hsLeaf()');
//  Add(' and GoodsProperty.GoodsCode in (7001)');
        Add('group by ObjectId');
        Add('       , ObjectName');
        Add('       , ObjectCode');
        Add('       , Erased');
        Add('       , Id_Postgres');
        Add('       , MeasureId_Postgres');
        Add('       , ParentId_Postgres');
        Add('       , InfoMoneyId_Postgres');
        Add('       , BusinessId_Postgres');
        Add('       , FuelId_PG');
        Add('       , isPartionCount');
        Add('       , isPartionSumm');
        Add('order by ObjectId');
        Open;
        cbGoods.Caption:='1.3. ('+IntToStr(RecordCount)+') Товары';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goods';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inWeight',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inMeasureId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inTradeMarkId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBusinessId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFuelId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_ObjectBoolean_Goods_Partion';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inPartionCount',ftBoolean,ptInput, false);
        toStoredProc_two.Params.AddParam ('inPartionSumm',ftBoolean,ptInput, false);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inWeight').Value:=FieldByName('Ves_onMeasure').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMeasureId').Value:=FieldByName('MeasureId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inTradeMarkId').Value:=FieldByName('TradeMarkId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBusinessId').Value:=FieldByName('BusinessId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inFuelId').Value:=FieldByName('FuelId_PG').AsInteger;

             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;

             if (FieldByName('isPartionCount').AsInteger=FieldByName('zc_rvYes').AsInteger)
              or(FieldByName('isPartionSumm').AsInteger=FieldByName('zc_rvYes').AsInteger)
             then begin
                       toStoredProc_two.Params.ParamByName('inId').Value:=toStoredProc.Params.ParamByName('ioId').Value;

                       if FieldByName('isPartionCount').AsInteger=FieldByName('zc_rvYes').AsInteger
                       then toStoredProc_two.Params.ParamByName('inPartionCount').Value:=true
                       else toStoredProc_two.Params.ParamByName('inPartionCount').Value:=false;

                       if FieldByName('isPartionSumm').AsInteger=FieldByName('zc_rvYes').AsInteger
                       then toStoredProc_two.Params.ParamByName('inPartionSumm').Value:=true
                       else toStoredProc_two.Params.ParamByName('inPartionSumm').Value:=false;
                       if not myExecToStoredProc_two then ;
             end;

             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('delete from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB');
        ExecSql;
     end;
     //
     myDisabledCB(cbGoods);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Goods_toZConnection;
begin
    ShowMessage ('ERROR - pLoadGuide_Goods_toZConnection');
{     if (not cbGoods.Checked)or(not cbGoods.Enabled) then exit;
     //
     myEnabledCB(cbGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty.Id as ObjectId');
        Add('     , GoodsProperty.GoodsCode as ObjectCode');
        Add('     , GoodsProperty.GoodsName as ObjectName');
        Add('     , max (case when Goods.ParentId=686 then GoodsProperty.Tare_Weight else GoodsProperty_Detail.Ves_onMeasure end) as Ves_onMeasure');
        Add('     , GoodsProperty.Id_Postgres as Id_Postgres');
        Add('     , Measure.Id_Postgres as MeasureId_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('     , _pgInfoMoney.Id3_Postgres as InfoMoneyId_Postgres');
        Add('from dba.GoodsProperty');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('     left outer join dba.Measure on Measure.Id = GoodsProperty.MeasureId');
        Add('     left outer join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId = GoodsProperty.Id');
        Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = 1');
        Add('where Goods.HasChildren = zc_hsLeaf() ');
        Add('group by ObjectId');
        Add('       , ObjectName');
        Add('       , ObjectCode');
        Add('       , Id_Postgres');
        Add('       , MeasureId_Postgres');
        Add('       , ParentId_Postgres');
        Add('       , InfoMoneyId_Postgres');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc_ZConnection.StoredProcName:='gpinsertupdate_object_goods';
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc_ZConnection.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc_ZConnection.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc_ZConnection.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc_ZConnection.Params.ParamByName('inGoodsGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc_ZConnection.Params.ParamByName('inMeasureId').Value:=FieldByName('MeasureId_Postgres').AsInteger;
             toStoredProc_ZConnection.Params.ParamByName('inWeight').Value:=FieldByName('MeasureId_Postgres').AsFloat;
             toStoredProc_ZConnection.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_Postgres').AsInteger;
             toStoredProc_ZConnection.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc_ZConnection then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres='+IntToStr(toStoredProc_ZConnection.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoods);}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsKind;
begin
     if (not cbGoodsKind.Checked)or(not cbGoodsKind.Enabled) then exit;
     //
     myEnabledCB(cbGoodsKind);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select KindPackage.Id as ObjectId');
        Add('     , KindPackage.KindPackageCode as ObjectCode');
        Add('     , KindPackage.KindPackageName as ObjectName');
        Add('     , KindPackage.Id_Postgres as Id_Postgres');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , KindPackage.Erased as Erased');
        Add('     , zc_KindPackage_PF() as zc_KindPackage_PF');
        Add('from dba.KindPackage');
        Add('where KindPackage.HasChildren = zc_hsLeaf()');
        Add('  and (KindPackage.ParentId not in (23,30)'
           +'     or KindPackage.Id in (24)'
           +'      )');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodskind';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.KindPackage set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             if FieldByName('ObjectId').AsInteger=FieldByName('zc_KindPackage_PF').AsInteger
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_GoodsKind_WorkProgress() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsKind);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Fuel;
var RateFuelKindId:String;
begin
     if (not cbFuel.Checked)or(not cbFuel.Enabled) then exit;
     //
     myEnabledCB(cbFuel);
     //
     fOpenSqToQuery ('select min (Id ) AS RateFuelKindId from Object where DescId = zc_Object_RateFuelKind()');
     RateFuelKindId:=toSqlQuery.FieldByName('RateFuelKindId').AsString;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Goods.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GoodsProperty.GoodsCode');
        Add('     , case when GoodsProperty.GoodsCode = 7001 then '+FormatToVarCharServer_notNULL('Бензин')
           +'            else Goods.GoodsName'
           +'       end as ObjectName');
        Add('     , case when GoodsProperty.GoodsCode = 7005 then 1.3059 else 1 end as Ratio');
        Add('     , '+RateFuelKindId+' as RateFuelKindId');
        Add('     , GoodsProperty_a95.GoodsId as GoodsId_a95');
        Add('     , GoodsProperty_Propan.GoodsId as GoodsId_Propan');
        Add('     , Goods.Id_Postgres_Fuel as Id_Postgres');
        Add('from dba.Goods');
        Add('     join dba.GoodsProperty on GoodsProperty.GoodsId = Goods.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_a95 on GoodsProperty_a95.GoodsCode = 7002');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_Propan on GoodsProperty_Propan.GoodsCode = 7011');
        Add('where Goods.HasChildren = zc_hsLeaf()');
        Add('  and fCheckGoodsParentID(7574,Goods.ParentId) =zc_rvYes()'); // ГСМ
        Add('  and GoodsProperty.GoodsCode not in (7002, 7011)');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Fuel';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inRatio',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inRateFuelKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inRatio').Value:=FieldByName('Ratio').AsFloat;
             toStoredProc.Params.ParamByName('inRateFuelKindId').Value:=FieldByName('RateFuelKindId').AsInteger;
             //
         if (FieldByName('Id_Postgres').AsInteger=0)or(1=0)
         then begin
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres_Fuel='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             if (FieldByName('GoodsCode').AsInteger=7001)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres_Fuel='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('GoodsId_a95').AsString);
             if (FieldByName('GoodsCode').AsInteger=7005)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres_Fuel='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('GoodsId_Propan').AsString);
         end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbFuel);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_TicketFuel;
begin
     if (not cbTicketFuel.Checked)or(not cbTicketFuel.Enabled) then exit;
     //
     myEnabledCB(cbTicketFuel);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Goods.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Goods.GoodsName as ObjectName');
        Add('     , GoodsProperty.Id_Postgres as inGoodsId');
        Add('     , Goods.Id_Postgres_TicketFuel as Id_Postgres');
        Add('from dba.Goods');
        Add('     join dba.GoodsProperty on GoodsProperty.GoodsId = Goods.Id');
        Add('where Goods.HasChildren = zc_hsLeaf()');
        Add('  and fCheckGoodsParentID(7574,Goods.ParentId) =zc_rvYes()'); // ГСМ
        Add('  and GoodsProperty.GoodsCode in (7011)');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_TicketFuel';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('inGoodsId').AsInteger;
             //
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres_TicketFuel='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbTicketFuel);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_PaidKind;
var zc_Enum_PaidKind_FirstForm,zc_Object_PaidKind_SecondForm:String;
begin
     if (not cbPaidKind.Checked)or(not cbPaidKind.Enabled) then exit;
     //
     myEnabledCB(cbPaidKind);
     //
     fOpenSqToQuery ('select zc_Enum_PaidKind_FirstForm from zc_Enum_PaidKind_FirstForm()');
     zc_Enum_PaidKind_FirstForm:=toSqlQuery.FieldByName('zc_Enum_PaidKind_FirstForm').AsString;
     fOpenSqToQuery ('select zc_Enum_PaidKind_SecondForm from zc_Enum_PaidKind_SecondForm()');
     zc_Object_PaidKind_SecondForm:=toSqlQuery.FieldByName('zc_Enum_PaidKind_SecondForm').AsString;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select MoneyKind.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , MoneyKind.MoneyKindName as ObjectName');
        Add('     , case when ObjectId =zc_mkBN() then '+zc_Enum_PaidKind_FirstForm+' when ObjectId =zc_mkNal() then '+zc_Object_PaidKind_SecondForm+' else MoneyKind.Id_Postgres end as Id_Postgres');
        Add('from dba.MoneyKind');
        Add('where MoneyKind.Id<=2');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_paidkind';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             // !!!всегда update!!!
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.MoneyKind set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPaidKind);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ContractKind;
begin
     if (not cbContractKind.Checked)or(not cbContractKind.Enabled) then exit;
     //
     myEnabledCB(cbContractKind);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ContractKind.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , ContractKind.ContractKindName as ObjectName');
        Add('     , ContractKind.Id_Postgres as Id_Postgres');
        Add('from dba.ContractKind');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_contractkind';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.ContractKind set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbContractKind);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_JuridicalGroup;
begin
     if (not cbJuridicalGroup.Checked)or(not cbJuridicalGroup.Enabled) then exit;
     //
     myEnabledCB(cbJuridicalGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id1_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id1_Postgres as ParentId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('where Unit.HasChildren <> zc_hsLeaf() and (Unit.Id in (151'  // ВСЕ
//                                                                +', 5354' // FLOATER
//                                                                +', 4219' // ЗАВИСШИЕ ДОЛГИ Ф2
//                                                                +', 28'   // Новые по ЗАЯВКАМ
                                                                +', 3504' // ПОКУПАТЕЛИ-ВСЕ
                                                                +', 152'  // Поставщики-ВСЕ
                                                                +', 4418' // Поставщики-кап. вложения
                                                                +' )'
           +'                                        or Unit.ParentId in(3504' // ПОКУПАТЕЛИ-ВСЕ
                                                                     +', 152'  // Поставщики-ВСЕ
                                                                     +' ))');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_juridicalgroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbJuridicalGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Juridical_Int (isBill:Boolean);
var ParentId_PG_in,ParentId_PG_out,ParentId_PG_service:String;
    JuridicalId_pg, JuridicalDetailsId_pg :Integer;
begin
     //fExecSqFromQuery('update dba._pgPartner set CodeIM = 30201 where Id>10000');
     //
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_JuridicalGroup() and ObjectCode=2');//02-Поставщики
     ParentId_PG_in:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_JuridicalGroup() and ObjectCode=3');//03-ПОКУПАТЕЛИ
     ParentId_PG_out:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_JuridicalGroup() and ObjectCode=4');//04-Услуги
     ParentId_PG_service:=toSqlQuery.FieldByName('Id').AsString;

     if (not cbJuridicalInt.Checked)or(not cbJuridicalInt.Enabled) then exit;
     //
     myEnabledCB(cbJuridicalInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
                  Add('select 0 as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , trim(_pgPartner.Name) as ObjectName');
                  Add('     , case when 1=1 then '+ParentId_PG_out); //03-ПОКУПАТЕЛИ
                  Add('            when _pgInfoMoney.Id3_Postgres in (8952) then '+ParentId_PG_service); // 'Общефирменные','Маркетинг','Реклама'
                  Add('            when _pgPartner.NumberSheet in (1,2) or _pgInfoMoney.Id1_Postgres in (8854) then '+ParentId_PG_out); // Доходы
                  Add('            when _pgPartner.NumberSheet=3 and (_pgInfoMoney.Id1_Postgres in (8855, 8856) or _pgInfoMoney.Id2_Postgres in (8875, 8877) ) then '+ParentId_PG_service); //Финансовая деятельность OR Расчеты с бюджетом OR услуги полученные OR Коммунальные услуги
                  Add('            when _pgPartner.NumberSheet=3 then '+ParentId_PG_in); //02-Поставщики
                  Add('       end as ParentId_Postgres');
                  Add('     , null as GoodsPropertyId_PG');
                  Add('     , ClientInformation_gln.GLNMain as inGLNCode');
                  Add('     , _pgInfoMoney.Id3_Postgres AS InfoMoneyId_PG');
                  Add('     , null as inBankId');
                  Add('     , case when trim(isnull(NameAll,ClientInformation.FirmName)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(NameAll,ClientInformation.FirmName)) else trim(ClientInformation.FirmName) end as inFullName');
                  Add('     , case when trim(isnull(ClientInformation.AddressFirm,Adr)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.AddressFirm,Adr)) else trim(Adr) end as inJuridicalAddress');
                  Add('     , case when trim(isnull(ClientInformation.KodNalog,Inn)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.KodNalog,Inn)) else trim(Inn) end as inINN');
                  Add('     , case when trim(isnull(ClientInformation.KodSvid,NSvid)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.KodSvid,NSvid)) else trim(NSvid) end as inNumberVAT');
                  Add('     , case when trim(isnull(ClientInformation.FioBuh,FioB)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.FioBuh,FioB)) else trim(FioB) end as inAccounterName');
                  Add('     , null as inBankAccount');
                  Add('     , _pgPartner_find.Id as pgPartnerId, _pgPartner_find_two.Id as pgPartnerId_two');
                  Add('     , _pgPartner_find.OKPO as inOKPO');
                  Add('     , _pgPartner_find.JuridicalDetailsId_pg as JuridicalDetailsId_Postgres');
                  Add('     , _pgPartner_find.JuridicalId_pg as Id_Postgres');
                  Add('from (select min (_pgPartner.Id) as Id'
                    + '           , max (isnull(_pgPartner.JuridicalId_pg,0)) as JuridicalId_pg'
                    + '           , max (isnull(_pgPartner.JuridicalDetailsId_pg,0)) as JuridicalDetailsId_pg'
                    + '           , trim (_pgPartner.OKPO)as OKPO'
                    + '      from dba._pgPartner'
                    + '      where trim (_pgPartner.OKPO)<>' + FormatToVarCharServer_notNULL('')
                    + '      group by OKPO'
                    + '     ) as _pgPartner_find'
                    + '     left join (select max (_pgPartner.Id) as Id'
                    + '                     , trim (_pgPartner.OKPO)as OKPO'
                    + '                from dba._pgPartner'
                    + '                where trim (_pgPartner.OKPO)<>' + FormatToVarCharServer_notNULL('')
                    + '                  and _pgPartner.NumberSheet = 1'
                    + '                group by OKPO'
                    + '               ) as _pgPartner_find_two on _pgPartner_find_two.OKPO = _pgPartner_find.OKPO'
                    + '     left join dba._pgPartner on _pgPartner.Id = isnull(_pgPartner_find_two.Id, _pgPartner_find.Id)'

                    + '     left join (select max (_pgPartner.UnitId) as ClientId'
                    + '                     , JuridicalId_pg'
                    + '                from dba._pgPartner'
                    + '                      join dba.ClientInformation on ClientInformation.ClientId = _pgPartner.UnitId'
                    + '                                                and trim (GLNMain) <> '+FormatToVarCharServer_notNULL('')
                    + '                where JuridicalId_pg<>0'
                    + '                group by JuridicalId_pg'
                    + '               ) as _pgPartner_gln on _pgPartner_gln.JuridicalId_pg = _pgPartner_find.JuridicalId_pg'
                    + '     left join dba.ClientInformation as ClientInformation_gln on ClientInformation_gln.ClientId = _pgPartner_gln.ClientId');

                  Add('     left join (select trim(ClientInformation.OKPO) as OKPO, max (ClientInformation.ClientId) as ClientId'
                     +'                from dba.ClientInformation'
                     +'                where trim(OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                  and trim(KodNalog) <> ' + FormatToVarCharServer_notNULL('')
                     +'                  and trim(KodSvid) <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as ClientInformation_find on ClientInformation_find.OKPO = _pgPartner_find.OKPO'
                     +'     left join dba.ClientInformation on ClientInformation.ClientId = ClientInformation_find.ClientId');
                  Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = _pgPartner.CodeIM'); //
{                  Add('     left outer join dba.GoodsProperty_Postgres as GoodsProperty_PG on GoodsProperty_PG.Id= case when fIsClient_ATB(Unit.Id)=zc_rvYes() then 1'
                                                                                                                 +'    when fIsClient_OK(Unit.Id)=zc_rvYes() then 2'
                                                                                                                 +'    when fIsClient_Metro(Unit.Id)=zc_rvYes() then 3'
                                                                                                                 +'    when fIsClient_Fozzi(Unit.Id)=zc_rvYes() or fIsClient_FozziM(Unit.Id)=zc_rvYes() then 5'
                                                                                                                 +'    when fIsClient_Kisheni(Unit.Id)=zc_rvYes() then 6'
                                                                                                                 +'    when fIsClient_Vivat(Unit.Id)=zc_rvYes() then 7'
                                                                                                                 +'    when fIsClient_Billa(Unit.Id)=zc_rvYes() then 8'
                                                                                                                 +'    when fIsClient_Amstor(Unit.Id)=zc_rvYes() then 9'
                                                                                                                 +'    when fIsClient_Omega(Unit.Id)=zc_rvYes() then 10'
                                                                                                                 +'    when fIsClient_Vostorg(Unit.Id)=zc_rvYes() then 11'
                                                                                                                 +'    when fIsClient_Ashan(Unit.Id)=zc_rvYes() then 12'
                                                                                                                 +'    when fIsClient_Real(Unit.Id)=zc_rvYes() then 13'
                                                                                                                 +'    when fIsClient_GD(Unit.Id)=zc_rvYes() then 14'
                                                                                                                 +'    else null'
                                                                                                                 +' end'}
                  //Add('where _pgPartner_find.Id>10000');
                  //Add('  and(isnull(_pgPartner_find.JuridicalDetailsId_pg,0) = 0 ');
                  //Add('   or isnull(_pgPartner_find.JuridicalId_pg,0)=0)');
                  Add('order by ObjectName, ObjectId');
        Open;
        cbJuridicalInt.Caption:='2.4. ('+IntToStr(RecordCount)+') Юр.лица Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_juridical';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGLNCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inIsCorporate',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inJuridicalGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsPropertyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRetailId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPriceListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPriceListPromoId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inStartPromo',ftDateTime,ptInput, Date);
        toStoredProc.Params.AddParam ('inEndPromo',ftDateTime,ptInput, Date);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_ObjectHistory_JuridicalDetails';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inOperDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inBankId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inFullName',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inJuridicalAddress',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inOKPO',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inINN',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inNumberVAT',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inAccounterName',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inBankAccount',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inPhone',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Пытаемся найти
             fOpenSqToQuery ('select JuridicalId, ObjectHistoryId from ObjectHistory_JuridicalDetails_View where OKPO='+FormatToVarCharServer_notNULL(FieldByName('inOKPO').AsString));
             JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             JuridicalDetailsId_pg:=toSqlQuery.FieldByName('ObjectHistoryId').AsInteger;

             //
             if (JuridicalId_pg=0)and(FieldByName('pgPartnerId').AsInteger>10000)
             then begin

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGLNCode').Value:=FieldByName('inGLNCode').AsString;
             toStoredProc.Params.ParamByName('inIsCorporate').Value:=false;
             toStoredProc.Params.ParamByName('inJuridicalGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inRetailId').Value:=0;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_PG').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //

                       toStoredProc_two.Params.ParamByName('ioId').Value:=FieldByName('JuridicalDetailsId_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inOperDate').Value:='01.01.2000';
                       toStoredProc_two.Params.ParamByName('inBankId').Value:=FieldByName('inBankId').AsInteger;
                       toStoredProc_two.Params.ParamByName('inFullName').Value:=FieldByName('inFullName').AsString;
                       toStoredProc_two.Params.ParamByName('inJuridicalAddress').Value:=FieldByName('inJuridicalAddress').AsString;
                       toStoredProc_two.Params.ParamByName('inOKPO').Value:=FieldByName('inOKPO').AsString;
                       toStoredProc_two.Params.ParamByName('inINN').Value:=FieldByName('inINN').AsString;
                       toStoredProc_two.Params.ParamByName('inNumberVAT').Value:=FieldByName('inNumberVAT').AsString;
                       toStoredProc_two.Params.ParamByName('inAccounterName').Value:=FieldByName('inAccounterName').AsString;
                       toStoredProc_two.Params.ParamByName('inBankAccount').Value:=FieldByName('inBankAccount').AsString;
                       if not myExecToStoredProc_two then ;

                       JuridicalId_pg:=toStoredProc.Params.ParamByName('ioId').Value;
                       JuridicalDetailsId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
             end // if (JuridicalId_pg=0)and(FieldByName('pgPartnerId').AsInteger>10000)
             else if trim(FieldByName('inGLNCode').AsString) <> ''
                  then
                       fExecSqToQuery ('update ObjectString set ValueData = '+FormatToVarCharServer_notNULL(trim(FieldByName('inGLNCode').AsString))+' where ObjectId = '+IntToStr(JuridicalId_pg)+' and DescId = zc_objectString_Juridical_GLNCode()');
             //
             //if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             if (JuridicalId_pg<>0)
             then fExecSqFromQuery(' update dba._pgPartner set JuridicalId_pg='+IntToStr(JuridicalId_pg)
                                  +'                         , JuridicalDetailsId_pg='+IntToStr(JuridicalDetailsId_pg)
                                  +' where trim(OKPO) = '+FormatToVarCharServer_notNULL(FieldByName('inOKPO').AsString)
                                  +'   and Id>10000');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbJuridicalInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Juridical_Fl (isBill:Boolean);
var ParentId_PG_in,ParentId_PG_out,ParentId_PG_service:String;
    JuridicalId_pg, JuridicalDetailsId_pg :Integer;
begin
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_JuridicalGroup() and ObjectCode=2');//02-Поставщики
     ParentId_PG_in:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_JuridicalGroup() and ObjectCode=3');//03-ПОКУПАТЕЛИ
     ParentId_PG_out:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_JuridicalGroup() and ObjectCode=4');//04-Услуги
     ParentId_PG_service:=toSqlQuery.FieldByName('Id').AsString;

     if (not cbJuridicalFl.Checked)or(not cbJuridicalFl.Enabled) then exit;
     //
     myEnabledCB(cbJuridicalFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
                  Add('select 0 as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , trim(_pgPartner.Name) as ObjectName');
                  Add('     , case when _pgInfoMoney.Id3_Postgres in (8952) then '+ParentId_PG_service); // 'Общефирменные','Маркетинг','Реклама'
                  Add('            when _pgPartner.NumberSheet in (1,2) or _pgInfoMoney.Id1_Postgres in (8854) then '+ParentId_PG_out); // Доходы
                  Add('            when _pgPartner.NumberSheet=3 and (_pgInfoMoney.Id1_Postgres in (8855, 8856) or _pgInfoMoney.Id2_Postgres in (8875, 8877) ) then '+ParentId_PG_service); //Финансовая деятельность OR Расчеты с бюджетом OR услуги полученные OR Коммунальные услуги
                  Add('            when _pgPartner.NumberSheet=3 then '+ParentId_PG_in); //02-Поставщики
                  Add('       end as ParentId_Postgres');
                  Add('     , null as GoodsPropertyId_PG');
                  Add('     , ClientInformation_gln.GLNMain as inGLNCode');
                  Add('     , _pgInfoMoney.Id3_Postgres AS InfoMoneyId_PG');
                  Add('     , null as inBankId');
                  Add('     , case when trim(isnull(NameAll,ClientInformation.FirmName)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(NameAll,ClientInformation.FirmName)) else trim(ClientInformation.FirmName) end as inFullName');
                  Add('     , case when trim(isnull(ClientInformation.AddressFirm,Adr)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.AddressFirm,Adr)) else trim(Adr) end as inJuridicalAddress');
                  Add('     , case when trim(isnull(ClientInformation.KodNalog,Inn)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.KodNalog,Inn)) else trim(Inn) end as inINN');
                  Add('     , case when trim(isnull(ClientInformation.KodSvid,NSvid)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.KodSvid,NSvid)) else trim(NSvid) end as inNumberVAT');
                  Add('     , case when trim(isnull(ClientInformation.FioBuh,FioB)) <> '+FormatToVarCharServer_notNULL('')+' then trim(isnull(ClientInformation.FioBuh,FioB)) else trim(FioB) end as inAccounterName');
                  Add('     , null as inBankAccount');
                  Add('     , _pgPartner_find.Id as pgPartnerId, _pgPartner_find_two.Id as pgPartnerId_two');
                  Add('     , _pgPartner_find.OKPO as inOKPO');
                  Add('     , _pgPartner_find.JuridicalDetailsId_pg as JuridicalDetailsId_Postgres');
                  Add('     , _pgPartner_find.JuridicalId_pg as Id_Postgres');
                  Add('from (select max (_pgPartner.Id) as Id'
                    + '           , max (isnull(_pgPartner.JuridicalId_pg,0)) as JuridicalId_pg'
                    + '           , max (isnull(_pgPartner.JuridicalDetailsId_pg,0)) as JuridicalDetailsId_pg'
                    + '           , trim (_pgPartner.OKPO)as OKPO'
                    + '      from dba._pgPartner'
                    + '      where trim (_pgPartner.OKPO)<>' + FormatToVarCharServer_notNULL('')
                    + '      group by OKPO'
                    + '     ) as _pgPartner_find'
                    + '     left join (select max (_pgPartner.Id) as Id'
                    + '                     , trim (_pgPartner.OKPO)as OKPO'
                    + '                from dba._pgPartner'
                    + '                where trim (_pgPartner.OKPO)<>' + FormatToVarCharServer_notNULL('')
                    + '                  and _pgPartner.NumberSheet = 1'
                    + '                group by OKPO'
                    + '               ) as _pgPartner_find_two on _pgPartner_find_two.OKPO = _pgPartner_find.OKPO'
                    + '     left join dba._pgPartner on _pgPartner.Id = isnull(_pgPartner_find_two.Id, _pgPartner_find.Id)'

                    + '     left join (select max (_pgPartner.UnitId) as ClientId'
                    + '                     , JuridicalId_pg'
                    + '                from dba._pgPartner'
                    + '                      join dba.ClientInformation on ClientInformation.ClientId = _pgPartner.UnitId'
                    + '                                                 and trim (GLNMain) <> '+FormatToVarCharServer_notNULL('')
                    + '                where JuridicalId_pg<>0'
                    + '                group by JuridicalId_pg'
                    + '               ) as _pgPartner_gln on _pgPartner_gln.JuridicalId_pg = _pgPartner_find.JuridicalId_pg'
                    + '     left join dba.ClientInformation as ClientInformation_gln on ClientInformation_gln.ClientId = _pgPartner_gln.ClientId');

                  Add('     left join (select trim(ClientInformation.OKPO) as OKPO, max (ClientInformation.ClientId) as ClientId'
                     +'                from dba.ClientInformation'
                     +'                where trim(OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                  and trim(KodNalog) <> ' + FormatToVarCharServer_notNULL('')
                     +'                  and trim(KodSvid) <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as ClientInformation_find on ClientInformation_find.OKPO = _pgPartner_find.OKPO'
                     +'     left join dba.ClientInformation on ClientInformation.ClientId = ClientInformation_find.ClientId');
                  Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = _pgPartner.CodeIM');
{                  Add('     left outer join dba.GoodsProperty_Postgres as GoodsProperty_PG on GoodsProperty_PG.Id= case when fIsClient_ATB(Unit.Id)=zc_rvYes() then 1'
                                                                                                                 +'    when fIsClient_OK(Unit.Id)=zc_rvYes() then 2'
                                                                                                                 +'    when fIsClient_Metro(Unit.Id)=zc_rvYes() then 3'
                                                                                                                 +'    when fIsClient_Fozzi(Unit.Id)=zc_rvYes() or fIsClient_FozziM(Unit.Id)=zc_rvYes() then 5'
                                                                                                                 +'    when fIsClient_Kisheni(Unit.Id)=zc_rvYes() then 6'
                                                                                                                 +'    when fIsClient_Vivat(Unit.Id)=zc_rvYes() then 7'
                                                                                                                 +'    when fIsClient_Billa(Unit.Id)=zc_rvYes() then 8'
                                                                                                                 +'    when fIsClient_Amstor(Unit.Id)=zc_rvYes() then 9'
                                                                                                                 +'    when fIsClient_Omega(Unit.Id)=zc_rvYes() then 10'
                                                                                                                 +'    when fIsClient_Vostorg(Unit.Id)=zc_rvYes() then 11'
                                                                                                                 +'    when fIsClient_Ashan(Unit.Id)=zc_rvYes() then 12'
                                                                                                                 +'    when fIsClient_Real(Unit.Id)=zc_rvYes() then 13'
                                                                                                                 +'    when fIsClient_GD(Unit.Id)=zc_rvYes() then 14'
                                                                                                                 +'    else null'
                                                                                                                 +' end'}
                  //Add('where isnull(_pgPartner_find.JuridicalId_pg,0)=0');
                  Add('order by ObjectName, ObjectId');
        Open;
        cbJuridicalFl.Caption:='3.2. ('+IntToStr(RecordCount)+') Юр.лица Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_juridical';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGLNCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inIsCorporate',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inJuridicalGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsPropertyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPriceListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPriceListPromoId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inStartPromo',ftDateTime,ptInput, Date);
        toStoredProc.Params.AddParam ('inEndPromo',ftDateTime,ptInput, Date);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_ObjectHistory_JuridicalDetails';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inOperDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inBankId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inFullName',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inJuridicalAddress',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inOKPO',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inINN',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inNumberVAT',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inAccounterName',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inBankAccount',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inPhone',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Пытаемся найти
             fOpenSqToQuery ('select JuridicalId, ObjectHistoryId from ObjectHistory_JuridicalDetails_View where OKPO='+FormatToVarCharServer_notNULL(FieldByName('inOKPO').AsString));
             JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             JuridicalDetailsId_pg:=toSqlQuery.FieldByName('ObjectHistoryId').AsInteger;

             //
             if (JuridicalId_pg=0)and(FieldByName('pgPartnerId').AsInteger<10000)
             then begin

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGLNCode').Value:=FieldByName('inGLNCode').AsString;
             toStoredProc.Params.ParamByName('inIsCorporate').Value:=false;
             toStoredProc.Params.ParamByName('inJuridicalGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_PG').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //

                       toStoredProc_two.Params.ParamByName('ioId').Value:=FieldByName('JuridicalDetailsId_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inOperDate').Value:='01.01.2000';
                       toStoredProc_two.Params.ParamByName('inBankId').Value:=FieldByName('inBankId').AsInteger;
                       toStoredProc_two.Params.ParamByName('inFullName').Value:=FieldByName('inFullName').AsString;
                       toStoredProc_two.Params.ParamByName('inJuridicalAddress').Value:=FieldByName('inJuridicalAddress').AsString;
                       toStoredProc_two.Params.ParamByName('inOKPO').Value:=FieldByName('inOKPO').AsString;
                       toStoredProc_two.Params.ParamByName('inINN').Value:=FieldByName('inINN').AsString;
                       toStoredProc_two.Params.ParamByName('inNumberVAT').Value:=FieldByName('inNumberVAT').AsString;
                       toStoredProc_two.Params.ParamByName('inAccounterName').Value:=FieldByName('inAccounterName').AsString;
                       toStoredProc_two.Params.ParamByName('inBankAccount').Value:=FieldByName('inBankAccount').AsString;
                       if not myExecToStoredProc_two then ;

                       JuridicalId_pg:=toStoredProc.Params.ParamByName('ioId').Value;
                       JuridicalDetailsId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
             end  // if (JuridicalId_pg=0)and(FieldByName('pgPartnerId').AsInteger<10000)
             else if trim(FieldByName('inGLNCode').AsString) <> ''
                  then
                       fExecSqToQuery ('update ObjectString set ValueData = '+FormatToVarCharServer_notNULL(trim(FieldByName('inGLNCode').AsString))+' where ObjectId = '+IntToStr(JuridicalId_pg)+' and DescId = zc_objectString_Juridical_GLNCode()');
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecFlSqFromQuery(' update dba._pgPartner set JuridicalId_pg='+IntToStr(JuridicalId_pg)
                                    +'                         , JuridicalDetailsId_pg='+IntToStr(JuridicalDetailsId_pg)
                                    +' where trim(OKPO) = '+FormatToVarCharServer_notNULL(FieldByName('inOKPO').AsString));

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbJuridicalFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Contract_Int;
begin
     if (not cbContractInt.Checked)or(not cbContractInt.Enabled) then exit;
     //
     myEnabledCB(cbContractInt);
     fExecSqFromQuery('call dba.pRecalc_Unit_isFindBill('+FormatToDateServer_notNULL(StrToDate('01.01.2014'))+')');
     myDisabledCB(cbContractInt);
     exit;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Contract_Fl;
var ContractKindID_15,ContractKindID_16,ContractKindID_17,ContractKindID_18:String;
    PaidKindBN,PaidKindNal:String;
    zc_Enum_ContractConditionKind_DelayDayCalendar,zc_Enum_ContractConditionKind_DelayDayBank,zc_Enum_ContractConditionKind_BonusPercentSaleReturn,zc_Enum_ContractConditionKind_BonusPercentAccount:Integer;
    ContractId_pg:Integer;
begin
     if (not cbContractFl.Checked)or(not cbContractFl.Enabled) then exit;
     //
     myEnabledCB(cbContractFl);
     fExecFlSqFromQuery('call dba.pRecalc_Unit_isFindBill('+FormatToDateServer_notNULL(StrToDate('01.01.2014'))+')');
     myDisabledCB(cbContractFl);
     exit;
     //
     //
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_ContractKind() and ObjectCode in (15,115,215)');//договiр поставки
     ContractKindID_15:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_ContractKind() and ObjectCode in (16,116,216)');//договiр купiвлi-продажу
     ContractKindID_16:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_ContractKind() and ObjectCode in (17,117,217)');//договiр комiсii
     ContractKindID_17:=toSqlQuery.FieldByName('Id').AsString;
     fOpenSqToQuery ('select Id from Object where DescId=zc_Object_ContractKind() and ObjectCode in (18,118,218)');//договiр постачання
     ContractKindID_18:=toSqlQuery.FieldByName('Id').AsString;
     //
     fOpenSqToQuery ('select zc_Enum_PaidKind_FirstForm() as PaidKindId');
     PaidKindBN:=toSqlQuery.FieldByName('PaidKindId').AsString;
     fOpenSqToQuery ('select zc_Enum_PaidKind_SecondForm() as PaidKindId');
     PaidKindNal:=toSqlQuery.FieldByName('PaidKindId').AsString;
     //
     fOpenSqToQuery ('select zc_Enum_ContractConditionKind_DelayDayCalendar() as ContractConditionKindId');
     zc_Enum_ContractConditionKind_DelayDayCalendar:=toSqlQuery.FieldByName('ContractConditionKindId').AsInteger;
     fOpenSqToQuery ('select zc_Enum_ContractConditionKind_DelayDayBank() as ContractConditionKindId');
     zc_Enum_ContractConditionKind_DelayDayBank:=toSqlQuery.FieldByName('ContractConditionKindId').AsInteger;
     fOpenSqToQuery ('select zc_Enum_ContractConditionKind_BonusPercentSaleReturn() as ContractConditionKindId');
     zc_Enum_ContractConditionKind_BonusPercentSaleReturn:=toSqlQuery.FieldByName('ContractConditionKindId').AsInteger;
     fOpenSqToQuery ('select zc_Enum_ContractConditionKind_BonusPercentAccount() as ContractConditionKindId');
     zc_Enum_ContractConditionKind_BonusPercentAccount:=toSqlQuery.FieldByName('ContractConditionKindId').AsInteger;
     //
     myEnabledCB(cbContractFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
                  Add('select 0 as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , trim(isnull(ContractKind_byHistory.ContractNumber,_pgPartner.ContractNumber)) as inInvNumber');
                  Add('     , '+FormatToVarCharServer_notNULL('')+' as inInvNumberArchive');
                  Add('     , '+FormatToVarCharServer_notNULL('')+' as inComment');
                  Add('     , dba.zf_Calc_Str_toDate(_pgPartner.Date0) as Date0');
                  Add('     , dba.zf_Calc_Str_toDate(_pgPartner.Date1) as Date1');
                  Add('     , dba.zf_Calc_Str_toDate(_pgPartner.Date2) as Date2');
                  Add('     , case when isnull(ContractKind_byHistory.ContractDate,zc_DateStart())=zc_DateStart() then Date0 else isnull(ContractKind_byHistory.ContractDate,Date0) end as inSigningDate_calc');
                  Add('     , case when isnull(ContractKind_byHistory.StartDate,zc_DateStart())=zc_DateStart() then Date1 else isnull(ContractKind_byHistory.StartDate,Date1) end as inStartDate_calc');
                  Add('     , case when isnull(ContractKind_byHistory.EndDateContract,zc_DateEnd())=zc_DateEnd() then Date2 else isnull(ContractKind_byHistory.EndDateContract,Date2) end as inEndDate_calc');

                  Add('     , case when inSigningDate_calc=zc_DateStart() then inStartDate else inSigningDate_calc end as inSigningDate');
                  Add('     , case when inStartDate_calc=zc_DateStart() then '+FormatToDateServer_notNULL(StrToDate('01.01.2000'))+' else inStartDate_calc end as inStartDate');
                  Add('     , case when inEndDate_calc=zc_DateStart() or inEndDate_calc=zc_DateEnd() then '+FormatToDateServer_notNULL(StrToDate('31.12.2020'))+' else inEndDate_calc end as inEndDate');

                  Add('     , _pgPartner_find.JuridicalId_pg as inJuridicalId');
                  Add('     , _pgInfoMoney.Id3_Postgres AS inInfoMoneyId');
                  Add('     , case when ContractKind.Id=15 then '+ContractKindID_15); //договiр поставки
                  Add('            when ContractKind.Id=16 then '+ContractKindID_16); //договiр купiвлi-продажу
                  Add('            when ContractKind.Id=17 then '+ContractKindID_17); //договiр комiсii
                  Add('            when ContractKind.Id=18 then '+ContractKindID_18); //договiр постачання
                  Add('            else '+ContractKindID_15); //договiр поставки
                  Add('       end as inContractKindId');
                  Add('     , '+PaidKindBN+' as inPaidKindId');
                  Add('     , null as inPersonalId');
                  Add('     , null as inAreaId');
                  Add('     , null as inContractArticleId');
                  Add('     , null as inContractStateKindId');
                  Add('     , isnull(ClientSumm_find.DayCount_Real,0) as DayCount_Real');
                  Add('     , isnull(ClientSumm_find.DayCount_Bank,0) as DayCount_Bank');
                  //Add('     , isnull(ClientSumm_find.PercentBonus_bySale,0) as PercentBonus_bySale');
                  //Add('     , isnull(ClientSumm_find.PercentBonus_byMoney,0) as PercentBonus_byMoney');
                  Add('     , 0 as PercentBonus_bySale');
                  Add('     , 0 as PercentBonus_byMoney');
                  Add('     , _pgPartner_my.Name');
                  Add('     , _pgPartner_my.NumberSheet');
                  Add('     , _pgPartner_find.JuridicalId_pg');
                  Add('     , _pgPartner_find.CodeIM');
                  Add('     , _pgPartner_find.OKPO');
                  Add('     , _pgPartner_find.ContractId_pg as Id_Postgres');
                  Add('from (select JuridicalId_pg, CodeIM, trim (_pgPartner.OKPO)as OKPO'
                    + '           , max (isnull(_pgPartner.ContractId_pg,0)) as ContractId_pg, max (_pgPartner.Id) as Id'
                    + '      from dba._pgPartner'
                    + '      where JuridicalId_pg<>0'
                    + '        and CodeIM=30101'
                    + '      group by JuridicalId_pg, CodeIM, OKPO'
                    + '     ) as _pgPartner_find'
                    + '     left join (select JuridicalId_pg, CodeIM, trim (_pgPartner.OKPO)as OKPO, max (_pgPartner.Id) as Id'
                     +'                from dba._pgPartner'
                     +'                where JuridicalId_pg<>0'
                    + '                  and CodeIM=30101'
                    + '                  and trim(_pgPartner.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
                    + '                group by JuridicalId_pg, CodeIM, OKPO'
                     +'               ) as _pgPartner_find_two on _pgPartner_find_two.OKPO = _pgPartner_find.OKPO'
                     +'                                       and _pgPartner_find_two.JuridicalId_pg = _pgPartner_find.JuridicalId_pg'
                     +'                                       and _pgPartner_find_two.CodeIM = _pgPartner_find.CodeIM'
                    + '     left join dba._pgPartner on _pgPartner.Id = _pgPartner_find_two.Id'
                    + '     left join dba._pgPartner as _pgPartner_my on _pgPartner_my.Id = _pgPartner_find.Id');
                  Add('     left join (select trim(ClientInformation.OKPO) as OKPO, max (ContractKind_byHistory.Id) as Id'
                     +'                from dba.Unit'
                     +'                     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)'
                     +'                                                                                    and trim(ClientInformation_find.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id'
                     +'                     join dba.ClientInformation on ClientInformation.ClientID = isnull(ClientInformation_find.ClientID,ClientInformation_child.ClientID)'
                     +'                                               and trim(ClientInformation.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ContractKind_byHistory as find1'
                     +'                                  on find1.ClientId = Unit.DolgByUnitID'
                     +'                                 and find1.EndDate=zc_DateEnd()'
                     +'                                 and trim(find1.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ContractKind_byHistory as find2'
                     +'                                  on find2.ClientId = Unit.Id'
                     +'                                 and find2.EndDate=zc_DateEnd()'
                     +'                                 and trim(find2.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ContractKind_byHistory on ContractKind_byHistory.Id = isnull (find1.Id, find2.Id)'
                     +'                where trim(ContractKind_byHistory.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as ContractKind_byHistory_find on ContractKind_byHistory_find.OKPO = _pgPartner_find.OKPO'
                     +'     left join dba.ContractKind_byHistory on ContractKind_byHistory.Id = ContractKind_byHistory_find.Id'
                     +'     left join dba.ContractKind on ContractKind.Id = ContractKind_byHistory.ContractKindId');

                  Add('     left join (select trim(ClientInformation.OKPO) as OKPO'
                     +'                      ,max (ClientSumm.DayCount_Real)as DayCount_Real'
                     +'                      ,max (ClientSumm.DayCount_Bank) as DayCount_Bank'
                     +'                      ,max (ClientSumm.PercentBonus_bySale) as PercentBonus_bySale'
                     +'                      ,max (ClientSumm.PercentBonus_byMoney) as PercentBonus_byMoney'
                     +'                from dba.ClientSumm'
                     +'                     left outer join dba.Unit on Unit.ID = ClientSumm.ClientId'
                     +'                     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)'
                     +'                                                                                    and trim(ClientInformation_find.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id'
                     +'                     join dba.ClientInformation on ClientInformation.ClientID = isnull(ClientInformation_find.ClientID,ClientInformation_child.ClientID)'
                     +'                                               and trim(ClientInformation.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as ClientSumm_find on ClientSumm_find.OKPO = _pgPartner_find.OKPO');

                  Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = _pgPartner_find.CodeIM');
                  //Add('where inInvNumber <> '+FormatToVarCharServer_notNULL(''));
                  Add('where _pgPartner_find.OKPO <> '+FormatToVarCharServer_notNULL('37121835')
                    + '  and _pgPartner_find.OKPO <> '+FormatToVarCharServer_notNULL('37425075'));
                  Add('union all');
                  Add('select 0 as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , trim(_pgPartner.ContractNumber) as inInvNumber');
                  Add('     , '+FormatToVarCharServer_notNULL('')+' as inInvNumberArchive');
                  Add('     , '+FormatToVarCharServer_notNULL('')+' as inComment');
                  Add('     , dba.zf_Calc_Str_toDate(_pgPartner.Date0) as Date0');
                  Add('     , dba.zf_Calc_Str_toDate(_pgPartner.Date1) as Date1');
                  Add('     , dba.zf_Calc_Str_toDate(_pgPartner.Date2) as Date2');
                  Add('     , Date0 as inSigningDate_calc');
                  Add('     , Date1 as inStartDate_calc');
                  Add('     , Date2 as inEndDate_calc');

                  Add('     , case when inSigningDate_calc=zc_DateStart() then inStartDate else inSigningDate_calc end as inSigningDate');
                  Add('     , case when inStartDate_calc=zc_DateStart() then '+FormatToDateServer_notNULL(StrToDate('01.01.2000'))+' else inStartDate_calc end as inStartDate');
                  Add('     , case when inEndDate_calc=zc_DateStart() or inEndDate_calc=zc_DateEnd() then '+FormatToDateServer_notNULL(StrToDate('31.12.2020'))+' else inEndDate_calc end as inEndDate');

                  Add('     , _pgPartner_find.JuridicalId_pg as inJuridicalId');
                  Add('     , _pgInfoMoney.Id3_Postgres AS inInfoMoneyId');
                  Add('     , '+ContractKindID_15+' as inContractKindId'); //договiр поставки
                  Add('     , '+PaidKindBN+' as inPaidKindId');
                  Add('     , null as inPersonalId');
                  Add('     , null as inAreaId');
                  Add('     , null as inContractArticleId');
                  Add('     , null as inContractStateKindId');
                  Add('     , 0 as DayCount_Real');
                  Add('     , 0 as DayCount_Bank');
                  Add('     , isnull(ClientSumm_find.PercentBonus_bySale,0) as PercentBonus_bySale');
                  Add('     , isnull(ClientSumm_find.PercentBonus_byMoney,0) as PercentBonus_byMoney');
                  Add('     , _pgPartner_my.Name');
                  Add('     , _pgPartner_my.NumberSheet');
                  Add('     , _pgPartner_find.JuridicalId_pg');
                  Add('     , _pgPartner_find.CodeIM');
                  Add('     , _pgPartner_find.OKPO');
                  Add('     , _pgPartner_find.ContractId_pg as Id_Postgres');
                  Add('from (select JuridicalId_pg, case when NumberSheet=2 then 21501 else _pgPartner.CodeIM end as CodeIM, trim (_pgPartner.OKPO)as OKPO'
                    + '           , max (isnull(_pgPartner.ContractId_pg,0)) as ContractId_pg, max (_pgPartner.Id) as Id'
                    + '      from dba._pgPartner'
                    + '      where JuridicalId_pg<>0'
                    + '        and (CodeIM in(30201,30103) or NumberSheet in (2,3))'
                    + '      group by JuridicalId_pg, CodeIM, OKPO'
                    + '     ) as _pgPartner_find'
                    + '     left join (select JuridicalId_pg, case when NumberSheet=2 then 21501 else _pgPartner.CodeIM end as CodeIM, trim (_pgPartner.OKPO)as OKPO, max (_pgPartner.Id) as Id'
                     +'                from dba._pgPartner'
                     +'                where JuridicalId_pg<>0'
                    + '                  and (CodeIM in(30201,30103) or NumberSheet in (2,3))'
                    + '                  and trim(_pgPartner.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
                    + '                group by JuridicalId_pg, CodeIM, OKPO'
                     +'               ) as _pgPartner_find_two on _pgPartner_find_two.OKPO = _pgPartner_find.OKPO'
                     +'                                       and _pgPartner_find_two.JuridicalId_pg = _pgPartner_find.JuridicalId_pg'
                     +'                                       and _pgPartner_find_two.CodeIM = _pgPartner_find.CodeIM'
                    + '     left join dba._pgPartner on _pgPartner.Id = _pgPartner_find_two.Id'
                    + '     left join dba._pgPartner as _pgPartner_my on _pgPartner_my.Id = _pgPartner_find.Id');

                  Add('     left join (select trim(ClientInformation.OKPO) as OKPO'
                     +'                      ,max (ClientSumm.DayCount_Real)as DayCount_Real'
                     +'                      ,max (ClientSumm.DayCount_Bank) as DayCount_Bank'
                     +'                      ,max (ClientSumm.PercentBonus_bySale) as PercentBonus_bySale'
                     +'                      ,max (ClientSumm.PercentBonus_byMoney) as PercentBonus_byMoney'
                     +'                from dba.ClientSumm'
                     +'                     left outer join dba.Unit on Unit.ID = ClientSumm.ClientId'
                     +'                     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)'
                     +'                                                                                    and trim(ClientInformation_find.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id'
                     +'                     join dba.ClientInformation on ClientInformation.ClientID = isnull(ClientInformation_find.ClientID,ClientInformation_child.ClientID)'
                     +'                                               and trim(ClientInformation.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as ClientSumm_find on ClientSumm_find.OKPO = _pgPartner_find.OKPO'
                     +'                                   and _pgPartner_my.NumberSheet = 2');

                  Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = _pgPartner_find.CodeIM');
                  //Add('where inInvNumber <> '+FormatToVarCharServer_notNULL(''));
                  Add('where _pgPartner_find.OKPO <> '+FormatToVarCharServer_notNULL('37121835')
                    + '  and _pgPartner_find.OKPO <> '+FormatToVarCharServer_notNULL('37425075'));
                  Add('order by _pgPartner_my.Name, inInvNumber,_pgPartner.Name, ObjectId');
        Open;
        cbContractFl.Caption:='2.3. ('+IntToStr(RecordCount)+') Договора Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Contract';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberArchive',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inBankAccount',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inSigningDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalBasisId',ftInteger,ptInput, 9399);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAreaId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractArticleId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractStateKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBankId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_Object_ContractCondition';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inValue',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inContractConditionKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if FieldByName('Id_Postgres').AsInteger<>0
             then ContractId_pg:=FieldByName('Id_Postgres').AsInteger
             else
                 begin
                  //fOpenSqToQuery ('select ContractId from Object_Contract_View where InvNumber='+FormatToVarCharServer_notNULL(FieldByName('inInvNumber').AsString)+' and JuridicalId='+FieldByName('inJuridicalId').AsString);
                  fOpenSqToQuery ('select ContractId from Object_Contract_View where InfoMoneyId = '+FieldByName('inInfoMoneyId').AsString+' and ContractStateKindId <> zc_Enum_ContractStateKind_Close() and isErased = FALSE and JuridicalId='+FieldByName('inJuridicalId').AsString);
                  ContractId_pg:=toSqlQuery.FieldByName('ContractId').AsInteger;
                 end;

             if (1=0)or(ContractId_pg=0)
             then begin

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberArchive').Value:=FieldByName('inInvNumberArchive').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('inComment').AsString;
             toStoredProc.Params.ParamByName('inSigningDate').Value:=FieldByName('inSigningDate').AsDateTime;
             toStoredProc.Params.ParamByName('inStartDate').Value:=FieldByName('inStartDate').AsDateTime;
             toStoredProc.Params.ParamByName('inEndDate').Value:=FieldByName('inEndDate').AsDateTime;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('inJuridicalId').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('inInfoMoneyId').AsInteger;
             toStoredProc.Params.ParamByName('inContractKindId').Value:=FieldByName('inContractKindId').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('inPaidKindId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalId').Value:=FieldByName('inPersonalId').AsInteger;
             toStoredProc.Params.ParamByName('inAreaId').Value:=FieldByName('inAreaId').AsInteger;
             toStoredProc.Params.ParamByName('inContractArticleId').Value:=FieldByName('inContractArticleId').AsInteger;
             toStoredProc.Params.ParamByName('inContractStateKindId').Value:=FieldByName('inContractStateKindId').AsInteger;

             if not myExecToStoredProc then ;//exit;

             if FieldByName('DayCount_Real').AsFloat<>0
             then begin
                       fOpenSqToQuery('select coalesce((select (ObjectLink.ObjectId) from ObjectLink join ObjectLink as ObjectLink2'
                                    +' on ObjectLink2.ChildObjectId=zc_Enum_ContractConditionKind_DelayDayCalendar()'
                                    +' and ObjectLink2.DescId=zc_ObjectLink_ContractCondition_ContractConditionKind() and ObjectLink2.ObjectId = ObjectLink.ObjectId where ObjectLink.DescId=zc_ObjectLink_ContractCondition_Contract() and ObjectLink.ChildObjectId='+toStoredProc.Params.ParamByName('ioId').AsString+'),0)as Id');
                       toStoredProc_two.Params.ParamByName('ioId').Value:=toSqlQuery.FieldByName('Id').AsString;
                       toStoredProc_two.Params.ParamByName('inValue').Value:=FieldByName('DayCount_Real').AsFloat;
                       toStoredProc_two.Params.ParamByName('inContractId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inContractConditionKindId').Value:=zc_Enum_ContractConditionKind_DelayDayCalendar;
                       if not myExecToStoredProc_two then ;
             end;
             if FieldByName('DayCount_Bank').AsFloat<>0
             then begin
                       fOpenSqToQuery('select coalesce((select (ObjectLink.ObjectId) from ObjectLink join ObjectLink as ObjectLink2'
                                    +' on ObjectLink2.ChildObjectId=zc_Enum_ContractConditionKind_DelayDayBank()'
                                    +' and ObjectLink2.DescId=zc_ObjectLink_ContractCondition_ContractConditionKind() and ObjectLink2.ObjectId = ObjectLink.ObjectId where ObjectLink.DescId=zc_ObjectLink_ContractCondition_Contract() and ObjectLink.ChildObjectId='+toStoredProc.Params.ParamByName('ioId').AsString+'),0)as Id');
                       toStoredProc_two.Params.ParamByName('ioId').Value:=toSqlQuery.FieldByName('Id').AsString;
                       toStoredProc_two.Params.ParamByName('inValue').Value:=FieldByName('DayCount_Bank').AsFloat;
                       toStoredProc_two.Params.ParamByName('inContractId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inContractConditionKindId').Value:=zc_Enum_ContractConditionKind_DelayDayBank;
                       if not myExecToStoredProc_two then ;
             end;
             if FieldByName('PercentBonus_bySale').AsFloat<>0
             then begin
                       fOpenSqToQuery('select coalesce((select (ObjectLink.ObjectId) from ObjectLink join ObjectLink as ObjectLink2'
                                    +' on ObjectLink2.ChildObjectId=zc_Enum_ContractConditionKind_BonusPercentSaleReturn()'
                                    +' and ObjectLink2.DescId=zc_ObjectLink_ContractCondition_ContractConditionKind() and ObjectLink2.ObjectId = ObjectLink.ObjectId where ObjectLink.DescId=zc_ObjectLink_ContractCondition_Contract() and ObjectLink.ChildObjectId='+toStoredProc.Params.ParamByName('ioId').AsString+'),0)as Id');
                       toStoredProc_two.Params.ParamByName('ioId').Value:=toSqlQuery.FieldByName('Id').AsString;
                       toStoredProc_two.Params.ParamByName('inValue').Value:=FieldByName('PercentBonus_bySale').AsFloat;
                       toStoredProc_two.Params.ParamByName('inContractId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inContractConditionKindId').Value:=zc_Enum_ContractConditionKind_BonusPercentSaleReturn;
                       if not myExecToStoredProc_two then ;
             end;
             if FieldByName('PercentBonus_byMoney').AsFloat<>0
             then begin
                       fOpenSqToQuery('select coalesce((select (ObjectLink.ObjectId) from ObjectLink join ObjectLink as ObjectLink2'
                                    +' on ObjectLink2.ChildObjectId=zc_Enum_ContractConditionKind_BonusPercentAccount()'
                                    +' and ObjectLink2.DescId=zc_ObjectLink_ContractCondition_ContractConditionKind() and ObjectLink2.ObjectId = ObjectLink.ObjectId where ObjectLink.DescId=zc_ObjectLink_ContractCondition_Contract() and ObjectLink.ChildObjectId='+toStoredProc.Params.ParamByName('ioId').AsString+'),0)as Id');
                       toStoredProc_two.Params.ParamByName('ioId').Value:=toSqlQuery.FieldByName('Id').AsString;
                       toStoredProc_two.Params.ParamByName('inValue').Value:=FieldByName('PercentBonus_byMoney').AsFloat;
                       toStoredProc_two.Params.ParamByName('inContractId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inContractConditionKindId').Value:=zc_Enum_ContractConditionKind_BonusPercentAccount;
                       if not myExecToStoredProc_two then ;
             end;

             ContractId_pg:=toStoredProc.Params.ParamByName('ioId').Value

             end;
             //

             if (FieldByName('NumberSheet').AsInteger=2)
             then
                 if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
                 then fExecFlSqFromQuery(' update dba._pgPartner set ContractId_pg='+IntToStr(ContractId_pg)
                                        +' where JuridicalId_pg = '+FieldByName('inJuridicalId').AsString
                                        +'   and NumberSheet = 2'
                                        )
                 else
             else
                 if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
                 then fExecFlSqFromQuery(' update dba._pgPartner set ContractId_pg='+IntToStr(ContractId_pg)
                                        +' where JuridicalId_pg = '+FieldByName('inJuridicalId').AsString
                                        +'   and CodeIM = '+FieldByName('CodeIM').AsString
                                        )
                 else
             ;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbContractFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Partner_Fl (isBill:Boolean);
var PartnerId_pg:Integer;
begin
     if (not cbPartnerFl.Checked)or(not cbPartnerFl.Enabled) then exit;
     //
     myEnabledCB(cbPartnerFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
                  Add('select 0 as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , case when trim(_pgPartner.UnitName) <> '+FormatToVarCharServer_notNULL('')+'  then trim(_pgPartner.UnitName)');
                  Add('            else trim(_pgPartner.UnitName)'); // trim(isnull(Unit.UnitName,_pgPartner.UnitName))
                  Add('       end as ObjectName');
                  //Add('     , case when Unit.AddressFirm is not null then Unit.AddressFirm');
                  Add('     , case when trim(_pgPartner.AdrUnit) <> '+FormatToVarCharServer_notNULL('')+'  then trim(_pgPartner.AdrUnit)');
                  Add('            else ObjectName');
                  Add('       end as inAddress');
                  Add('     , '+FormatToVarCharServer_notNULL('')+' as inGLNCode');
                  Add('     , null AS inPrepareDayCount');
                  Add('     , null AS inDocumentDayCount');
                  //Add('     , Unit.Id_byLoad, Unit.Id');
                  Add('     , _pgPartner.OKPO');
                  Add('     , _pgPartner.UnitId');
                  Add('     , _pgPartner_find.Main');
                  Add('     , _pgPartner_find.Id as pgPartnerId, _pgPartner_find_two.Id as pgPartnerId_two');
                  Add('     , _pgPartner_find.JuridicalId_pg as inJuridicalId');
                  Add('     , null AS inRouteId');
                  Add('     , null AS inRouteSortingId');
                  Add('     , null AS inPersonalTakeId');
                  Add('     , _pgPartner_find.PartnerId_pg as Id_Postgres');
                  Add('from (select min (_pgPartner.Id) as Id'
                    + '           , max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg'
                    + '           , JuridicalId_pg'
                    + '           , OKPO'
                    + '           , Main'
                    + '      from dba._pgPartner'
                    + '      where JuridicalId_pg<>0'
                    + '        and trim (UnitId) <> '+FormatToVarCharServer_notNULL('')
                    + '        and trim (UnitId) <> '+FormatToVarCharServer_notNULL('0')
                    + '        and trim (Main) <> '+FormatToVarCharServer_notNULL('')
                    + '        and trim (Main) <> '+FormatToVarCharServer_notNULL('0')
                    + '        and trim (UnitName) <> '+FormatToVarCharServer_notNULL('')
//                    + '        and _pgPartner.Id = 938'
                    + '      group by JuridicalId_pg'
                    + '             , OKPO'
                    + '             , Main'
                    + '     ) as _pgPartner_find'
                    + '     left join (select min (_pgPartner.Id) as Id'
                    + '                     , JuridicalId_pg'
                    + '                     , OKPO'
                    + '                     , Main'
                    + '                from dba._pgPartner'
                    + '                where JuridicalId_pg<>0'
                    + '                  and trim (UnitId) <> '+FormatToVarCharServer_notNULL('')
                    + '                  and trim (UnitId) <> '+FormatToVarCharServer_notNULL('0')
                    + '                  and trim (Main) <> '+FormatToVarCharServer_notNULL('')
                    + '                  and trim (Main) <> '+FormatToVarCharServer_notNULL('0')
                    + '                  and trim (UnitName) <> '+FormatToVarCharServer_notNULL('')
                    + '                  and trim (AdrUnit) <> '+FormatToVarCharServer_notNULL('')
                    + '                group by JuridicalId_pg'
                    + '                       , OKPO'
                    + '                       , Main'
                    + '               ) as _pgPartner_find_two on _pgPartner_find_two.JuridicalId_pg = _pgPartner_find.JuridicalId_pg'
                    + '                                       and _pgPartner_find_two.Main = _pgPartner_find.Main'
                    + '                                       and _pgPartner_find_two.OKPO = _pgPartner_find.OKPO'
                    + '     left join dba._pgPartner on _pgPartner.Id = isnull(_pgPartner_find_two.Id, _pgPartner_find.Id)');

                  Add('     left join (select trim(isnull(ClientInformation_child.OKPO,isnull(ClientInformation_find.OKPO,'+FormatToVarCharServer_notNULL('')+'))) as OKPO'
                     +'                from dba.Unit'
                     +'                     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)'
                     +'                                                                                    and trim(ClientInformation_find.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id'
                     +'                                                                                    and trim(ClientInformation_child.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                where Unit.isFindBill = zc_rvYes()'
                     +'                  and OKPO <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as Unit on Unit.OKPO = _pgPartner_find.OKPO');


                  //Add('where Unit.OKPO is not null or isnull(Id_Postgres,0) <> 0');
                  //Add('where Unit.OKPO is not null and isnull(Id_Postgres,0) = 0');
                  Add('order by inJuridicalId, ObjectName, ObjectId');

        Open;
        cbPartnerFl.Caption:='3.3. ('+IntToStr(RecordCount)+') Контрагенты Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Partner_Sybase';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGLNCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPrepareDayCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDocumentDayCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalTakeId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('pgPartnerId').AsInteger<10000)
             then begin
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inAddress').Value:=FieldByName('inAddress').AsString;
             toStoredProc.Params.ParamByName('inGLNCode').Value:=FieldByName('inGLNCode').AsString;
             toStoredProc.Params.ParamByName('inPrepareDayCount').Value:=FieldByName('inPrepareDayCount').AsFloat;
             toStoredProc.Params.ParamByName('inDocumentDayCount').Value:=FieldByName('inDocumentDayCount').AsFloat;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('inJuridicalId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('inRouteId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('inRouteSortingId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalTakeId').Value:=FieldByName('inPersonalTakeId').AsInteger;

             if not myExecToStoredProc then ;//exit;


                 PartnerId_pg:=toStoredProc.Params.ParamByName('ioId').Value;
             end// if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('pgPartnerId').AsInteger<10000)
             else
                 PartnerId_pg:=FieldByName('Id_Postgres').AsInteger;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecFlSqFromQuery(' update dba._pgPartner set PartnerId_pg = case when trim (UnitId) = '+FormatToVarCharServer_notNULL('')
                                   + '                                                 or trim (UnitId) = '+FormatToVarCharServer_notNULL('0')
                                   + '                                                 or trim (UnitName) = '+FormatToVarCharServer_notNULL('')
                                    +'                                                    then ' + FormatToVarCharServer_notNULL('0')
                                    +'                                               else '+IntToStr(PartnerId_pg)
                                    +'                                          end'
                                    +' where JuridicalId_pg = '+FieldByName('inJuridicalId').AsString
                                    +'   and Main = '+FieldByName('Main').AsString
                                    );

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPartnerFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Partner_Int (isBill:Boolean);
var PartnerId_pg:Integer;
begin
     if (not cbPartnerInt.Checked)or(not cbPartnerInt.Enabled) then exit;
     //
     myEnabledCB(cbPartnerInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
                  Add('select 0 as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , case when trim(_pgPartner.UnitName) <> '+FormatToVarCharServer_notNULL('')+'  then trim(_pgPartner.UnitName)');
                  Add('            else trim(_pgPartner.UnitName)');//trim(isnull(Unit.UnitName,_pgPartner.UnitName))
                  Add('       end as ObjectName');
                  Add('     , case when trim(_pgPartner.AdrUnit) <> '+FormatToVarCharServer_notNULL('')+'  then trim(_pgPartner.AdrUnit)');
                  Add('            else ObjectName');
                  Add('       end as inAddress');
                  Add('     , ClientInformation_gln.GLN as inGLNCode');
                  Add('     , null AS inPrepareDayCount');
                  Add('     , null AS inDocumentDayCount');
                  //Add('     , Unit.Id_byLoad, Unit.Id');
                  Add('     , _pgPartner.OKPO');
                  Add('     , _pgPartner.UnitId');
                  Add('     , _pgPartner_find.Main');
                  Add('     , _pgPartner_find.Id as pgPartnerId, _pgPartner_find_two.Id as pgPartnerId_two');
                  Add('     , _pgPartner_find.JuridicalId_pg as inJuridicalId');
                  Add('     , null AS inRouteId');
                  Add('     , null AS inRouteSortingId');
                  Add('     , null AS inPersonalTakeId');
                  Add('     , _pgPartner_find.PartnerId_pg as Id_Postgres');
                  Add('from (select min (_pgPartner.Id) as Id'
                    + '           , max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg'
                    + '           , JuridicalId_pg'
                    + '           , OKPO'
                    + '           , Main'
                    + '      from dba._pgPartner'
                    + '      where JuridicalId_pg<>0'
                    + '        and trim (UnitId) <> '+FormatToVarCharServer_notNULL('')
                    + '        and trim (UnitId) <> '+FormatToVarCharServer_notNULL('0')
                    + '        and trim (Main) <> '+FormatToVarCharServer_notNULL('')
                    + '        and trim (Main) <> '+FormatToVarCharServer_notNULL('0')
                    + '        and trim (UnitName) <> '+FormatToVarCharServer_notNULL('')
//                    + '        and _pgPartner.Id = 938'
                    + '      group by JuridicalId_pg'
                    + '             , OKPO'
                    + '             , Main'
                    + '     ) as _pgPartner_find'
                    + '     left join (select min (_pgPartner.Id) as Id'
                    + '                     , JuridicalId_pg'
                    + '                     , OKPO'
                    + '                     , Main'
                    + '                from dba._pgPartner'
                    + '                where JuridicalId_pg<>0'
                    + '                  and trim (UnitId) <> '+FormatToVarCharServer_notNULL('')
                    + '                  and trim (UnitId) <> '+FormatToVarCharServer_notNULL('0')
                    + '                  and trim (Main) <> '+FormatToVarCharServer_notNULL('')
                    + '                  and trim (Main) <> '+FormatToVarCharServer_notNULL('0')
                    + '                  and trim (UnitName) <> '+FormatToVarCharServer_notNULL('')
                    + '                  and trim (AdrUnit) <> '+FormatToVarCharServer_notNULL('')
                    + '                group by JuridicalId_pg'
                    + '                       , OKPO'
                    + '                       , Main'
                    + '               ) as _pgPartner_find_two on _pgPartner_find_two.JuridicalId_pg = _pgPartner_find.JuridicalId_pg'
                    + '                                       and _pgPartner_find_two.Main = _pgPartner_find.Main'
                    + '                                       and _pgPartner_find_two.OKPO = _pgPartner_find.OKPO'
                    + '     left join dba._pgPartner on _pgPartner.Id = isnull(_pgPartner_find_two.Id, _pgPartner_find.Id)'

                    + '     left join (select max (_pgPartner.UnitId) as ClientId'
                    + '                     , PartnerId_pg'
                    + '                from dba._pgPartner'
                    + '                      join dba.ClientInformation on ClientInformation.ClientId = _pgPartner.UnitId'
                    + '                                                 and trim (GLN) <> '+FormatToVarCharServer_notNULL('')
                    + '                where PartnerId_pg<>0'
                    + '                group by PartnerId_pg'
                    + '               ) as _pgPartner_gln on _pgPartner_gln.PartnerId_pg = _pgPartner_find.PartnerId_pg'
                    + '     left join dba.ClientInformation as ClientInformation_gln on ClientInformation_gln.ClientId = _pgPartner_gln.ClientId');

                  Add('     left join (select trim(isnull(ClientInformation_child.OKPO,isnull(ClientInformation_find.OKPO,'+FormatToVarCharServer_notNULL('')+'))) as OKPO'
                     +'                from dba.Unit'
                     +'                     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)'
                     +'                                                                                    and trim(ClientInformation_find.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id'
                     +'                                                                                    and trim(ClientInformation_child.OKPO) <> ' + FormatToVarCharServer_notNULL('')
                     +'                where Unit.isFindBill = zc_rvYes()'
                     +'                  and OKPO <> ' + FormatToVarCharServer_notNULL('')
                     +'                group by OKPO'
                     +'               ) as Unit on Unit.OKPO = _pgPartner_find.OKPO');
                  Add('where Unit.OKPO is not null or isnull(Id_Postgres,0) <> 0');
                  //Add('and _pgPartner_find.PartnerId_pg=0');
                  Add('order by inJuridicalId, ObjectName, ObjectId');

        Open;
        cbPartnerInt.Caption:='2.6. ('+IntToStr(RecordCount)+') Контрагенты Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Partner_Sybase';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGLNCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPrepareDayCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDocumentDayCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalTakeId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             if (FieldByName('Id_Postgres').AsInteger=0)and((FieldByName('pgPartnerId').AsInteger>10000)
                                                          //or(FieldByName('pgPartnerId').AsInteger=1310)
                                                          //or(FieldByName('pgPartnerId').AsInteger=2859)
                                                           )
             then begin
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inAddress').Value:=FieldByName('inAddress').AsString;
             toStoredProc.Params.ParamByName('inGLNCode').Value:=FieldByName('inGLNCode').AsString;
             toStoredProc.Params.ParamByName('inPrepareDayCount').Value:=FieldByName('inPrepareDayCount').AsFloat;
             toStoredProc.Params.ParamByName('inDocumentDayCount').Value:=FieldByName('inDocumentDayCount').AsFloat;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('inJuridicalId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('inRouteId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('inRouteSortingId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalTakeId').Value:=FieldByName('inPersonalTakeId').AsInteger;

                if not myExecToStoredProc then ;//exit;
                PartnerId_pg:=toStoredProc.Params.ParamByName('ioId').Value;

             end // if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('pgPartnerId').AsInteger>10000)
             else begin
                 PartnerId_pg:=FieldByName('Id_Postgres').AsInteger;
                 if trim(FieldByName('inGLNCode').AsString) <> ''
                 then
                     fExecSqToQuery ('update ObjectString set ValueData = '+FormatToVarCharServer_notNULL(trim(FieldByName('inGLNCode').AsString))+' where ObjectId = '+IntToStr(PartnerId_pg)+' and DescId = zc_objectString_Partner_GLNCode()');
                 end;

             //
             //if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             if (PartnerId_pg>0)
             then fExecSqFromQuery(' update dba._pgPartner set PartnerId_pg = case when trim (UnitId) = '+FormatToVarCharServer_notNULL('')
                                 + '                                                 or trim (UnitId) = '+FormatToVarCharServer_notNULL('0')
                                 + '                                                 or trim (UnitName) = '+FormatToVarCharServer_notNULL('')
                                  +'                                                    then ' + FormatToVarCharServer_notNULL('0')
                                  +'                                               else '+IntToStr(PartnerId_pg)
                                  +'                                          end'
                                  +' where JuridicalId_pg = '+FieldByName('inJuridicalId').AsString
                                  +'   and Main = '+FieldByName('Main').AsString
                                  +'   and (Id>10000'
                                  //+'     or Id=1310'
                                  //+'     or Id=2859'
                                  +'       )'
                                  );

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPartnerInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Partner1CLink_Fl;
        function InsertData_pg(UnitId,PartnerId:Integer;inCode:Integer;inName,ContractNumber:String):Boolean;
        var findId,ContractId:Integer;
        begin
             //нашли
             fOpenSqToQuery(' select ObjectLink.ObjectId'
                           +' from ObjectLink'
                           +'      JOIN ObjectLink AS ObjectLink_Branch'
                           +'                      ON ObjectLink_Branch.ObjectId = ObjectLink.ObjectId'
                           +'                     AND ObjectLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()'
                           +'                     AND ObjectLink_Branch.ChildObjectId = '+IntToStr(UnitId)
                           +'      JOIN Object ON Object.Id = ObjectLink.ObjectId'
                           +'                 AND Object.ObjectCode = '+IntToStr(inCode)
                           +'                 AND 0<>'+IntToStr(inCode)
                           +'      JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink.ObjectId'
                           +'                        AND ObjectBoolean.DescId = zc_ObjectBoolean_Partner1CLink_Sybase()'
                           +' where ObjectLink.ChildObjectId = '+IntToStr(PartnerId)
                           +'   and ObjectLink.DescId = zc_ObjectLink_Partner1CLink_Partner()'
                           );
             findId:=toSqlQuery.FieldByName('ObjectId').AsInteger;
             ContractId:=fFind_ContractId_pg(PartnerId,30101,0,ContractNumber);
             //
             if (findId = 0)
             then if (inCode = 0)and (trim(inName)='') then exit;
             //сохраняем
             toStoredProc.Params.ParamByName('ioId').Value:=findId;
             toStoredProc.Params.ParamByName('inCode').Value:=inCode;
             toStoredProc.Params.ParamByName('inName').Value:=inName;
             toStoredProc.Params.ParamByName('inPartnerId').Value:=PartnerId;
             toStoredProc.Params.ParamByName('inBranchId').Value:=UnitId;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId;
             toStoredProc.Params.ParamByName('inIsSybase').Value:=true;
             Result:=myExecToStoredProc;
         end;
begin
     if (not cbData1CLink.Checked)or(not cbData1CLink.Enabled) then exit;
     //
     myEnabledCB(cbData1CLink);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Client_by1CExternal.Id as ObjectId');
        Add('     , ClientCode_byKiev,ClientName_byKiev'
           +'     , ClientCode_byDoneck,ClientName_byDoneck'
           +'     , ClientCode_byNikopol,ClientName_byNikopol'
           +'     , ClientCode_byOdessa,ClientName_byOdessa'
           +'     , ClientCode_byXerson,ClientName_byXerson'
           +'     , ClientCode_byCherkassi,ClientName_byCherkassi'
           +'     , ClientCode_bySimf,ClientName_bySimf'
           +'     , ClientCode_byKrRog,ClientName_byKrRog'
           +'     , ClientCode_byXarkov,ClientName_byXarkov');
        Add('     , _pgUnitKiev.Id_Postgres_Branch as Is_pg_Kiev'
           +'     , _pgUnitKrRog.Id_Postgres_Branch as Is_pg_KrRog'
           +'     , _pgUnitCherkassi.Id_Postgres_Branch as Is_pg_Cherkassi'
           +'     , _pgUnitXerson.Id_Postgres_Branch as Is_pg_Xerson'
           +'     , _pgUnitSimf.Id_Postgres_Branch as Is_pg_Simf'
           +'     , _pgUnitDoneck.Id_Postgres_Branch as Is_pg_Doneck'
           +'     , _pgUnitOdessa.Id_Postgres_Branch as Is_pg_Odessa'
           +'     , _pgUnitXarkov.Id_Postgres_Branch as Is_pg_Xarkov'
           +'     , _pgUnitNikopol.Id_Postgres_Branch as Is_pg_Nikopol');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');
        Add('     , _pgPartner.PartnerId_pg as ClientId_Postgres');
        Add('from dba.Client_by1CExternal');
        Add('          join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId'
           +'               ) as Unit_byLoad_Client on Unit_byLoad_Client.UnitId = Client_by1CExternal.ClientId');
        Add('          join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'               ) as _pgPartner on _pgPartner.UnitId = Unit_byLoad_Client.Id_byLoad');

        Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                                left outer join dba.ContractKind_byHistory as find1'
           +'                                            on find1.ClientId = Unit.DolgByUnitID'
           +'                                           and find1.EndDate=zc_DateEnd()'
           +'                                           and trim(find1.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
           +'                                left outer join dba.ContractKind_byHistory as find2'
           +'                                            on find2.ClientId = Unit.Id'
           +'                                           and find2.EndDate=zc_DateEnd()'
           +'                                           and trim(find2.ContractNumber) <> ' + FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Client_by1CExternal.ClientId'
           +'          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Contract_find.Id');

        Add('     left outer join dba._pgUnit as _pgUnitKiev       on _pgUnitKiev.ObjectCode      = 22020');
        Add('     left outer join dba._pgUnit as _pgUnitKrRog      on _pgUnitKrRog.ObjectCode     = 22030');
        Add('     left outer join dba._pgUnit as _pgUnitCherkassi  on _pgUnitCherkassi.ObjectCode = 22040');
        Add('     left outer join dba._pgUnit as _pgUnitXerson     on _pgUnitXerson.ObjectCode    = 22050');
        Add('     left outer join dba._pgUnit as _pgUnitSimf       on _pgUnitSimf.ObjectCode      = 22060');
        Add('     left outer join dba._pgUnit as _pgUnitDoneck     on _pgUnitDoneck.ObjectCode    = 22070');
        Add('     left outer join dba._pgUnit as _pgUnitOdessa     on _pgUnitOdessa.ObjectCode    = 22080');
        Add('     left outer join dba._pgUnit as _pgUnitXarkov     on _pgUnitXarkov.ObjectCode    = 22090');
        Add('     left outer join dba._pgUnit as _pgUnitNikopol    on _pgUnitNikopol.ObjectCode   = 22100');
// Add('where 1=0');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Partner1CLink';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchTopId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsSybase',ftBoolean,ptInput, true);
        //
        //!!!Обнуляем признак!!!
        fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update ObjectBoolean set ValueData=FALSE where DescId=zc_ObjectBoolean_Partner1CLink_Sybase()')+')');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             InsertData_pg(FieldByName('Is_pg_Kiev').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byKiev').AsInteger,FieldByName('ClientName_byKiev').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Doneck').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byDoneck').AsInteger,FieldByName('ClientName_byDoneck').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Nikopol').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byNikopol').AsInteger,FieldByName('ClientName_byNikopol').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Odessa').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byOdessa').AsInteger,FieldByName('ClientName_byOdessa').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Xerson').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byXerson').AsInteger,FieldByName('ClientName_byXerson').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Cherkassi').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byCherkassi').AsInteger,FieldByName('ClientName_byCherkassi').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Simf').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_bySimf').AsInteger,FieldByName('ClientName_bySimf').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_KrRog').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byKrRog').AsInteger,FieldByName('ClientName_byKrRog').AsString
                          ,FieldByName('ContractNumber').AsString);
             InsertData_pg(FieldByName('Is_pg_Xarkov').AsInteger,FieldByName('ClientId_Postgres').AsInteger
                          ,FieldByName('ClientCode_byXarkov').AsInteger,FieldByName('ClientName_byXarkov').AsString
                          ,FieldByName('ContractNumber').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     //!!!Обнуляем значения если не было обработки!!!
     fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update Object set ObjectCode=0,ValueData='+FormatToVarCharServer_notNULL('')+FormatToVarCharServer_notNULL('')+' where id in (select ObjectId from ObjectBoolean where ValueData=FALSE and DescId=zc_ObjectBoolean_Partner1CLink_Sybase())')+')');
     //
     myDisabledCB(cbData1CLink);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Goods1CLink_Fl;
        function InsertData_pg(UnitId,GoodsId,GoodsKindId:Integer;inCode:Integer;inName:String):Boolean;
        var findId:Integer;
            addStr:String;
        begin
              if GoodsKindId<>0
              then addStr:=' JOIN ObjectLink AS ObjectLink_GoodsKind'
                          +'                 ON ObjectLink_GoodsKind.ObjectId = ObjectLink_Branch.ObjectId'
                          +'                AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()'
                          +'                AND ObjectLink_GoodsKind.ChildObjectId = '+IntToStr(GoodsKindId)
              else addStr:='';

             //нашли
             fOpenSqToQuery(' select ObjectLink_Branch.ObjectId'
                           +' from ObjectLink AS ObjectLink_Branch'
                           +'      JOIN ObjectLink AS ObjectLink_Goods'
                           +'                      ON ObjectLink_Goods.ObjectId = ObjectLink_Branch.ObjectId'
                           +'                     AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()'
                           +'                     AND ObjectLink_Goods.ChildObjectId = '+IntToStr(GoodsId)
                           +addStr
                           +'      JOIN Object ON Object.Id = ObjectLink_Branch.ObjectId'
                           +'                 AND Object.ObjectCode = '+IntToStr(inCode)
                           +'                 AND 0<>'+IntToStr(inCode)
                           +'      JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_Branch.ObjectId'
                           +'                        AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase()'
                           +' where ObjectLink_Branch.ChildObjectId = '+IntToStr(UnitId)
                           +'   and ObjectLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()'
                           );
             findId:=toSqlQuery.FieldByName('ObjectId').AsInteger;
             //
             if (findId = 0)
             then if (inCode = 0)and (trim(inName)='') then exit;
             //сохраняем
             toStoredProc.Params.ParamByName('ioId').Value:=findId;
             toStoredProc.Params.ParamByName('inCode').Value:=inCode;
             toStoredProc.Params.ParamByName('inName').Value:=inName;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=GoodsId;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=GoodsKindId;
             toStoredProc.Params.ParamByName('inBranchId').Value:=UnitId;
             toStoredProc.Params.ParamByName('inIsSybase').Value:=true;
             Result:=myExecToStoredProc;
         end;
begin
     if (not cbData1CLink.Checked)or(not cbData1CLink.Enabled) then exit;
     //
     myEnabledCB(cbData1CLink);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Goods_by1CExternal.Id as ObjectId');
        Add('     , GoodsCode_byKiev,GoodsName_byKiev'
           +'     , GoodsCode_byDoneck,GoodsName_byDoneck'
           +'     , GoodsCode_byNikopol,GoodsName_byNikopol'
           +'     , GoodsCode_byOdessa,GoodsName_byOdessa'
           +'     , GoodsCode_byXerson,GoodsName_byXerson'
           +'     , GoodsCode_byCherkassi,GoodsName_byCherkassi'
           +'     , GoodsCode_bySimf,GoodsName_bySimf'
           +'     , GoodsCode_byKrRog,GoodsName_byKrRog'
           +'     , GoodsCode_byXarkov,GoodsName_byXarkov');
        Add('     , _pgUnitKiev.Id_Postgres_Branch as Is_pg_Kiev'
           +'     , _pgUnitKrRog.Id_Postgres_Branch as Is_pg_KrRog'
           +'     , _pgUnitCherkassi.Id_Postgres_Branch as Is_pg_Cherkassi'
           +'     , _pgUnitXerson.Id_Postgres_Branch as Is_pg_Xerson'
           +'     , _pgUnitSimf.Id_Postgres_Branch as Is_pg_Simf'
           +'     , _pgUnitDoneck.Id_Postgres_Branch as Is_pg_Doneck'
           +'     , _pgUnitOdessa.Id_Postgres_Branch as Is_pg_Odessa'
           +'     , _pgUnitXarkov.Id_Postgres_Branch as Is_pg_Xarkov'
           +'     , _pgUnitNikopol.Id_Postgres_Branch as Is_pg_Nikopol');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('from dba.Goods_by1CExternal');
        Add('     join (select max(GoodsProperty_Detail_byLoad.Id_byLoad) as Id_byLoad, GoodsPropertyId, KindPackageId from dba.GoodsProperty_Detail_byLoad where GoodsProperty_Detail_byLoad.Id_byLoad<>0 group by GoodsPropertyId, KindPackageId');
        Add('          ) as GoodsProperty_Detail_byLoad on GoodsProperty_Detail_byLoad.GoodsPropertyId = Goods_by1CExternal.GoodsPropertyId');
        Add('                                          and GoodsProperty_Detail_byLoad.KindPackageId = Goods_by1CExternal.KindPackageId');
        Add('     join dba.GoodsProperty_Detail_byServer on GoodsProperty_Detail_byServer.Id = GoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     join dba.GoodsProperty_i as GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail_byServer.GoodsPropertyId');
        Add('     left outer join dba.Goods_i as Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('     left outer join dba._pgUnit as _pgUnitKiev       on _pgUnitKiev.ObjectCode      = 22020');
        Add('     left outer join dba._pgUnit as _pgUnitKrRog      on _pgUnitKrRog.ObjectCode     = 22030');
        Add('     left outer join dba._pgUnit as _pgUnitCherkassi  on _pgUnitCherkassi.ObjectCode = 22040');
        Add('     left outer join dba._pgUnit as _pgUnitXerson     on _pgUnitXerson.ObjectCode    = 22050');
        Add('     left outer join dba._pgUnit as _pgUnitSimf       on _pgUnitSimf.ObjectCode      = 22060');
        Add('     left outer join dba._pgUnit as _pgUnitDoneck     on _pgUnitDoneck.ObjectCode    = 22070');
        Add('     left outer join dba._pgUnit as _pgUnitOdessa     on _pgUnitOdessa.ObjectCode    = 22080');
        Add('     left outer join dba._pgUnit as _pgUnitXarkov     on _pgUnitXarkov.ObjectCode    = 22090');
        Add('     left outer join dba._pgUnit as _pgUnitNikopol    on _pgUnitNikopol.ObjectCode   = 22100');
// Add('where  GoodsCode_byKiev=15487');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_GoodsByGoodsKind1CLink';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchTopId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsSybase',ftBoolean,ptInput, true);
        //
        //!!!Обнуляем признак
        fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update ObjectBoolean set ValueData=FALSE where DescId=zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase()')+')');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             InsertData_pg(FieldByName('Is_pg_Kiev').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byKiev').AsInteger,FieldByName('GoodsName_byKiev').AsString);

             InsertData_pg(FieldByName('Is_pg_Doneck').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byDoneck').AsInteger,FieldByName('GoodsName_byDoneck').AsString);

             InsertData_pg(FieldByName('Is_pg_Nikopol').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byNikopol').AsInteger,FieldByName('GoodsName_byNikopol').AsString);

             InsertData_pg(FieldByName('Is_pg_Odessa').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byOdessa').AsInteger,FieldByName('GoodsName_byOdessa').AsString);

             InsertData_pg(FieldByName('Is_pg_Xerson').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byXerson').AsInteger,FieldByName('GoodsName_byXerson').AsString);

             InsertData_pg(FieldByName('Is_pg_Cherkassi').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byCherkassi').AsInteger,FieldByName('GoodsName_byCherkassi').AsString);

             InsertData_pg(FieldByName('Is_pg_Simf').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_bySimf').AsInteger,FieldByName('GoodsName_bySimf').AsString);

             InsertData_pg(FieldByName('Is_pg_KrRog').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byKrRog').AsInteger,FieldByName('GoodsName_byKrRog').AsString);

             InsertData_pg(FieldByName('Is_pg_Xarkov').AsInteger,FieldByName('GoodsId_Postgres').AsInteger,FieldByName('GoodsKindId_Postgres').AsInteger
                          ,FieldByName('GoodsCode_byXarkov').AsInteger,FieldByName('GoodsName_byXarkov').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     //!!!Обнуляем значения если не было обработки!!!
     fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update Object set ObjectCode=0,ValueData='+FormatToVarCharServer_notNULL('')+FormatToVarCharServer_notNULL('')+' where id in (select ObjectId from ObjectBoolean where ValueData=FALSE and DescId=zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase())')+')');
     //
     myDisabledCB(cbData1CLink);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsProperty_Detail;
begin
     if (not cbGoodsProperty_Detail.Checked)or(not cbGoodsProperty_Detail.Enabled) then exit;
     //
     myEnabledCB(cbGoodsProperty_Detail);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty_Detail.Id as ObjectId');
        Add('     , GoodsProperty.Id_Postgres as GoodsPropertyId_pg');
        Add('     , KindPackage.Id_Postgres as KindPackageId_pg');
        Add('from dba.GoodsProperty_Detail');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = GoodsProperty_Detail.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where KindPackage.Id_Postgres is not null');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             fOpenSqToQuery (' select Object_GoodsByGoodsKind_View.Id'
                            +' from Object_GoodsByGoodsKind_View'
                            +' where GoodsId='+FieldByName('GoodsPropertyId_pg').AsString
                            +'   and GoodsKindId='+FieldByName('KindPackageId_pg').AsString);

             fExecSqFromQuery('update dba.GoodsProperty_Detail set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toSqlQuery.FieldByName('Id').AsInteger)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsProperty_Detail);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Business;
begin
     if (not cbBusiness.Checked)or(not cbBusiness.Enabled) then exit;
     //
     myEnabledCB(cbBusiness);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit_Alan.Id as ObjectId');
        Add('     , 1 as ObjectCode');
        Add('     , Unit_Alan.UnitName as ObjectName');
        Add('     , Unit_Alan.Id_Postgres_Business as Id_Postgres');
        Add('from dba.Unit as Unit_Alan');
        Add('where Id = 3');// АЛАН
        Add('union all');
        Add('select Unit_Alan.Id as ObjectId');
        Add('     , 2 as ObjectCode');
        Add('     , '+FormatToVarCharServer_notNULL('Сырье')+' as ObjectName');
        Add('     , Unit_Alan.Id_Postgres_Business_TWO as Id_Postgres');
        Add('from dba.Unit as Unit_Alan');
        Add('where Id = 3');// АЛАН
        Add('union all');
        Add('select Unit_Alan.Id as ObjectId');
        Add('     , 3 as ObjectCode');
        Add('     , '+FormatToVarCharServer_notNULL('Чапли')+' as ObjectName');
        Add('     , Unit_Alan.Id_Postgres_Business_Chapli as Id_Postgres');
        Add('from dba.Unit as Unit_Alan');
        Add('where Id = 3');// АЛАН
        Add('order by ObjectId,ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_business';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then if FieldByName('ObjectCode').AsInteger=1
                  then fExecSqFromQuery('update dba.Unit set Id_Postgres_Business='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString)
                  else if FieldByName('ObjectCode').AsInteger=2
                       then fExecSqFromQuery('update dba.Unit set Id_Postgres_Business_TWO='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString)
                       else if FieldByName('ObjectCode').AsInteger=3
                            then fExecSqFromQuery('update dba.Unit set Id_Postgres_Business_Chapli='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbBusiness);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Branch;
begin
     if (not cbBranch.Checked)or(not cbBranch.Enabled) then exit;
     //
     myEnabledCB(cbBranch);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgUnit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , _pgUnit.Name3 as ObjectName');
        Add('     , case when _pgUnit.ObjectCode in (22010) then zc_rvYes() else zc_rvNo() end as zc_Branch_Basis');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , _pgUnit.Id_Postgres_Branch as Id_Postgres');
//        Add('     , 0 as JuridicalId_pg');
        Add('from dba._pgUnit');
        Add('     join dba._pgUnit as _pgUnit_parent on _pgUnit_parent.Id = _pgUnit.ParentId and _pgUnit_parent.ObjectCode in (22000)');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_branch';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
//        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
//             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('JuridicalId_pg').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgUnit set Id_Postgres_Branch='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             if FieldByName('zc_Branch_Basis').AsInteger=FieldByName('zc_rvYes').AsInteger
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Branch_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbBranch);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_UnitGroup;
begin
     ShowMessage ('!!! ERROR !!! pLoadGuide_UnitGroup');
     exit;
     //
     //
     if (not cbUnitGroup.Checked)or(not cbUnitGroup.Enabled) then exit;
     //
     myEnabledCB(cbUnitGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id1_Postgres as Id_Postgres');
        Add('     , case when Unit.Id in (3, 3714) then 0 else Unit_parent.Id1_Postgres end as ParentId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.isUnit on isUnit.UnitId = Unit.Id');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('where (fCheckUnitClientParentID(3,Unit.Id)=zc_rvYes()'    // АЛАН
           +'    or fCheckUnitClientParentID(3714,Unit.Id)=zc_rvYes()' // Алан-прочие
           +'      )');
        Add('  and isUnit.UnitId is null');
        Add('  and Unit.Id not in (4417' // КАПИТАЛЬНЫЕ ВЛОЖЕНИЯ-склад
                               +' ,4137' // МО ЛИЦА-ВСЕ
                               +' ,4927' // СКЛАД ПЕРЕПАК
                               +' ,4931' // СКЛАД ПЕРЕПАК ФОЗЗИ
                               +' ,3487' // Склад разделки мяса
                               +' )');
        Add('  and Unit.ParentId <> 4137'); // MO
        Add('  and Unit.Erased=zc_ErasedVis()');
        Add('  and Unit.HasChildren<>zc_hsLeaf()');

        Add('union all');

        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , '+FormatToVarCharServer_notNULL('ВСЕ Экспедиторы и Филиалы')+' as ObjectName');
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , 0 as ParentId_Postgres');
        Add('from dba.Unit');
        Add('where Unit.Id = 151'); // ВСЕ
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_unitgroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then if FieldByName('ObjectId').AsInteger=151
                  then fExecSqFromQuery('update dba.Unit set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString)
                  else fExecSqFromQuery('update dba.Unit set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbUnitGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_UnitOld;
begin
     if (not cbUnit.Checked)or(not cbUnit.Enabled) then exit;
     //
     myEnabledCB(cbUnit);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id1_Postgres as ParentId_Postgres');
        Add('     , Unit_Branch.Id3_Postgres as BranchId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.isUnit on isUnit.UnitId = Unit.Id');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('     left outer join dba.Unit as Unit_Branch on Unit_Branch.Id = 3'); // АЛАН
        Add('where (fCheckUnitClientParentID(3,Unit.Id)=zc_rvYes()'    // АЛАН
           +'    or fCheckUnitClientParentID(3714,Unit.Id)=zc_rvYes()' // Алан-прочие
           +'      )');
        Add('  and (isUnit.UnitId is not null or Unit.Id in (3487))'); // Склад разделки мяса
//        Add('  and Unit.Erased=zc_ErasedVis()');

        Add('union all');

        Add('select Unit.Id as ObjectId');
        Add('     , Unit.UnitCode as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id3_Postgres as ParentId_Postgres');
        Add('     , Unit_Branch.Id3_Postgres as BranchId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.isUnit on isUnit.UnitId = Unit.Id');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = 151'); // ВСЕ
        Add('     left outer join dba.Unit as Unit_Branch on Unit_Branch.Id = 3'); // АЛАН
        Add('where fCheckUnitClientParentID(3,Unit.Id)=zc_rvNo()'    // АЛАН
           +'  and fCheckUnitClientParentID(3714,Unit.Id)=zc_rvNo()' // Алан-прочие
            );
        Add('  and isnull(Unit.findGoodsCard,zc_rvNo()) = zc_rvYes()');
        Add('  and isUnit.UnitId is null');
//        Add('  and Unit.Erased=zc_ErasedVis()');
        Add('order by ObjectId');

        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_unit';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inUnitGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inUnitGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBranchId').Value:=FieldByName('BranchId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbUnit);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Unit;
begin
     if (not cbUnit.Checked)or(not cbUnit.Enabled) then exit;
     //
     myEnabledCB(cbUnit);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgUnit.Id as ObjectId');
        Add('     , _pgUnit.ObjectCode as ObjectCode');
        Add('     , _pgUnit.Name3 as ObjectName');
        Add('     , case when _pgUnit.ObjectCode in (31061, 31062) then zc_rvYes() else zc_rvNo() end as isPartionDate');
        Add('     , _pgUnit_parent.Id_Postgres as ParentId_Postgres');
        Add('     , isnull(_pgUnit_Branch_byCode.Id_Postgres_Branch, _pgUnit_Branch.Id_Postgres_Branch) as BranchId_Postgres');
        Add('     , case when _pgUnit.ObjectCode in (11020,21100) then Unit_Alan.Id_Postgres_Business_TWO else Unit_Alan.Id_Postgres_Business end as BusinessId_Postgres');
        Add('     , Unit_Alan.Id2_Postgres as JuridicalId_Postgres');
        Add('     , _pgAccount.Id2_Postgres as AccountDirectionId');
        Add('     , _pgProfitLoss.Id2_Postgres as ProfitLossDirectionId');
        Add('     , _pgUnit.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba._pgUnit');
        Add('     left outer join dba._pgUnit as _pgUnit_parent on _pgUnit_parent.Id = _pgUnit.ParentId');
        Add('     left outer join dba._pgUnit as _pgUnit_parent1 on _pgUnit_parent1.Id = _pgUnit_parent.ParentId');
        Add('     left outer join dba._pgUnit as _pgUnit_Branch on _pgUnit_Branch.Id = case when _pgUnit_parent.ObjectCode in (22000) then _pgUnit.Id'
           +'                                                                               when _pgUnit_parent1.ObjectCode in (22000) then _pgUnit.ParentId'
           +'                                                                          end');
        Add('     left outer join dba._pgUnit as _pgUnit_Branch_byCode on _pgUnit_Branch_byCode.ObjectCode = case when _pgUnit.ObjectCode between 21010 and 21090'
           +'                                                                                                          then _pgUnit.ObjectCode + 1000'
           +'                                                                                                     when _pgUnit.ObjectCode = 21100' //  -,+ 21100 - Транспорт мясное сырье
           +'                                                                                                          then 22010' // ф Днепр
           +'                                                                                                END');
        Add('     left outer join dba.Unit as Unit_Alan on Unit_Alan.Id = 3');// АЛАН
        Add('     left outer join dba._pgAccount on _pgAccount.ObjectCode = CASE WHEN _pgUnit_parent.ObjectCode in (22000,21000) or _pgUnit_parent1.ObjectCode in (22000) THEN 20701'); // Запасы + на филиалах
        Add('                                                                    WHEN (_pgUnit.ObjectCode between 31050 and 31056) or (_pgUnit.ObjectCode between 32010 and 32012) THEN 20201'); // Запасы + на складах
        Add('                                                                    WHEN _pgUnit.ObjectCode in (31071,32020,32021,32022,32030,32031,32032) THEN 20101'); // Запасы + на складах ГП
        Add('                                                                    WHEN _pgUnit.ObjectCode in (31070) THEN 20801'); // Запасы + на упаковке
        Add('                                                                    WHEN _pgUnit.ObjectCode in (31060) or _pgUnit_parent.ObjectCode in (31060) THEN 20401'); // Запасы + на производстве
        Add('                                                                END');
        Add('     left outer join dba._pgProfitLoss on _pgProfitLoss.ObjectCode = CASE WHEN _pgUnit.ObjectCode in (10000) THEN 30401'); // Административные расходы + Коммунальные услуги
        Add('                                                                          WHEN _pgUnit.ObjectCode in (30000) THEN 20601'); // Общепроизводственные расходы + Коммунальные услуги

        Add('                                                                          WHEN _pgUnit.ObjectCode in (11000) THEN 30101'); // Содержание админ
        Add('                                                                          WHEN _pgUnit.ObjectCode in (12000) THEN 30201'); // админ + Содержание транспорта
        Add('                                                                          WHEN _pgUnit.ObjectCode in (13000) THEN 30301'); // Содержание охраны
        Add('                                                                          WHEN _pgUnit.ObjectCode in (21000) THEN 40101'); // Сбыт  + Содержание транспорта
        Add('                                                                          WHEN _pgUnit.ObjectCode in (22000) THEN 40201'); // Содержание филиалов
        Add('                                                                          WHEN _pgUnit.ObjectCode in (23000) THEN 40301'); // Общефирменные
        Add('                                                                          WHEN _pgUnit.ObjectCode in (31000) THEN 20101'); // Содержание производства
        Add('                                                                          WHEN _pgUnit.ObjectCode in (32000) THEN 20201'); // Содержание складов
        Add('                                                                          WHEN _pgUnit.ObjectCode in (33000) THEN 20301'); // Производство + Содержание транспорта
        Add('                                                                          WHEN _pgUnit.ObjectCode in (34000) THEN 20401'); // Содержание Кухни
        Add('                                                                      END');
        Add('where _pgUnit.Id<>0');
        Add('order by ObjectCode');

        Open;
        cbUnit.Caption:='4.4. ('+IntToStr(RecordCount)+') Подразделения';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_unit';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPartionDate',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBusinessId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAccountDirectionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inProfitLossDirectionId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;

             if FieldByName('isPartionDate').AsInteger=FieldByName('zc_rvYes').AsInteger
             then toStoredProc.Params.ParamByName('inPartionDate').Value:=true
             else toStoredProc.Params.ParamByName('inPartionDate').Value:=false;

             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBranchId').Value:=FieldByName('BranchId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBusinessId').Value:=FieldByName('BusinessId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('JuridicalId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAccountDirectionId').Value:=FieldByName('AccountDirectionId').AsInteger;
             toStoredProc.Params.ParamByName('inProfitLossDirectionId').Value:=FieldByName('ProfitLossDirectionId').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgUnit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', Id_Postgres_Branch=zf_ChangeIntToNull('+IntToStr(FieldByName('BranchId_Postgres').AsInteger)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbUnit);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_RateFuel;
begin
     if (not cbCar.Checked)or(not cbCar.Enabled) then exit;
     //
     if cbOnlyOpen.Checked then exit;
     //
     myEnabledCB(cbCar);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgCar.Id as ObjectId');
        Add('     , _pgCar.I1 as inAmount_Internal');
        Add('     , _pgCar.I2 as inAmountColdDistance_Internal');
        Add('     , _pgCar.I3 as inAmountColdHour_Internal');
        Add('     , _pgCar.E1 as inAmount_External');
        Add('     , _pgCar.E2 as inAmountColdDistance_External');
        Add('     , _pgCar.E3 as inAmountColdHour_External');
        Add('     , _pgCar.CarId_pg as Id_Postgres');
        Add('from dba._pgCar');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001)as Goods_7001 on 1=1');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003)as Goods_7003 on 1=1');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7004)as Goods_7004 on 1=1');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7005)as Goods_7005 on 1=1');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_RateFuel';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inRateFuelId_Internal',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRateFuelId_External',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount_Internal',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountColdHour_Internal',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountColdDistance_Internal',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount_External',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountColdHour_External',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountColdDistance_External',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount_Internal').Value:=FieldByName('inAmount_Internal').AsFloat;
             toStoredProc.Params.ParamByName('inAmountColdHour_Internal').Value:=FieldByName('inAmountColdHour_Internal').AsFloat;
             toStoredProc.Params.ParamByName('inAmountColdDistance_Internal').Value:=FieldByName('inAmountColdDistance_Internal').AsFloat;
             toStoredProc.Params.ParamByName('inAmount_External').Value:=FieldByName('inAmount_External').AsFloat;
             toStoredProc.Params.ParamByName('inAmountColdHour_External').Value:=FieldByName('inAmountColdHour_External').AsFloat;
             toStoredProc.Params.ParamByName('inAmountColdDistance_External').Value:=FieldByName('inAmountColdDistance_External').AsFloat;
             if not myExecToStoredProc then ;//exit;
             //
             //if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             //then fExecSqFromQuery('update dba._pgCar set CarId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbCar);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Car;
begin
     if (not cbCar.Checked)or(not cbCar.Enabled) then exit;
     //
     if cbOnlyOpen.Checked then exit;
     //
     myEnabledCB(cbCar);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgCar.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim(_pgCar.Name) as ObjectName');

        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , _pgCar.ModelId_pg as inCarModelId');
        Add('     , _pgMember.PersonalId_pg as inPersonalDriverId');
        Add('     , case when trim(_pgCar.FuelName) ='+FormatToVarCharServer_notNULL('бензин')+' then Goods_7001.Id_Postgres_Fuel'
           +'            when trim(_pgCar.FuelName) ='+FormatToVarCharServer_notNULL('метан')+' then Goods_7004.Id_Postgres_Fuel'
           +'            when trim(_pgCar.FuelName) ='+FormatToVarCharServer_notNULL('д/т')+' then Goods_7003.Id_Postgres_Fuel'
           +'            when trim(_pgCar.FuelName) ='+FormatToVarCharServer_notNULL('пропан')+' then Goods_7005.Id_Postgres_Fuel'
           +'       end as inFuelMasterId');
        Add('     , case when trim(_pgCar.FuelName2) ='+FormatToVarCharServer_notNULL('бензин')+' then Goods_7001.Id_Postgres_Fuel'
           +'            when trim(_pgCar.FuelName2) ='+FormatToVarCharServer_notNULL('метан')+' then Goods_7004.Id_Postgres_Fuel'
           +'            when trim(_pgCar.FuelName2) ='+FormatToVarCharServer_notNULL('д/т')+' then Goods_7003.Id_Postgres_Fuel'
           +'            when trim(_pgCar.FuelName2) ='+FormatToVarCharServer_notNULL('пропан')+' then Goods_7005.Id_Postgres_Fuel'
           +'       end as inFuelChildId');

        Add('     , _pgCar.CarId_pg as Id_Postgres');
        Add('from dba._pgCar');
        Add('     left outer join dba._pgUnit on _pgUnit.ObjectCode=_pgCar.UnitCode');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001)as Goods_7001 on 1=1');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003)as Goods_7003 on 1=1');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7004)as Goods_7004 on 1=1');
        Add('     left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7005)as Goods_7005 on 1=1');
        Add('     left outer join dba._pgMember on _pgMember.FIO=_pgCar.FIO');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Car';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inRegistrationCertificate',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCarModelId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFuelMasterId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFuelChildId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inCarModelId').Value:=FieldByName('inCarModelId').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('inPersonalDriverId').AsInteger;
             toStoredProc.Params.ParamByName('inFuelMasterId').Value:=FieldByName('inFuelMasterId').AsInteger;
             toStoredProc.Params.ParamByName('inFuelChildId').Value:=FieldByName('inFuelChildId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgCar set CarId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbCar);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_CarModel;
begin
     if (not cbCar.Checked)or(not cbCar.Enabled) then exit;
     //
     myEnabledCB(cbCar);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim(CarModel) as ObjectName');
        Add('     , ModelId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgCar.ModelId_pg,0)) AS ModelId_pg, CarModel from dba._pgCar where CarModel <> '+FormatToVarCharServer_notNULL('') +' group by CarModel) as CarModelList');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_CarModel';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgCar set ModelId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim(CarModel) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbCar);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Route;
var extId,intId:String;
begin
     if (not cbRoute.Checked)or(not cbRoute.Enabled) then exit;
     //
     if cbOnlyOpen.Checked then exit;
     //
     fOpenSqToQuery ('select zc_Enum_RouteKind_Internal() AS zc_Enum_RouteKind_Internal');
     intId:=toSqlQuery.FieldByName('zc_Enum_RouteKind_Internal').AsString;
     fOpenSqToQuery ('select zc_Enum_RouteKind_External() AS zc_Enum_RouteKind_External');
     extId:=toSqlQuery.FieldByName('zc_Enum_RouteKind_External').AsString;

     //
     myEnabledCB(cbRoute);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgRoute.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim(_pgRoute.Name) as ObjectName');

        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , _pgRoute.FreightId_pg as inFreightId');
        Add('     , case when _pgRoute.RouteKindName ='+FormatToVarCharServer_notNULL('город')+' then '+intId+' else '+extId+' end as inRouteKindId');

        Add('     , _pgRoute.RouteId_pg as Id_Postgres');
        Add('from dba._pgRoute');
        Add('     left outer join dba._pgUnit on _pgUnit.ObjectCode=_pgRoute.UnitCode');
        Add('where trim(_pgRoute.Name)<>'+FormatToVarCharServer_notNULL(''));
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Route';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFreightId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteKindId').Value:=FieldByName('inRouteKindId').AsInteger;
             toStoredProc.Params.ParamByName('inFreightId').Value:=FieldByName('inFreightId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgRoute set RouteId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbRoute);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Freight;
begin
     if (not cbRoute.Checked)or(not cbRoute.Enabled) then exit;
     //
     myEnabledCB(cbRoute);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim (FreightName) as ObjectName');
        Add('     , FreightId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgRoute.FreightId_pg,0)) AS FreightId_pg, FreightName from dba._pgRoute where FreightName <> '+FormatToVarCharServer_notNULL('') +' group by FreightName) as Freight');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Freight';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgRoute set FreightId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim (FreightName) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbRoute);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ModelService;
var zc_Enum_ModelServiceKind_DaySheetWorkTime,zc_Enum_ModelServiceKind_MonthSheetWorkTime,zc_Enum_ModelServiceKind_SatSheetWorkTime:String;
begin
     if (not cbModelService.Checked)or(not cbModelService.Enabled) then exit;
     //
     myEnabledCB(cbModelService);
     //
     fOpenSqToQuery ('select zc_Enum_ModelServiceKind_DaySheetWorkTime() AS KindId');
     zc_Enum_ModelServiceKind_DaySheetWorkTime := toSqlQuery.FieldByName('KindId').AsString;
     fOpenSqToQuery ('select zc_Enum_ModelServiceKind_MonthSheetWorkTime() AS KindId');
     zc_Enum_ModelServiceKind_MonthSheetWorkTime := toSqlQuery.FieldByName('KindId').AsString;
     fOpenSqToQuery ('select zc_Enum_ModelServiceKind_SatSheetWorkTime() AS KindId');
     zc_Enum_ModelServiceKind_SatSheetWorkTime := toSqlQuery.FieldByName('KindId').AsString;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , ObjectName');
        Add('     , UnitCode_all');
        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , myComment as inComment');
        Add('     , case when ModelServiceKindName='+FormatToVarCharServer_notNULL('за месяц')+' then '+zc_Enum_ModelServiceKind_MonthSheetWorkTime
           +'            when ModelServiceKindName='+FormatToVarCharServer_notNULL('по дням табель')+' then '+zc_Enum_ModelServiceKind_DaySheetWorkTime
           +'            when ModelServiceKindName='+FormatToVarCharServer_notNULL('по субботам')+' then '+zc_Enum_ModelServiceKind_SatSheetWorkTime
           +'       end as inModelServiceKindId');
        Add('     , ModelServiceId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgModelService.ModelServiceId_pg,0)) AS ModelServiceId_pg'
           +'           , '+FormatToVarCharServer_notNULL('-') + 'as Sep'
           +'           , trim(_pgModelService.UnitCode_all) as UnitCode_all'
           +'           , zf_Calc_Word_bySeparate (UnitCode_all,Sep,Sep,1) as UnitCode'
           +'           , trim(_pgModelService.ModelServiceName) as ObjectName'
           +'           , trim(_pgModelService.ModelServiceKindName) as ModelServiceKindName'
           +'           , trim(_pgModelService.myComment) as myComment'
           +'      from dba._pgModelService'
           +'      where ObjectName <> '+FormatToVarCharServer_notNULL('')
           +'      group by UnitCode_all, ObjectName,ModelServiceKindName,myComment'
           +'     ) as ModelService');
        Add('     left outer join dba._pgUnit on _pgUnit.ObjectCode = ModelService.UnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_ModelService';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inModelServiceKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('inComment').AsString;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             toStoredProc.Params.ParamByName('inModelServiceKindId').Value:=FieldByName('inModelServiceKindId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then begin fExecSqFromQuery('update dba._pgModelService set ModelServiceId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                       +' where trim(ModelServiceName) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString)
                                       +'   and trim(UnitCode_all) = '+FormatToVarCharServer_notNULL(FieldByName('UnitCode_all').AsString));
                        fExecSqFromQuery('update dba._pgStaffListCost set ModelServiceId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                       +' where trim(ModelServiceName) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString)
                                       +'   and trim(UnitCode_all) = '+FormatToVarCharServer_notNULL(FieldByName('UnitCode_all').AsString));
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbModelService);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ModelServiceItemMaster;
var zc_Enum_SelectKind_InAmount,zc_Enum_SelectKind_OutAmount:String;
    zc_Movement_ProductionUnion,zc_Movement_Send:String;
begin
     if (not cbModelService.Checked)or(not cbModelService.Enabled) then exit;
     //
     myEnabledCB(cbModelService);
     //
     fOpenSqToQuery ('select zc_Enum_SelectKind_InAmount() AS FindId');
     zc_Enum_SelectKind_InAmount := toSqlQuery.FieldByName('FindId').AsString;
     fOpenSqToQuery ('select zc_Enum_SelectKind_OutAmount() AS FindId');
     zc_Enum_SelectKind_OutAmount := toSqlQuery.FieldByName('FindId').AsString;

     fOpenSqToQuery ('select zc_Movement_ProductionUnion() AS FindId');
     zc_Movement_ProductionUnion := toSqlQuery.FieldByName('FindId').AsString;
     fOpenSqToQuery ('select zc_Movement_Send() AS FindId');
     zc_Movement_Send := toSqlQuery.FieldByName('FindId').AsString;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , null as ObjectName');
        Add('     , ModelServiceId_pg as inModelServiceId');
        Add('     , _pgUnitFrom.Id_Postgres as inFromId');
        Add('     , _pgUnitTo.Id_Postgres as inToId');
        Add('     , MovementDescName as inComment');
        Add('     , MovementDescName, FromUnitCode, ToUnitCode, SelectKindName, Ratio');
        Add('     , cast(case when Ratio='+FormatToVarCharServer_notNULL('')+' then 0 else Ratio end as TSumm) as inRatio');
        Add('     , case when MovementDescName='+FormatToVarCharServer_notNULL('Производство-с')+' then '+zc_Movement_ProductionUnion
           +'            when MovementDescName='+FormatToVarCharServer_notNULL('Перемещение')+' then '+zc_Movement_Send
           +'       end as inMovementDescId');
        Add('     , case when SelectKindName='+FormatToVarCharServer_notNULL('Кол-во прих.')+' then '+zc_Enum_SelectKind_InAmount
           +'            when SelectKindName='+FormatToVarCharServer_notNULL('Кол-во расх.')+' then '+zc_Enum_SelectKind_OutAmount
           +'       end as inSelectKindId');
        Add('     , ModelServiceItemMasterId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgModelService.ModelServiceItemMasterId_pg,0)) AS ModelServiceItemMasterId_pg'
           +'           , _pgModelService.ModelServiceId_pg'
           +'           , trim(_pgModelService.MovementDescName) as MovementDescName'
           +'           , trim(_pgModelService.FromUnitCode) as FromUnitCode'
           +'           , trim(_pgModelService.ToUnitCode) as ToUnitCode'
           +'           , trim(_pgModelService.SelectKindName) as SelectKindName'
           +'           , trim(_pgModelService.Ratio) as Ratio'
           +'      from dba._pgModelService'
           +'      where _pgModelService.ModelServiceId_pg<>0'
           +'      group by ModelServiceId_pg, MovementDescName, FromUnitCode, ToUnitCode, SelectKindName,Ratio'
           +'     ) as ModelService');
        Add('     left outer join dba._pgUnit as _pgUnitFrom on _pgUnitFrom.ObjectCode = ModelService.FromUnitCode');
        Add('     left outer join dba._pgUnit as _pgUnitTo on _pgUnitTo.ObjectCode = ModelService.ToUnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_ModelServiceItemMaster';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementDescId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRatio',ftFloat,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inModelServiceId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inSelectKindId',ftInteger,ptInput, 0);
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementDescId').Value:=FieldByName('inMovementDescId').AsInteger;
             toStoredProc.Params.ParamByName('inRatio').Value:=FieldByName('inRatio').AsFloat;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('inComment').AsString;
             toStoredProc.Params.ParamByName('inModelServiceId').Value:=FieldByName('inModelServiceId').AsInteger;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('inFromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('inToId').AsInteger;
             toStoredProc.Params.ParamByName('inSelectKindId').Value:=FieldByName('inSelectKindId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgModelService set ModelServiceItemMasterId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where ModelServiceId_pg = '+FieldByName('inModelServiceId').AsString
                                 +'   and trim(Ratio) = '+FormatToVarCharServer_notNULL(FieldByName('Ratio').AsString)
                                 +'   and trim(MovementDescName) = '+FormatToVarCharServer_notNULL(FieldByName('MovementDescName').AsString)
                                 +'   and trim(FromUnitCode) = '+FormatToVarCharServer_notNULL(FieldByName('FromUnitCode').AsString)
                                 +'   and trim(ToUnitCode) = '+FormatToVarCharServer_notNULL(FieldByName('ToUnitCode').AsString)
                                 +'   and trim(SelectKindName) = '+FormatToVarCharServer_notNULL(FieldByName('SelectKindName').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbModelService);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ModelServiceItemChild;
begin
     if (not cbModelService.Checked)or(not cbModelService.Enabled) then exit;
     //
     myEnabledCB(cbModelService);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ObjectId');
        Add('     , null as ObjectCode');
        Add('     , null as ObjectName');
        Add('     , ModelServiceItemMasterId_pg as inModelServiceItemMasterId');
        Add('     , isnull(GoodsPropertyFrom.Id_Postgres,GoodsFrom.Id_Postgres) as inFromId');
        Add('     , isnull(GoodsPropertyTo.Id_Postgres,GoodsTo.Id_Postgres) as inToId');
        Add('     , inComment');
        Add('     , ModelServiceItemChildId_pg as Id_Postgres');
        Add('from (select _pgModelService.Id AS ObjectId'
           +'           , (isnull (_pgModelService.ModelServiceItemChildId_pg,0)) AS ModelServiceItemChildId_pg'
           +'           , _pgModelService.ModelServiceItemMasterId_pg'
           +'           , trim(_pgModelService.GoodsId_in) as FromGoodsId'
           +'           , trim(_pgModelService.GoodsId_out) as ToGoodsId'
           +'           , trim(trim(_pgModelService.GoodsName_in) + '+FormatToVarCharServer_notNULL(' ')+' + trim(_pgModelService.GoodsName_out)) as inComment'
           +'      from dba._pgModelService'
           +'      where _pgModelService.ModelServiceItemMasterId_pg<>0'
           +'     ) as ModelService');
        Add('     left outer join dba.Goods as GoodsFrom on GoodsFrom.Id = ModelService.FromGoodsId');
        Add('     left outer join dba.Goods as GoodsTo on GoodsTo.Id = ModelService.ToGoodsId');
        Add('     left outer join dba.GoodsProperty as GoodsPropertyFrom on GoodsPropertyFrom.GoodsId = GoodsFrom.Id');
        Add('     left outer join dba.GoodsProperty as GoodsPropertyTo on GoodsPropertyTo.GoodsId = GoodsTo.Id');

        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_ModelServiceItemChild';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inModelServiceItemMasterId',ftInteger,ptInput, 0);
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('inComment').AsString;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('inFromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('inToId').AsInteger;
             toStoredProc.Params.ParamByName('inModelServiceItemMasterId').Value:=FieldByName('inModelServiceItemMasterId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgModelService set ModelServiceItemChildId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbModelService);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_StaffList;
begin
     if (not cbStaffList.Checked)or(not cbStaffList.Enabled) then exit;
     //
     myEnabledCB(cbStaffList);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgStaffList.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , UnitCode_all,myNumber');
        Add('     , case when trim(HoursPlan)='+FormatToVarCharServer_notNULL('')+' then 0 else HoursPlan end as inHoursPlan'
          +'      , case when trim(HoursDay)='+FormatToVarCharServer_notNULL('')+' then 0 else HoursDay end as inHoursDay'
          +'      , case when trim(PersonalCount)= '+FormatToVarCharServer_notNULL('')+' then 0 else PersonalCount end as inPersonalCount'
          +'      , myComment as inComment');
        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , PositionId_pg as inPositionId');
        Add('     , PositionLevelId_pg as inPositionLevelId');
        Add('     , StaffListId_pg as Id_Postgres');
        Add('from (select _pgStaffList.Id, (isnull (_pgStaffList.StaffListId_pg,0)) AS StaffListId_pg'
           +'           , '+FormatToVarCharServer_notNULL('-') + 'as Sep'
           +'           , trim(_pgStaffList.UnitCode_all)as UnitCode_all'
           +'           , zf_Calc_Word_bySeparate (UnitCode_all,Sep,Sep,1) as UnitCode'
           +'           , _pgStaffList.myNumber, HoursPlan, HoursDay, PersonalCount,myComment'
           +'           , isnull(_pgStaffList.PositionId_pg,0) as PositionId_pg'
           +'           , isnull(_pgStaffList.PositionLevelId_pg,0) as PositionLevelId_pg'
           +'      from dba._pgStaffList'
           +'      where PositionId_pg<>0'
//           +'      group by myNumber,UnitCode_all,PositionId_pg,PositionLevelId_pg,GroupId_pg
            + '    ) as _pgStaffList');
        Add('      left outer join dba._pgUnit on _pgUnit.ObjectCode = _pgStaffList.UnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_StaffList';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inHoursPlan',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHoursDay',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPositionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPositionLevelId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=0;
             toStoredProc.Params.ParamByName('inHoursPlan').Value:=FieldByName('inHoursPlan').AsFloat;
             toStoredProc.Params.ParamByName('inHoursDay').Value:=FieldByName('inHoursDay').AsFloat;
             toStoredProc.Params.ParamByName('inPersonalCount').Value:=FieldByName('inPersonalCount').AsFloat;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('inComment').AsString;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             toStoredProc.Params.ParamByName('inPositionId').Value:=FieldByName('inPositionId').AsInteger;
             toStoredProc.Params.ParamByName('inPositionLevelId').Value:=FieldByName('inPositionLevelId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then begin fExecSqFromQuery('update dba._pgStaffList set StaffListId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                       +' where Id = '+FieldByName('ObjectId').AsString);
                        fExecSqFromQuery('update dba._pgStaffListCost set StaffListId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                        +' where trim (myNumber) = '+FormatToVarCharServer_notNULL(FieldByName('myNumber').AsString)
                                        +'   and trim (UnitCode_all) = '+FormatToVarCharServer_notNULL(FieldByName('UnitCode_all').AsString));
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbStaffList);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_StaffListCost;
begin
     if (not cbStaffList.Checked)or(not cbStaffList.Enabled) then exit;
     //
     myEnabledCB(cbStaffList);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgStaffListCost.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , case when trim(Summ)='+FormatToVarCharServer_notNULL('')+' then 0 else Summ end as inPrice');
        Add('     , ModelServiceId_pg as inModelServiceId');
        Add('     , StaffListId_pg as inStaffListId');
        Add('     , StaffListCostId_pg as Id_Postgres');
        Add('from (select _pgStaffListCost.Id, _pgStaffListCost.ModelServiceId_pg, _pgStaffListCost.StaffListId_pg,_pgStaffListCost.StaffListCostId_pg'
           +'           , Summ'
           +'      from dba._pgStaffListCost'
           +'      where StaffListId_pg<>0 and ModelServiceId_pg<>0'
//           +'      group by myNumber,UnitCode_all,PositionId_pg,PositionLevelId_pg,GroupId_pg
            + '    ) as _pgStaffListCost');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_StaffListCost';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inStaffListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inModelServiceId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('inPrice').AsFloat;
             toStoredProc.Params.ParamByName('inComment').Value:='';
             toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
             toStoredProc.Params.ParamByName('inModelServiceId').Value:=FieldByName('inModelServiceId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgStaffListCost set StaffListCostId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbStaffList);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_StaffListSumm;
var zc_Enum_StaffListSummKind_Month,zc_Enum_StaffListSummKind_Day,zc_Enum_StaffListSummKind_Personal:String;
    zc_Enum_StaffListSummKind_HoursPlan,zc_Enum_StaffListSummKind_HoursDay,zc_Enum_StaffListSummKind_HoursPlanConst:String;
    //zc_Enum_StaffListSummKind_HoursDayConst,zc_Enum_StaffListSummKind_WorkHours:String;
begin
     if (not cbStaffList.Checked)or(not cbStaffList.Enabled) then exit;
     //
     myEnabledCB(cbStaffList);
     //
     fOpenSqToQuery ('select zc_Enum_StaffListSummKind_Month() AS KindId');
     zc_Enum_StaffListSummKind_Month := toSqlQuery.FieldByName('KindId').AsString;
     fOpenSqToQuery ('select zc_Enum_StaffListSummKind_Day() AS KindId');
     zc_Enum_StaffListSummKind_Day := toSqlQuery.FieldByName('KindId').AsString;
     fOpenSqToQuery ('select zc_Enum_StaffListSummKind_Personal() AS KindId');
     zc_Enum_StaffListSummKind_Personal := toSqlQuery.FieldByName('KindId').AsString;

     fOpenSqToQuery ('select zc_Enum_StaffListSummKind_HoursPlan() AS KindId');
     zc_Enum_StaffListSummKind_HoursPlan := toSqlQuery.FieldByName('KindId').AsString;
     fOpenSqToQuery ('select zc_Enum_StaffListSummKind_HoursDay() AS KindId');
     zc_Enum_StaffListSummKind_HoursDay := toSqlQuery.FieldByName('KindId').AsString;
     fOpenSqToQuery ('select zc_Enum_StaffListSummKind_HoursPlanConst() AS KindId');
     zc_Enum_StaffListSummKind_HoursPlanConst := toSqlQuery.FieldByName('KindId').AsString;
     // fOpenSqToQuery ('select zc_Enum_StaffListSummKind_HoursDayConst() AS KindId');
     // zc_Enum_StaffListSummKind_HoursDayConst := toSqlQuery.FieldByName('KindId').AsString;

     // fOpenSqToQuery ('select zc_Enum_StaffListSummKind_WorkHours() AS KindId');
     // zc_Enum_StaffListSummKind_WorkHours := toSqlQuery.FieldByName('KindId').AsString;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgStaffList.Id as ObjectId');
        Add('     , case when trim(_pgStaffList.Summ_Month)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_Month end as Summ_Month');
        Add('     , case when trim(_pgStaffList.Summ_Day)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_Day end as Summ_Day');
        Add('     , case when trim(_pgStaffList.Summ_Personal)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_Personal end as Summ_Personal');
        Add('     , case when trim(_pgStaffList.Summ_HoursPlan)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_HoursPlan end as Summ_HoursPlan');
        Add('     , case when trim(_pgStaffList.Summ_HoursDay)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_HoursDay end as Summ_HoursDay');
        Add('     , case when trim(_pgStaffList.Summ_HoursPlanConst)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_HoursPlanConst end as Summ_HoursPlanConst');
        //Add('     , case when trim(_pgStaffList.Summ_HoursDayConst)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.Summ_HoursDayConst end as Summ_HoursDayConst');
        //Add('     , case when trim(_pgStaffList.HoursDay)='+FormatToVarCharServer_notNULL('')+' then 0 else _pgStaffList.HoursDay end as HoursDay');
        Add('           , StaffListSumm_MonthId_pg'
           +'           , StaffListSumm_DayId_pg'
           +'           , StaffListSumm_PersonalId_pg'
           +'           , StaffListSumm_HoursPlanId_pg'
           +'           , StaffListSumm_HoursDayId_pg'
           +'           , StaffListSumm_HoursPlanConstId_pg'
           //+'           , StaffListSumm_HoursDayConstId_pg'
           //+'           , StaffListSumm_HoursOnDayId_pg'
           +'     , StaffListId_pg as inStaffListId');
        Add('from (select _pgStaffList.Id, _pgStaffList.StaffListId_pg'
           +'           , StaffListSumm_MonthId_pg'
           +'           , StaffListSumm_DayId_pg'
           +'           , StaffListSumm_PersonalId_pg'
           +'           , StaffListSumm_HoursPlanId_pg'
           +'           , StaffListSumm_HoursDayId_pg'
           +'           , StaffListSumm_HoursPlanConstId_pg'
           //+'           , StaffListSumm_HoursDayConstId_pg'
           //+'           , StaffListSumm_HoursOnDayId_pg'
           +'           , Summ_Month'
           +'           , Summ_Day'
           +'           , Summ_Personal'
           +'           , Summ_HoursPlan'
           +'           , Summ_HoursDay'
           +'           , Summ_HoursPlanConst'
           //+'           , Summ_HoursDayConst'
           //+'           , HoursDay'
           +'      from dba._pgStaffList'
           +'      where StaffListId_pg<>0'
            + '    ) as _pgStaffList');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_StaffListSumm';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inValue',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inStaffListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inStaffListMasterId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inStaffListSummKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //Summ_Month
             if (FieldByName('Summ_Month').AsFloat<>0)or(FieldByName('StaffListSumm_MonthId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_MonthId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_Month').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_Month);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_MonthId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;
             //Summ_Day
             if (FieldByName('Summ_Day').AsFloat<>0)or(FieldByName('StaffListSumm_DayId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_DayId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_Day').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_Day);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_DayId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;
             //Summ_Personal
             if (FieldByName('Summ_Personal').AsFloat<>0)or(FieldByName('StaffListSumm_PersonalId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_PersonalId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_Personal').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_Personal);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_PersonalId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;
             //Summ_HoursPlan
             if (FieldByName('Summ_HoursPlan').AsFloat<>0)or(FieldByName('StaffListSumm_HoursPlanId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_HoursPlanId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_HoursPlan').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_HoursPlan);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_HoursPlanId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;
             //Summ_HoursDay
             if (FieldByName('Summ_HoursDay').AsFloat<>0)or(FieldByName('StaffListSumm_HoursDayId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_HoursDayId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_HoursDay').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_HoursDay);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_HoursDayId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;
             //Summ_HoursPlanConst
             if (FieldByName('Summ_HoursPlanConst').AsFloat<>0)or(FieldByName('StaffListSumm_HoursPlanConstId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_HoursPlanConstId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_HoursPlanConst').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_HoursPlanConst);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_HoursPlanConstId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;
             //Summ_HoursDayConst
             {if (FieldByName('Summ_HoursDayConst').AsFloat<>0)or(FieldByName('StaffListSumm_HoursDayConstId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_HoursDayConstId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Summ_HoursDayConst').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_HoursDayConst);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_HoursDayConstId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;}
             //HoursDay
             {if (FieldByName('HoursDay').AsFloat<>0)or(FieldByName('StaffListSumm_HoursOnDayId_pg').AsInteger<>0)
             then begin
                       //!!!
                       if fStop then begin exit;end;
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('StaffListSumm_HoursOnDayId_pg').AsInteger;
                       toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('HoursDay').AsFloat;
                       toStoredProc.Params.ParamByName('inComment').Value:='';
                       toStoredProc.Params.ParamByName('inStaffListId').Value:=FieldByName('inStaffListId').AsInteger;
                       toStoredProc.Params.ParamByName('inStaffListMasterId').Value:=0;
                       toStoredProc.Params.ParamByName('inStaffListSummKindId').Value:=StrToInt(zc_Enum_StaffListSummKind_WorkHours);
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=1)//or(FieldByName('Id_Postgres').AsInteger=0)
                       then fExecSqFromQuery('update dba._pgStaffList set StaffListSumm_HoursOnDayId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                            +' where Id = '+FieldByName('ObjectId').AsString);
             end;}

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbStaffList);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Member_SheetWorkTime;
begin
     if (not cbMember_andPersonal_SheetWorkTime.Checked)or(not cbMember_andPersonal_SheetWorkTime.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal_SheetWorkTime);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , FIO as ObjectName');
        Add('     , null as inDriverCertificate');
        Add('     , null as inINN');
        Add('     , MemberId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.MemberId_pg,0)) AS MemberId_pg, trim(_pgMember.FIO) AS FIO'
           +'      from dba._pgMemberSWT as _pgMember'
           +'      group by FIO) as _pgMember');
        Add('order by ObjectId, ObjectName');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Member';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inINN',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inDriverCertificate',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inINN').Value:=FieldByName('inINN').AsString;
             toStoredProc.Params.ParamByName('inDriverCertificate').Value:=FieldByName('inDriverCertificate').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgMemberSWT set MemberId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where trim(FIO) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal_SheetWorkTime);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Personal_SheetWorkTime;
begin
     if (not cbMember_andPersonal_SheetWorkTime.Checked)or(not cbMember_andPersonal_SheetWorkTime.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal_SheetWorkTime);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , UnitCode_all');
        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , MemberId_pg as inMemberId');
        Add('     , PositionId_pg as inPositionId');
        Add('     , PositionLevelId_pg as inPositionLevelId');
        Add('     , GroupId_pg as inPersonalGroupId');
        Add('     , PersonalId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.PersonalId_pg,0)) AS PersonalId_pg'
           +'           , '+FormatToVarCharServer_notNULL('-') + 'as Sep'
           +'           , trim(_pgMember.UnitCode_all)as UnitCode_all'
           +'           , zf_Calc_Word_bySeparate (UnitCode_all,Sep,Sep,1) as UnitCode'
           +'           , MemberId_pg'
           +'           , PositionId_pg'
           +'           , GroupId_pg'
           +'           , isnull(PositionLevelId_pg,0) as PositionLevelId_pg'
           +'      from dba._pgMemberSWT as _pgMember'
           +'      where MemberId_pg<>0'
           +'      group by UnitCode_all,MemberId_pg,PositionId_pg,PositionLevelId_pg,GroupId_pg) as _pgMember');
        Add('      left outer join dba._pgUnit on _pgUnit.ObjectCode = _pgMember.UnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Personal';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMemberId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPositionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPositionLevelId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDateIn',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inDateOut',ftDateTime,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMemberId').Value:=FieldByName('inMemberId').AsInteger;
             toStoredProc.Params.ParamByName('inPositionId').Value:=FieldByName('inPositionId').AsInteger;
             toStoredProc.Params.ParamByName('inPositionLevelId').Value:=FieldByName('inPositionLevelId').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalGroupId').Value:=FieldByName('inPersonalGroupId').AsInteger;
             toStoredProc.Params.ParamByName('inDateIn').Value:='01.01.2013';
             toStoredProc.Params.ParamByName('inDateOut').Value:='01.01.2013';
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgMemberSWT set PersonalId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where MemberId_pg = '+FieldByName('inMemberId').AsString
                                 +'   and PositionId_pg = '+FieldByName('inPositionId').AsString
                                 +'   and isnull(PositionLevelId_pg,0) = '+FieldByName('inPositionLevelId').AsString
                                 +'   and trim (UnitCode_all) = '+FormatToVarCharServer_notNULL(FieldByName('UnitCode_all').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal_SheetWorkTime);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Position_SheetWorkTime;
begin
     if (not cbMember_andPersonal_SheetWorkTime.Checked)or(not cbMember_andPersonal_SheetWorkTime.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal_SheetWorkTime);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim(PositionName) as ObjectName');
        Add('     , PositionId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.PositionId_pg,0)) AS PositionId_pg, trim(_pgMember.PositionName) as PositionName from dba._pgMemberSWT as _pgMember where PositionName <> '+FormatToVarCharServer_notNULL('') +' group by PositionName) as Position');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Position';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then begin
                       fExecSqFromQuery('update dba._pgMemberSWT set PositionId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim(PositionName) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
                       fExecSqFromQuery('update dba._pgStaffList set PositionId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim(PositionName) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
                  end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal_SheetWorkTime);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_PositionLevel_SheetWorkTime;
begin
     if (not cbMember_andPersonal_SheetWorkTime.Checked)or(not cbMember_andPersonal_SheetWorkTime.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal_SheetWorkTime);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim(PositionLevelName) as ObjectName');
        Add('     , PositionLevelId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.PositionLevelId_pg,0)) AS PositionLevelId_pg, trim(_pgMember.PositionLevel) as PositionLevelName from dba._pgMemberSWT as _pgMember where PositionLevelName <> '+FormatToVarCharServer_notNULL('') +' group by PositionLevelName) as PositionLevel');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_PositionLevel';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then begin
                       fExecSqFromQuery('update dba._pgMemberSWT set PositionLevelId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim(PositionLevel) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
                       fExecSqFromQuery('update dba._pgStaffList set PositionLevelId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim(PositionLevel) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
                  end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal_SheetWorkTime);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_PersonalGroup_SheetWorkTime;
begin
     if (not cbMember_andPersonal_SheetWorkTime.Checked)or(not cbMember_andPersonal_SheetWorkTime.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal_SheetWorkTime);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GroupName as ObjectName');
        Add('     , 24 as inWorkHours');
        Add('     , UnitCode_all');
        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , GroupId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.GroupId_pg,0)) AS GroupId_pg, GroupName'
           +'           , '+FormatToVarCharServer_notNULL('-') + 'as Sep'
           +'           , trim(_pgMember.UnitCode_all) as UnitCode_all'
           +'           , zf_Calc_Word_bySeparate (UnitCode_all,Sep,Sep,1) as UnitCode'
           +'      from dba._pgMemberSWT as _pgMember');
        Add('      where GroupName <> '+FormatToVarCharServer_notNULL('')
           +'      group by GroupName,UnitCode_all) as GroupMember');
        Add('      left outer join dba._pgUnit on _pgUnit.ObjectCode = GroupMember.UnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_PersonalGroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inWorkHours',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inWorkHours').Value:=FieldByName('inWorkHours').AsFloat;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgMemberSWT set GroupId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where GroupName = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString)
                                 +'   and trim(UnitCode_all) = '+FormatToVarCharServer_notNULL(FieldByName('UnitCode_all').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal_SheetWorkTime);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Position;
begin
     exit;
     if (not cbMember_andPersonal.Checked)or(not cbMember_andPersonal.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , trim(PositionName) as ObjectName');
        Add('     , PositionId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.PositionId_pg,0)) AS PositionId_pg, trim(_pgMember.PositionName) as PositionName from dba._pgMember where PositionName <> '+FormatToVarCharServer_notNULL('') +' group by PositionName) as Position');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Position';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgMember set PositionId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where trim(PositionName) = '+FormatToVarCharServer_notNULL(FieldByName('ObjectName').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_PersonalGroup;
begin
     exit;
     if (not cbMember_andPersonal.Checked)or(not cbMember_andPersonal.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select 0 as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GroupName as ObjectName');
        Add('     , 24 as inWorkHours');
        Add('     , UnitCode');
        Add('     , _pgUnit.Id_Postgres as inUnitId');
        Add('     , GroupId_pg as Id_Postgres');
        Add('from (select max (isnull (_pgMember.GroupId_pg,0)) AS GroupId_pg, GroupName, UnitCode'
           +'      from dba._pgMember');
        Add('      where GroupName <> '+FormatToVarCharServer_notNULL('')
           +'      group by GroupName,UnitCode) as GroupMember');
        Add('      left outer join dba._pgUnit on _pgUnit.ObjectCode = GroupMember.UnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_PersonalGroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inWorkHours',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inWorkHours').Value:=FieldByName('inWorkHours').AsFloat;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('inUnitId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgMember set GroupId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)
                                 +' where GroupName = '+FormatToVarCharServer_notNULL(FieldByName('GroupName').AsString)
                                 +'   and UnitCode = '+FormatToVarCharServer_notNULL(FieldByName('UnitCode').AsString));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Member_andPersonal;
begin
     exit;
     if (not cbMember_andPersonal.Checked)or(not cbMember_andPersonal.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgMember.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , _pgMember.FIO as ObjectName');
        Add('     , _pgMember.DriverCertificate');
        Add('     , _pgUnit.Id_Postgres as UnitId_PG');
        Add('     , _pgMember.INN');
        Add('     , cast (null as date) as DateIn');
        Add('     , cast (null as date) as DateOut');

        Add('     , _pgMember.GroupId_pg');
        Add('     , _pgMember.PositionId_pg');
        Add('     , _pgMember.MemberId_pg as Id_Postgres');
        Add('     , _pgMember.PersonalId_pg as Id_Postgres_two');
        Add('from dba._pgMember');
        Add('     left outer join dba._pgUnit on _pgUnit.ObjectCode=_pgMember.UnitCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Member';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inINN',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inDriverCertificate',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');

        toStoredProc_two.StoredProcName:='gpinsertupdate_object_personal';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inMemberId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inPositionId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inPersonalGroupId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDateIn',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDateOut',ftDateTime,ptInput, 0);

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Member
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inINN').Value:=FieldByName('INN').AsString;
             toStoredProc.Params.ParamByName('inDriverCertificate').Value:=FieldByName('DriverCertificate').AsString;
             if not myExecToStoredProc then ;//exit;
             //Personal
             toStoredProc_two.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres_two').AsInteger;
             toStoredProc_two.Params.ParamByName('inMemberId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
             toStoredProc_two.Params.ParamByName('inPositionId').Value:=FieldByName('PositionId_pg').AsInteger;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=FieldByName('UnitId_PG').AsInteger;
             toStoredProc_two.Params.ParamByName('inPersonalGroupId').Value:=FieldByName('GroupId_pg').AsInteger;
             //toStoredProc_two.Params.ParamByName('inDateIn').Value:='01.01.2013';
             //toStoredProc_two.Params.ParamByName('inDateOut').Value:='01.01.2013';
             //toStoredProc_two.Params.ParamByName('inDateIn').Value:=FieldByName('DateIn').AsDateTime;
             //toStoredProc_two.Params.ParamByName('inDateOut').Value:=FieldByName('DateOut').AsDateTime;
             if not myExecToStoredProc_two then ;//exit;
             //

             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)or(FieldByName('Id_Postgres_two').AsInteger=0)
             then fExecSqFromQuery('update dba._pgMember set MemberId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', PersonalId_pg='+IntToStr(toStoredProc_two.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMember_andPersonal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Member_Update;
begin
     if (not cbMember_andPersonal.Checked)or(not cbMember_andPersonal.Enabled) then exit;
     //
     myEnabledCB(cbMember_andPersonal);
     //
     //!!!1. InsertUpdate Sybase
     fOpenSqToQuery (' select Object_Member.Id            AS Id'
                    +'      , Object_Member.ObjectCode    AS Code'
                    +'      , Object_Member.ValueData     AS Name'
                    +'      , ObjectString_INN.ValueData  AS INN'
                    +' from Object AS Object_Member'
                    +'      LEFT JOIN ObjectString AS ObjectString_INN on ObjectString_INN.ObjectId = Object_Member.Id'
                    +'                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()'
                    +' WHERE Object_Member.DescId = zc_Object_Member()'
                    );
     //
     with toSqlQuery do begin
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             fOpenSqFromQuery('select Id from dba._pgPersonal where Id_Postgres='+FieldByName('Id').AsString);
             // Member
             if fromSqlQuery.RecordCount=0
             then fExecSqFromQuery('insert into dba._pgPersonal(PersonalCode,PersonalName,PositionName,Id_Postgres)'
                                  +' values ('+FieldByName('Code').AsString
                                  +'        ,'+FormatToVarCharServer_notNULL(myReplaceStr(FieldByName('Name').AsString,chr(39),'`'))
                                  +'        ,'+FormatToVarCharServer_notNULL(FieldByName('INN').AsString)
                                  +'        ,'+FieldByName('Id').AsString
                                  +'        )'
                                  )
             else if fromSqlQuery.RecordCount=1
                  then fExecSqFromQuery('update dba._pgPersonal'
                                       +' set PersonalCode = '+FieldByName('Code').AsString
                                       +'    ,PersonalName = '+FormatToVarCharServer_notNULL(myReplaceStr(FieldByName('Name').AsString,chr(39),'`'))
                                       +'    ,PositionName = '+FormatToVarCharServer_notNULL(FieldByName('INN').AsString)
                                       +' where Id_Postgres = '+FieldByName('Id').AsString
                                       )
                  else ShowMessage('Error.pLoadGuide_Member_Update.Id_Postgres='+FieldByName('Id').AsString);

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     fExecSqFromQuery('update dba.Unit'
                     +'       left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID'
                     +'                                            and Information1.OKPO <> '+FormatToVarCharServer_notNULL('')
                     +'       left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id'
                     +'       left outer join dba._pgPersonal on _pgPersonal.PositionName = isnull(Information1.OKPO,Information2.OKPO)'
                     +'                                      and _pgPersonal.PositionName <> '+FormatToVarCharServer_notNULL('')
                     +' set Unit.PersonalId_Postgres = _pgPersonal.Id'
                     );
     //
     myDisabledCB(cbMember_andPersonal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_CardFuel;
begin
     if (not cbCardFuel.Checked)or(not cbCardFuel.Enabled) then exit;
     //
     myEnabledCB(cbCardFuel);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
             begin
                  Add('select _pgCardFuel.Id as ObjectId');
                  Add('     , 0 as ObjectCode');
                  Add('     , _pgCardFuel.CardFuel as ObjectName');
                  Add('     , _pgCar.CarId_pg as inCarId');
                  Add('     , Unit.Id2_Postgres as inJuridicalId');
                  Add('     , MoneyKind.Id_Postgres as inPaidKindId');
                  Add('     , case when trim(_pgCardFuel.FuelName) ='+FormatToVarCharServer_notNULL('А-92')+' then Goods_7001.Id_Postgres'
                     +'            when trim(_pgCardFuel.FuelName) ='+FormatToVarCharServer_notNULL('А-95')+' then Goods_7002.Id_Postgres'
                     +'            when trim(_pgCardFuel.FuelName) ='+FormatToVarCharServer_notNULL('ДТ')+' then Goods_7003.Id_Postgres'
                     +'       end as inGoodsId');
                  Add('     , _pgCardFuel.Limit as inLimit');
                  Add('     , _pgCardFuel.CardFuelId_pg as Id_Postgres');
                  Add('from dba._pgCardFuel');
                  Add('     left outer join dba._pgCar on _pgCar.Name = _pgCardFuel.CarName');
                  Add('     left outer join dba.Unit on Unit.UnitName = _pgCardFuel.JuridicalName');
                  Add('     left outer join dba.MoneyKind on MoneyKind.Id = _pgCardFuel.KindAccountId');
                  Add('     left outer join (select GoodsProperty.Id_Postgres from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001)as Goods_7001 on 1=1');
                  Add('     left outer join (select GoodsProperty.Id_Postgres from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7002)as Goods_7002 on 1=1');
                  Add('     left outer join (select GoodsProperty.Id_Postgres from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003)as Goods_7003 on 1=1');
                  Add('order by ObjectId');
             end;
        Open;
        cbCardFuel.Caption:='4.8. ('+IntToStr(RecordCount)+') Топливные карты';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_CardFuel';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inLimit',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inLimit').Value:=FieldByName('inLimit').AsFloat;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=0;
             toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('inCarId').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('inPaidKindId').AsInteger;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('inJuridicalId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('inGoodsId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgCardFuel set CardFuelId_pg='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbCardFuel);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_RouteSorting();
begin
     if (not cbRouteSorting.Checked)or(not cbRouteSorting.Enabled) then exit;
     //
     myEnabledCB(cbRouteSorting);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
             begin
                  Add('select Unit.Id as ObjectId');
                  Add('     , Unit.UnitCode as ObjectCode');
                  Add('     , Unit.UnitName as ObjectName');
                  Add('     , Unit.Id_Postgres_RouteSorting as Id_Postgres');
                  Add('from (select Unit.Id as RouteUnitId'
                     +'      from dba.Unit as Unit_all'
                     +'           join dba.Unit on Unit.Id = Unit_all.RouteUnitID'
                     +'      where (Unit_all.ID<>Unit_all.RouteUnitID)'
                     +'      group by Unit.Id'
                     +'     union'
                     +'      select RouteUnitId'
                     +'      from Bill'
                     +'           join dba.Unit on Unit.Id = Unit_all.RouteUnitID'
                     +'      where RouteUnitId<>0'
                     +'        and Bill.BillDate>='+FormatToDateServer_notNULL(StrToDate('01.01.2014'))
                     +'      group by RouteUnitId) as tmp'
                     +'      left join dba.Unit on Unit.Id = tmp.RouteUnitId');
                  Add('group by ObjectId');
                  Add('       , ObjectCode');
                  Add('       , ObjectName');
                  Add('       , Id_Postgres');
                  Add('order by ObjectId');

             end;
        Open;
        cbRouteSorting.Caption:='3.4. ('+IntToStr(RecordCount)+') Сортировки Маршрутов';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_RouteSorting';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres_RouteSorting='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbRouteSorting);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_PriceList;
begin
     if (not cbPriceList.Checked)or(not cbPriceList.Enabled) then exit;
     //
     myEnabledCB(cbPriceList);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select PriceList_byHistory.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , PriceList_byHistory.PriceListName as ObjectName');
        Add('     , case when PriceList_byHistory.Id = 2 then zc_rvYes() else zc_rvNo() end as zc_PriceList_Basis');
        Add('     , case when PriceList_byHistory.Id = zc_def_PriceList_onRecalcProduction() then zc_rvYes() else zc_rvNo() end as zc_PriceList_ProductionSeparate');
        Add('     , 20 as VATPercent');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , PriceList_byHistory.Erased as Erased');
        Add('     , PriceList_byHistory.Id_Postgres as Id_Postgres');
        Add('from dba.PriceList_byHistory');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_pricelist';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, FALSE);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=FALSE;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.PriceList_byHistory set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             if FieldByName('zc_PriceList_Basis').AsInteger=FieldByName('zc_rvYes').AsInteger
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_PriceList_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('zc_PriceList_ProductionSeparate').AsInteger=FieldByName('zc_rvYes').AsInteger
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_PriceList_ProductionSeparate() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbPriceList);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_PriceListItems;
begin
     if (not cbPriceListItems.Checked)or(not cbPriceListItems.Enabled) then exit;
     //
     myEnabledCB(cbPriceListItems);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select PriceListItems_byHistory.Id as ObjectId');
        Add('     , PriceList_byHistory.Id_Postgres as PriceListId_PG');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_PG');
        Add('     , case when PriceListItems_byHistory.StartDate=zc_DateStart() then '+FormatToDateServer_notNULL(StrToDate('01.01.1990'))+' else PriceListItems_byHistory.StartDate end as OperDate');
        Add('     , PriceListItems_byHistory.NewPrice as NewPrice');
        Add('     , PriceListItems_byHistory.Id_Postgres as Id_Postgres');
        Add('from dba.PriceListItems_byHistory');
        Add('     left outer join dba.PriceList_byHistory on PriceList_byHistory.Id=PriceListItems_byHistory.PriceListID');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id=PriceListItems_byHistory.GoodsPropertyId');
        Add('where PriceListItems_byHistory.StartDate<>zc_DateStart() or PriceListItems_byHistory.NewPrice<>0');
        Add('order by PriceListId_PG, GoodsId_PG, OperDate');
        Open;
        cbPriceListItems.Caption:='5.2. ('+IntToStr(RecordCount)+') Прайс листы - цены';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_ObjectHistory_PriceListItem';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inPriceListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inValue',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPriceListId').Value:=FieldByName('PriceListId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('NewPrice').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.PriceListItems_byHistory set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbPriceListItems);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsProperty;
begin
     if (not cbGoodsProperty.Checked)or(not cbGoodsProperty.Enabled) then exit;
     //
     myEnabledCB(cbGoodsProperty);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty_Postgres.Id as ObjectId');
        Add('     , GoodsProperty_Postgres.Id as ObjectCode');
        Add('     , GoodsProperty_Postgres.Name_PG as ObjectName');
        Add('     , GoodsProperty_Postgres.Id_Postgres as Id_Postgres');
        Add('from dba.GoodsProperty_Postgres');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodsproperty';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty_Postgres set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsProperty);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsPropertyValue;
begin
     if (not cbGoodsPropertyValue.Checked)or(not cbGoodsPropertyValue.Enabled) then exit;
     //
     myEnabledCB(cbGoodsPropertyValue);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty_Detail.Id as ObjectId');
        Add('     , zc_rvYes() as zc_rvYes');
        //---------------------------***1***АТБ***GoodsCodeScaner***
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id1_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is1');
        Add('     , null as ObjectName1');
        Add('     , case when is1=zc_rvNo() then cast (null as TSumm) when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)='+FormatToVarCharServer_notNULL('230365')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,13,2) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,15,2) else cast (null as TSumm) end as Amount1');
        Add('     , case when is1=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)='+FormatToVarCharServer_notNULL('230365')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,12) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)+'+FormatToVarCharServer_notNULL('0000000')+' end as BarCode1');
        Add('     , case when is1=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)='+FormatToVarCharServer_notNULL('230365')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,17,5) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,18,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,8,5) end as Article1');
        Add('     , null as BarCodeGLN1');
        Add('     , null as ArticleGLN1');
        Add('     , PG1.Id_Postgres as GoodsPropertyId1');
        Add('     , GoodsProperty.Id_Postgres as GoodsId1');
        Add('     , KindPackage.Id_Postgres as GoodsKindId1');
        Add('     , GoodsProperty_Detail.Id1_Postgres as Id_Postgres1');
        //---------------------------***2***Киев ОК***GoodsCodeScaner_byKievOK
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byKievOK)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id2_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is2');
        Add('     , null as ObjectName2');
        Add('     , cast (null as TSumm) as Amount2');
//        Add('     , CASE WHEN LENGTH(GoodsProperty_Detail.GoodsCodeScaner_byKievOK)=6 THEN '+FormatToVarCharServer_notNULL('28')+'+GoodsProperty_Detail.GoodsCodeScaner_byKievOK ELSE '+FormatToVarCharServer_notNULL('')+' END as BarCode2');
//        Add('     , CASE WHEN LENGTH(GoodsProperty_Detail.GoodsCodeScaner_byKievOK)=6 THEN '+FormatToVarCharServer_notNULL('')+' ELSE trim (GoodsProperty_Detail.GoodsCodeScaner_byKievOK) END as Article2');
        Add('     , '+FormatToVarCharServer_notNULL('28')+'+GoodsProperty_Detail.GoodsCodeScaner_byKievOK as BarCode2');
        Add('     , trim (GoodsProperty_Detail.GoodsCodeScaner_byKievOK) as Article2');
        Add('     , null as BarCodeGLN2');
        Add('     , null as ArticleGLN2');
        Add('     , PG2.Id_Postgres as GoodsPropertyId2');
        Add('     , GoodsProperty.Id_Postgres as GoodsId2');
        Add('     , KindPackage.Id_Postgres as GoodsKindId2');
        Add('     , GoodsProperty_Detail.Id2_Postgres as Id_Postgres2');
        //---------------------------***3***Метро***GoodsCodeScaner_byMetro
        Add('     , case when LENGTH(GoodsProperty_Detail.GoodsCodeScaner_byMetro)>3 or isnull(GoodsProperty_Detail.Id3_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is3');
        Add('     , null as ObjectName3');
        Add('     , case when is3=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,2) <> '+FormatToVarCharServer_notNULL('')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,2) else cast (null as TSumm) end as Amount3');
        Add('     , SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,6,13) as BarCode3');
        Add('     , case when is3=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,23,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,24,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,23,6) end'
                                                                                                   +' else case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,21,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,6) end'
           +'       end as Article3');
        Add('     , BarCode3 as BarCodeGLN3');
        Add('     , Article3 as ArticleGLN3');
        Add('     , PG3.Id_Postgres as GoodsPropertyId3');
        Add('     , GoodsProperty.Id_Postgres as GoodsId3');
        Add('     , KindPackage.Id_Postgres as GoodsKindId3');
        Add('     , GoodsProperty_Detail.Id3_Postgres as Id_Postgres3');
        //---------------------------***4***Алан***GoodsCodeScaner_byMain
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byMain)<>'+FormatToVarCharServer_notNULL('')
                        +' or trim(GoodsProperty_Detail.GoodsName_Client)<>'+FormatToVarCharServer_notNULL('')
                        +' or isnull(GoodsProperty_Detail.Id4_Postgres,0) <> 0'
                        +'  then zc_rvYes() else zc_rvNo() end as is4');
        Add('     , trim(GoodsProperty_Detail.GoodsName_Client) as ObjectName4');
        Add('     , case when is4=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.Code_byTavriya,15,2) else cast (null as TSumm) end as Amount4');
        Add('     , case when length (GoodsProperty_Detail.GoodsCodeScaner_byMain)=13 then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMain,1,13)'
           +'            when length (GoodsProperty_Detail.Code_byTavriya)>=13 then SUBSTR(GoodsProperty_Detail.Code_byTavriya,1,13)'
           +'            when length (GoodsProperty_Detail.GoodsCodeScaner_byMain)=4 then '+FormatToVarCharServer_notNULL('250')+' + GoodsProperty_Detail.GoodsCodeScaner_byMain+'+FormatToVarCharServer_notNULL('000000')
           +'            when length (GoodsProperty_Detail.GoodsCodeScaner_byMain)=5 then '+FormatToVarCharServer_notNULL('25')+' + GoodsProperty_Detail.GoodsCodeScaner_byMain+'+FormatToVarCharServer_notNULL('000000')
           +'       end as BarCode4'); // GoodsCodeScaner_byMain + Code_byTavriya
        Add('     , case when length (GoodsProperty_Detail.Code_byTavriya)>=13 and SUBSTR(GoodsProperty_Detail.Code_byTavriya,18,3)='+FormatToVarCharServer_notNULL('000')+' then SUBSTR(GoodsProperty_Detail.Code_byTavriya,21,4)'
           +'            when length (GoodsProperty_Detail.Code_byTavriya)>=13 and SUBSTR(GoodsProperty_Detail.Code_byTavriya,18,2)='+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.Code_byTavriya,20,5)'
           +'            when length (GoodsProperty_Detail.Code_byTavriya)>=13 and SUBSTR(GoodsProperty_Detail.Code_byTavriya,18,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.Code_byTavriya,19,6)'
           +'            when length (GoodsProperty_Detail.Code_byTavriya)>=13 then SUBSTR(GoodsProperty_Detail.Code_byTavriya,18,7)'
           +'            when length (GoodsProperty_Detail.GoodsCodeScaner_byMain)<=7 then GoodsProperty_Detail.GoodsCodeScaner_byMain'
           +'       end as Article4');
        Add('     , null as BarCodeGLN4');
        Add('     , null as ArticleGLN4');
        Add('     , PG4.Id_Postgres as GoodsPropertyId4');
        Add('     , GoodsProperty.Id_Postgres as GoodsId4');
        Add('     , KindPackage.Id_Postgres as GoodsKindId4');
        Add('     , GoodsProperty_Detail.Id4_Postgres as Id_Postgres4');
        //---------------------------***5***Фоззи***GoodsCodeScaner_byFozzi
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byFozzi)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id5_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is5');
        Add('     , null as ObjectName5');
        Add('     , case when is5=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,15,2) else cast (null as TSumm) end as Amount5');
        Add('     , case when is5=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,1,7)+'+FormatToVarCharServer_notNULL('000000')+' end as BarCode5');
        Add('     , case when is5=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,5)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,6)'
                                                   //+' when LENGTH (GoodsProperty_Detail.GoodsCodeScaner_byFozzi) = 24 then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,20,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,6) end'
                                                   //+' when LENGTH (GoodsProperty_Detail.GoodsCodeScaner_byFozzi) = 23 then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,6) end'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,9,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,10,5)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,9,6) end as Article5');
        Add('     , case when is5=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,1,7)+'+FormatToVarCharServer_notNULL('')+' end as BarCodeGLN5');
        Add('     , Article5 as ArticleGLN5');
        Add('     , PG5.Id_Postgres as GoodsPropertyId5');
        Add('     , GoodsProperty.Id_Postgres as GoodsId5');
        Add('     , KindPackage.Id_Postgres as GoodsKindId5');
        Add('     , GoodsProperty_Detail.Id5_Postgres as Id_Postgres5');
        //---------------------------***6***Кишени***GoodsCodeScaner_byKisheni
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byKisheni)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id6_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is6');
        Add('     , null as ObjectName6');
        Add('     , case when is6=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,2) else cast (null as TSumm) end as Amount6');
        Add('     , case when is6=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,1,13) end as BarCode6');
        Add('     , case when is6=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,18,2) = '+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,20,5)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,19,6)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,18,7)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,2)='+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,17,5)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,16,6)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,7) end as Article6');
        Add('     , BarCode6 as BarCodeGLN6');
        Add('     , Article6 as ArticleGLN6');
        Add('     , PG6.Id_Postgres as GoodsPropertyId6');
        Add('     , GoodsProperty.Id_Postgres as GoodsId6');
        Add('     , KindPackage.Id_Postgres as GoodsKindId6');
        Add('     , GoodsProperty_Detail.Id6_Postgres as Id_Postgres6');
        //---------------------------***7***Виват***GoodsCodeScaner_byVivat
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byVivat)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id7_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is7');
        Add('     , null as ObjectName7');
        Add('     , case when is7=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,2) else cast (null as TSumm) end as Amount7');
        Add('     , case when is7=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,1,13) end as BarCode7');
        Add('     , case when is7=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,18,2) = '+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,20,5)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,19,6)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,18,7)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,2)='+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,17,5)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,16,6)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,7) end as Article7');
        Add('     , BarCode7 as BarCodeGLN7');
        Add('     , Article7 as ArticleGLN7');
        Add('     , PG7.Id_Postgres as GoodsPropertyId7');
        Add('     , GoodsProperty.Id_Postgres as GoodsId7');
        Add('     , KindPackage.Id_Postgres as GoodsKindId7');
        Add('     , GoodsProperty_Detail.Id7_Postgres as Id_Postgres7');
        //---------------------------***8***Билла***GoodsCodeScaner_byBilla
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byBilla)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id8_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is8');
        Add('     , null as ObjectName8');
        Add('     , case when is8=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,15,2) else cast (null as TSumm) end as Amount8');
        Add('     , case when is8=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,1,13) end as BarCode8');
        Add('     , case when is8=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,18,2) = '+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,20,4)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,19,5)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,18,6)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,18,2)='+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,20,4)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,18,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,19,5)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byBilla,18,6) end as Article8');
        Add('     , BarCode8 as BarCodeGLN8');
        Add('     , Article8 as ArticleGLN8');
        Add('     , PG8.Id_Postgres as GoodsPropertyId8');
        Add('     , GoodsProperty.Id_Postgres as GoodsId8');
        Add('     , KindPackage.Id_Postgres as GoodsKindId8');
        Add('     , GoodsProperty_Detail.Id8_Postgres as Id_Postgres8');
        //---------------------------***9***Билла-2***Code_byBillaTwo
        Add('     , case when trim (GoodsProperty_Detail.Code_byBillaTwo)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id9_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is9');
        Add('     , null as ObjectName9');
        Add('     , case when is9=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,15,2) else cast (null as TSumm) end as Amount9');
        Add('     , case when is9=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,1,13) else SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,1,13) end as BarCode9');
        Add('     , case when is9=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,18,2) = '+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,20,4)'
                                                   +' when SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,19,5)'
                                                   +' else SUBSTR(GoodsProperty_Detail.Code_byBillaTwo,18,6) end as Article9');
        Add('     , BarCode9 as BarCodeGLN9');
        Add('     , Article9 as ArticleGLN9');
        Add('     , PG9.Id_Postgres as GoodsPropertyId9');
        Add('     , GoodsProperty.Id_Postgres as GoodsId9');
        Add('     , KindPackage.Id_Postgres as GoodsKindId9');
        Add('     , GoodsProperty_Detail.Id9_Postgres as Id_Postgres9');
        //---------------------------***10***Амстор***GoodsCodeScaner_byAmstor
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byAmstor)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id10_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is10');
        Add('     , null as ObjectName10');
        Add('     , case when is10=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,15,2) else cast (null as TSumm) end as Amount10');

        Add('     , case when is10=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,1,13) end as BarCode10');
        Add('     , case when is10=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,19,6)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,18,7) end as Article10');

        Add('     , case when is10=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,26,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAmstor,26,8) end as BarCodeGLN10');
        Add('     , Article10 as ArticleGLN10');
        Add('     , PG10.Id_Postgres as GoodsPropertyId10');
        Add('     , GoodsProperty.Id_Postgres as GoodsId10');
        Add('     , KindPackage.Id_Postgres as GoodsKindId10');
        Add('     , GoodsProperty_Detail.Id10_Postgres as Id_Postgres10');
        //---------------------------***11***Омега***GoodsCodeScaner_byOmega
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byOmega)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id11_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is11');
        Add('     , null as ObjectName11');
        Add('     , case when is11=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then cast (null as TSumm) else cast (null as TSumm) end as Amount11');

        Add('     , case when is11=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,9,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,9,13) end as BarCode11');
        Add('     , case when is11=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,1,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,2,6)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,1,7) end as Article11');

        Add('     , case when is11=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,9,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,9,7) end as BarCodeGLN11');
        Add('     , case when is11=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,23,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,24,6)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byOmega,23,7) end as ArticleGLN11');
        Add('     , PG11.Id_Postgres as GoodsPropertyId11');
        Add('     , GoodsProperty.Id_Postgres as GoodsId11');
        Add('     , KindPackage.Id_Postgres as GoodsKindId11');
        Add('     , GoodsProperty_Detail.Id11_Postgres as Id_Postgres11');
        //---------------------------***12***Амстор***GoodsCodeScaner_byVostorg
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byVostorg)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id12_Postgres,0) <> 0  then zc_rvYes() else zc_rvNo() end as is12');
        Add('     , null as ObjectName12');
        Add('     , case when is12=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,15,2) else cast (null as TSumm) end as Amount12');

        Add('     , case when is12=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,1,13) end as BarCode12');
        Add('     , case when is12=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,19,6)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,18,7) end as Article12');

        Add('     , case when is12=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,26,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVostorg,26,13) end as BarCodeGLN12');
        Add('     , Article12 as ArticleGLN12');
        Add('     , PG12.Id_Postgres as GoodsPropertyId12');
        Add('     , GoodsProperty.Id_Postgres as GoodsId12');
        Add('     , KindPackage.Id_Postgres as GoodsKindId12');
        Add('     , GoodsProperty_Detail.Id12_Postgres as Id_Postgres12');
        //---------------------------***13***Ашан***GoodsCodeScaner_byAshan
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byAshan)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id13_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is13');
        Add('     , null as ObjectName13');
        Add('     , case when is13=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,15,2) else cast (null as TSumm) end as Amount13');

        Add('     , case when is13=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,1,13) end as BarCode13');
        Add('     , case when is13=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,18,3) = '+FormatToVarCharServer_notNULL('000')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,21,4)'
                                                    +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,18,2) = '+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,20,5)'
                                                    +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,19,6)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAshan,18,7) end as Article13');

        Add('     , BarCode13 as BarCodeGLN13');
        Add('     , Article13 as ArticleGLN13');
        Add('     , PG13.Id_Postgres as GoodsPropertyId13');
        Add('     , GoodsProperty.Id_Postgres as GoodsId13');
        Add('     , KindPackage.Id_Postgres as GoodsKindId13');
        Add('     , GoodsProperty_Detail.Id13_Postgres as Id_Postgres13');
        //---------------------------***14***Реал***GoodsCodeScaner_byReal
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byReal)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id14_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is14');
        Add('     , null as ObjectName14');
        Add('     , case when is14=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,15,2) else cast (null as TSumm) end as Amount14');

        Add('     , case when is14=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,1,13) end as BarCode14');
        Add('     , case when is14=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,18,3) = '+FormatToVarCharServer_notNULL('000')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,21,4)'
                                                    +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,18,2) = '+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,20,5)'
                                                    +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,19,6)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byReal,18,7) end as Article14');

        Add('     , BarCode14 as BarCodeGLN14');
        Add('     , Article14 as ArticleGLN14');
        Add('     , PG14.Id_Postgres as GoodsPropertyId14');
        Add('     , GoodsProperty.Id_Postgres as GoodsId14');
        Add('     , KindPackage.Id_Postgres as GoodsKindId14');
        Add('     , GoodsProperty_Detail.Id14_Postgres as Id_Postgres14');
        //---------------------------***15***ЖД***GoodsName_GD
        Add('     , case when trim (GoodsProperty_Detail.GoodsName_GD)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id15_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is15');
        Add('     , trim (GoodsProperty_Detail.GoodsName_GD) as ObjectName15');
        Add('     , 0 as Amount15');

        Add('     , null as BarCode15');
        Add('     , null as Article15');

        Add('     , BarCode15 as BarCodeGLN15');
        Add('     , Article15 as ArticleGLN15');
        Add('     , PG15.Id_Postgres as GoodsPropertyId15');
        Add('     , GoodsProperty.Id_Postgres as GoodsId15');
        Add('     , KindPackage.Id_Postgres as GoodsKindId15');
        Add('     , GoodsProperty_Detail.Id15_Postgres as Id_Postgres15');
        //---------------------------***16***Таврия***Code_byTavriya
        Add('     , zc_rvNo() as is16');
        //---------------------------***17***Адвентис***GoodsCodeScaner_byAdventis
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byAdventis)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id17_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is17');
        Add('     , null as ObjectName17');
        Add('     , case when is17=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then cast (null as TSumm) else cast (null as TSumm) end as Amount17');

        Add('     , case when is17=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,8,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,8,13) end as BarCode17');
        Add('     , case when is17=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,1,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,2,5)'
                                                    +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,1,6) end as Article17');

        Add('     , case when is17=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,8,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byAdventis,8,8) end as BarCodeGLN17');
        Add('     , Article17 as ArticleGLN17');
        Add('     , PG17.Id_Postgres as GoodsPropertyId17');
        Add('     , GoodsProperty.Id_Postgres as GoodsId17');
        Add('     , KindPackage.Id_Postgres as GoodsKindId17');
        Add('     , GoodsProperty_Detail.Id17_Postgres as Id_Postgres17');
        //---------------------------***18***Край***Code_byKray
        Add('     , case when trim (GoodsProperty_Detail.Code_byKray)<>'+FormatToVarCharServer_notNULL('')+' or isnull(GoodsProperty_Detail.Id18_Postgres,0) <> 0 then zc_rvYes() else zc_rvNo() end as is18');
        Add('     , null as ObjectName18');
        Add('     , case when is18=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.Code_byKray,15,2) else cast (null as TSumm) end as Amount18');

        Add('     , case when is18=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.Code_byKray,1,13) else SUBSTR(GoodsProperty_Detail.Code_byKray,1,13) end as BarCode18');
        Add('     , case when is18=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.Code_byKray,18,1) = '+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.Code_byKray,19,5)'
                                                    +' else SUBSTR(GoodsProperty_Detail.Code_byKray,18,6) end as Article18');
        Add('     , BarCode18 as BarCodeGLN18');
        Add('     , Article18 as ArticleGLN18');
        Add('     , PG18.Id_Postgres as GoodsPropertyId18');
        Add('     , GoodsProperty.Id_Postgres as GoodsId18');
        Add('     , KindPackage.Id_Postgres as GoodsKindId18');
        Add('     , GoodsProperty_Detail.Id18_Postgres as Id_Postgres18');

        Add('from dba.GoodsProperty_Detail');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id=GoodsProperty_Detail.GoodsPropertyId');
        Add('     left outer join dba.GoodsProperty_Postgres as PG1 on PG1.Id=1');
        Add('     left outer join dba.GoodsProperty_Postgres as PG2 on PG2.Id=2');
        Add('     left outer join dba.GoodsProperty_Postgres as PG3 on PG3.Id=3');
        Add('     left outer join dba.GoodsProperty_Postgres as PG4 on PG4.Id=4');
        Add('     left outer join dba.GoodsProperty_Postgres as PG5 on PG5.Id=5');
        Add('     left outer join dba.GoodsProperty_Postgres as PG6 on PG6.Id=6');
        Add('     left outer join dba.GoodsProperty_Postgres as PG7 on PG7.Id=7');
        Add('     left outer join dba.GoodsProperty_Postgres as PG8 on PG8.Id=8');
        Add('     left outer join dba.GoodsProperty_Postgres as PG9 on PG9.Id=9');
        Add('     left outer join dba.GoodsProperty_Postgres as PG10 on PG10.Id=10');
        Add('     left outer join dba.GoodsProperty_Postgres as PG11 on PG11.Id=11');
        Add('     left outer join dba.GoodsProperty_Postgres as PG12 on PG12.Id=12');
        Add('     left outer join dba.GoodsProperty_Postgres as PG13 on PG13.Id=13');
        Add('     left outer join dba.GoodsProperty_Postgres as PG14 on PG14.Id=14');
        Add('     left outer join dba.GoodsProperty_Postgres as PG15 on PG15.Id=15');
        Add('     left outer join dba.GoodsProperty_Postgres as PG16 on PG16.Id=16');
        Add('     left outer join dba.GoodsProperty_Postgres as PG17 on PG17.Id=17');
        Add('     left outer join dba.GoodsProperty_Postgres as PG18 on PG18.Id=18');

        //Add('     left outer join dba.KindPackage on KindPackage.Id=GoodsProperty_Detail.KindPackageId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = GoodsProperty_Detail.KindPackageId');
        Add('                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА

        //        Add('where is4=zc_rvYes()'
        Add('where (KindPackage.Id_Postgres is not null or trim (GoodsProperty_Detail.GoodsName_Client)<> '+FormatToVarCharServer_notNULL('')+' or trim (GoodsProperty_Detail.GoodsName_GD)<> '+FormatToVarCharServer_notNULL('')
             +'    )'
             +' and(is1=zc_rvYes()'
             +' or is2=zc_rvYes()'
             +' or is3=zc_rvYes()'
             +' or is4=zc_rvYes()'
             +' or is5=zc_rvYes()'
             +' or is6=zc_rvYes()'
             +' or is7=zc_rvYes()'
             +' or is8=zc_rvYes()'
             +' or is9=zc_rvYes()'
             +' or is10=zc_rvYes()'
             +' or is11=zc_rvYes()'
             +' or is12=zc_rvYes()'
             +' or is13=zc_rvYes()'
             +' or is14=zc_rvYes()'
             +' or is15=zc_rvYes()'
             +' or is16=zc_rvYes()'
             +' or is17=zc_rvYes()'
             +' or is18=zc_rvYes()'
             +'   )'
           );
        Add('order by is7, BarCode7, ObjectId');
        Open;
        cbGoodsPropertyValue.Caption:='6.2. ('+IntToStr(RecordCount)+') Значения свойств товаров для классификатора';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodspropertyvalue';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inBarCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inArticle',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inBarCodeGLN',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inArticleGLN',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsPropertyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             // 1
             if FieldByName('is1').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres1').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName1').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount1').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode1').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article1').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN1').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN1').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId1').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId1').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId1').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres1').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 2
             if FieldByName('is2').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres2').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName2').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount2').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode2').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article2').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN2').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN2').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId2').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId2').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId2').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres2').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id2_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 3
             if FieldByName('is3').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres3').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName3').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount3').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode3').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article3').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN3').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN3').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId3').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId3').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId3').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres3').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 4
             if FieldByName('is4').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres4').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName4').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount4').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode4').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article4').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN4').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN4').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId4').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId4').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId4').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres4').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id4_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 5
             if FieldByName('is5').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres5').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName5').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount5').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode5').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article5').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN5').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN5').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId5').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId5').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId5').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres5').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id5_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 6
             if FieldByName('is6').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres6').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName6').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount6').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode6').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article6').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN6').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN6').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId6').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId6').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId6').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres6').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id6_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 7
             if FieldByName('is7').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres7').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName7').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount7').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode7').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article7').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN7').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN7').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId7').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId7').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId7').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres7').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id7_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 8
             if FieldByName('is8').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres8').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName8').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount8').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode8').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article8').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN8').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN8').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId8').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId8').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId8').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres8').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id8_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 9
             if FieldByName('is9').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres9').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName9').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount9').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode9').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article9').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN9').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN9').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId9').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId9').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId9').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres9').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id9_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 10
             if FieldByName('is10').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres10').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName10').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount10').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode10').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article10').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN10').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN10').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId10').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId10').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId10').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres10').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id10_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 11
             if FieldByName('is11').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres11').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName11').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount11').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode11').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article11').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN11').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN11').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId11').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId11').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId11').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres11').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id11_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 12
             if FieldByName('is12').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres12').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName12').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount12').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode12').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article12').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN12').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN12').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId12').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId12').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId12').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres12').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id12_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 13
             if FieldByName('is13').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres13').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName13').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount13').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode13').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article13').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN13').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN13').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId13').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId13').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId13').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres13').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id13_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 14
             if FieldByName('is14').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres14').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName14').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount14').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode14').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article14').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN14').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN14').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId14').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId14').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId14').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres14').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id14_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 15
             if FieldByName('is15').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres15').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName15').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount15').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode15').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article15').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN15').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN15').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId15').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId15').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId15').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres15').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id15_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 16
             if FieldByName('is16').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres16').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName16').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount16').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode16').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article16').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN16').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN16').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId16').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId16').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId16').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres16').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id16_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 17
             if FieldByName('is17').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres17').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName17').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount17').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode17').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article17').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN17').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN17').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId17').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId17').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId17').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres17').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id17_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 18
             if FieldByName('is18').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres18').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName18').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount18').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode18').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article18').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN18').AsString;
                       toStoredProc.Params.ParamByName('inArticleGLN').Value:=FieldByName('ArticleGLN18').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId18').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId18').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId18').AsInteger;
                       //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres18').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id18_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbGoodsPropertyValue);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_InfoMoneyGroup;
begin
     if (not cbInfoMoneyGroup.Checked)or(not cbInfoMoneyGroup.Enabled) then exit;
     //
     myEnabledCB(cbInfoMoneyGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select max(Id) as ObjectId');
        Add('     , min(_pgInfoMoney.ObjectCode) - 101 as ObjectCode');
        Add('     , _pgInfoMoney.Name1 as ObjectName');
        Add('     , max (isnull (_pgInfoMoney.Id1_Postgres, 0)) as Id_Postgres');
        Add('from dba._pgInfoMoney');
        Add('group by ObjectName');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_infomoneygroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgInfoMoney set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Name1 in (select Name1 from dba._pgInfoMoney where Id = '+FieldByName('ObjectId').AsString+')');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbInfoMoneyGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_InfoMoneyDestination;
begin
     if (not cbInfoMoneyDestination.Checked)or(not cbInfoMoneyDestination.Enabled) then exit;
     //
     myEnabledCB(cbInfoMoneyDestination);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select max(Id) as ObjectId');
        Add('     , min(_pgInfoMoney.ObjectCode) - 1 as ObjectCode');
        Add('     , _pgInfoMoney.Name2 as ObjectName');
        Add('     , max (isnull (_pgInfoMoney.Id2_Postgres, 0)) as Id_Postgres');
        Add('from dba._pgInfoMoney');
        Add('group by ObjectName, _pgInfoMoney.Name1');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_infomoneydestination';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgInfoMoney set Id2_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Name1 in (select Name1 from dba._pgInfoMoney where Id = '+FieldByName('ObjectId').AsString+')'
                                                                                                                                      +'   and Name2 in (select Name2 from dba._pgInfoMoney where Id = '+FieldByName('ObjectId').AsString+')'
                                  );
             //
             if FieldByName('ObjectCode').AsInteger=21300 // Незавершенное производство
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_InfoMoneyDestination_WorkProgress() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbInfoMoneyDestination);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_InfoMoney;
begin
     if (not cbInfoMoney.Checked)or(not cbInfoMoney.Enabled) then exit;
     //
     myEnabledCB(cbInfoMoney);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgInfoMoney.Id as ObjectId');
        Add('     , _pgInfoMoney.ObjectCode as ObjectCode');
        Add('     , _pgInfoMoney.Name3 as ObjectName');
        Add('     , _pgInfoMoney.Id1_Postgres as InfoMoneyGroupId_PG');
        Add('     , _pgInfoMoney.Id2_Postgres as InfoMoneyDestinationId_PG');
        Add('     , _pgInfoMoney.Id3_Postgres as Id_Postgres');
        Add('from dba._pgInfoMoney');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_infomoney';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInfoMoneyGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyDestinationId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inInfoMoneyGroupId').Value:=FieldByName('InfoMoneyGroupId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyDestinationId').Value:=FieldByName('InfoMoneyDestinationId_PG').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgInfoMoney set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbInfoMoney);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_AccountGroup;
begin
     if (not cbAccountGroup.Checked)or(not cbAccountGroup.Enabled) then exit;
     //
     myEnabledCB(cbAccountGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select max(Id) as ObjectId');
        Add('     , min(_pgAccount.ObjectCode) - 101 as ObjectCode');
        Add('     , _pgAccount.Name1 as ObjectName');
        Add('     , max (isnull (_pgAccount.Id1_Postgres, 0)) as Id_Postgres');
        Add('from dba._pgAccount');
        Add('group by ObjectName');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_accountgroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgAccount set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Name1 in (select Name1 from dba._pgAccount where Id = '+FieldByName('ObjectId').AsString+')');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbAccountGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_AccountDirection;
begin
     if (not cbAccountDirection.Checked)or(not cbAccountDirection.Enabled) then exit;
     //
     myEnabledCB(cbAccountDirection);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select max(Id) as ObjectId');
        Add('     , min(_pgAccount.ObjectCode) - 1 as ObjectCode');
        Add('     , _pgAccount.Name2 as ObjectName');
        Add('     , max (isnull (_pgAccount.Id2_Postgres, 0)) as Id_Postgres');
        Add('from dba._pgAccount');
        Add('group by ObjectName, _pgAccount.Name1');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_accountdirection';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgAccount set Id2_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Name1 in (select Name1 from dba._pgAccount where Id = '+FieldByName('ObjectId').AsString+')'
                                                                                                                                    +'   and Name2 in (select Name2 from dba._pgAccount where Id = '+FieldByName('ObjectId').AsString+')'
                                  );
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbAccountDirection);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Account;
begin
     if (not cbAccount.Checked)or(not cbAccount.Enabled) then exit;
     //
     myEnabledCB(cbAccount);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgAccount.Id as ObjectId');
        Add('     , _pgAccount.ObjectCode as ObjectCode');
        Add('     , _pgAccount.Name3 as ObjectName');
        Add('     , _pgAccount.Id1_Postgres as AccountGroupId_PG');
        Add('     , _pgAccount.Id2_Postgres as AccountDirectionId_PG');
        Add('     , isnull(_pgInfoMoney_30201.Id2_Postgres, (select max (isnull (_pgInfoMoney.Id2_Postgres, 0)) from dba._pgInfoMoney where _pgInfoMoney.ObjectCode <> 30201 and _pgInfoMoney.Name2 = _pgAccount.Name3)) as InfoMoneyDestinationId_PG');
        Add('     , case when 1=1 then null when InfoMoneyDestinationId_PG is not null then null else (select max (isnull (_pgInfoMoney.Id3_Postgres, 0)) from dba._pgInfoMoney where _pgInfoMoney.Name3 = _pgAccount.Name3) end as InfoMoneyId_PG');
        Add('     , case when 1=1 then _pgAccount.Id3_Postgres else ObjectId end as Id_Postgres');
        Add('from dba._pgAccount');
        Add('     left outer join dba._pgInfoMoney as _pgInfoMoney_30201 on _pgInfoMoney_30201.ObjectCode = 30201 and _pgAccount.ObjectCode = 30101');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_account';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAccountGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAccountDirectionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyDestinationId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inAccountGroupId').Value:=FieldByName('AccountGroupId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inAccountDirectionId').Value:=FieldByName('AccountDirectionId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyDestinationId').Value:=FieldByName('InfoMoneyDestinationId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_PG').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgAccount set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbAccount);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ProfitLossGroup;
begin
     if (not cbProfitLossGroup.Checked)or(not cbProfitLossGroup.Enabled) then exit;
     //
     myEnabledCB(cbProfitLossGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select max(Id) as ObjectId');
        Add('     , min(_pgProfitLoss.ObjectCode) - 101 as ObjectCode');
        Add('     , _pgProfitLoss.Name1 as ObjectName');
        Add('     , max (isnull (_pgProfitLoss.Id1_Postgres, 0)) as Id_Postgres');
        Add('from dba._pgProfitLoss');
        Add('group by ObjectName');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_profitlossgroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgProfitLoss set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Name1 in (select Name1 from dba._pgProfitLoss where Id = '+FieldByName('ObjectId').AsString+')');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbProfitLossGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ProfitLossDirection;
begin
     if (not cbProfitLossDirection.Checked)or(not cbProfitLossDirection.Enabled) then exit;
     //
     myEnabledCB(cbProfitLossDirection);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select max(Id) as ObjectId');
        Add('     , min(_pgProfitLoss.ObjectCode) - 1 as ObjectCode');
        Add('     , _pgProfitLoss.Name2 as ObjectName');
        Add('     , max (isnull (_pgProfitLoss.Id2_Postgres, 0)) as Id_Postgres');
        Add('from dba._pgProfitLoss');
        Add('group by ObjectName, _pgProfitLoss.Name1');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_profitlossdirection';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgProfitLoss set Id2_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Name1 in (select Name1 from dba._pgProfitLoss where Id = '+FieldByName('ObjectId').AsString+')'
                                                                                                                                       +'   and Name2 in (select Name2 from dba._pgProfitLoss where Id = '+FieldByName('ObjectId').AsString+')'
                                  );
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbProfitLossDirection);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_ProfitLoss;
begin
     if (not cbProfitLoss.Checked)or(not cbProfitLoss.Enabled) then exit;
     //
     myEnabledCB(cbProfitLoss);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgProfitLoss.Id as ObjectId');
        Add('     , _pgProfitLoss.ObjectCode as ObjectCode');
        Add('     , _pgProfitLoss.Name3 as ObjectName');
        Add('     , _pgProfitLoss.Id1_Postgres as ProfitLossGroupId_PG');
        Add('     , _pgProfitLoss.Id2_Postgres as ProfitLossDirectionId_PG');
        Add('     , case when _pgProfitLoss.ObjectCode < 20000 then null ' + ' else isnull(_pgInfoMoney_30201.Id2_Postgres, (select max (isnull (_pgInfoMoney.Id2_Postgres, 0)) from dba._pgInfoMoney where _pgInfoMoney.ObjectCode <> 30201 and _pgInfoMoney.Name2 = _pgProfitLoss.Name3)) end as InfoMoneyDestinationId_PG');
        Add('     , case when _pgProfitLoss.ObjectCode < 20000 then null ' + ' else case when InfoMoneyDestinationId_PG is not null then null else (select max (isnull (_pgInfoMoney.Id3_Postgres, 0)) from dba._pgInfoMoney where _pgInfoMoney.Name3 = _pgProfitLoss.Name3) end end as InfoMoneyId_PG');
        Add('     , case when 1=1 then _pgProfitLoss.Id3_Postgres else ObjectId end as Id_Postgres');
        Add('from dba._pgProfitLoss');
        Add('     left outer join dba._pgInfoMoney as _pgInfoMoney_30201 on _pgInfoMoney_30201.ObjectCode = 30201 and _pgProfitLoss.ObjectCode = 70304');
        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_profitloss';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inProfitLossGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inProfitLossDirectionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyDestinationId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inProfitLossGroupId').Value:=FieldByName('ProfitLossGroupId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inProfitLossDirectionId').Value:=FieldByName('ProfitLossDirectionId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyDestinationId').Value:=FieldByName('InfoMoneyDestinationId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_PG').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba._pgProfitLoss set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbProfitLoss);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pInsertHistoryCost;
var calcStartDate,calcEndDate:TDateTime;
    Year, Month, Day: Word;
begin
     if (not cbInsertHistoryCost.Checked)or(not cbInsertHistoryCost.Enabled) then exit;
     //
     myEnabledCB(cbInsertHistoryCost);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateCompleteEdit.Text);
        DecodeDate(calcStartDate, Year, Month, Day);
        if Month=12 then begin Year:=Year+1;Month:=0;end;
        calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        while calcStartDate <= StrToDate(EndDateCompleteEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateCompleteEdit.Text)
             then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate')
             else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate');
             //
             calcStartDate:=calcEndDate+1;
             DecodeDate(calcStartDate, Year, Month, Day);
             if Month=12 then begin Year:=Year+1;Month:=0;end;
             calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        end;
        Add('order by StartDate, EndDate');
        Open;
        //
        Application.ProcessMessages;
        Application.ProcessMessages;
        Application.ProcessMessages;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_HistoryCost';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inItearationCount',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInsert',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiffSumm',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc.Params.ParamByName('inEndDate').Value:=FieldByName('EndDate').AsDateTime;
             toStoredProc.Params.ParamByName('inItearationCount').Value:=800;
             toStoredProc.Params.ParamByName('inInsert').Value:=12345;//захардкодил
             toStoredProc.Params.ParamByName('inDiffSumm').Value:=0.009;
             if not myExecToStoredProc then ;//exit;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbInsertHistoryCost);
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Income(isLastComplete:Boolean);
begin
     if (not cbCompleteIncome.Checked)or(not cbCompleteIncome.Enabled) then exit;
     //
     myEnabledCB(cbCompleteIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as InfoMoneyCode');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.Id as ObjectId');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           +'                      from dba.Bill'
           +'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems_find.GoodsPropertyId'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                        and Bill.BillKind=zc_bkIncomeToUnit()'
           +'                        and Bill.Id_Postgres>0'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as UnitFrom on UnitFrom.ID = Bill.FromID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and Id_Postgres >0'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by InfoMoneyCode,OperDate,ObjectId');
        Open;

        cbCompleteIncome.Caption:='1.1. ('+IntToStr(RecordCount)+') Приход от поставщика';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Income';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteIncome);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Income:Integer;
var JuridicalId_pg,PartnerId_pg,ContractId_pg:Integer;
begin
       Result:=0;
     if (not cbIncome.Checked)or(not cbIncome.Enabled) then exit;
     //
     myEnabledCB(cbIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');

        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when OKPO='+FormatToVarCharServer_notNULL('')+' or ToId_Postgres is null'
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when OKPO='+FormatToVarCharServer_notNULL('')+' then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName||'+FormatToVarCharServer_notNULL('(')+'||OKPO||'+FormatToVarCharServer_notNULL(')')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , Bill.BillDate as OperDate');
        Add('     , UnitFrom.UnitName as UnitNameFrom');
        Add('     , OperDate as OperDatePartner');
        Add('     , null as InvNumberPartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

//        Add('     , UnitFrom.Id3_Postgres as FromId_Postgres');
        Add('     , _pgUnit.Id_Postgres as ToId_Postgres');
        Add('     , MoneyKind.Id_Postgres as PaidKindId_Postgres');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as CodeIM');
        Add('     , _pgInfoMoney.Id3_Postgres as InfoMoneyId_pg');
        Add('     , null as PersonalPackerId');
        Add('     , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO');
        Add('     , Bill.FromId, Bill.ToId');
        Add('     , Bill_findInfoMoney.findId');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           +'                            ,max(isnull(BillItems_find.Id,0))as findId'
           +'                      from dba.Bill'
           +'                           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0'
           +'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems_find.GoodsPropertyId'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'                         and Bill.BillKind=zc_bkIncomeToUnit()'
           +'                         and Bill.MoneyKindId = zc_mkBN()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = Bill_findInfoMoney.InfoMoneyCode');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id=Bill.ToId');
        Add('     left outer join dba._pgUnit on _pgUnit.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and Bill.ToId<>4927'//СКЛАД ПЕРЕПАК
           +'  and Bill.FromId not in (3830, 3304)' //КРОТОН ООО (хранение) + КРОТОН ООО
           +'  and Bill.ToId not in (3830, 3304)'  // КРОТОН ООО (хранение) + КРОТОН ООО
//           +'  and Bill.FromId<>4928'//ФОЗЗИ-ПЕРЕПАК ПРОДУКЦИИ
//           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkBN()'
//+'  and Bill.Id=1383229'
//+'  and Bill.BillNumber=18733'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbIncome.Caption:='1.1. ('+IntToStr(RecordCount)+') Приход от поставщика';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalPackerId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_Object_Partner_Sybase';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inGLNCode',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inPrepareDayCount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDocumentDayCount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inPersonalTakeId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             PartnerId_pg:=0;
             JuridicalId_pg:=0;
             ContractId_pg:=0;
             //Сначала находим контрагента  и юр.лицо
             fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                           +' from ObjectHistory_JuridicalDetails_View'
                           +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                           +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                           +' where OKPO='+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)
                           +'   and '+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)+'<>'+FormatToVarCharServer_notNULL('')
                           );
             PartnerId_pg:=toSqlQuery.FieldByName('PartnerId').AsInteger;
             JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //
             //создаем контрагента !!!если надо!!!
             if (PartnerId_pg=0)and(JuridicalId_pg<>0) then
             begin
                  toStoredProc_two.Params.ParamByName('ioId').Value:=0;
                  toStoredProc_two.Params.ParamByName('inCode').Value:=0;
                  toStoredProc_two.Params.ParamByName('inName').Value:=FieldByName('UnitNameFrom').AsString;
                  toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
                  //
                  if not myExecToStoredProc_two then ;//exit;
                  //
                  PartnerId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
             end;
             //

             // !!!не меняем договор!!! если в документе установили "свой" договор, и он не "закрыт" и не "удален"
             if (not cbUpdateConrtact.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery (' select MovementLinkObject.ObjectId as ContractId'
                                 +' from MovementLinkObject'
                                 +'      join Object_Contract_View on Object_Contract_View.ContractId = MovementLinkObject.ObjectId'
                                 +'                               and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'                               and Object_Contract_View.isErased = FALSE'
                                 +' where MovementLinkObject.MovementId='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 +'   and MovementLinkObject.DescId=zc_MovementLinkObject_Contract()'
                                 );
                  if toSqlQuery.FieldByName('ContractId').AsInteger<>0
                  then ContractId_pg:=toSqlQuery.FieldByName('ContractId').AsInteger
                  else //находим договор
                       ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,FieldByName('OperDate').AsDateTime);
             end
             else //находим договор
                  ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,FieldByName('OperDate').AsDateTime);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if JuridicalId_pg=0 then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка-от кого:'+FieldByName('UnitNameFrom').AsString
                                 else if (ContractId_pg=0)and(FieldByName('findId').AsInteger<>0)
                                      then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка--договор:???'
                                      else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString;

             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('InvNumberPartner').AsString;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=PartnerId_pg;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inPersonalPackerId').Value:=FieldByName('PersonalPackerId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncome);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Income(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbIncome.Checked)or(not cbIncome.Enabled) then exit;
     //
     myEnabledCB(cbIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , BillItems.OperCount as Amount');
        Add('     , Amount as AmountPartner');
        Add('     , 0 as AmountPacker');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_Upakovka as LiveWeight');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , null as AssetId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
//        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
//           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbIncome.Caption:='1.1. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Приход от поставщика';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPacker',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inLiveWeight',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPacker').Value:=FieldByName('AmountPacker').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncome);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_IncomePacker:Integer;
begin
     Result:=0;
     if (not cbIncomePacker.Checked)or(not cbIncomePacker.Enabled) then exit;
     //
     myEnabledCB(cbIncomePacker);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , isnull (Bill_PartionStr_MB.BillNumber, Bill.BillNumber) as InvNumber');
        Add('     , isnull (Bill_PartionStr_MB.BillDate, Bill.BillDate) as OperDate');

        Add('     , OperDate as OperDatePartner');
        Add('     , null as InvNumberPartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , isnull(UnitFrom_PartionStr_MB.Id3_Postgres,_pgPersonal.Id2_Postgres) as FromId_Postgres');
        Add('     , _pgUnit.Id_Postgres as ToId_Postgres');
        Add('     , MoneyKind.Id_Postgres as PaidKindId_Postgres');
        Add('     , null as ContractId');
        Add('     , null as CarId');
        Add('     , null as PersonalDriverId');
        Add('     , case when Bill_PartionStr_MB.Id is not null then _pgPersonal.Id2_Postgres else null end as PersonalPackerId');

        Add('     , isnull(Bill_PartionStr_MB.Id_Postgres,Bill.Id_Postgres) as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba._pgPersonal on _pgPersonal.Id = UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba.Bill as Bill_PartionStr_MB on Bill_PartionStr_MB.Id = lfGet_BillId_byPartionStr_MB_isPG(Bill.Id)');
        Add('     left outer join dba.Unit as UnitFrom_PartionStr_MB on UnitFrom_PartionStr_MB.Id=Bill_PartionStr_MB.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id=Bill.ToId');
        Add('     left outer join dba._pgUnit on _pgUnit.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and UnitFrom.PersonalId_Postgres is not null'
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbIncomePacker.Caption:='1.2. ('+IntToStr(RecordCount)+') Приход от заготовителя';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalPackerId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('InvNumberPartner').AsString;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=FieldByName('ContractId').AsInteger;
             toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalPackerId').Value:=FieldByName('PersonalPackerId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and isnull(Id_Postgres,0)<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncomePacker);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_IncomePacker(SaveCount:Integer);
begin
     if (not cbIncomePacker.Checked)or(not cbIncomePacker.Enabled) then exit;
     //
     myEnabledCB(cbIncomePacker);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , isnull (Bill_PartionStr_MB.Id_Postgres, Bill.Id_Postgres) as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , case when Bill_PartionStr_MB.Id is null then BillItems.OperCount else 0 end as Amount');
        Add('     , Amount as AmountPartner');
        Add('     , case when Bill_PartionStr_MB.Id is not null then BillItems.OperCount else 0 end as AmountPacker');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_Upakovka as LiveWeight');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , null as AssetId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Bill as Bill_PartionStr_MB on Bill_PartionStr_MB.Id = lfGet_BillId_byPartionStr_MB_isPG(Bill.Id)');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and UnitFrom.PersonalId_Postgres is not null'
           +'  and BillItems.Id is not null'
// +'  and BillItems.BillId =1164656'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbIncomePacker.Caption:='1.2. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Приход от заготовителя';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPacker',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inLiveWeight',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPacker').Value:=FieldByName('AmountPacker').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncomePacker);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Send(isLastComplete:Boolean);
begin
     if (not cbCompleteSend.Checked)or(not cbCompleteSend.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSend);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId'
           +'                                              and UnitFrom.ParentId<>4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId'
           +'                                            and UnitTo.ParentId<>4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres'
           +'                                                      and UnitFrom.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres'
           +'                                                      and UnitTo.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and (isUnitFrom.UnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (isUnitTo.UnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (UnitFrom.pgUnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (UnitTo.pgUnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (pgUnitFrom.Id_Postgres_Branch is null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (pgUnitTo.Id_Postgres_Branch is null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and Id_Postgres >0'
           );
        Add('  and FromId_Postgres <> 0');
        Add('  and ToId_Postgres <> 0');

        Add('order by OperDate,ObjectId');
        Open;
        cbCompleteSend.Caption:='2.1. ('+IntToStr(RecordCount)+') Перемещение';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Send';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if cbComplete.Checked then
             begin
                  // проверка что он проведется
                  if (FieldByName('FromId_Postgres').AsInteger>0)and(FieldByName('ToId_Postgres').AsInteger>0) then
                  begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteSend);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_SendUnit:Integer;
begin
     Result:=0;
     if (not cbSendUnit.Checked)or(not cbSendUnit.Enabled) then exit;
     //
     myEnabledCB(cbSendUnit);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber || case when (pgUnitFrom.Id is null and pgPersonalFrom.Id is null)'
           +'                                 or (pgUnitTo.Id is null and pgPersonalTo.Id is null)'
           +'                                    then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when pgUnitFrom.Id is null and pgPersonalFrom.Id is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' От Кого:')+'|| UnitFrom.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when pgUnitTo.Id is null and pgPersonalTo.Id is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' Кому:')+'|| UnitTo.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'       as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId'
           +'                                              and UnitFrom.ParentId<>4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId'
           +'                                            and UnitTo.ParentId<>4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres'
//           +'                                                      and pgPersonalFrom.Id2_Postgres>0'
           +'                                                      and UnitFrom.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres'
//           +'                                                      and pgPersonalTo.Id2_Postgres>0'
           +'                                                      and UnitTo.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +' and Bill.Id_Postgres=22081'
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and (isUnitFrom.UnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (isUnitTo.UnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (UnitFrom.pgUnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (UnitTo.pgUnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (pgUnitFrom.Id_Postgres_Branch is null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (pgUnitTo.Id_Postgres_Branch is null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbSendUnit.Caption:='2.1. ('+IntToStr(RecordCount)+') Перемещение с подразделениями';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_send';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSendUnit);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_SendUnit(SaveCount:Integer);
begin
     if (not cbSendUnit.Checked)or(not cbSendUnit.Enabled) then exit;
     //
     myEnabledCB(cbSendUnit);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , -BillItems.OperCount as Amount');
        Add('     , BillItems.OperCount_Upakovka as inCount');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , zc_DateStart() AS PartionGoodsDate');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , 0 as AssetId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
//        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
//        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and (isUnitFrom.UnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (isUnitTo.UnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (UnitFrom.pgUnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (UnitTo.pgUnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (pgUnitFrom.Id_Postgres_Branch is null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
//           +'  and (pgUnitTo.Id_Postgres_Branch is null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbSendUnit.Caption:='2.1. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Перемещение с подразделениями';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_send';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inStorageId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             if FieldByName('PartionGoodsDate').AsDateTime <= StrToDate('01.01.1900')
             then toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=StrToDate('01.01.1900')
             else toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=FieldByName('PartionGoodsDate').AsDateTime;
             toStoredProc.Params.ParamByName('inCount').Value:=FieldByName('inCount').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=0;
             toStoredProc.Params.ParamByName('inStorageId').Value:=0;
             toStoredProc.Params.ParamByName('inPartionGoodsId').Value:=0;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSendUnit);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_SendOnPrice(isLastComplete:Boolean);
begin
     if (not cbCompleteSendOnPrice.Checked)or(not cbCompleteSendOnPrice.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSendOnPrice);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres'
           +'                                                      and pgPersonalFrom.Id2_Postgres>0'
           +'                                                      and UnitFrom.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres'
           +'                                                      and pgPersonalTo.Id2_Postgres>0'
           +'                                                      and UnitTo.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and Id_Postgres >0'

           +' AND (('
           +'      isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'  and isnull(UnitTo.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ

           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and UnitTo.pgUnitId is null'
           +'    and UnitTo.PersonalId_Postgres is not null)'

           +'    or (UnitTo.pgUnitId is not null'
           +'    and UnitFrom.pgUnitId is null'
           +'    and UnitFrom.PersonalId_Postgres is not null))'

           +'  and pgUnitFrom.Id_Postgres_Branch is null'
           +'  and pgUnitTo.Id_Postgres_Branch is null'
           +'  )'
           );
        Add(
            '  OR ('

           +'      not ('
           +'      (UnitFrom.pgUnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (UnitTo.pgUnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (pgUnitFrom.Id_Postgres_Branch is null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (pgUnitTo.Id_Postgres_Branch is null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'          )'

           +'  and not ('
           +'      isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'  and isnull(UnitTo.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ

           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and UnitTo.pgUnitId is null'
           +'    and UnitTo.PersonalId_Postgres is not null)'

           +'    or (UnitTo.pgUnitId is not null'
           +'    and UnitFrom.pgUnitId is null'
           +'    and UnitFrom.PersonalId_Postgres is not null))'

           +'  and pgUnitFrom.Id_Postgres_Branch is null'
           +'  and pgUnitTo.Id_Postgres_Branch is null'
           +'          )'

           +'  and not ('
           +'       ((UnitFrom.pgUnitId is not null'
           +'     or UnitFrom.PersonalId_Postgres is not null'
           +'     or pgUnitFrom.Id_Postgres_Branch is not null)'
           +'    and (UnitTo.pgUnitId is null'
           +'     and UnitTo.PersonalId_Postgres is null'
           +'     and pgUnitTo.Id_Postgres_Branch is null))'
           +'          )'
           +'  and not ('
           +'       ((UnitTo.pgUnitId is not null'
           +'     or UnitTo.PersonalId_Postgres is not null'
           +'     or pgUnitTo.Id_Postgres_Branch is not null)'
           +'    and (UnitFrom.pgUnitId is null'
           +'     and UnitFrom.PersonalId_Postgres is null'
           +'     and pgUnitFrom.Id_Postgres_Branch is null))'
           +'          )'
           +'  ))'

           );
        Add('order by OperDate,ObjectId');
        Open;
        cbCompleteSendOnPrice.Caption:='2.2. ('+IntToStr(RecordCount)+') Перемещение по цене';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_SendOnPrice';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if cbComplete.Checked then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteSendOnPrice);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_SendPersonal:Integer;
begin
     Result:=0;
     if (not cbSendPersonal.Checked)or(not cbSendPersonal.Enabled) then exit;
     //
     myEnabledCB(cbSendPersonal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');

        Add('     , OperDate as OperDatePartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , isnull(pgUnitFrom.Id_Postgres,pgPersonalFrom.Id2_Postgres) as FromId_Postgres');
        Add('     , isnull(pgUnitTo.Id_Postgres,pgPersonalTo.Id2_Postgres) as ToId_Postgres');
        Add('     , null as CarId');
        Add('     , null as PersonalDriverId');

        Add('     , null as RouteId');
        Add('     , case when isnull(Bill.RouteUnitId,0) = Bill.ToId then ToId_Postgres else Unit_RouteSorting.Id_Postgres_RouteSorting end as RouteSortingId_Postgres');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('     left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId');
        Add('     left outer join dba._pgPersonal on _pgPersonal.Id = Unit_RouteSorting.PersonalId_Postgres');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
// +' and Bill.Id = 1260716'
           +'  and isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'  and isnull(UnitTo.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ

           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and UnitTo.pgUnitId is null'
           +'    and UnitTo.PersonalId_Postgres is not null)'

           +'    or (UnitTo.pgUnitId is not null'
           +'    and UnitFrom.pgUnitId is null'
           +'    and UnitFrom.PersonalId_Postgres is not null))'

           +'  and pgUnitFrom.Id_Postgres_Branch is null'
           +'  and pgUnitTo.Id_Postgres_Branch is null'
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbSendPersonal.Caption:='2.2. ('+IntToStr(RecordCount)+') Перемещение с экспедиторами';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_sendonprice';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);

        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;

             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('RouteSortingId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSendPersonal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_SendPersonal(SaveCount:Integer);
begin
     if (not cbSendPersonal.Checked)or(not cbSendPersonal.Enabled) then exit;
     //
     myEnabledCB(cbSendPersonal);
     //
     fExecSqFromQuery('call dba._pgInsertClient_byScaleDiscountWeight ('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))+')');
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , case when isnull(tmpBI_byDiscountWeight.DiscountWeight,0)<>0'
           +'               then -1 * BillItems.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'            else -1 * BillItems.OperCount'
           +'       end as Amount');
        Add('     , -1 * BillItems.OperCount as AmountPartner');
        Add('     , -1 * BillItems.OperCount as AmountChangePercent');
        Add('     , isnull(tmpBI_byDiscountWeight.DiscountWeight,0) as ChangePercentAmount');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА

        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = BillItems.GoodsPropertyId'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = BillItems.KindPackageId'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill.ToId'
           +'                                                                           and 1=1'
           );

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'

           +'  and isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'  and isnull(UnitTo.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ

           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and UnitTo.pgUnitId is null'
           +'    and UnitTo.PersonalId_Postgres is not null)'

           +'    or (UnitTo.pgUnitId is not null'
           +'    and UnitFrom.pgUnitId is null'
           +'    and UnitFrom.PersonalId_Postgres is not null))'

           +'  and pgUnitFrom.Id_Postgres_Branch is null'
           +'  and pgUnitTo.Id_Postgres_Branch is null'

           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate,ObjectId');
        Open;
        cbSendPersonal.Caption:='2.2. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Перемещение с экспедиторами';
       //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_sendonprice';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercentAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountChangePercent').Value:=FieldByName('AmountChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercentAmount').Value:=FieldByName('ChangePercentAmount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSendPersonal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_SendUnitBranch:Integer;
begin
     Result:=0;
     if (not cbSendUnitBranch.Checked)or(not cbSendUnitBranch.Enabled) then exit;
     //
     myEnabledCB(cbSendUnitBranch);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');

        Add('     , OperDate as OperDatePartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('     , null as CarId');
        Add('     , null as PersonalDriverId');

        Add('     , null as RouteId');
        Add('     , case when isnull(Bill.RouteUnitId,0) = Bill.ToId then ToId_Postgres else Unit_RouteSorting.Id_Postgres_RouteSorting end as RouteSortingId_Postgres');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
// +' and Bill.Id = 1260716'

           +'  and not ('
           +'      (UnitFrom.pgUnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (UnitTo.pgUnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (pgUnitFrom.Id_Postgres_Branch is null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (pgUnitTo.Id_Postgres_Branch is null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'          )'

           +'  and not ('
           +'      isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'  and isnull(UnitTo.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ

           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and UnitTo.pgUnitId is null'
           +'    and UnitTo.PersonalId_Postgres is not null)'

           +'    or (UnitTo.pgUnitId is not null'
           +'    and UnitFrom.pgUnitId is null'
           +'    and UnitFrom.PersonalId_Postgres is not null))'

           +'  and pgUnitFrom.Id_Postgres_Branch is null'
           +'  and pgUnitTo.Id_Postgres_Branch is null'
           +'          )'

           +'  and not ('
           +'       ((UnitFrom.pgUnitId is not null'
           +'     or UnitFrom.PersonalId_Postgres is not null'
           +'     or pgUnitFrom.Id_Postgres_Branch is not null)'
           +'    and (UnitTo.pgUnitId is null'
           +'     and UnitTo.PersonalId_Postgres is null'
           +'     and pgUnitTo.Id_Postgres_Branch is null))'
           +'          )'
           +'  and not ('
           +'       ((UnitTo.pgUnitId is not null'
           +'     or UnitTo.PersonalId_Postgres is not null'
           +'     or pgUnitTo.Id_Postgres_Branch is not null)'
           +'    and (UnitFrom.pgUnitId is null'
           +'     and UnitFrom.PersonalId_Postgres is null'
           +'     and pgUnitFrom.Id_Postgres_Branch is null))'
           +'          )'

{           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and pgUnitTo.Id_Postgres_Branch is not null)'
           +'    or (UnitTo.pgUnitId is not null'
           +'    and pgUnitFrom.Id_Postgres_Branch is not null))'}
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbSendUnitBranch.Caption:='2.3. ('+IntToStr(RecordCount)+') Перемещение с филиалами';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_sendonprice';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);

        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;

             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('RouteSortingId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSendUnitBranch);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_SendUnitBranch(SaveCount:Integer);
begin
     if (not cbSendUnitBranch.Checked)or(not cbSendUnitBranch.Enabled) then exit;
     //
     myEnabledCB(cbSendUnitBranch);
     //
     fExecSqFromQuery('call dba._pgInsertClient_byScaleDiscountWeight ('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))+')');
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , case when isnull(tmpBI_byDiscountWeight.DiscountWeight,0)<>0'
           +'               then -1 * BillItems.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'            else -1 * BillItems.OperCount'
           +'       end as Amount');
        Add('     , -1 * BillItems.OperCount as AmountPartner');
        Add('     , -1 * BillItems.OperCount as AmountChangePercent');
        Add('     , isnull(tmpBI_byDiscountWeight.DiscountWeight,0) as ChangePercentAmount');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА

        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = BillItems.GoodsPropertyId'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = BillItems.KindPackageId'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill.ToId'
           +'                                                                           and 1=1');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
// +' and Bill.Id_Postgres=3915'

           +'  and not ('
           +'      (UnitFrom.pgUnitId is not null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (UnitTo.pgUnitId is not null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (pgUnitFrom.Id_Postgres_Branch is null or UnitFrom.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'  and (pgUnitTo.Id_Postgres_Branch is null or UnitTo.ParentId=4137)' // МО ЛИЦА-ВСЕ
           +'          )'

           +'  and not ('
           +'      isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'  and isnull(UnitTo.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ

           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and UnitTo.pgUnitId is null'
           +'    and UnitTo.PersonalId_Postgres is not null)'

           +'    or (UnitTo.pgUnitId is not null'
           +'    and UnitFrom.pgUnitId is null'
           +'    and UnitFrom.PersonalId_Postgres is not null))'

           +'  and pgUnitFrom.Id_Postgres_Branch is null'
           +'  and pgUnitTo.Id_Postgres_Branch is null'
           +'          )'

           +'  and not ('
           +'       ((UnitFrom.pgUnitId is not null'
           +'     or UnitFrom.PersonalId_Postgres is not null'
           +'     or pgUnitFrom.Id_Postgres_Branch is not null)'
           +'    and (UnitTo.pgUnitId is null'
           +'     and UnitTo.PersonalId_Postgres is null'
           +'     and pgUnitTo.Id_Postgres_Branch is null))'
           +'          )'
           +'  and not ('
           +'       ((UnitTo.pgUnitId is not null'
           +'     or UnitTo.PersonalId_Postgres is not null'
           +'     or pgUnitTo.Id_Postgres_Branch is not null)'
           +'    and (UnitFrom.pgUnitId is null'
           +'     and UnitFrom.PersonalId_Postgres is null'
           +'     and pgUnitFrom.Id_Postgres_Branch is null))'
           +'          )'

{           +'  and ((UnitFrom.pgUnitId is not null'
           +'    and pgUnitTo.Id_Postgres_Branch is not null)'
           +'    or (UnitTo.pgUnitId is not null'
           +'    and pgUnitFrom.Id_Postgres_Branch is not null))'
           +'  and BillItems.Id is not null'}

           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbSendUnitBranch.Caption:='2.3. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Перемещение с филиалами';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_sendonprice';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercentAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountChangePercent').Value:=FieldByName('AmountChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercentAmount').Value:=FieldByName('ChangePercentAmount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSendUnitBranch);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
//!!!!INTEGER
procedure TMainForm.pCompleteDocument_Sale_Int(isLastComplete:Boolean);
begin
     if (not cbCompleteSaleInt.Checked)or(not cbCompleteSaleInt.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSaleInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.ObjectId');
        Add('     , Bill.OperDate');
        Add('     , Bill.InvNumber');
        Add('     , Bill.FromID');
        Add('     , Bill.ClientID');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba._pgSelect_Bill_Sale('+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))+')');
        Add('     as Bill');

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.InvNumber'
                +'                           and _pgBillLoad.FromId=Bill.FromId')
        else
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = Bill.ClientID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
             Add('   and Bill.Id_Postgres>0');
        end
        else
            Add('where Bill.Id_Postgres>0');

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteSaleInt.Caption:='3.3.('+IntToStr(RecordCount)+')Прод.пок.Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Sale';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteSaleInt);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pCompleteDocument_Sale_Fl(isLastComplete:Boolean);
begin
     if (not cbCompleteSaleFl.Checked)or(not cbCompleteSaleFl.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSaleFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.ObjectId');
        Add('     , Bill.OperDate');
        Add('     , Bill.InvNumber');
        Add('     , Bill.ClientID');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba._pgSelect_Bill_Sale('+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))+')');
        Add('     as Bill');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = Bill.ClientID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
             Add('   and Bill.Id_Postgres>0');
        end
        else
            Add('where Bill.Id_Postgres>0');

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteSaleFl.Caption:='3.1.('+IntToStr(RecordCount)+')Прод.пок.Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Sale';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteSaleFl);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn_Int(isLastComplete:Boolean);
begin
     if (not cbCompleteReturnInInt.Checked)or(not cbCompleteReturnInInt.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnInInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.FromID as ClientId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = Bill.FromID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Id_Postgres > 0'
           +'  and Bill.BillKind=zc_bkReturnToUnit()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteReturnInInt.Caption:='3.4.('+IntToStr(RecordCount)+')Воз.от пок.Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_ReturnIn';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteReturnInInt);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn_Fl(isLastComplete:Boolean);
begin
     if (not cbCompleteReturnInFl.Checked)or(not cbCompleteReturnInFl.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnInFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.FromID as ClientId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = Bill.FromID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Id_Postgres > 0'
           +'  and Bill.BillKind=zc_bkReturnToUnit()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteReturnInFl.Caption:='3.2.('+IntToStr(RecordCount)+')Воз.от пок.Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_ReturnIn';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteReturnInFl);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
//!!!!INTEGER
function TMainForm.pLoadDocument_Sale:Integer;
var ContractId_pg,PriceListId:Integer;
begin
     Result:=0;
     if (not cbSaleInt.Checked)or(not cbSaleInt.Enabled) then exit;
     //
     myEnabledCB(cbSaleInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select * from dba._pgSelect_Bill_Sale('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))+') as tmpSelect');

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=tmpSelect.InvNumber'
                +'                           and _pgBillLoad.FromId=tmpSelect.FromId')
        else

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = tmpSelect.ClientID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
            if cbOnlyInsertDocument.Checked
            then Add('and isnull(Id_Postgres,0)=0');
        end
        else
            if cbOnlyInsertDocument.Checked
            then Add('where isnull(Id_Postgres,0)=0');
// Add('where BillId = 1400794');
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbSaleInt.Caption:='3.3.('+IntToStr(RecordCount)+')Прод.пок.Int';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Sale_SybaseInt';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberOrder',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);


        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        {toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalId',ftInteger,ptInput, 0);}
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('ioPriceListId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inIsOnlyUpdateInt',ftBoolean,ptInput, false);
        //
        toStoredProc_two.StoredProcName:='gpSetErased_Movement';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInputOutput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             //!!!УДАЛЯЕМ ВСЕ ЭЛЕМЕНТЫ!!!
             if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             then
                  fExecSqToQuery ('select gpMovementItem_Sale_SetErased (MovementItem.Id, zfCalc_UserAdmin()) from MovementItem where MovementId = '+FieldByName('Id_Postgres').AsString);
             //!!!!!!!!!!!!!!!!!!

             //Прайс-лист не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ObjectId AS PriceListId from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_PriceList()');
                  PriceListId:=toSqlQuery.FieldByName('PriceListId').AsInteger;
             end
             else PriceListId:=0;
             //
             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:='';
             toStoredProc.Params.ParamByName('inInvNumberOrder').Value:=FieldByName('BillNumberClient1').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;


             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             {toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalId').Value:=FieldByName('PersonalId_Postgres').AsInteger;
             }
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('RouteSortingId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioPriceListId').Value:=PriceListId;

             if FieldByName('isOnlyUpdateInt').AsInteger=zc_rvNo
             then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
             else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=cbOnlyUpdateInt.Checked;

             if not myExecToStoredProc then ;//exit;
             //
             if ((1=1)or(FieldByName('Id_Postgres').AsInteger=0))
             then begin fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value) + ' and isnull(Id_Postgres,0)<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
                        fExecSqFromQuery('update dba.Bill join dba._pgBillLoad_union on _pgBillLoad_union.BillId_union = '+FieldByName('ObjectId').AsString +' and _pgBillLoad_union.BillId = Bill.Id set Bill.Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value) + ' and isnull(Bill.Id_Postgres,0)<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
                  end;
             {}
             //
             //!!!УДАЛЕНИЕ!!!
             {toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
             if not myExecToStoredProc_two then ;
             if (FieldByName('isFl').AsInteger<>FieldByName('zc_rvYes').AsInteger)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=null where Id = '+FieldByName('ObjectId').AsString);}
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSaleInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!INTEGER
procedure TMainForm.pLoadDocumentItem_Sale (SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbSaleInt.Checked)or(not cbSaleInt.Enabled) then exit;
     //
     myEnabledCB(cbSaleInt);
     //
     fExecSqFromQuery('call dba._pgInsertClient_byScaleDiscountWeight ('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))+')');
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , case when isnull(tmpBI_byDiscountWeight.DiscountWeight,0)<>0'
           +'               then -1 * BillItems.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'            else -1 * BillItems.OperCount'
           +'       end as Amount');
        Add('     , -1 * BillItems.OperCount as AmountPartner');
        Add('     , -1 * BillItems.OperCount as AmountChangePercent');
        Add('     , isnull(tmpBI_byDiscountWeight.DiscountWeight,0) as ChangePercentAmount');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , 0 as AssetId_Postgres');

        Add('     , zc_rvNo() as isFl');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+isnull(KindPackage.KindPackageName,'+FormatToVarCharServer_notNULL('')+')+'+FormatToVarCharServer_notNULL(')')
           //+'            when KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')+' end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');

        Add('     , case when Bill.FromId in (zc_UnitId_StoreSale()) and BillItems.GoodsPropertyId<>5510' // РУЛЬКА ВАРЕНАЯ в пакете для запекания
           +'                 then zc_rvYes()'
           +'             else zc_rvNo()'
           +'       end as isOnlyUpdateInt');

        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from (select Bill.*'
           +'      from dba.Bill'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkSaleToClient())'
           +'        and Bill.Id_Postgres>0'
           +'     union all'
           +'      select Bill.*'
           +'      from dba.Bill'
           +'           left join dba.isUnit on isUnit.UnitId = Bill.ToId'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'        and Bill.FromId=zc_UnitId_StoreSale()'
           +'        and Bill.Id_Postgres>0'
           +'        and isUnit.UnitId is null'
           +'     ) as Bill');

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.BillNumber'
                +'                           and _pgBillLoad.FromId=Bill.FromId');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');

        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = GoodsProperty.Id'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = KindPackage.Id'
           +'                                                                           and Bill.BillDate between tmpBI_byDiscountWeight.StartDate and tmpBI_byDiscountWeight.EndDate'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill.ToId'
           +'                                                                           and 1=1');
{        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit(),zc_bkSaleToClient())'
           +'  and Bill.FromId<>1022' // ВИЗАРД 1
           +'  and Bill.ToId<>1022' // ВИЗАРД 1
           +'  and Bill.FromId<>532' // КЛИЕНТ БН
           +'  and Bill.ToId<>532' // КЛИЕНТ БН
           +'  and CheckBilNumber.BillNumber is null'
// +'  and 1=0'
// +'  and Bill.Id in (1262471, 1262480)'
// +'  and MovementId_Postgres = 10154'
           +'  and (((UnitFrom.pgUnitId is not null'
           +'     or UnitFrom.PersonalId_Postgres is not null'
           +'     or pgUnitFrom.Id_Postgres_Branch is not null)'
           +'    and (UnitTo.pgUnitId is null'
           +'     and UnitTo.PersonalId_Postgres is null'
           +'     and pgUnitTo.Id_Postgres_Branch is null)'
           +'     and isnull(UnitFrom.ParentId,0)<>4137' // МО ЛИЦА-ВСЕ
           +'     and isnull(UnitTo.ParentId,0)<>4137)' // МО ЛИЦА-ВСЕ
           +'     or Bill.BillKind = zc_bkSaleToClient())'
           +'  and BillItems.Id is not null'
           );
        Add('union all');
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , isnull(Bill_find_two.Id_Postgres, isnull(Bill_find.Id_Postgres, Bill.Id_Postgres)) as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , case when Bill.FromId=5 then 0 else -1* BillItems.OperCount end as Amount');
        Add('     , -1 * BillItems.OperCount as AmountPartner');
        Add('     , case when Bill.FromId=5 then 0 else -1* BillItems.OperCount end  as AmountChangePercent');
        Add('     , 0 as ChangePercentAmount');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , 0 as AssetId_Postgres');

        Add('     , zc_rvYes() as isFl');
        Add('     , case when GoodsProperty.Id is null then '+FormatToVarCharServer_notNULL('ошибка товар-')+'+cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-f')
           +'            when GoodsProperty_Detail.KindPackageId is null then '+FormatToVarCharServer_notNULL('ошибка вид-')+'+cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-f')
           +'            else '+FormatToVarCharServer_notNULL('')+' end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.fBill as Bill');
        Add('     left outer join dba.Bill AS Bill_find on Bill_find.Id = Bill.BillId_byLoad');
        Add('     left outer join dba.Bill AS Bill_find_two on Bill_find_two.Id = Bill_find.BillId_pg');

        Add('     left outer join dba.fBillItems as BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.fGoodsProperty_Detail_byLoad on fGoodsProperty_Detail_byLoad.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('                                                     and fGoodsProperty_Detail_byLoad.KindPackageId = BillItems.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Detail on GoodsProperty_Detail.Id = fGoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = GoodsProperty_Detail.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('     left outer join dba.BillItems as BillItems_find on BillItems_find.Id = BillItems.BillItemsId_byLoad'
           +'                                                    and BillItems_find.GoodsPropertyId=GoodsProperty_Detail.GoodsPropertyId'
           +'                                                    and (BillItems_find.KindPackageId=isnull(GoodsProperty_Detail.KindPackageId,0) or BillItems.GoodsPropertyId=1921)'
           +'                                                    and BillItems_find.OperPrice=BillItems.OperPrice');
        Add('     left outer join dba.Bill as Bill_find_check on Bill_find_check.Id = BillItems_find.BillId and isnull(Bill_find_check.BillId_pg,Bill_find_check.Id)=isnull(Bill_find.BillId_pg,Bill_find.Id)');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           +'  and Bill.BillKind in (zc_bkSaleToClient())'
           +'  and Bill.FromId<>1022' // ВИЗАРД 1
           +'  and Bill.FromId<>1037' // ВИЗАРД 1037
           +'  and Bill.ToId<>1022' // ВИЗАРД 1
           +'  and Bill.ToId<>1037' // ВИЗАРД 1037
           +'  and BillItems.Id is not null'
           +'  and Bill_find_check.Id is null'
           );}
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;
        cbSaleInt.Caption:='3.3.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Прод.пок.Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Sale_SybaseInt';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercentAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsOnlyUpdateInt',ftBoolean,ptInput, false);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             //!!!ВОССТАНАВЛИВАЕМ 1 ЭЛЕМЕНТ!!
             if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             then
                  fExecSqToQuery ('select * from gpMovementItem_Sale_SetUnErased ('+FieldByName('Id_Postgres').AsString+', zfCalc_UserAdmin())');
             //!!!!!!!!!!!!!!!!!!
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountChangePercent').Value:=FieldByName('AmountChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercentAmount').Value:=FieldByName('ChangePercentAmount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;

             if FieldByName('isOnlyUpdateInt').AsInteger=zc_rvNo
             then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
             else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=cbOnlyUpdateInt.Checked;

             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSaleInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
function TMainForm.pLoadDocument_Sale_Fl:Integer;
var ContractId_pg,PriceListId:Integer;
begin
     Result:=0;
     if (not cbSaleFl.Checked)or(not cbSaleFl.Enabled) then exit;
     //
     myEnabledCB(cbSaleFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select * from dba._pgSelect_Bill_Sale('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))+') as tmpSelect');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = tmpSelect.ClientID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
             if cbOnlyInsertDocument.Checked
             then Add('and isnull(Id_Postgres,0)=0');
        end
        else
             if cbOnlyInsertDocument.Checked
             then Add('where isnull(Id_Postgres,0)=0');
//Add('where BillId=1702760');

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbSaleFl.Caption:='3.1.('+IntToStr(RecordCount)+')Прод.пок.Fl';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_sale';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberOrder',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);


        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        {toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalId',ftInteger,ptInput, 0);}
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('ioPriceListId',ftInteger,ptInputOutput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //Прайс-лист не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ObjectId AS PriceListId from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_PriceList()');
                  PriceListId:=toSqlQuery.FieldByName('PriceListId').AsInteger;
             end
             else PriceListId:=0;
             //
             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('BillNumberClient2').AsString;;
             toStoredProc.Params.ParamByName('inInvNumberOrder').Value:=FieldByName('BillNumberClient1').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('StatusId').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inChecked').Value:=true else toStoredProc.Params.ParamByName('inChecked').Value:=false;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;


             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             {toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;
             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalId').Value:=FieldByName('PersonalId_Postgres').AsInteger;
             }
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('RouteSortingId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioPriceListId').Value:=PriceListId;

             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)
             then fExecFlSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSaleFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pLoadDocumentItem_Sale_Fl_Int (SaveCount1:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbSaleFl.Checked)or(not cbSaleFl.Enabled) then exit;
     //
     myEnabledCB(cbSaleFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , case when Bill.FromId in (5,'
           +'                                 1388,' //'ГРИВА Р.'
           +'                                 1799,' //'ДРОВОРУБ'
           +'                                 1288,' //'ИЩИК К.'
           +'                                 956,' //'КОЖУШКО С.'
           +'                                 1390,' //'НЯЙКО В.'
           +'                                 5460,' //'ОЛЕЙНИК М.В.'
           +'                                 324,' //'СЕМЕНЕВ С.'
           +'                                 3010,' //'ТАТАРЧЕНКО Е.'
           +'                                 5446,' //'ТКАЧЕНКО ЛЮБОВЬ'
           +'                                 4792,' //'ТРЕТЬЯКОВ О.Н.'
           +'                                 980,' //'ТУЛЕНКО С.'
           +'                                 2436' //'ШЕВЦОВ И.'
           +'                                ,1374' //БУФАНОВ Д.
           +'                                ,1022' //'ВИЗАРД 1
           +'                                ,1037' //'ВИЗАРД 1037
           +'                                )'
           +'            then zc_rvYes() else zc_rvNo() end as is_FromId_5');
        Add('     , case when is_FromId_5=zc_rvYes()'
           +'                 then case when isnull(tmpBI_byDiscountWeight.DiscountWeight,0)<>0'
           +'                                then -1 * BillItems_find.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'                           else -1 * BillItems_find.OperCount'
           +'                      end'
           +'                 else -1* BillItems.OperCount'
           +'       end as Amount');
        Add('     , -1 * BillItems.OperCount as AmountPartner');
        Add('     , case when is_FromId_5=zc_rvYes() then -1* BillItems_find.OperCount else -1* BillItems.OperCount end  as AmountChangePercent');
        Add('     , isnull(tmpBI_byDiscountWeight.DiscountWeight,0) as ChangePercentAmount');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , 0 as AssetId_Postgres');
        Add('     , zc_rvYes() as isFl');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+isnull(KindPackage_f.KindPackageName,'+FormatToVarCharServer_notNULL('')+')+'+FormatToVarCharServer_notNULL(')')
           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')+' end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Bill_i AS Bill_find on Bill_find.Id = Bill.BillId_byLoad');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_f on GoodsProperty_f.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage as KindPackage_f on KindPackage_f.Id = BillItems.KindPackageId');

        Add('     left outer join (select max(GoodsProperty_Detail_byLoad.Id_byLoad) as Id_byLoad, GoodsPropertyId, KindPackageId from dba.GoodsProperty_Detail_byLoad where GoodsProperty_Detail_byLoad.Id_byLoad<>0 group by GoodsPropertyId, KindPackageId');
        Add('                     ) as GoodsProperty_Detail_byLoad on GoodsProperty_Detail_byLoad.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('                                                     and GoodsProperty_Detail_byLoad.KindPackageId = BillItems.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Detail_byServer on GoodsProperty_Detail_byServer.Id = GoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     left outer join dba.GoodsProperty_i as GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail_byServer.GoodsPropertyId');
        Add('     left outer join dba.Goods_i as Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('     left outer join dba.BillItems_i as BillItems_find on BillItems_find.Id = BillItems.BillItemsId_byLoad'
           +'                                                      and BillItems_find.GoodsPropertyId=GoodsProperty.Id'
           +'                                                      and BillItems_find.KindPackageId=GoodsProperty_Detail_byServer.KindPackageId'
           +'                                                      and BillItems_find.OperPrice=BillItems.OperPrice');
        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = GoodsProperty.Id'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = KindPackage.Id'
           +'                                                                           and Bill_find.BillDate between tmpBI_byDiscountWeight.StartDate and tmpBI_byDiscountWeight.EndDate'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill_find.ToId'
           +'                                                                           and 1=1');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSaleToClient())'
           +'  and Bill.Id_Postgres>0'
           +'  and BillItems.GoodsPropertyId<>1041' // КОВБАСНI ВИРОБИ
// +'  and Bill.Id=1748596'
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbSaleFl.Caption:='3.1.('+IntToStr(SaveCount1)+')('+IntToStr(RecordCount)+')Прод.пок.Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_sale';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercentAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountChangePercent').Value:=FieldByName('AmountChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercentAmount').Value:=FieldByName('ChangePercentAmount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecFlSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSaleFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ProductionUnion(isLastComplete:Boolean);
begin
     if (not cbCompleteProductionUnion.Checked)or(not cbCompleteProductionUnion.Enabled) then exit;
     //
     myEnabledCB(cbCompleteProductionUnion);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , isnull (pgPersonalFrom.Id2_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id2_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres'
           +'                                                      and pgPersonalFrom.Id2_Postgres>0'
           +'                                                      and UnitFrom.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres'
           +'                                                      and pgPersonalTo.Id2_Postgres>0'
           +'                                                      and UnitTo.ParentId=4137'); // МО ЛИЦА-ВСЕ
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'  and Id_Postgres >0'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           );
        Add('  and FromId_Postgres <> 0');
        Add('  and ToId_Postgres <> 0');

        Add('order by OperDate,ObjectId');
        Open;
        cbCompleteProductionUnion.Caption:='4.1. ('+IntToStr(RecordCount)+') Производство смешивание';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_ProductionUnion';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if cbComplete.Checked then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteProductionUnion);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_ProductionUnion:Integer;
begin
     Result:=0;
     if (not cbProductionUnion.Checked)or(not cbProductionUnion.Enabled) then exit;
     //
     myEnabledCB(cbProductionUnion);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber || case when (pgUnitFrom.Id is null)'
           +'                                 or (pgUnitTo.Id is null)'
           +'                                    then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when pgUnitFrom.Id is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' От Кого:')+'|| UnitFrom.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when pgUnitTo.Id is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' Кому:')+'|| UnitTo.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'       as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +' and Bill.Id_Postgres=22081'
           +'  and Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbProductionUnion.Caption:='4.1. ('+IntToStr(RecordCount)+') Производство смешивание';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_ProductionUnion';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbProductionUnion);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocumentItem_ProductionUnionMaster(SaveCount:Integer):Integer;
begin
     Result:=0;
     if (not cbProductionUnion.Checked)or(not cbProductionUnion.Enabled) then exit;
     //
     myEnabledCB(cbProductionUnion);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , BillItems.OperCount as Amount');
        Add('     , isnull(BillItems.isClosePartion,zc_rvNo()) as PartionClose');
        Add('     , BillItems.OperCount_sh as shCount');
        Add('     , BillItems.RealCount as RealWeight');
        Add('     , BillItems.KuterCount as CuterCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , BillItems.OperComment as OperComment');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , 0 as ReceiptId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbProductionUnion.Caption:='4.1. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Производство смешивание';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ProductionUnion_Master';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionClose',ftBoolean,ptInput,false);
        toStoredProc.Params.AddParam ('inCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inRealWeight',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCuterCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inReceiptId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;

             if FieldByName('PartionClose').AsInteger=FieldByName('zc_rvYes').AsInteger
             then toStoredProc.Params.ParamByName('inPartionClose').Value:=true
             else toStoredProc.Params.ParamByName('inPartionClose').Value:=false;

             toStoredProc.Params.ParamByName('inCount').Value:=FieldByName('shCount').AsFloat;
             toStoredProc.Params.ParamByName('inRealWeight').Value:=FieldByName('RealWeight').AsFloat;
             toStoredProc.Params.ParamByName('inCuterCount').Value:=FieldByName('CuterCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('OperComment').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inReceiptId').Value:=FieldByName('ReceiptId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbProductionUnion);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_ProductionUnionChild(SaveCount1,SaveCount2:Integer);
begin
     if (not cbProductionUnion.Checked)or(not cbProductionUnion.Enabled) then exit;
     //
     myEnabledCB(cbProductionUnion);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItemsReceipt.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , -BillItemsReceipt.OperReceiptCount as Amount');
        Add('     , BillItems.Id_Postgres as ParentId_Postgres');
        Add('     , BillItemsReceipt.OperCount_byReceipt as AmountReceipt');
        Add('     , BillItemsReceipt.PartionDate as PartionGoodsDate');
        Add('     , BillItemsReceipt.PartionStr_MB as PartionGoods');
        Add('     , null as OperComment');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItemsReceipt.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItemsReceipt on BillItemsReceipt.BillId = Bill.Id');
        Add('     left outer join dba.BillItems on BillItems.Id = BillItemsReceipt.ParentBillItemsID');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItemsReceipt.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItemsReceipt.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           +'  and BillItemsReceipt.Id is not null'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbProductionUnion.Caption:='4.1. ('+IntToStr(SaveCount1)+')('+IntToStr(SaveCount2)+')('+IntToStr(RecordCount)+') Производство смешивание';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ProductionUnion_Child';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountReceipt',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmountReceipt').Value:=FieldByName('AmountReceipt').AsFloat;

             if FieldByName('PartionGoodsDate').AsDateTime < StrToDate('01.01.1900')
             then toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=StrToDate('01.01.1900')
             else toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=FieldByName('PartionGoodsDate').AsDateTime;

             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('OperComment').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItemsReceipt set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbProductionUnion);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ProductionSeparate(isLastComplete:Boolean);
begin
     if (not cbCompleteProductionSeparate.Checked)or(not cbCompleteProductionSeparate.Enabled) then exit;
     //
     myEnabledCB(cbCompleteProductionSeparate);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkProduction())'
           +'  and Id_Postgres >0'
           );
        Add('  and FromId_Postgres <> 0');
        Add('  and ToId_Postgres <> 0');

        Add('order by OperDate,ObjectId');
        Open;
        cbCompleteProductionSeparate.Caption:='4.2. ('+IntToStr(RecordCount)+') Производство разделение';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_ProductionSeparate';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if cbComplete.Checked then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteProductionSeparate);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_ProductionSeparate:Integer;
begin
     Result:=0;
     if (not cbProductionSeparate.Checked)or(not cbProductionSeparate.Enabled) then exit;
     //
     myEnabledCB(cbProductionSeparate);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber || case when (pgUnitFrom.Id is null)'
           +'                                 or (pgUnitTo.Id is null)'
           +'                                    then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when pgUnitFrom.Id is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' От Кого:')+'|| UnitFrom.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when pgUnitTo.Id is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' Кому:')+'|| UnitTo.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.PartionStr_MB as PartionGoods');
        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +' and Bill.Id_Postgres=22081'
           +'  and Bill.BillKind in (zc_bkProduction())'
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbProductionSeparate.Caption:='4.2. ('+IntToStr(RecordCount)+') Производство разделение';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_ProductionSeparate';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbProductionSeparate);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocumentItem_ProductionSeparateMaster(SaveCount:Integer):Integer;
begin
     Result:=0;
     if (not cbProductionSeparate.Checked)or(not cbProductionSeparate.Enabled) then exit;
     //
     myEnabledCB(cbProductionSeparate);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , -BillItems.OperCount as Amount');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.IsProduction=zc_rvNo()');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkProduction())'
           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbProductionSeparate.Caption:='4.2. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Производство разделение';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ProductionSeparate_Master';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
//        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             //toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbProductionSeparate);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_ProductionSeparateChild(SaveCount1,SaveCount2:Integer);
begin
     if (not cbProductionSeparate.Checked)or(not cbProductionSeparate.Enabled) then exit;
     //
     myEnabledCB(cbProductionSeparate);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , BillItems.OperCount as Amount');
        Add('     , 0 as ParentId_Postgres');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.IsProduction=zc_rvYes()');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkProduction())'
           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate,ObjectId');
        Open;
        cbProductionSeparate.Caption:='4.2. ('+IntToStr(SaveCount1)+')('+IntToStr(SaveCount2)+')('+IntToStr(RecordCount)+') Производство разделение';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ProductionSeparate_Child';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
//        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             //toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbProductionSeparate);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnOut(isLastComplete:Boolean);
begin
     if (not cbCompleteReturnOut.Checked)or(not cbCompleteReturnOut.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnOut);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as InfoMoneyCode');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.Id as ObjectId');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           +'                      from dba.Bill'
           +'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems_find.GoodsPropertyId'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                        and Bill.BillKind=zc_bkReturnToClient()'
           +'                        and Bill.Id_Postgres>0'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as UnitTo on UnitTo.ID = Bill.ToID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and Id_Postgres >0'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;
        Add('order by InfoMoneyCode,OperDate,ObjectId');
        Open;
        cbCompleteReturnOut.Caption:='1.2. ('+IntToStr(RecordCount)+') Возврат поставщику';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_ReturnOut';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteReturnOut);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_ReturnOut:Integer;
var JuridicalId_pg,PartnerId_pg,ContractId_pg:Integer;
begin
     Result:=0;
     if (not cbReturnOut.Checked)or(not cbReturnOut.Enabled) then exit;
     //
     myEnabledCB(cbReturnOut);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');

        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when OKPO='+FormatToVarCharServer_notNULL('')+' or FromId_Postgres is null'
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when OKPO='+FormatToVarCharServer_notNULL('')+' then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName ||'+FormatToVarCharServer_notNULL('(')+'||OKPO||'+FormatToVarCharServer_notNULL(')')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when FromId_Postgres is null then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , Bill.BillDate as OperDate');
        Add('     , UnitTo.UnitName as UnitNameTo');
        Add('     , OperDate as OperDatePartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , _pgUnit.Id_Postgres as FromId_Postgres');
        Add('     , MoneyKind.Id_Postgres as PaidKindId_Postgres');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as CodeIM');
        Add('     , _pgInfoMoney.Id3_Postgres as InfoMoneyId_pg');
        Add('     , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO');
        Add('     , Bill.FromId, Bill.ToId');
        Add('     , Bill_findInfoMoney.findId');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           +'                            ,max(isnull(BillItems_find.Id,0))as findId'
           +'                      from dba.Bill'
           +'                           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0'
           +'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems_find.GoodsPropertyId'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'                         and Bill.BillKind=zc_bkReturnToClient()'
           +'                         and Bill.MoneyKindId = zc_mkBN()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = Bill_findInfoMoney.InfoMoneyCode');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id=Bill.FromId');
        Add('     left outer join dba._pgUnit on _pgUnit.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
//           +'  and Bill.ToId<>4928'//ФОЗЗИ-ПЕРЕПАК ПРОДУКЦИИ
           +'  and Bill.FromId<>4927'//СКЛАД ПЕРЕПАК
           +'  and Bill.FromId not in (3830, 3304)' //КРОТОН ООО (хранение) + КРОТОН ООО
           +'  and Bill.ToId not in (3830, 3304)'  // КРОТОН ООО (хранение) + КРОТОН ООО
//           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbReturnOut.Caption:='1.3. ('+IntToStr(RecordCount)+') Возврат поставщику';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_ReturnOut';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_Object_Partner_Sybase';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inGLNCode',ftString,ptInput, '');
        toStoredProc_two.Params.AddParam ('inPrepareDayCount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDocumentDayCount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inPersonalTakeId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             PartnerId_pg:=0;
             JuridicalId_pg:=0;
             ContractId_pg:=0;
             //Сначала находим контрагента  и юр.лицо
             fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                           +' from ObjectHistory_JuridicalDetails_View'
                           +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                           +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                           +' where OKPO='+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)
                           +'   and '+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)+'<>'+FormatToVarCharServer_notNULL('')
                           );
             PartnerId_pg:=toSqlQuery.FieldByName('PartnerId').AsInteger;
             JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //
             //создаем контрагента !!!если надо!!!
             if (PartnerId_pg=0)and(JuridicalId_pg<>0) then
             begin
                  toStoredProc_two.Params.ParamByName('ioId').Value:=0;
                  toStoredProc_two.Params.ParamByName('inCode').Value:=0;
                  toStoredProc_two.Params.ParamByName('inName').Value:=FieldByName('UnitNameTo').AsString;
                  toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
                  //
                  if not myExecToStoredProc_two then ;//exit;
                  //
                  PartnerId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
             end;

             // !!!не меняем договор!!! если в документе установили "свой" договор, и он не "закрыт" и не "удален"
             if (not cbUpdateConrtact.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery (' select MovementLinkObject.ObjectId as ContractId'
                                 +' from MovementLinkObject'
                                 +'      join Object_Contract_View on Object_Contract_View.ContractId = MovementLinkObject.ObjectId'
                                 +'                               and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'                               and Object_Contract_View.isErased = FALSE'
                                 +' where MovementLinkObject.MovementId='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 +'   and MovementLinkObject.DescId=zc_MovementLinkObject_Contract()'
                                 );
                  if toSqlQuery.FieldByName('ContractId').AsInteger<>0
                  then ContractId_pg:=toSqlQuery.FieldByName('ContractId').AsInteger
                  else //находим договор
                       ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,FieldByName('OperDate').AsDateTime);
             end
             else //находим договор
                  ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,FieldByName('OperDate').AsDateTime);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if JuridicalId_pg=0 then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка-кому:'+FieldByName('UnitNameTo').AsString
                                 else if (ContractId_pg=0)and(FieldByName('findId').AsInteger<>0)
                                      then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка--договор:???'
                                      else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString;

             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=PartnerId_pg;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnOut);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_ReturnOut(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbReturnOut.Checked)or(not cbReturnOut.Enabled) then exit;
     //
     myEnabledCB(cbReturnOut);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill.BillDate');
        Add('     , Bill.BillNumber');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , -1 * BillItems.OperCount as Amount');
        Add('     , Amount as AmountPartner');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , null as AssetId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbReturnOut.Caption:='1.3. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Возврат поставщику';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_ReturnOut';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnOut);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!INTEGER
function TMainForm.pLoadDocument_ReturnIn:Integer;
var ContractId_pg:Integer;
    InvNumberMark:String;
begin
     Result:=0;
     if (not cbReturnInInt.Checked)or(not cbReturnInInt.Enabled) then exit;
     //
     myEnabledCB(cbReturnInInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0'
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when FromId_Postgres is null then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when CodeIM = 0 then '+FormatToVarCharServer_notNULL('-УП статья:???')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , Bill.BillDate as OperDate');
        Add('     , OperDate as OperDatePartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , _pgPartner.PartnerId_pg as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres');
        Add('     , CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from (select Bill.Id as BillId'
           +'           , 30201 as CodeIM' // Мясное сырье
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0'
           +'                           left outer join dba.Unit on Unit.Id = Bill.FromId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'      group by Bill.Id'
           +'     union all'
           +'      select Bill.Id as BillId'
           +'           , 30101 as CodeIM' // Готовая продукция
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0'
           +'                           left outer join dba.Unit on Unit.Id = Bill.FromId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillDate >=zc_def_StartDate_PG()'
           +'        and Bill.BillKind in (zc_bkReturnToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'      group by Bill.Id'
           +'      ) as Bill_find');

        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        {Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                            left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Bill.FromId'}
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find '); // Contract_find.Id
        Add('          left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                          ) as _pgPartner on _pgPartner.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
             if cbOnlyInsertDocument.Checked
             then Add('and isnull(Bill.Id_Postgres,0)=0');
        end
        else
             if cbOnlyInsertDocument.Checked
             then Add('where isnull(Bill.Id_Postgres,0)=0');

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbReturnInInt.Caption:='3.3.('+IntToStr(RecordCount)+')Воз.от пок.Int';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_ReturnIn';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberMark',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             //Номер "перекресленої зеленої марки зi складу" не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ValueData AS InvNumberMark from MovementString where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementString_InvNumberMark()');
                  InvNumberMark:=toSqlQuery.FieldByName('InvNumberMark').AsString;
             end
             else InvNumberMark:='';

             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString;
             toStoredProc.Params.ParamByName('inInvNumberMark').Value:=InvNumberMark;

             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;

             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnInInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!INTEGER
procedure TMainForm.pLoadDocumentItem_ReturnIn(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbReturnInInt.Checked)or(not cbReturnInInt.Enabled) then exit;
     //
     myEnabledCB(cbReturnInInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , zc_rvYes() as IsChangeAmount');
        Add('     , case when Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak())'
           +'             and Bill.BillDate >=zc_def_StartDate_PG()'
           +'                 then 0'
           +'            else BillItems.OperCount'
           +'       end as AmountPartner');
        Add('     , BillItems.OperCount as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');

        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+isnull(KindPackage.KindPackageName,'+FormatToVarCharServer_notNULL('')+')+'+FormatToVarCharServer_notNULL(')')
//           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit())'
           +'  and Bill.Id_Postgres>0'
//           +'  and BillItems.GoodsPropertyId<>1041' //КОВБАСНI ВИРОБИ
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbReturnInInt.Caption:='3.4.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Воз.от пок.Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_ReturnIn_SybaseFl';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangeAmount',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inChangeAmount').Value:=FieldByName('IsChangeAmount').AsInteger=zc_rvYes;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnInInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
function TMainForm.pLoadDocument_ReturnIn_Fl:Integer;
var ContractId_pg:Integer;
    InvNumberMark:String;
begin
     Result:=0;
     if (not cbReturnInFl.Checked)or(not cbReturnInFl.Enabled) then exit;
     //
     myEnabledCB(cbReturnInFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0'
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when FromId_Postgres is null then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when CodeIM = 0 then '+FormatToVarCharServer_notNULL('-УП статья:???')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , Bill.BillNumberClient1 as inInvNumberPartner');

        Add('     , Bill.BillDate as OperDate');
        Add('     , OperDate as OperDatePartner');

        Add('     , isnull(Bill.StatusId, zc_rvNo()) as StatusId');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , _pgPartner.PartnerId_pg as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres');
        //Add('     , isnull (_pgContract_30103.ContractId_pg, isnull (_pgContract_30101.ContractId_pg, 0)) as ContractId');
        Add('     , Bill_find.CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from (select Bill.Id as BillId'
           +'           , max(case when isnull(Goods.ParentId,0) = 1730'
           +'                           then 30103'//(30103) Доходы Продукция Хлеб
           +'                      when Goods.Id = 2514 and 1=0'
           +'                           then 30201'//(30201) Доходы Мясное сырье
           +'                      else 30101'//(30101) Доходы Продукция Готовая продукция
           +'                 end) as CodeIM'
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0'
           +'                             and BillItems.GoodsPropertyId<>1041' // КОВБАСНI ВИРОБИ
           +'           left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'           left join dba.Goods on Goods.Id = GoodsProperty.GoodsId'
           +'                           left outer join dba.Unit on Unit.Id = Bill.FromId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit())'
//!!!           +'       and Bill.FromId<>1022' // ВИЗАРД 1
//!!!           +'       and Bill.FromId<>1037' // ВИЗАРД 1037
//!!!           +'       and Bill.ToId<>1022' // ВИЗАРД 1
//!!!           +'       and Bill.ToId<>1037' // ВИЗАРД 1037
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'      group by Bill.Id'
           +'      ) as Bill_find');

        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        {Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                            left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Bill.FromId'}
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find'); // Contract_find.Id
        Add('          left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId'
           +'                          ) as Unit_byLoad_From on Unit_byLoad_From.UnitId = Bill.FromId');
        Add('          left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                          ) as _pgPartner on _pgPartner.UnitId = Unit_byLoad_From.Id_byLoad');
{        Add('          left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg'
           +'                           from dba._pgPartner'
           +'                           where _pgPartner.JuridicalId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '+FormatToVarCharServer_notNULL('30101')
           +'                           group by _pgPartner.JuridicalId_pg'
           +'                          ) as _pgContract_30101 on _pgContract_30101.JuridicalId_pg = _pgPartner.JuridicalId_pg'
           +'                                                and Bill_find.CodeIM = 30101');
        Add('          left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg'
           +'                           from dba._pgPartner'
           +'                           where _pgPartner.JuridicalId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '+FormatToVarCharServer_notNULL('30103')
           +'                           group by _pgPartner.JuridicalId_pg'
           +'                          ) as _pgContract_30103 on _pgContract_30103.JuridicalId_pg = _pgPartner.JuridicalId_pg'
           +'                                                and Bill_find.CodeIM = 30103');}
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = case when Bill.ToId in (1388' //ГРИВА Р.
           +'                                                                             , 1799' //ДРОВОРУБ
           +'                                                                             , 1288' //ИЩИК К.
           +'                                                                             , 956' //КОЖУШКО С.
           +'                                                                             , 1390' //НЯЙКО В.
           +'                                                                             , 5460' //ОЛЕЙНИК М.В.
           +'                                                                             , 324' //СЕМЕНЕВ С.
           +'                                                                             , 3010' //ТАТАРЧЕНКО Е.
           +'                                                                             , 5446' //ТКАЧЕНКО ЛЮБОВЬ
           +'                                                                             , 4792' //ТРЕТЬЯКОВ О.Н.
           +'                                                                             , 980' //ТУЛЕНКО С.
           +'                                                                             , 2436' //ШЕВЦОВ И.
           +'                                                                             , 1374' //БУФАНОВ Д.

           +'                                                                             , 1022' //ВИЗАРД 1
           +'                                                                             , 1037' //ВИЗАРД 1037
           +'                                                                              ) then 5 else Bill.ToId end');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
             if cbOnlyInsertDocument.Checked
             then Add('and isnull(Bill.Id_Postgres,0)=0');
        end
        else
             if cbOnlyInsertDocument.Checked
             then Add('where isnull(Bill.Id_Postgres,0)=0');

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbReturnInFl.Caption:='3.2.('+IntToStr(RecordCount)+')Воз.от пок.Fl';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_ReturnIn';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberMark',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             //Номер "перекресленої зеленої марки зi складу" не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ValueData AS InvNumberMark from MovementString where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementString_InvNumberMark()');
                  InvNumberMark:=toSqlQuery.FieldByName('InvNumberMark').AsString;
             end
             else InvNumberMark:='';
             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('inInvNumberPartner').AsString;
             toStoredProc.Params.ParamByName('inInvNumberMark').Value:=InvNumberMark;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;

             if FieldByName('StatusId').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inChecked').Value:=true else toStoredProc.Params.ParamByName('inChecked').Value:=false;
             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;

             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)
             then fExecFlSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnInFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pLoadDocumentItem_ReturnIn_Fl(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbReturnInFl.Checked)or(not cbReturnInFl.Enabled) then exit;
     //
     myEnabledCB(cbReturnInFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        //Add('     , case when Bill.ToId=5 then zc_rvNo() else zc_rvYes() end as IsChangeAmount');
        //Add('     , BillItems.OperCount as AmountPartner');
        //Add('     , case when IsChangeAmount=zc_rvYes() then AmountPartner end as Amount');
        Add('     , zc_rvYes() as IsChangeAmount');
        Add('     , BillItems.OperCount as AmountPartner');
        Add('     , BillItems.OperCount as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , zc_rvYes() as isFl');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+KindPackage_f.KindPackageName+'+FormatToVarCharServer_notNULL(')')
           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_f on GoodsProperty_f.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage as KindPackage_f on KindPackage_f.Id = BillItems.KindPackageId');

        Add('     left outer join (select max(GoodsProperty_Detail_byLoad.Id_byLoad) as Id_byLoad, GoodsPropertyId, KindPackageId from dba.GoodsProperty_Detail_byLoad where GoodsProperty_Detail_byLoad.Id_byLoad<>0 group by GoodsPropertyId, KindPackageId');
        Add('                     ) as GoodsProperty_Detail_byLoad on GoodsProperty_Detail_byLoad.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('                                                     and GoodsProperty_Detail_byLoad.KindPackageId = BillItems.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Detail_byServer on GoodsProperty_Detail_byServer.Id = GoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     left outer join dba.GoodsProperty_i as GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail_byServer.GoodsPropertyId');
        Add('     left outer join dba.Goods_i as Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit())'
           +'  and Bill.Id_Postgres>0'
           +'  and BillItems.GoodsPropertyId<>1041' //КОВБАСНI ВИРОБИ
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbReturnInFl.Caption:='3.2.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Воз.от пок.Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_ReturnIn_SybaseFl';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangeAmount',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inChangeAmount').Value:=FieldByName('IsChangeAmount').AsInteger=zc_rvYes;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecFlSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnInFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!Integer
procedure TMainForm.pCompleteDocument_TaxInt(isLastComplete:Boolean);
begin
     if (not cbCompleteTaxInt.Checked)or(not cbCompleteTaxInt.Enabled) then exit;
     //
     myEnabledCB(cbCompleteTaxInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast(Bill.BillNumber as integer)as InvNumber');
        Add('     , Bill.BillNumberNalog');
        Add('     , Bill.FromID');
        Add('     , Bill.ToID');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.BillNumber'
                +'                           and _pgBillLoad.FromId=Bill.FromId');
        Add('     left outer join dba.Unit as Client on Client.ID = Bill.ToId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkSaleToClient())'
           +'  and Bill.NalogId_PG>0');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteTaxInt.Caption:='8.3.('+IntToStr(RecordCount)+')Налоговые Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpSetErased_Movement';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked
             then if (FieldByName('BillNumberNalog').AsInteger=0)or(FieldByName('MoneyKindId').AsInteger<>FieldByName('zc_mkBN').AsInteger)
                  then
                      begin
                           // удаляем
                           toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                           if not myExecToStoredProc_two then ;//exit;
                      end
                  else
                      begin
                           // распроводим
                           toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                           if not myExecToStoredProc then ;//exit;
                      end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger)
               and(FieldByName('BillNumberNalog').AsInteger<>0)
             then begin
                  // проводим
                  fExecSqToQuery (' UPDATE Movement SET StatusId = zc_Enum_Status_Complete()'
                                 +' where Id='+FieldByName('Id_Postgres').AsString);
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteTaxInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!Integer
function TMainForm.pLoadDocument_Tax_Int:Integer;
var ContractId_pg,ToId_pg:Integer;
    InvNumberBranch:String;
    zc_Enum_DocumentTaxKind_Tax:String;
begin
     Result:=0;
     if (not cbTaxInt.Checked)or(not cbTaxInt.Enabled) then exit;
     //
     myEnabledCB(cbTaxInt);
     //
     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_Tax() as RetV');
     zc_Enum_DocumentTaxKind_Tax:=toSqlQuery.FieldByName('RetV').AsString;
     //
     fExecSqFromQuery('delete from dba._pgList_tmp');
     fExecSqFromQuery('insert into _pgList_tmp(Id)'
           +'        select Id '
           +'        from (select Bill.Id, Bill.BillDate, max (fCalcCurrentBillDate_byPG (ScaleHistory_byObvalka.InsertDate,zc_rpTimeRemainsFree_H04()) ) as BillDate_calc'
           +'              from dba.Bill'
           +'                   join dba.ScaleHistory_byObvalka on ScaleHistory_byObvalka.BillId=Bill.Id'
           +'              where Bill.BillDate between ' + FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-3)+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)+3)
           +'                and Bill.BillKind = zc_bkSaleToClient()'
           +'              group by Bill.Id, Bill.BillDate'
           +'              having Bill.BillDate <> BillDate_calc'
           +'            union'
           +'             select Bill.Id, Bill.BillDate, max (fCalcCurrentBillDate_byPG (ScaleHistory.InsertDate,zc_rpTimeRemainsFree_H10()) ) as BillDate_calc'
           +'              from dba.Bill'
           +'                   join dba.ScaleHistory on ScaleHistory.BillId=Bill.Id'
           +'              where Bill.BillDate between ' + FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-3)+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)+3)
           +'                and Bill.BillKind = zc_bkSaleToClient()'
           +'              group by Bill.Id, Bill.BillDate'
           +'              having Bill.BillDate <> BillDate_calc) as a');
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as inInvNumber');
        Add('     , Bill.BillNumberNalog as inInvNumberPartner');
        Add('     , Bill.BillDate + isnull(_toolsView_Client_isChangeDate.addDay,0)  as inOperDate');

        Add('     , isnull(Bill.StatusId, zc_rvNo()) as StatusId');

        Add('     , Bill.isNds as inPriceWithVAT');
        Add('     , Bill.Nds as inVATPercent');
        Add('     , Bill.ToId');

        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , 9399 as inFromId');
        Add('     , _pgPartner.PartnerId_pg as inPartnerId');

        Add('     , '+zc_Enum_DocumentTaxKind_Tax+' as inDocumentTaxKindId');

        Add('     , Bill_find.CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');

        Add('     , trim(isnull (Information1.OKPO, isnull (Information2.OKPO,'+FormatToVarCharServer_notNULL('')+'))) as OKPO');
        Add('     , zc_rvYes() as zc_rvYes');

        Add('     , isnull(Bill.isRegistration,zc_rvNo())as isRegistration');
        Add('     , Bill.RegistrationDate');

        Add('     , Bill.Id_Postgres as Id_Postgres_two');
        Add('     , Bill.NalogId_PG as Id_Postgres');
        Add('from (select Bill.Id as BillId'
           +'           , max(case when isnull(Goods.ParentId,0) = 1730'
           +'                           then 30103'//(30103) Доходы Продукция Хлеб
           +'                      when BillItems.GoodsPropertyId = 5510'
           +'                        or Bill.FromId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
           +'                           then 30201'//(30201) Доходы Мясное сырье
           +'                      else 30101'//(30101) Доходы Продукция Готовая продукция
           +'                 end) as CodeIM'
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id'
           +'                             and BillItems.OperCount<>0'
           +'                             and BillItems.OperPrice<>0'
           //+'           left join dba.BillItems as BillItems_5510 on BillItems_5510.BillId = Bill.Id'
           //+'                                                    and BillItems_5510.GoodsPropertyId = 5510'//РУЛЬКА ВАРЕНАЯ в пакете для запекания
           +'           left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'           left join dba.Goods on Goods.Id = GoodsProperty.GoodsId'
           +'                           left outer join dba.Unit on Unit.Id = Bill.ToId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkSaleToClient())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'        and Bill.BillNumberNalog <> 0'
           +'        and Bill.FromId in (zc_UnitId_StoreSale(),zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
           +'        and Bill.Id_Postgres<>0'
           //+'        and BillItems_5510.BillId is null'
           +'        and (Bill.BillDate >=zc_def_StartDate_PG() or Bill.FromId=zc_UnitId_StoreSale())'
           +'      group by Bill.Id'
           +'      ) as Bill_find');

        Add('     left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.BillNumber'
                +'                           and _pgBillLoad.FromId=Bill.FromId');

        {Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                            left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Bill.ToId'}
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find'); // Contract_find.Id
        Add('     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                     ) as _pgPartner on _pgPartner.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');

        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');

        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');

        Add('     left outer join _pgList_tmp  on _pgList_tmp .Id = Bill.Id');
        Add('     left outer join dba._toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = UnitTo.ID'
           +'                                                       and _pgList_tmp.Id is null');
//  Add('where inInvNumberPartner in (3450)');
// Add('where Bill.BillNumber in (58445,58443)');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)))
        else
            if cblTaxPF.Checked
            then Add('where Bill.FromId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())')
            else
                if cbOnlyInsertDocument.Checked
                then Add('where isnull(Bill.NalogId_PG,0)=0');
        Add('order by inOperDate, inInvNumber, ObjectId');
        Open;

        Result:=RecordCount;
        cbTaxInt.Caption:='8.3.('+IntToStr(RecordCount)+') Налоговые Int';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Tax';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberBranch',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inDocument',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDocumentTaxKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_MovementLinkMovement_Sale';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inMovementChildId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDocumentTaxKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             //!!!УДАЛЯЕМ ВСЕ ЭЛЕМЕНТЫ!!!
             if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             then
                  fExecSqToQuery ('select gpMovementItem_Tax_SetErased (MovementItem.Id, zfCalc_UserAdmin()) from MovementItem where MovementId = '+FieldByName('Id_Postgres').AsString);
             //!!!!!!!!!!!!!!!!!!
             //
             //Номер филиала не должен измениться
                  fOpenSqToQuery (' select ValueData as InvNumberBranch'
                                 +' from MovementString'
                                 +' where MovementId='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 +'   and DescId = zc_MovementString_InvNumberBranch()'
                                 );
                  InvNumberBranch:=toSqlQuery.FieldByName('InvNumberBranch').AsString;
             // Пытаемся найти <Юр.Лицо>
                  fOpenSqToQuery (' select ObjectLink_Partner_Juridical.childobjectid as JuridicalId'
                                 +' from ObjectLink AS ObjectLink_Partner_Juridical'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(FieldByName('inPartnerId').AsInteger)
                                 +'   and ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 );
                  ToId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('inPartnerId').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('inInvNumberPartner').AsString;
             toStoredProc.Params.ParamByName('inInvNumberBranch').Value:=InvNumberBranch;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('inOperDate').AsDateTime;

             if FieldByName('StatusId').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inChecked').Value:=true else toStoredProc.Params.ParamByName('inChecked').Value:=false;
             if FieldByName('inPriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('inVATPercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('inFromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=ToId_pg;
             toStoredProc.Params.ParamByName('inPartnerId').Value:=FieldByName('inPartnerId').AsInteger;

             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inDocumentTaxKindId').Value:=FieldByName('inDocumentTaxKindId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres_two').AsInteger;
                       toStoredProc_two.Params.ParamByName('inMovementChildId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inDocumentTaxKindId').Value:=FieldByName('inDocumentTaxKindId').AsInteger;
                       if not myExecToStoredProc_two then ;
             //
             if (FieldByName('isRegistration').AsInteger=zc_rvYes)
             then begin
                       fOpenSqToQuery('select * from lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', '+FormatToDateServer_notNULL(FieldByName('RegistrationDate').AsDateTime)+')');
                       fOpenSqToQuery('select * from lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', TRUE)');
             end;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbTaxInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!Integer
procedure TMainForm.pLoadDocumentItem_Tax_Int(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbTaxInt.Checked)or(not cbTaxInt.Enabled) then exit;
     //
     myEnabledCB(cbTaxInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.NalogId_PG as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , -1 * BillItems.OperCount as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , zc_rvYes() as isFl');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+KindPackage_f.KindPackageName+'+FormatToVarCharServer_notNULL(')')
           +'            when KindPackage.Id is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');

        Add('     , BillItems.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.BillNumber'
                +'                           and _pgBillLoad.FromId=Bill.FromId');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_f on GoodsProperty_f.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage as KindPackage_f on KindPackage_f.Id = BillItems.KindPackageId');

        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSaleToClient())'
           +'  and Bill.NalogId_PG>0'
//           +'  and BillItems.GoodsPropertyId<>1041' //КОВБАСНI ВИРОБИ
           +'  and BillItems.OperPrice<>0'
           +'  and BillItems.OperCount<>0'
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );
        if cblTaxPF.Checked
        then Add(' and Bill.FromId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())')
        else
            if cbOnlyInsertDocument.Checked
            then Add('and isnull(BillItems.NalogId_PG,0)=0');
        Add('order by 2,3,1');
        Open;

        //cbTaxInt.Caption:='8.3.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Налоговые Int';
        cbTaxInt.Caption:='8.3.('+IntToStr(SaveCount)+')(нет)Налоговые Int';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
{!!!!!НЕТ!!!!!!!
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Tax';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //!!!ВОССТАНАВЛИВАЕМ 1 ЭЛЕМЕНТ!!
             if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             then
                  fExecSqToQuery ('select * from gpMovementItem_Tax_SetUnErased ('+FieldByName('Id_Postgres').AsString+', zfCalc_UserAdmin())');
             //!!!!!!!!!!!!!!!!!!
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecSqFromQuery('update dba.BillItems set NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
!!!!!НЕТ!!!!!!!}
     end;
     //
     myDisabledCB(cbTaxInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pCompleteDocument_TaxFl;
begin
     if (not cbCompleteTaxFl.Checked)or(not cbCompleteTaxFl.Enabled) then exit;
     //
     myEnabledCB(cbCompleteTaxFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast(Bill.BillNumber as integer)as InvNumber');
        Add('     , Bill.FromID');
        Add('     , Bill.ToID');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as Client on Client.ID = Bill.ToId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkSaleToClient())'
           +'  and Bill.NalogId_PG>0');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteTaxFl.Caption:='8.1.('+IntToStr(RecordCount)+')Налоговые Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  // проводим
                  fExecSqToQuery (' UPDATE Movement SET StatusId = zc_Enum_Status_Complete()'
                                 +' where Id='+FieldByName('Id_Postgres').AsString);
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteTaxFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
function TMainForm.pLoadDocument_Tax_Fl:Integer;
var ContractId_pg,ToId_pg:Integer;
    zc_Enum_DocumentTaxKind_Tax,zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS,zc_Enum_DocumentTaxKind_TaxSummaryPartnerS:String;
    zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR:String;
    InvNumberBranch:String;
begin
     Result:=0;
     if (not cbTaxFl.Checked)or(not cbTaxFl.Enabled) then exit;
     //
     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_Tax() as RetV');
     zc_Enum_DocumentTaxKind_Tax:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS() as RetV');
     zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_TaxSummaryPartnerS() as RetV');
     zc_Enum_DocumentTaxKind_TaxSummaryPartnerS:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() as RetV');
     zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR:=toSqlQuery.FieldByName('RetV').AsString;
     //
     myEnabledCB(cbTaxFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , case when isnull(Bill_find.findId1,0)>0 and isnull(OperCount1,0)=0 and inDocumentTaxKindId='+zc_Enum_DocumentTaxKind_Tax+' then '+FormatToVarCharServer_notNULL('-ошибка-')+' else '+FormatToVarCharServer_notNULL('')+' end || Bill.BillNumber as inInvNumber');
        Add('     , case when isnull(Bill_find.findId1,0)>0 and isnull(OperCount1,0)=0 and inDocumentTaxKindId='+zc_Enum_DocumentTaxKind_Tax+' then zc_rvYes() else zc_rvNo() end as isErr');

        Add('     , Bill.BillNumberNalog as inInvNumberPartner');
        Add('     , Bill.BillDate as inOperDate');

        Add('     , isnull(Bill.StatusId, zc_rvNo()) as StatusId');

        Add('     , Bill.isNds as inPriceWithVAT');
        Add('     , Bill.Nds as inVATPercent');
        Add('     , Bill.ToId');

        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , 9399 as inFromId');
        Add('     , _pgPartner.PartnerId_pg as inPartnerId');

        //Add('     , case when Bill.ToId in (2535,2842,5887) then '+zc_Enum_DocumentTaxKind_TaxSummaryPartnerS //  ФУДМАРКЕТ ВМ № 05,Вел.Киш.,Дн-вск,Зоряний,1-а
        Add('     , case when Bill.ToId in (2842,5887) then '+zc_Enum_DocumentTaxKind_TaxSummaryPartnerS //  ФУДМАРКЕТ ВМ № 05,Вел.Киш.,Дн-вск,Зоряний,1-а
                                                                                                             // + ФУДМАРКЕТ ВК № 51,Жовт.Води Вел. киш
                                                                                                             // + ВК №51 ЖОВТІ ВОДИ,КРАПОТКІНА,35А 37830

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('38939423')//ЕКСПАНСІЯ
           +'                         ,'+FormatToVarCharServer_notNULL('30982361')//ОМЕГА
           +'                         ,'+FormatToVarCharServer_notNULL('32294897')//ФОРА
           +'                         ,'+FormatToVarCharServer_notNULL('38101395')//!!!add!!!РИТЕЛЛ ТОВ договор № 200155
           +'                         )'
           +'                 then '+zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('32294926')+')'//ФОЗЗИ ПРИВАТ
           +'             and (ContractNumber='+FormatToVarCharServer_notNULL('3037')
           +'               or ContractNumber='+FormatToVarCharServer_notNULL('3036')+')'
           +'                 then '+zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR

           +'            when OKPO ='+FormatToVarCharServer_notNULL('01073931')//Приднiпровська залiзниця ДП (хлеб)
           +'             and (Bill_find.CodeIM='+FormatToVarCharServer_notNULL('30103')
           +'               or (Bill.BillNumber='+FormatToVarCharServer_notNULL('137813')
           +'               and Bill.BillDate='+FormatToDateServer_notNULL(StrToDate('12.12.2013'))+'))'
           +'                 then '+zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('36439679')
           +'                         ,'+FormatToVarCharServer_notNULL('35275230')
           +'                         ,'+FormatToVarCharServer_notNULL('38381998')
           +'                         ,'+FormatToVarCharServer_notNULL('36988353')
           +'                         ,'+FormatToVarCharServer_notNULL('38316777')
           +'                         ,'+FormatToVarCharServer_notNULL('33478778')
           +'                         ,'+FormatToVarCharServer_notNULL('24541083')
           +'                         ,'+FormatToVarCharServer_notNULL('37672913')
           +'                         ,'+FormatToVarCharServer_notNULL('38722196')
           +'                         ,'+FormatToVarCharServer_notNULL('37678707')
           +'                         ,'+FormatToVarCharServer_notNULL('37060369')//КОПЕЙКА* ТД ТОВ дог.385 01.06.2013 ковб.
           +'                         ,'+FormatToVarCharServer_notNULL('32967633')
           +'                         ,'+FormatToVarCharServer_notNULL('37470510')
           +'                         ,'+FormatToVarCharServer_notNULL('38157537')
           +'                         ,'+FormatToVarCharServer_notNULL('33184262')
           +'                         ,'+FormatToVarCharServer_notNULL('30344629')
           +'                         ,'+FormatToVarCharServer_notNULL('31929492')
           +'                         ,'+FormatToVarCharServer_notNULL('19202597')
           +'                         ,'+FormatToVarCharServer_notNULL('32334104')
           +'                         ,'+FormatToVarCharServer_notNULL('38685495')
           +'                         ,'+FormatToVarCharServer_notNULL('34604386')
           +'                         ,'+FormatToVarCharServer_notNULL('30512339')
           +'                         ,'+FormatToVarCharServer_notNULL('32294926')
           +'                         ,'+FormatToVarCharServer_notNULL('23494714')//ГРАНД-МАРКЕТ ТОВ УЛ.
           +'                         ,'+FormatToVarCharServer_notNULL('38978614')//ГРАНД-МАРКЕТ
           +'                         )'
           +'                 then '+zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS
           +'            else '+zc_Enum_DocumentTaxKind_Tax
           +'       end as inDocumentTaxKindId');

        Add('     , Bill_find.CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');

        Add('     , trim(isnull (Information1.OKPO, isnull (Information2.OKPO,'+FormatToVarCharServer_notNULL('')+'))) as OKPO');
        Add('     , zc_rvYes() as zc_rvYes');

        Add('     , isnull(Bill.isRegistration,zc_rvNo())as isRegistration');
        Add('     , Bill.RegistrationDate');

        Add('     , Bill.Id_Postgres as Id_Postgres_two');
        Add('     , Bill.NalogId_PG as Id_Postgres');
        Add('from (select Bill.Id as BillId'
           +'           , max(case when isnull(Goods.ParentId,0) = 1730'
           +'                           then 30103'//(30103) Доходы Продукция Хлеб
           +'                      when Goods.Id = 2514 and 1=0'
           +'                           then 30201'//(30201) Доходы Мясное сырье
           +'                      else 30101'//(30101) Доходы Продукция Готовая продукция
           +'                 end) as CodeIM'
           +'           , max(isnull(BillItems.OperCount,0)) as OperCount1'
           +'           , max(isnull(BillItems_byParent.OperCount,0)) as OperCount2'
           +'           , max(isnull(BillItems_byParent.Id,0)) as findId1'
           +'           , max(isnull(BillItems_byParent_find.Id,0)) as findId2'
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id'
           +'                             and BillItems.GoodsPropertyId<>1041' // КОВБАСНI ВИРОБИ
           +'           left join dba.BillItems_byParent on BillItems_byParent.BillItemsId = BillItems.Id'
           +'           left join dba.BillItems_byParent as BillItems_byParent_find on BillItems_byParent_find.ParentBillItemsId = BillItems.Id and BillItems_byParent_find.ParentBillItemsId<>BillItems_byParent_find.BillItemsId'
           +'           left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'           left join dba.Goods on Goods.Id = GoodsProperty.GoodsId'

           +'                           left outer join dba.Unit on Unit.Id = Bill.ToId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')

           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkSaleToClient())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'        and Bill.BillNumberNalog <> 0'
           +'        and (BillItems.OperCount <> 0 or isnull(BillItems_byParent.OperCount,0) <> 0 or BillItems_byParent_find.ParentBillItemsId is not null)'
           +'      group by Bill.Id'
           +'      having isnull (findId1,0) = 0 or isnull (findId2,0) <> 0 or isnull (OperCount2,0)<>0'
           +'      ) as Bill_find');

        Add('     left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        Add('     left outer join dba.Bill_i AS Bill_find_i on Bill_find_i.Id = Bill.BillId_byLoad');
        {Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                            left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Bill.ToId'}
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find'); // Contract_find.Id
        Add('     left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId'
           +'                     ) as Unit_byLoad_To on Unit_byLoad_To.UnitId = Bill.ToId'
           +'                                        and Bill_find_i.Id is null');
        Add('     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                     ) as _pgPartner on _pgPartner.UnitId = isnull (Bill_find_i.ToId, Unit_byLoad_To.Id_byLoad)');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');

        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = case when Bill.FromId in (1388' //ГРИВА Р.
           +'                                                                             , 1799' //ДРОВОРУБ
           +'                                                                             , 1288' //ИЩИК К.
           +'                                                                             , 956' //КОЖУШКО С.
           +'                                                                             , 1390' //НЯЙКО В.
           +'                                                                             , 5460' //ОЛЕЙНИК М.В.
           +'                                                                             , 324' //СЕМЕНЕВ С.
           +'                                                                             , 3010' //ТАТАРЧЕНКО Е.
           +'                                                                             , 5446' //ТКАЧЕНКО ЛЮБОВЬ
           +'                                                                             , 4792' //ТРЕТЬЯКОВ О.Н.
           +'                                                                             , 980' //ТУЛЕНКО С.
           +'                                                                             , 2436' //ШЕВЦОВ И.
           +'                                                                             , 1374' //БУФАНОВ Д.

           +'                                                                             , 1022' //ВИЗАРД 1
           +'                                                                             , 1037' //ВИЗАРД 1037
           +'                                                                              ) then 5 else Bill.FromId end');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');

        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');
//  Add('where inInvNumberPartner in (3450)');
// Add('where Bill.BillNumber in (58445,58443)');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)))
        else
            if cbOnlyInsertDocument.Checked
            then Add('where isnull(Bill.NalogId_PG,0)=0')
            else
                if cbErr.Checked
                then Add(' where isErr = zc_rvYes()');
        Add('order by inOperDate, inInvNumber, ObjectId');
        Open;


        Result:=RecordCount;
        cbTaxFl.Caption:='8.1.('+IntToStr(RecordCount)+') Налоговые Fl';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Tax';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberBranch',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inDocument',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDocumentTaxKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_MovementLinkMovement_Sale';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inMovementChildId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDocumentTaxKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             //Номер филиала не должен измениться
                  fOpenSqToQuery (' select ValueData as InvNumberBranch'
                                 +' from MovementString'
                                 +' where MovementId='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 +'   and DescId = zc_MovementString_InvNumberBranch()'
                                 );
                  InvNumberBranch:=toSqlQuery.FieldByName('InvNumberBranch').AsString;
             // Пытаемся найти <Юр.Лицо>
                  fOpenSqToQuery (' select ObjectLink_Partner_Juridical.childobjectid as JuridicalId'
                                 +' from ObjectLink AS ObjectLink_Partner_Juridical'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(FieldByName('inPartnerId').AsInteger)
                                 +'   and ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 );
                  ToId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('inPartnerId').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('inInvNumberPartner').AsString;
             toStoredProc.Params.ParamByName('inInvNumberBranch').Value:=InvNumberBranch;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('inOperDate').AsDateTime;

             if FieldByName('StatusId').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inChecked').Value:=true else toStoredProc.Params.ParamByName('inChecked').Value:=false;
             if FieldByName('inPriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('inVATPercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('inFromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=ToId_pg;
             if (FieldByName('inDocumentTaxKindId').AsString<>zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS)
             and(FieldByName('inDocumentTaxKindId').AsString<>zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR)
             then toStoredProc.Params.ParamByName('inPartnerId').Value:=FieldByName('inPartnerId').AsInteger
             else toStoredProc.Params.ParamByName('inPartnerId').Value:=0;

             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inDocumentTaxKindId').Value:=FieldByName('inDocumentTaxKindId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres_two').AsInteger;
                       toStoredProc_two.Params.ParamByName('inMovementChildId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inDocumentTaxKindId').Value:=FieldByName('inDocumentTaxKindId').AsInteger;
                       if not myExecToStoredProc_two then ;
             //
             if (FieldByName('isRegistration').AsInteger=zc_rvYes)
             then begin
                       fOpenSqToQuery('select * from lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', '+FormatToDateServer_notNULL(FieldByName('RegistrationDate').AsDateTime)+')');
                       fOpenSqToQuery('select * from lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', TRUE)');
             end;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)
             then fExecFlSqFromQuery('update dba.Bill set NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbTaxFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pLoadDocumentItem_Tax_Fl(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbTaxFl.Checked)or(not cbTaxFl.Enabled) then exit;
     //
     myEnabledCB(cbTaxFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.NalogId_PG as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , isnull(BillItems_byParent.OperCount, -1 * BillItems.OperCount) as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , zc_rvYes() as isFl');
        Add('     , case when isnull(BillItems_byParent.Id,0)<>0 and BillItems_byParent.OperCount<>-BillItems.OperCount and BillItems.OperCount<>0 then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка кол-во')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+KindPackage_f.KindPackageName+'+FormatToVarCharServer_notNULL(')')
           +'            when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+KindPackage_f.KindPackageName+'+FormatToVarCharServer_notNULL(')')
           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');

        Add('     , BillItems.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.BillItems_byParent on BillItems_byParent.BillItemsId = BillItems.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_f on GoodsProperty_f.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage as KindPackage_f on KindPackage_f.Id = BillItems.KindPackageId');

        Add('     left outer join (select max(GoodsProperty_Detail_byLoad.Id_byLoad) as Id_byLoad, GoodsPropertyId, KindPackageId from dba.GoodsProperty_Detail_byLoad where GoodsProperty_Detail_byLoad.Id_byLoad<>0 group by GoodsPropertyId, KindPackageId');
        Add('                     ) as GoodsProperty_Detail_byLoad on GoodsProperty_Detail_byLoad.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('                                                     and GoodsProperty_Detail_byLoad.KindPackageId = BillItems.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Detail_byServer on GoodsProperty_Detail_byServer.Id = GoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     left outer join dba.GoodsProperty_i as GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail_byServer.GoodsPropertyId');
        Add('     left outer join dba.Goods_i as Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSaleToClient())'
           +'  and Bill.NalogId_PG>0'
           +'  and BillItems.GoodsPropertyId<>1041' //КОВБАСНI ВИРОБИ
           +'  and BillItems.OperPrice<>0'
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.NalogId_PG,0)=0');
        Add('order by 2,3,1');
        Open;

        cbTaxFl.Caption:='8.1.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Налоговые Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Tax';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecFlSqFromQuery('update dba.BillItems set NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbTaxFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pCompleteDocument_TaxCorrective(isLastComplete:Boolean);
begin
     if (not cbCompleteTaxCorrective.Checked)or(not cbCompleteTaxCorrective.Enabled) then exit;
     //
     myEnabledCB(cbCompleteTaxCorrective);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast(Bill.BillNumber as integer)as InvNumber');
        Add('     , Bill.FromID');
        Add('     , Bill.ToID');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , Bill.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as Client on Client.ID = Bill.FromId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit())'
           +'  and Bill.NalogId_PG>0');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;
        Add('union all');
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast(Bill.BillNumber as integer)as InvNumber');
        Add('     , Bill.FromID');
        Add('     , Bill.ToID');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , BillItems_byParent.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        Add('     join dba.BillItems_byParent on BillItems_byParent.BillId=Bill.ID');
        Add('     left outer join dba.Unit as Client on Client.ID = Bill.FromId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit())'
           +'  and BillItems_byParent.NalogId_PG>0');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;
        Add('group by Bill.Id');
        Add('       , Bill.BillDate');
        Add('       , Bill.BillNumber');
        Add('       , Bill.FromID');
        Add('       , Bill.ToID');
        Add('       , Bill.MoneyKindId');
        Add('       , BillItems_byParent.NalogId_PG');

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteTaxCorrective.Caption:='8.2.('+IntToStr(RecordCount)+')Корректировки Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  // проводим
                  fExecSqToQuery (' UPDATE Movement SET StatusId = zc_Enum_Status_Complete()'
                                 +' where Id='+FieldByName('Id_Postgres').AsString);
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteTaxCorrective);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
function TMainForm.pLoadDocument_TaxCorrective_Fl:Integer;
var ContractId_pg,FromId_pg:Integer;
    zc_Enum_DocumentTaxKind_Corrective:String;
    zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR,zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR:String;
    zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR,zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR:String;
    InvNumberBranch:String;
begin
     Result:=0;
     if (not cbTaxCorrective.Checked)or(not cbTaxCorrective.Enabled) then exit;
     //
     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_Corrective() as RetV');
     zc_Enum_DocumentTaxKind_Corrective:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR() as RetV');
     zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR() as RetV');
     zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR() as RetV');
     zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR:=toSqlQuery.FieldByName('RetV').AsString;

     fOpenSqToQuery ('select zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR() as RetV');
     zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR:=toSqlQuery.FieldByName('RetV').AsString;
     //
     myEnabledCB(cbTaxCorrective);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , case when inDocumentTaxKindId_calc<>'+zc_Enum_DocumentTaxKind_Corrective+' then '+FormatToVarCharServer_notNULL('-ошибка-')+' else '+FormatToVarCharServer_notNULL('')+' end || Bill.BillNumber as inInvNumber');
        Add('     , case when inDocumentTaxKindId_calc<>'+zc_Enum_DocumentTaxKind_Corrective+' then zc_rvYes() else zc_rvNo() end as isErr');
        Add('     , Bill.BillDate as inOperDate');

        Add('     , Bill.BillNumberNalog as inInvNumberPartner');
        Add('     , 0 as BillId_nalog');

        Add('     , isnull(Bill.StatusId, zc_rvNo()) as StatusId');
        Add('     , case when isnull(Bill.BillNumberClient2, '+FormatToVarCharServer_notNULL('')+') = '+FormatToVarCharServer_notNULL('1')+' then zc_rvYes() else zc_rvNo() end as DocId');

        Add('     , Bill.isNds as inPriceWithVAT');
        Add('     , Bill.Nds as inVATPercent');
        Add('     , Bill.FromId');

        Add('     , _pgPartner.PartnerId_pg as inPartnerId');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , 9399 as inToId');

        //Add('     , case when Bill.FromId in (2535,2842,5887) then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR //  ФУДМАРКЕТ ВМ № 05,Вел.Киш.,Дн-вск,Зоряний,1-а
        Add('     , case when Bill.FromId in (2842,5887) then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR //  ФУДМАРКЕТ ВМ № 05,Вел.Киш.,Дн-вск,Зоряний,1-а
                                                                                                                       // + ФУДМАРКЕТ ВК № 51,Жовт.Води Вел. киш
                                                                                                                       // + ВК №51 ЖОВТІ ВОДИ,КРАПОТКІНА,35А 37830
           +'            when OKPO in ('+FormatToVarCharServer_notNULL('38939423')//ЕКСПАНСІЯ
           +'                         ,'+FormatToVarCharServer_notNULL('30982361')//ОМЕГА
           +'                         ,'+FormatToVarCharServer_notNULL('32294897')//ФОРА
           +'                         ,'+FormatToVarCharServer_notNULL('38101395')//!!!add!!!РИТЕЛЛ ТОВ договор № 200155
           +'                         )'
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('32294926')+')'//ФОЗЗИ ПРИВАТ
           +'             and (ContractNumber='+FormatToVarCharServer_notNULL('3037')
           +'               or ContractNumber='+FormatToVarCharServer_notNULL('3036')+')'
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR

           +'            when OKPO ='+FormatToVarCharServer_notNULL('01073931')//Приднiпровська залiзниця ДП (хлеб)
           +'             and Bill_find.CodeIM='+FormatToVarCharServer_notNULL('30103')
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('36439679')
           +'                         ,'+FormatToVarCharServer_notNULL('35275230')
           +'                         ,'+FormatToVarCharServer_notNULL('38381998')
           +'                         ,'+FormatToVarCharServer_notNULL('36988353')
           +'                         ,'+FormatToVarCharServer_notNULL('38316777')
           +'                         ,'+FormatToVarCharServer_notNULL('33478778')
           +'                         ,'+FormatToVarCharServer_notNULL('24541083')
           +'                         ,'+FormatToVarCharServer_notNULL('37672913')
           +'                         ,'+FormatToVarCharServer_notNULL('38722196')
           +'                         ,'+FormatToVarCharServer_notNULL('37678707')
           +'                         ,'+FormatToVarCharServer_notNULL('37060369')//КОПЕЙКА* ТД ТОВ дог.385 01.06.2013 ковб.
           +'                         ,'+FormatToVarCharServer_notNULL('32967633')
           +'                         ,'+FormatToVarCharServer_notNULL('37470510')
           +'                         ,'+FormatToVarCharServer_notNULL('38157537')
           +'                         ,'+FormatToVarCharServer_notNULL('33184262')
           +'                         ,'+FormatToVarCharServer_notNULL('30344629')
           +'                         ,'+FormatToVarCharServer_notNULL('31929492')
           +'                         ,'+FormatToVarCharServer_notNULL('19202597')
           +'                         ,'+FormatToVarCharServer_notNULL('32334104')
           +'                         ,'+FormatToVarCharServer_notNULL('38685495')
           +'                         ,'+FormatToVarCharServer_notNULL('34604386')
           +'                         ,'+FormatToVarCharServer_notNULL('30512339')
           +'                         ,'+FormatToVarCharServer_notNULL('32294926')
           +'                         ,'+FormatToVarCharServer_notNULL('23494714')//ГРАНД-МАРКЕТ ТОВ УЛ.
           +'                         ,'+FormatToVarCharServer_notNULL('38978614')//ГРАНД-МАРКЕТ
           +'                         )'
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR
           +'            else '+zc_Enum_DocumentTaxKind_Corrective
           +'       end as inDocumentTaxKindId_calc'
           +'     , '+zc_Enum_DocumentTaxKind_Corrective+' as inDocumentTaxKindId');

        Add('     , Bill_find.CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');

        Add('     , trim(isnull (Information1.OKPO, isnull (Information2.OKPO,'+FormatToVarCharServer_notNULL('')+'))) as OKPO');

        Add('     , isnull(Bill.isRegistration,zc_rvNo())as isRegistration');
        Add('     , Bill.RegistrationDate');

        Add('     , zc_rvNo() as isDetail');
        Add('     , Bill.Id_Postgres as Id_Postgres_Master');
        Add('     , 0 as Id_Postgres_Child');
        Add('     , Bill.NalogId_PG as Id_Postgres');

        Add('from (select Bill.Id as BillId'
           +'           , max(case when isnull(Goods.ParentId,0) = 1730'
           +'                           then 30103'//(30103) Доходы Продукция Хлеб
           +'                      when Goods.Id = 2514 and 1=0'
           +'                           then 30201'//(30201) Доходы Мясное сырье
           +'                      else 30101'//(30101) Доходы Продукция Готовая продукция
           +'                 end) as CodeIM'
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id'
//           +'                             and BillItems.GoodsPropertyId<>1041' // КОВБАСНI ВИРОБИ
           +'           left join dba.BillItems_byParent on BillItems_byParent.BillID=Bill.ID'
           +'           left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'           left join dba.Goods on Goods.Id = GoodsProperty.GoodsId'
           +'                           left outer join dba.Unit on Unit.Id = Bill.FromId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'        and Bill.BillNumberNalog <> 0'
           +'        and BillItems_byParent.BillID is null'
           +'      group by Bill.Id'
           +'      ) as Bill_find');
        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        {Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                            left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Bill.FromId'}
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find');//Contract_find.Id
        Add('     left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId'
           +'                     ) as Unit_byLoad_From on Unit_byLoad_From.UnitId = Bill.FromId');
        Add('     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                     ) as _pgPartner on _pgPartner.UnitId = Unit_byLoad_From.Id_byLoad');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = case when Bill.ToId in (1388' //ГРИВА Р.
           +'                                                                             , 1799' //ДРОВОРУБ
           +'                                                                             , 1288' //ИЩИК К.
           +'                                                                             , 956' //КОЖУШКО С.
           +'                                                                             , 1390' //НЯЙКО В.
           +'                                                                             , 5460' //ОЛЕЙНИК М.В.
           +'                                                                             , 324' //СЕМЕНЕВ С.
           +'                                                                             , 3010' //ТАТАРЧЕНКО Е.
           +'                                                                             , 5446' //ТКАЧЕНКО ЛЮБОВЬ
           +'                                                                             , 4792' //ТРЕТЬЯКОВ О.Н.
           +'                                                                             , 980' //ТУЛЕНКО С.
           +'                                                                             , 2436' //ШЕВЦОВ И.
           +'                                                                             , 1374' //БУФАНОВ Д.

           +'                                                                             , 1022' //ВИЗАРД 1
           +'                                                                             , 1037' //ВИЗАРД 1037
           +'                                                                              ) then 5 else Bill.ToId end');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
 //Add('where Bill.BillNumber in (136565)');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)))
        else
            if cbOnlyInsertDocument.Checked
            then Add('where isnull(Bill.NalogId_PG,0)=0')
            else
                if cbErr.Checked
                then Add(' where isErr = zc_rvYes()')
                else
                    if cbTotalTaxCorr.Checked
                    then Add(' where isErr = zc_rvNo()');

        Add('union all');

        Add('select Bill.Id as ObjectId');
        Add('     , case when Bill_find.OperCount1=0 and inDocumentTaxKindId_calc = '+zc_Enum_DocumentTaxKind_Corrective+' then '+FormatToVarCharServer_notNULL('-ошибка-')
           +'            else '+FormatToVarCharServer_notNULL('')+' end || Bill.BillNumber as inInvNumber');
        Add('     , case when Bill_find.OperCount1=0 and inDocumentTaxKindId_calc = '+zc_Enum_DocumentTaxKind_Corrective+' then zc_rvYes()'
           +'            else zc_rvNo() end as isErr');
        Add('     , Bill.BillDate as inOperDate');

        Add('     , Bill_find.inInvNumberPartner');
        Add('     , Bill_find.BillId_nalog');

        Add('     , isnull(Bill.StatusId, zc_rvNo()) as StatusId');
        Add('     , case when isnull(Bill.BillNumberClient2, '+FormatToVarCharServer_notNULL('')+') = '+FormatToVarCharServer_notNULL('1')+' then zc_rvYes() else zc_rvNo() end as DocId');

        Add('     , Bill.isNds as inPriceWithVAT');
        Add('     , Bill.Nds as inVATPercent');
        Add('     , Bill.FromId');

        Add('     , _pgPartner.PartnerId_pg as inPartnerId');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , 9399 as inToId');

        //Add('     , case when Bill.FromId in (2535,2842,5887) then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR //  ФУДМАРКЕТ ВМ № 05,Вел.Киш.,Дн-вск,Зоряний,1-а
        Add('     , case when Bill.FromId in (2842,5887) then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR //  ФУДМАРКЕТ ВМ № 05,Вел.Киш.,Дн-вск,Зоряний,1-а
                                                                                                                  // + ФУДМАРКЕТ ВК № 51,Жовт.Води Вел. киш
                                                                                                                  // + ВК №51 ЖОВТІ ВОДИ,КРАПОТКІНА,35А 37830
           +'            when OKPO in ('+FormatToVarCharServer_notNULL('38939423')//ЕКСПАНСІЯ
           +'                         ,'+FormatToVarCharServer_notNULL('30982361')//ОМЕГА
           +'                         ,'+FormatToVarCharServer_notNULL('32294897')//ФОРА
           +'                         ,'+FormatToVarCharServer_notNULL('38101395')//!!!add!!!РИТЕЛЛ ТОВ договор № 200155
           +'                         )'
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('32294926')+')'//ФОЗЗИ ПРИВАТ
           +'             and (ContractNumber='+FormatToVarCharServer_notNULL('3037')
           +'               or ContractNumber='+FormatToVarCharServer_notNULL('3036')+')'
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR

           +'            when OKPO ='+FormatToVarCharServer_notNULL('01073931')//Приднiпровська залiзниця ДП (хлеб)
           +'             and Bill_find.CodeIM='+FormatToVarCharServer_notNULL('30103')
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR

           +'            when OKPO in ('+FormatToVarCharServer_notNULL('36439679')
           +'                         ,'+FormatToVarCharServer_notNULL('35275230')
           +'                         ,'+FormatToVarCharServer_notNULL('38381998')
           +'                         ,'+FormatToVarCharServer_notNULL('36988353')
           +'                         ,'+FormatToVarCharServer_notNULL('38316777')
           +'                         ,'+FormatToVarCharServer_notNULL('33478778')
           +'                         ,'+FormatToVarCharServer_notNULL('24541083')
           +'                         ,'+FormatToVarCharServer_notNULL('37672913')
           +'                         ,'+FormatToVarCharServer_notNULL('38722196')
           +'                         ,'+FormatToVarCharServer_notNULL('37678707')
           +'                         ,'+FormatToVarCharServer_notNULL('37060369')//КОПЕЙКА* ТД ТОВ дог.385 01.06.2013 ковб.
           +'                         ,'+FormatToVarCharServer_notNULL('32967633')
           +'                         ,'+FormatToVarCharServer_notNULL('37470510')
           +'                         ,'+FormatToVarCharServer_notNULL('38157537')
           +'                         ,'+FormatToVarCharServer_notNULL('33184262')
           +'                         ,'+FormatToVarCharServer_notNULL('30344629')
           +'                         ,'+FormatToVarCharServer_notNULL('31929492')
           +'                         ,'+FormatToVarCharServer_notNULL('19202597')
           +'                         ,'+FormatToVarCharServer_notNULL('32334104')
           +'                         ,'+FormatToVarCharServer_notNULL('38685495')
           +'                         ,'+FormatToVarCharServer_notNULL('34604386')
           +'                         ,'+FormatToVarCharServer_notNULL('30512339')
           +'                         ,'+FormatToVarCharServer_notNULL('32294926')
           +'                         ,'+FormatToVarCharServer_notNULL('23494714')//ГРАНД-МАРКЕТ ТОВ УЛ.
           +'                         ,'+FormatToVarCharServer_notNULL('38978614')//ГРАНД-МАРКЕТ
           +'                         )'
           +'                 then '+zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR
           +'            else '+zc_Enum_DocumentTaxKind_Corrective
           +'       end as inDocumentTaxKindId_calc');

        Add('     , inDocumentTaxKindId_calc as inDocumentTaxKindId');

        Add('     , Bill_find.CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');

        Add('     , trim(isnull (Information1.OKPO, isnull (Information2.OKPO,'+FormatToVarCharServer_notNULL('')+'))) as OKPO');

        Add('     , isnull(Bill.isRegistration,zc_rvNo())as isRegistration');
        Add('     , Bill.RegistrationDate');

        Add('     , zc_rvYes() as isDetail');
        Add('     , case when inDocumentTaxKindId <>'+zc_Enum_DocumentTaxKind_Corrective+' then 0 else Bill.Id_Postgres end as Id_Postgres_Master');
        Add('     , Bill_find.Id_Postgres_Child');
        Add('     , Bill_find.NalogId_PG as Id_Postgres');

        Add('from (select Bill.Id as BillId'
           +'           , Bill_nalog.Id AS BillId_nalog'
           +'           , Bill_nalog.NalogId_PG as Id_Postgres_Child'
           +'           , max(isnull(BillItems_byParent.NalogId_PG,0)) as NalogId_PG'
           +'           , BillItems_byParent.addBillNumber as inInvNumberPartner'
           +'           , max(case when isnull(Goods.ParentId,0) = 1730'
           +'                           then 30103'//(30103) Доходы Продукция Хлеб
           +'                      when Goods.Id = 2514 and 1=0'
           +'                           then 30201'//(30201) Доходы Мясное сырье
           +'                      else 30101'//(30101) Доходы Продукция Готовая продукция
           +'                 end) as CodeIM'
           +'           , max(BillItems.OperCount) as OperCount1'
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
           +'      from dba.Bill'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id'
//           +'                             and BillItems.GoodsPropertyId<>1041' // КОВБАСНI ВИРОБИ
           +'           join dba.BillItems_byParent on BillItems_byParent.BillItemsId=BillItems.ID'
           +'           left join dba.BillItems as BillItems_nalog on BillItems_nalog.Id = BillItems_byParent.ParentBillItemsId'
           +'           left join dba.Bill as Bill_nalog on Bill_nalog.Id = BillItems_nalog.BillId'
           +'           left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'           left join dba.Goods on Goods.Id = GoodsProperty.GoodsId'
           +'                           left outer join dba.Unit on Unit.Id = Bill.FromId'
           +'                           left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and Bill.BillDate between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and Bill.BillDate between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           //+'        and Bill.BillNumberNalog <> 0'
           +'        and BillItems_byParent.OperCount<>0'
           +'      group by Bill.Id'
           +'           , BillId_nalog'
           +'           , Id_Postgres_Child'
           +'           , inInvNumberPartner'
           +'      ) as Bill_find');
        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        {Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
           +'                           from dba.Unit'
           +'                            left outer join dba.ContractKind_byHistory as find1'
           +'                                on find1.ClientId = Unit.DolgByUnitID'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
           +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           left outer join dba.ContractKind_byHistory as find2'
           +'                               on find2.ClientId = Unit.Id'
           +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
           +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
           +'                           group by Unit.Id'
           +'                          ) as Contract_find on Contract_find.ClientId = Bill.FromId'}
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find');//Contract_find.Id
        Add('     left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId'
           +'                     ) as Unit_byLoad_From on Unit_byLoad_From.UnitId = Bill.FromId');
        Add('     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                     ) as _pgPartner on _pgPartner.UnitId = Unit_byLoad_From.Id_byLoad');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = case when Bill.ToId in (1388' //ГРИВА Р.
           +'                                                                             , 1799' //ДРОВОРУБ
           +'                                                                             , 1288' //ИЩИК К.
           +'                                                                             , 956' //КОЖУШКО С.
           +'                                                                             , 1390' //НЯЙКО В.
           +'                                                                             , 5460' //ОЛЕЙНИК М.В.
           +'                                                                             , 324' //СЕМЕНЕВ С.
           +'                                                                             , 3010' //ТАТАРЧЕНКО Е.
           +'                                                                             , 5446' //ТКАЧЕНКО ЛЮБОВЬ
           +'                                                                             , 4792' //ТРЕТЬЯКОВ О.Н.
           +'                                                                             , 980' //ТУЛЕНКО С.
           +'                                                                             , 2436' //ШЕВЦОВ И.
           +'                                                                             , 1374' //БУФАНОВ Д.

           +'                                                                             , 1022' //ВИЗАРД 1
           +'                                                                             , 1037' //ВИЗАРД 1037
           +'                                                                              ) then 5 else Bill.ToId end');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)))
        else
            if cbOnlyInsertDocument.Checked
            then Add('where isnull(Bill_find.NalogId_PG,0)=0')
            else
                if cbErr.Checked then Add(' where isErr = zc_rvYes()')
                else
                    if cbTotalTaxCorr.Checked
                    then Add(' where isErr = zc_rvNo()');
        Add('order by inOperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbTaxCorrective.Caption:='8.2.('+IntToStr(RecordCount)+')Корректировки Fl';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_TaxCorrective';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberBranch',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inChecked',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inDocument',ftBoolean,ptInput, false);

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDocumentTaxKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_MovementLinkMovement_TaxCorrective';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inMovementMasterId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inMovementChildId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inDocumentTaxKindId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             //Номер филиала не должен измениться
                  fOpenSqToQuery (' select ValueData as InvNumberBranch'
                                 +' from MovementString'
                                 +' where MovementId='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 +'   and DescId = zc_MovementString_InvNumberBranch()'
                                 );
                  InvNumberBranch:=toSqlQuery.FieldByName('InvNumberBranch').AsString;
             // Пытаемся найти <Юр.Лицо>
                  fOpenSqToQuery (' select ObjectLink_Partner_Juridical.childobjectid as JuridicalId'
                                 +' from ObjectLink AS ObjectLink_Partner_Juridical'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(FieldByName('inPartnerId').AsInteger)
                                 +'   and ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 );
                  FromId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //Определяем Договор
             ContractId_pg:=fFind_ContractId_pg(FieldByName('inPartnerId').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if ContractId_pg=0
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('inInvNumberPartner').AsString;
             toStoredProc.Params.ParamByName('inInvNumberBranch').Value:=InvNumberBranch;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('inOperDate').AsDateTime;

             if FieldByName('StatusId').AsInteger=zc_rvYes then toStoredProc.Params.ParamByName('inChecked').Value:=true else toStoredProc.Params.ParamByName('inChecked').Value:=false;
             if FieldByName('DocId').AsInteger=zc_rvYes then toStoredProc.Params.ParamByName('inDocument').Value:=true else toStoredProc.Params.ParamByName('inDocument').Value:=false;

             if FieldByName('inPriceWithVAT').AsInteger=zc_rvYes then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('inVATPercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FromId_pg;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('inToId').AsInteger;
             if (FieldByName('inDocumentTaxKindId').AsString<>zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR)
             and(FieldByName('inDocumentTaxKindId').AsString<>zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR)
             then toStoredProc.Params.ParamByName('inPartnerId').Value:=FieldByName('inPartnerId').AsInteger
             else toStoredProc.Params.ParamByName('inPartnerId').Value:=0;

             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inDocumentTaxKindId').Value:=FieldByName('inDocumentTaxKindId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
                       toStoredProc_two.Params.ParamByName('inMovementMasterId').Value:=FieldByName('Id_Postgres_Master').AsInteger;
                       toStoredProc_two.Params.ParamByName('inMovementChildId').Value:=FieldByName('Id_Postgres_Child').AsInteger;
                       toStoredProc_two.Params.ParamByName('inDocumentTaxKindId').Value:=FieldByName('inDocumentTaxKindId').AsInteger;
                       if not myExecToStoredProc_two then ;
             //
             if (FieldByName('isRegistration').AsInteger=zc_rvYes)
             then begin
                       fOpenSqToQuery('select * from lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', '+FormatToDateServer_notNULL(FieldByName('RegistrationDate').AsDateTime)+')');
                       fOpenSqToQuery('select * from lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+', TRUE)');
             end;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)
             then if FieldByName('isDetail').AsInteger<>zc_rvYes
                  then fExecFlSqFromQuery('update dba.Bill set NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value))
                  else fExecFlSqFromQuery(' update dba.BillItems_byParent join dba.BillItems on BillItems.Id = ParentBillItemsId and BillItems.BillId = '+FieldByName('BillId_nalog').AsString
                                         +'        set BillItems_byParent.NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+')'
                                         +' where BillItems_byParent.BillId = '+FieldByName('ObjectId').AsString
                                         +'   and BillItems_byParent.addBillNumber = '+FieldByName('inInvNumberPartner').AsString
                                         +'   and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbTaxCorrective);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_TaxCorrective_Fl(SaveCount:Integer);
begin
     if (cbOKPO.Checked)then exit;
     if (not cbTaxCorrective.Checked)or(not cbTaxCorrective.Enabled) then exit;
     //
     myEnabledCB(cbTaxCorrective);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.NalogId_PG as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , BillItems.OperCount as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , zc_rvNo() as isDetail');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+KindPackage_f.KindPackageName+'+FormatToVarCharServer_notNULL(')')
           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');

        Add('     , BillItems.NalogId_PG as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_f on GoodsProperty_f.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage as KindPackage_f on KindPackage_f.Id = BillItems.KindPackageId');

        Add('     left outer join (select max(GoodsProperty_Detail_byLoad.Id_byLoad) as Id_byLoad, GoodsPropertyId, KindPackageId from dba.GoodsProperty_Detail_byLoad where GoodsProperty_Detail_byLoad.Id_byLoad<>0 group by GoodsPropertyId, KindPackageId');
        Add('                     ) as GoodsProperty_Detail_byLoad on GoodsProperty_Detail_byLoad.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('                                                     and GoodsProperty_Detail_byLoad.KindPackageId = BillItems.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Detail_byServer on GoodsProperty_Detail_byServer.Id = GoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     left outer join dba.GoodsProperty_i as GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail_byServer.GoodsPropertyId');
        Add('     left outer join dba.Goods_i as Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit())'
           +'  and Bill.NalogId_PG>0'
           +'  and BillItems.OperPrice<>0'
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );

        Add('union all');

        Add('select BillItems_byParent.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , BillItems_byParent.NalogId_PG as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , BillItems_byParent.OperCount as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , zc_rvYes() as isDetail');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty_f.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+KindPackage_f.KindPackageName+'+FormatToVarCharServer_notNULL(')')
           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');

        Add('     , BillItems_byParent.NalogItemId_PG as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.BillItems_byParent on BillItems_byParent.BillItemsId = BillItems.Id');
        Add('     left outer join dba.GoodsProperty as GoodsProperty_f on GoodsProperty_f.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage as KindPackage_f on KindPackage_f.Id = BillItems.KindPackageId');

        Add('     left outer join (select max(GoodsProperty_Detail_byLoad.Id_byLoad) as Id_byLoad, GoodsPropertyId, KindPackageId from dba.GoodsProperty_Detail_byLoad where GoodsProperty_Detail_byLoad.Id_byLoad<>0 group by GoodsPropertyId, KindPackageId');
        Add('                     ) as GoodsProperty_Detail_byLoad on GoodsProperty_Detail_byLoad.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('                                                     and GoodsProperty_Detail_byLoad.KindPackageId = BillItems.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Detail_byServer on GoodsProperty_Detail_byServer.Id = GoodsProperty_Detail_byLoad.Id_byLoad');
        Add('     left outer join dba.GoodsProperty_i as GoodsProperty on GoodsProperty.Id = GoodsProperty_Detail_byServer.GoodsPropertyId');
        Add('     left outer join dba.Goods_i as Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit())'
           +'  and BillItems_byParent.NalogId_PG>0'
           +'  and BillItems.OperPrice<>0'
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );

        if cbOnlyInsertDocument.Checked
        then Add('and isnull(Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbTaxCorrective.Caption:='8.2.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Корректировки Fl';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_TaxCorrective';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gtmpUpdate_Movement_InvNumber';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then if FieldByName('isDetail').AsInteger<>zc_rvYes
                  then fExecFlSqFromQuery('update dba.BillItems set NalogId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString)
                  else fExecFlSqFromQuery('update dba.BillItems_byParent set NalogItemId_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('MovementId_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inInvNumber').Value:=FieldByName('errInvNumber').AsString;
                  if not myExecToStoredProc_two then;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbTaxCorrective);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Delete_Int:Integer;
var Id_PG:Integer;
begin
     Result:=0;
     if (not cbDeleteInt.Checked)or(not cbDeleteInt.Enabled) then exit;
     //
     myEnabledCB(cbDeleteInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Id as ObjectId');
        Add('     , Id_PG as Id_Postgres');
        Add('from dba._pgBill_delete');
        Add('order by Id_PG desc');
        Open;

        Result:=RecordCount;
        cbDeleteInt.Caption:='3.0.2.('+IntToStr(RecordCount)+')Удаление Int';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpSetErased_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, '');
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Sale';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, false);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             fOpenSqToQuery (' select Movement.OperDate'
                           +'       , Movement.StatusId, zc_Enum_Status_Complete() as zc_Enum_Status_Complete'
                           +'       , case when Movement.DescId = zc_Movement_Sale() and MD.ValueData >= ' + FormatToDateServer_notNULL(StrToDate('01.04.2014'))
                           +'               and MLO.ObjectId=8459' // Склад Реализации
                           +'              then '+IntToStr(zc_rvNo)+' else '+IntToStr(zc_rvYes)
                           +'         end as isDelete'
                           +' from Movement'
                           +'      left join MovementLinkObject as MLO on MLO.MovementId = Movement.Id and MLO.DescId = zc_MovementLinkObject_From()'
                           +'      left join MovementDate AS MD on MD.MovementId = Movement.Id and MD.DescId = zc_MovementDate_OperDatePartner()'
                           +' where Movement.Id='+FieldByName('Id_Postgres').AsString);

// if FieldByName('Id_Postgres').AsString = '259257' then showMessage('');
             //
             if  (toSqlQuery.FieldByName('OperDate').AsDateTime >= StrToDate(StartDateEdit.Text))
              and(toSqlQuery.FieldByName('OperDate').AsDateTime <= StrToDate(EndDateEdit.Text))
             then begin
                  if toSqlQuery.FieldByName('isDelete').AsInteger = zc_rvNo
                  then begin
                            if toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_Complete').AsInteger
                            then Id_PG:=FieldByName('Id_Postgres').AsInteger// begin ShowMessage('Ошибка.Документ проведен. № '+FieldByName('Id_Postgres').AsString);exit;end;
                            else Id_PG:=0;
                            //
                            if Id_PG<>0
                            then
                                //!!!UnComplete
                                fExecSqToQuery (' select * from lpUnComplete_Movement('+IntToStr(Id_PG)+',5)');
                            //
                            //!!!UPDATE
                            fExecSqToQuery (' update MovementItem set Amount = 0'
                                           +' where MovementItem.MovementId='+FieldByName('Id_Postgres').AsString);
                            fExecSqToQuery (' update MovementItemFloat set ValueData = 0'
                                           +' from MovementItem'
                                           +' where MovementItem.MovementId='+FieldByName('Id_Postgres').AsString
                                           +'   and MovementItemFloat.MovementItemId=MovementItem.Id'
                                           +'   and MovementItemFloat.DescId=zc_MIFloat_AmountChangePercent()');
                            //!!!RecalSumm
                            fExecSqToQuery (' select * from lpInsertUpdate_MovementFloat_TotalSumm ('+FieldByName('Id_Postgres').AsString+')');
                            //
                            if Id_PG<>0
                            then begin
                                //!!!Complete
                                toStoredProc_two.Params.ParamByName('inMovementId').Value:=Id_PG;
                                if myExecToStoredProc_two
                                then if cbClearDelete.Checked
                                     then fExecSqFromQuery('delete dba._pgBill_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
                            end;
                  end
                  else begin
                            //!!!DELETE
                            toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                            //
                            if myExecToStoredProc
                            then if cbClearDelete.Checked
                                 then fExecSqFromQuery('delete dba._pgBill_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
                  end;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbDeleteInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Delete_Int(SaveCount:Integer);
var Id_PG,movId_PG:Integer;
begin
     if (not cbDeleteInt.Checked)or(not cbDeleteInt.Enabled) then exit;
     //
     myEnabledCB(cbDeleteInt);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Id as ObjectId');
        Add('     , Id_PG as Id_Postgres');
        Add('from dba._pgBillItems_delete');
        Add('order by Id_PG desc');
        Open;

        cbDeleteInt.Caption:='3.0.2.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Удаление Int';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpSetErased_MovementItem';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementItemId',ftInteger,ptInput, '');
        //
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Sale';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, false);
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             fOpenSqToQuery (' select Movement.Id as MovementId'
                           +'       , Movement.OperDate'
                           +'       , Movement.StatusId, zc_Enum_Status_Complete() as zc_Enum_Status_Complete'
                           +'       , case when Movement.DescId = zc_Movement_Sale() and MD.ValueData >= ' + FormatToDateServer_notNULL(StrToDate('01.04.2014'))
                           +'               and MLO.ObjectId=8459' // Склад Реализации
                           +'              then '+IntToStr(zc_rvNo)+' else '+IntToStr(zc_rvYes)
                           +'         end as isDelete'
                           +' from MovementItem'
                           +'      left join Movement on Movement.Id = MovementItem.MovementId'
                           +'      left join MovementLinkObject as MLO on MLO.MovementId = Movement.Id and MLO.DescId = zc_MovementLinkObject_From()'
                           +'      left join MovementDate AS MD on MD.MovementId = Movement.Id and MD.DescId = zc_MovementDate_OperDatePartner()'
                           +' where MovementItem.Id='+FieldByName('Id_Postgres').AsString);


// if FieldByName('Id_Postgres').AsString = '2096798' then showMessage('');
// if FieldByName('Id_Postgres').AsString = '2089306' then showMessage('');

             if  (toSqlQuery.FieldByName('OperDate').AsDateTime >= StrToDate(StartDateEdit.Text))
              and(toSqlQuery.FieldByName('OperDate').AsDateTime <= StrToDate(EndDateEdit.Text))
             then begin
                  if toSqlQuery.FieldByName('isDelete').AsInteger = zc_rvNo
                  then begin
                            movId_PG:=toSqlQuery.FieldByName('MovementId').AsInteger;
                            if toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_Complete').AsInteger
                            then Id_PG:=toSqlQuery.FieldByName('MovementId').AsInteger// begin ShowMessage('Ошибка.Документ проведен. № '+FieldByName('Id_Postgres').AsString);exit;end;
                            else Id_PG:=0;
                            //
                            if Id_PG<>0
                            then
                                //!!!UnComplete
                                fExecSqToQuery (' select * from lpUnComplete_Movement('+IntToStr(Id_PG)+',5)');
                            //
                            //!!!UPDATE
                            fExecSqToQuery (' update MovementItem set Amount = 0'
                                           +' where MovementItem.Id='+FieldByName('Id_Postgres').AsString);
                            fExecSqToQuery (' update MovementItemFloat set ValueData = 0'
                                           +' where MovementItemFloat.MovementItemId='+FieldByName('Id_Postgres').AsString
                                           +'   and MovementItemFloat.DescId=zc_MIFloat_AmountChangePercent()');
                            //!!!RecalSumm
                            fExecSqToQuery (' select * from lpInsertUpdate_MovementFloat_TotalSumm ('+IntToStr(movId_PG)+')');
                            //
                            if Id_PG<>0
                            then begin
                                //!!!Complete
                                toStoredProc_two.Params.ParamByName('inMovementId').Value:=Id_PG;
                                if myExecToStoredProc_two
                                then if cbClearDelete.Checked
                                     then fExecSqFromQuery('delete dba._pgBillItems_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
                            end;
                  end
                  else begin
                            toStoredProc.Params.ParamByName('inMovementItemId').Value:=FieldByName('Id_Postgres').AsInteger;
                            //
                            if myExecToStoredProc
                            then if cbClearDelete.Checked
                                 then fExecSqFromQuery('delete dba._pgBillItems_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
                  end;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbDeleteInt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Delete_Fl:Integer;
begin
     Result:=0;
     if (not cbDeleteFl.Checked)or(not cbDeleteFl.Enabled) then exit;
     //
     myEnabledCB(cbDeleteFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Id as ObjectId');
        Add('     , Id_PG as Id_Postgres');
        Add('from dba._pgBill_delete');
        Add('order by Id_PG desc');
        Open;

        Result:=RecordCount;
        cbDeleteFl.Caption:='3.0.1.('+IntToStr(RecordCount)+')Удаление Fl';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpSetErased_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             fOpenSqToQuery ('select OperDate from Movement where Id='+FieldByName('Id_Postgres').AsString);
             if  (toSqlQuery.FieldByName('OperDate').AsDateTime >= StrToDate(StartDateEdit.Text))
              and(toSqlQuery.FieldByName('OperDate').AsDateTime <= StrToDate(EndDateEdit.Text))
             then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  //
                  // if cbCheck.Checked then ShowMessage ('pg - del : '+FieldByName('Id_Postgres').AsString);
                  //
                  if myExecToStoredProc
                  then if cbClearDelete.Checked
                       then begin //if cbCheck.Checked then ShowMessage ('Fl - del : '+'delete dba._pgBill_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
                                  fExecFlSqFromQuery('delete dba._pgBill_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
                             end;
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbDeleteFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Delete_Fl(SaveCount:Integer);
begin
     if (not cbDeleteFl.Checked)or(not cbDeleteFl.Enabled) then exit;
     //
     myEnabledCB(cbDeleteFl);
     //
     with fromFlQuery,Sql do begin
        Close;
        Clear;
        Add('select Id as ObjectId');
        Add('     , Id_PG as Id_Postgres');
        Add('from dba._pgBillItems_delete');
        Add('order by Id_PG desc');
        Open;

        cbDeleteFl.Caption:='3.0.1.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Удаление Fl';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpSetErased_MovementItem';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementItemId',ftInteger,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             fOpenSqToQuery ('select Movement.OperDate from MovementItem join Movement on Movement.Id = MovementId where MovementItem.Id='+FieldByName('Id_Postgres').AsString);
             if  (toSqlQuery.FieldByName('OperDate').AsDateTime >= StrToDate(StartDateEdit.Text))
              and(toSqlQuery.FieldByName('OperDate').AsDateTime <= StrToDate(EndDateEdit.Text))
             then begin
                  toStoredProc.Params.ParamByName('inMovementItemId').Value:=FieldByName('Id_Postgres').AsInteger;
                  //
                  if myExecToStoredProc
                  then if cbClearDelete.Checked
                       then fExecFlSqFromQuery('delete dba._pgBillItems_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
             end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbDeleteFl);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Loss:Integer;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Loss(SaveCount:Integer);
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Inventory(isLastComplete:Boolean);
begin
     if (not cbCompleteInventory.Checked)or(not cbCompleteInventory.Enabled) then exit;
     //
     myEnabledCB(cbCompleteInventory);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'  and Bill.isRemains = zc_rvYes()'
           +'  and Id_Postgres <> 0');
        Add('union all');
        Add('select _pgCar.Id as ObjectId');
        Add('     , _pgCar.Name as InvNumber');
        Add('     , '+FormatToDateServer_notNULL(StrToDate('30.09.2013'))+' as OperDate');
        Add('     , _pgCar.MovementId_pg as Id_Postgres');
        Add('     , _pgCar.CarId_pg as FromId_Postgres');
        Add('     , _pgCar.CarId_pg as ToId_Postgres');
        Add('from dba._pgCar');
        Add('where '+FormatToDateServer_notNULL(StrToDate('30.09.2013'))+'='+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Id_Postgres <> 0'
           );

        Add('order by OperDate,ObjectId');
        Open;
        cbCompleteInventory.Caption:='6. ('+IntToStr(RecordCount)+') Инвентаризация';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Inventory';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsLastComplete',ftBoolean, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if cbComplete.Checked then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MovementLinkObject_From.ObjectId, 0) AS UnitId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_From'
                                 +'                                   ON MovementLinkObject_From.MovementId = Movement.Id'
                                 +'                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   and Movement.DescId = zc_Movement_Inventory()'
                                 );
                  if toSqlQuery.FieldByName('UnitId').AsInteger>0 then
                  begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompleteInventory);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocument_Inventory_Erased;
begin
     if (not cbInventory.Checked)or(not cbInventory.Enabled) then exit;
     //
     myEnabledCB(cbInventory);
     //
     //!!!1. InsertUpdate Sybase
     {fOpenSqToQuery (' select Movement.Id  AS Id_Postgres'
                    +'       ,1            AS isCar' // zc_rvNo
                    +' from Movement'
                    +' WHERE Movement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
                    +'   and Movement.DescId = zc_Movement_Inventory()'
                    +'   and Movement.StatusId = zc_Enum_Status_UnComplete()'
                    );
     //
     with toSqlQuery do begin}
     {!!!!!}
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvNo() as isCar');
        Add('from dba.Bill');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkProductionInFromReceipt()'
           +'  and Bill.isRemains = zc_rvYes()'
           +'  and isnull(Bill.Id_Postgres,0) <> 0 ');
//           +'  and '+IntToStr(isGlobalLoad)+'=zc_rvNo()'
        Add('union all');
        Add('select _pgCar.Id as ObjectId');
        Add('     , _pgCar.Name as InvNumber');
        Add('     , '+FormatToDateServer_notNULL(StrToDate('30.09.2013'))+' as OperDate');
        Add('     , _pgCar.MovementId_pg as Id_Postgres');
        Add('     , zc_rvYes() as isCar');
        Add('from dba._pgCar');
        Add('where '+FormatToDateServer_notNULL(StrToDate('30.09.2013'))+'='+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           );
        Add('order by OperDate, InvNumber, ObjectId');

        Open;{!!!!!}
        cbInventory.Caption:='6. ('+IntToStr(RecordCount)+') Инвентаризация';
        //
        fStop:=(cbOnlyOpen.Checked);
        if fStop then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpSetErased_Movement';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('isCar').AsInteger=zc_rvYes
             then fExecSqFromQuery('update dba._pgCar set MovementId_pg=null where Id = '+FieldByName('ObjectId').AsString)
             else fExecSqFromQuery('update dba.Bill set Id_Postgres=null where Id = '+FieldByName('ObjectId').AsString);
             //else fExecSqFromQuery('update dba.Bill set Id_Postgres=null where Id_Postgres = '+FieldByName('Id_Postgres').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbInventory);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Inventory:Integer;
var calcStartDate,calcEndDate,saveStartDate,saveEndDate:TDateTime;
    Year, Month, Day: Word;
begin
     // !!!
     pLoadDocument_Inventory_Erased;
     //
     Result:=0;
     if (not cbInventory.Checked)or(not cbInventory.Enabled) then exit;
     //
     myEnabledCB(cbInventory);
     //
     // добавляем периоды по месяцам
     with fromQuery_two,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateEdit.Text);
        DecodeDate(calcStartDate, Year, Month, Day);
        if Month=12 then begin Year:=Year+1;Month:=0;end;
        calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        while calcStartDate <= StrToDate(EndDateEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateEdit.Text)
             then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate')
             else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate');
             //
             calcStartDate:=calcEndDate+1;
             DecodeDate(calcStartDate, Year, Month, Day);
             if Month=12 then begin Year:=Year+1;Month:=0;end;
             calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        end;
        Add('order by StartDate, EndDate');
        Open;
     end;

     saveStartDate:=StrToDate(StartDateEdit.Text);
     saveEndDate:=StrToDate(EndDateEdit.Text);

   while not fromQuery_two.EOF do begin
     StartDateEdit.Text:=fromQuery_two.FieldByName('StartDate').AsString;
     EndDateEdit.Text:=fromQuery_two.FieldByName('EndDate').AsString;
     //
     StartDateEdit.Style.Font.Style:=[fsBold];
     StartDateEdit.Style.Font.Color:=clBlue;
     EndDateEdit.Style.Font.Style:=[fsBold];
     EndDateEdit.Style.Font.Color:=clBlue;
     //
     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('call dba._pgSelect_Bill_Inventory('+IntToStr(isGlobalLoad)+','+FormatToDateServer_notNULL(fromQuery_two.FieldByName('StartDate').AsDateTime)+','+FormatToDateServer_notNULL(fromQuery_two.FieldByName('EndDate').AsDateTime)+')');
        Open;
        Result:=RecordCount;
        cbInventory.Caption:='6. ('+IntToStr(RecordCount)+') Инвентаризация';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Inventory';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        //
        // добавляем все накладные из одного периода
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // gc_isDebugMode:=true;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then if FieldByName('isCar').AsInteger=zc_rvYes
                  then fExecSqFromQuery('update dba._pgCar set MovementId_pg=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString)
                  else fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     // после добавления всех накладных из одного периода, вставляем строчную часть
     pLoadDocumentItem_Inventory(Gauge.MaxValue);
     // переходим к след.периоду
     fromQuery_two.Next;
     //
   end;
   Application.ProcessMessages;
   StartDateEdit.Text:=DateToStr(saveStartDate);
   EndDateEdit.Text:=DateToStr(saveEndDate);
   //
   StartDateEdit.Style.Font.Style:=[];
   StartDateEdit.Style.Font.Color:=clWindowText;
   EndDateEdit.Style.Font.Style:=[];
   EndDateEdit.Style.Font.Color:=clWindowText;
   //
   Application.ProcessMessages;
   Application.ProcessMessages;
   Application.ProcessMessages;
     //
     myDisabledCB(cbInventory);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Inventory(SaveCount:Integer);
begin
     if (not cbInventory.Checked)or(not cbInventory.Enabled) then exit;
     //
     myEnabledCB(cbInventory);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('call dba._pgSelect_Bill_Inventory_Item('+IntToStr(isGlobalLoad)+','+FormatToDateServer_notNULL(fromQuery_two.FieldByName('StartDate').AsDateTime)+','+FormatToDateServer_notNULL(fromQuery_two.FieldByName('EndDate').AsDateTime)+')');
        Open;
        cbInventory.Caption:='6. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Инвентаризация';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Inventory';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inStorageId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;

             if FieldByName('PartionGoodsDate').AsDateTime <= StrToDate('01.01.1900')
             then toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=StrToDate('01.01.1900')
             else toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=FieldByName('PartionGoodsDate').AsDateTime;

             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inSumm').Value:=FieldByName('Summ').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inCount').Value:=FieldByName('myCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=0;
             toStoredProc.Params.ParamByName('inStorageId').Value:=0;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)
             then fExecSqFromQuery('update dba. set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbInventory);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Zakaz:Integer;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Zakaz(SaveCount:Integer);
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
end.


{
-- dblog -t D:\Database\Alan\v9ProfiMeating_log D:\Database\Alan\v9ProfiMeating.db
--
-- !!!! в базе сибасе надо создать ключи !!!
--
alter table dba.GoodsProperty_Detail add Id1_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id2_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id3_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id4_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id5_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id6_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id7_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id8_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id9_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id10_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id11_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id12_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id13_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id14_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id15_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id16_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id17_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id18_Postgres integer null;

create table dba.GoodsProperty_Postgres (Id integer not null, Name_PG TVarCharMedium not null, Id_Postgres integer null);
insert into dba.GoodsProperty_Postgres (Id, Name_PG)
  select 1, 'АТБ' union all       // +fIsClient_ATB *** GoodsCodeScaner
  select 2, 'Киев ОК' union all   // +fIsClient_OK  *** GoodsCodeScaner_byKievOK
  select 3, 'Метро' union all     // +fIsClient_Metro  fIsClient_MetroTwo *** GoodsCodeScaner_byMetro
  select 4, 'Алан' union all      //                  *** GoodsCodeScaner_byMain
  select 5, 'Фоззи' union all     // +fIsClient_Fozzi fIsClient_FozziM  *** GoodsCodeScaner_byFozzi
  select 6, 'Кишени' union all    // +fIsClient_Kisheni *** GoodsCodeScaner_byKisheni
  select 7, 'Виват' union all     // +fIsClient_Vivat *** GoodsCodeScaner_byVivat
  select 8, 'Билла' union all     // +fIsClient_Billa *** GoodsCodeScaner_byBilla
  select 9, 'Билла-2' union all   // fIsClient_BillaTwo *** Code_byBillaTwo
  select 10, 'Амстор' union all     // +fIsClient_Amstor *** GoodsCodeScaner_byAmstor
  select 11, 'Омега' union all     // ***fIsClient_Omega *** GoodsCodeScaner_byOmega
  select 12, 'Восторг' union all   // ***fIsClient_Vostorg *** GoodsCodeScaner_byVostorg
  select 13, 'Ашан' union all      // +fIsClient_Ashan *** GoodsCodeScaner_byAshan
  select 14, 'Реал' union all      // +fIsClient_Real  *** GoodsCodeScaner_byReal
  select 15, 'ЖД' union all        // ***fIsClient_GD  *** GoodsName_GD
  -- select 16, 'Таврия' union all    // fIsClient_Tavriya *** Code_byTavriya
  select 17, 'Адвентис' union all  // fIsClient_Adventis *** GoodsCodeScaner_byAdventis
  select 18, 'Край'                // fIsClient_Kray *** Code_byKray
  ;                               // ------
                                  // fIsClient_Furshet
                                  // fIsClient_Obgora






alter table dba.Goods add Id_Postgres integer null;
alter table dba.Goods add Id_Postgres_Fuel integer null;
alter table dba.Goods add Id_Postgres_TicketFuel integer null;
alter table dba.GoodsProperty add Id_Postgres integer null;
alter table dba.Measure add Id_Postgres integer null;
alter table dba.KindPackage add Id_Postgres integer null;

alter table dba.MoneyKind add Id_Postgres integer null;
alter table dba.ContractKind add Id_Postgres integer null;

alter table dba.Unit add Id1_Postgres integer null;
alter table dba.Unit add Id2_Postgres integer null;
alter table dba.Unit add Id3_Postgres integer null;
alter table dba.Unit add Id_Postgres_Business integer null;
alter table dba.Unit add Id_Postgres_Business_TWO integer null;
alter table dba.Unit add Id_Postgres_Business_Chapli integer null;
alter table dba.Unit add PersonalId_Postgres integer null;
alter table dba.Unit add pgUnitId integer null;
alter table dba.Unit add Id_Postgres_RouteSorting integer null;

alter table dba._pgUnit add Id_Postgres_Branch integer null;

alter table dba.PriceList_byHistory add Id_Postgres integer null;
alter table dba.PriceListItems_byHistory add Id_Postgres integer null;

alter table dba.Bill add Id_Postgres integer null;
alter table dba.BillItems add Id_Postgres integer null;
alter table dba.BillItemsReceipt add Id_Postgres integer null;
ok

}


{
select 1 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_ATB(Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 2 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_OK(Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 3 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where (fIsClient_Metro(Unit .Id) = zc_rvYes() or fIsClient_MetroTwo(Unit .Id) = zc_rvYes()) and OKPO <> ''
group by OKPO

union all
select 4 as myId -- Алан
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where (fIsClient_Furshet(Unit .Id) = zc_rvYes() or fIsClient_Obgora(Unit .Id) = zc_rvYes()or fIsClient_Tavriya(Unit .Id) = zc_rvYes()) and OKPO <> ''
group by OKPO

union all
select 5 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where (fIsClient_Fozzi(Unit .Id) = zc_rvYes() or fIsClient_FozziM(Unit .Id) = zc_rvYes()) and OKPO <> ''
group by OKPO

union all

select 6 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Kisheni(Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 7 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Vivat (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 8 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Billa (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 10 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Amstor (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 11 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Omega (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 12 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Vostorg (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 13 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Ashan (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 14 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Real (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 15 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_GD (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

-- union all select 16 as myId fIsClient_Tavriya

union all
select 17 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Adventis (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 18 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Kray (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

order by 1
}
