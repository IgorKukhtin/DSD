unit Main;

interface

uses
  Windows, Forms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ZAbstractConnection,
  ZConnection, dsdDB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.Samples.Gauges, Vcl.ExtCtrls, System.Classes,
  Vcl.Grids, Vcl.DBGrids, DBTables, dxSkinsCore, dxSkinsDefaultPainters,
  IdBaseComponent, IdComponent, IdIPWatch;

type
  TMainForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    GuidePanel: TPanel;
    cbAllGuide: TCheckBox;
    Gauge: TGauge;
    fromADOConnection: TADOConnection;
    fromQuery: TADOQuery;
    fromSqlQuery: TADOQuery;
    StopButton: TButton;
    CloseButton: TButton;
    cbMeasure: TCheckBox;
    cbSetNull_Id_Postgres: TCheckBox;
    cbOnlyOpen: TCheckBox;
    DocumentPanel: TPanel;
    cbAllDocument: TCheckBox;
    cbIncomeBN: TCheckBox;
    OKDocumentButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    toSqlQuery: TZQuery;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    CompleteDocumentPanel: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    cbAllCompleteDocument: TCheckBox;
    cbCompleteIncomeBN: TCheckBox;
    StartDateCompleteEdit: TcxDateEdit;
    EndDateCompleteEdit: TcxDateEdit;
    cbComplete: TCheckBox;
    cbUnComplete: TCheckBox;
    OKCompleteDocumentButton: TButton;
    cbIncomePacker: TCheckBox;
    cbSendUnit: TCheckBox;
    cbSendPersonal: TCheckBox;
    cbSendUnitBranch: TCheckBox;
    cbSaleIntNal: TCheckBox;
    cbReturnOutBN: TCheckBox;
    cbReturnInIntNal: TCheckBox;
    cbProductionUnion: TCheckBox;
    cbProductionSeparate: TCheckBox;
    cbLoss: TCheckBox;
    cbInventory: TCheckBox;
    cbOrderExternal: TCheckBox;
    cbOnlyOpenMI: TCheckBox;
    cbCompleteSend: TCheckBox;
    cbCompleteSendOnPrice: TCheckBox;
    cbInsertHistoryCost: TCheckBox;
    cbCompleteProductionUnion: TCheckBox;
    cbCompleteProductionSeparate: TCheckBox;
    toStoredProc: TdsdStoredProc;
    toStoredProc_two: TdsdStoredProc;
    cbLastComplete: TCheckBox;
    fromQuery_two: TADOQuery;
    cbCompleteInventory: TCheckBox;
    cbCompleteSaleIntNal: TCheckBox;
    toZConnection: TZConnection;
    fromFlADOConnection: TADOConnection;
    fromFlQuery: TADOQuery;
    fromFlSqlQuery: TADOQuery;
    cbCompleteReturnInIntNal: TCheckBox;
    cbOnlyInsertDocument: TCheckBox;
    cbCompleteReturnOutBN: TCheckBox;
    cbTaxFl: TCheckBox;
    cbTaxCorrective: TCheckBox;
    cbReturnInInt: TCheckBox;
    cbSaleInt: TCheckBox;
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
    cbIncomeNal: TCheckBox;
    cbReturnOutNal: TCheckBox;
    cbCompleteIncomeNal: TCheckBox;
    cbCompleteReturnOutNal: TCheckBox;
    toStoredProc_three: TdsdStoredProc;
    cbPartner_Income: TCheckBox;
    toSqlQuery_two: TZQuery;
    cbPartner_Sale: TCheckBox;
    cbOrderInternal: TCheckBox;
    cbCompleteOrderExternal: TCheckBox;
    cbCompleteOrderInternal: TCheckBox;
    cbLossDebt: TCheckBox;
    cbCash: TCheckBox;
    cbCompleteCash: TCheckBox;
    cbCompleteLoss: TCheckBox;
    cbLossGuide: TCheckBox;
    cbCompleteLossNotError: TCheckBox;
    cbWeighingPartner: TCheckBox;
    cbWeighingProduction: TCheckBox;
    cbComplete_List: TCheckBox;
    cbBranchSendOnPrice: TCheckBox;
    UnitCodeSendOnPriceEdit: TEdit;
    cbFillSoldTable: TCheckBox;
    cbCompleteIncome_UpdateConrtact: TCheckBox;
    cbInsertHistoryCost_andReComplete: TCheckBox;
    fromQueryDate: TADOQuery;
    cbDocERROR: TCheckBox;
    cbShowContract: TCheckBox;
    cbShowAll: TCheckBox;
    cbDefroster: TCheckBox;
    cbPack: TCheckBox;
    cbKopchenie: TCheckBox;
    cbPartion: TCheckBox;
    fromQueryDate_recalc: TADOQuery;
    cbHistoryCost_diff: TCheckBox;
    cbLastCost: TCheckBox;
    cb100MSec: TCheckBox;
    cbOnlySale: TCheckBox;
    cbReturnIn_Auto: TCheckBox;
    cbGoodsListSale: TCheckBox;
    cbOnlyTwo: TCheckBox;
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
    procedure cbCompleteIncomeBNClick(Sender: TObject);
    procedure OKCompleteDocumentButtonClick(Sender: TObject);
    procedure cbTaxIntClick(Sender: TObject);
    procedure DocumentPanelClick(Sender: TObject);
    procedure toZConnectionAfterConnect(Sender: TObject);
    procedure OKGuideButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    fStop:Boolean;
    isGlobalLoad,zc_rvYes,zc_rvNo:Integer;
    zc_Enum_PaidKind_FirstForm,zc_Enum_PaidKind_SecondForm:Integer;

    procedure EADO_EngineErrorMsg(E:EADOError);
    procedure EDB_EngineErrorMsg(E:EDBEngineError);
    function myExecToStoredProc_ZConnection:Boolean;
    function myExecToStoredProc:Boolean;
    function myExecToStoredProc_two:Boolean;
    function myExecToStoredProc_three:Boolean;
    function myExecSqlUpdateErased(ObjectId:Integer;Erased,Erased_del:byte):Boolean;

    procedure myShowSql(mySql:TStrings);
    procedure MyDelay(mySec:Integer);

    function myReplaceStr(const S, Srch, Replace: string): string;
    function FormatToVarCharServer_notNULL(_Value:string):string;
    function FormatToVarCharServer_isSpace(_Value:string):string;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;
    function FormatToDateTimeServer(_Date:TDateTime):string;

    function fOpenSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery (mySql:String):Boolean;
    function fExecFlSqFromQuery (mySql:String):Boolean;

    function fGetSession:String;
    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):Boolean;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;

    function fFind_ContractId_pg(PartnerId,IMCode,IMCode_two,PaidKindId:Integer;myContractNumber:String):Integer;
    function fFindIncome_ContractId_pg(JuridicalId,IMCode,InfoMoneyId,PaidKindId:Integer;OperDate:TdateTime):Integer;

    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;

    procedure pInsertHistoryCost(isFirst:Boolean);
    procedure pInsertHistoryCost_Period(StartDate,EndDate:TDateTime;isPeriodTwo:Boolean);
    procedure pSelectData_afterLoad;
    // DocumentsCompelete :
    procedure pCompleteDocument_Cash;

    procedure pCompleteDocument_Income(isLastComplete:Boolean);
    procedure pCompleteDocument_IncomeNal(isLastComplete:Boolean);
    procedure pCompleteDocument_UpdateConrtact;
    procedure pCompleteDocument_ReturnOut(isLastComplete:Boolean);
    procedure pCompleteDocument_ReturnOutNal(isLastComplete:Boolean);
    procedure pCompleteDocument_Send(isLastComplete:Boolean);
    procedure pCompleteDocument_SendOnPrice(isLastComplete:Boolean);

    procedure pCompleteDocument_Sale_IntBN(isLastComplete:Boolean);
    procedure pCompleteDocument_Sale_IntNAL(isLastComplete:Boolean);
    procedure pCompleteDocument_Sale_Fl(isLastComplete:Boolean);

    procedure pCompleteDocument_ReturnIn_IntBN(isLastComplete:Boolean);
    procedure pCompleteDocument_ReturnIn_IntNal(isLastComplete:Boolean);
    procedure pCompleteDocument_ReturnIn_Fl(isLastComplete:Boolean);

    procedure pCompleteDocument_ProductionUnion(isLastComplete:Boolean);
    procedure pCompleteDocument_ProductionSeparate(isLastComplete:Boolean);
    procedure pCompleteDocument_Inventory(isLastComplete:Boolean);

    procedure pCompleteDocument_Loss(isLastComplete:Boolean);

    procedure pCompleteDocument_List(isBefoHistoryCost,isPartion,isDiff:Boolean);
    procedure pCompleteDocument_Defroster;
    procedure pCompleteDocument_Pack;
    procedure pCompleteDocument_Kopchenie;
    procedure pCompleteDocument_Partion;
    procedure pCompleteDocument_Diff;
    procedure pCompleteDocument_ReturnIn_Auto;

    procedure pCompleteDocument_TaxFl(isLastComplete:Boolean);
    procedure pCompleteDocument_TaxCorrective(isLastComplete:Boolean);
    procedure pCompleteDocument_TaxInt(isLastComplete:Boolean);

    procedure pCompleteDocument_OrderExternal;
    procedure pCompleteDocument_OrderInternal;

    // Documents :
    procedure pLoadDocument_LossDebt;

    procedure pLoadDocument_Cash;

    function pLoadDocument_Income:Integer;
    procedure pLoadDocumentItem_Income(SaveCount:Integer);
    function pLoadDocument_IncomeNal:Integer;
    procedure pLoadDocumentItem_IncomeNal(SaveCount:Integer);
    function pLoadDocument_IncomePacker:Integer;
    procedure pLoadDocumentItem_IncomePacker(SaveCount:Integer);

    function pLoadDocument_ReturnOut:Integer;
    procedure pLoadDocumentItem_ReturnOut(SaveCount:Integer);
    function pLoadDocument_ReturnOutNal:Integer;
    procedure pLoadDocumentItem_ReturnOutNal(SaveCount:Integer);

    function pLoadDocument_SendUnit:Integer;
    procedure pLoadDocumentItem_SendUnit(SaveCount:Integer);
    function pLoadDocument_SendUnitBranch:Integer;
    procedure pLoadDocumentItem_SendUnitBranch(SaveCount:Integer);
    function pLoadDocument_SendPersonal:Integer;
    procedure pLoadDocumentItem_SendPersonal(SaveCount:Integer);

    function pLoadDocument_Sale_IntBN:Integer;
    procedure pLoadDocumentItem_Sale_IntBN(SaveCount:Integer);
    function pLoadDocument_Sale_IntNal:Integer;
    procedure pLoadDocumentItem_Sale_IntNal(SaveCount:Integer);

    function pLoadDocument_Sale_Fl:Integer;
    procedure pLoadDocumentItem_Sale_Fl_Int(SaveCount1:Integer);

    function pLoadDocument_ReturnIn:Integer;
    procedure pLoadDocumentItem_ReturnIn(SaveCount:Integer);
    function pLoadDocument_ReturnInNal:Integer;
    procedure pLoadDocumentItem_ReturnInNal(SaveCount:Integer);
    function pLoadDocument_ReturnIn_Fl:Integer;
    procedure pLoadDocumentItem_ReturnIn_Fl(SaveCount:Integer);

    function pLoadDocument_ProductionUnion:Integer;
    function pLoadDocumentItem_ProductionUnionMaster(SaveCount:Integer):Integer;
    procedure pLoadDocumentItem_ProductionUnionChild(SaveCount1,SaveCount2:Integer);
    function pLoadDocument_ProductionSeparate:Integer;
    function pLoadDocumentItem_ProductionSeparateMaster(SaveCount:Integer):Integer;
    procedure pLoadDocumentItem_ProductionSeparateChild(SaveCount1,SaveCount2:Integer);

    procedure pLoadDocument_LossGuide;
    function pLoadDocument_Loss:Integer;
    procedure pLoadDocumentItem_Loss(SaveCount:Integer);

    procedure pLoadDocument_Inventory_Erased;
    function pLoadDocument_Inventory:Integer;
    procedure pLoadDocumentItem_Inventory(SaveCount:Integer);

    function pLoadDocument_OrderExternal:Integer;
    procedure pLoadDocumentItem_OrderExternal(SaveCount:Integer);

    function pLoadDocument_OrderInternal:Integer;
    procedure pLoadDocumentItem_OrderInternal(SaveCount:Integer);

    function pLoadDocument_WeighingPartner:Integer;
    procedure pLoadDocumentItem_WeighingPartner(SaveCount:Integer);

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

    procedure pLoadFillSoldTable;
    procedure pLoadGoodsListSale;

    // Guides :
    procedure pLoadGuide_Measure;


    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);
  public
    procedure StartProcess;
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fFindIncome_ContractId_pg(JuridicalId,IMCode,InfoMoneyId,PaidKindId:Integer;OperDate:TdateTime):Integer;
begin
            // !!!Меняется параметр InfoMoneyId!!!
            fOpenSqToQuery (' select InfoMoneyId'
                           +' from Object_InfoMoney_View'
                           +' where InfoMoneyId='+IntToStr(InfoMoneyId)
                           +'   and InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400()' // Общефирменные + услуги полученные
                           +'                                      , zc_Enum_InfoMoneyDestination_21500()' // Общефирменные + Маркетинг
                           +'                                      , zc_Enum_InfoMoneyDestination_21600()' // Общефирменные + Коммунальные услуги
                           +'                                       )'
                           +'  and (InfoMoneyDestinationCode < 30000' // Доходы
                           +'    or InfoMoneyGroupCode = 70000)' // Инвестиции
                           );
            // !!!Меняется параметр InfoMoneyId!!!
            InfoMoneyId:=toSqlQuery.FieldByName('InfoMoneyId').AsInteger;


             //1.1. находим договор: статья + по дате + не "закрыт" + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and '+FormatToVarCharServer_notNULL(DateToStr(OperDate))+' between StartDate and EndDate'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.1.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('1.1.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!1.1.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and '+FormatToVarCharServer_notNULL(DateToStr(OperDate))+' between StartDate and EndDate'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!1.1.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and '+FormatToVarCharServer_notNULL(DateToStr(OperDate))+' between StartDate and EndDate'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.1.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('1.1.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;
             //1.2. если не нашли, находим договор: статья + без условия даты + не "закрыт" + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 //+'   and '+FormatToVarCharServer_notNULL(OperDate)+' between StartDate and EndDate'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.2.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('1.2.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  //1.2.2. !!!для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  //1.2.2. !!!для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.2.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('1.2.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;
             //1.3.1. если не нашли, находим договор: статья + без условия даты + не "удален"
             if (JuridicalId<>0)and(InfoMoneyId<>0)and(Result=0)then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 //+'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 //+'   and '+FormatToVarCharServer_notNULL(OperDate)+' between StartDate and EndDate'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.3.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('1.3.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!1.3.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!1.3.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and InfoMoneyId='+IntToStr(InfoMoneyId)
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.3.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('1.3.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;


             //2.1.1. если не нашли, находим договор с "похожими" на "Мясное сырье" статьями и без условия даты + не "закрыт" + не "удален"
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('2.1.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('2.1.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!2.1.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!2.1.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('2.1.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('2.1.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;
             //2.2.1. если не нашли, находим договор с "похожими" на "Мясное сырье" статьями и без условия даты + не "удален"
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 //+'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('2.2.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('2.2.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!2.2.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!2.2.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('2.2.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('2.2.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;

             //3.1.1. если не нашли, находим договор с "похожими" на "Прочее сырье" статьями и без условия даты + не "закрыт" + не "удален"
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('3.1.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('3.1.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!3.1.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!3.1.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 +'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('3.1.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('3.1.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 //+'   and Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('3.2.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('3.2.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!3.2.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!3.2.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()'
                                 +' where Object_Contract_View.JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('3.2.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('3.2.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;

             //4. если не нашли, находим хоть один договор !!!у поставщика и если это не услуги!!! + не "удален"
             if (JuridicalId<>0)and(IMCode<>0)and(Result=0)
             then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400()' // Общефирменные + услуги полученные
                                 +'                                                                                         , zc_Enum_InfoMoneyDestination_21500()' // Общефирменные + Маркетинг
                                 +'                                                                                         , zc_Enum_InfoMoneyDestination_21600()' // Общефирменные + Коммунальные услуги
                                 +'                                                                                          )'
                                 +'                                and (Object_InfoMoney_View.InfoMoneyDestinationCode < 30000' // Доходы
                                 +'                                  or Object_InfoMoney_View.InfoMoneyGroupCode = 70000)' // Инвестиции
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 //+'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('4.1.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('4.1.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  //
                  // повторно
                  if (Result=0) then begin
                  if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
                  then
                  // !!!4.2. для НАЛ поиск среди БН!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 //+'                                and Object_InfoMoney_View.InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400(), zc_Enum_InfoMoneyDestination_21500(), zc_Enum_InfoMoneyDestination_21600(), zc_Enum_InfoMoneyDestination_30400(), zc_Enum_InfoMoneyDestination_30500())'
                                 //+'                                and Object_InfoMoney_View.InfoMoneyDestinationCode < 40000'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400()' // Общефирменные + услуги полученные
                                 +'                                                                                         , zc_Enum_InfoMoneyDestination_21500()' // Общефирменные + Маркетинг
                                 +'                                                                                         , zc_Enum_InfoMoneyDestination_21600()' // Общефирменные + Коммунальные услуги
                                 +'                                                                                          )'
                                 +'                                and (Object_InfoMoney_View.InfoMoneyDestinationCode < 30000' // Доходы
                                 +'                                  or Object_InfoMoney_View.InfoMoneyGroupCode = 70000)' // Инвестиции
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_FirstForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 )
                  else if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
                  then
                  // !!!4.2. для БН поиск среди НАЛ!!!
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 //+'                                and Object_InfoMoney_View.InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400(), zc_Enum_InfoMoneyDestination_21500(), zc_Enum_InfoMoneyDestination_21600(), zc_Enum_InfoMoneyDestination_30400(), zc_Enum_InfoMoneyDestination_30500())'
                                 //+'                                and Object_InfoMoney_View.InfoMoneyDestinationCode < 40000'
                                 +'                                and Object_InfoMoney_View.InfoMoneyDestinationId not in'+'(zc_Enum_InfoMoneyDestination_21400()' // Общефирменные + услуги полученные
                                 +'                                                                                         , zc_Enum_InfoMoneyDestination_21500()' // Общефирменные + Маркетинг
                                 +'                                                                                         , zc_Enum_InfoMoneyDestination_21600()' // Общефирменные + Коммунальные услуги
                                 +'                                                                                          )'
                                 +'                                and (Object_InfoMoney_View.InfoMoneyDestinationCode < 30000' // Доходы
                                 +'                                  or Object_InfoMoney_View.InfoMoneyGroupCode = 70000)' // Инвестиции
                                 +' where JuridicalId='+IntToStr(JuridicalId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 )
                  ;
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('4.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked then ShowMessage('4.2.+'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
                  end;
             end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fFind_ContractId_pg(PartnerId,IMCode,IMCode_two,PaidKindId:Integer;myContractNumber:String):Integer;
     function fNal(where_ContractNumber,where_not:String):Integer;
     begin
             // В 1.1.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + УП статье + не закрыт!!!
             Result:=0;
             //if myContractNumber<>'' then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.1.fNal'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.1.fNal'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;

             // В 1.2.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + УП статье + закрыт!!!
             if (Result=0){and(myContractNumber<>'')} then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(zc_Enum_PaidKind_SecondForm)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId = zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 + where_not
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.2.fNal'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.2.fNal'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;

             // В 1.3.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + без УП статьи + не закрыт!!!
             if (Result=0){and(myContractNumber<>'')} then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_21500()' // Маркетинг
                                 +'                                AND (Object_InfoMoney_View.InfoMoneyDestinationId in (zc_Enum_InfoMoneyDestination_20800(),zc_Enum_InfoMoneyDestination_20900(),zc_Enum_InfoMoneyDestination_21000(),zc_Enum_InfoMoneyDestination_21100())' //
                                 +'                                  OR Object_InfoMoney_View.InfoMoneyGroupId in (zc_Enum_InfoMoneyGroup_30000())' // Доходы
                                 +'                                     )'
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 + where_not
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.3.fNal'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.3.fNal'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;
     end;
var where_ContractNumber,where_not:string;
begin
     if (PaidKindId=zc_Enum_PaidKind_FirstForm)and (myContractNumber<>'myContractNumber is null')
     then where_ContractNumber:=' and Object_Contract_View.InvNumber = '+FormatToVarCharServer_notNULL(myContractNumber)
     else where_ContractNumber:='';
     if where_ContractNumber='' then where_not:= ' and 1=0' else where_not:='';


             // В 1.1.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + УП статье + не закрыт!!!
             Result:=0;
             //if myContractNumber<>'' then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.1'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.1'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);

             end;
             // В 1.2.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + УП статье + закрыт!!!
             if (Result=0){and(myContractNumber<>'')} then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyCode = '+IntToStr(IMCode)
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId = zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 + where_not
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.2'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.2'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;
             //
             //
             // !!!для НАЛ поиск среди БН!!!
             if (Result=0)and(PaidKindId=zc_Enum_PaidKind_SecondForm)
             then Result:=fFind_ContractId_pg(PartnerId,IMCode,IMCode_two,zc_Enum_PaidKind_FirstForm,'myContractNumber is null');
             //
             //
             //
             // В 1.3.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + без УП статьи + не закрыт!!!
             if (Result=0){and(myContractNumber<>'')} then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_21500()' // Маркетинг
                                 +'                                AND (Object_InfoMoney_View.InfoMoneyDestinationId in (zc_Enum_InfoMoneyDestination_20800(),zc_Enum_InfoMoneyDestination_20900(),zc_Enum_InfoMoneyDestination_21000(),zc_Enum_InfoMoneyDestination_21100())' //
                                 +'                                  OR Object_InfoMoney_View.InfoMoneyGroupId in (zc_Enum_InfoMoneyGroup_30000())' // Доходы
                                 +'                                     )'
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 + where_not
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.3'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.3'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;
             // В 1.4.-ый раз Пытаемся найти <Договор> !!!по НОМЕРУ + без УП статьи + закрыт!!!
             if (Result=0){and(myContractNumber<>'')} then
             begin
                  fOpenSqToQuery (' select max(ContractId) as ContractId'
                                 +' from Object_Contract_View'
                                 +'      JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId'
                                 +'                                AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_21500()' // // Маркетинг
                                 +'                                AND (Object_InfoMoney_View.InfoMoneyDestinationId in (zc_Enum_InfoMoneyDestination_20800(),zc_Enum_InfoMoneyDestination_20900(),zc_Enum_InfoMoneyDestination_21000(),zc_Enum_InfoMoneyDestination_21100())' //
                                 +'                                  OR Object_InfoMoney_View.InfoMoneyGroupId in (zc_Enum_InfoMoneyGroup_30000())' // Доходы
                                 +'                                     )'
                                 +'      JOIN ObjectLink AS ObjectLink_Partner_Juridical'
                                 +'                         ON ObjectLink_Partner_Juridical.childobjectid = Object_Contract_View.JuridicalId'
                                 +'                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where ObjectLink_Partner_Juridical.ObjectId='+IntToStr(PartnerId)
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId = zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 + where_ContractNumber
                                 + where_not
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('1.4'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('1.4'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;
             //
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('2.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('2.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
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
                                 +'   and PaidKindId='+IntToStr(PaidKindId)
                                 //+'   and '+FormatToVarCharServer_notNULL(DateToStr(FieldByName('OperDate').AsDateTime))+' between StartDate and EndDate'
                                 +'   and ContractStateKindId <> zc_Enum_ContractStateKind_Close()'
                                 +'   and Object_Contract_View.isErased = FALSE'
                                 );
                  Result:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  //
                  if (cbShowContract.Checked)and(Result>0) then ShowMessage('4.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0])
                  else if cbShowAll.Checked  then ShowMessage('4.'+#10+#13+IntToStr(Result)+#10+#13+toSqlQuery.Sql[0]);
             end;
             //
             //
             // !!!для БН поиск среди НАЛ!!!
             if (Result=0)and(PaidKindId=zc_Enum_PaidKind_FirstForm)
             then Result:=fNal(where_ContractNumber,where_not);
             //
             //
             //
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно остановить загрузку?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
end;
procedure TMainForm.toZConnectionAfterConnect(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('Действительно остановить загрузку и выйти?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
procedure TMainForm.DocumentPanelClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGetSession:String;
begin Result:='1005'; end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery(mySql:String):Boolean;
begin
     //fromADOConnection.Connected:=false;
     //
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
     //fromADOConnection.Connected:=false;
     //
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
function TMainForm.fOpenSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.MyDelay(mySec:Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
     end;
end;
{------------------------------------------------------------------------------}
procedure TMainForm.myShowSql(mySql:TStrings);
var
  I: Integer;
  Str: string;
begin
     Str:='';
     for i:= 0 to mySql.Count-1 do
     if i=mySql.Count-1
     then Str:=Str+mySql[i]
     else Str:=Str+mySql[i]+#10+#13;
     ShowMessage('Error.OpenSql'+#10+#13+Str);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToVarCharServer_notNULL(_Value:string):string;
begin if trim(_Value)='' then Result:=chr(39)+''+chr(39) else Result:=chr(39)+trim(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToVarCharServer_isSpace(_Value:string):string;
begin Result:=chr(39)+(_Value)+chr(39);end;
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
function TMainForm.FormatToDateTimeServer(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
  AHour, AMinute, ASecond, MSec: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     DecodeTime(_Date,AHour, AMinute, ASecond, MSec);
//     result:=chr(39)+GetStringValue('select zf_FormatToDateServer('+IntToStr(Year)+','+IntToStr(Month)+','+IntToStr(Day)+')as RetV')+chr(39);
     if Year <= 1900
     then result:='null'
     else result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+' '+IntToStr(AHour)+':'+IntToStr(AMinute)+':'+IntToStr(ASecond)+chr(39);
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
     // toStoredProc.Prepared:=true;
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
function TMainForm.myExecToStoredProc_three:Boolean;
begin
    result:=false;
     // toStoredProc_three.Prepared:=true;
     // try
     toStoredProc_three.Execute;
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
procedure TMainForm.cbCompleteIncomeBNClick(Sender: TObject);
begin
     if (not cbComplete.Checked)and(not cbUnComplete.Checked)then cbComplete.Checked:=true;
end;
procedure TMainForm.cbTaxIntClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
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
     if ParamStr(1)='alan_dp_ua' then
     with toZConnection do begin
        Connected:=false;
        HostName:='integer-srv.alan.dp.ua';
        User:='admin';
        Password:='vas6ok';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        isGlobalLoad:=zc_rvYes;
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
        Connected:=false;
     end
     else
     if ParamStr(1)='alan_dp_ua_test' then
     with toZConnection do begin
        Connected:=false;
        HostName:='integer-srv-r.alan.dp.ua';
        User:='admin';
        Password:='vas6ok';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        isGlobalLoad:=zc_rvYes;
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
        Connected:=false;
     end
     else
     with toZConnection do begin
        Connected:=false;
        HostName:='localhost';
        User:='postgres';
        Password:='plans';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        //if ParamCount = 2 then isGlobalLoad:=zc_rvYes else isGlobalLoad:=zc_rvNo;
        isGlobalLoad:=zc_rvNo;
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
        //
        Connected:=false;
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
     //

     //
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StartProcess;
    procedure autoNal(isOneDay: Boolean);
    begin
    end;
    procedure autoBN (isOneDay: Boolean);
    begin
    end;
    procedure autoGuide;
    begin
    end;

    procedure autoALL (isOneDay: Boolean);
    var Day_ReComplete:Integer;
    begin
               try Day_ReComplete:=StrToInt(ParamStr(3));
               except Day_ReComplete:=10
               end;
               fOpenSqFromQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-Day_ReComplete)+') as RetV');
               StartDateCompleteEdit.Text:=DateToStr(fromSqlQuery.FieldByName('RetV').AsDateTime);
               EndDateCompleteEdit.Text:=DateToStr(Date-1);

               UnitCodeSendOnPriceEdit.Text:='autoALL('+IntToStr(Day_ReComplete)+'Day)';
               //Привязка Возвраты
               cbReturnIn_Auto.Checked:=true;
               //Проводим+Распроводим
               cbComplete.Checked:=true;
               cbUnComplete.Checked:=true;
               cbLastComplete.Checked:=false;
               //с/с
               cbInsertHistoryCost.Checked:=true;
               //по списку
               cbComplete_List.Checked:=true;
               //с задержкой
               cb100MSec.Checked:=true;

               OKCompleteDocumentButtonClick(Self);
end;

var Day_ReComplete:Integer;
begin
     // !!!важно!!!
     cbOnlySale.Checked:=  System.Pos('_SALE',ParamStr(2))>0;

     if ParamStr(2)='autoFillSoldTable'
     then begin
               fOpenSqFromQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-28)+') as RetV');
               StartDateEdit.Text:=DateToStr(fromSqlQuery.FieldByName('RetV').AsDateTime);

               fOpenSqFromQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-28)+') as RetV');
               EndDateEdit.Text:=DateToStr(fromSqlQuery.FieldByName('RetV').AsDateTime);
               //if Date<fromSqlQuery.FieldByName('RetV').AsDateTime
               //then EndDateEdit.Text:=DateToStr(Date-1)
               //else EndDateEdit.Text:=DateToStr(fromSqlQuery.FieldByName('RetV').AsDateTime);

               // текущий месяц
               fOpenSqFromQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-5)+') as RetV');

               // !!!этот пересчет - всегда!!!
               cbGoodsListSale.Checked:=true;

               // !!!за "текущий" - не надо!!! + или надо ...
               if  (EndDateEdit.Text <> DateToStr(fromSqlQuery.FieldByName('RetV').AsDateTime))
                or (ParamStr(3)='+')
               then begin
                    cbFillSoldTable.Checked:=true;
               end
               else
                    cbFillSoldTable.Checked:=false;
               //Загружаем
               OKDocumentButtonClick(Self);
     end;


     if (ParamStr(2)='autoALL')or(ParamStr(2)='autoALL_SALE')
     then begin
               autoALL(true);
     end;
     if (ParamStr(2)='autoALLLAST')or(ParamStr(2)='autoALLLAST_SALE')
     then begin
               cbLastCost.Checked:=TRUE;
               cbHistoryCost_diff.Checked:=TRUE;
               autoALL(true);
     end;

     if ParamStr(2)='auto'
     then begin
          end;
     if ParamStr(2)='autoReComplete'
     then begin
          end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKGuideButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if   System.Pos('auto',ParamStr(2))<=0
     then
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

     if not fStop then DataSource.DataSet:=fromQuery;
     //!!!end FLOAT!!!
     //


     //!!!Integer!!!
     if not fStop then pLoadGuide_Measure;


     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
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

     if System.Pos('auto',ParamStr(2))<=0
     then
         if fStop then ShowMessage('Справочники НЕ загружены. Time=('+StrTime+').')
                  else ShowMessage('Справочники загружены. Time=('+StrTime+').')
     else OKPOEdit.Text:=OKPOEdit.Text + ' Guide:'+StrTime;
     //
     fStop:=true;
end;
procedure TMainForm.OKGuideButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    myRecordCount1,myRecordCount2:Integer;
begin
     if System.Pos('auto',ParamStr(2))<=0
     then
     if MessageDlg('Действительно загрузить выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     {if not cbBeforeSave.Checked
     then begin
               if MessageDlg('Сохранение отключено.Продолжить?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end
     else fExecSqToQuery (' select * from _lpSaveData_beforeLoad('+StartDateEdit.Text+','+EndDateEdit.Text+')');}


     if cbShowContract.Checked then cbOnlyOpen.Checked:=true;

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



     if not fStop then pLoadDocument_LossDebt;

     if not fStop then pLoadDocument_Cash;

     if not fStop then myRecordCount1:=pLoadDocument_Delete_Int;
     if not fStop then pLoadDocumentItem_Delete_Int(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Income;
     if not fStop then pLoadDocumentItem_Income(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnOut;
     if not fStop then pLoadDocumentItem_ReturnOut(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_IncomeNal;
     if not fStop then pLoadDocumentItem_IncomeNal(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnOutNal;
     if not fStop then pLoadDocumentItem_ReturnOutNal(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_IncomePacker;
     if not fStop then pLoadDocumentItem_IncomePacker(myRecordCount1);


     if not fStop then myRecordCount1:=pLoadDocument_SendUnit;
     if not fStop then pLoadDocumentItem_SendUnit(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_SendUnitBranch;
     if not fStop then pLoadDocumentItem_SendUnitBranch(myRecordCount1);
     //if not fStop then myRecordCount1:=pLoadDocument_SendPersonal;
     //if not fStop then pLoadDocumentItem_SendPersonal(myRecordCount1);


     if not fStop then myRecordCount1:=pLoadDocument_Sale_IntBN;
     if not fStop then pLoadDocumentItem_Sale_IntBN(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnIn;
     if not fStop then pLoadDocumentItem_ReturnIn(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Sale_IntNal;
     if not fStop then pLoadDocumentItem_Sale_IntNal(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnInNal;
     if not fStop then pLoadDocumentItem_ReturnInNal(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_Tax_Int;
     if not fStop then pLoadDocumentItem_Tax_Int(myRecordCount1);


     if not fStop then myRecordCount1:=pLoadDocument_ProductionUnion;
     if not fStop then myRecordCount2:=pLoadDocumentItem_ProductionUnionMaster(myRecordCount1);
     if not fStop then pLoadDocumentItem_ProductionUnionChild(myRecordCount1,myRecordCount2);
     if not fStop then myRecordCount1:=pLoadDocument_ProductionSeparate;
     if not fStop then myRecordCount2:=pLoadDocumentItem_ProductionSeparateMaster(myRecordCount1);
     if not fStop then pLoadDocumentItem_ProductionSeparateChild(myRecordCount1,myRecordCount2);

     if not fStop then pLoadDocument_LossGuide;
     if not fStop then myRecordCount1:=pLoadDocument_Loss;
     if not fStop then pLoadDocumentItem_Loss(myRecordCount1);


     if not fStop then myRecordCount1:=pLoadDocument_Inventory;
     //!!!on pLoadDocument_Inventory !!! if not fStop then pLoadDocumentItem_Inventory(myRecordCount1);


     if not fStop then myRecordCount1:=pLoadDocument_OrderExternal;
     if not fStop then pLoadDocumentItem_OrderExternal(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_OrderInternal;
     if not fStop then pLoadDocumentItem_OrderInternal(myRecordCount1);

     if not fStop then myRecordCount1:=pLoadDocument_WeighingPartner;
     if not fStop then pLoadDocumentItem_WeighingPartner(myRecordCount1);
     //
     if not fStop then pLoadGoodsListSale;
     //
     if not fStop then pLoadFillSoldTable;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
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

     if fStop then ShowMessage('Документы НЕ загружены. Time=('+StrTime+').')
     else
         if System.Pos('auto',ParamStr(2))<=0
         then ShowMessage('Документы загружены. Time=('+StrTime+').')
         else OKPOEdit.Text:=OKPOEdit.Text + ' Doc:'+StrTime;
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
    +trim('     , (SELECT MAX (SessionId) FROM _testMI_afterLoad WHERE '+SessionId_str+') AS SessionId_max')
    +trim('     , (SELECT MIN (SessionId) FROM _testMI_afterLoad WHERE '+SessionId_str+') AS SessionId_min')
    +     ' FROM'
    +trim('(SELECT tmpAll.MovementId')
    +trim('      , tmpAll.InvNumber')
    +trim('      , tmpAll.OperDate')
    +trim('      , tmpAll.OperDatePartner')
    +trim('      , tmpAll.PaidKindId')
    +trim('      , tmpAll.MovementItemId')
    +trim('      , tmpAll.GoodsId')
    +trim('      , tmpAll.Price')
    +trim('      , tmpAll.OperDate')
    +     ' FROM (SELECT MovementId'
    +trim('            , InvNumber')
    +trim('            , OperDate')
    +trim('            , OperDatePartner')
    +trim('            , PaidKindId')
    +trim('            , MovementItemId')
    +trim('            , GoodsId')
    +trim('            , AmountPartner')
    +trim('            , 0 AS AmountPartnerNew')
    +trim('            , Amount')
    +trim('            , 0 AS AmountNew')
    +trim('            , Price')
    +     '       FROM (SELECT MAX (SessionId) AS Id FROM _testMI_afterLoad WHERE '+SessionId_str+') as tmpSession'
    +     '            INNER JOIN _testMI_afterLoad ON _testMI_afterLoad.SessionId = tmpSession.Id'
    //+     '        WHERE _testMI_afterLoad.OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '        WHERE _testMI_afterLoad.OperDatePartner BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '         AND _testMI_afterLoad.DescId IN '+DescId_str
    +     '         AND _testMI_afterLoad.StatusId = zc_Enum_Status_Complete()'
    +     '         AND _testMI_afterLoad.isErased = FALSE'
    +     '         AND _testMI_afterLoad.PaidKindId = zc_Enum_PaidKind_FirstForm()'
    +     '         AND (_testMI_afterLoad.FromId = '+UnitId_str+' or 0='+UnitId_str+')' // 8459-Склад Реализации
    +     '      UNION ALL'
    +     '       SELECT Movement.Id AS MovementId'
    +trim('            , Movement.InvNumber')
    +trim('            , Movement.OperDate')
    +trim('            , CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END AS OperDatePartner')
    +trim('            , MLO_PaidKind.ObjectId AS PaidKindId')
    +trim('            , MovementItem.Id AS MovementItemId')
    +trim('            , MovementItem.ObjectId AS GoodsId')
    +trim('            , 0 AS AmountPartner')
    +trim('            , COALESCE (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0) AS AmountPartnerNew')
    +trim('            , 0 AS Amount')
    +trim('            , MovementItem.Amount as AmountNew')
    +trim('            , COALESCE (MIFloat_Price.ValueData, 0) AS Price')
    +     '       FROM Movement'
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_From')
+' '+trim('                                         ON MLO_From.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_From.DescId = zc_MovementLinkObject_From()')
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_To')
+' '+trim('                                         ON MLO_To.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_To.DescId = zc_MovementLinkObject_To()')
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_Contract')
+' '+trim('                                         ON MLO_Contract.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()')
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_PaidKind')
+' '+trim('                                         ON MLO_PaidKind.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()')
+' '+trim('            LEFT JOIN MovementDate AS MovementDate_OperDatePartner')
+' '+trim('                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id')
+' '+trim('                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()')
+' '+trim('            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id')
+' '+trim('                                   AND MovementItem.isErased = FALSE')
+' '+trim('            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner')
+' '+trim('                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id')
+' '+trim('                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()')
+' '+trim('            LEFT JOIN MovementItemFloat AS MIFloat_Price')
+' '+trim('                                        ON MIFloat_Price.MovementItemId = MovementItem.Id')
+' '+trim('                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()')
    +     '       WHERE Movement.DescId IN '+DescId_str
    +     '         AND Movement.StatusId = zc_Enum_Status_Complete()'
    //+     '         AND Movement.OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '         AND MovementDate_OperDatePartner.ValueData BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '         AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()'
    +     '         AND (MLO_From.ObjectId = '+UnitId_str+' or 0='+UnitId_str+')' // 8459-Склад Реализации
    +     '      ) AS tmpAll'
    +     ' GROUP BY tmpAll.MovementId'
    +trim('        , tmpAll.InvNumber')
    +trim('        , tmpAll.OperDate')
    +trim('        , tmpAll.OperDatePartner')
    +trim('        , tmpAll.PaidKindId')
    +trim('        , tmpAll.MovementItemId')
    +trim('        , tmpAll.GoodsId')
    +trim('        , tmpAll.Price')
    +trim('        , tmpAll.OperDate')
    +     ' HAVING SUM (tmpAll.AmountPartner) <> SUM (tmpAll.AmountPartnerNew)'
    +     ') AS tmp'
    );

     if toSqlQuery.FieldByName('calcCount').AsInteger=0
     then ShowMessage('Ошибок нет.Сессия № <'+toSqlQuery.FieldByName('SessionId_max').AsString+'> min('+toSqlQuery.FieldByName('SessionId_min').AsString+')')
     else ShowMessage('Ошибки есть.Сессия № <'+toSqlQuery.FieldByName('SessionId_max').AsString+'> Кол-во=<'+toSqlQuery.FieldByName('calcCount').AsString+'> min=<'+toSqlQuery.FieldByName('minId').AsString+'> max=<'+toSqlQuery.FieldByName('maxId').AsString+'')

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKCompleteDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2,tmpDate3:TDateTime;
    Year, Month, saveMonth, Day, Hour, Min, Sec, MSec: Word;
    Year2, Month2, Day2: Word;
    StrTime:String;
    saveStartDate,saveEndDate:TDateTime;
    calcStartDate,calcEndDate:TDateTime;
begin
     {if (cbSelectData_afterLoad.Checked)
     then begin
               pSelectData_afterLoad;
               exit;
     end;}
     //
     //
     if System.Pos('auto',ParamStr(2))<=0
     then begin
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
     end;
     //
     //
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     if cbComplete_List.Checked then cbUnComplete.Checked:=cbComplete.Checked;
     //
     Gauge.Visible:=true;
     //
     tmpDate1:=NOw;
     //
     saveStartDate:=StrToDate(StartDateCompleteEdit.Text);
     saveEndDate:=StrToDate(EndDateCompleteEdit.Text);
     DecodeDate(saveStartDate, Year, Month, Day);
     DecodeDate(saveEndDate, Year2, Month2, Day2);
     saveMonth:=Month;
     //
     //
     calcStartDate:=saveStartDate;
     if saveMonth <> Month2
     then begin
               if Month=12 then begin Year:=Year+1;Month:=0;end;
               calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
          end
     else calcEndDate:= saveEndDate;
     //
     if (cbOKPO.Checked)and(OKPOEdit.Text='123')
     then pInsertHistoryCost_Period(saveStartDate,saveEndDate,FALSE)
     else pInsertHistoryCost_Period(calcStartDate,calcEndDate,FALSE);
     //
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;
     //
     //
     if saveMonth <> Month2 then begin
       pInsertHistoryCost_Period(calcEndDate+1,saveEndDate,TRUE);
       //
       tmpDate3:=NOw;
       if (tmpDate3-tmpDate2)>=1
       then StrTime:='(1):'+StrTime + '   (2):' + DateTimeToStr(tmpDate3-tmpDate2)
       else begin
                 DecodeTime(tmpDate3-tmpDate2, Hour, Min, Sec, MSec);
                 StrTime:='(1):'+StrTime + '   (2):' + IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
       end;
     end;
     //
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromADOConnection.Connected:=false;

     if System.Pos('auto',ParamStr(2))<=0
     then begin
               if (fStop)and(cbInsertHistoryCost.Checked) then ShowMessage('СЕБЕСТОИМОСТЬ по МЕСЯЦАМ расчитана НЕ полностью. Time=('+StrTime+').')
               else if fStop then ShowMessage('Документы НЕ Распроведены и(или) НЕ Проведены. Time=('+StrTime+').')
               else if cbInsertHistoryCost.Checked then ShowMessage('СЕБЕСТОИМОСТЬ по МЕСЯЦАМ расчитана полностью. Time=('+StrTime+').')
                    else ShowMessage('Документы Распроведены и(или) Проведены. Time=('+StrTime+').');
     end
     else OKPOEdit.Text:=OKPOEdit.Text + ' Complete:'+StrTime;
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pInsertHistoryCost_Period(StartDate,EndDate:TDateTime;isPeriodTwo:Boolean);
var cbLastCost_save,cbOnlySale_save:Boolean;
begin
     StartDateCompleteEdit.Text:=DateToStr(StartDate);
     EndDateCompleteEdit.Text:=DateToStr(EndDate);

     cbLastCost_save:=cbLastCost.Checked;
     if isPeriodTwo = TRUE then cbLastCost.Checked:=false;
     cbOnlySale_save:=cbOnlySale.Checked;
     if isPeriodTwo = TRUE then cbOnlySale.Checked:=false;
     //
     //!!!Integer!!!

     //if not fStop then pCompleteDocument_Cash;

     if {(cbOnlySale.Checked = FALSE)and***}(cbInsertHistoryCost.Checked)and(cbInsertHistoryCost.Enabled)
         // и - если необходимо 2 раза
         and (cbOnlyTwo.Checked = FALSE)
     then begin
          {if not fStop then pCompleteDocument_Income(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_IncomeNal(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_ReturnOut(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_ReturnOutNal(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_Send(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_SendOnPrice(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_Sale_IntBN(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_Sale_IntNAL(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_ReturnIn_IntBN(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_ReturnIn_IntNal(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_ProductionUnion(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_ProductionSeparate(cbLastComplete.Checked);
          if not fStop then pCompleteDocument_Inventory(cbLastComplete.Checked);}

           //
           // сам расчет с/с - 1-ый - ТОЛЬКО производство
           if not fStop then pInsertHistoryCost (TRUE);
           //
           // перепроведение
           if not fStop then pCompleteDocument_List(TRUE, FALSE, FALSE);

     end;
     //
     //
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Defroster;
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Pack;
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Partion;
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Kopchenie;
     //
     // сам расчет с/с - 2-ой - производство + ФИЛИАЛЫ
     if not fStop then pInsertHistoryCost(FALSE);
     //
     // ВСЕГДА - Привязка Возвраты
     if (not fStop) and ((ParamStr(4) <> '-') or (isPeriodTwo = true)) then pCompleteDocument_ReturnIn_Auto;
     //
     // перепроведение
     if not fStop then pCompleteDocument_List(FALSE, FALSE, FALSE);
     //
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Diff;
     //
     //
     if isPeriodTwo = TRUE then cbLastCost.Checked:=cbLastCost_save;
     if isPeriodTwo = TRUE then cbOnlySale.Checked:=cbOnlySale_save;
     //
     {if(not fStop)and(not ((cbInsertHistoryCost.Checked)and(cbInsertHistoryCost.Enabled)))then begin pCompleteDocument_Income(cbLastComplete.Checked);pCompleteDocument_IncomeNal(cbLastComplete.Checked);end;
     if not fStop then pCompleteDocument_UpdateConrtact;
     if not fStop then pCompleteDocument_ReturnOut(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ReturnOutNal(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Send(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_SendOnPrice(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Sale_IntBN(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Sale_IntNAL(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ReturnIn_IntBN(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ReturnIn_IntNal(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ProductionUnion(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_ProductionSeparate(cbLastComplete.Checked);
     if not fStop then pCompleteDocument_Inventory(cbLastComplete.Checked);

     if not fStop then pCompleteDocument_Loss(cbLastComplete.Checked);

     if not fStop then pCompleteDocument_TaxInt(cbLastComplete.Checked);

     if not fStop then pCompleteDocument_OrderExternal;
     if not fStop then pCompleteDocument_OrderInternal;}

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
var
    InternalCode_pg:String;
    InternalName_pg:String;
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
        toStoredProc.Params.AddParam ('inInternalCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInternalName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
//             fOpenSqToQuery (' select OS_Measure_InternalCode.ValueData  AS InternalCode'
//                           +'       , OS_Measure_InternalName.ValueData  AS InternalName'
//                           +' from Object'
//                           +'         LEFT JOIN ObjectString AS OS_Measure_InternalName'
//                           +'                  ON OS_Measure_InternalName.ObjectId = Object.Id'
//                           +'                 AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()'
//                           +'         LEFT JOIN ObjectString AS OS_Measure_InternalCode'
//                           +'                  ON OS_Measure_InternalCode.ObjectId = Object.Id'
//                           +'                 AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()'
//                           +' where Object.Id='+FieldByName('Id_Postgres').AsString);
             fOpenSqToQuery (' select OS_Measure_InternalCode.ValueData  AS InternalCode'
                           +'       , OS_Measure_InternalName.ValueData  AS InternalName'
                           +' from Object'
                           +'         LEFT JOIN ObjectString AS OS_Measure_InternalName'
                           +'                  ON OS_Measure_InternalName.ObjectId = Object.Id'
                           +'                 AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()'
                           +'         LEFT JOIN ObjectString AS OS_Measure_InternalCode'
                           +'                  ON OS_Measure_InternalCode.ObjectId = Object.Id'
                           +'                 AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()'
                           +' where Object.Id='+FieldByName('Id_Postgres').AsString);



             InternalCode_pg:=toSqlQuery.FieldByName('InternalCode').AsString;
             InternalName_pg:=toSqlQuery.FieldByName('InternalName').AsString;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inInternalCode').Value:=InternalCode_pg;
             toStoredProc.Params.ParamByName('inInternalName').Value:=InternalName_pg;

             if not myExecToStoredProc then;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Measure set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
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
procedure TMainForm.pInsertHistoryCost(isFirst:Boolean);
var calcStartDate,calcEndDate:TDateTime;
    saveStartDate,saveEndDate:TDateTime;
    Year, Month, Day: Word;
    myComponent:TADOQuery;
begin
     if (not cbInsertHistoryCost.Checked)or(not cbInsertHistoryCost.Enabled) then exit;
     //
     myEnabledCB(cbInsertHistoryCost);
     //
     saveStartDate:=StrToDate(StartDateCompleteEdit.Text);
     saveEndDate:=StrToDate(EndDateCompleteEdit.Text);
     //
     if cbInsertHistoryCost_andReComplete.Checked
     then myComponent:=fromQueryDate
     else myComponent:=fromQuery;
     //
     fromADOConnection.Connected:=false;
     with myComponent,Sql do begin
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
             then if (cbLastCost.Checked)
                  then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, -1 as BranchId, 0 as BranchCode, null as BranchName')
                  else Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, 0 as BranchId, 0 as BranchCode, null as BranchName')
             else if (cbLastCost.Checked)
                  then Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, -1 as BranchId, 0 as BranchCode, null as BranchName')
                  else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, 0 as BranchId, 0 as BranchCode, null as BranchName');
             //
             //
             if (isFirst = FALSE){and(cbOnlySale.Checked=TRUE)***} then
             begin
                   fOpenSqToQuery (' select *'
                                  +' from gpSelect_HistoryCost_Branch ('+FormatToDateServer_notNULL(calcStartDate)
                                  +'                                  ,'+FormatToDateServer_notNULL(calcEndDate)
                                  +'                                  ,zfCalc_UserAdmin()'
                                  +'                                  )');
                   while not toSqlQuery.EOF do
                   begin
                        Add(' union all select cast('+FormatToDateServer_notNULL(toSqlQuery.FieldByName('StartDate').AsDatetime)+' as date) as StartDate'
                           +'                , cast('+FormatToDateServer_notNULL(toSqlQuery.FieldByName('EndDate').AsDatetime)+' as date) as EndDate'
                           +'                , '+IntToStr(toSqlQuery.FieldByName('BranchId').AsInteger)+' as BranchId'
                           +'                , '+IntToStr(toSqlQuery.FieldByName('BranchCode').AsInteger)+' as BranchCode'
                           +'                , '+FormatToVarCharServer_notNULL(toSqlQuery.FieldByName('BranchName').AsString)+' as BranchName');
                        toSqlQuery.Next;
                   end;
             end;
             //
             //
             calcStartDate:=calcEndDate+1;
             DecodeDate(calcStartDate, Year, Month, Day);
             if Month=12 then begin Year:=Year+1;Month:=0;end;
             calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        end;
        Add('order by StartDate, BranchCode, EndDate');
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
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inItearationCount',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInsert',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiffSumm',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             StartDateCompleteEdit.Text:=DateToStr(FieldByName('StartDate').AsDateTime);
             EndDateCompleteEdit.Text:=DateToStr(FieldByName('EndDate').AsDateTime);
             //
             //
             //
             if cbInsertHistoryCost_andReComplete.Checked
             then begin
                       cbComplete_List.Checked:=true;
                       pCompleteDocument_List(true, FALSE, FALSE);
                      //ShowMessage('pCompleteDocument_List-1');
                  end;
             //
             //
             //
             //
             toStoredProc.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc.Params.ParamByName('inEndDate').Value:=FieldByName('EndDate').AsDateTime;
             toStoredProc.Params.ParamByName('inBranchId').Value:=FieldByName('BranchId').AsInteger;
             toStoredProc.Params.ParamByName('inItearationCount').Value:=800;
             toStoredProc.Params.ParamByName('inInsert').Value:=12345;//захардкодил
             toStoredProc.Params.ParamByName('inDiffSumm').Value:=0.009;
             //ShowMessage('pInsertHistoryCost');
             if not myExecToStoredProc then exit;
             //
             //
             MyDelay(5 * 1000);
             //
             //
             if cbInsertHistoryCost_andReComplete.Checked
             then begin
                       cbComplete_List.Checked:=true;
                       pCompleteDocument_List(false, FALSE, FALSE);
                       //ShowMessage('pCompleteDocument_List-2');
                  end;
             //
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     StartDateCompleteEdit.Text:=DateToStr(saveStartDate);
     EndDateCompleteEdit.Text:=DateToStr(saveEndDate);
     //
     myDisabledCB(cbInsertHistoryCost);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Cash;
begin

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocument_Cash;
var JuridicalId_pg,PartnerId_pg,ContractId_pg,InfoMoneyId_pg,MemberId_pg,KassaId_pg:Integer;
    addComment:String;
    ServiceDate_pg:TDateTime;
begin
     if (not cbCash.Checked)or(not cbCash.Enabled) then exit;
     //
     myEnabledCB(cbCash);
     //
     //находим кассу
     fOpenSqToQuery('select Id as RetV from Object where ObjectCode=101 and DescId = zc_Object_Cash()');
     KassaId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ClientMoney.Id as ObjectId');

        Add('     , ClientMoney.Id - 197000 as InvNumber');
        Add('     , ClientMoney.OperDate as OperDate');
        Add('     , MONTHS (ClientMoney.OperDate, -1) as ServiceDate_pg');

        Add('     , case when _pgPersonal_two.Id_Postgres <> 0 and not (_pgInfoMoney.ObjectCode between 30101 and 30502) then _pgPersonal_two.Id_Postgres else isnull (_pgPartner.PartnerId_pg, Client.Id3_Postgres) end as ClientId_pg');
        Add('     , Client.UnitCode as ClientCode');
        Add('     , Client.UnitName as ClientName');

        Add('     , case when _pgInfoMoney.ObjectCode between 30101 and 30502 then zc_rvYes() else zc_rvNo() end as isSale');
        Add('     , _pgInfoMoney.ObjectCode as CodeIM');
        Add('     , _pgInfoMoney.Id3_Postgres as InfoMoneyId_pg');
        Add('     , _pgInfoMoney.Name3 as InfoMoneyName_pg');
        Add('     , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO');
        Add('     , zf_isOKPO_Virtual_PG(OKPO) as isOKPO_Virtual');
        Add('     , _pgUnit.Id_Postgres as UnitId_pg');
        Add('     , _pgPersonal.Id_Postgres as MemberId_pg');

        Add('     , ClientMoney.Summa');
        Add('     , ClientMoney.MoneyComment as inComment');

        //Add('     , '+IntToStr(zc_Enum_PaidKind_SecondForm)+' as MoneyKindId_pg');

        Add('     , ClientMoney.Id_PG as Id_Postgres');
        Add('from dba.ClientMoney');
        Add('     left outer join (select trim(Unit.UnitName) as UnitName, max (_pgPersonal.Id_Postgres) as Id_Postgres from dba.Unit join dba._pgPersonal on _pgPersonal.Id=Unit.PersonalId_Postgres where Unit.PersonalId_Postgres<>0 group by UnitName'
           +'                     ) as _pgPersonal on _pgPersonal.UnitName = trim(ClientMoney.MoneyComment)');
        Add('     left outer join dba._pgUnit on _pgUnit.ID=ClientMoney.pgUnitId');
        Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ID=ClientMoney.pgInfoMoneyId');
        Add('     left outer join dba.Unit as Client on Client.Id = ClientMoney.ClientId');
        Add('     left outer join dba._pgPersonal as _pgPersonal_two on _pgPersonal_two.Id = Client.PersonalId_Postgres');
        Add('     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                     ) as _pgPartner on _pgPartner.UnitId = ClientMoney.ClientId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');

        Add('where ClientMoney.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and ClientMoney.KassaID=1');
        Add('order by OperDate, ClientName');
        Open;

        cbCash.Caption:='8. ('+IntToStr(RecordCount)+') Касса Int - НАЛ';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Cash';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inServiceDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountIn',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountOut',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCashId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inMoneyPlaceId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPositionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inMemberId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
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
        //
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //
             ContractId_pg:=0;
             PartnerId_pg:=0;
             JuridicalId_pg:=0;
             InfoMoneyId_pg:=0;
             addComment:='';
             //
             //
             //!!!ДЛЯ ПОСТАВЩИКА!!!
             if (FieldByName('isSale').AsInteger = zc_rvNo) and (trim (FieldByName('OKPO').AsString)<>'') then
             begin

             if (FieldByName('isOKPO_Virtual').AsInteger=zc_rvYes)or(FieldByName('ClientId_pg').AsInteger<>0)
             then begin
                        //находим юр.лицо по Контрагенту
                        fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                      +' from ObjectLink'
                                      +' where ObjectLink.ObjectId='+IntToStr(FieldByName('ClientId_pg').AsInteger)
                                      +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                      +'   and 0 <> '+IntToStr(FieldByName('ClientId_pg').AsInteger)
                                      );
                        PartnerId_pg:=FieldByName('ClientId_pg').AsInteger;
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end
             else begin
                  //Сначала находим контрагента и юр.лицо по ОКПО
                  fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, Object_Partner.ObjectCode as PartnerCode, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                                +' from ObjectHistory_JuridicalDetails_View'
                                +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                                +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                +'      left join Object as Object_Partner on Object_Partner.Id = ObjectLink.ObjectId'
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
                       toStoredProc_two.Params.ParamByName('inCode').Value:=FieldByName('ClientCode').AsString;
                       toStoredProc_two.Params.ParamByName('inName').Value:=FieldByName('ClientName').AsString;
                       toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
                       //
                       //if not myExecToStoredProc_two then ;//exit;
                       //
                       PartnerId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
                  end
                  else if (toSqlQuery.FieldByName('PartnerCode').AsInteger=0)  // <> FieldByName('UnitCodeFrom').AsString
                          and (FieldByName('ClientCode').AsInteger > 0)
                            //меняем код контрагента !!!если надо!!!
                       then fExecSqToQuery ('update Object set ObjectCode ='+FieldByName('ClientCode').AsString+' where Id = '+IntToStr(PartnerId_pg));
             end;
             //
             end; //!!!ДЛЯ ПОСТАВЩИКА!!!
             //
             //!!!ДЛЯ ПОКУПАТЕЛЯ!!!
             if (FieldByName('isSale').AsInteger = zc_rvYes) and (FieldByName('ClientId_pg').AsInteger<>0) then
             begin
                       //находим юр.лицо по Контрагенту
                       fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                     +' from ObjectLink'
                                     +' where ObjectLink.ObjectId='+FieldByName('ClientId_pg').AsString
                                     +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                     );
                        PartnerId_pg:=FieldByName('ClientId_pg').AsInteger;
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end;


             //находим договор НАЛ - !!!ДЛЯ ПОСТАВЩИКА!!!
             if (JuridicalId_pg <> 0)and(FieldByName('isSale').AsInteger = zc_rvNo)
             then ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_SecondForm,StrToDate(StartDateEdit.Text)-1);
             //
             //находим договор НАЛ - !!!ДЛЯ ПОКУПАТЕЛЯ!!!
             if (JuridicalId_pg <> 0)and(FieldByName('isSale').AsInteger = zc_rvYes)
             then ContractId_pg:=fFind_ContractId_pg(PartnerId_pg,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_SecondForm,'');
             //
             //
             //!!!уп статья всегда по договору!!!
             if ContractId_pg<>0 then
             begin
                  fOpenSqToQuery('select InfoMoneyId from Object_Contract_InvNumber_View where ContractId='+IntToStr(ContractId_pg));
                  InfoMoneyId_pg:=toSqlQuery.FieldByName('InfoMoneyId').AsInteger;
                  if InfoMoneyId_pg<>FieldByName('InfoMoneyId_PG').AsInteger
                  then addComment:='('+FieldByName('CodeIM').AsString+')'+FieldByName('InfoMoneyName_pg').AsString;

             end
             else InfoMoneyId_pg:=FieldByName('InfoMoneyId_PG').AsInteger;

             //
             if PartnerId_pg=0 then addComment:=addComment+' ' +FieldByName('ClientName').AsString;

             // !!!не меняем Физ лицо (через кого)!!!
             if (MemberId_pg=0)and(FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery (' select MILO_Member.ObjectId as RetV'
                                 +' from Movement'
                                 +'      left join MovementItem on MovementItem.MovementId = Movement.Id'
                                 +'                            and MovementItem.DescId=zc_MI_Master()'
                                 +'      left join MovementItemLinkObject as MILO_Member'
                                 +'                                       on MILO_Member.MovementItemId=MovementItem.Id'
                                 +'                                      and MILO_Member.DescId=zc_MILinkObject_Member()'
                                 +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 );
                  if toSqlQuery.FieldByName('RetV').AsInteger<>0
                  then MemberId_pg:=toSqlQuery.FieldByName('RetV').AsInteger
                  else MemberId_pg:=FieldByName('MemberId_pg').AsInteger;
             end
             else begin
                       MemberId_pg:=FieldByName('MemberId_pg').AsInteger;
             end;
             //if MemberId_pg <> 0 then showmessage('');


             // !!!не меняем УП статью и От кого/Кому и Договор!!! если в документе они есть  //, а в Integer нет
             if (FieldByName('Id_Postgres').AsInteger<>0) then
             begin
                  fOpenSqToQuery (' select MILO_MoneyPlace.ObjectId as PartnerId'
                                 +'       ,MILO_InfoMoney.ObjectId as InfoMoneyId'
                                 +'       ,MILO_Contract.ObjectId as ContractId'
                                 +' from Movement'
                                 +'      left join MovementItem on MovementItem.MovementId = Movement.Id'
                                 +'                            and MovementItem.DescId=zc_MI_Master()'
                                 +'      left join MovementItemLinkObject as MILO_MoneyPlace'
                                 +'                                       on MILO_MoneyPlace.MovementItemId=MovementItem.Id'
                                 +'                                      and MILO_MoneyPlace.DescId=zc_MILinkObject_MoneyPlace()'
                                 +'      left join MovementItemLinkObject as MILO_InfoMoney'
                                 +'                                       on MILO_InfoMoney.MovementItemId=MovementItem.Id'
                                 +'                                      and MILO_InfoMoney.DescId=zc_MILinkObject_InfoMoney()'
                                 +'      left join MovementItemLinkObject as MILO_Contract'
                                 +'                                       on MILO_Contract.MovementItemId=MovementItem.Id'
                                 +'                                      and MILO_Contract.DescId=zc_MILinkObject_Contract()'
                                 +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 );
                  if toSqlQuery.FieldByName('InfoMoneyId').AsInteger<>0
                  then begin InfoMoneyId_pg:=toSqlQuery.FieldByName('InfoMoneyId').AsInteger;
                             ContractId_pg :=toSqlQuery.FieldByName('ContractId').AsInteger;
                             PartnerId_pg  :=toSqlQuery.FieldByName('PartnerId').AsInteger;
                       end;
             end;
             //
             // !!!не меняем Дату начисления!!!
             if (FieldByName('Id_Postgres').AsInteger<>0) then
             begin
                  fOpenSqToQuery (' select MIDate_ServiceDate.ValueData as ServiceDate'
                                 +' from Movement'
                                 +'      left join MovementItem on MovementItem.MovementId = Movement.Id'
                                 +'                            and MovementItem.DescId=zc_MI_Master()'
                                 +'      left join MovementItemDate AS MIDate_ServiceDate'
                                 +'                                 on MIDate_ServiceDate.MovementItemId = MovementItem.Id'
                                 +'                                and MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()'
                                 +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 );
                  ServiceDate_pg:=toSqlQuery.FieldByName('ServiceDate').AsDateTime;
             end
             else ServiceDate_pg:=FieldByName('ServiceDate_pg').AsDateTime;
             //

             //Сохранение
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inServiceDate').Value:=ServiceDate_pg;
             if FieldByName('Summa').AsFloat > 0
             then toStoredProc.Params.ParamByName('inAmountIn').Value:=FieldByName('Summa').AsFloat
             else toStoredProc.Params.ParamByName('inAmountIn').Value:=0;
             if FieldByName('Summa').AsFloat < 0
             then toStoredProc.Params.ParamByName('inAmountOut').Value:=-1 * FieldByName('Summa').AsFloat
             else toStoredProc.Params.ParamByName('inAmountOut').Value:=0;

             toStoredProc.Params.ParamByName('inComment').Value:=trim(addComment + ' ' + FieldByName('inComment').AsString);
             toStoredProc.Params.ParamByName('inCashId').Value:=KassaId_pg;
             toStoredProc.Params.ParamByName('inMoneyPlaceId').Value:=PartnerId_pg;
             toStoredProc.Params.ParamByName('inPositionId').Value:=0;
             toStoredProc.Params.ParamByName('inMemberId').Value:=MemberId_pg;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=InfoMoneyId_pg;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('UnitId_pg').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.ClientMoney set Id_PG=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
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
     myDisabledCB(cbCash);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocument_LossDebt;
var JuridicalId_pg,PartnerId_pg,ContractId_pg:Integer;
    MovementId_pg,zc_Branch_Basis:Integer;
begin
     if (not cbLossDebt.Checked)or(not cbLossDebt.Enabled) then exit;
     //
     myEnabledCB(cbLossDebt);
     //
     fOpenSqToQuery (' select zc_Branch_Basis() as RetV');
     zc_Branch_Basis:=toSqlQuery.FieldByName('RetV').AsInteger;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('call dba._pgSelect_Bill_LossDebt('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-1)+')');
        Open;

        cbLossDebt.Caption:='('+IntToStr(RecordCount)+') Долги Int-НАЛ';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_LossDebt';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('ioAmountDebet',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioAmountKredit',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioSummDebet',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioSummKredit',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioIsCalculated',ftBoolean,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
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
        //
        //!!!находим документ
        fOpenSqToQuery ('select Id as RetV from Movement where OperDate='+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-1) + ' and DescId = zc_Movement_LossDebt() and StatusId =zc_Enum_Status_UnComplete()');
        if toSqlQuery.RecordCount <> 1 then begin ShowMessage('not find Movement');exit;end;
        MovementId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
        //
        //!!!удаление ФИЗ. всех элементов
        fExecSqToQuery ('select lpDelete_MovementItem(Id, zfCalc_UserAdmin()) from MovementItem where MovementId='+IntToStr(MovementId_pg));
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //
             ContractId_pg:=0;
             PartnerId_pg:=0;
             JuridicalId_pg:=0;
             //
             //
             //!!!ДЛЯ ПОСТАВЩИКА!!!
             if (FieldByName('isSale').AsInteger = zc_rvNo) and (trim (FieldByName('OKPO').AsString)<>'') then
             begin

             if FieldByName('isOKPO_Virtual').AsInteger=zc_rvYes
             then begin
                        //находим юр.лицо по Контрагенту
                        fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                      +' from ObjectLink'
                                      +' where ObjectLink.ObjectId='+IntToStr(FieldByName('ClientId_pg').AsInteger)
                                      +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                      +'   and 0 <> '+IntToStr(FieldByName('ClientId_pg').AsInteger)
                                      );
                        PartnerId_pg:=FieldByName('ClientId_pg').AsInteger;
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end
             else begin
                  //Сначала находим контрагента и юр.лицо по ОКПО
                  fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, Object_Partner.ObjectCode as PartnerCode, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                                +' from ObjectHistory_JuridicalDetails_View'
                                +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                                +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                +'      left join Object as Object_Partner on Object_Partner.Id = ObjectLink.ObjectId'
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
                       toStoredProc_two.Params.ParamByName('inCode').Value:=FieldByName('ClientCode').AsString;
                       toStoredProc_two.Params.ParamByName('inName').Value:=FieldByName('ClientName').AsString;
                       toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
                       //
                       if not myExecToStoredProc_two then ;//exit;
                       //
                       PartnerId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
                  end
                  else if (toSqlQuery.FieldByName('PartnerCode').AsInteger=0)  // <> FieldByName('UnitCodeFrom').AsString
                          and (FieldByName('ClientCode').AsInteger > 0)
                            //меняем код контрагента !!!если надо!!!
                       then fExecSqToQuery ('update Object set ObjectCode ='+FieldByName('ClientCode').AsString+' where Id = '+IntToStr(PartnerId_pg));
             end;
             //
             end; //!!!ДЛЯ ПОСТАВЩИКА!!!
             //
             //!!!ДЛЯ ПОКУПАТЕЛЯ!!!
             if (FieldByName('isSale').AsInteger = zc_rvYes) and (FieldByName('ClientId_pg').AsInteger<>0) then
             begin
                        //находим юр.лицо по Контрагенту
                        fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                      +' from ObjectLink'
                                      +' where ObjectLink.ObjectId='+FieldByName('ClientId_pg').AsString
                                      +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                      );
                        PartnerId_pg:=FieldByName('ClientId_pg').AsInteger;
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end;


             //находим договор НАЛ - !!!ДЛЯ ПОСТАВЩИКА!!!
             if (JuridicalId_pg <> 0)and(FieldByName('isSale').AsInteger = zc_rvNo)
             then ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('InfoMoneyCode').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_SecondForm,StrToDate(StartDateEdit.Text)-1);
             //
             //находим договор НАЛ - !!!ДЛЯ ПОКУПАТЕЛЯ!!!
             if (JuridicalId_pg <> 0)and(FieldByName('isSale').AsInteger = zc_rvYes)
             then ContractId_pg:=fFind_ContractId_pg(PartnerId_pg,FieldByName('InfoMoneyCode').AsInteger,30101,zc_Enum_PaidKind_SecondForm,'');
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=0;
             toStoredProc.Params.ParamByName('inMovementId').Value:=MovementId_pg;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
             toStoredProc.Params.ParamByName('inPartnerId').Value:=PartnerId_pg;
             toStoredProc.Params.ParamByName('inBranchId').Value:=zc_Branch_Basis;
             toStoredProc.Params.ParamByName('ioAmountDebet').Value:=0;
             toStoredProc.Params.ParamByName('ioAmountKredit').Value:=0;
             if FieldByName('Summa').AsFloat > 0
             then toStoredProc.Params.ParamByName('ioSummDebet').Value:=FieldByName('Summa').AsFloat
             else toStoredProc.Params.ParamByName('ioSummDebet').Value:=0;
             if FieldByName('Summa').AsFloat < 0
             then toStoredProc.Params.ParamByName('ioSummKredit').Value:=-1 * FieldByName('Summa').AsFloat
             else toStoredProc.Params.ParamByName('ioSummKredit').Value:=0;
             toStoredProc.Params.ParamByName('ioIsCalculated').Value:=true;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=zc_Enum_PaidKind_SecondForm;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=FieldByName('InfoMoneyId_PG').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             // !!!ЭТО НЕ НАДО!!!
             // if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             // then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
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
     myDisabledCB(cbLossDebt);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Income(isLastComplete:Boolean);
var isDocBEGIN:Boolean;
begin
     if (not cbCompleteIncomeBN.Checked)or(not cbCompleteIncomeBN.Enabled) then exit;
     //
     myEnabledCB(cbCompleteIncomeBN);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as InfoMoneyCode');
        Add('     , Bill_findInfoMoney.findId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           //+'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           left outer join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           //+'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id  and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId' // BillItems_find.GoodsPropertyId
           +'                                                            and GoodsProperty.InfoMoneyCode not between 21400 + 1 and 21500 - 1' // услуги полученные
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                        and Bill.BillKind=zc_bkIncomeToUnit()'
           +'                        and Bill.Id_Postgres>0'
           +'                        and Bill.MoneyKindId = zc_mkBN()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and Id_Postgres >0'
           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by InfoMoneyCode,OperDate,ObjectId');
        Open;

        cbCompleteIncomeBN.Caption:='1.1. ('+IntToStr(RecordCount)+') Приход от поставщика - БН';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked){and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger)} then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_Income()'
                                 );
                  if (toSqlQuery.FieldByName('ContractId').AsInteger>0)//or(FieldByName('findId').AsInteger=0)
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     myDisabledCB(cbCompleteIncomeBN);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Income:Integer;
var JuridicalId_pg,PartnerId_pg,ContractId_pg,PersonalPackerId_pg:Integer;
    isDocBEGIN:Boolean;
begin
       Result:=0;
     if (not cbIncomeBN.Checked)or(not cbIncomeBN.Enabled) then exit;
     //
     myEnabledCB(cbIncomeBN);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');

        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when ToId_Postgres is null' // OKPO='+FormatToVarCharServer_notNULL('')+' or
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           //+'                   || case when OKPO='+FormatToVarCharServer_notNULL('')+' then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName||'+FormatToVarCharServer_notNULL('(')+'||OKPO||'+FormatToVarCharServer_notNULL(')')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , Bill.BillDate as OperDate');
        Add('     , UnitFrom.UnitCode as UnitCodeFrom');
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
//           +'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           //+'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId' // BillItems_find.GoodsPropertyId
           +'                                                            and GoodsProperty.InfoMoneyCode not between 21400 + 1 and 21500 - 1' // услуги полученные
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
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
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
//           +'  and Bill.FromId<>4928'//ФОЗЗИ-ПЕРЕПАК ПРОДУКЦИИ
           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkBN()'
//+'  and Bill.Id=1383229'
//+'  and Bill.BillNumber=18733'
           );

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' and Bill.BillNumber = '+trim(OKPOEdit.Text))
        else

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbIncomeBN.Caption:='1.1. ('+IntToStr(RecordCount)+') Приход от поставщика - БН';
        //
        //
        if cbShowContract.Checked
        then begin
             JuridicalId_pg:=0;
             //Сначала находим контрагента  и юр.лицо по ОКПО
             fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, Object_Partner.ObjectCode as PartnerCode, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                           +' from ObjectHistory_JuridicalDetails_View'
                           +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                           +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                           +'      left join Object as Object_Partner on Object_Partner.Id = ObjectLink.ObjectId'
                           +' where OKPO='+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)
                           +'   and '+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)+'<>'+FormatToVarCharServer_notNULL('')
                           );
             JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //
             fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_FirstForm,FieldByName('OperDate').AsDateTime);
        end;
        //
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
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
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
             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                  cbUpdateConrtact.Checked:=TRUE;
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;

         if isDocBEGIN then
         begin
             //
             //Сначала находим контрагента  и юр.лицо по ОКПО
             fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, Object_Partner.ObjectCode as PartnerCode, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                           +' from ObjectHistory_JuridicalDetails_View'
                           +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                           +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                           +'      left join Object as Object_Partner on Object_Partner.Id = ObjectLink.ObjectId'
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
                  toStoredProc_two.Params.ParamByName('inCode').Value:=FieldByName('UnitCodeFrom').AsString;
                  toStoredProc_two.Params.ParamByName('inName').Value:=FieldByName('UnitNameFrom').AsString;
                  toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
                  //
                  if not myExecToStoredProc_two then ;//exit;
                  //
                  PartnerId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
             end
             else if (toSqlQuery.FieldByName('PartnerCode').AsInteger=0)  // <> FieldByName('UnitCodeFrom').AsString
             //else if (toSqlQuery.FieldByName('PartnerCode').AsInteger <> FieldByName('UnitCodeFrom').AsInteger)
                     and (FieldByName('UnitCodeFrom').AsInteger > 0)
                       //меняем код контрагента !!!если надо!!!
                  then fExecSqToQuery ('update Object set ObjectCode ='+FieldByName('UnitCodeFrom').AsString+' where Id = '+IntToStr(PartnerId_pg));

             //

             // !!!Физ лицо (заготовитель) из документа!!!
             if (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery (' select MLO_PersonalPacker.ObjectId as PersonalPackerId'
                                 +' from Movement'
                                 +'      left join MovementLinkObject as MLO_PersonalPacker'
                                 +'                                   on MLO_PersonalPacker.MovementId=Movement.Id'
                                 +'                                  and MLO_PersonalPacker.DescId=zc_MovementLinkObject_PersonalPacker()'
                                 +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 );
                  PersonalPackerId_pg:=toSqlQuery.FieldByName('PersonalPackerId').AsInteger;
             end
             else begin
                       PersonalPackerId_pg:=FieldByName('PersonalPackerId').AsInteger;
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
                  else //находим договор БН
                       ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_FirstForm,FieldByName('OperDate').AsDateTime);
             end
             else //находим договор БН
                  ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_FirstForm,FieldByName('OperDate').AsDateTime);
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
             toStoredProc.Params.ParamByName('inPersonalPackerId').Value:=PersonalPackerId_pg;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //

         end; //if isDocBEGIN // если надо обработать только ошибки

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncomeBN);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Income(SaveCount:Integer);
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
     if (not cbIncomeBN.Checked)or(not cbIncomeBN.Enabled) then exit;
     //
     myEnabledCB(cbIncomeBN);
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
        Add('     , case when _toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG.GoodsPropertyId is not null'
           +'                 then isnull (zf_ChangeTVarCharMediumToNull (BillItems.PartionStr_MB), zf_Calc_PartionIncome_byObvalka (Bill.BillDate, UnitFrom.UnitCode, GoodsProperty.GoodsCode))'
           +'       end as PartionGoods_calc');
        Add('     , UnitFrom.UnitCode AS UnitCode_from');

        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , null as AssetId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG on _toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька

        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbIncomeBN.Caption:='1.1. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Приход от поставщика - БН';
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
        toStoredProc.Params.AddParam ('ioAmount',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioAmountPartner',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inAmountPacker',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsCalcAmountPartner',ftBoolean,ptInput, TRUE);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioCountForPrice',ftFloat,ptInput, 0);
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
             fOpenSqToQuery (' select Object.ObjectCode'
                            +' from MovementLinkObject'
                            +'      LEFT JOIN Object ON Object.Id = MovementLinkObject.ObjectId'
                            +' where MovementLinkObject.MovementId='+IntToStr(FieldByName('MovementId_Postgres').AsInteger)
                            +'   and MovementLinkObject.DescId=zc_MovementLinkObject_From()');
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPacker').Value:=FieldByName('AmountPacker').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('ioCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;

             if(toSqlQuery.FieldByName('ObjectCode').AsInteger <> FieldByName('UnitCode_from').AsInteger)
             then begin
               //if FieldByName('PartionGoods_calc').AsString<>'' then showMessage ('<'+IntToStr(toSqlQuery.FieldByName('ObjectCode').AsInteger)+'>  <'+IntToStr(FieldByName('UnitCode_from').AsInteger)+'>');
               toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods_calc').AsString;
             end
             else toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;

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
     myDisabledCB(cbIncomeBN);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_UpdateConrtact;
begin
     if (not cbCompleteIncome_UpdateConrtact.Checked)or(not cbCompleteIncome_UpdateConrtact.Enabled) then exit;
     //
     myEnabledCB(cbCompleteIncome_UpdateConrtact);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and Id_Postgres >0'
           +'  and Bill.ToId<>4927'//СКЛАД ПЕРЕПАК
           +'  and Bill.FromId not in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and isUnitFrom.UnitId is null'
           +'  and UnitFrom.PersonalId_Postgres is null'
           //!!!!!!+'  and Bill.MoneyKindId = zc_mkNal()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('union all ');
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and Id_Postgres >0'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;
        Add('order by OperDate,ObjectId');
        Open;


        cbCompleteIncome_UpdateConrtact.Caption:='1.6. ('+IntToStr(RecordCount)+') Исправление договора приход';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpReComplete_Movement_Income_Sybase';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             // !!!договор!!!
                  fOpenSqToQuery (' select ObjectLink.ChildObjectId as JuridicalId'
                                 +'      , Object_Contract_View.JuridicalId as JuridicalId_Contract'
                                 +'      , Object_Contract_View.InfoMoneyId'
                                 +'      , Object_InfoMoney.ObjectCode as CodeIM'
                                 +' from MovementLinkObject'
                                 +'      left join Movement on Movement.Id = MovementLinkObject.MovementId'
                                 +'      left join Object_Contract_View on Object_Contract_View.ContractId = MovementLinkObject.ObjectId'
                                 +'      left join Object as Object_InfoMoney on Object_InfoMoney.Id = Object_Contract_View.InfoMoneyId'
                                 +'      left join MovementLinkObject as MLO_From on MLO_From.MovementId = MovementLinkObject.MovementId'
                                 +'                                              and MLO_From.DescId = case when Movement.DescId = zc_Movement_Income() then zc_MovementLinkObject_From() else zc_MovementLinkObject_To() end'
                                 +'      left join ObjectLink on ObjectLink.ObjectId = MLO_From.ObjectId'
                                 +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                 +' where MovementLinkObject.MovementId='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 +'   and MovementLinkObject.DescId=zc_MovementLinkObject_Contract()'
                                 );

           if toSqlQuery.FieldByName('JuridicalId').AsInteger<>toSqlQuery.FieldByName('JuridicalId_Contract').AsInteger
           then begin
               toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
               //находим договор БН
               if FieldByName('MoneyKindId').AsInteger = FieldByName('zc_mkBN').AsInteger
               then toStoredProc.Params.ParamByName('inContractId').Value:=fFindIncome_ContractId_pg(toSqlQuery.FieldByName('JuridicalId').AsInteger
                                                                                                    ,toSqlQuery.FieldByName('CodeIM').AsInteger
                                                                                                    ,toSqlQuery.FieldByName('InfoMoneyId').AsInteger
                                                                                                    ,zc_Enum_PaidKind_FirstForm
                                                                                                    ,FieldByName('OperDate').AsDateTime)
               else toStoredProc.Params.ParamByName('inContractId').Value:=fFindIncome_ContractId_pg(toSqlQuery.FieldByName('JuridicalId').AsInteger
                                                                                                    ,toSqlQuery.FieldByName('CodeIM').AsInteger
                                                                                                    ,toSqlQuery.FieldByName('InfoMoneyId').AsInteger
                                                                                                    ,zc_Enum_PaidKind_SecondForm
                                                                                                    ,FieldByName('OperDate').AsDateTime);

               if not myExecToStoredProc then ;//exit;
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
     myDisabledCB(cbCompleteIncome_UpdateConrtact);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_IncomeNal(isLastComplete:Boolean);
var isDocBEGIN:Boolean;
begin
     if (not cbCompleteIncomeNal.Checked)or(not cbCompleteIncomeNal.Enabled) then exit;
     //
     myEnabledCB(cbCompleteIncomeNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as InfoMoneyCode');
        Add('     , Bill_findInfoMoney.findId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           //+'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           left outer join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           //+'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id  and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId' // BillItems_find.GoodsPropertyId
           +'                                                            and GoodsProperty.InfoMoneyCode not between 21400 + 1 and 21500 - 1' // услуги полученные
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                        and Bill.BillKind=zc_bkIncomeToUnit()'
           +'                        and Bill.Id_Postgres>0'
           +'                        and Bill.MoneyKindId = zc_mkNal()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and Id_Postgres >0'
           +'  and Bill.ToId<>4927'//СКЛАД ПЕРЕПАК
           +'  and Bill.FromId not in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and isUnitFrom.UnitId is null'
           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkNal()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by InfoMoneyCode,OperDate,ObjectId');
        Open;

        cbCompleteIncomeNal.Caption:='1.4. ('+IntToStr(RecordCount)+') Приход от поставщика - НАЛ';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked) then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_Income()'
                                 );
                  if (toSqlQuery.FieldByName('ContractId').AsInteger>0)//or(FieldByName('findId').AsInteger=0)
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                      if not myExecToStoredProc_two then ;//exit;
                  end;
             end;

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     myDisabledCB(cbCompleteIncomeNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_IncomeNal:Integer;
var JuridicalId_pg,PartnerId_pg,ContractId_pg,PersonalPackerId_pg:Integer;
    isDocBEGIN:Boolean;
begin
     Result:=0;
     if (not cbIncomeNal.Checked)or(not cbIncomeNal.Enabled) then exit;
     //
     myEnabledCB(cbIncomeNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');

        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when ToId_Postgres is null' // OKPO='+FormatToVarCharServer_notNULL('')+' or
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           //+'                   || case when OKPO='+FormatToVarCharServer_notNULL('')+' then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName||'+FormatToVarCharServer_notNULL('(')+'||OKPO||'+FormatToVarCharServer_notNULL(')')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , Bill.BillDate as OperDate');
        Add('     , UnitFrom.UnitCode as UnitCodeFrom');
        Add('     , UnitFrom.UnitName as UnitNameFrom');
        Add('     , Unit_Dolg.UnitName as UnitName_Dolg');
        Add('     , isnull(ClientSumm_dolg.DayCount_Real,0)as DayCount_Real');
        Add('     , isnull(ClientSumm_dolg.DayCount_Bank,0)as DayCount_Bank');
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
        Add('     , zf_isOKPO_Virtual_PG(OKPO) as isOKPO_Virtual');
        Add('     , UnitFrom.Id3_Postgres as FromId_pg_find');
        Add('     , Bill.FromId, Bill.ToId');
        Add('     , Bill_findInfoMoney.findId');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
           //+'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           //+'                           left outer join dba.BillItems as BillItems_find on BillItems_find.BillId = Bill.Id and BillItems_find.OperPrice<>0 and BillItems_find.OperCount<>0'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId' // BillItems_find.GoodsPropertyId
           +'                                                            and GoodsProperty.InfoMoneyCode not between 21400 + 1 and 21500 - 1' // услуги полученные
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'                         and Bill.BillKind=zc_bkIncomeToUnit()'
           +'                         and Bill.MoneyKindId = zc_mkNal()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        Add('     left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = Bill_findInfoMoney.InfoMoneyCode');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id=Bill.ToId');
        Add('     left outer join dba._pgUnit on _pgUnit.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId');
        Add('     left outer join dba.Unit as Unit_Dolg on Unit_Dolg.Id=isnull(zf_ChangeIntToNull(UnitFrom.DolgByUnitID),UnitFrom.Id)');
        Add('     left outer join dba.ClientSumm as ClientSumm_dolg on ClientSumm_dolg.ClientId=Unit_Dolg.Id');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and Bill.ToId<>4927'//СКЛАД ПЕРЕПАК
           +'  and Bill.FromId not in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
//           +'  and Bill.FromId<>4928'//ФОЗЗИ-ПЕРЕПАК ПРОДУКЦИИ
           +'  and isUnitFrom.UnitId is null'
           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkNal()'
//+'  and Bill.Id=1383229'
//+'  and Bill.BillNumber=21363'
           );

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' and Bill.BillNumber = '+trim(OKPOEdit.Text))
        else

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbIncomeNal.Caption:='1.4. ('+IntToStr(RecordCount)+') Приход от поставщика - НАЛ';
        //
        //
        if cbShowContract.Checked
        then begin
             //
             if FieldByName('isOKPO_Virtual').AsInteger=zc_rvYes
             then begin
                        //находим юр.лицо по Контрагенту
                        fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                      +' from ObjectLink'
                                      +' where ObjectLink.ObjectId='+IntToStr(FieldByName('FromId_pg_find').AsInteger)
                                      +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                      +'   and 0 <> '+IntToStr(FieldByName('FromId_pg_find').AsInteger)
                                      );
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end
             else begin
                  //Сначала находим контрагента и юр.лицо по ОКПО
                  fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, Object_Partner.ObjectCode as PartnerCode, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                                +' from ObjectHistory_JuridicalDetails_View'
                                +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                                +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                +'      left join Object as Object_Partner on Object_Partner.Id = ObjectLink.ObjectId'
                                +' where OKPO='+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)
                                +'   and '+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)+'<>'+FormatToVarCharServer_notNULL('')
                                );
                  JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
                  //
             end;
             //находим договор НАЛ
             fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_SecondForm,FieldByName('OperDate').AsDateTime);
        end;
        //
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
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
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
             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                  //Сначала находим статус документе, если он проведен или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             if FieldByName('isOKPO_Virtual').AsInteger=zc_rvYes
             then begin
                        //находим юр.лицо по Контрагенту
                        fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                      +' from ObjectLink'
                                      +' where ObjectLink.ObjectId='+IntToStr(FieldByName('FromId_pg_find').AsInteger)
                                      +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                      +'   and 0 <> '+IntToStr(FieldByName('FromId_pg_find').AsInteger)
                                      );
                        PartnerId_pg:=FieldByName('FromId_pg_find').AsInteger;
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end
             else begin
                  //Сначала находим контрагента и юр.лицо по ОКПО
                  fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, Object_Partner.ObjectCode as PartnerCode, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                                +' from ObjectHistory_JuridicalDetails_View'
                                +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                                +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                +'      left join Object as Object_Partner on Object_Partner.Id = ObjectLink.ObjectId'
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
                       toStoredProc_two.Params.ParamByName('inCode').Value:=FieldByName('UnitCodeFrom').AsString;
                       toStoredProc_two.Params.ParamByName('inName').Value:=FieldByName('UnitNameFrom').AsString;
                       toStoredProc_two.Params.ParamByName('inJuridicalId').Value:=JuridicalId_pg;
                       //
                       if not myExecToStoredProc_two then ;//exit;
                       //
                       PartnerId_pg:=toStoredProc_two.Params.ParamByName('ioId').Value;
                  end
                  else if (toSqlQuery.FieldByName('PartnerCode').AsInteger=0)  // <> FieldByName('UnitCodeFrom').AsString
                  //else if (toSqlQuery.FieldByName('PartnerCode').AsInteger<> FieldByName('UnitCodeFrom').AsInteger)
                          and (FieldByName('UnitCodeFrom').AsInteger > 0)
                            //меняем код контрагента !!!если надо!!!
                       then fExecSqToQuery ('update Object set ObjectCode ='+FieldByName('UnitCodeFrom').AsString+' where Id = '+IntToStr(PartnerId_pg));
             end;
             //

             // !!!Физ лицо (заготовитель) из документа!!!
             if (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery (' select MLO_PersonalPacker.ObjectId as PersonalPackerId'
                                 +' from Movement'
                                 +'      left join MovementLinkObject as MLO_PersonalPacker'
                                 +'                                   on MLO_PersonalPacker.MovementId=Movement.Id'
                                 +'                                  and MLO_PersonalPacker.DescId=zc_MovementLinkObject_PersonalPacker()'
                                 +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 );
                  PersonalPackerId_pg:=toSqlQuery.FieldByName('PersonalPackerId').AsInteger;
             end
             else begin
                       PersonalPackerId_pg:=FieldByName('PersonalPackerId').AsInteger;
             end;

             //находим договор НАЛ
             ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_SecondForm,FieldByName('OperDate').AsDateTime);
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
             toStoredProc.Params.ParamByName('inPersonalPackerId').Value:=PersonalPackerId_pg;

             // !!!вызова может не быть!!!
             //if cbContractConditionDocument.Checked then
             begin
                  if not myExecToStoredProc then ;//exit;
                  //
                  if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
                  then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             end;
             //
             //условие по договору
             {if (ContractId_pg<>0)
                and ((FieldByName('DayCount_Real').AsFloat<>0)or(FieldByName('DayCount_Bank').AsFloat<>0))
             then begin
                       fOpenSqToQuery (' select MAX (CASE WHEN ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_DelayDayCalendar() THEN COALESCE (ObjectLink_ContractCondition_ContractConditionKind.ObjectId, 0) ELSE 0 END) AS Id_DayCalendar'
                                      +'      , MAX (CASE WHEN ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_DelayDayBank()   THEN COALESCE (ObjectLink_ContractCondition_ContractConditionKind.ObjectId, 0) ELSE 0 END) AS Id_DelayDayBank'
                                      +'      , zc_Enum_ContractConditionKind_DelayDayCalendar() AS zc_Enum_ContractConditionKind_DelayDayCalendar'
                                      +'      , zc_Enum_ContractConditionKind_DelayDayBank()     AS zc_Enum_ContractConditionKind_DelayDayBank'
                                      +'      , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId'
                                      +' from (SELECT zc_Enum_ContractConditionKind_DelayDayCalendar() AS Id UNION ALL SELECT zc_Enum_ContractConditionKind_DelayDayBank() AS Id) AS tmpContractConditionKind'
                                      +'      inner join Object AS Object_Contract on Object_Contract.Id =' + IntToStr(ContractId_pg)
                                      +'      left join ObjectLink AS ObjectLink_ContractCondition_Contract'
                                      +'                           ON ObjectLink_ContractCondition_Contract.ChildObjectId=Object_Contract.Id'
                                      +'                          AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()'
                                      +'      left join ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind'
                                      +'                           ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId'
                                      +'                          AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = tmpContractConditionKind.Id'
                                      +'                          AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()'
                                      +'      left join ObjectLink AS ObjectLink_Contract_PaidKind'
                                      +'                           ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId'
                                      +'                          AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()'
                                      +' group by ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId'
                                      );
                       if //(toSqlQuery.FieldByName('Id_DayCalendar').AsInteger = zc_Enum_PaidKind_FirstForm)
                           //and
                            ((toSqlQuery.FieldByName('Id_DayCalendar').AsInteger<>0)
                                 or(toSqlQuery.FieldByName('Id_DelayDayBank').AsInteger<>0))
                       then // !!!ничего не делаем для если есть инфа!!!
                       else
                           if (FieldByName('DayCount_Real').AsFloat<>0)
                           then
                                 // добавление zc_Enum_ContractConditionKind_DelayDayCalendar
                                 fExecSqToQuery_two ('select * from gpInsertUpdate_Object_ContractCondition('+IntToStr(toSqlQuery.FieldByName('Id_DayCalendar').AsInteger)
                                                    +'                                           , (select ValueData from Object where Id = '+IntToStr(toSqlQuery.FieldByName('Id_DayCalendar').AsInteger)+' and DescId = zc_Object_ContractCondition())'
                                                    +'                                           , '+FloatToStr(FieldByName('DayCount_Real').AsFloat)
                                                    +'                                           , coalesce((select ChildObjectId from ObjectLink where ObjectId = '+IntToStr(toSqlQuery.FieldByName('Id_DayCalendar').AsInteger)+' and DescId = zc_ObjectLink_ContractCondition_Contract()),'+IntToStr(ContractId_pg)+')'
                                                    +'                                           , '+toSqlQuery.FieldByName('zc_Enum_ContractConditionKind_DelayDayCalendar').AsString
                                                    +'                                           , (select ChildObjectId from ObjectLink where ObjectId = '+IntToStr(toSqlQuery.FieldByName('Id_DayCalendar').AsInteger)+' and DescId = zc_ObjectLink_ContractCondition_BonusKind())'
                                                    +'                                           , (select ChildObjectId from ObjectLink where ObjectId = '+IntToStr(toSqlQuery.FieldByName('Id_DayCalendar').AsInteger)+' and DescId = zc_ObjectLink_ContractCondition_InfoMoney())'
                                                    +'                                           , zfCalc_UserAdmin()'
                                                    +'                                           )'
                                                    )
                           else
                           if (FieldByName('DayCount_Bank').AsFloat<>0)
                           then
                                 // добавление zc_Enum_ContractConditionKind_DelayDayBank
                                 fExecSqToQuery_two ('select * from gpInsertUpdate_Object_ContractCondition('+IntToStr(toSqlQuery.FieldByName('Id_DelayDayBank').AsInteger)
                                                    +'                                           , (select ValueData from Object where Id = '+IntToStr(toSqlQuery.FieldByName('Id_DelayDayBank').AsInteger)+' and DescId = zc_Object_ContractCondition())'
                                                    +'                                           , '+FloatToStr(FieldByName('DayCount_Bank').AsFloat)
                                                    +'                                           , coalesce((select ChildObjectId from ObjectLink where ObjectId = '+IntToStr(toSqlQuery.FieldByName('Id_DelayDayBank').AsInteger)+' and DescId = zc_ObjectLink_ContractCondition_Contract()),'+IntToStr(ContractId_pg)+')'
                                                    +'                                           , '+toSqlQuery.FieldByName('zc_Enum_ContractConditionKind_DelayDayBank').AsString
                                                    +'                                           , (select ChildObjectId from ObjectLink where ObjectId = '+IntToStr(toSqlQuery.FieldByName('Id_DelayDayBank').AsInteger)+' and DescId = zc_ObjectLink_ContractCondition_BonusKind())'
                                                    +'                                           , (select ChildObjectId from ObjectLink where ObjectId = '+IntToStr(toSqlQuery.FieldByName('Id_DelayDayBank').AsInteger)+' and DescId = zc_ObjectLink_ContractCondition_InfoMoney())'
                                                    +'                                           , zfCalc_UserAdmin()'
                                                    +'                                           )'
                                                    );
                  end;}

         end; //if isDocBEGIN // если надо обработать только ошибки
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncomeNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_IncomeNal(SaveCount:Integer);
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
     if (not cbIncomeNal.Checked)or(not cbIncomeNal.Enabled) then exit;
     //
     myEnabledCB(cbIncomeNal);
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
        Add('     , case when _toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG.GoodsPropertyId is not null'
           +'                 then isnull (zf_ChangeTVarCharMediumToNull (BillItems.PartionStr_MB), zf_Calc_PartionIncome_byObvalka (Bill.BillDate, UnitFrom.UnitCode, GoodsProperty.GoodsCode))'
           +'       end as PartionGoods_calc');
        Add('     , UnitFrom.UnitCode AS UnitCode_from');

        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , null as AssetId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG on _toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG.GoodsPropertyId = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька

        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           +'  and Bill.ToId<>4927'//СКЛАД ПЕРЕПАК
           +'  and Bill.FromId not in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and isUnitFrom.UnitId is null'
           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkNal()');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbIncomeNal.Caption:='1.4. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Приход от поставщика - НАЛ';
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
        toStoredProc.Params.AddParam ('ioAmount',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioAmountPartner',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inAmountPacker',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsCalcAmountPartner',ftBoolean,ptInput, TRUE);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioCountForPrice',ftFloat,ptInput, 0);
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
             fOpenSqToQuery (' select Object.ObjectCode'
                            +' from MovementLinkObject'
                            +'      LEFT JOIN Object ON Object.Id = MovementLinkObject.ObjectId'
                            +' where MovementLinkObject.MovementId='+IntToStr(FieldByName('MovementId_Postgres').AsInteger)
                            +'   and MovementLinkObject.DescId=zc_MovementLinkObject_From()');
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPacker').Value:=FieldByName('AmountPacker').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('ioCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;

             if(toSqlQuery.FieldByName('ObjectCode').AsInteger <> FieldByName('UnitCode_from').AsInteger)
             then toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods_calc').AsString
             else toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;

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
     myDisabledCB(cbIncomeNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_IncomePacker:Integer;
var
   FromId_pg, ContractId_pg,PaidKindId_pg:Integer;
   isDocBEGIN:Boolean;
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

        Add('     , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO');
        Add('     , zf_isOKPO_Virtual_PG(OKPO) as isOKPO_Virtual');
        Add('     , 0 as FromId_Postgres');
        Add('     , _pgUnit.Id_Postgres as ToId_Postgres');
        Add('     , MoneyKind.Id_Postgres as PaidKindId_Postgres');
        Add('     , null as ContractId');
        Add('     , _pgPersonal.Id_Postgres as PersonalPackerId');

        Add('     , isnull(Bill_PartionStr_MB.Id_Postgres,Bill.Id_Postgres) as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba._pgPersonal on _pgPersonal.Id = UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba.Bill as Bill_PartionStr_MB on Bill_PartionStr_MB.Id = lfGet_BillId_byPartionStr_MB_isPG(Bill.Id)');
        Add('     left outer join dba.Unit as UnitFrom_PartionStr_MB on UnitFrom_PartionStr_MB.Id=Bill_PartionStr_MB.FromId');
        Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom_PartionStr_MB.InformationFromUnitID'
           +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
        Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom_PartionStr_MB.Id');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id=Bill.ToId');
        Add('     left outer join dba._pgUnit on _pgUnit.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and UnitFrom.PersonalId_Postgres is not null'
           +'  and Bill.MoneyKindId = zc_mkNal()'
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
        toStoredProc.Params.AddParam ('inPersonalPackerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                  cbUpdateConrtact.Checked:=TRUE;
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             // !!!договор и поставщика из документа!!!
             if (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery (' select MLO_Contract.ObjectId as ContractId'
                                 +'      , MLO_From.ObjectId as FromId'
                                 +'      , MLO_PaidKind.ObjectId as PaidKindId'
                                 +' from Movement'
                                 +'      left join MovementLinkObject as MLO_Contract'
                                 +'                                   on MLO_Contract.MovementId=Movement.Id'
                                 +'                                  and MLO_Contract.DescId=zc_MovementLinkObject_Contract()'
                                 +'      left join MovementLinkObject as MLO_From'
                                 +'                                   on MLO_From.MovementId=Movement.Id'
                                 +'                                  and MLO_From.DescId=zc_MovementLinkObject_From()'
                                 +'      left join MovementLinkObject as MLO_PaidKind'
                                 +'                                   on MLO_PaidKind.MovementId=Movement.Id'
                                 +'                                  and MLO_PaidKind.DescId=zc_MovementLinkObject_PaidKind()'
                                 +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger)
                                 );
                  FromId_pg:=toSqlQuery.FieldByName('FromId').AsInteger;
                  ContractId_pg:=toSqlQuery.FieldByName('ContractId').AsInteger;
                  PaidKindId_pg:=toSqlQuery.FieldByName('PaidKindId').AsInteger;
             end
             else begin
                       FromId_pg:=FieldByName('FromId_Postgres').AsInteger;
                       ContractId_pg:=FieldByName('ContractId').AsInteger;
                       PaidKindId_pg:=FieldByName('PaidKindId_Postgres').AsInteger;
             end;
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('InvNumberPartner').AsString;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FromId_pg;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=PaidKindId_pg;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inPersonalPackerId').Value:=FieldByName('PersonalPackerId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and isnull(Id_Postgres,0)<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
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
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and UnitFrom.PersonalId_Postgres is not null'
           +'  and BillItems.Id is not null'
           +'  and Bill.MoneyKindId = zc_mkNal()'
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
        toStoredProc.Params.AddParam ('ioAmount',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioAmountPartner',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inAmountPacker',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsCalcAmountPartner',ftBoolean,ptInput, TRUE);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioCountForPrice',ftFloat,ptInput, 0);
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
             toStoredProc.Params.ParamByName('ioAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPacker').Value:=FieldByName('AmountPacker').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('ioCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
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
        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and (isUnitFrom.UnitId is not null or (UnitFrom.PersonalId_Postgres is not null and Bill.ToId not in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())) or UnitFrom.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'  and (isUnitTo.UnitId is not null or (UnitTo.PersonalId_Postgres is not null and Bill.FromId not in (zc_UnitId_StoreSale())) or UnitTo.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
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
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +' and Bill.Id_Postgres=22081'
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and (isUnitFrom.UnitId is not null or (UnitFrom.PersonalId_Postgres is not null and Bill.ToId not in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())) or UnitFrom.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'  and (isUnitTo.UnitId is not null or (UnitTo.PersonalId_Postgres is not null and Bill.FromId not in (zc_UnitId_StoreSale())) or UnitTo.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbSendUnit.Caption:='2.1. ('+IntToStr(RecordCount)+') Перемещение';
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
        Add('     , -1 * BillItems.OperCount as Amount');
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

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit())'
           +'  and (isUnitFrom.UnitId is not null or (UnitFrom.PersonalId_Postgres is not null and Bill.ToId not in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())) or UnitFrom.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'  and (isUnitTo.UnitId is not null or (UnitTo.PersonalId_Postgres is not null and Bill.FromId not in (zc_UnitId_StoreSale())) or UnitTo.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'  and BillItems.Id is not null'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbSendUnit.Caption:='2.1. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Перемещение';
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
var UnitId_pg:Integer;
begin
     if (not cbCompleteSendOnPrice.Checked)or(not cbCompleteSendOnPrice.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSendOnPrice);
     //
     //ограничение по одному Складу (для Филиала)
     if cbBranchSendOnPrice.Checked then
     begin
          fOpenSqToQuery(' select Id as RetV from Object_Unit_View where Code='+IntToStr(StrToInt(UnitCodeSendOnPriceEdit.Text)));
          UnitId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
     end
     else UnitId_pg:=0;
     //
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Id_Postgres >0'
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit(), zc_bkSaleToClient(), zc_bkReturnToUnit())'
           +'  and Bill.MoneyKindId=zc_mkNal()'
           +'  and UnitFrom.pgUnitId NOT IN (3, 1625)' // !!!ф. Одесса OR ф. Никополь!!!
           +'  and UnitTo.pgUnitId NOT IN (3, 1625)' // !!!ф. Одесса OR ф. Никополь!!!
           +'  and ((isUnitFrom.UnitId is not null and UnitTo.pgUnitId is not null)'
           +'    or (isUnitTo.UnitId is not null and UnitFrom.pgUnitId is not null))'
           +'  and not ((isUnitFrom.UnitId is not null or (UnitFrom.PersonalId_Postgres is not null and Bill.ToId not in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())) or UnitFrom.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'       and (isUnitTo.UnitId is not null or (UnitTo.PersonalId_Postgres is not null and Bill.FromId not in (zc_UnitId_StoreSale())) or UnitTo.ParentId in (4137, 8217)))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           );
        Add('  and FromId_Postgres <> 0');
        Add('  and ToId_Postgres <> 0');
        if UnitId_pg<>0
        then Add('and (pgUnitFrom.Id_Postgres = '+IntToStr(UnitId_pg)
                +'  or pgUnitTo.Id_Postgres = '+IntToStr(UnitId_pg)
                +'  )'
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
        // cbSendPersonal.Caption:='2.2. ('+IntToStr(RecordCount)+') Перемещение с экспедиторами';
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_SendPersonal(SaveCount:Integer);
begin
        //cbSendPersonal.Caption:='2.2. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Перемещение с экспедиторами';
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_SendUnitBranch:Integer;
var UnitId_pg:Integer;
begin
     Result:=0;
     if (not cbSendUnitBranch.Checked)or(not cbSendUnitBranch.Enabled) then exit;
     //
     myEnabledCB(cbSendUnitBranch);
     //
     //ограничение по одному Складу (для Филиала)
     if cbBranchSendOnPrice.Checked then
     begin
          fOpenSqToQuery(' select Id as RetV from Object_Unit_View where Code='+IntToStr(StrToInt(UnitCodeSendOnPriceEdit.Text)));
          UnitId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
     end
     else UnitId_pg:=0;
     //
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
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +' and Bill.Id_Postgres=22081'
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit(), zc_bkSaleToClient(), zc_bkReturnToUnit())'
           +'  and Bill.MoneyKindId=zc_mkNal()'
           +'  and UnitFrom.pgUnitId NOT IN (3, 1625)' // !!!ф. Одесса OR ф. Никополь!!!
           +'  and UnitTo.pgUnitId NOT IN (3, 1625)' // !!!ф. Одесса OR ф. Никополь!!!
           +'  and ((isUnitFrom.UnitId is not null and UnitTo.pgUnitId is not null)'
           +'    or (isUnitTo.UnitId is not null and UnitFrom.pgUnitId is not null))'
           +'  and not ((isUnitFrom.UnitId is not null or (UnitFrom.PersonalId_Postgres is not null and Bill.ToId not in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())) or UnitFrom.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'       and (isUnitTo.UnitId is not null or (UnitTo.PersonalId_Postgres is not null and Bill.FromId not in (zc_UnitId_StoreSale())) or UnitTo.ParentId in (4137, 8217)))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           );
        if UnitId_pg<>0
        then Add('and (pgUnitFrom.Id_Postgres = '+IntToStr(UnitId_pg)
                +'  or pgUnitTo.Id_Postgres = '+IntToStr(UnitId_pg)
                +'  )'
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

             //fExecSqFromQuery('update dba.BillItems set Id_Postgres= null where BillId = '+FieldByName('ObjectId').AsString);
             //fExecSqFromQuery('update dba.Bill set Id_Postgres= null where Id = '+FieldByName('ObjectId').AsString);
             //fExecSqToQuery (' select * from lpSetErased_Movement('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+',5)');

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
var UnitId_pg:Integer;
begin
     if (not cbSendUnitBranch.Checked)or(not cbSendUnitBranch.Enabled) then exit;
     //
     myEnabledCB(cbSendUnitBranch);
     //
     //ограничение по одному Складу (для Филиала)
     if cbBranchSendOnPrice.Checked then
     begin
          fOpenSqToQuery(' select Id as RetV from Object_Unit_View where Code='+IntToStr(StrToInt(UnitCodeSendOnPriceEdit.Text)));
          UnitId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
     end
     else UnitId_pg:=0;
     //
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
           //+'               then -1 * BillItems.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'               then BillItems.OperCount * case when Bill.BillKind = zc_bkReturnToUnit() then 1 else -1 end'
           +'            else BillItems.OperCount * case when Bill.BillKind = zc_bkReturnToUnit() then 1 else -1 end'
           +'       end as Amount');
        Add('     , BillItems.OperCount * case when Bill.BillKind = zc_bkReturnToUnit() then 1 else -1 end as AmountPartner');
        Add('     , BillItems.OperCount * case when Bill.BillKind = zc_bkReturnToUnit() then 1 else -1 end as AmountChangePercent');
        Add('     , isnull(tmpBI_byDiscountWeight.DiscountWeight,0) as ChangePercentAmount');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        //Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька

        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = BillItems.GoodsPropertyId'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = BillItems.KindPackageId'
           +'                                                                           and Bill.BillDate between tmpBI_byDiscountWeight.StartDate and tmpBI_byDiscountWeight.EndDate'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill.ToId'
           +'                                                                           and 1=1');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and BillItems.Id is not null'
// +' and Bill.Id_Postgres=367617'
           +'  and Bill.BillKind in (zc_bkSendUnitToUnit(), zc_bkSaleToClient(), zc_bkReturnToUnit())'
           +'  and Bill.MoneyKindId=zc_mkNal()'
           +'  and UnitFrom.pgUnitId NOT IN (3, 1625)' // !!!ф. Одесса OR ф. Никополь!!!
           +'  and UnitTo.pgUnitId NOT IN (3, 1625)' // !!!ф. Одесса OR ф. Никополь!!!
           +'  and ((isUnitFrom.UnitId is not null and UnitTo.pgUnitId is not null)'
           +'    or (isUnitTo.UnitId is not null and UnitFrom.pgUnitId is not null))'
           +'  and not ((isUnitFrom.UnitId is not null or (UnitFrom.PersonalId_Postgres is not null and Bill.ToId not in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())) or UnitFrom.ParentId in (4137, 8217))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           +'       and (isUnitTo.UnitId is not null or (UnitTo.PersonalId_Postgres is not null and Bill.FromId not in (zc_UnitId_StoreSale())) or UnitTo.ParentId in (4137, 8217)))' // МО ЛИЦА-ВСЕ + АВТОМОБИЛИ
           );
        if UnitId_pg<>0
        then Add('and (pgUnitFrom.Id_Postgres = '+IntToStr(UnitId_pg)
                +'  or pgUnitTo.Id_Postgres = '+IntToStr(UnitId_pg)
                +'  )'
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
        //toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
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
             //toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=0;
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
procedure TMainForm.pCompleteDocument_Sale_IntBN(isLastComplete:Boolean);
var
   CurrencyDocumentId:Integer;
   CurrencyPartnerId:Integer;
   zc_Enum_Currency_Basis:Integer;
   isDocBEGIN:Boolean;
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
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba._pgSelect_Bill_Sale('+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))+')');
        Add('     as Bill');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ClientID');

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.InvNumber_my'
                +'                           and _pgBillLoad.FromId=Bill.FromId')
        else
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = Bill.ClientID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
             Add(' where isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
             Add('   and Bill.Id_Postgres>0'
                +'   and Bill.MoneyKindId=zc_mkBN()');
        end
        else
            Add('where Bill.Id_Postgres>0'
               +'  and Bill.MoneyKindId=zc_mkBN()');

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteSaleInt.Caption:='3.3.('+IntToStr(RecordCount)+')Прод.пок.Int - БН';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             //!!!ВАЛЮТА!!!
             begin
                   fOpenSqToQuery (' SELECT coalesce (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis())   AS CurrencyDocumentId'
                                  +'      , coalesce (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())    AS CurrencyPartnerId'
                                  +'      , zc_Enum_Currency_Basis()                       as zc_Enum_Currency_Basis'
                                  +' FROM Movement'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument'
                                  +'             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner'
                                  +'             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()'
                                  +' WHERE Movement.Id = '+IntToStr(FieldByName('Id_Postgres').AsInteger));
                       CurrencyDocumentId:=toSqlQuery.FieldByName('CurrencyDocumentId').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('CurrencyPartnerId').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('zc_Enum_Currency_Basis').AsInteger;
             end;
             //!!!если ВАЛЮТА, ничего не делаем!!!
             if (CurrencyDocumentId=zc_Enum_Currency_Basis) and (CurrencyPartnerId =zc_Enum_Currency_Basis)
             then begin
             //!!!если ВАЛЮТА, ничего не делаем!!!

             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_To.ObjectId, 0) AS ToId'
                                 +'       ,COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_To'
                                 +'                                   ON MLO_To.MovementId = Movement.Id'
                                 +'                                  AND MLO_To.DescId = zc_MovementLinkObject_To()'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_Sale()'
                                 );
             if (cbComplete.Checked)
                and(toSqlQuery.FieldByName('ToId').AsInteger>0)
                and(toSqlQuery.FieldByName('ContractId').AsInteger>0)
                and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger)
             then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                  if not myExecToStoredProc_two then ;//exit;
             end;
             //

             end; //if !!!если ВАЛЮТА, ничего не делаем!!!

         end; //if isDocBEGIN // если надо обработать только ошибки
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
procedure TMainForm.pCompleteDocument_Sale_IntNAL(isLastComplete:Boolean);
var
   CurrencyDocumentId:Integer;
   CurrencyPartnerId:Integer;
   zc_Enum_Currency_Basis:Integer;
   isDocBEGIN:Boolean;
begin
     if (not cbCompleteSaleIntNal.Checked)or(not cbCompleteSaleIntNal.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSaleIntNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.ObjectId');
        Add('     , Bill.OperDate');
        Add('     , Bill.InvNumber');
        Add('     , Bill.FromID');
        Add('     , Bill.ClientID');
        Add('     , Bill.isTare');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkNal() as zc_mkNal');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba._pgSelect_Bill_Sale_NAL('+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))+')');
        Add('     as Bill');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ClientID');

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
             Add('   and Bill.Id_Postgres>0'
                +'   and Bill.MoneyKindId=zc_mkNal()');
        end
        else
            Add('where Bill.Id_Postgres>0'
               +'  and Bill.MoneyKindId=zc_mkNal()');

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteSaleIntNal.Caption:='3.3.('+IntToStr(RecordCount)+')Прод.пок.НАЛ';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             //!!!ВАЛЮТА!!!
             begin
                   fOpenSqToQuery (' SELECT coalesce (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis())   AS CurrencyDocumentId'
                                  +'      , coalesce (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())    AS CurrencyPartnerId'
                                  +'      , zc_Enum_Currency_Basis()                       as zc_Enum_Currency_Basis'
                                  +' FROM Movement'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument'
                                  +'             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner'
                                  +'             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()'
                                  +' WHERE Movement.Id = '+IntToStr(FieldByName('Id_Postgres').AsInteger));
                       CurrencyDocumentId:=toSqlQuery.FieldByName('CurrencyDocumentId').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('CurrencyPartnerId').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('zc_Enum_Currency_Basis').AsInteger;
             end;
             //!!!если ВАЛЮТА, ничего не делаем!!!
             if (CurrencyDocumentId=zc_Enum_Currency_Basis) and (CurrencyPartnerId =zc_Enum_Currency_Basis)
             then begin
             //!!!если ВАЛЮТА, ничего не делаем!!!

             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;

             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkNal').AsInteger) then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_To.ObjectId, 0) AS ToId'
                                 +'       ,COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_To'
                                 +'                                   ON MLO_To.MovementId = Movement.Id'
                                 +'                                  AND MLO_To.DescId = zc_MovementLinkObject_To()'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_Sale()'
                                 );
                  if (FieldByName('isTare').AsInteger=zc_rvYes)
                    or ((toSqlQuery.FieldByName('ToId').AsInteger>0)
                     and(toSqlQuery.FieldByName('ContractId').AsInteger>0)
                       )
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                   end;
             end;
             //

             end; //if !!!если ВАЛЮТА, ничего не делаем!!!

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     myDisabledCB(cbCompleteSaleIntNal);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pCompleteDocument_Sale_Fl(isLastComplete:Boolean);
begin
{     if (not cbCompleteSaleFl.Checked)or(not cbCompleteSaleFl.Enabled) then exit;
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
     myDisabledCB(cbCompleteSaleFl);}
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn_IntBN(isLastComplete:Boolean);
var isDocBEGIN:Boolean;
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
        Add('     , Bill_find.findId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left join (select Bill.Id as BillId'
//           +'                     , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                     , max(isnull(case when GoodsProperty.InfoMoneyCode not in (20501) then BillItems.Id else 0 end,0))as findId'
           +'                from dba.Bill'
           +'                     left join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'                     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                  and Bill.Id_Postgres > 0'
           +'                  and Bill.BillKind in (zc_bkReturnToUnit(),zc_bkSendUnitToUnit())'
           +'                  and Bill.MoneyKindId=zc_mkBN()'
           +'                group by Bill.Id'
           +'                ) as Bill_find on Bill_find.BillId = Bill.Id'
           );
        Add('     left join dba.isUnit on isUnit.UnitId = Bill.FromId');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.Unit as Client on Client.ID = Bill.FromID');
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Client.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Client.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Id_Postgres > 0'
           +'  and Bill.BillKind in (zc_bkReturnToUnit(),zc_bkSendUnitToUnit())'
           +'  and Bill.ToId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF()'
           +'                   ,zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())'
           +'  and Bill.MoneyKindId=zc_mkBN()'
           +'  and isUnit.UnitId is null'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
        then
             Add('   and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteReturnInInt.Caption:='3.4.('+IntToStr(RecordCount)+')Воз.от пок.Int - БН';
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

             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin

             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;

             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger) then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_ReturnIn()'
                                 );
                  if (toSqlQuery.FieldByName('ContractId').AsInteger>0)//or(FieldByName('findId').AsInteger=0)
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;

         end; //if isDocBEGIN // если надо обработать только ошибки
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
procedure TMainForm.pCompleteDocument_ReturnIn_IntNal(isLastComplete:Boolean);
var isDocBEGIN:Boolean;
begin
     if (not cbCompleteReturnInIntNal.Checked)or(not cbCompleteReturnInIntNal.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnInIntNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill_find.OKPO');
        Add('     , Bill.FromID as ClientId');
        Add('     , Bill_find.findId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkNal() as zc_mkNal');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from (select Bill.Id as BillId'
           +'           , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO'
//           +'           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'           , max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'      from dba.Bill'
           +'           left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId'
           +'           left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'           left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                                and Information1.OKPO <> '+FormatToVarCharServer_notNULL('')
           +'           left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id'
           +'           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit(), zc_bkSendUnitToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()'
           +'                         ,zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF()'
           +'                         ,zc_UnitId_CompositionZ(),zc_UnitId_CompositionZ(),zc_UnitId_StorePav()'
           +'                         )'
           +'        and Bill.MoneyKindId = zc_mkNal()'
           +'        and Bill.Id_Postgres > 0'
           +'        and isUnitFrom.UnitId is null'
           +'        and (isnull (UnitFrom.PersonalId_Postgres, 0) = 0 OR Bill.ToId in (zc_UnitId_StoreSale(), zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()))'
           +'        and (isnull (UnitFrom.pgUnitId, 0) = 0 or UnitFrom.pgUnitId IN (3, 1625))' // !!!ф. Одесса OR ф. Никополь!!!
           +'        and OKPO <> '+FormatToVarCharServer_notNULL(''));
           if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
           then Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        Add('      group by Bill.Id, OKPO'
           +'      ) as Bill_find');

        Add('     left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteReturnInIntNal.Caption:='3.2.('+IntToStr(RecordCount)+')Воз.от пок.-НАЛ';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin

             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;

             if (cbComplete.Checked)and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkNal').AsInteger) then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_ReturnIn()'
                                 );
                  if (toSqlQuery.FieldByName('ContractId').AsInteger>0)//or(FieldByName('findId').AsInteger=0)
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     myDisabledCB(cbCompleteReturnInIntNal);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn_Fl(isLastComplete:Boolean);
begin
{     if (not cbCompleteReturnInFl.Checked)or(not cbCompleteReturnInFl.Enabled) then exit;
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
     myDisabledCB(cbCompleteReturnInFl);}
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
//!!!!INTEGER
function TMainForm.pLoadDocument_Sale_IntNal:Integer;
var ContractId_pg,PriceListId:Integer;
   CurrencyDocumentId:Integer;
   CurrencyPartnerId:Integer;
   zc_Enum_Currency_Basis:Integer;
   isDocBEGIN:Boolean;
begin
     Result:=0;
     if (not cbSaleIntNal.Checked)or(not cbSaleIntNal.Enabled) then exit;
     //
     myEnabledCB(cbSaleIntNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select * from dba._pgSelect_Bill_Sale_NAL('+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))+') as tmpSelect');

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' where tmpSelect.InvNumber_my = '+trim(OKPOEdit.Text))
        else

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=tmpSelect.InvNumber_my'
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
        cbSaleIntNal.Caption:='3.1.('+IntToStr(RecordCount)+')Прод.пок.Int - НАЛ';
        //
        //
        if cbShowContract.Checked
        then fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_SecondForm,'');
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
        toStoredProc.Params.AddParam ('inPersonalId',ftInteger,ptInput, 0);}
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
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
             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             //!!!ВАЛЮТА!!!
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                   fOpenSqToQuery (' SELECT coalesce (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis())   AS CurrencyDocumentId'
                                  +'      , coalesce (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())    AS CurrencyPartnerId'
                                  +'      , zc_Enum_Currency_Basis()                       as zc_Enum_Currency_Basis'
                                  +' FROM Movement'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument'
                                  +'             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner'
                                  +'             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()'
                                  +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString);
                       CurrencyDocumentId:=toSqlQuery.FieldByName('CurrencyDocumentId').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('CurrencyPartnerId').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('zc_Enum_Currency_Basis').AsInteger;
             end
             else begin
                       fOpenSqToQuery ('select zc_Enum_Currency_Basis() AS RetV');
                       CurrencyDocumentId:=toSqlQuery.FieldByName('RetV').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('RetV').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('RetV').AsInteger;
             end;
             //!!!если ВАЛЮТА, ничего не делаем!!!
             if (CurrencyDocumentId=zc_Enum_Currency_Basis) and (CurrencyPartnerId =zc_Enum_Currency_Basis)
             then begin
             //!!!если ВАЛЮТА, ничего не делаем!!!


             //!!!УДАЛЯЕМ ВСЕ ЭЛЕМЕНТЫ!!!
             if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             then
                  fExecSqToQuery ('select gpMovementItem_Sale_SetErased (MovementItem.Id, zfCalc_UserAdmin()) from MovementItem where MovementId = '+FieldByName('Id_Postgres').AsString);
             //!!!!!!!!!!!!!!!!!!

             //Прайс-лист не должен измениться
             {f FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ObjectId AS PriceListId from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_PriceList()');
                  PriceListId:=toSqlQuery.FieldByName('PriceListId').AsInteger;
             end
             else PriceListId:=0;}
             PriceListId:=FieldByName('PriceListId_pg').AsInteger;
             if {(PriceListId=0)and}(FieldByName('PriceWithVAT').AsInteger=zc_rvYes)then
             begin
                  if PriceListId<>0
                  then begin
                            fOpenSqToQuery ('select ObjectId AS RetV from ObjectBoolean where ObjectId='+IntToStr(PriceListId) + ' and DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = TRUE');
                            if toSqlQuery.FieldByName('RetV').AsInteger=0
                            then PriceListId:=302013;
                       end
                  else begin //fOpenSqToQuery ('select max (ObjectId) AS RetV from ObjectBoolean where DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = TRUE');
                             PriceListId:=302013;//toSqlQuery.FieldByName('RetV').AsInteger;
                       end;
                  // еще раз
                  if PriceListId=0 then
                  begin //fOpenSqToQuery ('select max (ObjectId) AS RetV from ObjectBoolean where DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = TRUE');
                        PriceListId:=302013;//toSqlQuery.FieldByName('RetV').AsInteger;
                  end;

                  if PriceListId=0 then
                  begin
                       ShowMessage('Ошибка-1 PriceListId = 0 BillId = ('+FieldByName('ObjectId').AsString+') Id_pg=('+FieldByName('Id_Postgres').AsString+')');
                       fStop:=true;
                       exit;
                  end;
             end
             else if PriceListId<>0 then
                  begin
                       fOpenSqToQuery ('select ObjectId AS RetV from ObjectBoolean where ObjectId='+IntToStr(PriceListId) + ' and DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = FALSE');
                       if toSqlQuery.FieldByName('RetV').AsInteger=0 then
                       begin
                            PriceListId:=0;
                            //ShowMessage('Ошибка-2 PriceListId = 0 BillId = ('+FieldByName('ObjectId').AsString+') Id_pg=('+FieldByName('Id_Postgres').AsString+')');
                            //fStop:=true;
                            //exit;
                       end;
                  end;
             //
             //находим договор НАЛ or БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_SecondForm,'');
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if (ContractId_pg=0)and(FieldByName('isTare').AsInteger=zc_rvNo)
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
             toStoredProc.Params.ParamByName('inPersonalId').Value:=FieldByName('PersonalId_Postgres').AsInteger;
             }
             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('RouteSortingId_pg').AsInteger;
             toStoredProc.Params.ParamByName('ioPriceListId').Value:=PriceListId;

             // для EDI - IsOnlyUpdateInt = TRUE
             if (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery ('select COALESCE(MovementChildId, 0) AS RetV from MovementLinkMovement where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId IN (zc_MovementLinkMovement_Sale(), zc_MovementLinkMovement_MasterEDI())');
                  if toSqlQuery.FieldByName('RetV').AsInteger > 0
                  then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=TRUE
                       // !!!для НАЛ - все данные из Integer!!!
                  else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
             end
                  // !!!для НАЛ - все данные из Integer!!!
             else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
             ;


             if not myExecToStoredProc then ;//exit;
             //
             if ((1=1)or(FieldByName('Id_Postgres').AsInteger=0))
             then begin fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value) + ' and isnull(Id_Postgres,0)<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
                        //fExecSqFromQuery('update dba.Bill join dba._pgBillLoad_union on _pgBillLoad_union.BillId_union = '+FieldByName('ObjectId').AsString +' and _pgBillLoad_union.BillId = Bill.Id set Bill.Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value) + ' and isnull(Bill.Id_Postgres,0)<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
                  end;
             //

             end; //if !!!если ВАЛЮТА, ничего не делаем!!!

         end; //if isDocBEGIN // если надо обработать только ошибки
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSaleIntNal);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Sale_IntNal(SaveCount:Integer);
var str:String;
    i:Integer;
   CurrencyDocumentId:Integer;
   CurrencyPartnerId:Integer;
   zc_Enum_Currency_Basis:Integer;
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
     if (not cbSaleIntNal.Checked)or(not cbSaleIntNal.Enabled) then exit;
     //
     myEnabledCB(cbSaleIntNal);
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
           //+'               then -1 * BillItems.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'               then -1 * BillItems.OperCount '
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
           +'           , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO'
           +'      from dba.Bill'
           +'           left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId'
           +'           left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId'
           +'           left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId'
           +'           left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId'
           +'           left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
           +'                                                                and Information1.OKPO <> '+FormatToVarCharServer_notNULL('')
           +'           left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkSaleToClient(), zc_bkSendUnitToUnit())'
           +'        and Bill.MoneyKindId = zc_mkNal()'
           +'        and Bill.Id_Postgres>0'
           +'        and isUnitFrom.UnitId is not null'
           +'        and isUnitTo.UnitId is null'
           +'        and (isnull (UnitTo.PersonalId_Postgres, 0) = 0 OR Bill.FromId = zc_UnitId_StoreSale())'
           +'        and (isnull (UnitTo.pgUnitId, 0) = 0 or UnitTo.pgUnitId IN (3, 1625))' // !!!ф. Одесса OR ф. Никополь!!!
           +'        and OKPO <> '+FormatToVarCharServer_notNULL('')
           +'     ) as Bill');

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=Bill.BillNumber'
                +'                           and _pgBillLoad.FromId=Bill.FromId');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');

        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = GoodsProperty.Id'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = KindPackage.Id'
           +'                                                                           and Bill.BillDate between tmpBI_byDiscountWeight.StartDate and tmpBI_byDiscountWeight.EndDate'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill.ToId'
           +'                                                                           and 1=1');
        if cbOnlyInsertDocument.Checked
        then Add('where isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');

        try
        Open;
        except
              myShowSql(Sql);
              fStop:=true;
              exit;
        end;

        cbSaleIntNal.Caption:='3.1.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Прод.пок.Int - НАЛ';
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

             //!!!ВАЛЮТА!!!
             begin
                   fOpenSqToQuery (' SELECT coalesce (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis())   AS CurrencyDocumentId'
                                  +'      , coalesce (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())    AS CurrencyPartnerId'
                                  +'      , zc_Enum_Currency_Basis()                       as zc_Enum_Currency_Basis'
                                  +' FROM Movement'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument'
                                  +'             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner'
                                  +'             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()'
                                  +' WHERE Movement.Id = '+FieldByName('MovementId_Postgres').AsString);
                       CurrencyDocumentId:=toSqlQuery.FieldByName('CurrencyDocumentId').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('CurrencyPartnerId').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('zc_Enum_Currency_Basis').AsInteger;
             end;
             //!!!если ВАЛЮТА, ничего не делаем!!!
             if (CurrencyDocumentId=zc_Enum_Currency_Basis) and (CurrencyPartnerId =zc_Enum_Currency_Basis)
             then begin
             //!!!если ВАЛЮТА, ничего не делаем!!!


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

             // для EDI - IsOnlyUpdateInt = TRUE
             if (FieldByName('MovementId_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery ('select COALESCE(MovementChildId, 0) AS RetV from MovementLinkMovement where MovementId='+FieldByName('MovementId_Postgres').AsString + ' and DescId IN (zc_MovementLinkMovement_Sale(), zc_MovementLinkMovement_MasterEDI())');
                  if toSqlQuery.FieldByName('RetV').AsInteger > 0
                  then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=TRUE
                       // !!!для НАЛ - все данные из Integer!!!
                  else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
             end
                  // !!!для НАЛ - все данные из Integer!!!
             else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
             ;

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

             end; //if !!!если ВАЛЮТА, ничего не делаем!!!


             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbSaleIntNal);
end;
//--------------------------------------------------------------------------*--------------------------------------------------------------------------
function TMainForm.pLoadDocument_Sale_IntBN:Integer;
var ContractId_pg,PriceListId:Integer;
   CurrencyDocumentId:Integer;
   CurrencyPartnerId:Integer;
   zc_Enum_Currency_Basis:Integer;
   isDocBEGIN:Boolean;
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

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' where tmpSelect.InvNumber_my = '+trim(OKPOEdit.Text))
        else

        if (cbBill_List.Checked)
        then
             Add(' inner join dba._pgBillLoad on _pgBillLoad.BillNumber=tmpSelect.InvNumber_my'
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
        cbSaleInt.Caption:='3.3.('+IntToStr(RecordCount)+')Прод.пок.Int - БН';
        //
        if cbShowContract.Checked
        then fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
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

             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             //
             //!!!ВАЛЮТА!!!
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                   fOpenSqToQuery (' SELECT coalesce (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis())   AS CurrencyDocumentId'
                                  +'      , coalesce (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())    AS CurrencyPartnerId'
                                  +'      , zc_Enum_Currency_Basis()                       as zc_Enum_Currency_Basis'
                                  +' FROM Movement'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument'
                                  +'             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner'
                                  +'             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()'
                                  +' WHERE Movement.Id = '+IntToStr(FieldByName('Id_Postgres').AsInteger));
                       CurrencyDocumentId:=toSqlQuery.FieldByName('CurrencyDocumentId').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('CurrencyPartnerId').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('zc_Enum_Currency_Basis').AsInteger;
             end
             else begin
                       fOpenSqToQuery ('select zc_Enum_Currency_Basis() AS RetV');
                       CurrencyDocumentId:=toSqlQuery.FieldByName('RetV').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('RetV').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('RetV').AsInteger;
             end;
             //!!!если ВАЛЮТА, ничего не делаем!!!
             if (CurrencyDocumentId=zc_Enum_Currency_Basis) and (CurrencyPartnerId =zc_Enum_Currency_Basis)
             then begin
             //!!!если ВАЛЮТА, ничего не делаем!!!


             //!!!УДАЛЯЕМ ВСЕ ЭЛЕМЕНТЫ!!!
             if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             then
                  fExecSqToQuery ('select gpMovementItem_Sale_SetErased (MovementItem.Id, zfCalc_UserAdmin()) from MovementItem where MovementId = '+FieldByName('Id_Postgres').AsString);
             //!!!!!!!!!!!!!!!!!!

             //Прайс-лист не должен измениться
             {if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ObjectId AS PriceListId from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_PriceList()');
                  PriceListId:=toSqlQuery.FieldByName('PriceListId').AsInteger;
             end
             else PriceListId:=0;}
             PriceListId:=FieldByName('PriceListId_pg').AsInteger;
             if {(PriceListId=0)and}(FieldByName('PriceWithVAT').AsInteger=zc_rvYes)then
             begin
                  if PriceListId<>0
                  then begin
                            fOpenSqToQuery ('select ObjectId AS RetV from ObjectBoolean where ObjectId='+IntToStr(PriceListId) + ' and DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = TRUE');
                            if toSqlQuery.FieldByName('RetV').AsInteger=0
                            then PriceListId:=302013;
                       end
                  else begin //fOpenSqToQuery ('select max (ObjectId) AS RetV from ObjectBoolean where DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = TRUE');
                             PriceListId:=302013;//toSqlQuery.FieldByName('RetV').AsInteger;
                       end;
                  // еще раз
                  if PriceListId=0 then
                  begin //fOpenSqToQuery ('select max (ObjectId) AS RetV from ObjectBoolean where DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = TRUE');
                        PriceListId:=302013;//toSqlQuery.FieldByName('RetV').AsInteger;
                  end;

                  if PriceListId=0 then
                  begin
                       ShowMessage('Ошибка-1 PriceListId = 0 BillId = ('+FieldByName('ObjectId').AsString+') Id_pg=('+FieldByName('Id_Postgres').AsString+')');
                       fStop:=true;
                       exit;
                  end;
             end
             else if PriceListId<>0 then
                  begin
                       fOpenSqToQuery ('select ObjectId AS RetV from ObjectBoolean where ObjectId='+IntToStr(PriceListId) + ' and DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() and ValueData = FALSE');
                       if toSqlQuery.FieldByName('RetV').AsInteger=0 then
                       begin
                            PriceListId:=0;
                            //ShowMessage('Ошибка-2 PriceListId = 0 BillId = ('+FieldByName('ObjectId').AsString+') Id_pg=('+FieldByName('Id_Postgres').AsString+')');
                            //fStop:=true;
                            //exit;
                       end;
                  end;
             //
             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
             //
             //сохранение
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if (ContractId_pg=0)and(FieldByName('isTare').AsInteger=zc_rvNo)
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
             toStoredProc.Params.ParamByName('inPersonalId').Value:=FieldByName('PersonalId_Postgres').AsInteger;
             }
             toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=FieldByName('RouteSortingId_pg').AsInteger;
             toStoredProc.Params.ParamByName('ioPriceListId').Value:=PriceListId;


             // для EDI - IsOnlyUpdateInt = TRUE
             if (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery ('select COALESCE(MovementChildId, 0) AS RetV from MovementLinkMovement where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId IN (zc_MovementLinkMovement_Sale(), zc_MovementLinkMovement_MasterEDI())');
                  if toSqlQuery.FieldByName('RetV').AsInteger > 0
                  then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=TRUE
                  else if FieldByName('isOnlyUpdateInt').AsInteger=zc_rvNo
                       then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
                       else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=cbOnlyUpdateInt.Checked
             end
             else if FieldByName('isOnlyUpdateInt').AsInteger=zc_rvNo
                  then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
                  else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=cbOnlyUpdateInt.Checked
             ;

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

             end; //if !!!если ВАЛЮТА, ничего не делаем!!!

         end; //if isDocBEGIN // если надо обработать только ошибки
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
procedure TMainForm.pLoadDocumentItem_Sale_IntBN (SaveCount:Integer);
var
   CurrencyDocumentId:Integer;
   CurrencyPartnerId:Integer;
   zc_Enum_Currency_Basis:Integer;
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
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
//           +'               then -1 * BillItems.OperCount / (1 - tmpBI_byDiscountWeight.DiscountWeight/100)'
           +'               then -1 * BillItems.OperCount'
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
           +'        and Bill.MoneyKindId = zc_mkBN()' // Bill.Id_Postgres>0
           +'        and Bill.Id_Postgres>0'
           +'     union all'
           +'      select Bill.*'
           +'      from dba.Bill'
           +'           left join dba.isUnit on isUnit.UnitId = Bill.ToId'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkSendUnitToUnit())'
           //+'        and Bill.FromId=zc_UnitId_StoreSale()'
           +'        and Bill.MoneyKindId = zc_mkBN()' // Bill.Id_Postgres>0
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
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('     left outer join dba._Client_byDiscountWeight as tmpBI_byDiscountWeight on tmpBI_byDiscountWeight.GoodsPropertyId = GoodsProperty.Id'
           +'                                                                           and tmpBI_byDiscountWeight.KindPackageId = KindPackage.Id'
           +'                                                                           and Bill.BillDate between tmpBI_byDiscountWeight.StartDate and tmpBI_byDiscountWeight.EndDate'
           +'                                                                           and tmpBI_byDiscountWeight.ToId = Bill.ToId'
           +'                                                                           and 1=1');
        if cbOnlyInsertDocument.Checked
        then Add('where isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');

        if cbShowContract.Checked then myShowSql(fromQuery.Sql);

        Open;
        cbSaleInt.Caption:='3.3.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Прод.пок.Int - БН';
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
             //!!!ВАЛЮТА!!!
             begin
                   fOpenSqToQuery (' SELECT coalesce (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis())   AS CurrencyDocumentId'
                                  +'      , coalesce (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())    AS CurrencyPartnerId'
                                  +'      , zc_Enum_Currency_Basis()                       as zc_Enum_Currency_Basis'
                                  +' FROM Movement'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument'
                                  +'             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()'
                                  +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner'
                                  +'             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id'
                                  +'            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()'
                                  +' WHERE Movement.Id = '+FieldByName('MovementId_Postgres').AsString);
                       CurrencyDocumentId:=toSqlQuery.FieldByName('CurrencyDocumentId').AsInteger;
                       CurrencyPartnerId:=toSqlQuery.FieldByName('CurrencyPartnerId').AsInteger;
                       zc_Enum_Currency_Basis:=toSqlQuery.FieldByName('zc_Enum_Currency_Basis').AsInteger;
             end;
             //!!!если ВАЛЮТА, ничего не делаем!!!
             if (CurrencyDocumentId=zc_Enum_Currency_Basis) and (CurrencyPartnerId =zc_Enum_Currency_Basis)
             then begin
             //!!!если ВАЛЮТА, ничего не делаем!!!


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

             // для EDI - IsOnlyUpdateInt = TRUE
             if (FieldByName('MovementId_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery ('select COALESCE(MovementChildId, 0) AS RetV from MovementLinkMovement where MovementId='+FieldByName('MovementId_Postgres').AsString + ' and DescId IN (zc_MovementLinkMovement_Sale(), zc_MovementLinkMovement_MasterEDI())');
                  if toSqlQuery.FieldByName('RetV').AsInteger > 0
                  then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=TRUE
                  else if FieldByName('isOnlyUpdateInt').AsInteger=zc_rvNo
                       then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
                       else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=cbOnlyUpdateInt.Checked
             end
             else if FieldByName('isOnlyUpdateInt').AsInteger=zc_rvNo
                  then toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=FALSE
                  else toStoredProc.Params.ParamByName('inIsOnlyUpdateInt').Value:=cbOnlyUpdateInt.Checked
             ;

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

             end; //if !!!если ВАЛЮТА, ничего не делаем!!!

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
{     Result:=0;
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
        //toStoredProc.Params.AddParam ('inCarId',ftInteger,ptInput, 0);
        //toStoredProc.Params.AddParam ('inPersonalDriverId',ftInteger,ptInput, 0);
        //toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        //toStoredProc.Params.AddParam ('inPersonalId',ftInteger,ptInput, 0);
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
             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('ToId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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
             //toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             //toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;
             //toStoredProc.Params.ParamByName('inRouteId').Value:=FieldByName('RouteId').AsInteger;
             //toStoredProc.Params.ParamByName('inPersonalId').Value:=FieldByName('PersonalId_Postgres').AsInteger;

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
     myDisabledCB(cbSaleFl);}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pLoadDocumentItem_Sale_Fl_Int (SaveCount1:Integer);
begin
{     if (cbOKPO.Checked)then exit;
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
        //Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                                     and GoodsProperty.InfoMoneyCode in(20901,30101)'); // Ирна  + Готовая продукция
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
             if fStop then begin exit;end;
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
     myDisabledCB(cbSaleFl);}
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
        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and (Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'    or (Bill.BillKind=zc_bkIncomeToUnit() and (Bill.FromId in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'                                            or isUnitFrom.UnitId is not null))'
           +'      )'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           +'  and Id_Postgres >0'
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
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.BillNumber || case when (FromId_Postgres is null)'
           +'                                 or (ToId_Postgres is null)'
           +'                                    then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when FromId_Postgres is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' От Кого:')+'|| UnitFrom.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when ToId_Postgres is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' Кому:')+'|| UnitTo.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'       as InvNumber');
        Add('     , case when Bill.FromId in (5347) then ToId_Postgres else isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) end as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
// +' and Bill.Id_Postgres=22081'
           +'  and (Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'    or (Bill.BillKind=zc_bkIncomeToUnit() and (Bill.FromId in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'                                            or isUnitFrom.UnitId is not null))'
           +'      )'
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
        toStoredProc.Params.AddParam ('inIsPeresort',ftBoolean,ptInput, false);
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
             toStoredProc.Params.ParamByName('inIsPeresort').Value:=false;

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

        Add('     , isnull(BillItems.PartionDate,zc_DateStart()) as PartionGoodsDate');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , BillItems.OperComment as OperComment');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , KindPackage_zakaz.Id_Postgres as GoodsKindId_zakaz_Postgres');
        Add('     , Receipt_byHistory.Id_pg as ReceiptId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.Receipt_byHistory on Receipt_byHistory.ReceiptId = BillItems.ReceiptId');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('     left outer join dba.KindPackage as KindPackage_zakaz on KindPackage_zakaz.Id = BillItems.KindPackageId_zakaz');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and (Bill.BillKind in (zc_bkProductionInFromReceipt())'
           +'    or (Bill.BillKind=zc_bkIncomeToUnit() and (Bill.FromId in (5347)' //ИЗЛИШКИ ПО ПРИХОДУ СО
           +'                                            or isUnitFrom.UnitId is not null))'
           +'      )'
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
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ProductionUnion_Master_Sybase';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsPartionClose',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inRealWeight',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCuterCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindCompleteId',ftInteger,ptInput, 0);
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
             then toStoredProc.Params.ParamByName('inIsPartionClose').Value:=true
             else toStoredProc.Params.ParamByName('inIsPartionClose').Value:=false;
             toStoredProc.Params.ParamByName('inCount').Value:=FieldByName('shCount').AsFloat;
             toStoredProc.Params.ParamByName('inRealWeight').Value:=FieldByName('RealWeight').AsFloat;
             toStoredProc.Params.ParamByName('inCuterCount').Value:=FieldByName('CuterCount').AsFloat;
             if FieldByName('PartionGoodsDate').AsDateTime <= StrToDate('01.01.1900')
             then toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=StrToDate('01.01.1900')
             else toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=FieldByName('PartionGoodsDate').AsDateTime;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('OperComment').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsKindCompleteId').Value:=FieldByName('GoodsKindId_zakaz_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inReceiptId').Value:=FieldByName('ReceiptId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
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
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ProductionUnion_Child_Sybase';
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
        Add('     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
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
        Add('     , Bill.BillDate as OperDate');
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
        Add('     , Bill.PartionStr_MB as PartionGoods');
        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');
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
        Add('     , BillItems.OperCount_Upakovka as LiveWeight');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.IsProduction=zc_rvNo()');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
        toStoredProc.Params.AddParam ('inLiveWeight',ftFloat,ptInput, 0);
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
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
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
        Add('     , BillItems.OperCount_Upakovka as LiveWeight');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.IsProduction=zc_rvYes()');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inLiveWeight',ftFloat,ptInput, 0);
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
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
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
var isDocBEGIN:Boolean;
begin
     if (not cbCompleteReturnOutBN.Checked)or(not cbCompleteReturnOutBN.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnOutBN);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as InfoMoneyCode');
        Add('     , Bill_findInfoMoney.findId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
//           +'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           left outer join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                        and Bill.BillKind=zc_bkReturnToClient()'
           +'                        and Bill.Id_Postgres>0'
           +'                        and Bill.MoneyKindId = zc_mkBN()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and Id_Postgres >0'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;
        Add('order by InfoMoneyCode,OperDate,ObjectId');
        Open;
        cbCompleteReturnOutBN.Caption:='1.2. ('+IntToStr(RecordCount)+') Возврат поставщику - БН';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked){and(FieldByName('MoneyKindId').AsInteger=FieldByName('zc_mkBN').AsInteger)} then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_ReturnOut()'
                                 );
                  if (toSqlQuery.FieldByName('ContractId').AsInteger>0)//or(FieldByName('findId').AsInteger=0)
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     myDisabledCB(cbCompleteReturnOutBN);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_ReturnOut:Integer;
var JuridicalId_pg,PartnerId_pg,ContractId_pg:Integer;
    isDocBEGIN:Boolean;
begin
     Result:=0;
     if (not cbReturnOutBN.Checked)or(not cbReturnOutBN.Enabled) then exit;
     //
     myEnabledCB(cbReturnOutBN);
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
//           +'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
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
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
//           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' and Bill.BillNumber = '+trim(OKPOEdit.Text))
        else

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbReturnOutBN.Caption:='1.3. ('+IntToStr(RecordCount)+') Возврат поставщику - БН';
        //
        //
        if cbShowContract.Checked
        then begin
             //Сначала находим контрагента  и юр.лицо
             fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                           +' from ObjectHistory_JuridicalDetails_View'
                           +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                           +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                           +' where OKPO='+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)
                           +'   and '+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)+'<>'+FormatToVarCharServer_notNULL('')
                           );
             JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             //находим договор НАЛ
             fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_FirstForm,FieldByName('OperDate').AsDateTime);
        end;
        //
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
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
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
             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                  cbUpdateConrtact.Checked:=TRUE;
                  //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
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
                  else //находим договор БН
                       ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_FirstForm,FieldByName('OperDate').AsDateTime);
             end
             else //находим договор БН
                  ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_FirstForm,FieldByName('OperDate').AsDateTime);
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

         end; //if isDocBEGIN // если надо обработать только ошибки
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnOutBN);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_ReturnOut(SaveCount:Integer);
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
     if (not cbReturnOutBN.Checked)or(not cbReturnOutBN.Enabled) then exit;
     //
     myEnabledCB(cbReturnOutBN);
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
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbReturnOutBN.Caption:='1.3. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Возврат поставщику - БН';
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
        toStoredProc.Params.AddParam ('ioAmount',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioAmountPartner',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inIsCalcAmountPartner',ftBoolean,ptInput, TRUE);
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
             toStoredProc.Params.ParamByName('ioAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
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
     myDisabledCB(cbReturnOutBN);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnOutNal(isLastComplete:Boolean);
var isDocBEGIN:Boolean;
begin
     if (not cbCompleteReturnOutNal.Checked)or(not cbCompleteReturnOutNal.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnOutNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , Bill_findInfoMoney.InfoMoneyCode as InfoMoneyCode');
        Add('     , Bill_findInfoMoney.findId');
        Add('     , Bill.MoneyKindId');
        Add('     , zc_mkBN() as zc_mkBN');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
//           +'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           left outer join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'                        and Bill.BillKind=zc_bkReturnToClient()'
           +'                        and Bill.Id_Postgres>0'
           +'                        and Bill.MoneyKindId = zc_mkNal()'
           +'                      group by Bill.Id'
           +'                     ) as Bill_findInfoMoney on Bill_findInfoMoney.BillId=Bill.Id');
        Add('     left join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add('     left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID'
                +'                                                          and Information1.OKPO <> '+FormatToVarCharServer_notNULL(''));
             Add('     left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id');
        end;
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and Id_Postgres >0'
           +'  and Bill.MoneyKindId = zc_mkNal()'
           );
        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;
        Add('order by InfoMoneyCode,OperDate,ObjectId');
        Open;
        cbCompleteReturnOutNal.Caption:='1.5. ('+IntToStr(RecordCount)+') Возврат поставщику - НАЛ';
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
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;
             if (cbComplete.Checked) then
             begin
                  // проверка что он проведется
                  fOpenSqToQuery (' select COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_ReturnOut()'
                                 );
                  if (toSqlQuery.FieldByName('ContractId').AsInteger>0)//or(FieldByName('findId').AsInteger=0)
                  then begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsLastComplete').Value:=isLastComplete;
                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     myDisabledCB(cbCompleteReturnOutNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_ReturnOutNal:Integer;
var JuridicalId_pg,PartnerId_pg,ContractId_pg:Integer;
    isDocBEGIN:Boolean;
begin
     Result:=0;
     if (not cbReturnOutNal.Checked)or(not cbReturnOutNal.Enabled) then exit;
     //
     myEnabledCB(cbReturnOutNal);
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
        Add('     , zf_isOKPO_Virtual_PG(OKPO) as isOKPO_Virtual');
        Add('     , UnitTo.Id3_Postgres as ToId_pg_find');

        Add('     , Bill.FromId, Bill.ToId');
        Add('     , Bill_findInfoMoney.findId');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join (select Bill.Id as BillId'
           +'                            ,max(isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode'
//           +'                            ,max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'                            ,max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'                      from dba.Bill'
           +'                           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'                           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'                      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'                         and Bill.BillKind=zc_bkReturnToClient()'
           +'                         and Bill.MoneyKindId = zc_mkNal()'
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
           +'  and Bill.FromId not in (3830, 3304,10594,10598)' //КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
           +'  and Bill.ToId not in (3830, 3304,10594,10598)'  // КРОТОН ООО (хранение) + КРОТОН ООО + ДЮКОВ Ю.О. (хранение) + ДЮКОВ Ю.О.  услуги
//           +'  and UnitFrom.PersonalId_Postgres is null'
           +'  and Bill.MoneyKindId = zc_mkNal()'
           );

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' and Bill.BillNumber = '+trim(OKPOEdit.Text))
        else

        if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'') then
        begin
             Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));
        end;

        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbReturnOutNal.Caption:='1.5. ('+IntToStr(RecordCount)+') Возврат поставщику - НАЛ';
        //
        //
        if cbShowContract.Checked
        then begin
             if FieldByName('isOKPO_Virtual').AsInteger=zc_rvYes
             then begin
                       //находим юр.лицо
                       fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                     +' from ObjectLink'
                                     +' where ObjectLink.ObjectId='+IntToStr(FieldByName('ToId_pg_find').AsInteger)
                                     +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                     );
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end
             else begin
                  //Сначала находим контрагента  и юр.лицо
                  fOpenSqToQuery(' select coalesce(ObjectLink.ObjectId,0) as PartnerId, coalesce(ObjectHistory_JuridicalDetails_View.JuridicalId,0)as JuridicalId'
                                +' from ObjectHistory_JuridicalDetails_View'
                                +'      left join ObjectLink on ObjectLink.ChildObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId'
                                +'                          and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                +' where OKPO='+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)
                                +'   and '+FormatToVarCharServer_notNULL(FieldByName('OKPO').AsString)+'<>'+FormatToVarCharServer_notNULL('')
                                );
                  JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end;
             //находим договор НАЛ
             fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_SecondForm,FieldByName('OperDate').AsDateTime);
        end;
        //
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
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
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
             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             if FieldByName('isOKPO_Virtual').AsInteger=zc_rvYes
             then begin
                       //находим юр.лицо
                       fOpenSqToQuery(' select ObjectLink.ChildObjectId as JuridicalId'
                                     +' from ObjectLink'
                                     +' where ObjectLink.ObjectId='+IntToStr(FieldByName('ToId_pg_find').AsInteger)
                                     +'   and ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()'
                                     );
                        PartnerId_pg:=FieldByName('ToId_pg_find').AsInteger;
                        JuridicalId_pg:=toSqlQuery.FieldByName('JuridicalId').AsInteger;
             end
             else begin
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
             end;

             //находим договор НАЛ
             ContractId_pg:=fFindIncome_ContractId_pg(JuridicalId_pg,FieldByName('CodeIM').AsInteger,FieldByName('InfoMoneyId_pg').AsInteger,zc_Enum_PaidKind_SecondForm,FieldByName('OperDate').AsDateTime);

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

         end; //if isDocBEGIN // если надо обработать только ошибки
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnOutNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_ReturnOutNal(SaveCount:Integer);
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
     if (not cbReturnOutNal.Checked)or(not cbReturnOutNal.Enabled) then exit;
     //
     myEnabledCB(cbReturnOutNal);
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
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkReturnToClient()'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           +'  and Bill.MoneyKindId = zc_mkNal()'
           );
        Add('order by Bill.BillDate, ObjectId');
        Open;
        cbReturnOutNal.Caption:='1.5. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Возврат поставщику - НАЛ';
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
        toStoredProc.Params.AddParam ('ioAmount',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioAmountPartner',ftFloat,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inIsCalcAmountPartner',ftBoolean,ptInput, TRUE);
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
             toStoredProc.Params.ParamByName('ioAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
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
     myDisabledCB(cbReturnOutNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!INTEGER
function TMainForm.pLoadDocument_ReturnInNal:Integer;
var ContractId_pg:Integer;
    InvNumberMark:String;
    isDocBEGIN:Boolean;
begin
     Result:=0;
     if (not cbReturnInIntNal.Checked)or(not cbReturnInIntNal.Enabled) then exit;
     //
     myEnabledCB(cbReturnInIntNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0'
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when FromId_Postgres is null then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when CodeIM = 0 then '+FormatToVarCharServer_notNULL('-УП статья:???')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , OperDate as OperDatePartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , case when UnitFrom.pgUnitId = 3' // ф. Одесса
          + '                 then 298605' // ОГОРЕНКО новый дистрибьютор
          + '            when UnitFrom.pgUnitId = 1625' // ф. Никополь
          + '                 then 256624' // Мержиєвський О.В. ФОП дистрибьютор
          //+ '            when UnitFrom.pgUnitId = 5' // ф.Крым
          //+ '                 then ' // Мержиєвський О.В. ФОП дистрибьютор
          + '            else isnull (_pgPartner.PartnerId_pg, UnitFrom.Id3_Postgres)'
          + '       end as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');
        Add('     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres');
        Add('     , CodeIM');
        Add('     , Bill_find.findId');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from (select Bill.Id as BillId'
           +'           , min(case when Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil(), zc_UnitId_StorePav())'
           +'                           then 30101' // Готовая продукция
           +'                      when Bill.ToId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
           +'                           then 30201' // Мясное сырье
           +'                      when GoodsProperty.InfoMoneyCode in (20700)'
           +'                           then 30201' // Прочие товары
           +'                      else 30501' // Прочие доходы
           +'                 end) as CodeIM'
           +'           , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO'
//           +'           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'           , max(isnull(case when GoodsProperty.Id is not null then BillItems.Id else 0 end,0))as findId'
           +'      from dba.Bill'
           +'           left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId'
           +'           left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'           left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                                and Information1.OKPO <> '+FormatToVarCharServer_notNULL('')
           +'           left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id'
           +'           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
           +'                                            and (GoodsProperty.InfoMoneyCode not in (20501)' // Оборотная тара
           +'                                              or (BillItems.OperCount<>0 and BillItems.OperPrice<>0))'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit(), zc_bkSendUnitToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()'
           +'                         ,zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF()'
           +'                         ,zc_UnitId_CompositionZ(),zc_UnitId_CompositionZ(),zc_UnitId_StorePav()'
           +'                         )'
           +'        and Bill.MoneyKindId = zc_mkNal()'
           +'        and isUnitFrom.UnitId is null'
           +'        and (isnull (UnitFrom.PersonalId_Postgres, 0) = 0 OR Bill.ToId in (zc_UnitId_StoreSale(), zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()))'
           +'        and (isnull (UnitFrom.pgUnitId, 0) = 0 or UnitFrom.pgUnitId IN (3, 1625))' // !!!ф. Одесса OR ф. Никополь!!!
           +'        and OKPO <> '+FormatToVarCharServer_notNULL(''));
           if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
           then Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));

        Add('      group by Bill.Id, OKPO'
           +'      ) as Bill_find');

        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');
        Add('          left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                          ) as _pgPartner on _pgPartner.UnitId = Bill.FromId');

        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' where Bill.BillNumber = '+trim(OKPOEdit.Text))
        else

        if cbOnlyInsertDocument.Checked
        then Add('where isnull(Bill.Id_Postgres,0)=0');

        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbReturnInIntNal.Caption:='3.2.('+IntToStr(RecordCount)+')Воз.от пок.Int - НАЛ';
        //
        if cbShowContract.Checked
        then fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_SecondForm,'');
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
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
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
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');


        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             //Номер "перекресленої зеленої марки зi складу" не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ValueData AS InvNumberMark from MovementString where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementString_InvNumberMark()');
                  InvNumberMark:=toSqlQuery.FieldByName('InvNumberMark').AsString;
             end
             else InvNumberMark:='';

             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_SecondForm,'');
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if (ContractId_pg=0)and(FieldByName('findId').AsInteger<>0)
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

         end; //if isDocBEGIN // если надо обработать только ошибки
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnInIntNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_ReturnInNal(SaveCount:Integer);
begin
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
     if (not cbReturnInIntNal.Checked)or(not cbReturnInIntNal.Enabled) then exit;
     //
     myEnabledCB(cbReturnInIntNal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , Bill_find.OKPO');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , zc_rvYes() as IsChangeAmount');
        Add('     , abs (BillItems.OperCount) as AmountPartner');
        Add('     , abs (BillItems.OperCount) as Amount');

        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');

        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+isnull(KindPackage.KindPackageName,'+FormatToVarCharServer_notNULL('')+')+'+FormatToVarCharServer_notNULL(')')
