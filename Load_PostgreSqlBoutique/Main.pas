unit Main;

interface

uses
  Windows, Forms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ZAbstractConnection,
  ZConnection, dsdDB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.Samples.Gauges, Vcl.ExtCtrls, System.Classes,
  Vcl.Grids, Vcl.DBGrids, DBTables, dxSkinsCore, dxSkinsDefaultPainters,
  IdBaseComponent, IdComponent, IdIPWatch, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TMainForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    GuidePanel: TPanel;
    cbAllGuide: TCheckBox;
    Gauge: TGauge;
    StopButton: TButton;
    CloseButton: TButton;
    cbMeasure: TCheckBox;
    cbOnlyOpen: TCheckBox;
    DocumentPanel: TPanel;
    cbAllDocument: TCheckBox;
    OKDocumentButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    toSqlQuery: TZQuery;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    OKCompleteDocumentButton: TButton;
    toStoredProc: TdsdStoredProc;
    toStoredProc_two: TdsdStoredProc;
    toZConnection: TZConnection;
    toStoredProc_three: TdsdStoredProc;
    toSqlQuery_two: TZQuery;
    cbCompositionGroup: TCheckBox;
    cbCreateId_Postgres: TCheckBox;
    cbNullId_Postgres: TCheckBox;
    cbComposition: TCheckBox;
    cbCountryBrand: TCheckBox;
    cbBrand: TCheckBox;
    cbFabrika: TCheckBox;
    cbLineFabrica: TCheckBox;
    cbGoodsInfo: TCheckBox;
    cbGoodsSize: TCheckBox;
    cbCash: TCheckBox;
    cbValuta: TCheckBox;
    cbPeriod: TCheckBox;
    cbGoodsGroup: TCheckBox;
    cbDiscount: TCheckBox;
    cbDiscountTools: TCheckBox;
    cbPartner: TCheckBox;
    cbUnit: TCheckBox;
    cbLabel: TCheckBox;
    DatabaseSybase: TDatabase;
    fromQuery: TQuery;
    fromSqlQuery: TQuery;
    fromQuery_two: TQuery;
    fromQueryDate: TQuery;
    fromQueryDate_recalc: TQuery;
    cbGoods: TCheckBox;
    cbGoodsItem: TCheckBox;
    cbClient: TCheckBox;
    cbCity: TCheckBox;
    cbIncome: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    btnCreateTableDat: TButton;
    cbChado: TCheckBox;
    btnLoadDat: TButton;
    PathDatFiles: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    cbEsc: TCheckBox;
    cbMM: TCheckBox;
    cbSAV: TCheckBox;
    cbSav_out: TCheckBox;
    cbTer_Out: TCheckBox;
    cbTL: TCheckBox;
    cbVint: TCheckBox;
    cbSop: TCheckBox;
    cbGoods2: TCheckBox;
    btnInsertGoods2: TButton;
    btnDropTableDat: TButton;
    btnInsertHasChildGoods2: TButton;
    cbAllTables: TCheckBox;
    btnResultCSV: TButton;
    btnUpdateGoods2: TButton;

    lResultCSV: TLabel;
    lDropTableDat: TLabel;
    lInsertGoods2: TLabel;
    lInsertHasChildGoods2: TLabel;
    lUpdateGoods2: TLabel;
    lLoadDat: TLabel;
    lCreateTableDat: TLabel;
    Splitter1: TSplitter;
    btnResultGroupCSV: TButton;
    lResultGroupCSV: TLabel;
    cbCreateDocId_Postgres: TCheckBox;
    cbOnlyOpenMIMaster: TCheckBox;
    �bNotVisibleCursor: TCheckBox;
    cbJuridical: TCheckBox;
    cbReturnOut: TCheckBox;
    cbSend: TCheckBox;
    cbLoss: TCheckBox;
    cbPriceList: TCheckBox;
    cbDiscountPeriodItem: TCheckBox;
    cbPriceListItem: TCheckBox;
    cbMember: TCheckBox;
    cbUser: TCheckBox;
    cbInventory: TCheckBox;
    cbSale: TCheckBox;
    cbReturnIn: TCheckBox;
    cbSale_Child: TCheckBox;
    cbReturnIn_Child: TCheckBox;
    cbGroup11: TCheckBox;
    cbGroup22: TCheckBox;
    cbTest: TCheckBox;
    TestEdit: TEdit;
    cbGoodsAccount: TCheckBox;
    CompleteDocumentPanel: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    cbAllCompleteDocument: TCheckBox;
    cbCompleteIncome: TCheckBox;
    StartDateCompleteEdit: TcxDateEdit;
    EndDateCompleteEdit: TcxDateEdit;
    cbComplete: TCheckBox;
    cbUnComplete: TCheckBox;
    cbCompleteSend: TCheckBox;
    cbLastComplete: TCheckBox;
    cbCompleteInventory: TCheckBox;
    cbCompleteSale: TCheckBox;
    cbCompleteReturnIn: TCheckBox;
    cbCompleteReturnOut: TCheckBox;
    cbCompleteAccount: TCheckBox;
    cbCompleteLoss: TCheckBox;
    cbComplete_List: TCheckBox;
    cb100MSec: TCheckBox;
    cbOnlyOpenMIChild: TCheckBox;

    procedure OKGuideButtonClick(Sender: TObject);
    procedure cbAllGuideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure cbAllDocumentClick(Sender: TObject);
    procedure OKDocumentButtonClick(Sender: TObject);
    procedure cbAllCompleteDocumentClick(Sender: TObject);
    procedure OKCompleteDocumentButtonClick(Sender: TObject);
    procedure btnCreateTableDatClick(Sender: TObject);
    procedure btnLoadDatClick(Sender: TObject);
    procedure btnInsertGoods2Click(Sender: TObject);
    procedure btnDropTableDatClick(Sender: TObject);
    procedure btnInsertHasChildGoods2Click(Sender: TObject);
    procedure cbAllTablesClick(Sender: TObject);
    procedure btnUpdateGoods2Click(Sender: TObject);
    procedure btnResultCSVClick(Sender: TObject);
    procedure btnResultGroupCSVClick(Sender: TObject);
    procedure ButtonPanelDblClick(Sender: TObject);
    procedure �bNotVisibleCursorClick(Sender: TObject);
    procedure cbCompleteIncomeClick(Sender: TObject);
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
    function fExecSqFromQuery_noErr (mySql:String):Boolean;

    function fGetSession:String;
    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):Boolean;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;

    procedure pCreateGuide_Id_Postgres;
    procedure pCreateDocument_Id_Postgres;

    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;

    // Guides :
    procedure pLoadGuide_Measure;
    procedure pLoadGuide_CompositionGroup;
    procedure pLoadGuide_Composition;
    procedure pLoadGuide_CountryBrand;
    procedure pLoadGuide_Brand;
    procedure pLoadGuide_Fabrika;
    procedure pLoadGuide_LineFabrica;
    procedure pLoadGuide_GoodsInfo;
    procedure pLoadGuide_GoodsSize;
    procedure pLoadGuide_Valuta;
    procedure pLoadGuide_Cash;
    procedure pLoadGuide_Period;
    procedure pLoadGuide_GoodsGroup;
    procedure pLoadGuide_Discount;
    procedure pLoadGuide_DiscountTools;
    procedure pLoadGuide_Partner;
    procedure pLoadGuide_Unit;
    procedure pLoadGuide_Label;
    procedure pLoadGuide_Goods;
    procedure pLoadGuide_GoodsItem;
    procedure pLoadGuide_City;
    procedure pLoadGuide_Client;
    procedure pLoadGuide_Juridical;
    procedure pLoadGuide_PriceList;
    procedure pLoadGuide_Member;
    procedure pLoadGuide_User;

   // Documents
    function  pLoadDocument_Income:Integer;
    procedure pLoadDocumentItem_Income(SaveCount:Integer);

    function  pLoadDocument_ReturnOut:Integer;
    procedure pLoadDocumentItem_ReturnOut(SaveCount:Integer);

    function  pLoadDocument_Send:Integer;
    procedure pLoadDocumentItem_Send(SaveCount:Integer);

    function  pLoadDocument_Loss:Integer;
    procedure pLoadDocumentItem_Loss(SaveCount:Integer);

    function  pLoadDocument_Inventory:Integer;
    procedure pLoadDocumentItem_Inventory(SaveCount:Integer);

    function  pLoadDocument_Sale:Integer;
    procedure pLoadDocumentItem_Sale(SaveCount:Integer);

    function  pLoadDocument_ReturnIn:Integer;
    procedure pLoadDocumentItem_ReturnIn(SaveCount:Integer);

    function  pLoadDocument_Sale_Child:Integer;
    function  pLoadDocument_ReturnIn_Child:Integer;

    function  pLoadDocument_GoodsAccount:Integer;
    procedure pLoadDocumentItem_GoodsAccount(SaveCount:Integer);
    function  pLoadDocument_GoodsAccount_Child:Integer;

    procedure pLoadDocuments_PriceListItem;
    procedure pLoadDocuments_DiscountPeriodItem;

    // Complete
    procedure pCompleteDocumentAll(StartDate,EndDate:TDateTime);
    procedure pCompleteDocument_Income;
    procedure pCompleteDocument_ReturnOut;
    procedure pCompleteDocument_Send;
    procedure pCompleteDocument_Loss;
    procedure pCompleteDocument_Inventory;

    procedure pCompleteDocument_Sale;
    procedure pCompleteDocument_ReturnIn;
    procedure pCompleteDocument_Account;

    procedure CursorGridChange;

    // Load from files *.dat
    procedure pLoad_Chado;
    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics, UtilConst;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('������������� ���������� ��������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllTablesClick(Sender: TObject);
var i : integer;
begin
  for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=11
          then TCheckBox(Components[i]).Checked:=cbAllTables.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('������������� ���������� �������� � �����?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
procedure TMainForm.btnCreateTableDatClick(Sender: TObject);
begin
 lCreateTableDat.Caption:= 'FALSE';

     fExecSqFromQuery_noErr(
       ' 	CREATE TABLE _Group11 (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharLongLong ,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	UnitName  TVarCharMedium )' );
     fExecSqFromQuery_noErr(
       ' 	CREATE TABLE _Group22 (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharLongLong ,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	UnitName  TVarCharMedium )' );

      fExecSqFromQuery(' delete from DBA._Group11');
      fExecSqFromQuery(' delete from DBA._Group22');

      fExecSqFromQuery(
     ' 	LOAD TABLE DBA._Group11	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Group1.csv''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '',''	 '
     );
      fExecSqFromQuery(
     ' 	LOAD TABLE DBA._Group22	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Group2.csv''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '',''	 '
     );
fExecSqFromQuery(
 ' update _Group11 set col2 = ''�������'' where col2 = ''�����'' or col2 = ''����''; '
+' update _Group22 set col2 = ''�������'' where col2 = ''�����'' or col2 = ''����''; '
                );
 fExecSqFromQuery_noErr('alter table dba._Group11 add ParentId2 integer null;');
 fExecSqFromQuery_noErr('alter table dba._Group22 add ParentId2 integer null;');


 if cbChado.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE chado (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Incoming INTEGER,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium ,	 ' +
       ' 	BillItemsIncomeID INTEGER,	 ' +
       ' 	GoodsPropertyID INTEGER,	 ' +
       ' 	GoodsID INTEGER,	 ' +
       ' 	LineFabrica TVarCharMedium ,	 ' +
       ' 	Composition  TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );

 if cbEsc.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE Esc (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Incoming INTEGER,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium ,	 ' +
       ' 	BillItemsIncomeID INTEGER,	 ' +
       ' 	GoodsPropertyID INTEGER,	 ' +
       ' 	GoodsID INTEGER,	 ' +
       ' 	LineFabrica TVarCharMedium ,	 ' +
       ' 	Composition  TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );

 if cbMM.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE MM (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Incoming INTEGER,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium ,	 ' +
       ' 	BillItemsIncomeID INTEGER,	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );


 if cbSAV.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE SAV (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Incoming INTEGER,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	IntoPrise float,	   ' +
       ' 	IntoPriseRate float,	 ' +
       ' 	IntoPriseRate2 float,	 ' +
       ' 	PerDiscount float,  	 ' +
       '  Profit float,          ' +
       ' 	Valuta  TVarCharMedium, 	 ' +
       ' 	Prise float,	         ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	         ' +
       ' 	PeriodYear INTEGER,	   ' +
       ' 	GoodsInfo TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );

 if cbSav_out.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE Sav_out (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Incoming INTEGER,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium ,	 ' +
       ' 	BillItemsIncomeID INTEGER,	 ' +
       ' 	GoodsPropertyID INTEGER,	 ' +
       ' 	GoodsID INTEGER,	 ' +
       ' 	LineFabrica TVarCharMedium ,	 ' +
       ' 	Composition  TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );
 if cbTer_Out.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE Ter_Out (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	GoodsInfo TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );

 if cbTL.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE TL (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Incoming INTEGER,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium ,	 ' +
       ' 	Composition  TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );

 if cbVint.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE Vint (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	Prise float,	 ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );
 if cbSop.Checked then
     fExecSqFromQuery(
       ' 	CREATE TABLE Sop (	 ' +
       ' 	Code INTEGER ,	 ' +
       ' 	Goodsgroup TVarCharMedium ,	 ' +
       ' 	Name TVarCharMedium ,	 ' +
       ' 	Remain INTEGER,	 ' +
       ' 	col1  TVarCharMedium ,	 ' +
       ' 	col2  TVarCharMedium ,	 ' +
       ' 	col3  TVarCharMedium ,	 ' +
       ' 	col4  TVarCharMedium ,	 ' +
       ' 	col5  TVarCharMedium ,	 ' +
       ' 	col6  TVarCharMedium ,	 ' +
       ' 	col7  INTEGER ,	         ' +
       ' 	Partner  TVarCharMedium, 	 ' +
       ' 	Markup float,	 ' +
       ' 	PeriodYear INTEGER,	 ' +
       ' 	GoodsInfo TVarCharMedium ,	 ' +
       ' 	BillItemsIncomeID INTEGER,	 ' +
       ' 	GoodsPropertyID INTEGER,	 ' +
       ' 	GoodsID INTEGER,	 ' +
       ' 	LineFabrica TVarCharMedium ,	 ' +
       ' 	Composition  TVarCharMedium, 	 ' +
       ' 	ParentId2  Integer 	 ' +
       ' 	)	 '
     );
 if cbGoods2.Checked then begin
     fExecSqFromQuery(
       ' 	CREATE TABLE Goods2 (	 ' +
       ' 	ID INTEGER  DEFAULT  autoincrement ,	 ' +
       ' 	GoodsName TVarCharMedium,	 ' +
       ' 	Erased smallint ,	 ' +
       ' 	ParentID INTEGER,	 ' +
       ' 	HasChildren smallint,	 ' +
       ' 	isPrinted  smallint ,	 ' +
       ' 	CashCode  INTEGER ,	 ' +
       ' 	UserID  INTEGER ,	 ' +
       ' 	ProtocolDate  datetime ,	 ' +
       ' 	isReplication  INTEGER ,	 ' +
       ' 	CountryBrandID  INTEGER ,  ' +
       ' 	PRIMARY KEY (ID)         ' +
       ' 	)	 '
     );
     //
     // !!!�� ������ - ��� ����!!!
     fExecSqFromQuery(' insert into Goods2 (id, GoodsName, Erased, ParentID, HasChildren, isPrinted)'
                    + '   select 93, ''����������'',zc_erasedVis(), null, 2, zc_rvYes()');
     fExecSqFromQuery(' insert into Goods2 (id, GoodsName, Erased, ParentID, HasChildren, isPrinted)'
                    + '   select 113, ''�����'',zc_erasedVis(), null, 2, zc_rvYes()');
     fExecSqFromQuery(' insert into Goods2 (id, GoodsName, Erased, ParentID, HasChildren, isPrinted)'
                    + '   select 94, ''������'',zc_erasedVis(), null, 2, zc_rvYes()');
     // !!!�� ������ - ��� ����!!!
     fExecSqFromQuery(' insert into Goods2 (id, GoodsName, Erased, ParentID, HasChildren, isPrinted)'
                    + '   select 500000, ''�����'',zc_erasedVis(), null, 2, zc_rvYes()');
     // !!!�� ������ - ��� ����!!!
     // fExecSqFromQuery(' 	delete from Goods2 where id = 500000');
 end;

 lCreateTableDat.Caption:= 'TRUE';

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGetSession:String;
begin Result:='1005'; end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery(mySql:String):Boolean;
begin
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
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery_noErr(mySql:String):Boolean;
begin
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql; except Result:=false;exit;end;
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
          if (Components[i].Tag=10)and(TCheckBox(Components[i]).Enabled)
          then TCheckBox(Components[i]).Checked:=cbAllGuide.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.�bNotVisibleCursorClick(Sender: TObject);
begin
    CursorGridChange;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CursorGridChange;
begin
     if Assigned (DBGrid.DataSource.DataSet)
     then
       if �bNotVisibleCursor.Checked
       then DBGrid.DataSource.DataSet.DisableControls
       else DBGrid.DataSource.DataSet.EnableControls;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.btnLoadDatClick(Sender: TObject);
begin
 lLoadDat.Caption:= 'FALSE';


 if cbChado.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."chado"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\chado.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbEsc.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."Esc"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Esc.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbMM.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."MM"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\MM.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbSav.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."Sav"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Sav.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbSav_out.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."Sav_out"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Sav_out.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbTer_Out.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."Ter_Out"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Ter_Out.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbTL.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."TL"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\TL.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbVint.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."Vint"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Vint.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );
if cbSop.Checked then
 fExecSqFromQuery(
     ' 	LOAD TABLE "DBA"."Sop"	 ' +
     ' 	 FROM '''+pathdatfiles.Text+'\Sop.dat''	 ' +
     ' 	 QUOTES ON ESCAPES ON STRIP OFF	 ' +
     ' 	 DELIMITED BY '';''	 '
     );


 lLoadDat.Caption:= 'TRUE';

end;

procedure TMainForm.btnDropTableDatClick(Sender: TObject);
begin
 lDropTableDat.Caption:= 'FALSE';

 if cbChado.Checked then fExecSqFromQuery(' drop table chado');
 if cbEsc.Checked then fExecSqFromQuery(' drop table Esc');
 if cbMM.Checked then fExecSqFromQuery(' drop table MM');
 if cbSAV.Checked then fExecSqFromQuery(' drop table SAV');
 if cbSav_out.Checked then fExecSqFromQuery(' drop table Sav_out');
 if cbTer_Out.Checked then fExecSqFromQuery(' drop table Ter_Out');
 if cbTL.Checked then fExecSqFromQuery(' drop table TL');
 if cbVint.Checked then fExecSqFromQuery(' drop table Vint');
 if cbSop.Checked   then fExecSqFromQuery(' drop table Sop');
 if cbGoods2.Checked then fExecSqFromQuery(' drop table goods2');

 lDropTableDat.Caption:= 'TRUE';

end;

procedure TMainForm.btnInsertHasChildGoods2Click(Sender: TObject);
var  inGoodsName,  inParentID, inHasChildren : string;
begin
 lInsertHasChildGoods2.Caption:= 'FALSE';


 Gauge.Visible:=true;
    myEnabledCB(cbGoods2);
     //

     //������� �����, �.�. ��������� �� �����
     try fExecSqFromQuery_noErr('create view dba._ViewLoadPG6 as select distinct code, ParentId2, ''Sop'' as Name from Sop '
            + ' union '
            + '   select distinct code, ParentId2, ''Vint'' as Name from Vint '
            + ' union '
            + '   select distinct code, ParentId2, ''Tl'' as Name from Tl '
            + ' union '
            + '   select distinct code, ParentId2, ''Esc'' as Name from Esc '
            + ' union '
            + '   select distinct code, ParentId2, ''Mm'' as Name from Mm '
            + ' union '
            + '   select distinct code, ParentId2, ''Sav_out'' as Name from Sav_out '
            + ' union '
            + '   select distinct code, ParentId2, ''Ter_out'' as Name from Ter_out '
            + ' union '
            + '   select distinct code, ParentId2, ''Sav'' as Name from Sav '
            + ' union '
            + '   select distinct code, ParentId2, ''Chado'' as Name from Chado'
            );
     except end;

     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select id, GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID from goods where HasChildren = -1');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
          with fromQuery_two,Sql do begin
            Close;
            Clear;
            Add('select parentid2 as ParentId from  _ViewLoadPG6 as a  ');
            Add('where a.code = '+fromQuery.FieldByName('cashcode').AsString+'');
            Open;
            //if fromQuery_two.RecordCount > 0 then
             begin
                inParentID:=fromQuery_two.FieldByName('ParentId').AsString;
                inHasChildren:='-1';
               //
                if inParentID<>'' then
                 // �������� � ������ ��� �����
                fExecSqFromQuery(
                  ' Insert into goods2 (Id , GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  UserId, ProtocolDate, isReplication, CountryBrandID) ' +
                    // !!!�� ������ - ���� ��������� Id!!!
                  ' select Id, GoodsName, Erased, '+inParentID+' as ParentID, HasChildren, isPrinted, CashCode,  UserId, ProtocolDate, isReplication, CountryBrandID from goods where  ' +
                  ' id =  '+fromQuery.FieldByName('ID').AsString
                  )
                 else
                 // ��� ����� �������� � ������ - �����
                fExecSqFromQuery(
                  ' Insert into goods2 (Id , GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  UserId, ProtocolDate, isReplication, CountryBrandID) ' +
                    // !!!�� ������ - ���� ��������� Id!!!
                  ' select Id, GoodsName, Erased, 500000 as ParentID, HasChildren, isPrinted, CashCode,  UserId, ProtocolDate, isReplication, CountryBrandID from goods where  ' +
                  ' id =  '+fromQuery.FieldByName('ID').AsString
                  )

             end;
            //
          end;


             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;



     end;

     //
     // �������� .............
     {fExecSqFromQuery(' update goods2'
                     +' from goodsProperty'
                     +' where goods2.ParentId = 500000'
                     +'   and goods2.Id = goodsProperty.GoodsId'
                     );}
     //
     myDisabledCB(cbGoods2);
 Gauge.Visible:=False;

 lInsertHasChildGoods2.Caption:= 'TRUE';

end;

procedure TMainForm.btnUpdateGoods2Click(Sender: TObject);
var Res1, Res2, Res3 :Integer;
begin
  lUpdateGoods2.Caption:= 'FALSE';

  with fromQuery_two,Sql do begin
    Close;
    Clear;
    Add('select count(*) as res from goods2 where ParentId = 500000');
    Open;
    Res1:= fromQuery_two.FieldByName('res').AsInteger;
    Close;
  end;

      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG1 (GroupsName TVarCharLongLong primary key, ParentId integer)');
      except end;

      fExecSqFromQuery('delete from dba._TableLoadPG1');
      fExecSqFromQuery('insert into dba._TableLoadPG1 (GroupsName, ParentId)'
      +'       select goodsProperty.GroupsName, max (goods2.ParentId) AS ParentId'
      +'       from goodsProperty'
      +'            join goods2 on goods2.Id = goodsProperty.GoodsId'
      +'                       and goods2.ParentId <> 500000'
      +'      group by goodsProperty.GroupsName');
  //
  //
  fExecSqFromQuery(
       ' update goods2 set ParentId =  tmp.ParentId'
      +' from goodsProperty'
             //����� �����, �.�. ��������� �� �����
      +'      inner join _TableLoadPG1 as tmp on tmp.GroupsName = goodsProperty.GroupsName'
      +' where goods2.ParentId = 500000'
      +'   and goods2.Id = goodsProperty.GoodsId'
       );

  with fromQuery_two,Sql do begin
    Close;
    Clear;
    Add('select count(*) as res from goods2 where ParentId = 500000');
    Open;
    Res2:= fromQuery_two.FieldByName('res').AsInteger;
    Close;
  end;

  fExecSqFromQuery(
       ' update goods2 set ParentId =  tmp.ParentId2'
      +' from goodsProperty'
             //����� �����, �.�. ��������� �� �����
      +'      inner join _Group22 as tmp on tmp.Goodsgroup = goodsProperty.GroupsName'
      +' where goods2.ParentId = 500000'
      +'   and goods2.Id = goodsProperty.GoodsId'
       );
{
  fExecSqFromQuery(
       ' update goods2 set ParentId =  tmp.ParentId2'
      +' from goodsProperty'
             //����� �����, �.�. ��������� �� �����
      +'      inner join _Group11 as tmp on tmp.Goodsgroup = goodsProperty.GroupsName'
      +' where goods2.ParentId = 500000'
      +'   and goods2.Id = goodsProperty.GoodsId'
       );
}
  with fromQuery_two,Sql do begin
    Close;
    Clear;
    Add('select count(*) as res from goods2 where ParentId = 500000');
    Open;
    Res3:= fromQuery_two.FieldByName('res').AsInteger;
    Close;
  end;


      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG11 (GroupsName TVarCharLongLong primary key, Id integer)');
      except end;
  //��������� ������� �� ������ ������� � 1 ����
{
Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID)
   select distinct cast (goodsProperty.GroupsName as TVarCharMedium) as GoodsName, 0 as Erased, 500000 as ParentID, 2 as HasChildren, zc_rvYes() as isPrinted, 0 as CashCode, null as CountryBrandID
   from goodsProperty
        join goods2 on goods2.Id = goodsProperty.GoodsId
                   and goods2.ParentId = 500000
                   and goods2.HasChildren = -1;

 delete from dba._TableLoadPG11;
 insert into dba._TableLoadPG11 (Id, GroupsName)
         select goods2.Id, goods2.GoodsName as GroupsName
         from goods2
         where goods2.ParentId = 500000 and goods2.HasChildren <> -1;

update goods2 set ParentId = tmp.Id
from goodsProperty
    join _TableLoadPG11 as tmp on tmp.GroupsName = cast (goodsProperty.GroupsName as TVarCharMedium)
where goods2.ParentId = 500000
  and goods2.HasChildren = -1
  and goods2.Id = goodsProperty.GoodsId;

select *  from goods2 where ParentId = 500000 and HasChildren = -1 -- 14384
select count(*) from goods2 where ParentId = 500000 and HasChildren = -1 -- 14384
select count(*) from goods2 where ParentId = 500000 and HasChildren <> -1 -- 2425
commit
rollback
}

 lUpdateGoods2.Caption:= 'TRUE ('+IntToStr(Res1)+') - ('+IntToStr(Res2)+') - ('+IntToStr(Res3)+')';

end;

procedure TMainForm.ButtonPanelDblClick(Sender: TObject);
begin
     gc_isDebugMode:=not gc_isDebugMode;
     if gc_isDebugMode = TRUE
     then ShowMessage ('������� - ��������')
     else ShowMessage ('������� - ���������');

end;

procedure TMainForm.btnResultCSVClick(Sender: TObject);
var strCSV: string;
    csvFile: TextFile;
begin
 lResultCSV.Caption:= 'FALSE';

  // ??? ����� ???
  //if (not cbGoods2.Checked)or(not cbGoods2.Enabled) then exit;

    Gauge.Visible:=true;
     //
     myEnabledCB(cbGoods2);

      //
      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG2 (goodsid integer primary key'
           +'                     , OperCount TSumm'
           +'                     , RemainsCount TSumm'
           +'                     , OperPrice TSumm'
           +'                     , PriceListPrice  TSumm'
           +'                     , UnitID Integer'
           +'                     , clientid Integer'
           +'                     , ValutaID Integer'
           +'                     , DateIn date)');
      except end;
      //
      fExecSqFromQuery('delete from dba._TableLoadPG2');
      fExecSqFromQuery('insert into dba._TableLoadPG2 (goodsid'
           +'                     , OperCount '
           +'                     , RemainsCount '
           +'                     , OperPrice '
           +'                     , PriceListPrice  '
           +'                     , UnitID '
           +'                     , clientid '
           +'                     , ValutaID '
           +'                     , DateIn)'
           +'                     select BillItemsIncome.goodsid '
           +'                     , sum(BillItemsIncome.OperCount) as OperCount '
           +'                     , sum(BillItemsIncome.RemainsCount) as RemainsCount '
           +'                     , max(BillItemsIncome.OperPrice) as OperPrice '
           +'                     , max(BillItemsIncome.PriceListPrice) as PriceListPrice  '
           +'                     , max(BillItemsIncome.UnitID) as UnitID'
           +'                     , max(BillItemsIncome.clientid)  as  clientid '
           +'                     , max(BillItemsIncome.ValutaID)  as  ValutaID '
           +'                     , max(BillItemsIncome.DateIn)    as  DateIn '
           +'                 from BillItemsIncome  '
           +'                 group by goodsid');
      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG3 (goodsid integer primary key'
           +'                     , GroupsName TVarCharLong)');
      except end;
      fExecSqFromQuery('delete from dba._TableLoadPG3');
      fExecSqFromQuery('insert into dba._TableLoadPG3 (goodsid, GroupsName)'
                      +'  select DISTINCT goodsid, GroupsName from goodsproperty');
      //
       with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select goods2.CashCode as CashCode');
        Add('      , grgoods.GroupsName as GroupsName ');
        Add('      , goods2.GoodsName as Name ');
        Add('      , BillItemsIncome.OperCount as OperCount ');
        Add('      , BillItemsIncome.RemainsCount as RemainsCount ');
        Add('      , BillItemsIncome.OperPrice as OperPrice ');
        Add('      , valuta.ValutaName as Valuta  ');
        Add('      , BillItemsIncome.PriceListPrice as PriceListPrice  ');
        Add('      , Partner.UnitName as Partner  ');
        Add('      , Shop.UnitName as Shop  ');
        Add('      , BillItemsIncome.DateIn as DateIn  ');
        Add(' from goods2  ');
                  //����� �����, �.�. ��������� �� �����
        Add('     left outer join _TableLoadPG2 as BillItemsIncome on BillItemsIncome.goodsid = goods2.id ');
                  //����� �����, �.�. ��������� �� �����
        Add('     left outer join _TableLoadPG3 as grGoods on grGoods.goodsid = goods2.id');

        Add('     left outer join  Unit as Shop on shop.id = BillItemsIncome.UnitID ');
        Add('     left outer join  Unit as Partner on Partner.id = BillItemsIncome.clientid ');
        Add('     left outer join valuta on valuta.id = BillItemsIncome.ValutaID ');
        Add(' where goods2.ParentId = 500000 ');
        Add('   and goods2.HasChildren = -1  ');
        Add(' order by goods2.CashCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        //
        AssignFile(csvFile, pathdatfiles.Text+'\Goods2.csv');
        ReWrite(csvFile);
        WriteLn(csvFile, ';;;;;��/��;����;���;�������;��, ����,���;������;;;;;;');
        WriteLn(csvFile, ';;;;;���/���;�/�;�����;��������;���.�����.;;;;;;;');
        WriteLn(csvFile, ';;;;;;;;;;;;;;;;');
        WriteLn(csvFile, '���;������;��������;����.;���.;1;2;3;4;5;6;�� ����;���.;����~�� �-�;���������;�������;���� �������');
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
               strCSV := fromQuery.FieldByName('CashCode').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('GroupsName').AsString;
               strCSV := strCSV +';'+ myReplaceStr(fromQuery.FieldByName('Name').AsString,';',',');
               strCSV := strCSV +';'+ fromQuery.FieldByName('OperCount').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('RemainsCount').AsString;
               strCSV := strCSV +';;;;;;;'+ fromQuery.FieldByName('OperPrice').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('Valuta').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('PriceListPrice').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('Partner').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('Shop').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('DateIn').AsString;
             //
               WriteLn(csvFile, strCSV);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        CloseFile(csvFile);
     end;
     //
     myDisabledCB(cbGoods2);
     Gauge.Visible:=False;

 lResultCSV.Caption:= 'TRUE - ' + pathdatfiles.Text + '\Goods2.csv';

end;

procedure TMainForm.btnResultGroupCSVClick(Sender: TObject);
var strCSV: string;
    csvFile: TextFile;
begin
 lResultGroupCSV.Caption:= 'FALSE';

    Gauge.Visible:=true;
     //
     myEnabledCB(cbGoods2);
      //
      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG2 (goodsid integer primary key'
           +'                     , OperCount TSumm'
           +'                     , RemainsCount TSumm'
           +'                     , OperPrice TSumm'
           +'                     , PriceListPrice  TSumm'
           +'                     , UnitID Integer'
           +'                     , clientid Integer'
           +'                     , ValutaID Integer'
           +'                     , DateIn date)');
      except end;
      //
      fExecSqFromQuery('delete from dba._TableLoadPG2');
      fExecSqFromQuery('insert into dba._TableLoadPG2 (goodsid'
           +'                     , OperCount '
           +'                     , RemainsCount '
           +'                     , OperPrice '
           +'                     , PriceListPrice  '
           +'                     , UnitID '
           +'                     , clientid '
           +'                     , ValutaID '
           +'                     , DateIn)'
           +'                     select BillItemsIncome.goodsid '
           +'                     , sum(BillItemsIncome.OperCount) as OperCount '
           +'                     , sum(BillItemsIncome.RemainsCount) as RemainsCount '
           +'                     , max(BillItemsIncome.OperPrice) as OperPrice '
           +'                     , max(BillItemsIncome.PriceListPrice) as PriceListPrice  '
           +'                     , max(BillItemsIncome.UnitID) as UnitID'
           +'                     , max(BillItemsIncome.clientid)  as  clientid '
           +'                     , max(BillItemsIncome.ValutaID)  as  ValutaID '
           +'                     , max(BillItemsIncome.DateIn)    as  DateIn '
           +'                 from BillItemsIncome  '
           +'                 group by goodsid');
      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG3 (goodsid integer primary key'
           +'                     , GroupsName TVarCharLong)');
      except end;
      fExecSqFromQuery('delete from dba._TableLoadPG3');
      fExecSqFromQuery('insert into dba._TableLoadPG3 (goodsid, GroupsName)'
                      +'  select DISTINCT goodsid, GroupsName from goodsproperty');
      //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select max (goods2.CashCode) as CashCode');
        Add('      , grgoods.GroupsName as GroupsName ');
        Add('      , null as Name ');
        Add('      , sum (BillItemsIncome.OperCount) as OperCount ');
        Add('      , sum (BillItemsIncome.RemainsCount) as RemainsCount ');
        Add('      , null as OperPrice ');
        Add('      , null as Valuta  ');
        Add('      , null as PriceListPrice  ');
        Add('      , null as Partner');
        Add('      , Shop.UnitName as Shop  ');
        Add('      , max (BillItemsIncome.DateIn) as DateIn');
        Add(' from goods2');
                  //����� �����, �.�. ��������� �� �����
        Add('     left outer join _TableLoadPG2 as BillItemsIncome on BillItemsIncome.goodsid = goods2.id ');
                 //����� �����, �.�. ��������� �� �����
        Add('     left outer join _TableLoadPG3 as grGoods on grGoods.goodsid = goods2.id');

        Add('     left outer join Unit as Shop on shop.id = BillItemsIncome.UnitID ');
        Add(' where goods2.ParentId = 500000 ');
        Add('   and goods2.HasChildren = -1  ');
        Add(' group by grgoods.GroupsName');
        Add('        , Shop.UnitName');
        Add(' order by grgoods.GroupsName');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        //
        AssignFile(csvFile, pathdatfiles.Text+'\Groups2.csv');
        ReWrite(csvFile);
        WriteLn(csvFile, ';;;;;��/��;����;���;�������;��, ����,���;������;;;;;;');
        WriteLn(csvFile, ';;;;;���/���;�/�;�����;��������;���.�����.;;;;;;;');
        WriteLn(csvFile, ';;;;;;;;;;;;;;;;');
        WriteLn(csvFile, '���;������;��������;����.;���.;1;2;3;4;5;6;�� ����;���.;����~�� �-�;���������;�������;���� �������');
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
               strCSV := fromQuery.FieldByName('CashCode').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('GroupsName').AsString;
               strCSV := strCSV +';'+ myReplaceStr(fromQuery.FieldByName('Name').AsString,';',',');
               strCSV := strCSV +';'+ fromQuery.FieldByName('OperCount').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('RemainsCount').AsString;
               strCSV := strCSV +';;;;;;;'+ fromQuery.FieldByName('OperPrice').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('Valuta').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('PriceListPrice').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('Partner').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('Shop').AsString;
               strCSV := strCSV +';'+ fromQuery.FieldByName('DateIn').AsString;
             //
               WriteLn(csvFile, strCSV);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        CloseFile(csvFile);
     end;
     //
     myDisabledCB(cbGoods2);
     Gauge.Visible:=False;

 lResultGroupCSV.Caption:= 'TRUE - ' + pathdatfiles.Text + '\Group2.csv';
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
procedure TMainForm.cbCompleteIncomeClick(Sender: TObject);
begin
     if (not cbComplete.Checked)and(not cbUnComplete.Checked)
     then begin cbComplete.Checked:=true;cbUnComplete.Checked:=true;end;
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
     with toZConnection do begin
        Connected:=false;
        HostName:='localhost';
        User:='postgres';
        Password:='postgres';
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
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����', gc_User);
     if not Assigned (gc_User) then ShowMessage ('not Assigned (gc_User)');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.btnInsertGoods2Click(Sender: TObject);
var  inGoodsName,  inParentID, inHasChildren , upWhere : string;
     fErr : Boolean;
begin
 lInsertGoods2.Caption:= 'FALSE';
// if not cbGoods2.Checked then Exit;


 Gauge.Visible:=true;
 myEnabledCB(cbGoods2);
// ������ �����
fExecSqFromQuery(
 ' update _Group11 set col2 = ''�������'' where col2 = ''�����'' or col2 = ''����''; '+
 ' update _Group22 set col2 = ''�������'' where col2 = ''�����'' or col2 = ''����''; '+

 ' update sop set col1=''�������'' where col1=''�����''; ' +
 ' update sop set col2=''�������'' where col2=''�����''; ' +

 ' update sav_out  set col1=''���'' where col1=''���''; ' +
 ' update sav_out  set col2=''���'' where col2=''���''; ' +

 ' update sav_out  set col1=''���'' where col1=''���''; ' +
 ' update sav_out  set col2=''���'' where col2=''���''; ' +

 ' update ter_out  set col1=''���'' where col1=''���''; ' +
 ' update ter_out  set col2=''���'' where col2=''���''; ' +

 ' update ter_out  set col1=''���'' where col1=''���''; ' +
 ' update ter_out  set col2=''���'' where col2=''���''; ' +

 ' update tl  set col1=''���'' where col1=''���''; ' +
 ' update tl  set col2=''���'' where col2=''���''; ' +

 ' update tl  set col1=''���'' where col1=''���''; ' +
 ' update tl  set col2=''���'' where col2=''���''; '
);

  with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Sop'' as Name'+' from Sop');
        Add(' where '+ BoolToStr(cbSop.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Vint'' as Name'+' from Vint');
        Add(' where '+ BoolToStr(cbVint.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Tl'' as Name'+' from Tl');
        Add(' where '+ BoolToStr(cbTl.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Esc'' as Name'+' from Esc');
        Add(' where '+ BoolToStr(cbEsc.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Mm'' as Name'+' from Mm');
        Add(' where '+ BoolToStr(cbMm.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Sav_out'' as Name'+' from Sav_out');
        Add(' where '+ BoolToStr(cbSav_out.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Ter_out'' as Name'+' from Ter_out');
        Add(' where '+ BoolToStr(cbTer_out.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Sav'' as Name'+' from Sav');
        Add(' where '+ BoolToStr(cbSav.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''Chado'' as Name'+' from Chado');
        Add(' where '+ BoolToStr(cbChado.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''_Group11'' as Name'+' from _Group11');
        Add(' where '+ BoolToStr(cbGroup11.Checked) + ' <> 0');

        Add('union');
        Add('select distinct col1, col2, col3, col4, col5, col6, '+'''_Group22'' as Name'+' from _Group22');
        Add(' where '+ BoolToStr(cbGroup22.Checked) + ' <> 0');

        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        //
        while not EOF do   // ���� �� ���� �������
        begin
         //!!!
         if fStop then begin exit;end;

         fErr:= false;
         //
           inParentID:='null';
           inHasChildren:='2';

          // 1-�� ������� - col1
          with fromQuery_two,Sql do
          begin
            //�������� ��������-1 - !!!������ ����!!!
            if trim (fromQuery.FieldByName('Col1').AsString) = '' then ShowMessage('������ - col1 - ������ :'
                                                                                 + ' <' + fromQuery.FieldByName('Col1').AsString +  '>'
                                                                                 + ' <' + fromQuery.FieldByName('Col2').AsString +  '>'
                                                                                 + ' <' + fromQuery.FieldByName('Col3').AsString +  '>'
                                                                                 + ' <' + fromQuery.FieldByName('Col4').AsString +  '>'
                                                                                 + ' <' + fromQuery.FieldByName('Col5').AsString +  '>'
                                                                                 + ' <' + fromQuery.FieldByName('Col6').AsString +  '>'
                                                                                 + ' <' + fromQuery.FieldByName('Name').AsString +  '>'
                                                                                 + ' <' + inParentID +  '>'
                                                                                  );

            Close;
            Clear;
            //����� ��������-1
            Add('select id from goods as goods2 where lower(goodsname) = lower(trim('''+lowercase(fromQuery.FieldByName('Col1').AsString)+'''))');
            Add('   and isnull(ParentId,0) = 0');
            Add('   and HasChildren <> -1');
            Open;
            //���� �� ����� �������-1 - ����� Insert
            if (fromQuery_two.RecordCount <> 1) and (fErr = false) then
            begin
                inGoodsName:= fromQuery.FieldByName('Col1').AsString;
                inParentID:='null';
                inHasChildren:='2';
                //
            fErr:=true;
            ShowMessage ('1 ' + trim(inGoodsName) + '   and ParentId = ' + inParentID);
                {if inGoodsName<>'' then
                fExecSqFromQuery(
                  ' Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID) ' +
                  ' select distinct ''' + trim(inGoodsName) + ''' as GoodsName , 0 as Erased, '+inParentID+' as ParentID,  '+inHasChildren+' as HasChildren, 0 as isPrinted, 0 as CashCode  , null as CountryBrand '
                  );
                //����� ����� ParentID ��� !!!����������!!! ������
                Close;
                Open;
                if fromQuery_two.RecordCount <> 1
                then ShowMessage('������ - �� ������ Id - col1')
                else inParentID:=fromQuery_two.FieldByName('Id').AsString;}
            end
            //����� ����� �������� ParentID ��� !!!����������!!! ������
            else inParentID:=fromQuery_two.FieldByName('Id').AsString;

          end;  // ����� ������ ������� col1

          //
          // 2-�� ������� - col2
          with fromQuery_two,Sql do
           if trim (fromQuery.FieldByName('Col2').AsString) <> '' then
           begin
            Close;
            Clear;
            //����� ��������-2
            Add('select id from goods as goods2 where lower(goodsname) = lower(trim('''+lowercase(fromQuery.FieldByName('Col2').AsString)+'''))');
            Add('   and ParentId = ' + inParentID);
            Add('   and HasChildren <> -1');
            Open;

            //���� �� ����� �������-2 - ����� Insert
            if (fromQuery_two.RecordCount <> 1) and (fErr = false) then
            begin
                inGoodsName := fromQuery.FieldByName('Col2').AsString;
                inHasChildren := '2';
            fErr:=true;
            ShowMessage ('2 ' + trim(inGoodsName) + '   and ParentId = ' + inParentID);
                //
            {    fExecSqFromQuery(
                  ' Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID) ' +
                  ' select distinct ''' + trim(inGoodsName) + ''' as GoodsName , 0 as Erased, '+inParentID+' as ParentID,  '+inHasChildren+' as HasChildren, 0 as isPrinted, 0 as CashCode  , null as CountryBrand '
                  );
                //����� ����� ParentID ��� !!!����������!!! ������
                Close;
                Open;
                if fromQuery_two.RecordCount <> 1
                then ShowMessage('������ - �� ������ Id - col2')
                else inParentID:=fromQuery_two.FieldByName('Id').AsString;}
            end
            //����� ����� �������� ParentID ��� !!!����������!!! ������
            else inParentID:=fromQuery_two.FieldByName('Id').AsString;

          end;  // ����� ������ ������� col2

          //
          // 3-�� ������� - col3
          with fromQuery_two,Sql do
           if trim (fromQuery.FieldByName('Col3').AsString) <> '' then
           begin
            Close;
            Clear;
            Add('select id from goods as goods2 where  lower(goodsname) = lower(trim('''+lowercase(fromQuery.FieldByName('Col3').AsString)+'''))');
            Add('   and ParentId = ' + inParentID);
            Add('   and HasChildren <> -1');
            Open;

            //���� �� ����� �������-3 - ����� Insert
            if (fromQuery_two.RecordCount <> 1) and (fErr = false) then
            begin
                inGoodsName := fromQuery.FieldByName('Col3').AsString;
                inHasChildren := '2';
                //
            fErr:=true;
            ShowMessage ('3 ' + trim(inGoodsName) + '   and ParentId = ' + inParentID);
                {fExecSqFromQuery(
                  ' Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID) ' +
                  ' select distinct '''+ trim(inGoodsName) +''' as GoodsName , 0 as Erased, '+inParentID+' as ParentID,  '+inHasChildren+' as HasChildren, 0 as isPrinted, 0 as CashCode  , null as CountryBrand '
                  );
                //����� ����� ParentID ��� !!!����������!!! ������
                Close;
                Open;
                if fromQuery_two.RecordCount <> 1
                then ShowMessage('������ - �� ������ Id - col3')
                else inParentID:=fromQuery_two.FieldByName('Id').AsString;}
            end
            //����� ����� �������� ParentID ��� !!!����������!!! ������
            else inParentID:=fromQuery_two.FieldByName('Id').AsString;

          end;  // ����� ������ ������� col3

          //
          // 4-�� ������� - col4
          with fromQuery_two,Sql do
           if trim (fromQuery.FieldByName('Col4').AsString) <> '' then
           begin
            Close;
            Clear;
            Add('select id from goods as goods2 where  lower(goodsname) = lower(trim('''+lowercase(fromQuery.FieldByName('Col4').AsString)+'''))');
            Add('   and ParentId = ' + inParentID);
            Add('   and HasChildren <> -1');
            Open;

            //���� �� ����� �������-4 - ����� Insert
            if (fromQuery_two.RecordCount <> 1) and (fErr = false) then
             begin
                inGoodsName := fromQuery.FieldByName('Col4').AsString;
                inHasChildren := '2';
                //
            fErr:=true;
            ShowMessage ('4 ' + trim(inGoodsName) + '   and ParentId = ' + inParentID);
                {fExecSqFromQuery(
                  ' Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID) ' +
                  ' select distinct '''+ trim(inGoodsName) +''' as GoodsName , 0 as Erased, '+inParentID+' as ParentID,  '+inHasChildren+' as HasChildren, 0 as isPrinted, 0 as CashCode  , null as CountryBrand '
                  );
                //����� ����� ParentID ��� !!!����������!!! ������
                Close;
                Open;
                if fromQuery_two.RecordCount <> 1
                then ShowMessage('������ - �� ������ Id - col4')
                else inParentID:=fromQuery_two.FieldByName('Id').AsString;   }
            end
            //����� ����� �������� ParentID ��� !!!����������!!! ������
            else inParentID:=fromQuery_two.FieldByName('Id').AsString;

          end;  // ����� ��������� ������� col4

          //
          // 5-�� ������� - col5
          with fromQuery_two,Sql do
           if trim (fromQuery.FieldByName('Col5').AsString) <> '' then
           begin
            Close;
            Clear;
            Add('select id from goods as goods2 where lower(goodsname) = lower(trim('''+lowercase(fromQuery.FieldByName('Col5').AsString)+'''))');
            Add('   and ParentId = ' + inParentID);
            Add('   and HasChildren <> -1');
            Open;

            //���� �� ����� �������-5 - ����� Insert
            if (fromQuery_two.RecordCount <> 1) and (fErr = false) then
            begin
                inGoodsName := fromQuery.FieldByName('Col5').AsString;
                inHasChildren := '2';
                //
            fErr:=true;
            ShowMessage ('5 ' + trim(inGoodsName) + '   and ParentId = ' + inParentID);
                {fExecSqFromQuery(
                  ' Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID) ' +
                  ' select distinct '''+ trim(inGoodsName) +''' as GoodsName , 0 as Erased, '+inParentID+' as ParentID,  '+inHasChildren+' as HasChildren, 0 as isPrinted, 0 as CashCode  , null as CountryBrand '
                  );
                //����� ����� ParentID ��� !!!����������!!! ������
                Close;
                Open;
                if fromQuery_two.RecordCount <> 1
                then ShowMessage('������ - �� ������ Id - col5')
                else inParentID:=fromQuery_two.FieldByName('Id').AsString;}
            end
            //����� ����� �������� ParentID ��� !!!����������!!! ������
            else inParentID:=fromQuery_two.FieldByName('Id').AsString;

          end;  // ����� ������� col5

          //
          // 6-�� ������� - col6
          with fromQuery_two,Sql do
           if trim (fromQuery.FieldByName('Col6').AsString) <> '' then
           begin
            Close;
            Clear;
            Add('select id from goods as goods2 where lower(goodsname) = lower(trim('''+lowercase(fromQuery.FieldByName('Col6').AsString)+'''))');
            Add('   and ParentId = ' + inParentID);
            Add('   and HasChildren <> -1');
            Open;

            //���� �� ����� �������-6 - ����� Insert
            if (fromQuery_two.RecordCount <> 1) and (fErr = false) then
            begin
                inGoodsName := fromQuery.FieldByName('Col6').AsString;
                inHasChildren := '1';
                //
            fErr:=true;
            ShowMessage ('6 '
                               + ' <' + fromQuery.FieldByName('Col1').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col2').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col3').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col4').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col5').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col6').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Name').AsString +  '>'
                               + ' <' + inParentID +  '>'
                                );
                {fExecSqFromQuery(
                  ' Insert into goods2 (GoodsName, Erased, ParentID, HasChildren, isPrinted, CashCode,  CountryBrandID) ' +
                  ' select distinct '''+ trim(inGoodsName) +''' as GoodsName , 0 as Erased, '+inParentID+' as ParentID,  '+inHasChildren+' as HasChildren, 0 as isPrinted, 0 as CashCode  , null as CountryBrand '
                  );
                //����� ����� ParentID ��� !!!����������!!! ������
                Close;
                Open;
                if fromQuery_two.RecordCount <> 1
                then ShowMessage('������ - �� ������ Id - col6'
                               + ' <' + fromQuery.FieldByName('Col1').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col2').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col3').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col4').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col5').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Col6').AsString +  '>'
                               + ' <' + fromQuery.FieldByName('Name').AsString +  '>'
                               + ' <' + inParentID +  '>'
                                )
                else inParentID:=fromQuery_two.FieldByName('Id').AsString;}
            end
            //����� ����� �������� ParentID ��� !!!����������!!! ������
            else inParentID:=fromQuery_two.FieldByName('Id').AsString;

          end;  // ����� ������ ������� col6

          // ���������� ParentId2 ��� ������� �������

          if fErr = false then
          begin
          upWhere:=' update  '+fromQuery.FieldByName('Name').AsString +'  set ParentId2 = '+ inParentID +' where ';
          upWhere:=upWhere + '     lower(trim(isnull (col1, ''''))) = lower(trim('''+fromQuery.FieldByName('Col1').AsString+''')) ';
          upWhere:=upWhere + ' and lower(trim(isnull (col2, ''''))) = lower(trim('''+fromQuery.FieldByName('Col2').AsString+''')) ';
          upWhere:=upWhere + ' and lower(trim(isnull (col3, ''''))) = lower(trim('''+fromQuery.FieldByName('Col3').AsString+''')) ';
          upWhere:=upWhere + ' and lower(trim(isnull (col4, ''''))) = lower(trim('''+fromQuery.FieldByName('Col4').AsString+''')) ';
          upWhere:=upWhere + ' and lower(trim(isnull (col5, ''''))) = lower(trim('''+fromQuery.FieldByName('Col5').AsString+''')) ';
          upWhere:=upWhere + ' and lower(trim(isnull (col6, ''''))) = lower(trim('''+fromQuery.FieldByName('Col6').AsString+''')) ';
            fExecSqFromQuery(
            upWhere
            );

          end;

          // ����� ���������� ParentId2 ��� ������� �������
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;

        end;
        myDisabledCB(cbGoods2);
         Gauge.Visible:=False;
     end;

 lInsertGoods2.Caption:= 'TRUE';

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKGuideButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if cbCreateId_Postgres.Checked
     then begin if MessageDlg('������������� Create �����������.Sybase.����.Id_Postgres ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                pCreateGuide_Id_Postgres;
          end;
     if cbNullId_Postgres.Checked
     then begin if MessageDlg('������������� set �����������.Sybase.����.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                pSetNullGuide_Id_Postgres;
          end;
     //
     if MessageDlg('������������� ��������� ��������� �����������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
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


     DataSource.DataSet:=fromQuery;
     CursorGridChange;

     //!!!Integer!!!
     if not fStop then pLoadGuide_Measure;
     if not fStop then pLoadGuide_CompositionGroup;
     if not fStop then pLoadGuide_Composition;
     if not fStop then pLoadGuide_CountryBrand;
     if not fStop then pLoadGuide_Brand;
     if not fStop then pLoadGuide_Fabrika;
     if not fStop then pLoadGuide_LineFabrica;
     if not fStop then pLoadGuide_GoodsInfo;
     if not fStop then pLoadGuide_GoodsSize;
     if not fStop then pLoadGuide_Valuta;
     if not fStop then
     begin
      pLoadGuide_Unit;
      pLoadGuide_Unit;
     end;
     if not fStop then pLoadGuide_Period;
     if not fStop then
     Begin
      pLoadGuide_GoodsGroup;
      pLoadGuide_GoodsGroup;
     End;
     if not fStop then pLoadGuide_Discount;
     if not fStop then pLoadGuide_DiscountTools;
     if not fStop then pLoadGuide_Partner;
     if not fStop then pLoadGuide_Cash;
     if not fStop then pLoadGuide_Label;
     if not fStop then pLoadGuide_Goods;
     if not fStop then pLoadGuide_GoodsItem;
     if not fStop then pLoadGuide_City;
     if not fStop then pLoadGuide_Juridical;
     if not fStop then pLoadGuide_PriceList;
     if not fStop then pLoadGuide_Member;
     if not fStop then pLoadGuide_User;
     if not fStop then pLoadGuide_Client;
     //
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then DatabaseSybase.Connected:=False;;
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
         if fStop then ShowMessage('����������� �� ���������. Time=('+StrTime+').')
                  else ShowMessage('����������� ���������. Time=('+StrTime+').') ;
//     else OKPOEdit.Text:=OKPOEdit.Text + ' Guide:'+StrTime;
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
     if cbCreateDocId_Postgres.Checked
     then begin if MessageDlg('������������� Create ���������.Sybase.����.Id_Postgres ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                pCreateDocument_Id_Postgres;
          end;
     if cbNullId_Postgres.Checked
     then begin if MessageDlg('������������� set ���������.Sybase.����.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                pSetNullDocument_Id_Postgres;
          end;
     //
     if MessageDlg('������������� ��������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     //
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     if cbNullId_Postgres.Checked  then begin if MessageDlg('������������� set ���������.Sybase.����.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                                 pSetNullDocument_Id_Postgres;
                                           end;
     //
     tmpDate1:=NOw;

     DataSource.DataSet:=fromQuery;
     CursorGridChange;

     if not fStop then myRecordCount1:=pLoadDocument_Income;
     if not fStop then pLoadDocumentItem_Income(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnOut;
     if not fStop then pLoadDocumentItem_ReturnOut(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_Send;
     if not fStop then pLoadDocumentItem_Send(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_Loss;
     if not fStop then pLoadDocumentItem_Loss(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_Inventory;
     if not fStop then pLoadDocumentItem_Inventory(myRecordCount1);
     if not fStop then pLoadDocuments_PriceListItem;
     if not fStop then pLoadDocuments_DiscountPeriodItem;
     if not fStop then myRecordCount1:=pLoadDocument_Sale;
     if not fStop then pLoadDocumentItem_Sale(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_ReturnIn;
     if not fStop then pLoadDocumentItem_ReturnIn(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_Sale_Child;
     if not fStop then myRecordCount1:=pLoadDocument_ReturnIn_Child;
     if not fStop then myRecordCount1:=pLoadDocument_GoodsAccount;
     if not fStop then pLoadDocumentItem_GoodsAccount(myRecordCount1);
     if not fStop then myRecordCount1:=pLoadDocument_GoodsAccount_Child;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then DatabaseSybase.Connected:=False;;
     //
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;

     if fStop then ShowMessage('��������� �� ���������. Time=('+StrTime+').')
     else
         if System.Pos('auto',ParamStr(2))<=0
         then ShowMessage('��������� ���������. Time=('+StrTime+').') ;
//         else OKPOEdit.Text:=OKPOEdit.Text + ' Doc:'+StrTime;
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKCompleteDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if (cbComplete.Checked)and(cbUnComplete.Checked)
     then if MessageDlg('������������� �����������/�������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
     else
         if cbUnComplete.Checked
         then if MessageDlg('������������� ������ ����������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
         else
             if cbComplete.Checked then if MessageDlg('������������� ������ �������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
             else begin ShowMessage('������.�� ������� ����������� ��� �������� ��� ����������.'); end;
     //
     DataSource.DataSet:=fromQuery;
     CursorGridChange;
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
     //
     pCompleteDocumentAll(StrToDate(StartDateCompleteEdit.Text),StrToDate(EndDateCompleteEdit.Text));
     //
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then DatabaseSybase.Connected:=false;
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
     if fStop then ShowMessage('��������� �� ������������ �(���) �� ���������. Time=('+StrTime+').')
     else ShowMessage('��������� ������������ �(���) ���������. Time=('+StrTime+').');
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocumentAll(StartDate,EndDate:TDateTime);
begin
     StartDateCompleteEdit.Text:=DateToStr(StartDate);
     EndDateCompleteEdit.Text:=DateToStr(EndDate);

     if not fStop then pCompleteDocument_Income;
     if not fStop then pCompleteDocument_ReturnOut;

     if not fStop then pCompleteDocument_Send;
     if not fStop then pCompleteDocument_Loss;
     if not fStop then pCompleteDocument_Inventory;

     if not fStop then pCompleteDocument_Sale;
     if not fStop then pCompleteDocument_ReturnIn;
     if not fStop then pCompleteDocument_Account;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Income;
begin
     if (not cbCompleteIncome.Checked)or(not cbCompleteIncome.Enabled) then exit;
     //
     myEnabledCB(cbCompleteIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeFromClientToUnit()'
           +'  and Id_Postgres >0'
           );
        Add('order by OperDate,ObjectId');
        Open;

        cbCompleteIncome.Caption:='1.1. ('+IntToStr(RecordCount)+') ������ �� ����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement_Income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Income';
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
             if (cbComplete.Checked) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
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
procedure TMainForm.pCompleteDocument_ReturnOut;
begin
     if (not cbCompleteReturnOut.Checked)or(not cbCompleteReturnOut.Enabled) then exit;
     //
     myEnabledCB(cbCompleteReturnOut);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind = zc_bkReturnFromUnitToClient()'
           +'  and Id_Postgres > 0'
           );
        Add('order by OperDate,ObjectId');
        Open;

        cbCompleteReturnOut.Caption:='1.2. ('+IntToStr(RecordCount)+') ������� ����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement_ReturnOut';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_ReturnOut';
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
             if (cbComplete.Checked) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
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
procedure TMainForm.pCompleteDocument_Send;
begin
     if (not cbCompleteSend.Checked)or(not cbCompleteSend.Enabled) then exit;
     //
     myEnabledCB(cbCompleteSend);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillDate as OperDate');
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind = zc_bkSendFromUnitToUnit()'
           +'  and Id_Postgres > 0'
           );
        Add('order by OperDate,ObjectId');
        Open;

        cbCompleteSend.Caption:='1.3. ('+IntToStr(RecordCount)+') �����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement_Send';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpComplete_Movement_Send';
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
             if (cbComplete.Checked) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
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
     myDisabledCB(cbCompleteSend);
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
        Add('     , cast (Bill.BillNumber as integer) as InvNumber');
        Add('     , UnitFrom.UnitName, UnitTo.UnitName');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromID');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToID');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
           +'  and Bill.BillKind = zc_bkOutFromUnitToBrak()'
           +'  and Id_Postgres > 0'
           );
        Add('order by OperDate,ObjectId');
        Open;

        cbCompleteLoss.Caption:='1.4. ('+IntToStr(RecordCount)+') ��������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpUnComplete_Movement_Loss';
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
             if (cbComplete.Checked) then
             begin
                  toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('Id_Postgres').AsInteger;
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
     myDisabledCB(cbCompleteLoss);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Inventory;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Sale;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Account;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCreateGuide_Id_Postgres;
begin
     if cbCreateId_Postgres.Checked then
     begin
        // 1.1. ��.���.
        try fExecSqFromQuery_noErr('alter table dba.Measure add Id_Postgres integer null;'); except end;
        // 1.2. ������ ��� ������� ������
        try fExecSqFromQuery_noErr('alter table dba.CompositionGroup add Id_Postgres integer null;'); except end;
        // 1.3. ������ ������
        try fExecSqFromQuery_noErr('alter table dba.Composition add Id_Postgres integer null;'); except end;
        // 1.4. ������ �������������
        try fExecSqFromQuery_noErr('alter table dba.CountryBrand add Id_Postgres integer null;'); except end;
        // 1.5. �������� �����
        try fExecSqFromQuery_noErr('alter table dba.Brand add Id_Postgres integer null;'); except end;
        // 1.6. ������� �������������
        try fExecSqFromQuery_noErr('alter table dba.Fabrika add Id_Postgres integer null;'); except end;
        // 1.7. ����� ���������
        try fExecSqFromQuery_noErr('alter table dba.LineFabrica add Id_Postgres integer null;'); except end;
        // 1.8. �������� ������
        try fExecSqFromQuery_noErr('alter table dba.GoodsInfo add Id_Postgres integer null;'); except end;
        // 1.9. ������ ������
        try fExecSqFromQuery_noErr('alter table dba.GoodsSize add Id_Postgres integer null;'); except end;
        // 1.10. ������
        try fExecSqFromQuery_noErr('alter table dba.Valuta add Id_Postgres integer null;'); except end;
        // 1.11. �������������
        try fExecSqFromQuery_noErr('alter table dba.Unit add Id_Postgres integer null;'); except end;
        // 1.12. ������
        try fExecSqFromQuery_noErr('alter table dba.Period add Id_Postgres integer null;'); except end;
        // 1.13. ������ �������
        try fExecSqFromQuery_noErr('alter table dba.Goods add Id_Postgres integer null;'); except end;
        // 1.14. �������� ������������� ������
        try fExecSqFromQuery_noErr('alter table dba.Discount add Id_Postgres integer null;'); except end;
        // 1.15. ��������� ��������� �� ������������� �������
        try fExecSqFromQuery_noErr('alter table dba.DiscountTools add Id_Postgres integer null;'); except end;
        // 1.16. ��c�������
//        try fExecSqFromQuery_noErr('alter table dba.Unit add Id_Postgres integer null;'); except end;
        // 1.17. �����
        try fExecSqFromQuery_noErr('alter table dba.KassaProperty add Id_Postgres integer null;'); except end;
        // 1.18. �������� ��� �������
//        try fExecSqFromQuery_noErr('alter table dba.GoodsProperty add Id_pg_label integer null;'); except end;
        // 1.19. ������
        try fExecSqFromQuery_noErr('alter table dba.GoodsProperty add Id_Pg_goods integer null;'); except end;
        // 1.20. ������ c ���������
        try fExecSqFromQuery_noErr('alter table dba.GoodsProperty add Id_Pg_goodsItem integer null;'); except end;
        // 1.21. �����
//       no
        // 1.22. ����������� ����
        try fExecSqFromQuery_noErr('alter table dba.Firma add Id_Postgres integer null;'); except end;
        // 1.23. ����� �����
        try fExecSqFromQuery_noErr('alter table dba.PriceList add Id_Postgres integer null;'); except end;
        // 1.24. ���������� ����
        try fExecSqFromQuery_noErr('alter table dba.Users add MemberId_Postgres integer null;'); except end;
        // 1.25. ������������
        try fExecSqFromQuery_noErr('alter table dba.Users add UserId_Postgres integer null;'); except end;
        // 1.26. ����������
//        try fExecSqFromQuery_noErr('alter table dba.Unit add Id_Postgres integer null;'); except end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCreateDocument_Id_Postgres;
begin
     if cbCreateDocId_Postgres.Checked then
     begin
      // 1.1. ������
        try fExecSqFromQuery_noErr('alter table dba.Bill add Id_Postgres integer null;'); except end;
        try fExecSqFromQuery_noErr('alter table dba.BillItemsIncome add Id_Postgres integer null;'); except end;
        try fExecSqFromQuery_noErr('alter table dba.BillItemsIncome add GoodsId_Postgres integer null;'); except end;
      // 1.2. ������� ����������
        try fExecSqFromQuery_noErr('alter table dba.BillItems add ReturnOutId_Postgres integer null;'); except end;
      // 1.3. �����������
        try fExecSqFromQuery_noErr('alter table dba.BillItems add SendId_Postgres integer null;'); except end;
      // 1.4. ��������
        try fExecSqFromQuery_noErr('alter table dba.BillItems add LossId_Postgres integer null;'); except end;
      // 1.5. ��������������
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovementInventory add Id_Postgres integer null;'); except end;
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovementItemInventory_byBarCode add Id_Postgres integer null;'); except end;
      // 1.6. ������� ����
        try fExecSqFromQuery_noErr('alter table dba.PriceListItems add Id_Postgres integer null;'); except end;
      // 1.7. ������� ������
        try fExecSqFromQuery_noErr('alter table dba.DiscountTaxItems add Id_Postgres integer null;'); except end;
      // 1.8. ������� ����������
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovement add SaleId_Postgres integer null;'); except end;
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovementItem_byBarCode add Id_Postgres integer null;'); except end;
      // 1.9. ������� �� ����������
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovement add ReturnInId_Postgres integer null;'); except end;
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovementItemReturn_byBarCode add Id_Postgres integer null;'); except end;
      // 1.10. ������ ����������
      //
      // 1.11. ������� ������ ����������
      //
      // 1.12. ������ ���������� GoodsAccount
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovement add GoodsAccountId_Postgres integer null;'); except end;
        try fExecSqFromQuery_noErr('alter table dba.DiscountMovementItem_byBarCode add GoodsAccountId_Postgres integer null;'); except end;

     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
      // 1.1.
      fExecSqFromQuery('update dba.Measure set Id_Postgres = null where Id_Postgres is not null');
      // 1.2.
      fExecSqFromQuery('update dba.CompositionGroup set Id_Postgres = null where Id_Postgres is not null');
      // 1.3.
      fExecSqFromQuery('update dba.Composition set Id_Postgres = null where Id_Postgres is not null');
      // 1.4.
      fExecSqFromQuery('update dba.CountryBrand set Id_Postgres = null where Id_Postgres is not null');
      // 1.5.
      fExecSqFromQuery('update dba.Brand set Id_Postgres = null where Id_Postgres is not null');
      // 1.6.
      fExecSqFromQuery('update dba.Fabrika set Id_Postgres = null where Id_Postgres is not null');
      // 1.7.
      fExecSqFromQuery('update dba.LineFabrica set Id_Postgres = null where Id_Postgres is not null');
      // 1.8.
      fExecSqFromQuery('update dba.GoodsInfo set Id_Postgres = null where Id_Postgres is not null');
      // 1.9.
      fExecSqFromQuery('update dba.GoodsSize set Id_Postgres = null where Id_Postgres is not null');
      // 1.10.
      fExecSqFromQuery('update dba.Valuta set Id_Postgres = null where Id_Postgres is not null');

      // 1.11. �������������
      fExecSqFromQuery('update dba.Unit set Id_Postgres = null where Id_Postgres is not null');

      // 1.12.
      fExecSqFromQuery('update dba.Period set Id_Postgres = null where Id_Postgres is not null');

      // 1.13. ������ �������
      fExecSqFromQuery('update dba.Goods set Id_Postgres = null where Id_Postgres is not null');

      // 1.14.
      fExecSqFromQuery('update dba.Discount set Id_Postgres = null where Id_Postgres is not null');
      // 1.15.
      fExecSqFromQuery('update dba.DiscountTools set Id_Postgres = null where Id_Postgres is not null');

      // 1.16. ��c������� = 1.11.
      // fExecSqFromQuery('update dba.Unit set Id_Postgres = null where Id_Postgres is not null');

      // 1.17.
      fExecSqFromQuery('update dba.KassaProperty set Id_Postgres = null where Id_Postgres is not null');

      // 1.18. �������� ��� �������
      fExecSqFromQuery('update dba.GoodsProperty set Id_pg_label = null where Id_pg_label is not null');
      // 1.19. ������
      fExecSqFromQuery('update dba.GoodsProperty set Id_Pg_Goods = null where Id_Pg_Goods is not null');
      // 1.20. ������ c ���������
      fExecSqFromQuery('update dba.GoodsProperty set Id_Pg_GoodsItem = null where Id_Pg_GoodsItem is not null');

      // 1.21. ����� - ???
      //fExecSqFromQuery('select distinct city from DiscountKlient where city <> '''');

      // 1.22. ����������� ����
      fExecSqFromQuery('update dba.Firma set Id_Postgres = null where Id_Postgres is not null');
      //
      // 1.23. ����� �����
      fExecSqFromQuery('update dba.PriceList set Id_Postgres = null where Id_Postgres is not null');

      // 1.24. ���������� ����
      fExecSqFromQuery('update dba.Users set MemberId_Postgres = null where MemberId_Postgres is not null');
      // 1.25.  ������������
      fExecSqFromQuery('update dba.Users set UserId_Postgres = null where UserId_Postgres is not null');

      // 1.26. ���������� = 1.11.
      // fExecSqFromQuery('update dba.Unit set Id_Postgres = null where Id_Postgres is not null');

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullDocument_Id_Postgres;
begin
      // 1.1. ������
        try fExecSqFromQuery('update dba.Bill set Id_Postgres = null where Id_Postgres is not null'); except end;
        try fExecSqFromQuery('update dba.BillItemsIncome set Id_Postgres = null where Id_Postgres is not null'); except end;
        try fExecSqFromQuery('update dba.BillItemsIncome set GoodsId_Postgres = null where GoodsId_Postgres is not null'); except end;
      // 1.2. ������� ����������
        try fExecSqFromQuery('update dba.BillItems set ReturnOutId_Postgres = null where ReturnOutId_Postgres is not null'); except end;
      // 1.3. �����������
        try fExecSqFromQuery('update dba.BillItems set SendId_Postgres = null where SendId_Postgres is not null'); except end;
      // 1.3. ��������
        try fExecSqFromQuery('update dba.BillItems set LossId_Postgres = null where LossId_Postgres is not null'); except end;
      // 1.4. ��������������
        try fExecSqFromQuery('update dba.DiscountMovementInventory set Id_Postgres = null where Id_Postgres is not null'); except end;
        try fExecSqFromQuery('update dba.DiscountMovementItemInventory_byBarCode set Id_Postgres = null where Id_Postgres is not null'); except end;
      // 1.5. ������� ����
        try fExecSqFromQuery('update dba.PriceListItems set Id_Postgres = null where Id_Postgres is not null'); except end;
      // 1.6. ������� ������
        try fExecSqFromQuery('update dba.DiscountTaxItems set Id_Postgres = null where Id_Postgres is not null'); except end;
      // 1.8. ������� ����������
        try fExecSqFromQuery('update dba.DiscountMovement set SaleId_Postgres = null where SaleId_Postgres is not null'); except end;
        try fExecSqFromQuery('update dba.DiscountMovementItem_byBarCode set Id_Postgres = null where Id_Postgres is not null'); except end;
      // 1.9. ������� �� ����������
        try fExecSqFromQuery('update dba.DiscountMovement set ReturnInId_Postgres = null where ReturnInId_Postgres is not null'); except end;
        try fExecSqFromQuery('update dba.DiscountMovementItemReturn_byBarCode set Id_Postgres = null where Id_Postgres is not null'); except end;
      // 1.10. ������ ����������
      //
      // 1.11. ������� ������ ����������
      //
      // 1.12. ������ �����������
        try fExecSqFromQuery('update dba.DiscountMovement set GoodsAccountId_Postgres = null where GoodsAccountId_Postgres is not null'); except end;
        try fExecSqFromQuery('update dba.DiscountMovementItem_byBarCode set GoodsAccountId_Postgres = null where GoodsAccountId_Postgres is not null'); except end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_GoodsAccount(SaveCount: Integer);
begin
     if (not cbGoodsAccount.Checked)or(not cbGoodsAccount.Enabled) then exit;
     //
     myEnabledCB(cbGoodsAccount);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' SELECT  distinct');
        Add('      DiscountMovementItem_byBarCode.Id as ObjectId');
        Add('    , DiscountMovement.GoodsAccountId_Postgres as MovementId');
        Add('    , BillItemsIncome.GoodsId_Postgres as GoodsId');
        Add('    , BillItemsIncome.Id_Postgres as PartionId');
        Add('    , DiscountMovementItem_byBarCode.Id_Postgres as   PartionMI_Id');
        Add('    , DiscountMovementItem_byBarCode.Id_Postgres as SaleMI_Id');
        Add('    , if  DiscountKlientAccountMoney.Summa<>0 then 1 else 0 endif isPay ');
        Add('    , DiscountMovementItem_byBarCode.OperCount as Amount');
        Add('    , DiscountMovementItem_byBarCode.SummDiscountManual as SummChangePercent');
        Add('    , DiscountMovementItem_byBarCode.BarCode_byClient as BarCode');
        Add('    , DiscountMovementItem_byBarCode.GoodsAccountId_Postgres');
        Add(' FROM dba.DiscountMovementItem_byBarCode');
        Add('    join DiscountMovement     on DiscountMovement.id = DiscountMovementItem_byBarCode.DiscountMovementId');
        Add('    left outer join BillItemsIncome on BillItemsIncome.id  = DiscountMovementItem_byBarCode.BillItemsIncomeId');
        Add('    join DiscountKlientAccountMoney  on DiscountKlientAccountMoney.DiscountMovementItemId = DiscountMovementItem_byBarCode.Id ');
        Add('                                and isCurrent = 1 and discountMovementItemReturnId  is null');
        Add('     left outer join DBA.Unit as DiscountMovement_From on DiscountMovement_From.Id = DiscountMovement.UnitID');
        Add('    left outer join DBA.DiscountKlient as DiscountKlient on DiscountKlient.Id = DiscountMovement.DiscountKlientID');
        Add('    left outer join DBA.Unit as DiscountMovement_To on DiscountKlient.ClientId = DiscountMovement_To.id');
        Add(' WHERE DiscountMovement.descId = 1  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' ORDER BY ObjectId ');
        Open;

        cbGoodsAccount.Caption:='1.12. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') ������� �����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_GoodsAccount';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;

        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionMI_Id',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inSaleMI_Id',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inisPay',ftBoolean,ptInput, False);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inSummChangePercent',ftFloat,ptInput, 0);

        //

        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;

              //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('GoodsAccountId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionMI_Id').Value:=FieldByName('PartionMI_Id').AsInteger;
             toStoredProc.Params.ParamByName('inSaleMI_Id').Value:=FieldByName('SaleMI_Id').AsInteger;
             toStoredProc.Params.ParamByName('inisPay').Value:=Boolean(FieldByName('isPay').AsInteger);
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inSummChangePercent').Value:=FieldByName('SummChangePercent').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('GoodsAccountId_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.DiscountMovementItem_byBarCode set GoodsAccountId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbGoodsAccount);

end;

procedure TMainForm.pLoadDocumentItem_Income(SaveCount: Integer);
var GroupId_BII_Dolg : Integer;
begin
     if (not cbIncome.Checked)or(not cbIncome.Enabled) then exit;
     //
     myEnabledCB(cbIncome);
     //
     // ������ ��� �������� zc_BII_Dolg - "�����" ������
     fOpenSqToQuery_two(' select min (Id) AS Id_find'
                       +' from Object'
                       +' where DescId = zc_Object_GoodsGroup()');
     GroupId_BII_Dolg:=toSqlQuery_two.FieldByName('Id_find').Value;
     //
     //������� �������, �.�. ��������� �� �����
     try fExecSqFromQuery_noErr('create table dba._TableLoadPG4 (goodsid integer primary key'
          +'                                                   , LabelName TVarCharLong)');
     except end;
     fExecSqFromQuery('delete from dba._TableLoadPG4');
     fExecSqFromQuery('insert into dba._TableLoadPG4 (goodsid, LabelName)'
                     +'  select DISTINCT GoodsProperty.goodsId'
                     +'       , goods_group.goodsName AS LabelName '
                     +'  from GoodsProperty '
                     +'       join goods on goods.Id = GoodsProperty.goodsId '
                     +'       join goods as goods_group on goods_group.Id = goods.ParentId');
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select BillItemsIncome.Id as ObjectId');
        Add('     , BillItemsIncome.Id_Postgres as Id_Postgres');
        Add('     , Bill.Id_Postgres as MovementId_pg');

        // !!!��������� ������ �� ���������, �� ����� ������
        Add('     , case when BillItemsIncome.Id = zc_BII_Dolg()');
        Add('                 then ' + IntToStr(GroupId_BII_Dolg));
        Add('            when coalesce (Goods.ParentId, 0) = 500000');
        Add('              or coalesce (GoodsGroup1.ParentId, 0) = 500000');
        Add('              or coalesce (GoodsGroup2.ParentId, 0) = 500000');
        Add('                 then GoodsGroup1.Id_Postgres');
        Add('            else GoodsGroup2.Id_Postgres');
        Add('       end as GoodsGroupId_pg');


        Add('     , -1 * GoodsProperty.CashCode       as GoodsCode');
        Add('     , TRIM(Goods.GoodsName)             as GoodsName ');
        Add('     , TRIM(GoodsInfo.GoodsInfoName)     as GoodsInfoName ');
        Add('     , TRIM(GoodsSize.GoodsSizeName)     as GoodsSizeName ');
        Add('     , TRIM(Composition.CompositionName) as CompositionName ');
        Add('     , TRIM(LineFabrica.LineFabricaName) as LineFabricaName ');
        Add('     , TRIM(Label.LabelName)             as LabelName ');
        Add('     , BillItemsIncome.OperCount as Amount  ');
        Add('     , BillItemsIncome.OperPrice as OperPrice  ');
        Add('     , 1 as CountForPrice  ');
        Add('     , BillItemsIncome.PriceListPrice as OperPriceList');
        Add('     , Firma.Id_Postgres as JuridicalId_pg');
        Add('     , Measure.Id_Postgres as MeasureId_pg');
        Add('     , BillItemsIncome.Id as SybaseId'); // !!!���� ��������� ���� ����
        Add(' from dba.Bill');
        Add('     join dba.BillItemsIncome on BillItemsIncome.BillID = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItemsIncome.GoodsPropertyId  ');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId  ');
        Add('     left outer join dba.Measure on Measure.Id = GoodsProperty.MeasureId  ');
        Add('     left outer join DBA.GoodsInfo  on GoodsInfo.Id = GoodsProperty.GoodsInfoId ');
        Add('     left outer join DBA.GoodsSize on  GoodsSize.Id = GoodsProperty.GoodsSizeId ');
        Add('     left outer join DBA.Composition on Composition.Id = GoodsProperty.CompositionId ');
        Add('     left outer join DBA.LineFabrica on LineFabrica.Id = GoodsProperty.LineFabricaId ');
        Add('     left outer join _TableLoadPG4 as Label on label.goodsId = GoodsProperty.goodsId ');
        Add('      left outer join  dba.Firma as Firma on  Firma.id = BillItemsIncome.FirmaId ');
        //    !!!��������� ������ �� ���������, �� ����� ������
        Add('      left outer join  dba.Goods as GoodsGroup1 on  GoodsGroup1.id = Goods.ParentId ');
        Add('      left outer join  dba.Goods as GoodsGroup2 on  GoodsGroup2.id = GoodsGroup1.ParentId ');

        Add(' where Bill.BillKind = zc_bkIncomeFromClientToUnit() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        //??? Add('  and GoodsGroupId is not null '); // ��� ����� ��� GoodsGroupId
        if cbTest.Checked then Add(' and BillItemsIncome.Id = ' + TestEdit.Text);
        Add(' order by Bill.BillDate, Bill.Id, Goods.Id, GoodsSize.GoodsSizeName, BillItemsIncome.Id');
        Open;

        cbIncome.Caption:='1.1. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') ������ �� ����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MIEdit_Income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inMeasureId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('ioGoodsCode',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inGoodsName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsInfoName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsSizeName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCompositionName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inLineFabricaName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inLabelName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCountForPrice',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperPriceList',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsGroupId').Value:=FieldByName('GoodsGroupId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inMeasureId').Value:=FieldByName('MeasureId_pg').AsInteger;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('JuridicalId_pg').AsInteger;
             toStoredProc.Params.ParamByName('ioGoodsCode').Value:=FieldByName('GoodsCode').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsName').Value:=FieldByName('GoodsName').AsString;
             toStoredProc.Params.ParamByName('inGoodsInfoName').Value:=FieldByName('GoodsInfoName').AsString;
             toStoredProc.Params.ParamByName('inGoodsSizeName').Value:=FieldByName('GoodsSizeName').AsString;
             toStoredProc.Params.ParamByName('inCompositionName').Value:=FieldByName('CompositionName').AsString;
             toStoredProc.Params.ParamByName('inLineFabricaName').Value:=FieldByName('LineFabricaName').AsString;
             toStoredProc.Params.ParamByName('inLabelName').Value:=FieldByName('LabelName').AsString;

             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inOperPrice').Value:=FieldByName('OperPrice').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inOperPriceList').Value:=FieldByName('OperPriceList').AsFloat;


             if not myExecToStoredProc then ;//exit;
             //
             // !!! ��������� ��� � Postgresql - ���� ���� !!!
             fExecSqToQuery_two ('update Object_PartionGoods set SybaseId = ' + IntToStr(FieldByName('SybaseId').AsInteger)+ ' where MovementItemId = ' + IntToStr(toStoredProc.Params.ParamByName('ioId').Value) + ' and SybaseId is null');
             //
             //
             if (FieldByName('Id_Postgres').AsInteger = 0) and (toStoredProc.Params.ParamByName('ioId').Value <> 0) then
               fExecSqFromQuery('update dba.BillItemsIncome set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
              fOpenSqToQuery_two(' select GoodsID '
                           +' from Object_PartionGoods'
                           +' where MovementItemId='+inttostr(toStoredProc.Params.ParamByName('ioId').Value));
              fExecSqFromQuery('update dba.BillItemsIncome set GoodsId_Postgres='+IntToStr(toSqlQuery_two.FieldByName('GoodsID').Value)+' where Id = '+FieldByName('ObjectId').AsString);

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbIncome);
end;

procedure TMainForm.pLoadDocumentItem_Inventory(SaveCount: Integer);
begin
     if (not cbInventory.Checked)or(not cbInventory.Enabled) then exit;
     //
     myEnabledCB(cbInventory);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ');
        Add('      DiscountMovementItemInventory_byBarCode.Id as ObjectId   ');
        Add('    , DiscountMovementItemInventory_byBarCode.Id_Postgres ');
        Add('    , DiscountMovementInventory.Id_Postgres as MovementId   ');
        Add('    , BillItemsIncome.GoodsId_Postgres as GoodsId  ');
        Add('    , BillItemsIncome.Id_Postgres as PartionId  ');
        Add('    , DiscountMovementItemInventory_byBarCode.EnterOperCount as Amount ');
        Add('    , DiscountMovementItemInventory_byBarCode.EnterOperCount_two as AmountSecond ');
//        Add('    , DiscountMovementItemInventory_byBarCode.CalcOperCount as AmountRemains ');
//        Add('    , DiscountMovementItemInventory_byBarCode.CalcOperCount_two as AmountSecondRemains ');
//        Add('    , DiscountMovementItemInventory_byBarCode.DolgOperCount as AmountDolg ');
        Add('from dba.DiscountMovementItemInventory_byBarCode    ');
        Add('    join DiscountMovementInventory on DiscountMovementInventory.id = DiscountMovementItemInventory_byBarCode.DiscountMovementId ');
        Add('    left outer join BillItemsIncome on BillItemsIncome.id = DiscountMovementItemInventory_byBarCode.BillItemsIncomeId ');
        Add('where  DiscountMovementInventory.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('order by OperDate, ObjectId  ');
        Open;

        cbInventory.Caption:='1.5. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') �������������� ';
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
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountSecond',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountSecond').Value:=FieldByName('AmountSecond').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.DiscountMovementItemInventory_byBarCode set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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

procedure TMainForm.pLoadDocumentItem_Loss(SaveCount: Integer);
begin
     if (not cbLoss.Checked)or(not cbLoss.Enabled) then exit;
     //
     myEnabledCB(cbLoss);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select BillItems.Id as ObjectId  ');
        Add('     , BillItems.LossId_Postgres as Id_Postgres  ');
        Add('     , Bill.Id_Postgres as MovementId  ');
        Add('     , BillItemsIncome.GoodsId_Postgres as GoodsId  ');
        Add('     , BillItemsIncome.Id_Postgres as PartionId ');
        Add('     , Goods.GoodsName as GoodsName ');
        Add('     , abs(BillItems.OperCount) as Amount  ');
        Add('     , BillItems.OperPrice as OperPrice  ');
        Add('     , 1 as CountForPrice  ');
        Add('     , BillItems.PriceListPrice as OperPriceList  ');
        Add(' from dba.BillItems   ');
        Add('     join dba.Bill on BillItems.BillID = Bill.Id ');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId  ');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId  ');
        Add('     left outer join  DBA.BillItemsIncome on BillItemsIncome.Id = BillItems.BillItemsIncomeID ');
        Add(' where  Bill.BillKind = zc_bkOutFromUnitToBrak() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, Bill.Id ');
        Open;

        cbLoss.Caption:='1.4. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') ��������';
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
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioOperPriceList',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;

              //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioOperPriceList').Value:=FieldByName('OperPriceList').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.BillItems set LossId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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

procedure TMainForm.pLoadDocumentItem_ReturnIn(SaveCount: Integer);
begin
     if (not cbReturnIn.Checked)or(not cbReturnIn.Enabled) then exit;
     //
     myEnabledCB(cbReturnIn);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('SELECT');
        Add('      DiscountMovementItemReturn_byBarCode.Id as ObjectId');
        Add('    , DiscountMovementItemReturn_byBarCode.Id_Postgres');
        Add('    , DiscountMovement.ReturnInId_Postgres as MovementId');
        Add('    , BillItemsIncome.GoodsId_Postgres as GoodsId');
        Add('    , BillItemsIncome.Id_Postgres as PartionId');
        Add('    , DiscountMovementItem_byBarCode.Id_Postgres as SaleMI_Id');
        Add('    , DiscountMovementItemReturn_byBarCode.OperCount as Amount');
        Add('FROM dba.DiscountMovementItemReturn_byBarCode');
        Add('    join DiscountMovement     on DiscountMovement.id = DiscountMovementItemReturn_byBarCode.DiscountMovementId');
        Add('    left outer join BillItemsIncome on BillItemsIncome.id  = DiscountMovementItemReturn_byBarCode.BillItemsIncomeId');
        Add('    left outer join DiscountMovementItem_byBarCode  on DiscountMovementItem_byBarCode.Id = DiscountMovementItemReturn_byBarCode.DiscountMovementItemId ');
        Add('WHERE DiscountMovement.descId = 2  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('ORDER BY OperDate, ObjectId ');
        Open;

        cbReturnIn.Caption:='1.9. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') ������� �� ����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_ReturnIn';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionMI_Id',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inSaleMI_Id',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inisPay',ftBoolean,ptInput, False);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);



        //

        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;

              //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             toStoredProc.Params.ParamByName('inSaleMI_Id').Value:=FieldByName('SaleMI_Id').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.DiscountMovementItemReturn_byBarCode set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbReturnIn);

end;

procedure TMainForm.pLoadDocumentItem_ReturnOut(SaveCount: Integer);
begin
     if (not cbReturnOut.Checked)or(not cbReturnOut.Enabled) then exit;
     //
     myEnabledCB(cbReturnOut);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select BillItems.Id as ObjectId  ');
        Add('     , BillItems.ReturnOutId_Postgres as Id_Postgres  ');
        Add('     , Bill.Id_Postgres as MovementId  ');
        Add('     , BillItemsIncome.GoodsId_Postgres as GoodsId  ');
        Add('     , BillItemsIncome.Id_Postgres as PartionId ');
        Add('     , Goods.GoodsName as GoodsName ');
        Add('     , abs(BillItems.OperCount) as Amount  ');
        Add('     , BillItems.OperPrice as OperPrice  ');
        Add('     , 1 as CountForPrice  ');
        Add('     , BillItems.PriceListPrice as OperPriceList  ');
        Add(' from dba.BillItems   ');
        Add('     join dba.Bill on BillItems.BillID = Bill.Id ');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId  ');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId  ');
        Add('     left outer join  DBA.BillItemsIncome on BillItemsIncome.Id = BillItems.BillItemsIncomeID ');
        Add(' where Bill.BillKind = zc_bkReturnFromUnitToClient() ');
        Add('   and BillItems.PriceListPrice <> 100000 '); // ��� ����� BillItems.PriceListPrice = 100000 - ��� GoodsId
        Add('   and Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, Bill.Id, BillItems.Id ');
        Open;

        cbReturnOut.Caption:='1.2. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') ������� ����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_ReturnOut';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioOperPriceList',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;

              //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioOperPriceList').Value:=FieldByName('OperPriceList').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.BillItems set ReturnOutId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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

procedure TMainForm.pLoadDocumentItem_Sale(SaveCount: Integer);
var zc_Enum_DiscountSaleKind_Period , zc_Enum_DiscountSaleKind_Client, zc_Enum_DiscountSaleKind_Outlet :Integer;
begin
     if (not cbSale.Checked)or(not cbSale.Enabled) then exit;
     //
     fOpenSqToQuery ('select zc_Enum_DiscountSaleKind_Period() AS RetV ');
     zc_Enum_DiscountSaleKind_Period:=toSqlQuery.FieldByName('RetV').AsInteger;
     fOpenSqToQuery ('select zc_Enum_DiscountSaleKind_Client() AS RetV ');
     zc_Enum_DiscountSaleKind_Client:=toSqlQuery.FieldByName('RetV').AsInteger;
     fOpenSqToQuery ('select zc_Enum_DiscountSaleKind_Outlet() AS RetV ');
     zc_Enum_DiscountSaleKind_Outlet:=toSqlQuery.FieldByName('RetV').AsInteger;
     //
     myEnabledCB(cbSale);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('SELECT');
        Add('      Bill.Id as ObjectId');
        Add('    , BillItems.Id_Postgres');
        Add('    , Bill.Id_Postgres as MovementId');
        Add('    , BillItemsIncome.GoodsId_Postgres as GoodsId');
        Add('    , BillItemsIncome.Id_Postgres as PartionId');
        Add('    , -1 * BillItems.OperCount as Amount');
        Add('    , 0 as SummChangePercent');
        Add('    , BillItems.OperPrice as OperPriceList');
        Add('    , 0 as ChangePercent');
        Add('    , '''' as BarCode');
        Add('    , '''' as Comment');
        Add('    , zc_rvYes() as isBill');
        Add('    , zc_rvYes() as isClose');
        Add('from DBA.Bill');
        Add('    join BillItems  on BillItems.BillId = Bill.Id');
        Add('    left outer join BillItemsIncome on BillItemsIncome.id  = BillItems.BillItemsIncomeId');
        Add('where Bill.BillKind = zc_bkSaleFromUnitToClient() and Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('  and Bill.DatabaseId = 0');
        Add('union all');
        Add('SELECT');
        Add('      DiscountMovementItem_byBarCode.Id as ObjectId');
        Add('    , DiscountMovementItem_byBarCode.Id_Postgres');
        Add('    , DiscountMovement.SaleId_Postgres as MovementId');
        Add('    , BillItemsIncome.GoodsId_Postgres as GoodsId');
        Add('    , BillItemsIncome.Id_Postgres as PartionId');
        Add('    , DiscountMovementItem_byBarCode.OperCount as Amount');
        Add('    , DiscountMovementItem_byBarCode.SummDiscountManual as SummChangePercent');
        Add('    , DiscountMovementItem_byBarCode.OperPrice as OperPriceList');
        Add('    , DiscountMovementItem_byBarCode.DiscountTax AS ChangePercent');
        Add('    , DiscountMovementItem_byBarCode.BarCode_byClient as BarCode');
        Add('    , DiscountMovementItem_byBarCode.CommentInfo as Comment');
        Add('    , zc_rvNo() as isBill');
        Add('    , case when DiscountMovementItem_byBarCode_all.BillItemsId > 0 then zc_rvYes() else zc_rvNo() end  as isClose');
        Add('FROM dba.DiscountMovementItem_byBarCode');
        Add('    join DiscountMovement     on DiscountMovement.id = DiscountMovementItem_byBarCode.DiscountMovementId');
        Add('    left outer join BillItemsIncome on BillItemsIncome.id  = DiscountMovementItem_byBarCode.BillItemsIncomeId');
        Add('    left outer join _data_all on _data_all.DatabaseId  = DiscountMovementItem_byBarCode.DatabaseId');
        Add('                             and _data_all.ReplId      = DiscountMovementItem_byBarCode.ReplId');
        Add('WHERE DiscountMovement.descId = 1  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('ORDER BY DiscountMovement.OperDate, ObjectId ');
        Open;

        cbSale.Caption:='1.8. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') ������� ����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Sale';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inisPay',ftBoolean,ptInput, False);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inSummChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioOperPriceList',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioChangePercent',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inBarCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;

              //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             if FieldByName('isBill').AsInteger = zc_rvYes
             then toStoredProc.Params.ParamByName('inIsPay').Value:= TRUE
             else toStoredProc.Params.ParamByName('inIsPay').Value:= FALSE;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inSummChangePercent').Value:=FieldByName('SummChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('ioOperPriceList').Value:=FieldByName('OperPriceList').AsFloat;
             toStoredProc.Params.ParamByName('ioChangePercent').Value:=FieldByName('ChangePercent').AsFloat;
             toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('Comment').AsString;


             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0) and(FieldByName('isBill').AsInteger=zc_rvNo) then
                fExecSqFromQuery('update dba.BillItems set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString)
             else
                 if (FieldByName('Id_Postgres').AsInteger=0) and(FieldByName('isBill').AsInteger=zc_rvYes) then
                   fExecSqFromQuery('update dba.DiscountMovementItem_byBarCode set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbSale);

end;

procedure TMainForm.pLoadDocumentItem_Send(SaveCount: Integer);
begin
      if (not cbSend.Checked)or(not cbSend.Enabled) then exit;
     //
     myEnabledCB(cbSend);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select BillItems.Id as ObjectId  ');
        Add('     , BillItems.SendId_Postgres as Id_Postgres  ');
        Add('     , Bill.Id_Postgres as MovementId  ');
        Add('     , BillItemsIncome.GoodsId_Postgres as GoodsId  ');
        Add('     , BillItemsIncome.Id_Postgres as PartionId ');
        Add('     , Goods.GoodsName as GoodsName ');
        Add('     , abs(BillItems.OperCount) as Amount  ');
        Add('     , BillItems.OperPrice as OperPrice  ');
        Add('     , BillItems.PriceListPrice as OperPriceList  ');
        Add(' from dba.BillItems   ');
        Add('     join dba.Bill on BillItems.BillID = Bill.Id ');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId  ');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId  ');
        Add('     left outer join DBA.BillItemsIncome on BillItemsIncome.Id = BillItems.BillItemsIncomeID ');
        Add(' where  Bill.BillKind = zc_bkSendFromUnitToUnit() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, Bill.Id, BillItems.Id ');
        Open;
        Open;

        cbSend.Caption:='1.3. ('+IntToStr(SaveCount)+')('+IntToStr(RecordCount)+') �����������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MovementItem_Send';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('ioOperPriceList',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit; end;

              //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inPartionId').Value:=FieldByName('PartionId').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('ioOperPriceList').Value:=FieldByName('OperPriceList').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.BillItems set SendId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbSend);
end;



function TMainForm.pLoadDocument_GoodsAccount: Integer;
begin
     Result:=0;
     //
     if (not cbGoodsAccount.Checked)or(not cbGoodsAccount.Enabled) then exit;
     //
     myEnabledCB(cbGoodsAccount);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' SELECT distinct');
        Add('      DiscountMovement.Id as ObjectId');
        Add('    , 0 as InvNumber');
        Add('    , date(DiscountMovement.OperDate) as OperDate   // �� �������� ������ �������� ������ ����');
        Add('    , DiscountMovement_From.Id_Postgres as FromId ');
        Add('    , DiscountMovement_From.UnitName as UnitNameFrom');
        Add('    , DiscountMovement_To.Id_Postgres as ToId');
        Add('    , DiscountMovement_To.UnitName as UnitNameTo');
        Add('    , DiscountMovement.GoodsAccountId_Postgres ');
        Add(' FROM dba.DiscountMovementItem_byBarCode');
        Add('    join DiscountMovement     on DiscountMovement.id = DiscountMovementItem_byBarCode.DiscountMovementId');
        Add('    left outer join BillItemsIncome on BillItemsIncome.id  = DiscountMovementItem_byBarCode.BillItemsIncomeId');
        Add('    join DiscountKlientAccountMoney  on DiscountKlientAccountMoney.DiscountMovementItemId = DiscountMovementItem_byBarCode.Id ');
        Add('                                and isCurrent = 1 and discountMovementItemReturnId  is null');
        Add('     left outer join DBA.Unit as DiscountMovement_From on DiscountMovement_From.Id = DiscountMovement.UnitID');
        Add('    left outer join DBA.DiscountKlient as DiscountKlient on DiscountKlient.Id = DiscountMovement.DiscountKlientID');
        Add('    left outer join DBA.Unit as DiscountMovement_To on DiscountKlient.ClientId = DiscountMovement_To.id');
        Add(' WHERE DiscountMovement.descId = 1  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' ORDER BY ObjectId ');
        Open;

        Result:=RecordCount;
        cbGoodsAccount.Caption:='1.12. ('+IntToStr(RecordCount)+') ������� �����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not  cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_GoodsAccount';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInput, '');  // ������ ptInputOutput ������ ptInput
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('GoodsAccountId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('ToId').AsInteger;   // inFromId= ToId - �� ������

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('GoodsAccountId_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.DiscountMovement set GoodsAccountId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbGoodsAccount);

end;

function TMainForm.pLoadDocument_GoodsAccount_Child: Integer;
begin
     Result:=0;
     //
     if (not cbGoodsAccount.Checked)or(not cbGoodsAccount.Enabled) then exit;
     //
     myEnabledCB(cbGoodsAccount);
     //
     try fExecSqFromQuery_noErr(' drop table dba._TableLoadGoodsAccount '); except end;  // ���������� ����� ������� �������������. // ����� ���� ���� ������� ������ ������� ����� ����
      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr(' create table dba._TableLoadGoodsAccount ( ObjectId integer, MovementId integer, ParentId integer, KassaID integer, ' + ' AmountGRN decimal, AmountEUR decimal, AmountUSD decimal, AmountCard decimal, AmountDiscount decimal,  CurrencyValueUSD decimal, ParValueUSD decimal, CurrencyValueEUR decimal,  ParValueEUR decimal )');
      except end;
      fExecSqFromQuery(' delete from dba._TableLoadGoodsAccount');
      fExecSqFromQuery(' insert into dba._TableLoadGoodsAccount (ObjectId, MovementId, ParentId, KassaID, AmountGRN, AmountEUR, AmountUSD, AmountCard, AmountDiscount, CurrencyValueUSD, ParValueUSD, CurrencyValueEUR,  ParValueEUR )'
             + ' SELECT'
             + '      DiscountKlientAccountMoney.Id as ObjectId'
             + '    , DiscountMovement.GoodsAccountId_Postgres as MovementId'
             + '    , DiscountMovementItem_byBarCode.Id_Postgres as ParentId'
             + '    , Kassa.ID as KassaID'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=1 then  DiscountKlientAccountMoney.Summa else 0 endif as AmountGRN'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then  DiscountKlientAccountMoney.Summa else 0 endif as AmountEUR'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then  DiscountKlientAccountMoney.Summa else 0 endif as AmountUSD'
             + '    , if  Kassa.ID in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  ) then  DiscountKlientAccountMoney.Summa else 0 endif as AmountCard'
             + '    , if  Kassa.ID in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  ) then  DiscountKlientAccountMoney.SummDiscountManual else 0 endif as  AmountDiscount'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then DiscountKlientAccountMoney.KursClient else 0 endif as CurrencyValueUSD'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then DiscountKlientAccountMoney.NominalKursClient else 0 endif as ParValueUSD'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then DiscountKlientAccountMoney.KursClient else 0 endif as CurrencyValueEUR'
             + '    , if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then DiscountKlientAccountMoney.NominalKursClient else 0 endif as ParValueEUR'
             + ' FROM dba.DiscountMovementItem_byBarCode'
             + '    join DiscountMovement     on DiscountMovement.id = DiscountMovementItem_byBarCode.DiscountMovementId'
             + '    left outer join BillItemsIncome on BillItemsIncome.id  = DiscountMovementItem_byBarCode.BillItemsIncomeId'
             + '    join DiscountKlientAccountMoney  on DiscountKlientAccountMoney.DiscountMovementItemId = DiscountMovementItem_byBarCode.Id '
             + '                                and isCurrent = 1 and discountMovementItemReturnId  is null'
             + '    join Kassa on Kassa.Id = DiscountKlientAccountMoney.KassaID'
             + '    join KassaProperty  on KassaProperty.KassaID = Kassa.ID'
             + ' WHERE DiscountMovement.descId = 1  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
             + ' ORDER BY ObjectId '
);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('SELECT');
        Add('  min(ObjectId) as ObjectId');
        Add(', a.MovementId');
        Add(', a.ParentId');
        Add(', a.KassaID');
        Add(', sum(AmountGRN) as AmountGRN');
        Add(', sum(AmountEUR) as AmountEUR');
        Add(', sum(AmountUSD) as AmountUSD');
        Add(', sum(AmountCard) as AmountCard');
        Add(', sum(AmountDiscount) as AmountDiscount');
        Add(', min(CurrencyValueUSD) as CurrencyValueUSD');
        Add(', min(ParValueUSD) as ParValueUSD');
        Add(', min(CurrencyValueEUR) as CurrencyValueEUR');
        Add(', min(ParValueEUR) as ParValueEUR');
        Add(' FROM  dba._TableLoadGoodsAccount AS a');
        Add(' GROUP BY MovementId, ParentId, KassaID');
        Open;

        Result:=RecordCount;
        cbGoodsAccount.Caption:= cbGoodsAccount.Caption + ' ('+IntToStr(RecordCount)+')Child';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_GoodsAccount_Child';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        //
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountGRN',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountEUR',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountCard',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountDiscount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyValueUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParValueUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyValueEUR',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParValueEUR',ftFloat,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId').AsInteger;
             toStoredProc.Params.ParamByName('inAmountGRN').Value:=FieldByName('AmountGRN').AsFloat;
             toStoredProc.Params.ParamByName('inAmountUSD').Value:=FieldByName('AmountUSD').AsFloat;
             toStoredProc.Params.ParamByName('inAmountEUR').Value:=FieldByName('AmountEUR').AsFloat;
             toStoredProc.Params.ParamByName('inAmountCard').Value:=FieldByName('AmountCard').AsFloat;
             toStoredProc.Params.ParamByName('inAmountDiscount').Value:=FieldByName('AmountDiscount').AsFloat;
             toStoredProc.Params.ParamByName('inCurrencyValueUSD').Value:=FieldByName('CurrencyValueUSD').AsFloat;
             toStoredProc.Params.ParamByName('inParValueUSD').Value:=FieldByName('ParValueUSD').AsFloat;
             toStoredProc.Params.ParamByName('inCurrencyValueEUR').Value:=FieldByName('CurrencyValueEUR').AsFloat;
             toStoredProc.Params.ParamByName('inParValueEUR').Value:=FieldByName('ParValueEUR').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     try fExecSqFromQuery_noErr(' drop table dba._TableLoadGoodsAccount '); except end;
     //
     myDisabledCB(cbGoodsAccount);
end;

function TMainForm.pLoadDocument_Income: Integer;
begin
     Result:=0;
     //
     if (not cbIncome.Checked)or(not cbIncome.Enabled) then exit;
     //
     myEnabledCB(cbIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select Bill.Id as ObjectId ');
        Add('     , Bill.Id_Postgres ');
        Add('     , Bill.BillNumber as InvNumber ');
        Add('     , Bill.BillDate as OperDate ');
        Add('     , Bill_From.Id_Postgres as FromId  ');
        Add('     , Bill_From.UnitName as UnitNameFrom ');
        Add('     , Bill_To.Id_Postgres as ToId ');
        Add('     , Bill_To.UnitName as UnitNameTo ');
        Add('     , Bill_CurrencyDocument.Id_Postgres as CurrencyDocumentId ');
        Add('     , Bill_CurrencyDocument.ValutaName as  CurrencyDocumentName ');
        Add('     , 0 as CurrencyValue ');
        Add('     , 1 as ParValue ');
        Add('     , 0 as CurrencyPartnerValue ');
        Add('     , 1 as ParPartnerValue ');
        Add('     , '''' as Comments ');
        Add(' from DBA.Bill ');
        Add('     left outer join DBA.Unit as Bill_From on Bill_From.Id = Bill.FromID ');
        Add('     left outer join DBA.Unit as Bill_To on Bill_To.Id = Bill.ToID ');
        Add('     left outer join DBA.Valuta as Bill_CurrencyDocument on Bill_CurrencyDocument.Id = Bill.ValutaIDIn   ');
        Add(' where Bill.BillKind = zc_bkIncomeFromClientToUnit() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, ObjectId ');
        Open;

        Result:=RecordCount;
        cbIncome.Caption:='1.1. ('+IntToStr(RecordCount)+') ������ �� ����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Income';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;
             toStoredProc.Params.ParamByName('inCurrencyDocumentId').Value:=FieldByName('CurrencyDocumentId').AsInteger;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('Comments').AsString;

             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger = 0) and (toStoredProc.Params.ParamByName('ioId').Value <> 0) then
               fExecSqFromQuery('update dba.Bill set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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




function TMainForm.pLoadDocument_Inventory: Integer;
begin
     Result:=0;
     //
     if (not cbInventory.Checked)or(not cbInventory.Enabled) then exit;
     //
     myEnabledCB(cbInventory);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ');
        Add('      DiscountMovementInventory.Id as ObjectId ');
        Add('    , DiscountMovementInventory.Id_Postgres ');
        Add('    , 0 as InvNumber ');
        Add('    , DiscountMovementInventory.OperDate as OperDate ');
        Add('    , DiscountMovementInventory_From.Id_Postgres as FromId  ');
        Add('    , DiscountMovementInventory_From.UnitName as UnitNameFrom ');
        Add('    , DiscountMovementInventory_To.Id_Postgres as ToId ');
        Add('    , DiscountMovementInventory_To.UnitName as UnitNameTo ');
        Add('from DBA.DiscountMovementInventory ');
        Add('    left outer join DBA.Unit as DiscountMovementInventory_From on DiscountMovementInventory_From.Id = DiscountMovementInventory.UnitID ');
        Add('    left outer join DBA.Unit as DiscountMovementInventory_To on DiscountMovementInventory_To.Id = DiscountMovementInventory.UnitID_two ');
        Add('where  DiscountMovementInventory.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('order by OperDate, ObjectId ');
        Open;

        Result:=RecordCount;
        cbInventory.Caption:='1.5. ('+IntToStr(RecordCount)+') ��������������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Inventory';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.DiscountMovementInventory set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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

function TMainForm.pLoadDocument_Loss: Integer;
begin
     Result:=0;
     //
     if (not cbLoss.Checked)or(not cbLoss.Enabled) then exit;
     //
     myEnabledCB(cbLoss);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select Bill.Id as ObjectId ');
        Add('     , Bill.Id_Postgres ');
        Add('     , Bill.BillNumber as InvNumber ');
        Add('     , Bill.BillDate as OperDate ');
        Add('     , Bill_From.Id_Postgres as FromId  ');
        Add('     , Bill_From.UnitName as UnitNameFrom ');
        Add('     , Bill_To.Id_Postgres as ToId ');
        Add('     , Bill_To.UnitName as UnitNameTo ');
        Add('     , '''' as Comments ');
        Add(' from DBA.Bill ');
        Add('     left outer join DBA.Unit as Bill_From on Bill_From.Id = Bill.FromID ');
        Add('     left outer join DBA.Unit as Bill_To on Bill_To.Id = Bill.ToID ');
        //Add('     left outer join (select * from  DBA.ValutaKursItems order by id desc ) as valutaDoc  on Bill.BillDate  between valutaDoc.startDate and valutaDoc.EndDate and valutaDoc.FromValutaID = Bill.ValutaIDIn  and valutaDoc.ToValutaID = Bill.ValutaIDpl ');
        //Add('     left outer join (select * from  DBA.ValutaKursItems order by id desc ) as valutaPar  on Bill.BillDate  between valutaPar.startDate and valutaPar.EndDate and valutaPar.FromValutaID = Bill.ValutaIDIn  and valutaPar.ToValutaID = Bill.ValutaID ');
        Add(' where  Bill.BillKind = zc_bkOutFromUnitToBrak() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, ObjectId ');
        Open;

        Result:=RecordCount;
        cbLoss.Caption:='1.4. ('+IntToStr(RecordCount)+') ��������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Loss';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('Comments').AsString;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.Bill set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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

function TMainForm.pLoadDocument_ReturnIn: Integer;
begin
     Result:=0;
     //
     if (not cbReturnIn.Checked)or(not cbReturnIn.Enabled) then exit;
     //
     myEnabledCB(cbReturnIn);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select');
        Add('      DiscountMovement.Id as ObjectId');
        Add('    , DiscountMovement.ReturnInId_Postgres as Id_Postgres');
        Add('    , 0 as InvNumber');
        Add('    , date(DiscountMovement.OperDate) as OperDate');   // �� ������� ������ �������� ������ ����
        Add('    , DiscountMovement_From.Id_Postgres as FromId ');
        Add('    , DiscountMovement_From.UnitName as UnitNameFrom');
        Add('    , DiscountMovement_To.Id_Postgres as ToId');
        Add('    , DiscountMovement_To.UnitName as UnitNameTo');
        Add('from DBA.DiscountMovement');
        Add('    left outer join DBA.Unit as DiscountMovement_To on DiscountMovement_To.Id = DiscountMovement.UnitID');
        Add('    left outer join DBA.DiscountKlient as DiscountKlient on DiscountKlient.Id = DiscountMovement.DiscountKlientID');
        Add('    left outer join DBA.Unit as DiscountMovement_From on DiscountKlient.ClientId = DiscountMovement_From.id');
        Add('where DiscountMovement.descId = 2  and DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('order by OperDate, ObjectId');
        Open;

        Result:=RecordCount;
        cbReturnIn.Caption:='1.9. ('+IntToStr(RecordCount)+') ������� �� ����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_ReturnIn';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('ReturnInId_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.DiscountMovement set ReturnInId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbReturnIn);

end;

function TMainForm.pLoadDocument_ReturnIn_Child: Integer;
begin
     Result:=0;
     //
     if (not cbReturnIn_Child.Checked)or(not cbReturnIn_Child.Enabled) then exit;
     //
     myEnabledCB(cbReturnIn_Child);
     //
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(   ' SELECT'
             + '      DiscountMovement.OperDate'
             + '    , DiscountMovement.ReturnInId_Postgres as MovementId'
             + '    , DiscountMovementItemReturn_byBarCode.Id_Postgres as ParentId'
             + '    , SUM (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=1 then  Abs(DiscountKlientAccountMoney.Summa) else 0 endif ) as AmountGRN'
             + '    , SUM (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then  Abs(DiscountKlientAccountMoney.Summa) else 0 endif ) as AmountEUR'
             + '    , SUM (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then  Abs(DiscountKlientAccountMoney.Summa) else 0 endif ) as AmountUSD'
             + '    , SUM (if  Kassa.ID in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  ) then  DiscountKlientAccountMoney.Summa else 0 endif ) as AmountCard'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then DiscountKlientAccountMoney.KursClient else 0 endif ) as CurrencyValueUSD'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then DiscountKlientAccountMoney.NominalKursClient else 0 endif ) as ParValueUSD'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then DiscountKlientAccountMoney.KursClient else 0 endif ) as CurrencyValueEUR'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then DiscountKlientAccountMoney.NominalKursClient else 0 endif ) as ParValueEUR'
             + ' FROM dba.DiscountMovementItemReturn_byBarCode'
             + '    join DiscountMovement     on DiscountMovement.id = DiscountMovementItemReturn_byBarCode.DiscountMovementId'
             + '    left outer join BillItemsIncome on BillItemsIncome.id  = DiscountMovementItemReturn_byBarCode.BillItemsIncomeId'
             + '    join DiscountKlientAccountMoney on DiscountKlientAccountMoney.DiscountMovementItemReturnId = DiscountMovementItemReturn_byBarCode.Id '
             + '                                   and isCurrent = zc_rvYes() '
             + '    join Kassa on Kassa.Id = DiscountKlientAccountMoney.KassaID'
             + '    join KassaProperty  on KassaProperty.KassaID = Kassa.ID'
             + ' WHERE DiscountMovement.descId = 2  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
             + ' GROUP BY DiscountMovement.OperDate, MovementId, ParentId'
             + ' ORDER BY DiscountMovement.OperDate');
        Open;

        Result:= RecordCount;
        cbReturnIn_Child.Caption:='1.11. ('+IntToStr(RecordCount)+') ������� ������ ����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_ReturnIn_Child';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        //
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountGRN',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountEUR',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountCard',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyValueUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParValueUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyValueEUR',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParValueEUR',ftFloat,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId').AsInteger;
             toStoredProc.Params.ParamByName('inAmountGRN').Value:=FieldByName('AmountGRN').AsFloat;
             toStoredProc.Params.ParamByName('inAmountUSD').Value:=FieldByName('AmountUSD').AsFloat;
             toStoredProc.Params.ParamByName('inAmountEUR').Value:=FieldByName('AmountEUR').AsFloat;
             toStoredProc.Params.ParamByName('inAmountCard').Value:=FieldByName('AmountCard').AsFloat;
             toStoredProc.Params.ParamByName('inCurrencyValueUSD').Value:=FieldByName('CurrencyValueUSD').AsFloat;
             toStoredProc.Params.ParamByName('inParValueUSD').Value:=FieldByName('ParValueUSD').AsFloat;
             toStoredProc.Params.ParamByName('inCurrencyValueEUR').Value:=FieldByName('CurrencyValueEUR').AsFloat;
             toStoredProc.Params.ParamByName('inParValueEUR').Value:=FieldByName('ParValueEUR').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     try fExecSqFromQuery_noErr(' drop table dba._TableLoadReturnIn '); except end;
     //
     myDisabledCB(cbReturnIn_Child);
end;

function TMainForm.pLoadDocument_ReturnOut: Integer;
begin
     Result:=0;
     //
     if (not cbReturnOut.Checked)or(not cbReturnOut.Enabled) then exit;
     //
     myEnabledCB(cbReturnOut);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select Bill.Id as ObjectId ');
        Add('     , Bill.Id_Postgres ');
        Add('     , Bill.BillNumber as InvNumber ');
        Add('     , Bill.BillDate as OperDate ');
        Add('     , Bill_From.Id_Postgres as FromId  ');
        Add('     , Bill_From.UnitName as UnitNameFrom ');
        Add('     , Bill_To.Id_Postgres as ToId ');
        Add('     , Bill_To.UnitName as UnitNameTo ');
        Add('     , Bill_CurrencyDocument.Id_Postgres as CurrencyDocumentId ');
        Add('     , Bill_CurrencyDocument.ValutaName as  CurrencyDocumentName ');
        Add('     , 0 as CurrencyValue ');
        Add('     , 1 as ParValue ');
        Add('     , '''' as Comments ');
        Add(' from DBA.Bill ');
        Add('     left outer join DBA.Valuta as Bill_CurrencyDocument on Bill_CurrencyDocument.Id = Bill.ValutaIDIn   ');
        Add('     left outer join DBA.Unit as Bill_From on Bill_From.Id = Bill.FromID ');
        Add('     left outer join DBA.Unit as Bill_To on Bill_To.Id = Bill.ToID ');
        Add(' where  Bill.BillKind = zc_bkReturnFromUnitToClient() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, ObjectId ');
        Open;

        Result:=RecordCount;
        cbReturnOut.Caption:='1.2. ('+IntToStr(RecordCount)+') ������� ����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_ReturnOut';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyDocumentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;
             toStoredProc.Params.ParamByName('inCurrencyDocumentId').Value:=FieldByName('CurrencyDocumentId').AsInteger;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('Comments').AsString;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.Bill set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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

function TMainForm.pLoadDocument_Sale: Integer;
begin
     Result:=0;
     //
     if (not cbSale.Checked)or(not cbSale.Enabled) then exit;
     //
     myEnabledCB(cbSale);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select');
        Add('      Bill.Id as ObjectId');
        Add('    , Bill.Id_Postgres as Id_Postgres');
        Add('    , 0 as InvNumber');
        Add('    , Bill.BillDate as OperDate');
        Add('    , Bill.BillDate as OperDateInsert');
        Add('    , Unit_From.Id_Postgres as FromId ');
        Add('    , Unit_From.UnitName as UnitNameFrom');
        Add('    , Unit_To.Id_Postgres as ToId');
        Add('    , Unit_To.UnitName as UnitNameTo');
        Add('    , zc_rvYes() as isBill');
        Add('from DBA.Bill');
        Add('    left outer join DBA.Unit as Unit_From on Unit_From.Id = Bill.FromID');
        Add('    left outer join DBA.Unit as Unit_To on Unit_To.Id = Bill.ToId');
        Add('where Bill.BillKind = zc_bkSaleFromUnitToClient() and Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('  and Bill.DatabaseId = 0');
        Add('union all');
        Add('select');
        Add('      DiscountMovement.Id as ObjectId');
        Add('    , DiscountMovement.SaleId_Postgres as Id_Postgres');
        Add('    , 0 as InvNumber');
        Add('    , date(DiscountMovement.OperDate) as OperDate');   // �� ������� ������ �������� ������ ����
        Add('    , DiscountMovement.OperDate as OperDateInsert');
        Add('    , Unit_From.Id_Postgres as FromId ');
        Add('    , Unit_From.UnitName as UnitNameFrom');
        Add('    , Unit_To.Id_Postgres as ToId');
        Add('    , Unit_To.UnitName as UnitNameTo');
        Add('    , zc_rvNo() as isBill');
        Add('from DBA.DiscountMovement');
        Add('    left outer join DBA.Unit as Unit_From on Unit_From.Id = DiscountMovement.UnitID');
        Add('    left outer join DBA.DiscountKlient as DiscountKlient on DiscountKlient.Id = DiscountMovement.DiscountKlientID');
        Add('    left outer join DBA.Unit as Unit_To on Unit_To.id = DiscountKlient.ClientId');
        Add('where DiscountMovement.descId = 1  and DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('order by 4, 1');
        Open;

        Result:=RecordCount;
        cbSale.Caption:='1.8. ('+IntToStr(RecordCount)+') ������� ����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Sale';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;

             if not myExecToStoredProc then ;//exit;
             //
             if (FieldByName('Id_Postgres').AsInteger=0) and(FieldByName('isBill').AsInteger=zc_rvNo) then
               fExecSqFromQuery('update dba.DiscountMovement set SaleId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString)
             else
                 if (FieldByName('Id_Postgres').AsInteger=0) and(FieldByName('isBill').AsInteger=zc_rvYes) then
                   fExecSqFromQuery('update dba.Bill set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbSale);

end;

function TMainForm.pLoadDocument_Sale_Child: Integer;
begin
     Result:=0;
     //
     if (not cbSale_Child.Checked)or(not cbSale_Child.Enabled) then exit;
     //
     myEnabledCB(cbSale_Child);
     //
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(   ' SELECT'
             + '      DiscountMovement.OperDate'
             + '    , DiscountMovement.SaleId_Postgres as MovementId'
             + '    , DiscountMovementItem_byBarCode.Id_Postgres as ParentId'
             + '    , SUM (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=1 then  DiscountKlientAccountMoney.Summa else 0 endif ) as AmountGRN'
             + '    , SUM (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then  DiscountKlientAccountMoney.Summa else 0 endif ) as AmountEUR'
             + '    , SUM (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then  DiscountKlientAccountMoney.Summa else 0 endif ) as AmountUSD'
             + '    , SUM (if  Kassa.ID in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  ) then  DiscountKlientAccountMoney.Summa else 0 endif ) as AmountCard'
             + '    , SUM (if  Kassa.ID in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  ) then  DiscountKlientAccountMoney.SummDiscountManual else 0 endif ) as  AmountDiscount'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then DiscountKlientAccountMoney.KursClient else 0 endif ) as CurrencyValueUSD'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=5 then DiscountKlientAccountMoney.NominalKursClient else 0 endif ) as ParValueUSD'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then DiscountKlientAccountMoney.KursClient else 0 endif ) as CurrencyValueEUR'
             + '    , MAX (if  Kassa.ID not in (26, 34, 37, 40, 44, 48, 51, 56, 60, 64, 67  )  and KassaProperty.valutaID=2 then DiscountKlientAccountMoney.NominalKursClient else 0 endif ) as ParValueEUR'
             + ' FROM dba.DiscountMovementItem_byBarCode'
             + '    join DiscountMovement     on DiscountMovement.id = DiscountMovementItem_byBarCode.DiscountMovementId'
             + '    join DiscountKlientAccountMoney  on DiscountKlientAccountMoney.DiscountMovementItemId = DiscountMovementItem_byBarCode.Id '
             + '                                and isCurrent = zc_rvYes() and discountMovementItemReturnId  is null'
             + '    join Kassa on Kassa.Id = DiscountKlientAccountMoney.KassaID'
             + '    join KassaProperty  on KassaProperty.KassaID = Kassa.ID'
             + ' WHERE DiscountMovement.descId = 1  AND DiscountMovement.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
             + ' GROUP BY DiscountMovement.OperDate, MovementId, ParentId'
             + ' ORDER BY DiscountMovement.OperDate');
        Open;

        Result:=RecordCount;
        cbSale_Child.Caption:='1.10. ('+IntToStr(RecordCount)+') ������ ����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_MI_Sale_Child';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        //
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountGRN',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountEUR',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountCard',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAmountDiscount',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyValueUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParValueUSD',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inCurrencyValueEUR',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inParValueEUR',ftFloat,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId').AsInteger;
             toStoredProc.Params.ParamByName('inAmountGRN').Value:=FieldByName('AmountGRN').AsFloat;
             toStoredProc.Params.ParamByName('inAmountUSD').Value:=FieldByName('AmountUSD').AsFloat;
             toStoredProc.Params.ParamByName('inAmountEUR').Value:=FieldByName('AmountEUR').AsFloat;
             toStoredProc.Params.ParamByName('inAmountCard').Value:=FieldByName('AmountCard').AsFloat;
             toStoredProc.Params.ParamByName('inAmountDiscount').Value:=FieldByName('AmountDiscount').AsFloat;
             toStoredProc.Params.ParamByName('inCurrencyValueUSD').Value:=FieldByName('CurrencyValueUSD').AsFloat;
             toStoredProc.Params.ParamByName('inParValueUSD').Value:=FieldByName('ParValueUSD').AsFloat;
             toStoredProc.Params.ParamByName('inCurrencyValueEUR').Value:=FieldByName('CurrencyValueEUR').AsFloat;
             toStoredProc.Params.ParamByName('inParValueEUR').Value:=FieldByName('ParValueEUR').AsFloat;

             if not myExecToStoredProc then ;//exit;
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     try fExecSqFromQuery_noErr(' drop table dba._TableLoadSale '); except end;
     //
     myDisabledCB(cbSale_Child);
end;

function TMainForm.pLoadDocument_Send: Integer;
begin
      Result:=0;
     //
     if (not cbSend.Checked)or(not cbSend.Enabled) then exit;
     //
     myEnabledCB(cbSend);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select Bill.Id as ObjectId ');
        Add('     , Bill.Id_Postgres ');
        Add('     , Bill.BillNumber as InvNumber ');
        Add('     , Bill.BillDate as OperDate ');
        Add('     , Bill_From.Id_Postgres as FromId  ');
        Add('     , Bill_From.UnitName as UnitNameFrom ');
        Add('     , Bill_To.Id_Postgres as ToId ');
        Add('     , Bill_To.UnitName as UnitNameTo ');
        Add('     , '''' as Comments ');
        Add(' from DBA.Bill ');
        Add('     left outer join DBA.Unit as Bill_From on Bill_From.Id = Bill.FromID ');
        Add('     left outer join DBA.Unit as Bill_To on Bill_To.Id = Bill.ToID ');
        Add(' where  Bill.BillKind = zc_bkSendFromUnitToUnit() and  Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add(' order by Bill.BillDate, ObjectId ');
        Open;
        Open;

        Result:=RecordCount;
        cbSend.Caption:='1.3. ('+IntToStr(RecordCount)+') �����������';
        //
        //
        //
        //
        fStop:=(cbOnlyOpen.Checked)and(not cbOnlyOpenMIMaster.Checked)and(not cbOnlyOpenMIChild.Checked);

        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Movement_Send';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioInvNumber',ftString,ptInputOutput, '');
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
            if fStop then begin exit; end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('ioInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId').AsInteger;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('Comments').AsString;

             if not myExecToStoredProc then ;//exit;
             //
             if FieldByName('Id_Postgres').AsInteger=0 then
               fExecSqFromQuery('update dba.Bill set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbSend);

end;

procedure TMainForm.pLoadGuide_Brand;
begin
     if (not cbBrand.Checked)or(not cbBrand.Enabled) then exit;
     //
     myEnabledCB(cbBrand);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Brand.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Brand.BrandName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Brand.Erased as Erased');
        Add('     , Brand.Id_Postgres');
        Add('     , Brand_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Brand');
        Add('     left outer join dba.CountryBrand as Brand_parent on Brand_parent.Id = Brand.CountryBrandId');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Brand';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCountryBrandId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inCountryBrandId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Brand set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbBrand);
end;

procedure TMainForm.pLoadGuide_City;
begin
   if (not cbCity.Checked)or(not cbCity.Enabled) then exit;
     //
     myEnabledCB(cbCity);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('   select distinct city as ObjectName ');
        Add('  from DiscountKlient where city <>''''   ');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_City';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=0;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCity);
end;

procedure TMainForm.pLoadGuide_Client;
begin
     if (not cbClient.Checked)or(not cbClient.Enabled) then exit;
     //
     myEnabledCB(cbClient);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select');
        Add('  Unit.Id as ObjectId');
        Add(', 0 as ObjectCode');
        Add(', Unit.UnitName as ObjectName');
        Add(', zc_erasedDel() as zc_erasedDel');
        Add(', Unit.Erased as Erased');
        Add(', Unit.Id_Postgres');
        Add(', DiscountKlient.kardnumber as  DiscountCard');
        Add(', DiscountKlient.DiscountTax');
        Add(', DiscountKlient.DiscountTaxTwo');
        Add(', DiscountKlient.TotalCount');
        Add(', DiscountKlient.TotalSumm');
        Add(', DiscountKlient.TotalSummDiscount');
        Add(', DiscountKlient.TotalSummPay');
        Add(', DiscountKlient.LastCount');
        Add(', DiscountKlient.LastSumm');
        Add(', DiscountKlient.LastSummDiscount');
        Add(', DiscountKlient.LastDate');
        Add(', DiscountKlient.DiscountKlientAddress as  Address');
        Add(', DiscountKlient.HappyDate');
        Add(', DiscountKlient.PhoneMobile');
        Add(', DiscountKlient.Phone');
        Add(', DiscountKlient.Poshta as Mail');
        Add(', DiscountKlient.CommentInfo as  Comments');
        Add(', DiscountKlient.City as CityName');
        Add(', DiscountKlient.KindDiscount as KindDiscount');
        Add(', users.userId_postgres as LastUserID');
        Add('from Unit inner join DiscountKlient on DiscountKlient.ClientId = Unit.id');
        Add('     left outer join Users on users.id = DiscountKlient.LastUserID');
        Add('where KindUnit = zc_kuClient()');
        Add('order by  ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Client';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inDiscountCard',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inDiscountTax',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiscountTaxTwo',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inHappyDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inPhoneMobile',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPhone',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inMail',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCityId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiscountKindId',ftInteger,ptInput, 0);
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_Object_Client_Sybase';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc_two.Params.AddParam ('inTotalCount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inTotalSumm',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inTotalSummDiscount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inTotalSummPay',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inLastCount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inLastSumm',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inLastSummDiscount',ftFloat,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inLastDate',ftDateTime,ptInput, '');
        toStoredProc_two.Params.AddParam ('inLastUserID',ftInteger,ptInput, 0);
        while not EOF do
        begin

             //!!!
             if fStop then begin {EnableControls;}exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inDiscountCard').Value:=FieldByName('DiscountCard').AsString;
             toStoredProc.Params.ParamByName('inDiscountTax').Value:=FieldByName('DiscountTax').AsFloat;
             toStoredProc.Params.ParamByName('inDiscountTaxTwo').Value:=FieldByName('DiscountTaxTwo').AsFloat;
             toStoredProc.Params.ParamByName('inAddress').Value:=FieldByName('Address').AsString;
             toStoredProc.Params.ParamByName('inHappyDate').Value:=FieldByName('HappyDate').AsDateTime;
             toStoredProc.Params.ParamByName('inPhoneMobile').Value:=FieldByName('PhoneMobile').AsString;
             toStoredProc.Params.ParamByName('inPhone').Value:=FieldByName('Phone').AsString;
             toStoredProc.Params.ParamByName('inMail').Value:=FieldByName('Mail').AsString;
             toStoredProc.Params.ParamByName('inComment').Value:=FieldByName('Comments').AsString;
             //
             fOpenSqToQuery (' SELECT ID  FROM Object WHERE Object.DescId = zc_Object_City()  '
                           +' and ValueData = '''+FieldByName('CityName').AsString+'''');
             toStoredProc.Params.ParamByName('inCityId').Value:=toSqlQuery.FieldByName('Id').AsInteger;
             //

             //
             fOpenSqToQuery (' SELECT ID  FROM Object WHERE Object.DescId = zc_Object_DiscountKind()  '
                           +' and objectcode ='+inttostr(FieldByName('KindDiscount').AsInteger));
             toStoredProc.Params.ParamByName('inDiscountKindId').Value:=toSqlQuery.FieldByName('Id').AsInteger;
             //



             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             //toStoredProc_two.Params.ParamByName('ioId').Value:=toStoredProc.Params.ParamByName('ioId').Value;
             //toStoredProc_two.Params.ParamByName('inTotalCount').Value:=FieldByName('TotalCount').AsFloat;
             //toStoredProc_two.Params.ParamByName('inTotalSumm').Value:=FieldByName('TotalSumm').AsFloat;
             //toStoredProc_two.Params.ParamByName('inTotalSummDiscount').Value:=FieldByName('TotalSummDiscount').AsFloat;
             //toStoredProc_two.Params.ParamByName('inTotalSummPay').Value:=FieldByName('TotalSummPay').AsFloat;
             //toStoredProc_two.Params.ParamByName('inLastCount').Value:=FieldByName('LastCount').AsFloat;
             //toStoredProc_two.Params.ParamByName('inLastSumm').Value:=FieldByName('LastSumm').AsFloat;
             //toStoredProc_two.Params.ParamByName('inLastSummDiscount').Value:=FieldByName('LastSummDiscount').AsFloat;
             //toStoredProc_two.Params.ParamByName('inLastDate').Value:=FieldByName('LastDate').AsDateTime;
             //toStoredProc_two.Params.ParamByName('inLastUserID').Value:=FieldByName('LastUserID').AsInteger;
             //if not myExecToStoredProc_two then ;//exit;

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbClient);
end;

procedure TMainForm.pLoadGuide_Composition;
begin
     if (not cbComposition.Checked)or(not cbComposition.Enabled) then exit;
     //
     ShowMessage('cbComposition ����� - �� �����������');
     cbComposition.Checked:= FALSE;
     cbComposition.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbComposition);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Composition.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Composition.CompositionName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Composition.Erased as Erased');
        Add('     , Composition.Id_Postgres');
        Add('     , Composition_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Composition');
        Add('     left outer join dba.CompositionGroup as Composition_parent on Composition_parent.Id = Composition.CompositionGroupId');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Composition';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCompositionGroupId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inCompositionGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Composition set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbComposition);
end;

procedure TMainForm.pLoadGuide_CompositionGroup;
begin
     if (not cbCompositionGroup.Checked)or(not cbCompositionGroup.Enabled) then exit;
     //
     myEnabledCB(cbCompositionGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select CompositionGroup.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , CompositionGroup.CompositionGroupName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , CompositionGroup.Erased as Erased');
        Add('     , CompositionGroup.Id_Postgres');
        Add('from dba.CompositionGroup');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_CompositionGroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.CompositionGroup set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbCompositionGroup);
end;

procedure TMainForm.pLoadGuide_CountryBrand;
begin
     if (not cbCountryBrand.Checked)or(not cbCountryBrand.Enabled) then exit;
     //
     myEnabledCB(cbCountryBrand);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select CountryBrand.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , CountryBrand.CountryBrandName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , CountryBrand.Erased as Erased');
        Add('     , CountryBrand.Id_Postgres');
        Add('from dba.CountryBrand');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_CountryBrand';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.CountryBrand set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbCountryBrand);
end;

procedure TMainForm.pLoadGuide_Discount;
begin
     if (not cbDiscount.Checked)or(not cbDiscount.Enabled) then exit;
     //
     myEnabledCB(cbDiscount);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Discount.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Discount.DiscountName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Discount.isErased as Erased');
        Add('     , Discount.Id_Postgres');
        Add('     , KindDiscount');
        Add('from dba.Discount');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Discount';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inDiscountKindId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //

             fOpenSqToQuery (' SELECT ID  FROM Object WHERE Object.DescId = zc_Object_DiscountKind()  '
                           +' and objectcode ='+inttostr(FieldByName('KindDiscount').AsInteger));
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inDiscountKindId').Value:=toSqlQuery.FieldByName('Id').AsInteger;


             if not myExecToStoredProc then;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Discount set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbDiscount);
end;

procedure TMainForm.pLoadGuide_DiscountTools;
begin
     if (not cbDiscountTools.Checked)or(not cbDiscountTools.Enabled) then exit;
     //
     myEnabledCB(cbDiscountTools);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select DiscountTools.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     --, DiscountTools.DiscountName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , DiscountTools.isErased as Erased');
        Add('     , DiscountTools.Id_Postgres');
        Add('     , DiscountTools_parent.Id_Postgres as ParentId_Postgres');
        Add('     , DiscountTools.DiscountId as DiscountId');
        Add('     , DiscountTools.StartSumm as StartSumm');
        Add('     , DiscountTools.EndSumm as EndSumm');
        Add('     , DiscountTools.DiscountTax as DiscountTax');
        Add('from dba.DiscountTools');
        Add('     left outer join dba.Discount as DiscountTools_parent on DiscountTools_parent.Id = DiscountTools.DiscountId');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_DiscountTools';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
//        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
//        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inStartSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inEndSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiscountTax',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiscountId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin   exit; end;
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
//             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
//             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inStartSumm').Value:=FieldByName('StartSumm').AsFloat;
             toStoredProc.Params.ParamByName('inEndSumm').Value:=FieldByName('EndSumm').AsFloat;
             toStoredProc.Params.ParamByName('inDiscountTax').Value:=FieldByName('DiscountTax').AsFloat;
             toStoredProc.Params.ParamByName('inDiscountId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.DiscountTools set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbDiscountTools);
end;

procedure TMainForm.pLoadGuide_Fabrika;
begin
     if (not cbFabrika.Checked)or(not cbFabrika.Enabled) then exit;
     //
     myEnabledCB(cbFabrika);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Fabrika.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Fabrika.FabrikaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Fabrika.Erased as Erased');
        Add('     , Fabrika.Id_Postgres');
        Add('from dba.Fabrika');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Fabrika';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Fabrika set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbFabrika);
end;

procedure TMainForm.pLoadGuide_Goods;
begin
     //
     if (not cbGoods.Checked)or(not cbGoods.Enabled) then exit;
     //
     ShowMessage('cbGoods ����� - �� �����������');
     cbGoods.Checked:= FALSE;
     cbGoods.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select distinct');
        Add('       GoodsProperty.CashCode as ObjectCode');
        Add('     , GoodsName.GoodsName as ObjectName');
        Add('     , zc_erasedDel()         as zc_erasedDel');
        Add('     , GoodsProperty.Erased   as Erased');
        Add('     , GoodsProperty.Id_Pg_Goods');
        Add('     , case when GoodsName.ParentId = 500000');
        Add('              or Goods_parent1.ParentId = 500000');
        Add('              or Goods_parent2.ParentId = 500000');
        Add('            then Goods_parent1.Id');
        Add('            else Goods_parent2.Id');
        Add('       end as GoodsGroupId'); // !!!��������� ������ �� ���������, �� ����� ������
        Add('     , GoodsProperty.MeasureId');
        Add('     , GoodsProperty.CompositionId');
        Add('     , GoodsProperty.GoodsInfoId');
        Add('     , GoodsProperty.LineFabricaId');
        Add('     , case when GoodsName.ParentId = 500000');
        Add('              or Goods_parent1.ParentId = 500000');
        Add('              or Goods_parent2.ParentId = 500000');
        Add('            then Goods_parent1.Id_Postgres');
        Add('            else Goods_parent2.Id_Postgres');
        Add('       end as ParentId_Postgres_GoodsGroup'); // !!!��������� ������ �� ���������, �� ����� ������
        Add('     , GoodsProperty_parent_measure.Id_Postgres as ParentId_Postgres_measure');
        Add('     , GoodsProperty_parent_Composition.Id_Postgres as ParentId_Postgres_Composition');
        Add('     , GoodsProperty_parent_GoodsInfo.Id_Postgres as ParentId_Postgres_GoodsInfo');
        Add('     , GoodsProperty_parent_LineFabrica.Id_Postgres as ParentId_Postgres_LineFabrica');
        Add('     , GoodsLabel.GoodsName as LabelName');
        Add('from dba.GoodsProperty ');
        Add(' left outer join dba.measure as GoodsProperty_parent_measure on GoodsProperty_parent_measure.id = GoodsProperty.MeasureId ');
        Add(' left outer join dba.Composition as GoodsProperty_parent_Composition on GoodsProperty_parent_Composition.id = GoodsProperty.CompositionId');
        Add(' left outer join dba.GoodsInfo as GoodsProperty_parent_GoodsInfo on GoodsProperty_parent_GoodsInfo.id = GoodsProperty.GoodsInfoId');
        Add(' left outer join dba.LineFabrica as GoodsProperty_parent_LineFabrica on GoodsProperty_parent_LineFabrica.Id =  GoodsProperty.LineFabricaId');
        Add(' left outer join dba.Goods as GoodsName  on GoodsName.Id = GoodsProperty.GoodsId');
        Add(' left outer join dba.Goods as GoodsLabel on GoodsLabel.Id = GoodsName.ParentId');
        //    !!!��������� ������ �� ���������, �� ����� ������
        Add(' left outer join dba.Goods as Goods_parent1 on Goods_parent1.Id = GoodsName.ParentId');
        Add(' left outer join dba.Goods as Goods_parent2 on Goods_parent2.Id = Goods_parent1.ParentId');

        Add('order by ObjectCode');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Goods';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsGroupId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inMeasureId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inCompositionId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsInfoId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inLineFabricaID',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inLabelId',ftInteger,ptInput, 0);

        //

        while not EOF do
        begin

             //!!!
             if fStop then begin  exit;end;
             //
                          fOpenSqToQuery (' SELECT ID  FROM Object WHERE Object.DescId = zc_Object_Label()  '
                           +' and ValueData = '''+FieldByName('LabelName').AsString+'''');
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Pg_Goods').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGoodsGroupId').Value:=FieldByName('ParentId_Postgres_GoodsGroup').AsFloat;
             toStoredProc.Params.ParamByName('inMeasureId').Value:=FieldByName('ParentId_Postgres_Measure').AsFloat;
             toStoredProc.Params.ParamByName('inCompositionId').Value:=FieldByName('ParentId_Postgres_Composition').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsInfoId').Value:=FieldByName('ParentId_Postgres_GoodsInfo').AsFloat;
             toStoredProc.Params.ParamByName('inLineFabricaID').Value:=FieldByName('ParentId_Postgres_LineFabrica').AsFloat;
             toStoredProc.Params.ParamByName('inLabelId').Value:=toSqlQuery.FieldByName('Id').AsInteger;

             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Pg_Goods').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty set Id_Pg_Goods = '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where CashCode = '+FieldByName('ObjectCode').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbGoods);

end;

procedure TMainForm.pLoadGuide_GoodsGroup;
begin
     if (not cbGoodsGroup.Checked)or(not cbGoodsGroup.Enabled) then exit;
     //
     myEnabledCB(cbGoodsGroup);
     //
      //������� �������, �.�. ��������� �� �����
      try fExecSqFromQuery_noErr('create table dba._TableLoadPG5 (ParentId integer primary key)');
      except end;
      fExecSqFromQuery('delete from dba._TableLoadPG5');
      fExecSqFromQuery('insert into dba._TableLoadPG5 (ParentId)'
                      +'           select distinct Goods_find.ParentId'
           +'                      from dba.Goods as Goods_find'
           +'                           left outer join dba.Goods as Goods_parent1 on Goods_parent1.Id = Goods_find.ParentId'
           +'                           left outer join dba.Goods as Goods_parent2 on Goods_parent2.Id = Goods_parent1.ParentId'
           +'                      where Goods_find.HasChildren = zc_hsLeaf()'
           +'                         and Goods_find.ParentId <> 500000'
           +'                         and Goods_parent1.ParentId <> 500000'
           +'                         and Goods_parent2.ParentId <> 500000');
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select DISTINCT');
        Add('       Goods.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Goods.GoodsName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Goods.Erased as Erased');
        Add('     , Goods.Id_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Goods');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('     left outer join dba.Goods as Goods_child on Goods_child.ParentId    = Goods.Id');
        Add('                                             and Goods_child.HasChildren <> zc_hsLeaf()');
        //        !!!��������� ������ �� ���������, �� ����� ������
        Add('     left outer join _TableLoadPG5 as Goods_find on Goods_find.ParentId = Goods.Id');
        Add('where Goods.HasChildren <> zc_hsLeaf()');
        Add('  and (Goods_find.ParentId is null'); // !!!��������� ������ �� ���������, �� ����� ������
        Add('    or Goods_child.Id > 0)');
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
        toStoredProc.Params.AddParam ('inInfoMoneyId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=1)or(FieldByName('Id_Postgres').AsInteger=0)
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

procedure TMainForm.pLoadGuide_GoodsInfo;
begin
     if (not cbGoodsInfo.Checked)or(not cbGoodsInfo.Enabled) then exit;
     //
     ShowMessage('cbGoodsInfo ����� - �� �����������');
     cbGoodsInfo.Checked:= FALSE;
     cbGoodsInfo.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbGoodsInfo);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsInfo.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GoodsInfo.GoodsInfoName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , GoodsInfo.Erased as Erased');
        Add('     , GoodsInfo.Id_Postgres');
        Add('from dba.GoodsInfo');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_GoodsInfo';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsInfo set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbGoodsInfo);
end;

procedure TMainForm.pLoadGuide_GoodsItem;
begin
     if (not cbGoodsItem.Checked)or(not cbGoodsItem.Enabled) then exit;
     //
     ShowMessage('cbGoodsItem ����� - �� �����������');
     cbGoodsItem.Checked:= FALSE;
     cbGoodsItem.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbGoodsItem);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty.ID  as ObjectId');
        Add('     , GoodsProperty.CashCode as ObjectCode');
        Add('     , GoodsName.GoodsName as ObjectName');
        Add('     , zc_erasedDel()         as zc_erasedDel');
        Add('     , GoodsProperty.Erased   as Erased');
        Add('     , GoodsProperty.Id_Pg_GoodsItem');
        Add('     , GoodsProperty.Id_Pg_Goods');
        Add('     , GoodsProperty_parent_GoodsSize.Id_Postgres as ParentId_Postgres_GoodsSize');
        Add('from dba.GoodsProperty ');
        Add(' left outer join dba.Goods as GoodsName  on GoodsName.Id = GoodsProperty.GoodsId');
        Add(' left outer join dba.GoodsSize as GoodsProperty_parent_GoodsSize on GoodsProperty_parent_GoodsSize.Id =  GoodsProperty.GoodsSizeId');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_GoodsItem';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsSizeId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin  exit;end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Pg_GoodsItem').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('Id_Pg_Goods').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsSizeId').Value:=FieldByName('ParentId_Postgres_GoodsSize').AsInteger;


             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Pg_GoodsItem').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty set Id_Pg_GoodsItem = '+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbGoodsItem);

end;

procedure TMainForm.pLoadGuide_GoodsSize;
begin
     if (not cbGoodsSize.Checked)or(not cbGoodsSize.Enabled) then exit;
     //
     ShowMessage('cbGoodsSize ����� - �� �����������');
     cbGoodsSize.Checked:= FALSE;
     cbGoodsSize.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbGoodsSize);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsSize.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GoodsSize.GoodsSizeName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , GoodsSize.Erased as Erased');
        Add('     , GoodsSize.Id_Postgres');
        Add('from dba.GoodsSize');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_GoodsSize';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsSize set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbGoodsSize);
end;

procedure TMainForm.pLoadGuide_Juridical;
begin
     if (not cbJuridical.Checked)or(not cbJuridical.Enabled) then exit;
     //
     myEnabledCB(cbJuridical);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select');
        Add('  Firma.Id as ObjectId');
        Add(', 0 as ObjectCode');
        Add(', Firma.FirmaName as ObjectName');
        Add(', zc_erasedDel() as zc_erasedDel');
        Add(', Firma.Erased as Erased');
        Add(', Firma.Id_Postgres');
        Add('from DBA.Firma ');
        Add('order by  ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Juridical';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inIsCorporate',ftBoolean,ptInput, false);
        toStoredProc.Params.AddParam ('inFullName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inOKPO',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inINN',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inJuridicalGroupId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin  exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             //

             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Firma set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbJuridical);
end;

procedure TMainForm.pLoadGuide_Cash;
begin
     if (not cbCash.Checked)or(not cbCash.Enabled) then exit;
     //
     myEnabledCB(cbCash);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select');
        Add('       KassaProperty.KassaId as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , KassaProperty.KassaPropertyName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , KassaProperty.Erased as Erased');
        Add('     , KassaProperty.Id_Postgres');
        Add('     , Valuta.Id_Postgres as CurrencyId');
        Add('     , case');
        Add('       when ObjectId = 21 then 235');     // MaxMara ���   - ������� MaxMara
        Add('       when ObjectId = 25 then 235');     // MaxMara $     - ������� MaxMara
        //Add('       when ObjectId = 26 then 235');   // MaxMara ��    - ������� MaxMara
        Add('       when ObjectId = 27 then 235');     // MaxMara EUR   - ������� MaxMara
        //Add('       when ObjectId = 28 then 0');       // ����������    -
        Add('       when ObjectId = 29 then 204');     // Terry - L ��� - ������� Terri-Luxury
        Add('       when ObjectId = 30 then 234');     // ����� ���     - ������� SAVOY
        Add('       when ObjectId = 31 then 240');     // 5 ������� ��� - ������� 5 �������
        Add('       when ObjectId = 32 then 240');     // 5 ������� $   - ������� 5 �������
        Add('       when ObjectId = 33 then 240');     // 5 ������� EUR - ������� 5 �������
        //Add('       when ObjectId = 34 then 240');     // 5 ������� ��  - ������� 5 �������
        Add('       when ObjectId = 35 then 234');     // ����� $       - ������� SAVOY
        Add('       when ObjectId = 36 then 234');     // ����� EUR     - ������� SAVOY
        //Add('       when ObjectId = 37 then 234');     // ����� ��      - ������� SAVOY
        Add('       when ObjectId = 38 then 204');     // Terry - L $   - ������� Terri-Luxury
        Add('       when ObjectId = 39 then 204');     // Terry - L EUR - ������� Terri-Luxury
        //Add('       when ObjectId = 40 then 204');     // Terry - L ��  - ������� Terri-Luxury
        Add('       when ObjectId = 41 then 1121');    // ���� ���      - ������� CHADO
        Add('       when ObjectId = 42 then 1121');    // ���� $        - ������� CHADO
        Add('       when ObjectId = 43 then 1121');    // ���� EUR      - ������� CHADO
        //Add('       when ObjectId = 44 then 1121');    // ���� ��       - ������� CHADO
        Add('       when ObjectId = 45 then 969');     // ����� ���     - ������� Sopra
        Add('       when ObjectId = 46 then 969');     // ����� $       - ������� Sopra
        Add('       when ObjectId = 47 then 969');     // ����� EUR     - ������� Sopra
        //Add('       when ObjectId = 48 then 969');     // ����� ��      - ������� Sopra
        Add('       when ObjectId = 49 then 5727');    // PZ ���        - ������� Savoy-P.Z.
        Add('       when ObjectId = 50 then 5727');    // PZ $          - ������� Savoy-P.Z.
        //Add('       when ObjectId = 51 then 5727');    // PZ ��         - ������� Savoy-P.Z.
        Add('       when ObjectId = 52 then 5727');    // PZ EUR        - ������� Savoy-P.Z.
        Add('       when ObjectId = 53 then 11772');   // �����  ���    - ������� �����-Out
        Add('       when ObjectId = 54 then 11772');   // �����  $      - ������� �����-Out
        Add('       when ObjectId = 55 then 11772');   // �����  EUR    - ������� �����-Out
        //Add('       when ObjectId = 56 then 11772');   // �����  ��     - ������� �����-Out
        Add('       when ObjectId = 57 then 4646');    // Vintag grn    - ��.Vintag
        Add('       when ObjectId = 58 then 4646');    // Vintag dol    - ��.Vintag
        Add('       when ObjectId = 59 then 4646');    // Vintag EUR    - ��.Vintag
        //Add('       when ObjectId = 60 then 4646');    // Vintag BN     - ��.Vintag
        Add('       when ObjectId = 61 then 20484');   // ESCADA ���    - ������� ESCADA
        Add('       when ObjectId = 62 then 20484');   // ESCADA $      - ������� ESCADA
        Add('       when ObjectId = 63 then 20484');   // ESCADA EUR    - ������� ESCADA
        //Add('       when ObjectId = 64 then 20484');   // ESCADA ��     - ������� ESCADA
        Add('       when ObjectId = 65 then 29018');   // Savoy-O ���   - ������� Savoy-O
        Add('       when ObjectId = 66 then 29018');   // Savoy-O EUR   - ������� Savoy-O
        //Add('       when ObjectId = 67 then 29018');   // Savoy-O ��    - ������� Savoy-O
        Add('       when ObjectId = 68 then 29018');   // Savoy-O $     - ������� Savoy-O
        Add('       end   as IDUnitID');
        Add('     , podr.Id_Postgres as UnitID    ');
        Add('from dba.KassaProperty');
        Add('     left outer join Valuta on Valuta.Id = KassaProperty.ValutaId');
        Add('     left outer join Unit as Podr on podr.id = IDUnitID');
        Add('where KassaProperty.KassaId <> 28');       // ����������    -
        Add('order by  ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_Cash';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCurrencyId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inCurrencyId').Value:=FieldByName('CurrencyId').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('UnitId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //

             if (FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.KassaProperty set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbCash);
end;

procedure TMainForm.pLoadGuide_Label;
begin
    if (not cbLabel.Checked)or(not cbLabel.Enabled) then exit;
     //
     ShowMessage('cbLabel ����� - �� �����������');
     cbLabel.Checked:= FALSE;
     cbLabel.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbLabel);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add(' select goods_group.goodsName AS ObjectName');
        Add(' from GoodsProperty');
        Add(' join goods on goods.Id = GoodsProperty.goodsId');
        Add(' join goods as goods_group on goods_group.Id = goods.ParentId');
        Add(' group by  goods_group.goodsName');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Label';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=0;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbLabel);
end;

procedure TMainForm.pLoadGuide_LineFabrica;
begin
     if (not cbLineFabrica.Checked)or(not cbLineFabrica.Enabled) then exit;
     //
     ShowMessage('cbLineFabrica ����� - �� �����������');
     cbLineFabrica.Checked:= FALSE;
     cbLineFabrica.Enabled:= FALSE;
     exit;
     //
     //
     myEnabledCB(cbLineFabrica);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select LineFabrica.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , LineFabrica.LineFabricaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , LineFabrica.Erased as Erased');
        Add('     , LineFabrica.Id_Postgres');
        Add('from dba.LineFabrica');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_LineFabrica';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.LineFabrica set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbLineFabrica);
end;

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
             if fStop then begin   exit; end;
             //

             fOpenSqToQuery (' select OS_Measure_InternalCode.ValueData  AS InternalCode'
                           +'       , OS_Measure_InternalName.ValueData  AS InternalName'
                           +' from Object'
                           +'         left outer join ObjectString AS OS_Measure_InternalName'
                           +'                  ON OS_Measure_InternalName.ObjectId = Object.Id'
                           +'                 AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()'
                           +'         left outer join ObjectString AS OS_Measure_InternalCode'
                           +'                  ON OS_Measure_InternalCode.ObjectId = Object.Id'
                           +'                 AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()'
                           +' where Object.Id='+inttostr(FieldByName('Id_Postgres').AsInteger));



             InternalCode_pg:=toSqlQuery.FieldByName('InternalCode').AsString;
             InternalName_pg:=toSqlQuery.FieldByName('InternalName').AsString;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inInternalCode').Value:=InternalCode_pg;
             toStoredProc.Params.ParamByName('inInternalName').Value:=InternalName_pg;


             if not myExecToStoredProc then ;
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
procedure TMainForm.pLoadGuide_Member;
begin
      if (not cbMember.Checked)or(not cbMember.Enabled) then exit;
     //
     myEnabledCB(cbMember);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Users.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Users.UsersName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Users.Erased as Erased');
        Add('     , Users.MemberId_Postgres as Id_Postgres');
        Add('from dba.Users  where haschildren = -1');
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
        toStoredProc.Params.AddParam ('inComment',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inEMail',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Users set MemberId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbMember);
end;

procedure TMainForm.pLoadGuide_Partner;
begin
     if (not cbPartner.Checked)or(not cbPartner.Enabled) then exit;
     //
     myEnabledCB(cbPartner);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Partner.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Partner.Erased as Erased');
        Add('     , Partner.Id_Postgres');
        Add('     , Partner.BrandID');
        Add('     , Partner.FabrikaID');
        Add('     , Partner.PeriodID');
        Add('     , Partner.PeriodYear');
        Add('     , Partner_parent_brand.Id_Postgres as ParentId_Postgres_brand');
        Add('     , Partner_parent_fabrika.Id_Postgres as ParentId_Postgres_fabrika');
        Add('     , Partner_parent_Period.Id_Postgres as ParentId_Postgres_Period');
        Add('from dba.Unit as    Partner');
        Add(' left outer join dba.Brand as Partner_parent_brand on Partner_parent_brand.Id =  Partner.BrandID');
        Add(' left outer join dba.Fabrika as Partner_parent_fabrika on Partner_parent_fabrika.Id =  Partner.FabrikaID');
        Add(' left outer join dba.Period as Partner_parent_Period on Partner_parent_Period.Id =  Partner.PeriodID');
        Add('where KindUnit = zc_kuIncome()');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Partner';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBrandId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFabrikaId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPeriodId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPeriodYear',ftFloat,ptInput, 0);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin   exit; end;
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBrandId').Value:=FieldByName('ParentId_Postgres_brand').AsFloat;
             toStoredProc.Params.ParamByName('inFabrikaId').Value:=FieldByName('ParentId_Postgres_fabrika').AsFloat;
             toStoredProc.Params.ParamByName('inPeriodId').Value:=FieldByName('ParentId_Postgres_Period').AsFloat;
             toStoredProc.Params.ParamByName('inPeriodYear').Value:=FieldByName('PeriodYear').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbPartner);
end;

procedure TMainForm.pLoadGuide_Period;
begin
     if (not cbPeriod.Checked)or(not cbPeriod.Enabled) then exit;
     //
     myEnabledCB(cbPeriod);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Period.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Period.PeriodName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Period.Erased as Erased');
        Add('     , Period.Id_Postgres');
        Add('from dba.Period');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Period';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Period set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbPeriod);
end;

procedure TMainForm.pLoadGuide_PriceList;
begin
     if (not cbPriceList.Checked)or(not cbPriceList.Enabled) then exit;
     //
     myEnabledCB(cbPriceList);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select');
        Add('  PriceList.Id as ObjectId');
        Add(', 0 as ObjectCode');
        Add(', PriceList.PriceListName as ObjectName');
        Add(', zc_erasedDel() as zc_erasedDel');
        Add(', PriceList.Erased as Erased');
        Add(', PriceList.Id_Postgres');
        Add(', valuta.Id_Postgres as ValutaID');
        Add('from DBA.PriceList ');
        Add('left outer join valuta on valuta.id = PriceList.valutaid');
        Add('order by  ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_PriceList';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCurrencyId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin  exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inCurrencyId').Value:=FieldByName('ValutaId').AsString;
             //

             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.PriceList set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             if FieldByName('ObjectId').AsInteger=13
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_PriceList_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbPriceList);
end;

procedure TMainForm.pLoadDocuments_DiscountPeriodItem;
begin
     if (not cbDiscountPeriodItem.Checked)or(not cbDiscountPeriodItem.Enabled) then exit;
     //
     myEnabledCB(cbDiscountPeriodItem);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select DISTINCT');
        Add('  DiscountTaxItems.Id as ObjectId');
        Add(', Unit.Id_Postgres as UnitId');
        Add(', BillItemsIncome.GoodsId_Postgres as GoodsID');
        Add(', DiscountTaxItems.StartDate as OperDate');
        Add(', DiscountTaxItems.PercentTax as Value');
        Add(', DiscountTaxItems.Id_Postgres');
        Add('from DBA.DiscountTaxItems');
        Add('     left outer join Unit on Unit.id = DiscountTaxItems.UnitID');
        Add('     left outer join BillItemsIncome on BillItemsIncome.ID= DiscountTaxItems.BillItemsIncomeID');
        Add('where BillItemsIncome.GoodsId_Postgres is not null');  // ��� ������ ������ ��� ������������ � �������� �������� �� �������
        Add('  and (DiscountTaxItems.PercentTax <> 0 or DiscountTaxItems.StartDate <> zc_DateStart())'); //
        Add('order by StartDate');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inValue',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsLast',ftBoolean,ptInput, True);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin  exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inUnitId').Value:=FieldByName('UnitId').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsString;
             toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Value').AsString;
             //

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.DiscountTaxItems set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbDiscountPeriodItem);
end;


procedure TMainForm.pLoadDocuments_PriceListItem;
begin
     if (not cbPriceListItem.Checked)or(not cbPriceListItem.Enabled) then exit;
     //
     myEnabledCB(cbPriceListItem);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select DISTINCT');
        Add('  PriceListItems.Id as ObjectId');
        Add(', PriceList.Id_Postgres as PriceListID');
        Add(', BillItemsIncome.GoodsId_Postgres as GoodsId ');
        Add(', PriceListItems.StartDate as OperDate');
        Add(', PriceListItems.NewPrice as Value');
        Add(', PriceListItems.Id_Postgres');
        Add('from DBA.PriceListItems');
        Add('     left outer join PriceList on PriceList.id = PriceListItems.PriceListID');
        Add('     left outer join BillItemsIncome on BillItemsIncome.GoodsID= PriceListItems.goodsid');
        Add('where BillItemsIncome.GoodsId_Postgres is not null'); // ��� ������ ������ ��� ������������ � �������� �������� �� �������
        Add('  and PriceListItems.NewPrice <> 0'); //
        Add('order by StartDate');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_ObjectHistory_PriceListItemLast';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inPriceListId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inGoodsId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inValue',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inIsLast',ftBoolean,ptInput, True);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin  exit;end;

             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPriceListId').Value:=FieldByName('PriceListId').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId').AsInteger;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inValue').Value:=FieldByName('Value').AsFloat;
             //

             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.PriceListItems set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //

             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbPriceListItem);
end;

procedure TMainForm.pLoadGuide_Unit;
var BankAccountId : Integer;
begin
     if (not cbUnit.Checked)or(not cbUnit.Enabled) then exit;
     //
     myEnabledCB(cbUnit);
     //
     // ������� - ������� 1 ��������� ���� - ���� ��� ���
     fOpenSqToQuery_two(' select case when Id_Find > 0 THEN Id_Find'
                       +'             else (SELECT tmp.ioId from gpInsertUpdate_Object_BankAccount (0, 0, ''��������� ���� ��� ����'', 0, 0, zc_Currency_GRN(), zfCalc_UserAdmin()) as tmp)'
                       +'         end as Id'
                       +' from (SELECT MIN (Id) AS Id_Find FROM Object WHERE DescId = zc_Object_BankAccount() AND isErased = FALSE) AS tmp');
     BankAccountId:= toSqlQuery_two.FieldByName('Id').Value;
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('    , 0 as ObjectCode');
        Add('    , Unit.UnitName as ObjectName');
        Add('    , if Unit.ParentId<> 200 then  Unit.ParentId else 0 endif as  IDParentId ');
        Add('    ,  Parent.Id_Postgres as ParentId ');
        Add('    , zc_erasedDel() as zc_erasedDel');
        Add('    , Unit.Erased as Erased');
        Add('    , Unit.Id_Postgres');
        Add('     , case');
        Add('       when ObjectId = 204 then 979');    //������� Terri-Luxury- ����� Terri
        Add('       when ObjectId = 234 then 980');    //������� SAVOY       - ����� SAVOY
        Add('       when ObjectId = 235 then 0');      //������� MaxMara     -
        Add('       when ObjectId = 240 then 6383');   //������� 5 �������   - ����� 5�������
        Add('       when ObjectId = 969 then 0');      //������� Sopra       -
        Add('       when ObjectId = 978 then 0');      //������� Vintag      -
        Add('       when ObjectId = 1121 then 5438');  //������� CHADO       - ����� CHADO
        Add('       when ObjectId = 4646 then 981');   //��.Vintag           - ����� Vintag
        Add('       when ObjectId = 4647 then 0');     //������� Vintag 50   -
        Add('       when ObjectId = 5727 then 0');     //������� Savoy-P.Z.  -
        Add('       when ObjectId = 7360 then 0');     //������� Vintag 90   -
        Add('       when ObjectId = 11425 then 0');    //������� Vintag 80   -
        Add('       when ObjectId = 11772 then 979');  //������� �����-Out   - ����� Terri
        Add('       when ObjectId = 20484 then 0');    //������� ESCADA      -
        Add('       when ObjectId = 29018 then 0')  ;  //������� Savoy-O     -
        Add('       end   as IDChildId');
        Add('     , Child.Id_Postgres as ChildId');
        Add('     , case when ObjectId = 4646 then 0 else ' + IntToStr(BankAccountId) + ' end as BankAccountId');

        Add('from dba.Unit');
        Add('     left outer join Unit as Parent on Parent.id = IDParentId ');
        Add('     left outer join Unit as Child on Child.Id = IDChildId');
        Add('where Unit.KindUnit =  zc_kuUnit() or Unit.id = 4646');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Unit';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('ioCode',ftInteger,ptInput, 0);  // ���� io �� ptInput ��� ��� ���� ����� 1 �����
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inAddress',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPhone',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inDiscountTax',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inChildId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBankAccountId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inAccountDirectionId',ftInteger,ptInput, 0);
        //

        while not EOF do
        begin

             //!!!
             if fStop then begin   exit; end;
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId').AsInteger;
             toStoredProc.Params.ParamByName('inChildId').Value:=FieldByName('ChildId').AsInteger;
             toStoredProc.Params.ParamByName('inBankAccountId').Value:=FieldByName('BankAccountId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbUnit);
end;

procedure TMainForm.pLoadGuide_User;
begin
       if (not cbUser.Checked)or(not cbUser.Enabled) then exit;
     //
     myEnabledCB(cbUser);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Users.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Users.UsersName as UserName');
        Add('     , ''int''Users.UsersPassword as Password');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Users.Erased as Erased');
        Add('     , Users.MemberId_Postgres as MemberId');
        Add('     , Users.UserId_Postgres as Id_Postgres');
        Add('from dba.Users where haschildren = -1');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_User';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inUserName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inPassword',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inMemberId',ftInteger,ptInput, 0);

        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inUserName').Value:=FieldByName('UserName').AsString;
             toStoredProc.Params.ParamByName('inPassword').Value:=FieldByName('Password').AsString;
             toStoredProc.Params.ParamByName('inMemberId').Value:=FieldByName('MemberId').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Users set UserId_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbUser);
end;

procedure TMainForm.pLoadGuide_Valuta;
begin
     if (not cbValuta.Checked)or(not cbValuta.Enabled) then exit;
     //
     myEnabledCB(cbValuta);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Valuta.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Valuta.ValutaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Valuta.Erased as Erased');
        Add('     , Valuta.Id_Postgres');
        Add('from dba.Valuta');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Currency';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Valuta set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);

             if FieldByName('ObjectId').AsInteger=1 // ��� - Basis
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('ObjectId').AsInteger=1 // ���
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_GRN() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('ObjectId').AsInteger=2 // EUR
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_EUR() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('ObjectId').AsInteger=5 // $
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_USD() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;

     end;
     //
     myDisabledCB(cbValuta);
end;


procedure TMainForm.pLoad_Chado;
begin

end;

end.


{
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