//           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from (select Bill.Id as BillId'
           +'           , isnull (Information1.OKPO, isnull (Information2.OKPO, '+FormatToVarCharServer_notNULL('')+')) AS OKPO'
           +'      from dba.Bill'
           +'           left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId'
           +'           left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'           left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitFrom.InformationFromUnitID'
           +'                                                                and Information1.OKPO <> '+FormatToVarCharServer_notNULL('')
           +'           left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitFrom.Id'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind in (zc_bkReturnToUnit(), zc_bkSendUnitToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()'
           +'                         ,zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF()'
           +'                         ,zc_UnitId_CompositionZ(),zc_UnitId_CompositionZ(),zc_UnitId_StorePav()'
           +'                         )'
           +'        and Bill.MoneyKindId = zc_mkNal()'
           +'        and Bill.Id_Postgres>0'
           +'        and isUnitFrom.UnitId is null'
           +'        and (isnull (UnitFrom.PersonalId_Postgres, 0) = 0 OR Bill.ToId in (zc_UnitId_StoreSale(), zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()))'
           +'        and (isnull (UnitFrom.pgUnitId, 0) = 0 or UnitFrom.pgUnitId IN (3, 1625))' // !!!ф. Одесса OR ф. Никополь!!!
           +'        and OKPO <> '+FormatToVarCharServer_notNULL(''));
           if (cbOKPO.Checked)and (trim(OKPOEdit.Text)<>'')
           then Add(' and isnull (Information1.OKPO, Information2.OKPO)=' + FormatToVarCharServer_notNULL(trim(OKPOEdit.Text)));

        Add('      group by Bill.Id, OKPO'
           +'      ) as Bill_find');

        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька

        if cbOnlyInsertDocument.Checked
        then Add('where isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbReturnInIntNal.Caption:='3.2.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Воз.от пок.Int - НАЛ';
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
     myDisabledCB(cbReturnInIntNal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_ReturnIn:Integer;
var ContractId_pg:Integer;
    InvNumberMark,InvNumberPartner:String;
    OperDate,OperDatePartner:TDateTime;
   isDocBEGIN:Boolean;
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
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0'
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when FromId_Postgres is null then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when CodeIM = 0 then '+FormatToVarCharServer_notNULL('-УП статья:???')+' else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');

        Add('     , OperDate as OperDatePartner');

        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent');

        Add('     , _pgPartner.PartnerId_pg as FromId_Postgres');
        Add('     , isnull (pgPersonalTo.Id_Postgres, pgUnitTo.Id_Postgres) as ToId_Postgres');
        Add('     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres');
        Add('     , CodeIM');
        Add('     , isnull(Contract.ContractNumber,'+FormatToVarCharServer_notNULL('')+') as ContractNumber');
        Add('     , Bill_find.findId');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from (select Bill.Id as BillId'
           +'           , 30201 as CodeIM' // Мясное сырье
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
//           +'           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'           , max(isnull(case when GoodsProperty.InfoMoneyCode not in (20501) then BillItems.Id else 0 end,0))as findId'
           +'      from dba.Bill'
           +'           left join dba.isUnit on isUnit.UnitId = Bill.FromId'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
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
           +'        and Bill.BillKind in (zc_bkReturnToUnit(),zc_bkSendUnitToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'        and isUnit.UnitId is null'
           +'      group by Bill.Id'
           +'     union all'
           +'      select Bill.Id as BillId'
           +'           , 30101 as CodeIM' // Готовая продукция
           +'           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find'
//           +'           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId'
           +'           , max(isnull(case when GoodsProperty.InfoMoneyCode not in (20501) then BillItems.Id else 0 end,0))as findId'
           +'      from dba.Bill'
           +'           left join dba.isUnit on isUnit.UnitId = Bill.FromId'
           +'           join dba.BillItems on BillItems.BillId = Bill.Id and (BillItems.OperCount<>0 or BillItems.Id_Postgres<>0)'
           +'           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId'
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
           +'        and Bill.BillKind in (zc_bkReturnToUnit(),zc_bkSendUnitToUnit())'
           +'        and Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil(),zc_UnitId_StorePav())'
           +'        and Bill.MoneyKindId = zc_mkBN()'
           +'        and isUnit.UnitId is null'
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

        if (cbShowContract.Checked)and(trim(OKPOEdit.Text)<>'')
        then
             Add(' where Bill.BillNumber = '+trim(OKPOEdit.Text))
        else

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
        cbReturnInInt.Caption:='3.3.('+IntToStr(RecordCount)+')Воз.от пок.Int - БН';
        //
        if cbShowContract.Checked
        then fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
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
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyPartnerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             //
             //!!!если надо обработать только ошибки!!!
             if (cbDocERROR.Checked)and(FieldByName('Id_Postgres').AsInteger>0) then
             begin
                 //Сначала находим статус документе, если он проведене или удален - ничего не делаем
                  fOpenSqToQuery ('select StatusId, zc_Enum_Status_UnComplete() as zc_Enum_Status_UnComplete from Movement where Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));
                  isDocBEGIN:=toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_UnComplete').AsInteger;
             end
             else isDocBEGIN:=true;
         if isDocBEGIN then
         begin
             //
             //Номер "перекресленої зеленої марки зi складу" не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery (' select Movement.OperDate'
                                 +'      , MD_OperDatePartner.ValueData AS OperDatePartner'
                                 +'      , MS_InvNumberPartner.ValueData AS InvNumberPartner'
                                 +'      , MS_InvNumberMark.ValueData AS InvNumberMark'
                                 +' from Movement'
                                 +'      left join MovementDate AS MD_OperDatePartner on MD_OperDatePartner.MovementId = Movement.Id and MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()'
                                 +'      left join MovementString AS MS_InvNumberPartner on MS_InvNumberPartner.MovementId = Movement.Id and MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()'
                                 +'      left join MovementString AS MS_InvNumberMark on MS_InvNumberMark.MovementId = Movement.Id and MS_InvNumberMark.DescId = zc_MovementString_InvNumberMark()'
                                 +' where Movement.Id='+FieldByName('Id_Postgres').AsString);
                  OperDate:=toSqlQuery.FieldByName('OperDate').AsDateTime;
                  OperDatePartner:=toSqlQuery.FieldByName('OperDatePartner').AsDateTime;
                  InvNumberPartner:=toSqlQuery.FieldByName('InvNumberPartner').AsString;
                  InvNumberMark:=toSqlQuery.FieldByName('InvNumberMark').AsString;

             end
             else begin OperDate:=FieldByName('OperDate').AsDateTime;
                        OperDatePartner:=FieldByName('OperDatePartner').AsDateTime;
                        InvNumberPartner:='';
                        InvNumberMark:='';
                  end;

             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if (ContractId_pg=0)and(FieldByName('findId').AsInteger<>0)
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=InvNumberPartner;
             toStoredProc.Params.ParamByName('inInvNumberMark').Value:=InvNumberMark;

             toStoredProc.Params.ParamByName('inOperDate').Value:=OperDate;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=OperDatePartner;

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

         end; //if isDocBEGIN // если надо обработать только ошибки
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
     if (cbOKPO.Checked)or(cbDocERROR.Checked)then exit;
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

        Add('     , case when Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())'
           +'             and Bill.BillDate >=zc_def_StartDate_PG()'
           +'                 then zc_rvNo()'
           +'            else zc_rvYes()'
           +'       end as IsChangeAmount');
        Add('     , abs (BillItems.OperCount) as AmountPartner');
        Add('     , abs (BillItems.OperCount) as Amount');

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
        Add('     left join dba.isUnit on isUnit.UnitId = Bill.FromId');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind in (zc_bkReturnToUnit(),zc_bkSendUnitToUnit())'
           +'  and Bill.Id_Postgres>0'
           +'  and Bill.ToId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF(), zc_UnitId_StoreSalePF()'
           +'                   ,zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())'
           +'  and Bill.MoneyKindId = zc_mkBN()'
           +'  and isUnit.UnitId is null'
//           +'  and BillItems.GoodsPropertyId<>1041' //КОВБАСНI ВИРОБИ
// +'  and 1=0'
// +'  and MovementId_Postgres = 10154'
           );
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbReturnInInt.Caption:='3.4.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Воз.от пок.Int - БН';
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
{     Result:=0;
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
        //Add('          left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId'
        //   +'                           from dba.Unit'
        //   +'                            left outer join dba.ContractKind_byHistory as find1'
        //   +'                                on find1.ClientId = Unit.DolgByUnitID'
        //   +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find1.StartDate and find1.EndDate'
        //   +'                              and find1.ContractNumber <> '+FormatToVarCharServer_notNULL('')
        //   +'                           left outer join dba.ContractKind_byHistory as find2'
        //   +'                               on find2.ClientId = Unit.Id'
        //   +'                              and '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' between find2.StartDate and find2.EndDate'
        //   +'                              and find2.ContractNumber <> '+FormatToVarCharServer_notNULL('')
        //   +'                           group by Unit.Id'
        //   +'                          ) as Contract_find on Contract_find.ClientId = Bill.FromId'
        Add('          left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find'); // Contract_find.Id
        Add('          left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId'
           +'                          ) as Unit_byLoad_From on Unit_byLoad_From.UnitId = Bill.FromId');
        Add('          left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                          ) as _pgPartner on _pgPartner.UnitId = Unit_byLoad_From.Id_byLoad');
//        Add('          left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg'
//           +'                           from dba._pgPartner'
//           +'                           where _pgPartner.JuridicalId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '+FormatToVarCharServer_notNULL('30101')
//           +'                           group by _pgPartner.JuridicalId_pg'
//           +'                          ) as _pgContract_30101 on _pgContract_30101.JuridicalId_pg = _pgPartner.JuridicalId_pg'
//           +'                                                and Bill_find.CodeIM = 30101');
//        Add('          left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg'
//           +'                           from dba._pgPartner'
//           +'                           where _pgPartner.JuridicalId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '+FormatToVarCharServer_notNULL('30103')
//           +'                           group by _pgPartner.JuridicalId_pg'
//           +'                          ) as _pgContract_30103 on _pgContract_30103.JuridicalId_pg = _pgPartner.JuridicalId_pg'
//           +'                                                and Bill_find.CodeIM = 30103');
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
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
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
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');

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
             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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
     myDisabledCB(cbReturnInFl);}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//!!!!FLOAT
procedure TMainForm.pLoadDocumentItem_ReturnIn_Fl(SaveCount:Integer);
begin
{     if (cbOKPO.Checked)then exit;
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
        //Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                                       and GoodsProperty.InfoMoneyCode in(20901,30101)'); // Ирна  + Готовая продукция
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
             if fStop then begin exit;end;
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
     myDisabledCB(cbReturnInFl);}
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
                           fOpenSqToQuery (' select case when MovementBoolean_Medoc.ValueData = TRUE or MovementBoolean.ValueData = TRUE'
                                         +'              then '+IntToStr(zc_rvYes)+' else '+IntToStr(zc_rvNo)
                                         +'         end as isMedoc'
                                         +' from Movement'
                                         +'      left join MovementLinkMovement as MovementLinkMovement_Tax on MovementLinkMovement_Tax.MovementId=Movement.Id and MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()'
                                         +'      left join MovementBoolean on MovementBoolean.MovementId = Movement.Id AND MovementBoolean.DescId = zc_MovementBoolean_Checked()'
                                         +'      left join Movement as Movement_Tax on Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId and Movement_Tax.StatusId <> zc_Enum_Status_Erased()'
                                         +'      left join MovementBoolean AS MovementBoolean_Medoc on MovementBoolean_Medoc.MovementId = MovementLinkMovement_Tax.MovementChildId AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()'
                                         +' where Movement.Id='+FieldByName('Id_Postgres').AsString);

                          if(toSqlQuery.FieldByName('isMedoc').AsInteger = zc_rvNo)
                          then begin
                                // удаляем
                                toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                                if not myExecToStoredProc_two then ;//exit;
                          end;
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
             //!!! if (cbBill_List.Checked)and(FieldByName('Id_Postgres').AsInteger<>0)
             //!!! then
             //!!!     fExecSqToQuery ('select gpMovementItem_Tax_SetErased (MovementItem.Id, zfCalc_UserAdmin()) from MovementItem where MovementId = '+FieldByName('Id_Postgres').AsString);
             //!!!!!!!!!!!!!!!!!!
             //

                           fOpenSqToQuery (' select case when MovementBoolean_Medoc.ValueData = TRUE or MovementBoolean.ValueData = TRUE'
                                         +'              then '+IntToStr(zc_rvYes)+' else '+IntToStr(zc_rvNo)
                                         +'         end as isMedoc'
                                         +' from Movement'
                                         +'      left join MovementLinkMovement as MovementLinkMovement_Tax on MovementLinkMovement_Tax.MovementChildId = Movement.Id and MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()'
                                         +'      left join MovementBoolean on MovementBoolean.MovementId = MovementLinkMovement_Tax.MovementId AND MovementBoolean.DescId = zc_MovementBoolean_Checked()'
                                         +'      left join MovementBoolean AS MovementBoolean_Medoc on MovementBoolean_Medoc.MovementId = Movement.Id AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()'
                                         +' where Movement.Id='+IntToStr(FieldByName('Id_Postgres').AsInteger));

                          if(toSqlQuery.FieldByName('isMedoc').AsInteger = zc_rvNo) or (FieldByName('Id_Postgres').AsInteger=0)
                          then begin

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
             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('inPartnerId').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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

                          end;
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
        //Add('                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('inPartnerId').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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
        //Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                                     and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
             //находим договор БН
             ContractId_pg:=fFind_ContractId_pg(FieldByName('inPartnerId').AsInteger,FieldByName('CodeIM').AsInteger,30101,zc_Enum_PaidKind_FirstForm,FieldByName('ContractNumber').AsString);
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
        //Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                                     and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
        //Add('     left outer join dba.KindPackage_i as KindPackage on KindPackage.Id = GoodsProperty_Detail_byServer.KindPackageId');
        Add('                                                     and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                                     and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
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
    addSklad:String;
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
//Add('where Id_PG=479115');
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
             if cbOnlyUpdateInt.Checked  then addSklad:= ' and MLO.ObjectId=8459 ' else addSklad:= ' and 1=0 ';// Склад Реализации

             fOpenSqToQuery (' select Movement.OperDate'
                           +'       , Movement.StatusId, zc_Enum_Status_Complete() as zc_Enum_Status_Complete'
                           +'       , case when (Movement.DescId = zc_Movement_Sale() and MD.ValueData >= ' + FormatToDateServer_notNULL(StrToDate('01.04.2014'))
                           +addSklad // Склад Реализации
                           +'             )or MovementLinkMovement.MovementChildId is not null'
                           +'              then '+IntToStr(zc_rvNo)+' else '+IntToStr(zc_rvYes)
                           +'         end as isDelete'
                           +'       , case when MovementBoolean_Medoc.ValueData = TRUE or MovementBoolean.ValueData = TRUE'
                           +'              then '+IntToStr(zc_rvYes)+' else '+IntToStr(zc_rvNo)
                           +'         end as isMedoc'
                           +'       , case when Movement.DescId = zc_Movement_SendOnPrice() then '+IntToStr(zc_Enum_PaidKind_FirstForm)+' else MLO_PaidKind.ObjectId end AS PaidKindId'
                           +' from Movement'
                           +'      left join MovementLinkObject as MLO_PaidKind on MLO_PaidKind.MovementId = Movement.Id and MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()'
                           +'      left join MovementLinkObject as MLO on MLO.MovementId = Movement.Id and MLO.DescId = zc_MovementLinkObject_From()'
                           +'      left join MovementDate AS MD on MD.MovementId = Movement.Id and MD.DescId = zc_MovementDate_OperDatePartner()'
                           +'      left join MovementLinkMovement on MovementLinkMovement.MovementId=Movement.Id and MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Sale(), zc_MovementLinkMovement_MasterEDI())'
                           +'      left join MovementLinkMovement as MovementLinkMovement_Tax on MovementLinkMovement_Tax.MovementId=Movement.Id and MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()'
                           +'      left join MovementBoolean on MovementBoolean.MovementId = Movement.Id AND MovementBoolean.DescId = zc_MovementBoolean_Checked()'
                           +'      left join Movement as Movement_Tax on Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId and Movement_Tax.StatusId <> zc_Enum_Status_Erased()'
                           +'      left join MovementBoolean AS MovementBoolean_Medoc on MovementBoolean_Medoc.MovementId = MovementLinkMovement_Tax.MovementChildId AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()'
                           +' where Movement.Id='+FieldByName('Id_Postgres').AsString);

// if FieldByName('Id_Postgres').AsString = '259257' then showMessage('');
             if (((cbSaleInt.Checked)and(toSqlQuery.FieldByName('PaidKindId').AsInteger = zc_Enum_PaidKind_FirstForm))
               or ((cbSaleIntNal.Checked)and(toSqlQuery.FieldByName('PaidKindId').AsInteger = zc_Enum_PaidKind_SecondForm))
                )
              and(toSqlQuery.FieldByName('OperDate').AsDateTime >= StrToDate(StartDateEdit.Text))
              and(toSqlQuery.FieldByName('OperDate').AsDateTime <= StrToDate(EndDateEdit.Text))
              and(toSqlQuery.FieldByName('isMedoc').AsInteger = zc_rvNo)
             then begin
                  if toSqlQuery.FieldByName('isDelete').AsInteger = zc_rvNo
                  then begin
                            if toSqlQuery.FieldByName('StatusId').AsInteger = toSqlQuery.FieldByName('zc_Enum_Status_Complete').AsInteger
                            then Id_PG:=FieldByName('Id_Postgres').AsInteger// begin ShowMessage('Ошибка.Документ проведен. № '+FieldByName('Id_Postgres').AsString);exit;end;
                            else Id_PG:=-1*FieldByName('Id_Postgres').AsInteger;// ???почему был 0???
                            //
                            if Id_PG>0
                            then
                                //!!!UnComplete
                                fExecSqToQuery (' select * from lpUnComplete_Movement('+IntToStr(FieldByName('Id_Postgres').AsInteger)+',5)');
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
                            if Id_PG>0
                            then begin
                                //!!!Complete
                                toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                                if myExecToStoredProc_two
                                then ;
                            end;
                            //
                            if cbClearDelete.Checked
                            then fExecSqFromQuery('delete dba._pgBill_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString)
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
    addSklad:String;
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
             if cbOnlyUpdateInt.Checked then addSklad:= ' and MLO.ObjectId=8459 ' else addSklad:= ' and 1=0 ';// Склад Реализации

             fOpenSqToQuery (' select Movement.Id as MovementId'
                           +'       , Movement.OperDate'
                           +'       , Movement.StatusId, zc_Enum_Status_Complete() as zc_Enum_Status_Complete'
                           +'       , case when (Movement.DescId = zc_Movement_Sale() and MD.ValueData >= ' + FormatToDateServer_notNULL(StrToDate('01.04.2014'))
                           +addSklad // Склад Реализации
                           +'             )or MovementLinkMovement.MovementChildId is not null'
                           +'              or MovementBoolean_Medoc.ValueData = TRUE'
                           +'              or MovementBoolean.ValueData = TRUE'
                           +'              then '+IntToStr(zc_rvNo)+' else '+IntToStr(zc_rvYes)
                           +'         end as isDelete'
                           +' from MovementItem'
                           +'      left join Movement on Movement.Id = MovementItem.MovementId'
                           +'      left join MovementLinkObject as MLO on MLO.MovementId = Movement.Id and MLO.DescId = zc_MovementLinkObject_From()'
                           +'      left join MovementDate AS MD on MD.MovementId = Movement.Id and MD.DescId = zc_MovementDate_OperDatePartner()'
                           +'      left join MovementLinkMovement on MovementLinkMovement.MovementId=MovementItem.MovementId and MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Sale(), zc_MovementLinkMovement_MasterEDI())'
                           +'      left join MovementLinkMovement as MovementLinkMovement_Tax on MovementLinkMovement_Tax.MovementId=Movement.Id and MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()'
                           +'      left join MovementBoolean on MovementBoolean.MovementId = Movement.Id AND MovementBoolean.DescId = zc_MovementBoolean_Checked()'
                           +'      left join Movement as Movement_Tax on Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId and Movement_Tax.StatusId <> zc_Enum_Status_Erased()'
                           +'      left join MovementBoolean AS MovementBoolean_Medoc on MovementBoolean_Medoc.MovementId = MovementLinkMovement_Tax.MovementChildId AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()'
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
                            else Id_PG:=-1*toSqlQuery.FieldByName('MovementId').AsInteger;
                            //
                            if Id_PG>0
                            then
                                //!!!UnComplete
                                fExecSqToQuery (' select * from lpUnComplete_Movement('+IntToStr(movId_PG)+',5)');
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
                            if Id_PG>0
                            then begin
                                //!!!Complete
                                toStoredProc_two.Params.ParamByName('inMovementId').Value:=movId_PG;
                                if myExecToStoredProc_two
                                then ;
                            end;
                            //
                            if cbClearDelete.Checked
                            then fExecSqFromQuery('delete dba._pgBillItems_delete where Id = '+FieldByName('ObjectId').AsString + ' and Id_PG='+FieldByName('Id_Postgres').AsString);
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
procedure TMainForm.pLoadDocument_LossGuide;
var InfoMoneyId_pg,ProfitLossDirectionId_pg:Integer;
begin
     if (not cbLossGuide.Checked)or(not cbLossGuide.Enabled) then exit;
     //
     myEnabledCB(cbLossGuide);

     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select UnitTo.Id as ObjectId');
        Add('     , UnitTo.UnitCode as ObjectCode');
        Add('     , UnitTo.UnitName as ObjectName');
        Add('     , cast (_pgArticleLoss.PL_Code as integer) as PL_Code');
        Add('     , UnitTo.LossId_pg as Id_Postgres');
        Add('from dba.Bill');
        Add('     left join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgArticleLoss on _pgArticleLoss.UnitId = Bill.ToId');
        Add('                                       and _pgArticleLoss.UnitId <> 0');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkOut()'
           +'  and (Bill.BillNumber<>0 or Bill.FromId <> Bill.ToId)'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           +'  and Bill.FromId <> Bill.ToId'
           +'  and isnull (UnitTo.CarId_pg, 0) = 0'
           +'  and isnull (UnitTo.PersonalId_Postgres, 0) = 0'
           +'  and isnull (UnitTo.pgUnitId, 0) = 0'
           +'  and Bill.ToId > 0');
        Add('group by UnitTo.Id');
        Add('       , UnitTo.UnitCode');
        Add('       , UnitTo.UnitName');
        Add('       , _pgArticleLoss.PL_Code');
        Add('       , UnitTo.LossId_pg');
        Open;
        cbLossGuide.Caption:='5.1. ('+IntToStr(RecordCount)+') !!!Справочник списания!!!';
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_ArticleLoss';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inProfitLossDirectionId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // Статьи назначения не должна измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ChildObjectId AS RetV from ObjectLink where ObjectId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_ObjectLink_ArticleLoss_InfoMoney()');
                  InfoMoneyId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
                  //
                  fOpenSqToQuery ('select ChildObjectId AS RetV from ObjectLink where ObjectId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()');
                  ProfitLossDirectionId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
             end
             else begin InfoMoneyId_pg:=0;ProfitLossDirectionId_pg:=0;end;
             // определяется ProfitLossDirection
             if (FieldByName('PL_Code').AsInteger<>0)and(ProfitLossDirectionId_pg<>0) then
             begin
                  fOpenSqToQuery ('select Id AS RetV from Object where ObjectCode='+FieldByName('PL_Code').AsString + ' and DescId = zc_Object_ProfitLossDirection()');
                  ProfitLossDirectionId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
             end;

             // Save
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inInfoMoneyId').Value:=InfoMoneyId_pg;
             toStoredProc.Params.ParamByName('inProfitLossDirectionId').Value:=ProfitLossDirectionId_pg;
             if not myExecToStoredProc then ;

             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set LossId_pg=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbLossGuide);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGoodsListSale;
var mySql:String;
begin
     if (not cbGoodsListSale.Checked)or(not cbGoodsListSale.Enabled) then exit;
     //
     //      'select * from gpInsertUpdate_Object_GoodsListSale_byReport(inPeriod_1:= 12, inPeriod_2:= 3, inPeriod_3:= 6, inInfoMoneyId_1:= 8963, inInfoMoneyDestinationId_1:= 0, inInfoMoneyId_2:= 0, inInfoMoneyDestinationId_2:= 8879, inSession:= ' + chr(39) + '5' + chr(39) + ')';
     mySql:= 'select * from gpInsertUpdate_Object_GoodsListSale_byReport(             12,              3,              6,                   8963,                              0,                   0,                              8879,             ' + chr(39) + '5' + chr(39) + ')';
     try
     fOpenSqToQuery (mySql);
     except ShowMessage('Err - ' + mySql);
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadFillSoldTable;
begin
     if (not cbFillSoldTable.Checked)or(not cbFillSoldTable.Enabled) then exit;
     //
     fOpenSqToQuery ('select * from FillSoldTable('+FormatToVarCharServer_isSpace(StartDateEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateEdit.Text)+',zfCalc_UserAdmin())')
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_List(isBefoHistoryCost,isPartion,isDiff:Boolean);
  function myAdd :String;
  begin
       result:='';
       if not toSqlQuery.EOF then
       with toSqlQuery do
       result:=' select ' + FieldByName('MovementId').AsString
              +'       ,' + FormatToDateServer_notNULL(FieldByName('OperDate').AsDateTime)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('InvNumber').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('Code').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(myReplaceStr(FieldByName('ItemName').AsString,chr(39),'`'));
       Gauge.Progress:=Gauge.Progress+1;
  end;
var ExecStr1,ExecStr2,ExecStr3,ExecStr4,addStr:String;
    i,SaveRecord:Integer;
    MSec_complete:Integer;
    isSale_str:String;
begin
     if (isPartion = FALSE) and (isDiff = FALSE) then if (not cbComplete_List.Checked)or(not cbComplete_List.Enabled) then exit;
     //
     myEnabledCB(cbComplete_List);
     //
     if cbOnlySale.Checked = true then isSale_str:=',TRUE' else isSale_str:=',FALSE';
     //
     // !!!заливка в сибасе!!!

     // Get Data
     if (ParamStr(2)='autoReComplete') and (isBefoHistoryCost = TRUE)
     then fOpenSqToQuery ('select * from gpComplete_SelectAllBranch_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',TRUE)')
     else
     if (ParamStr(2)='autoReComplete') and (isBefoHistoryCost = FALSE)
     then fOpenSqToQuery ('select * from gpComplete_SelectAllBranch_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',FALSE)')
     else

     if (isDiff = TRUE)
     then fOpenSqToQuery ('select * from gpComplete_SelectAll_Sybase_diff('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+',NULL)')
     else
     if (isPartion = TRUE)
     then fOpenSqToQuery ('select * from gpComplete_SelectAll_Sybase_CEH('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+',TRUE)')
     else
         if (isBefoHistoryCost = TRUE)and(cbInsertHistoryCost_andReComplete.Checked)
         then fOpenSqToQuery ('select * from gpComplete_SelectHistoryCost_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+',TRUE)')
         else if (isBefoHistoryCost = FALSE)and(cbInsertHistoryCost_andReComplete.Checked)
              then fOpenSqToQuery ('select * from gpComplete_SelectHistoryCost_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',FALSE)')
              else
                  if isBefoHistoryCost = TRUE
                  then fOpenSqToQuery ('select * from gpComplete_SelectAll_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',TRUE)')
                  else fOpenSqToQuery ('select * from gpComplete_SelectAll_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',FALSE)');

     // delete Data on Sybase
     fromADOConnection.Connected:=false;
     fExecSqFromQuery('delete dba._pgMovementReComlete');
     fExecSqFromQuery('insert into dba._pgMovementReComlete select * from _pgMovementReComlete_add');

     SaveRecord:=toSqlQuery.RecordCount;
     Gauge.Progress:=0;
     Gauge.MaxValue:=SaveRecord;
     cbComplete_List.Caption:='('+IntToStr(SaveRecord)+') !!!Cписок накладных!!!';

     with toSqlQuery do
        while not EOF do
        begin
             // insert into Sybase
             ExecStr1:='insert into dba._pgMovementReComlete(MovementId,OperDate,InvNumber,Code,ItemName)'
                     +myAdd;
             ExecStr2:='';
             ExecStr3:='';
             ExecStr4:='';
             for i:=1 to 100 do
             begin
                  Next;
                  addStr:=myAdd;
                  if addStr <> '' then
                  if LengTh(ExecStr1) < 3500
                  then ExecStr1:=ExecStr1 + ' union all ' + addStr
                  else if LengTh(ExecStr2) < 3500
                       then ExecStr2:=ExecStr2 + ' union all ' + addStr
                        else if LengTh(ExecStr3) < 3500
                             then ExecStr3:=ExecStr3 + ' union all ' + addStr
                             else ExecStr4:=ExecStr4 + ' union all ' + addStr;
                  Application.ProcessMessages;
                  Application.ProcessMessages;
                  Application.ProcessMessages;
             end;
             fromADOConnection.Connected:=false;
             fExecSqFromQuery(ExecStr1+ExecStr2+ExecStr3+ExecStr4);
             Next;
        end;
     //
     fromADOConnection.Connected:=false;
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select case when Code = ' + FormatToVarCharServer_notNULL('zc_Movement_Inventory')
           +'                 then 1'
           +'            else 0'
           +'       end as Order_master'
           +'    , _pgMovementReComlete.*');
        Add('from dba._pgMovementReComlete');
        Add('order by Order_master,OperDate,MovementId,InvNumber');
        Open;

        cbComplete_List.Caption:='('+IntToStr(SaveRecord)+')('+IntToStr(RecordCount)+') !!!Cписок накладных!!!';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        {toStoredProc.StoredProcName:='';//gpUnComplete_Movement
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);}
        //
        toStoredProc_two.StoredProcName:='gpComplete_All_Sybase';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsNoHistoryCost',ftBoolean,ptInput, true);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             {if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;}
             if cbComplete.Checked then
             begin
                  begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsNoHistoryCost').Value:=cbLastComplete.Checked;

                       if not myExecToStoredProc_two then ;//exit;
                  end;
             end;
             //
             try MSec_complete:=StrToInt(SessionIdEdit.Text);if MSec_complete<=0 then MSec_complete:=100;except MSec_complete:=100;end;
             if cb100MSec.Checked then begin SessionIdEdit.Text:=IntToStr(MSec_complete); MyDelay(MSec_complete);end;
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
     myDisabledCB(cbComplete_List);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Defroster;
begin
     if (not cbDefroster.Checked)or(not cbDefroster.Enabled) then exit;
     //
     myEnabledCB(cbDefroster);
     //
        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Defroster';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);

             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=8440;//Дефростер
             if not myExecToStoredProc_two then ;//exit;
             //
     //
     myDisabledCB(cbDefroster);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Pack;
var calcStartDate:TDateTime;
    MSec_complete:Integer;
begin
     if (not cbPack.Checked)or(not cbPack.Enabled) then exit;
     //
     myEnabledCB(cbPack);
     //
     //
     DBGrid.DataSource.DataSet:=fromQueryDate_recalc;
     //
     fromADOConnection.Connected:=false;
     with fromQueryDate_recalc,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateCompleteEdit.Text);
        while calcStartDate <= StrToDate(EndDateCompleteEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateCompleteEdit.Text)
             then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate')
             else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate');
             //
             calcStartDate:=calcStartDate+1;
        end;
        Add('order by StartDate, EndDate');
        Open;

        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;

        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Pack';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);

        while not EOF do
        begin
             //!!!
             if fStop then begin DBGrid.DataSource.DataSet:=fromQuery;exit;end;
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=8451;//Цех Упаковки
             if not myExecToStoredProc_two then ;//exit;
             //
             if cb100MSec.Checked
             then begin
                  try MSec_complete:=StrToInt(SessionIdEdit.Text);if MSec_complete<=0 then MSec_complete:=100;except MSec_complete:=100;end;
                  if cb100MSec.Checked then begin SessionIdEdit.Text:=IntToStr(MSec_complete); MyDelay(MSec_complete);end;
             end
             else MyDelay(15 * 1000);
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
     myDisabledCB(cbPack);
     //
     DBGrid.DataSource.DataSet:=fromQuery;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Kopchenie;
var calcStartDate:TDateTime;
begin
     if (not cbKopchenie.Checked)or(not cbKopchenie.Enabled) then exit;
     //
     myEnabledCB(cbKopchenie);
     //
     //
     DBGrid.DataSource.DataSet:=fromQueryDate_recalc;
     //
     fromADOConnection.Connected:=false;
     with fromQueryDate_recalc,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateCompleteEdit.Text);
        while calcStartDate <= StrToDate(EndDateCompleteEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateCompleteEdit.Text)
             then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate')
             else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate');
             //
             calcStartDate:=calcStartDate+1;
        end;
        Add('order by StartDate, EndDate');
        Open;

        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;

        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Kopchenie';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);

        while not EOF do
        begin
             //!!!
             if fStop then begin DBGrid.DataSource.DataSet:=fromQuery;exit;end;
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=8450;//ЦЕХ копчения
             if not myExecToStoredProc_two then ;//exit;
             //
             MyDelay(5 * 1000);
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
     myDisabledCB(cbKopchenie);
     //
     DBGrid.DataSource.DataSet:=fromQuery;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Diff;
begin
     if (not cbHistoryCost_diff.Checked)or(not cbHistoryCost_diff.Enabled) then exit;
     //
     myEnabledCB(cbHistoryCost_diff);
     //
        toStoredProc_two.StoredProcName:='gpUpdate_HistoryCost_diff';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsUpdate',ftBoolean,ptInput, TRUE);

        Gauge.Progress:=0;
        Gauge.MaxValue:=1;

             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inIsUpdate').Value:= TRUE;
             if not cbOnlyOpen.Checked then if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:=1;
        MyDelay(3 * 1000);
     //
     pCompleteDocument_List(false, FALSE, TRUE);
     //
     myDisabledCB(cbHistoryCost_diff);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn_Auto;
  function myAdd :String;
  begin
       result:='';
       if not toSqlQuery.EOF then
       with toSqlQuery do
       result:=' select ' + FieldByName('MovementId').AsString
              +'       ,' + FormatToDateServer_notNULL(FieldByName('OperDate').AsDateTime)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('InvNumber').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('Code').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(myReplaceStr(FieldByName('ItemName').AsString,chr(39),'`'));
       Gauge.Progress:=Gauge.Progress+1;
  end;
var ExecStr1,ExecStr2,ExecStr3,ExecStr4,addStr:String;
    i,SaveRecord:Integer;
    MSec_complete:Integer;
    isSale_str:String;
begin
     if (not cbReturnIn_Auto.Checked)or(not cbReturnIn_Auto.Enabled) then exit;
     //
     myEnabledCB(cbReturnIn_Auto);
     //
     // !!!заливка в сибасе!!!
     fOpenSqToQuery ('select * from gpComplete_SelectAll_Sybase_ReturnIn_Auto('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+')');

     // delete Data on Sybase
     fromADOConnection.Connected:=false;
     fExecSqFromQuery('delete dba._pgMovementReComlete');
     fExecSqFromQuery('insert into dba._pgMovementReComlete select * from _pgMovementReComlete_add');

     SaveRecord:=toSqlQuery.RecordCount;
     Gauge.Progress:=0;
     Gauge.MaxValue:=SaveRecord;
     cbReturnIn_Auto.Caption:='('+IntToStr(SaveRecord)+') !!!Cписок накладных!!!';

     with toSqlQuery do
        while not EOF do
        begin
             // insert into Sybase
             ExecStr1:='insert into dba._pgMovementReComlete(MovementId,OperDate,InvNumber,Code,ItemName)'
                     +myAdd;
             ExecStr2:='';
             ExecStr3:='';
             ExecStr4:='';
             for i:=1 to 100 do
             begin
                  Next;
                  addStr:=myAdd;
                  if addStr <> '' then
                  if LengTh(ExecStr1) < 3500
                  then ExecStr1:=ExecStr1 + ' union all ' + addStr
                  else if LengTh(ExecStr2) < 3500
                       then ExecStr2:=ExecStr2 + ' union all ' + addStr
                        else if LengTh(ExecStr3) < 3500
                             then ExecStr3:=ExecStr3 + ' union all ' + addStr
                             else ExecStr4:=ExecStr4 + ' union all ' + addStr;
                  Application.ProcessMessages;
                  Application.ProcessMessages;
                  Application.ProcessMessages;
             end;
             fromADOConnection.Connected:=false;
             fExecSqFromQuery(ExecStr1+ExecStr2+ExecStr3+ExecStr4);
             Next;
        end;
     //
     fromADOConnection.Connected:=false;
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select _pgMovementReComlete.*');
        Add('from dba._pgMovementReComlete');
        Add('order by OperDate,MovementId,InvNumber');
        Open;

        cbReturnIn_Auto.Caption:='('+IntToStr(RecordCount)+') Привязка Возвраты';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ReturnIn_isError';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             if not myExecToStoredProc_two then ;//exit;
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
     myDisabledCB(cbReturnIn_Auto);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Partion;
begin
     if (not cbPartion.Checked)or(not cbPartion.Enabled) then exit;
     //
     myEnabledCB(cbPartion);
     //
        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Partion';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inToId',ftInteger,ptInput, 0);

        Gauge.Progress:=0;
        Gauge.MaxValue:=3;

             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=8448;//ЦЕХ деликатесов
             toStoredProc_two.Params.ParamByName('inToId').Value:=8458;//Склад База ГП
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(3 * 1000);
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=8447;//ЦЕХ колбасный
             toStoredProc_two.Params.ParamByName('inToId').Value:=8458;//Склад База ГП
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(1 * 1000);
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=951601; //ЦЕХ упаковки мясо
             toStoredProc_two.Params.ParamByName('inToId').Value:=8439; //Участок мясного сырья
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(1 * 1000);
     //
     pCompleteDocument_List(false,true, FALSE);
     //
     myDisabledCB(cbPartion);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Loss;
begin
     if (not cbCompleteLoss.Checked)or(not cbCompleteLoss.Enabled) then exit;
     //
     myEnabledCB(cbCompleteLoss);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , cast (Bill.BillNumber as TVarCharMedium)');
        Add('     , UnitFrom.UnitName as FromUnitName, UnitTo.UnitName as ToUnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToId');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkOut()'
           +'  and Bill.Id_Postgres>0'
           //+'  and (Bill.BillNumber<>0 or Bill.FromId <> Bill.ToId)'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()');
        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteLoss.Caption:='5.('+IntToStr(RecordCount)+') Списание';
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
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Loss';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
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
                  {fOpenSqToQuery (' select COALESCE (MLO_From.ObjectId, 0) AS FromId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_From'
                                 +'                                   ON MLO_From.MovementId = Movement.Id'
                                 +'                                  AND MLO_From.DescId = zc_MovementLinkObject_From()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_OrderExternal()'
                                 );
                  //
                  if toSqlQuery.FieldByName('FromId').AsInteger>0 then}
                  begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
                       if cbCompleteLossNotError.Checked
                       then try
                               myExecToStoredProc_two;
                            except
                            end
                       else if not myExecToStoredProc_two then ;//exit;
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
     myDisabledCB(cbCompleteLoss);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_Loss:Integer;
var ArticleLossId_Defroster:Integer;
    ToId_pg,ArticleLossId_pg:Integer;
begin
     if (not cbLoss.Checked)or(not cbLoss.Enabled) then exit;
     //
     myEnabledCB(cbLoss);
     //
     fOpenSqToQuery (' select Id as RetV from Object where ObjectCode=101 and DescId=zc_Object_ArticleLoss()');
     ArticleLossId_Defroster:=toSqlQuery.FieldByName('RetV').AsInteger;
     if ArticleLossId_Defroster=0
     then begin
               ShowMessage('ArticleLossId_Defroster=0');
               fStop:=true;
               exit;
     end;

     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , cast (Bill.BillNumber as TVarCharMedium)'
           +'    || case when FromId_Postgres is null or (ToId_Postgres is null and ArticleLossId_pg is null and Bill.ToId <> 0 and isnull(Bill.FromId,0) <> isnull(Bill.ToId,0)) '
           +'                 then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                   || case when FromId_Postgres is null then '+FormatToVarCharServer_notNULL('-от кого:')+' || UnitFrom.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'                   || case when ToId_Postgres is null and ArticleLossId_pg is null and Bill.ToId <> 0 and isnull(Bill.FromId,0) <> isnull(Bill.ToId,0) then '+FormatToVarCharServer_notNULL('-кому:')+' || UnitTo.UnitName else '+FormatToVarCharServer_notNULL('')+' end'
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as InvNumber_all');
        Add('     , isnull(_pgPersonalFrom.Id_Postgres,pgUnitFrom.Id_Postgres) as FromId_Postgres');
        Add('     , case when isnull(Bill.FromId,0) = isnull(Bill.ToId,0)'
           +'                 then 0'
           +'            when pgUnitTo.Id_Postgres > 0'
           +'                 then pgUnitTo.Id_Postgres'
           +'            when _pgCar.CarId_pg > 0'
           +'                 then _pgCar.CarId_pg'
           +'            when _pgPersonal.Id_Postgres > 0'
           +'                 then _pgPersonal.Id_Postgres'
           +'       end as ToId_Postgres');
        Add('     , case when Bill.KindAuto = zc_KindAuto01_Defroster()'
           +'                 then ' + IntToStr(ArticleLossId_Defroster)
           +'            else UnitTo.LossId_pg'
           +'       end as ArticleLossId_pg');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        //Add('     inner join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as _pgPersonalFrom on _pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal on _pgPersonal.Id = UnitTo.PersonalId_Postgres');
        Add('     left outer join dba._pgCar on _pgCar.Id = UnitTo.CarId_pg');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkOut()'
           //+'  and (Bill.BillNumber<>0 or Bill.FromId <> Bill.ToId)'
           +'  and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           //+'  and isnull(Bill.KindAuto,0) = 0'
           );
        Open;
        Result:=RecordCount;
        cbLoss.Caption:='5.2. ('+IntToStr(RecordCount)+') Списание';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Loss';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inArticleLossId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;

             // ToId_Postgres не должна измениться
             if (FieldByName('ToId_Postgres').AsInteger=0) and (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery ('select ObjectId AS RetV from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_To()');
                  ToId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
             end
             else ToId_pg:=FieldByName('ToId_Postgres').AsInteger;

             // ArticleLossId_pg не должна измениться
             if (FieldByName('ArticleLossId_pg').AsInteger=0) and (FieldByName('Id_Postgres').AsInteger<>0)then
             begin
                  fOpenSqToQuery ('select ObjectId AS RetV from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_ArticleLoss()');
                  ArticleLossId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
             end
             else ArticleLossId_pg:=FieldByName('ArticleLossId_pg').AsInteger;

             // Save
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber_all').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=ToId_pg;
             toStoredProc.Params.ParamByName('inArticleLossId').Value:=ArticleLossId_pg;

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
     myDisabledCB(cbLoss);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Loss(SaveCount:Integer);
var PartionGoodsId_pg:Integer;
begin
     if (not cbLoss.Checked)or(not cbLoss.Enabled) then exit;
     //
     myEnabledCB(cbLoss);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');

        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , -1 * BillItems.OperCount as Amount');
        Add('     , BillItems.OperCount_Upakovka as inCount');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , BillItems.PartionStr_MB as PartionGoods');
        Add('     , isnull(BillItems.PartionDate,zc_DateStart()) AS PartionGoodsDate');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , 0 as AssetId_Postgres');
        Add('     , case when GoodsProperty.InfoMoneyCode between 20200 and 20400 then zc_rvYes()'
           +'            when GoodsProperty.InfoMoneyCode between 70100 and 70200 then zc_rvYes()'
           +'            else zc_rvNo()'
           +'       end as isMNMA');
        Add('     , isnull(_pgPersonalFrom.Id_Postgres,0) as MemberId_Postgres');

        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from (select Bill.Id as BillId'
           +'      from dba.Bill'
           //+'           inner join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId'
           +'      where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'        and Bill.BillKind = zc_bkOut()'
           +'        and Bill.Id_Postgres>0'
           //+'        and (Bill.BillNumber<>0 or Bill.FromId <> Bill.ToId)'
           +'        and isnull(Bill.isRemains,zc_rvNo())=zc_rvNo()'
           );
        Add('      group by Bill.Id'
           +'      ) as Bill_find');

        Add('          left outer join dba.Bill on Bill.Id = Bill_find.BillId');

        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba._pgPersonal as _pgPersonalFrom on _pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres');

        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where BillItems.Id > 0');

        Add('order by 2,3,1');
        Open;

        cbLoss.Caption:='5.2.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') Списание';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Loss';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAssetId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsId',ftInteger,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             // для MNMA
             if (FieldByName('isMNMA').AsInteger=zc_rvYes)and(FieldByName('MemberId_Postgres').AsInteger>0) then
             begin
                  fOpenSqToQuery (' select COALESCE(CLO_PartionGoods.ObjectId, 0) AS RetV'
                                 +' from Container'
                                 +'      join ContainerLinkObject AS CLO_Member on CLO_Member.ContainerId=Container.Id'
                                 + '                                           and CLO_Member.DescId = zc_ContainerLinkObject_Member()'
                                 + '                                           and CLO_Member.ObjectId = ' + FieldByName('MemberId_Postgres').AsString
                                 +'      join ContainerLinkObject AS CLO_PartionGoods on CLO_PartionGoods.ContainerId=Container.Id'
                                 + '                                                 and CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()'
                                 +' where Container.ObjectId='+FieldByName('GoodsId_Postgres').AsString
                                 + '  and Container.DescId = zc_Container_Count()'
                                 + '  and Container.Amount>='+FloatToStr(FieldByName('Amount').AsFloat));
                  PartionGoodsId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
             end
             else PartionGoodsId_pg:=0;

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inCount').Value:=FieldByName('inCount').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             if FieldByName('PartionGoodsDate').AsDateTime <= StrToDate('01.01.1900')
             then toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=StrToDate('01.01.1900')
             else toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=FieldByName('PartionGoodsDate').AsDateTime;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('PartionGoods').AsString;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAssetId').Value:=FieldByName('AssetId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPartionGoodsId').Value:=PartionGoodsId_pg;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbLoss);
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
                                 +'   AND Movement.DescId = zc_Movement_Inventory()'
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
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
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
    Id_Postgres:Integer;
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
        if cbOnlyOpen.Checked then begin pLoadDocumentItem_Inventory(Gauge.MaxValue);exit;end;
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
             //находим
             fOpenSqToQuery (' select Movement.Id as MovementId'
                            +' from Movement'
                            +'      INNER JOIN MovementLinkObject AS MovementLinkObject_From'
                            +'                                    ON MovementLinkObject_From.MovementId = Movement.Id'
                            +'                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()'
                            +'                                   AND MovementLinkObject_From.ObjectId >0'
                            +'                                   AND MovementLinkObject_From.ObjectId = '+IntToStr(FieldByName('FromId_Postgres').AsInteger)
                            +' where Movement.OperDate='+FormatToDateServer_notNULL(FieldByName('OperDate').AsDateTime)
                            + '  and Movement.DescId = zc_Movement_Inventory()'
                            + '  and Movement.StatusId = zc_Enum_Status_UnComplete()');
             Id_Postgres:=toSqlQuery.FieldByName('MovementId').AsInteger;
             //
             if Id_Postgres=0
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
                       toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
                       toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;

                       toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
                       toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;

                       if not myExecToStoredProc then ;//exit;
                       //
                       Id_Postgres:=toStoredProc.Params.ParamByName('ioId').Value;
             end;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then if FieldByName('isCar').AsInteger=zc_rvYes
                  then fExecSqFromQuery('update dba._pgCar set MovementId_pg=zf_ChangeIntToNull('+IntToStr(Id_Postgres)+') where Id = '+FieldByName('ObjectId').AsString)
                  else fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(Id_Postgres)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
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
        Add('select * from dba._pgSelect_Bill_Inventory_Item('+IntToStr(isGlobalLoad)+','+FormatToDateServer_notNULL(fromQuery_two.FieldByName('StartDate').AsDateTime)+','+FormatToDateServer_notNULL(fromQuery_two.FieldByName('EndDate').AsDateTime)+') as tmp');
        if OKPOEdit.Text<>''
        then Add('where GoodsPropertyId='+OKPOEdit.Text);
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
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('UnitId').AsInteger;
             toStoredProc.Params.ParamByName('inStorageId').Value:=FieldByName('StorageId').AsInteger;

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
procedure TMainForm.pCompleteDocument_OrderInternal;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_OrderExternal;
begin
     if (not cbCompleteOrderExternal.Checked)or(not cbCompleteOrderExternal.Enabled) then exit;
     //
     myEnabledCB(cbCompleteOrderExternal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast(Bill.BillNumber as integer)as InvNumber');
        //Add('     , case when pgUnitFrom.Id>0 then zc_rvYes() else zc_rvNo() end as isUnit_Branch');
        Add('     , case when pgUnitFrom.Id_Postgres > 0 or (UnitFrom.LossId_pg > 0 and isnull (_pgPartner.PartnerId_pg, isnull (UnitFrom.Id3_Postgres, 0)) = 0)  then zc_rvYes() else zc_rvNo() end as isUnit_Branch');
        Add('     , Bill.FromID');
        Add('     , Bill.ToID');
        Add('     , Bill.MoneyKindId');
        Add('     , Bill.Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('          left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                          ) as _pgPartner on _pgPartner.UnitId = Bill.FromId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind = zc_bkProductionInZakaz()'
           +'  and Bill.Id_Postgres>0'
           +'  and (isUnitFrom.UnitId is null and isUnitTo.UnitId is not null)'
           );
        Add('order by OperDate,InvNumber,ObjectId');
        Open;

        cbCompleteOrderExternal.Caption:='7.1.('+IntToStr(RecordCount)+')Заявки покупателей';
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
        toStoredProc_two.StoredProcName:='gpComplete_Movement_OrderExternal';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
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
                  fOpenSqToQuery (' select COALESCE (MLO_From.ObjectId, 0) AS FromId'
                                 +'      , COALESCE (MLO_Contract.ObjectId, 0) AS ContractId'
                                 +' from Movement'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_From'
                                 +'                                   ON MLO_From.MovementId = Movement.Id'
                                 +'                                  AND MLO_From.DescId = zc_MovementLinkObject_From()'
                                 +'      LEFT JOIN MovementLinkObject AS MLO_Contract'
                                 +'                                   ON MLO_Contract.MovementId = Movement.Id'
                                 +'                                  AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()'
                                 +' WHERE Movement.Id = '+FieldByName('Id_Postgres').AsString
                                 +'   AND Movement.DescId = zc_Movement_OrderExternal()'
                                 );
                  //
                  if ((toSqlQuery.FieldByName('FromId').AsInteger>0)and((toSqlQuery.FieldByName('ContractId').AsInteger>0)))
                   or(FieldByName('isUnit_Branch').AsInteger=zc_rvYes)
                  then
                  begin
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
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
     myDisabledCB(cbCompleteOrderExternal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_OrderExternal:Integer;
var ContractId_pg,PriceListId:Integer;
    zc_PriceList_Basis:Integer;
    RouteId_pg,RouteSortingId_pg,PersonalId_pg:Integer;
begin
     Result:=0;
     if (not cbOrderExternal.Checked)or(not cbOrderExternal.Enabled) then exit;
     //
     myEnabledCB(cbOrderExternal);
     //
     fOpenSqToQuery ('select zc_PriceList_Basis() as RetV');
     zc_PriceList_Basis:=toSqlQuery.FieldByName('RetV').AsInteger;
     //
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber || case when (FromId_Postgres is null)'
           +'                                 or (ToId_Postgres is null)'
           +'                                    then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when FromId_Postgres is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' От Кого:')+'|| UnitFrom.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when ToId_Postgres is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' Кому:')+'|| UnitTo.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'       as InvNumber');
        Add('     , trim(Bill.BillNumberClient1) as BillNumberClient1');
        Add('     , Bill.BillDate as OperDate');
        Add('     , case when isnull(Bill.KindRoute,0) = 1 then OperDate + 1 else OperDate end as OperDatePartner');
        Add('     , isnull(Bill.BillDate_two, Bill.BillDate) as OperDateMark');

        Add('     , zc_rvNo() as PriceWithVAT');
        Add('     , 20 as VATPercent');
        Add('     , 0 as ChangePercent');

        Add('     , case when pgUnitFrom.Id_Postgres > 0 or (UnitFrom.LossId_pg > 0 and isnull (_pgPartner.PartnerId_pg, isnull (UnitFrom.Id3_Postgres, 0)) = 0)  then zc_rvYes() else zc_rvNo() end as isBranch');
        Add('     , isnull (pgUnitFrom.Id_Postgres, isnull (_pgPartner.PartnerId_pg, isnull (UnitFrom.Id3_Postgres, UnitFrom.LossId_pg))) as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');

        Add('     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres');
        Add('     , case when Bill.ToId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
           +'                then 30201' // Мясное сырье
           +'                else 30101' // Готовая продукция
           +'       end as CodeIM');

        // Add('     , _pgRoute.RouteId_pg as RouteId_pg');
        // Add('     , Unit_RouteSorting.Id_Postgres_RouteSorting as RouteSortingId_pg');
        // Add('     , null as PersonalId_pg');

        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');

        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = case when Bill.ToId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())'
          +'                                                                  then zc_UnitId_StoreSalePF()'
          +'                                                             else zc_UnitId_StoreSale()'
          +'                                                        end');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId');
        Add('                                                  and Bill.FromId<>Bill.RouteUnitId');
        Add('     left outer join dba.RouteGroup on RouteGroup.Id = Unit_RouteSorting.RouteGroupId');
        Add('     left outer join dba._pgRoute on _pgRoute.Id = RouteGroup.RouteId_pg');
        Add('          left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId'
           +'                          ) as _pgPartner on _pgPartner.UnitId = Bill.FromId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));

        if OKPOEdit.Text <> '' then Add('  and Bill.BillNumber='+OKPOEdit.Text);

        Add('  and Bill.BillKind = zc_bkProductionInZakaz()'
           +'  and (isUnitFrom.UnitId is null and isUnitTo.UnitId is not null)'
// +' and Bill.Id_Postgres=22081'
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbOrderExternal.Caption:='7.1. ('+IntToStr(RecordCount)+')Заявки покуп.';
        //
        if cbShowContract.Checked
        then fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('PaidKindId_Postgres').AsInteger,'myContractNumber is null');
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_OrderExternal_Sybase';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInvNumberPartner',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDatePartner',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDateMark',ftDateTime,ptInput, '');

        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPersonalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('ioPriceListId',ftInteger,ptInputOutput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //
             //Прайс-лист не должен измениться
             if FieldByName('Id_Postgres').AsInteger<>0 then
             begin
                  fOpenSqToQuery ('select ObjectId AS PriceListId from MovementLinkObject where MovementId='+FieldByName('Id_Postgres').AsString + ' and DescId = zc_MovementLinkObject_PriceList()');
                  PriceListId:=toSqlQuery.FieldByName('PriceListId').AsInteger;
             end
             else PriceListId:=zc_PriceList_Basis;
             //
             //находим параметры для маршрута
             fOpenSqToQuery (' select ObjectLink_Partner_Route.ChildObjectId        as RouteId'
                            +'      , ObjectLink_Partner_RouteSorting.ChildObjectId as RouteSortingId'
                            +'      , ObjectLink_Partner_MemberTake.ChildObjectId   as MemberTakeId'
                            +' from Object as Object_Partner'
                            +'      LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake'
                            +'                           ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id'
                            +'                          AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()'
                            +'      LEFT JOIN ObjectLink AS ObjectLink_Partner_Route'
                            +'                           ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id'
                            +'                          AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()'
                            +'      LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting'
                            +'                           ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id'
                            +'                          AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()'
                            +' where Object_Partner.Id = '+IntToStr(FieldByName('FromId_Postgres').AsInteger)
                            );
             RouteId_pg:=toSqlQuery.FieldByName('RouteId').AsInteger;
             RouteSortingId_pg:=toSqlQuery.FieldByName('RouteSortingId').AsInteger;
             PersonalId_pg:=toSqlQuery.FieldByName('MemberTakeId').AsInteger;
             //
             //находим договор по документу продажи
             if (FieldByName('BillNumberClient1').AsString<>'')and(FieldByName('isBranch').AsInteger=zc_rvNo)
             then begin
                       fOpenSqToQuery (' select MovementLinkObject.ObjectId AS RetV'
                                      +' from Movement, MovementDate, MovementString, MovementLinkObject'
                                      +' where MovementDate.ValueData between (cast ('+FormatToDateServer_notNULL(FieldByName('OperDatePartner').AsDateTime) + ' as TDateTime) - INTERVAL '+FormatToVarCharServer_notNULL('1 DAY')+') and (cast (' + FormatToDateServer_notNULL(FieldByName('OperDatePartner').AsDateTime)+ ' as TDateTime) + INTERVAL '+FormatToVarCharServer_notNULL('1 DAY') + ')'
                                      +'   and MovementDate.DescId = zc_MovementDate_OperDatePartner()'
                                      +'   and MovementString.MovementId=MovementDate.MovementId'
                                      +'   and MovementString.DescId = zc_MovementString_InvNumberOrder()'
                                      +'   and trim(MovementString.ValueData) = '+FormatToVarCharServer_notNULL(FieldByName('BillNumberClient1').AsString)
                                      +'   and Movement.Id=MovementDate.MovementId'
                                      +'   and Movement.DescId = zc_Movement_Sale()'
                                      +'   and Movement.StatusId <> zc_Enum_Status_Erased()'
                                      +'   and MovementLinkObject.MovementId=MovementDate.MovementId'
                                      +'   and MovementLinkObject.DescId = zc_MovementLinkObject_Contract()');
                       ContractId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
                  end
             else ContractId_pg:=0;
             //находим договор
             if (ContractId_pg=0)and (FieldByName('isBranch').AsInteger=zc_rvNo)and(FieldByName('FromId_Postgres').AsInteger>0)
             then ContractId_pg:=fFind_ContractId_pg(FieldByName('FromId_Postgres').AsInteger,FieldByName('CodeIM').AsInteger,30101,FieldByName('PaidKindId_Postgres').AsInteger,'myContractNumber is null');
             //
             //сохранение
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             if (ContractId_pg=0)and (FieldByName('isBranch').AsInteger=zc_rvNo)and(FieldByName('FromId_Postgres').AsInteger>0)
             then toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString+'-ошибка договор:???'
             else toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('BillNumberClient1').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDateMark').Value:=FieldByName('OperDateMark').AsDateTime;

             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('ChangePercent').AsFloat;

             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inRouteId').Value:=RouteId_pg;//FieldByName('RouteId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=RouteSortingId_pg;//FieldByName('RouteSortingId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalId').Value:=PersonalId_pg;//FieldByName('PersonalId_pg').AsInteger;
             toStoredProc.Params.ParamByName('ioPriceListId').Value:=PriceListId;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));

             //fExecSqFromQuery('update dba.BillItems set Id_Postgres= null where BillId = '+FieldByName('ObjectId').AsString);
             //fExecSqFromQuery('update dba.Bill set Id_Postgres= null where Id = '+FieldByName('ObjectId').AsString);
             //fExecSqToQuery (' select * from lpSetErased_Movement('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+',5)');

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbOrderExternal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_OrderExternal(SaveCount:Integer);
begin
     if (not cbOrderExternal.Checked)or(not cbOrderExternal.Enabled) then exit;
     myEnabledCB(cbOrderExternal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , isnull(BillItems.ZakazCount1,0) + isnull(BillItems.ZakazCount2,0) as Amount');
        Add('     , BillItems.ZakazChange as AmountSecond');

        Add('     , PriceListItems_byHistory.NewPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');

        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+isnull(KindPackage.KindPackageName,'+FormatToVarCharServer_notNULL('')+')+'+FormatToVarCharServer_notNULL(')')
//           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');

        Add('     left outer join dba.BillItemsZakaz as BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('     LEFT JOIN dba.PriceListItems_byHistory on PriceListItems_byHistory.GoodsPropertyId=BillItems.GoodsPropertyId'
           +'                                           and PriceListItems_byHistory.PriceListID = 2' // ОПТОВЫЕ ЦЕНЫ
           +'                                           and Bill.BillDate between PriceListItems_byHistory.StartDate and PriceListItems_byHistory.EndDate');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind = zc_bkProductionInZakaz()'
           +'  and (isUnitFrom.UnitId is null and isUnitTo.UnitId is not null)'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           );
        if cbOnlyInsertDocument.Checked
        then Add('and isnull(BillItems.Id_Postgres,0)=0');
        Add('order by 2,3,1');
        Open;

        cbOrderExternal.Caption:='7.1.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Заявки покуп.';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_OrderExternal';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountSecond',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
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
             toStoredProc.Params.ParamByName('inAmountSecond').Value:=FieldByName('AmountSecond').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecSqFromQuery('update dba.BillItemsZakaz set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
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
     myDisabledCB(cbOrderExternal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_OrderInternal:Integer;
begin
     Result:=0;
     if (not cbOrderInternal.Checked)or(not cbOrderInternal.Enabled) then exit;
     //
     myEnabledCB(cbOrderInternal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber || case when (FromId_Postgres is null)'
           +'                                 or (ToId_Postgres is null)'
           +'                                    then '+FormatToVarCharServer_notNULL('-ошибка')
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when FromId_Postgres is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' От Кого:')+'|| UnitFrom.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'                       || case when ToId_Postgres is null'
           +'                                    then '+FormatToVarCharServer_notNULL(' Кому:')+'|| UnitTo.UnitName'
           +'                               else '+FormatToVarCharServer_notNULL('')
           +'                           end'
           +'       as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , Bill.BillDate - 55 - 2 as inOperDateStart');
        Add('     , Bill.BillDate - 2 as inOperDateEnd');

        Add('     , pgUnitFrom.Id_Postgres as FromId_Postgres');
        Add('     , pgUnitTo.Id_Postgres as ToId_Postgres');

        Add('     , Bill.Id_Postgres as Id_Postgres');

        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');
        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('  and Bill.BillKind = zc_bkProductionInZakaz()'
           +'  and (isUnitFrom.UnitId is not null and isUnitTo.UnitId is not null)'
// +' and Bill.Id_Postgres=22081'
           );
        Add('order by OperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbOrderInternal.Caption:='7.2. ('+IntToStr(RecordCount)+')Заявки пр-во';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_OrderInternal';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDateStart',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDateEnd',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //
             //сохранение
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDateStart').Value:=FieldByName('inOperDateStart').AsDateTime;
             toStoredProc.Params.ParamByName('inOperDateEnd').Value:=FieldByName('inOperDateEnd').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));

             //fExecSqFromQuery('update dba.BillItems set Id_Postgres= null where BillId = '+FieldByName('ObjectId').AsString);
             //fExecSqFromQuery('update dba.Bill set Id_Postgres= null where Id = '+FieldByName('ObjectId').AsString);
             //fExecSqToQuery (' select * from lpSetErased_Movement('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+',5)');

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbOrderInternal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_OrderInternal(SaveCount:Integer);
begin
     if (not cbOrderInternal.Checked)or(not cbOrderInternal.Enabled) then exit;
     myEnabledCB(cbOrderInternal);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.BillDate as BillDate');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');

        Add('     , isnull(BillItems.ZakazCount1,0) + isnull(BillItems.ZakazCount2,0) as Amount');
        Add('     , BillItems.ZakazChange as AmountSecond');

        Add('     , isnull(BillItems.RemainsOperCount, 0) + isnull(BillItems.RemainsOperCount_two,0) as AmountRemains');
        Add('     , isnull(BillItems.PrognozCount,0) as PrognozCount');
        Add('     , isnull(BillItems.PrognozCount_two,0) as PrognozCount_two');

        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');

        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId');
        Add('     left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId');

        Add('     left outer join dba.BillItemsZakaz as BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind = zc_bkProductionInZakaz()'
           +'  and (isUnitFrom.UnitId is not null and isUnitTo.UnitId is not null)'
           +'  and BillItems.Id is not null'
           +'  and Bill.Id_Postgres>0'
           );
        Add('order by 2,3,1');
        Open;

        cbOrderInternal.Caption:='7.2.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Заявки пр-во';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_OrderInternal';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountSecond',ftFloat,ptInput, 0);
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
             toStoredProc.Params.ParamByName('inAmountSecond').Value:=FieldByName('AmountSecond').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if ((1=0)or(FieldByName('Id_Postgres').AsInteger=0))
             then fExecSqFromQuery('update dba.BillItemsZakaz set Id_Postgres=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString);
             //
             fExecSqToQuery ('select lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountRemains(),'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+','+FloatToStr(FieldByName('AmountRemains').AsFloat)+')');
             fExecSqToQuery ('select lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountForecast(),'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+','+FloatToStr(FieldByName('PrognozCount').AsFloat)+')');
             fExecSqToQuery ('select lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountForecastOrder(),'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+','+FloatToStr(FieldByName('PrognozCount_two').AsFloat)+')');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbOrderInternal);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pLoadDocument_WeighingPartner:Integer;
var ContractId_pg,MovementDescId_pg:Integer;
    FromId_pg,ToId_pg,PaidKindId_pg,RouteSortingId_pg:Integer;
begin
     Result:=0;
     if (not cbWeighingPartner.Checked)or(not cbWeighingPartner.Enabled) then exit;
     //
     myEnabledCB(cbWeighingPartner);
     //
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ScaleHistory.BillId as ObjectId');
        Add('     , ScaleHistory.Date_pg as inOperDate');
        Add('     , Bill.BillNumber as inInvNumber');

        Add('     , isnull(Bill.Id_Postgres,-1*ScaleHistory.BillId) as inParentId');

        Add('     , ScaleHistory.minInsertDate as inStartWeighing');
        Add('     , ScaleHistory.maxInsertDate as inEndWeighing');

        Add('     , isnull(Bill.isNds,zc_rvNo()) as PriceWithVAT');
        Add('     , isnull(Bill.Nds,20) as inVATPercent');
        Add('     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else isnull(Bill.DiscountTax,0) end as inChangePercent');

        Add('     , case when ScaleHistory.BillKind=zc_bkIncomeToUnit() then ' + FormatToVarCharServer_notNULL('zc_Movement_Income()')
          +'             when ScaleHistory.BillKind=zc_bkReturnToClient() then ' + FormatToVarCharServer_notNULL('zc_Movement_ReturnOut()')
          +'             when ScaleHistory.BillKind=zc_bkSaleToClient() then ' + FormatToVarCharServer_notNULL('zc_Movement_Sale()')
          +'             when ScaleHistory.BillKind=zc_bkReturnToUnit() then ' + FormatToVarCharServer_notNULL('zc_Movement_ReturnIn()')

          +'             when ScaleHistory.BillKind=zc_bkSendUnitToUnit() then ' + FormatToVarCharServer_notNULL('zc_Movement_Send()')
          +'             when ScaleHistory.BillKind=zc_bkProduction() then ' + FormatToVarCharServer_notNULL('zc_Movement_ProductionSeparate()')
          +'             when ScaleHistory.BillKind=zc_bkProductionInFromReceipt() then ' + FormatToVarCharServer_notNULL('zc_Movement_ProductionUnion()')

          +'             when ScaleHistory.BillKind=zc_bkOut() then ' + FormatToVarCharServer_notNULL('zc_Movement_Loss()')
          +'             when ScaleHistory.BillKind=zc_bkProductionInZakaz() then ' + FormatToVarCharServer_notNULL('zc_Movement_Inventory()')
          +'        end as MovementDescName_pg');


        Add('     , NULL as inInvNumberTransport');
        Add('     , fGet_BillNumberAdd_byBillNumber(Bill.BillDate,Bill.BillNumber,Bill.Id) as inWeighingNumber');

        Add('     , trim(Bill.BillNumberClient1) as inInvNumberOrder');
        Add('     , ScaleHistory.PartionStr_MB as inPartionGoods');

        Add('     , isnull (pgPersonalFrom.Id_Postgres, isnull (pgUnitFrom.Id_Postgres, isnull (_pgPartnerFrom.PartnerId_pg,UnitFrom.Id3_Postgres))) as FromId_pg');
        Add('     , isnull (pgPersonalTo.Id_Postgres, isnull (pgUnitTo.Id_Postgres, isnull (_pgPartnerTo.PartnerId_pg,UnitTo.Id3_Postgres))) as ToId_pg');
        Add('     , case when ScaleHistory.BillKind in (zc_bkSendUnitToUnit(),zc_bkProduction(),zc_bkProductionInFromReceipt(),zc_bkOut(),zc_bkProductionInZakaz()) then null'
           +'            when Bill.MoneyKindId=zc_mkBN() then 3'
           +'            else 4'
           +'       end as PaidKindId_pg');
        Add('     , NULL as RouteSortingId_pg');

        Add('     , _pgUsers.Id_pg as inUserId');

        Add('     , ScaleHistory.isObv');
        Add('     , ScaleHistory.MovementId_pg as Id_Postgres');

        Add('from (select ScaleHistory.BillId'
           +'            ,zc_rvNo() as isObv'
           +'            ,max (isnull(ScaleHistory.UserId,0))as UserId'
           +'            ,max (isnull(ScaleHistory.FromId,0))as FromId'
           +'            ,max (isnull(ScaleHistory.ToId,0))as ToId'
           +'            ,max (isnull(ScaleHistory.BillKind,0))as BillKind'
           +'            ,max (isnull(ScaleHistory.isRemainsFact,zc_rvNo()))as isRemainsFact'
           +'            ,min(InsertDate) as minInsertDate'
           +'            ,max(InsertDate) as maxInsertDate'
           +'            ,fCalcCurrentBillDate_byPG(maxInsertDate,10) as Date_pg'
           +'            ,max(isnull(ScaleHistory.PartionStr_MB,'+FormatToVarCharServer_notNULL('')+')) as PartionStr_MB'
           +'            ,max(isnull(ScaleHistory.MovementId_pg,0))as MovementId_pg'
           +'      from dba.ScaleHistory'
           +'      where InsertDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-1)+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)+1)
           +'        and ScaleHistory.BillId>0'
           +'      group by ScaleHistory.BillId'
           +'     union'
           +'      select ScaleHistory.BillId'
           +'            ,zc_rvYes() as isObv'
           +'            ,max (isnull(ScaleHistory.UserId,0))as UserId'
           +'            ,max (isnull(ScaleHistory.FromId,0))as FromId'
           +'            ,max (isnull(ScaleHistory.ToId,0))as ToId'
           +'            ,max (isnull(ScaleHistory.BillKind,0))as BillKind'
           +'            ,max (isnull(ScaleHistory.isRemainsFact,zc_rvNo()))as isRemainsFact'
           +'            ,min(InsertDate) as minInsertDate'
           +'            ,max(InsertDate) as maxInsertDate'
           +'            ,fCalcCurrentBillDate_byPG(maxInsertDate,10) as Date_pg'
           +'            ,max(isnull(ScaleHistory.PartionStr_MB,'+FormatToVarCharServer_notNULL('')+')) as PartionStr_MB'
           +'            ,max(isnull(ScaleHistory.MovementId_pg,0))as MovementId_pg'
           +'      from dba.ScaleHistory_byObvalka as ScaleHistory'
           +'      where InsertDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-1)+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)+1)
           +'        and ScaleHistory.BillId>0'
           +'      group by ScaleHistory.BillId'
           +'     ) as ScaleHistory');
        Add('     left outer join dba.Bill on Bill.Id = ScaleHistory.BillId');

        Add('     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId');
        Add('     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId');
        Add('     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres');
        Add('     left outer join dba._pgPersonal as pgPersonalTo on pgPersonalTo.Id=UnitTo.PersonalId_Postgres');

        Add('     left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, UnitId from dba._pgPartner where _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by UnitId'
           +'                     ) as _pgPartnerFrom on _pgPartnerFrom.UnitId = Bill.FromId');
        Add('     left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, UnitId from dba._pgPartner where _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by UnitId'
           +'                     ) as _pgPartnerTo on _pgPartnerTo.UnitId = Bill.ToId');

        Add('     left outer join dba._pgUsers on _pgUsers.UserId = ScaleHistory.UserId');

        Add('where Date_pg between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('order by inOperDate, ObjectId');
        Open;
        Result:=RecordCount;
        cbWeighingPartner.Caption:='9.1. ('+IntToStr(RecordCount)+')Взвеш.покуп.';
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMI.Checked);
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_WeighingPartner_Sybase';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInvNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inStartWeighing',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inEndWeighing',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inPriceWithVAT',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inVATPercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inMovementDescId',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inInvNumberTransport',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inWeighingNumber',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inInvNumberOrder',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPartionGoods',ftString,ptInput, '');

        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContractId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPaidKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRouteSortingId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUserId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             //находим параметры по документу продажи
             if (FieldByName('inParentId').AsInteger>0)
             then begin
                       fOpenSqToQuery (' select Movement.DescId AS MovementDescId'
                                      +'      , MovementLinkObject_From.ObjectId AS FromId'
                                      +'      , COALESCE (MovementLinkObject_ArticleLoss.ObjectId, MovementLinkObject_To.ObjectId) AS ToId'
                                      +'      , MovementLinkObject_Contract.ObjectId AS ContractId'
                                      +'      , MovementLinkObject_PaidKind.ObjectId AS PaidKindId'
                                      +'      , MovementLinkObject_RouteSorting.ObjectId AS RouteSortingId'
                                      +' from Movement'
                                      +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_From'
                                      +'                                   ON MovementLinkObject_From.MovementId = Movement.Id'
                                      +'                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()'
                                      +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_To'
                                      +'                                   ON MovementLinkObject_To.MovementId = Movement.Id'
                                      +'                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()'
                                      +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss'
                                      +'                                   ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id'
                                      +'                                  AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()'
                                      +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract'
                                      +'                                   ON MovementLinkObject_Contract.MovementId = Movement.Id'
                                      +'                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()'
                                      +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind'
                                      +'                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id'
                                      +'                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()'
                                      +'      LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting'
                                      +'                                   ON MovementLinkObject_RouteSorting.MovementId = Movement.Id'
                                      +'                                  AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()'
                                      +' where Movement.Id = '+ FieldByName('inParentId').AsString);

                        MovementDescId_pg:=toSqlQuery.FieldByName('MovementDescId').AsInteger;
                        FromId_pg:=toSqlQuery.FieldByName('FromId').AsInteger;
                        ToId_pg:=toSqlQuery.FieldByName('ToId').AsInteger;
                        ContractId_pg:=toSqlQuery.FieldByName('ContractId').AsInteger;
                        PaidKindId_pg:=toSqlQuery.FieldByName('PaidKindId').AsInteger;
                        RouteSortingId_pg:=toSqlQuery.FieldByName('RouteSortingId').AsInteger;
                  end
             else begin if FieldByName('MovementDescName_pg').AsString <> ''
                        then begin fOpenSqToQuery ('select '+FieldByName('MovementDescName_pg').AsString+' AS RetV');
                                   MovementDescId_pg:=toSqlQuery.FieldByName('RetV').AsInteger;
                        end else MovementDescId_pg:=0;
                        FromId_pg:=FieldByName('FromId_pg').AsInteger;
                        ToId_pg:=FieldByName('ToId_pg').AsInteger;
                        ContractId_pg:=0;
                        PaidKindId_pg:=FieldByName('PaidKindId_pg').AsInteger;
                        RouteSortingId_pg:=0;
                  end;
             //
             //сохранение
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('inParentId').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('inInvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('inOperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inStartWeighing').Value:=FieldByName('inStartWeighing').AsDateTime;
             toStoredProc.Params.ParamByName('inEndWeighing').Value:=FieldByName('inEndWeighing').AsDateTime;
             if FieldByName('PriceWithVAT').AsInteger=zc_rvYes then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('inVATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercent').Value:=FieldByName('inChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('inMovementDescId').Value:=MovementDescId_pg;
             toStoredProc.Params.ParamByName('inInvNumberTransport').Value:=FieldByName('inInvNumberTransport').AsInteger;
             toStoredProc.Params.ParamByName('inWeighingNumber').Value:=FieldByName('inWeighingNumber').AsInteger;

             toStoredProc.Params.ParamByName('inInvNumberOrder').Value:=FieldByName('inInvNumberOrder').AsString;
             toStoredProc.Params.ParamByName('inPartionGoods').Value:=FieldByName('inPartionGoods').AsString;

             toStoredProc.Params.ParamByName('inFromId').Value:=FromId_pg;
             toStoredProc.Params.ParamByName('inToId').Value:=ToId_pg;
             toStoredProc.Params.ParamByName('inContractId').Value:=ContractId_pg;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=PaidKindId_pg;
             toStoredProc.Params.ParamByName('inRouteSortingId').Value:=RouteSortingId_pg;
             toStoredProc.Params.ParamByName('inUserId').Value:=FieldByName('inUserId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('isObv').AsInteger=zc_rvYes)
             then fExecSqFromQuery('update dba.ScaleHistory_byObvalka set MovementId_pg=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where BillId = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value))
             else
                 if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('isObv').AsInteger=zc_rvNo)
                 then fExecSqFromQuery('update dba.ScaleHistory set MovementId_pg=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where BillId = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbWeighingPartner);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_WeighingPartner(SaveCount:Integer);
var i:Integer;
str, str2:String;
begin
     if (not cbWeighingPartner.Checked)or(not cbWeighingPartner.Enabled) then exit;
     myEnabledCB(cbWeighingPartner);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ScaleHistory.Id as ObjectId');
        Add('     , ScaleHistory.Date_pg');
        Add('     , Bill.BillNumber as BillNumber');
        Add('     , ScaleHistory.InsertDate');
        Add('     , isnull(ScaleHistory.UpdateDate,zc_DateStart())as UpdateDate');
        Add('     , zc_DateStart() as zc_DateStart');
        Add('     , ScaleHistory.MovementId_pg as inMovementId');
        Add('     , GoodsProperty.Id_Postgres as inGoodsId');

        Add('     , ScaleHistory.Production_Weight as inAmount');
        Add('     , case when fIsClient_Fozzi(Bill.ToID)=zc_rvYes() or fIsClient_Kisheni(Bill.ToID)=zc_rvYes() or fIsClient_Vivat(Bill.ToID)=zc_rvYes() or fIsClient_Amstor(Bill.ToID)=zc_rvYes() or fIsClient_Real(Bill.ToID)=zc_rvYes()'
           +'              or fIsClient_ATB(Bill.ToID)=zc_rvYes() or fIsClient_OK(Bill.ToID)=zc_rvYes()'
           +'              or fIsClient_Fozzi(ScaleHistory.ToID)=zc_rvYes() or fIsClient_Kisheni(ScaleHistory.ToID)=zc_rvYes()'+'or fIsClient_Vivat(ScaleHistory.ToID)=zc_rvYes() or fIsClient_Amstor(ScaleHistory.ToID)=zc_rvYes() or fIsClient_Real(ScaleHistory.ToID)=zc_rvYes()'
           +'              or fIsClient_ATB(ScaleHistory.ToID)=zc_rvYes() or fIsClient_OK(ScaleHistory.ToID)=zc_rvYes()'
           +'                 then zf_MyRound3(ScaleHistory.Production_Weight*(1-ScaleHistory.DiscountWeight/100))'
           +'            when ScaleHistory.BillKind=zc_bkSaleToClient() and isnull(Bill.BillKind,0)<>zc_bkOut()'
           +'                 then zf_MyRound(ScaleHistory.Production_Weight*(1-ScaleHistory.DiscountWeight/100))'
           +'            when ScaleHistory.BillKind in (zc_bkIncomeToUnit(),zc_bkReturnToClient(),zc_bkReturnToUnit())'
           +'                 then ScaleHistory.Production_Weight'
           +'            else 0'
           +'       end as inAmountPartner');
        Add('     , ScaleHistory.Production_Weight + isnull(ScaleHistory.Tare_Count * ScaleHistory.Tare_Weight,0) as inRealWeight');
        Add('     , ScaleHistory.DiscountWeight as inChangePercentAmount');
        Add('     , ScaleHistory.Tare_Count as inCountTare');
        Add('     , ScaleHistory.Tare_Weight as inWeightTare');
        Add('     , ScaleHistory.OperCount_Upakovka as inCount');
        Add('     , case when isnull(Bill.FromId, ScaleHistory.FromID) <> zc_UnitId_StoreSale()'
           +'             and isnull(Bill.ToId, ScaleHistory.ToID) <> zc_UnitId_StoreSale()'
           +'                 then ScaleHistory.OperCount_sh'
           +'            else 0'
           +'       end as inHeadCount');
        Add('     , case when isnull(Bill.FromId, ScaleHistory.FromID) = zc_UnitId_StoreSale()'
           +'              or isnull(Bill.ToId, ScaleHistory.ToID) = zc_UnitId_StoreSale()'
           +'                 then case when ScaleHistory.NumberTare<>0 then 1 else ScaleHistory.OperCount_sh end'
           +'            else 0'
           +'       end as inBoxCount');
        Add('     , ScaleHistory.NumberTare as inBoxNumber');
        Add('     , ScaleHistory.NumberLevel as inLevelNumber');
        Add('     , PriceListItems_byHistory.NewPrice as inPrice');
        Add('     , 1 as inCountForPrice');
        Add('     , isnull(ScaleHistory.PartionDate,zc_DateStart()) as inPartionGoodsDate');

        Add('     , KindPackage.Id_Postgres as inGoodsKindId');
        Add('     , PriceList_byHistory.Id_Postgres as inPriceListId');
        Add('     , case when inBoxCount <> 0 then 300700 else 0 end as inBoxId');

        Add('     , ScaleHistory.isObv');

        Add('     , case when ScaleHistory.isErased=zc_erasedDel() then zc_rvYes() else zc_rvNo() end as isErased');
        Add('     , case when GoodsProperty.Id_Postgres is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка товар(')+'+GoodsProperty.GoodsName+'+FormatToVarCharServer_notNULL('*')+'+isnull(KindPackage.KindPackageName,'+FormatToVarCharServer_notNULL('')+')+'+FormatToVarCharServer_notNULL(')')
//           +'            when GoodsProperty_Detail_byServer.KindPackageId is null then cast (Bill.BillNumber as TVarCharMedium)+'+FormatToVarCharServer_notNULL('-ошибка вид')
           +'            else '+FormatToVarCharServer_notNULL('')
           +'       end as errInvNumber');

        Add('     , ScaleHistory.MIId_pg as Id_Postgres');
        Add('from (select ScaleHistory.Id'
           +'            ,ScaleHistory.BillId'
           +'            ,zc_rvNo() as isObv'
           +'            ,fCalcCurrentBillDate_byPG(InsertDate,10) as Date_pg'
           +'            ,InsertDate,UpdateDate'
           +'            ,BillKind,ToId,FromId'
           +'            ,Production_GoodsId as GoodsPropertyId'
           +'            ,KindPackageId'
           +'            ,PriceListId'
           +'            ,Production_Weight'
           +'            ,Tare_GoodsId'
           +'            ,Tare_Weight'
           +'            ,OperCount_Upakovka,OperCount_sh,NumberTare,NumberLevel,PartionDate'
           +'            ,isErased'
           +'            ,Tare_Count'
           +'            ,DiscountWeight'
           +'            ,ScaleHistory.MovementId_pg,ScaleHistory.MIId_pg'
           +'      from dba.ScaleHistory'
           +'      where InsertDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-1)+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)+1)
           +'        and ScaleHistory.BillId>0'
           +'        and ScaleHistory.MovementId_pg>0'
           +'     union'
           +'      select ScaleHistory.Id'
           +'            ,ScaleHistory.BillId'
           +'            ,zc_rvYes() as isObv'
           +'            ,fCalcCurrentBillDate_byPG(InsertDate,10) as Date_pg'
           +'            ,InsertDate,UpdateDate'
           +'            ,BillKind,ToId,FromId'
           +'            ,Production_GoodsId as GoodsPropertyId'
           +'            ,KindPackageId'
           +'            ,PriceListId'
           +'            ,Production_Weight'
           +'            ,Tare_GoodsId'
           +'            ,Tare_Weight'
           +'            ,OperCount_Upakovka,OperCount_sh,NumberTare,NumberLevel,PartionDate'
           +'            ,isErased'
           +'            ,Tare_Count'
           +'            ,DiscountWeight'
           +'            ,ScaleHistory.MovementId_pg,ScaleHistory.MIId_pg'
           +'      from dba.ScaleHistory_byObvalka as ScaleHistory'
           +'      where InsertDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text)-1)+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)+1)
           +'        and ScaleHistory.BillId>0'
           +'        and ScaleHistory.MovementId_pg>0'
           +'     ) as ScaleHistory');

        Add('     left outer join dba.Bill on Bill.Id = ScaleHistory.BillId');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = ScaleHistory.GoodsPropertyId');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = ScaleHistory.KindPackageId');
        //Add('                                    and Goods.ParentId not in(686,1670,2387,2849,5874)'); // Тара + СЫР + ХЛЕБ + С-ПЕРЕРАБОТКА + ТУШЕНКА
        Add('                                    and GoodsProperty.InfoMoneyCode in(20901,30101,30201)'); // Ирна  + Готовая продукция + Рулька
        Add('     left join dba.PriceList_byHistory on PriceList_byHistory.Id=ScaleHistory.PriceListID');
        Add('     LEFT JOIN dba.PriceListItems_byHistory on PriceListItems_byHistory.GoodsPropertyId=ScaleHistory.GoodsPropertyId'
           +'                                           and PriceListItems_byHistory.PriceListID = ScaleHistory.PriceListID' // ОПТОВЫЕ ЦЕНЫ
           +'                                           and ScaleHistory.Date_pg between PriceListItems_byHistory.StartDate and PriceListItems_byHistory.EndDate');
        Add('order by 2,3,1');
        Open;

        str:='';
        str2:='';
        for i:=0 to 20 do str:= str + #10+ #13 + ' ' + Sql[i];
        for i:=21 to Sql.Count-1 do str2:= str2 + #10+ #13 + ' ' + Sql[i];
// showMessage(str);
// showMessage(str2);

        cbWeighingPartner.Caption:='9.1.('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+')Взвеш.покуп.';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_WeighingPartner';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountPartner',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inRealWeight',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inChangePercentAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountTare',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inWeightTare',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inHeadCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inBoxCount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inBoxNumber',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inLevelNumber',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionGoodsDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsKindId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPriceListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBoxId',ftInteger,ptInput, 0);
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
             //
             if FieldByName('Id_Postgres').AsInteger <> 0
             then fExecSqToQuery ('select lpSetUnErased_MovementItem('+IntToStr(FieldByName('Id_Postgres').AsInteger)+',5)');

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('inMovementId').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('inGoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('inAmount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('inAmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inRealWeight').Value:=FieldByName('inRealWeight').AsFloat;
             toStoredProc.Params.ParamByName('inChangePercentAmount').Value:=FieldByName('inChangePercentAmount').AsFloat;
             toStoredProc.Params.ParamByName('inCountTare').Value:=FieldByName('inCountTare').AsFloat;
             toStoredProc.Params.ParamByName('inWeightTare').Value:=FieldByName('inWeightTare').AsFloat;
             toStoredProc.Params.ParamByName('inCount').Value:=FieldByName('inCount').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('inHeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inBoxCount').Value:=FieldByName('inBoxCount').AsFloat;
             toStoredProc.Params.ParamByName('inBoxNumber').Value:=FieldByName('inBoxNumber').AsFloat;
             toStoredProc.Params.ParamByName('inLevelNumber').Value:=FieldByName('inLevelNumber').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('inPrice').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('inCountForPrice').AsFloat;
             if FieldByName('inPartionGoodsDate').AsDateTime <= StrToDate('01.01.1900')
             then toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=StrToDate('01.01.1900')
             else toStoredProc.Params.ParamByName('inPartionGoodsDate').Value:=FieldByName('inPartionGoodsDate').AsDateTime;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('inGoodsKindId').AsInteger;
             toStoredProc.Params.ParamByName('inPriceListId').Value:=FieldByName('inPriceListId').AsInteger;
             toStoredProc.Params.ParamByName('inBoxId').Value:=FieldByName('inBoxId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('isObv').AsInteger=zc_rvYes)
             then fExecSqFromQuery('update dba.ScaleHistory_byObvalka set MIId_pg=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value))
             else
                 if (FieldByName('Id_Postgres').AsInteger=0)and(FieldByName('isObv').AsInteger=zc_rvNo)
                 then fExecSqFromQuery('update dba.ScaleHistory set MIId_pg=zf_ChangeIntToNull('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+') where Id = '+FieldByName('ObjectId').AsString + ' and 0<>'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value));
             //
             fExecSqToQuery ('select lpInsertUpdate_MovementItemDate(zc_MIDate_Insert(),'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+','+FormatToDateTimeServer(FieldByName('InsertDate').AsDateTime)+')');
             fExecSqToQuery ('select lpInsertUpdate_MovementItemDate(zc_MIDate_Update(),'+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+','+FormatToDateTimeServer(FieldByName('UpdateDate').AsDateTime)+')');
             if FieldByName('isErased').AsInteger=zc_rvYes
             then fExecSqToQuery ('select lpSetErased_MovementItem('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+',5)');
             //
             if (FieldByName('errInvNumber').AsString<>'')
             then begin
                  toStoredProc_two.Params.ParamByName('inId').Value:=FieldByName('inMovementId').AsInteger;
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
     myDisabledCB(cbWeighingPartner);
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
alter table dba.GoodsProperty_Detail add Id19_pg integer null;
alter table dba.GoodsProperty_Detail add Id20_pg integer null;
alter table dba.GoodsProperty_Detail add Id21_Postgres integer null;

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
  select 18, 'Край'               // fIsClient_Kray *** Code_byKray
  ;                               // ------
                                  // fIsClient_Furshet
                                  // fIsClient_Obgora

insert into dba.GoodsProperty_Postgres (Id, Name_PG,Id_Postgres)
  select 19, 'ВЭД Eng', 300422

insert into dba.GoodsProperty_Postgres (Id, Name_PG,Id_Postgres)
  select 20, 'ВЭД Рус', 300423

insert into dba.GoodsProperty_Postgres (Id, Name_PG,Id_Postgres)
  select 21, 'Кишени-Кулинария', 420377 // +fIsClient_KisheniContract *** GoodsCodeScaner_byKisheni



update dba.GoodsProperty_Postgres set Id = 21 where Id_Postgres = 420377

alter table dba.GoodsProperty_Kachestvo add Id_pg1 integer null;
alter table dba.GoodsProperty_Kachestvo add Id_pg2 integer null;

alter table dba.Receipt_byHistory add Id_pg integer null;
alter table dba.ReceiptItem_byHistory add Id_pg integer null;


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
