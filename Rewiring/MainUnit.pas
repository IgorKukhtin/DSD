unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes,
  System.Variants, System.Classes, Vcl.Graphics, System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBarBuiltInMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, Vcl.StdCtrls, cxPC,
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, Vcl.ExtCtrls, cxContainer, cxEdit, cxTextEdit, cxMemo, cxLabel,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxProgressBar, DataModul, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, dxDateRanges, cxDBData, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, Datasnap.DBClient, cxCurrencyEdit,
  DateUtils, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, Vcl.Buttons,
  cxGridBandedTableView, cxGridDBBandedTableView, Datasnap.Provider,
  cxGridDBDataDefinitions;

type
  TMainForm = class(TForm)
    cxPageControl: TcxPageControl;
    cxTabSheetProcess: TcxTabSheet;
    cxTabSheetSettings: TcxTabSheet;
    grpSlave: TGroupBox;
    lbSlaveServer: TLabel;
    lbSlaveDatabase: TLabel;
    lbSlaveUser: TLabel;
    lbSlavePassword: TLabel;
    lbSlavePort: TLabel;
    edtSlaveServer: TEdit;
    edtSlaveDatabase: TEdit;
    edtSlaveUser: TEdit;
    edtSlavePassword: TEdit;
    edtSlavePort: TEdit;
    grpMaster: TGroupBox;
    lbDatabase: TLabel;
    lbMasterUser: TLabel;
    lbMasterPort: TLabel;
    lbMasterPassword: TLabel;
    edtMasterDatabase: TEdit;
    edtMasterUser: TEdit;
    edtMasterPort: TEdit;
    edtMasterPassword: TEdit;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    grpScripts: TGroupBox;
    pnlScriptBottom: TPanel;
    btnCheckВase: TButton;
    pnlScriptTop: TPanel;
    lbScriptPath: TLabel;
    pnlScriptList: TPanel;
    edtScriptPath: TEdit;
    btnScriptPath: TButton;
    mmoScriptLog: TcxMemo;
    opndlgMain: TFileOpenDialog;
    ZQueryExecute: TZQuery;
    btnUpdateSleve: TButton;
    GroupBox1: TGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    deDateStartDate: TcxDateEdit;
    deStartDate: TcxDateEdit;
    deEndDate: TcxDateEdit;
    btnUpdateMaster: TButton;
    grpProcessing: TGroupBox;
    Panel2: TPanel;
    btnReadInfo: TButton;
    Panel3: TPanel;
    mmoScriptLogRewiring: TcxMemo;
    btnHistoryCost: TButton;
    pbProcess: TcxProgressBar;
    lblActionTake: TcxLabel;
    btnEqualizationBreak: TButton;
    pnlInfoProcess: TPanel;
    edtMasterUserRun: TEdit;
    Label2: TLabel;
    cxLabel6: TcxLabel;
    edCountThread: TcxCurrencyEdit;
    edtMasterServer: TEdit;
    lbMasterServer: TLabel;
    edtMasterServerIn: TEdit;
    Label5: TLabel;
    edtSlaveServerIn: TEdit;
    Label6: TLabel;
    cxLabel5: TcxLabel;
    edSession: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    isCalculate: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    Process: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    HistoryCost_BranchDS: TDataSource;
    HistoryCost_BranchCDS: TClientDataSet;
    TimerHistoryCost: TTimer;
    edtSlavePasswordRC: TEdit;
    Label3: TLabel;
    edtSlaveUserRC: TEdit;
    Label4: TLabel;
    btnCreateUserRC: TButton;
    cxPageProcessing: TcxPageControl;
    tsPageProcessingEmpty: TcxTabSheet;
    tsPageProcessingHistoryCost: TcxTabSheet;
    tsPageProcessingRewiring: TcxTabSheet;
    btnRewiring: TButton;
    btnSendDocument: TButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    RewiringisCalculate: TcxGridDBColumn;
    RewiringPosition: TcxGridDBColumn;
    RewiringStartDate: TcxGridDBColumn;
    RewiringEndDate: TcxGridDBColumn;
    RewiringGroupName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    Rewiring_BranchDS: TDataSource;
    Rewiring_BranchCDS: TClientDataSet;
    TimerRewiring: TTimer;
    RewiringProcess: TcxGridDBColumn;
    btnCopyFunction: TButton;
    RewiringIsBefoHistoryCost: TcxGridDBColumn;
    cxTabSheetCheckingHC: TcxTabSheet;
    Panel1: TPanel;
    deStartDateCheckingHC: TcxDateEdit;
    deEndDateCheckingHC: TcxDateEdit;
    cxLabel4: TcxLabel;
    cxLabel7: TcxLabel;
    cxgCheckingHC: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxLabel8: TcxLabel;
    BranchDS: TDataSource;
    BranchCDS: TClientDataSet;
    cbBranchCheckingHC: TcxLookupComboBox;
    sbRunCheckingHC: TSpeedButton;
    CheckingHCDS: TDataSource;
    CheckingHCCDS: TClientDataSet;
    cxgCheckingHCDBBandedTableView1: TcxGridDBBandedTableView;
    cxgCheckingHCLevel1: TcxGridLevel;
    cxgCheckingHCDBBandedTableView2: TcxGridDBBandedTableView;
    CheckingHC_ContainerId: TcxGridDBBandedColumn;
    CheckingHCD_StartDate: TcxGridDBBandedColumn;
    CheckingHC_EndDate: TcxGridDBBandedColumn;
    CheckingHC_MPrice: TcxGridDBBandedColumn;
    CheckingHC_MStartCount: TcxGridDBBandedColumn;
    CheckingHC_MStartSumm: TcxGridDBBandedColumn;
    CheckingHC_MIncomeCount: TcxGridDBBandedColumn;
    CheckingHC_MIncomeSumm: TcxGridDBBandedColumn;
    CheckingHC_MCalcCount: TcxGridDBBandedColumn;
    CheckingHC_MCalcSumm: TcxGridDBBandedColumn;
    CheckingHC_MOutCount: TcxGridDBBandedColumn;
    CheckingHC_MOutSumm: TcxGridDBBandedColumn;
    CheckingHC_MPrice_external: TcxGridDBBandedColumn;
    CheckingHC_MCalcCount_external: TcxGridDBBandedColumn;
    CheckingHC_SStartCount: TcxGridDBBandedColumn;
    CheckingHC_SPrice: TcxGridDBBandedColumn;
    CheckingHC_SCalcSumm_external: TcxGridDBBandedColumn;
    CheckingHC_SCalcCount_external: TcxGridDBBandedColumn;
    CheckingHC_SStartSumm: TcxGridDBBandedColumn;
    CheckingHC_SIncomeCount: TcxGridDBBandedColumn;
    CheckingHC_SIncomeSumm: TcxGridDBBandedColumn;
    CheckingHC_SOutSumm: TcxGridDBBandedColumn;
    CheckingHC_SCalcCount: TcxGridDBBandedColumn;
    CheckingHC_SCalcSumm: TcxGridDBBandedColumn;
    CheckingHC_SOutCount: TcxGridDBBandedColumn;
    CheckingHC_SPrice_external: TcxGridDBBandedColumn;
    CheckingHC_MCalcSumm_external: TcxGridDBBandedColumn;
    cxStyleRepository: TcxStyleRepository;
    cxStyle1: TcxStyle;
    TimerCheckingHistoryCost: TTimer;
    CheckingHC_DPrice: TcxGridDBBandedColumn;
    CheckingHC_PPrice: TcxGridDBBandedColumn;
    Panel4: TPanel;
    rgStepRewiring: TRadioGroup;
    rgMICSlave: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnScriptPathClick(Sender: TObject);
    procedure btnCheckВaseClick(Sender: TObject);
    procedure cxPageControlPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure btnUpdateMasterClick(Sender: TObject);
    procedure btnUpdateSleveClick(Sender: TObject);
    procedure btnReadInfoClick(Sender: TObject);
    procedure TimerHistoryCostTimer(Sender: TObject);
    procedure btnHistoryCostClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEqualizationBreakClick(Sender: TObject);
    procedure btnCreateUserRCClick(Sender: TObject);
    procedure btnRewiringClick(Sender: TObject);
    procedure btnSendDocumentClick(Sender: TObject);
    procedure TimerRewiringTimer(Sender: TObject);
    procedure btnCopyFunctionClick(Sender: TObject);
    procedure sbRunCheckingHCClick(Sender: TObject);
    procedure cxgCheckingHCDBBandedTableView2StylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure TimerCheckingHistoryCostTimer(Sender: TObject);
    procedure rgStepRewiringClick(Sender: TObject);
  private
    { Private declarations }

    FListProcessing: TStringList;
    FisProcessingEmpty: Boolean;
    FTerminated: Boolean;

    FMasterUUId : String;
    FSlaveUUId : String;
    FStyle: TcxStyle;

    procedure ReadSettings;
    procedure ReadInfo;
    procedure WriteSettings;
    function GetInfoMaster : Boolean;
    function GetInfoSlave : Boolean;
    function GetInfoSlavePostgres : Boolean;

    procedure HistoryCostThreadFinish(AError : String; ABranchId : Integer);
    procedure HistoryCostThreadProcess(AText : String; ABranchId : Integer);
    procedure RewiringThreadFinish(AError : String; AGroupId : Integer);
    procedure RewiringThreadProcess(AText: String; AGroupId, APosition, AMax : Integer);
    procedure SendMovementThreadFinish(AError : String; AGroupId : Integer);
    procedure SendMovementThreadProcess(AText: String; AGroupId, APosition, AMax : Integer);
    procedure FunctionThreadFinish(AError : String; AGroupId : Integer);
    procedure FunctionThreadProcess(AText: String; AGroupId, APosition, AMax : Integer);
    procedure CheckingHistoryCostThreadFinish(AError : String; AisMaster : Boolean; AUUId : String);
  public
    { Public declarations }
    procedure SaveRewiringLog(ALogMessage: string; AShowMessage: Boolean = False);
    function LiadScripts(AFileName : String) : String;
    function CheckDB : boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses System.Math, System.IOUtils, UnitSettings, UnitConst, ThreaHistoryCostUnit,
     ThreaRewiringUnit, ThreaSendMovementUnit, ThreaFunctionUnit,
     ThreaCheckingHistoryCostUnit;

procedure LoadDataToCDS(ADst: TClientDataSet; AZQuery: TZQuery);
  var DataSetProvider: TDataSetProvider;
      ClientDataSet: TClientDataSet;
begin

  try
    if AZQuery.RecordCount < 1 then Exit;

    DataSetProvider := TDataSetProvider.Create(Application);
    DataSetProvider.Name := 'DataSetProvider';
    DataSetProvider.DataSet := AZQuery;
    ClientDataSet := TClientDataSet.Create(Application);
    ClientDataSet.ProviderName := DataSetProvider.Name;
    try

      ClientDataSet.Active := True;

      if ADst.Active then ADst.Close;

      ADst.AppendData(ClientDataSet.Data, False);

    finally
      ClientDataSet.Free;
      DataSetProvider.Free;
    end;
  Except on E: Exception do
    MainForm.SaveRewiringLog('Ошибка переноса данных ' + E.Message);
  end;
end;

procedure TMainForm.SaveRewiringLog(ALogMessage: string; AShowMessage: Boolean = False);
var F: TextFile;
    cFile: string;
begin
  if cxPageControl.Properties.ActivePage = cxTabSheetProcess then
    mmoScriptLogRewiring.Lines.Add(ALogMessage)
  else mmoScriptLog.Lines.Add(ALogMessage);

  cFile := ExtractFilePath(ParamStr(0))+'\Rewiring.log';
  AssignFile(F, cFile);
  if FileExists(cFile) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, DateTimeToStr(Now) + ' : ' + StringReplace(ALogMessage, #13#10, ' ', [rfReplaceAll]));
  CloseFile(F);
  if AShowMessage then ShowMessage(ALogMessage);
end;

procedure TMainForm.sbRunCheckingHCClick(Sender: TObject);
  var CheckingHistoryCostThread: TCheckingHistoryCostThread;
begin
  if MessageDlg('Запустить проверку перерасчета цен?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

  FMasterUUId := '';
  FSlaveUUId := '';

  FTerminated := False;
  cxPageProcessing.ActivePage := tsPageProcessingEmpty;
  cxPageControl.ActivePage := cxTabSheetProcess;

  cxTabSheetSettings.TabVisible := False;
  cxTabSheetCheckingHC.TabVisible := False;

  btnReadInfo.Enabled := False;
  btnHistoryCost.Enabled := False;
  btnRewiring.Enabled := False;
  btnSendDocument.Enabled := False;

  cxGrid1DBTableView1.OptionsData.Editing := False;
  FisProcessingEmpty := False;

  lblActionTake.Caption := 'Проверка HistoryCost';
  pbProcess.Properties.Marquee := True;

  SaveRewiringLog('Запуск потоков получения данных для "Проверка HistoryCost".');

  // Запуск расчета на слейве
  CheckingHistoryCostThread := TCheckingHistoryCostThread.Create(True);
  CheckingHistoryCostThread.FreeOnTerminate:=True;
  CheckingHistoryCostThread.HostName := MainForm.edtSlaveServer.Text;
  CheckingHistoryCostThread.Database := MainForm.edtSlaveDatabase.Text;
  CheckingHistoryCostThread.User := MainForm.edtSlaveUser.Text;
  CheckingHistoryCostThread.Password := MainForm.edtSlavePassword.Text;
  CheckingHistoryCostThread.Port := StrToInt(MainForm.edtSlavePort.Text);
  CheckingHistoryCostThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;

  CheckingHistoryCostThread.isMaster := False;
  CheckingHistoryCostThread.BranchId := cbBranchCheckingHC.EditValue;;
  CheckingHistoryCostThread.StartDate := deStartDateCheckingHC.Date;
  CheckingHistoryCostThread.EndDate := deEndDateCheckingHC.Date;
  CheckingHistoryCostThread.Session := edSession.Text;

  CheckingHistoryCostThread.OnFinish := CheckingHistoryCostThreadFinish;

  FListProcessing.AddObject('1', CheckingHistoryCostThread);
  CheckingHistoryCostThread.Resume;

  // Запуск расчета на мастере
  CheckingHistoryCostThread := TCheckingHistoryCostThread.Create(True);
  CheckingHistoryCostThread.FreeOnTerminate:=True;
  CheckingHistoryCostThread.HostName := MainForm.edtSlaveServer.Text;
  CheckingHistoryCostThread.Database := MainForm.edtSlaveDatabase.Text;
  CheckingHistoryCostThread.User := MainForm.edtSlaveUser.Text;
  CheckingHistoryCostThread.Password := MainForm.edtSlavePassword.Text;
  CheckingHistoryCostThread.Port := StrToInt(MainForm.edtSlavePort.Text);
  CheckingHistoryCostThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;

  CheckingHistoryCostThread.isMaster := True;
  CheckingHistoryCostThread.BranchId := cbBranchCheckingHC.EditValue;;
  CheckingHistoryCostThread.StartDate := deStartDateCheckingHC.Date;
  CheckingHistoryCostThread.EndDate := deEndDateCheckingHC.Date;
  CheckingHistoryCostThread.Session := edSession.Text;

  CheckingHistoryCostThread.OnFinish := CheckingHistoryCostThreadFinish;

  FListProcessing.AddObject('2', CheckingHistoryCostThread);
  CheckingHistoryCostThread.Resume;

  FisProcessingEmpty := True;

end;

procedure TMainForm.TimerCheckingHistoryCostTimer(Sender: TObject);
  var pZConnection: TZConnection; pZQuery: TZQuery;
begin
  TimerCheckingHistoryCost.Enabled := False;
  try
    if (FMasterUUId <> '') and (FSlaveUUId <> '') then
    begin
      SaveRewiringLog('Открытие отчета "Проверка HistoryCost".');
      try

        try
          pZConnection := TZConnection.Create(Nil);
          pZConnection.Protocol := 'postgresql-9';
          pZConnection.HostName :=  edtSlaveServer.Text;
          pZConnection.Database :=  edtSlaveDatabase.Text;
          pZConnection.User     :=  edtSlaveUser.Text;
          pZConnection.Password :=  edtSlavePassword.Text;
          pZConnection.Port     :=  StrToInt(edtSlavePort.Text);
          pZConnection.LibraryLocation := ZConnection.LibraryLocation;
          pZConnection.Connect;

          pZQuery := TZQuery.Create(Nil);
          pZQuery.Connection := pZConnection;
          pZQuery.SQL.Text := cSQLSelect_CheckingHistoryCost;
          pZQuery.ParamByName('inMasterUUId').Value := FMasterUUId;
          pZQuery.ParamByName('inSlaveUUId').Value := FSlaveUUId;
          pZQuery.ParamByName('inSession').Value := edSession.Text;
          pZQuery.Open;

          SaveRewiringLog('Перенос данных "Проверка HistoryCost".');
          LoadDataToCDS(CheckingHCCDS, pZQuery);
        finally
          pZQuery.Close;
          pZConnection.Disconnect;
          FreeAndNil(pZQuery);
          FreeAndNil(pZConnection);
        end;
      except
        on E: Exception do
          SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));

      end;
    end;
  finally
    cxTabSheetSettings.TabVisible := True;
    cxTabSheetCheckingHC.TabVisible := True;
    cxPageControl.ActivePage := cxTabSheetCheckingHC;

    btnReadInfo.Enabled := True;
    btnHistoryCost.Enabled := True;
    btnRewiring.Enabled := True;
    btnSendDocument.Enabled := True;

    cxGrid1DBTableView1.OptionsData.Editing := True;
    lblActionTake.Caption := 'Ожидание задания';
    pbProcess.Properties.Marquee := False;
    pbProcess.Properties.ShowTextStyle := cxtsPercent;
    pbProcess.Position := 0;
  end;
end;

procedure TMainForm.TimerHistoryCostTimer(Sender: TObject);
  var HistoryCostThread: THistoryCostThread;
begin
  TimerHistoryCost.Enabled := False;
  HistoryCost_BranchCDS.DisableControls;
  try

    if not FisProcessingEmpty and not FTerminated and
      (FListProcessing.Count < edCountThread.Value) then
    begin

      HistoryCost_BranchCDS.First;
      while not HistoryCost_BranchCDS.Eof do
      begin
        if HistoryCost_BranchCDS.FieldByName('isCalculate').AsBoolean then Break;
        HistoryCost_BranchCDS.Next;
      end;

      if HistoryCost_BranchCDS.FieldByName('isCalculate').AsBoolean then
      begin
        HistoryCost_BranchCDS.Edit;
        HistoryCost_BranchCDS.FieldByName('isCalculate').AsBoolean := False;
        HistoryCost_BranchCDS.FieldByName('Process').AsString := 'Запуск расчета';
        HistoryCost_BranchCDS.Post;

        HistoryCostThread := THistoryCostThread.Create(True);
        HistoryCostThread.FreeOnTerminate:=True;
        HistoryCostThread.HostName := MainForm.edtSlaveServer.Text;
        HistoryCostThread.Database := MainForm.edtSlaveDatabase.Text;
        HistoryCostThread.User := MainForm.edtSlaveUser.Text;
        HistoryCostThread.Password := MainForm.edtSlavePassword.Text;
        HistoryCostThread.Port := StrToInt(MainForm.edtSlavePort.Text);
        HistoryCostThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;

        HistoryCostThread.BranchId := HistoryCost_BranchCDS.FieldByName('BranchId').AsInteger;
        HistoryCostThread.BranchName := HistoryCost_BranchCDS.FieldByName('BranchName').AsString;
        HistoryCostThread.StartDate := HistoryCost_BranchCDS.FieldByName('StartDate').AsDateTime;
        HistoryCostThread.EndDate := HistoryCost_BranchCDS.FieldByName('EndDate').AsDateTime;
        HistoryCostThread.isMICSlave := rgMICSlave.ItemIndex = 1;
        HistoryCostThread.Session := edSession.Text;

        HistoryCostThread.OnFinish := HistoryCostThreadFinish;
        HistoryCostThread.OnProcess := HistoryCostThreadProcess;

        FListProcessing.AddObject(HistoryCost_BranchCDS.FieldByName('BranchId').AsString, HistoryCostThread);
        HistoryCostThread.Resume;
      end else FisProcessingEmpty := True;

    end;

    if FListProcessing.Count = 0 then
    begin
      cxTabSheetSettings.TabVisible := True;
      cxTabSheetCheckingHC.TabVisible := True;

      btnReadInfo.Enabled := True;
      btnHistoryCost.Enabled := True;
      btnRewiring.Enabled := True;
      btnSendDocument.Enabled := True;
      rgMICSlave.Enabled := True;

      cxGrid1DBTableView1.OptionsData.Editing := True;
      lblActionTake.Caption := 'Ожидание задания';
      pbProcess.Properties.Marquee := False;
      pbProcess.Properties.ShowTextStyle := cxtsPercent;
    end;

  finally
    HistoryCost_BranchCDS.EnableControls;
    TimerHistoryCost.Enabled := FListProcessing.Count > 0;
  end;
end;

procedure TMainForm.TimerRewiringTimer(Sender: TObject);
  var RewiringThread: TRewiringThread;
begin
  TimerRewiring.Enabled := False;
  Rewiring_BranchCDS.DisableControls;
  try

    if not FisProcessingEmpty and not FTerminated and
      (FListProcessing.Count < edCountThread.Value) then
    begin

      Rewiring_BranchCDS.First;
      while not Rewiring_BranchCDS.Eof do
      begin
        if Rewiring_BranchCDS.FieldByName('isCalculate').AsBoolean then Break;
        Rewiring_BranchCDS.Next;
      end;

      if Rewiring_BranchCDS.FieldByName('isCalculate').AsBoolean then
      begin
        Rewiring_BranchCDS.Edit;
        Rewiring_BranchCDS.FieldByName('isCalculate').AsBoolean := False;
        Rewiring_BranchCDS.FieldByName('Process').AsString := 'Запуск расчета';
        Rewiring_BranchCDS.Post;

        RewiringThread := TRewiringThread.Create(True);
        RewiringThread.FreeOnTerminate:=True;
        RewiringThread.HostName := MainForm.edtSlaveServer.Text;
        RewiringThread.Database := MainForm.edtSlaveDatabase.Text;
        RewiringThread.User := MainForm.edtSlaveUserRC.Text;
        RewiringThread.Password := MainForm.edtSlavePasswordRC.Text;
        RewiringThread.Port := StrToInt(MainForm.edtSlavePort.Text);
        RewiringThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;

        RewiringThread.GroupId := Rewiring_BranchCDS.FieldByName('GroupId').AsInteger;
        RewiringThread.GroupName := Rewiring_BranchCDS.FieldByName('GroupName').AsString;
        RewiringThread.StartDate := Rewiring_BranchCDS.FieldByName('StartDate').AsDateTime;
        RewiringThread.EndDate := Rewiring_BranchCDS.FieldByName('EndDate').AsDateTime;
        RewiringThread.IsSale := Rewiring_BranchCDS.FieldByName('IsSale').AsBoolean;
        RewiringThread.IsBefoHistoryCost := Rewiring_BranchCDS.FieldByName('IsBefoHistoryCost').AsBoolean;
        RewiringThread.StepRewiring := rgStepRewiring.ItemIndex;
        RewiringThread.Session := edSession.Text;

        RewiringThread.OnFinish := RewiringThreadFinish;
        RewiringThread.OnProcess := RewiringThreadProcess;

        FListProcessing.AddObject(Rewiring_BranchCDS.FieldByName('GroupId').AsString, RewiringThread);
        RewiringThread.Resume;
      end else FisProcessingEmpty := True;

    end;

    if FListProcessing.Count = 0 then
    begin
      cxTabSheetSettings.TabVisible := True;
      cxTabSheetCheckingHC.TabVisible := True;

      btnReadInfo.Enabled := True;
      btnHistoryCost.Enabled := True;
      btnRewiring.Enabled := True;
      btnSendDocument.Enabled := True;
      rgStepRewiring.Enabled := True;

      cxGrid1DBTableView1.OptionsData.Editing := True;
      lblActionTake.Caption := 'Ожидание задания';
      pbProcess.Properties.Marquee := False;
      pbProcess.Properties.ShowTextStyle := cxtsPercent;
    end;

  finally
    Rewiring_BranchCDS.EnableControls;
    TimerRewiring.Enabled := FListProcessing.Count > 0;
  end;
end;

function TMainForm.LiadScripts(AFileName : String) : String;
var cFile: string;
begin
  cFile := edtScriptPath.Text + AFileName;
  if FileExists(cFile) then Result := TFile.ReadAllText(cFile)
  else raise Exception.Create('Ошибка файл ' + cFile + ' не найден.');
end;

function TMainForm.GetInfoMaster : Boolean;
begin
  Result := False;
  SaveRewiringLog('Подключение к Master к базе ' + edtMasterDatabase.Text);
  try
    ZConnection.Disconnect;
    ZConnection.HostName :=  edtMasterServer.Text;
    ZConnection.Database :=  edtMasterDatabase.Text;
    ZConnection.User     :=  edtMasterUser.Text;
    ZConnection.Password :=  edtMasterPassword.Text;
    ZConnection.Port     :=  StrToInt(edtMasterPort.Text);

    ZConnection.Connect;
    Result := ZConnection.Connected;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TMainForm.GetInfoSlave : Boolean;
begin
  Result := False;
  SaveRewiringLog('Подключение к Slave к базе ' + edtSlaveDatabase.Text);
  try
    ZConnection.Disconnect;
    ZConnection.HostName :=  edtSlaveServer.Text;
    ZConnection.Database :=  edtSlaveDatabase.Text;
    ZConnection.User     :=  edtSlaveUser.Text;
    ZConnection.Password :=  edtSlavePassword.Text;
    ZConnection.Port     :=  StrToInt(edtSlavePort.Text);

    ZConnection.Connect;
    Result := ZConnection.Connected;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TMainForm.GetInfoSlavePostgres : Boolean;
begin
  Result := False;
  SaveRewiringLog('Подключение к Slave к базе postgres');
  try
    ZConnection.Disconnect;
    ZConnection.HostName :=  edtSlaveServer.Text;
    ZConnection.Database :=  'postgres';
    ZConnection.User     :=  edtSlaveUser.Text;
    ZConnection.Password :=  edtSlavePassword.Text;
    ZConnection.Port     :=  StrToInt(edtSlavePort.Text);

    ZConnection.Connect;
    Result := ZConnection.Connected;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnCheckВaseClick(Sender: TObject);
  var cEncodings, S, MovementDesc : String; List : TStringList; I, nReplServerId : Integer;
begin
  if not GetInfoMaster then Exit;
  try
    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtMasterDatabase.Text]);
    ZQuery.Open;
    SaveRewiringLog('Версия сервера: ' + ZQuery.FieldByName('Version').AsString);
    SaveRewiringLog('Кодировка: ' + ZQuery.FieldByName('Encodings').AsString);

    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('Не мастере не найдена схема <_replica> работа невозможна.');
      Exit;
    end;

    if not GetInfoSlave then Exit;

    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtSlaveDatabase.Text]);
    ZQuery.Open;
    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('Не слейве не найдена схема <_replica> работа невозможна.');
      Exit;
    end;

    SaveRewiringLog('Проверка подключений прошла успешно.');

  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TMainForm.CheckDB : boolean;
begin
  Result := False;
  if not GetInfoMaster then Exit;
  try
    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtMasterDatabase.Text]);
    ZQuery.Open;
    SaveRewiringLog('Версия сервера: ' + ZQuery.FieldByName('Version').AsString);
    SaveRewiringLog('Кодировка: ' + ZQuery.FieldByName('Encodings').AsString);

    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('Не мастере не найдена схема <_replica> работа невозможна.');
      Exit;
    end;

    if not GetInfoSlave then Exit;

    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtSlaveDatabase.Text]);
    ZQuery.Open;
    SaveRewiringLog('Версия сервера: ' + ZQuery.FieldByName('Version').AsString);
    SaveRewiringLog('Кодировка: ' + ZQuery.FieldByName('Encodings').AsString);

    Result := True;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

end;

procedure TMainForm.cxgCheckingHCDBBandedTableView2StylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var S : string; I : Integer;
begin
  if Assigned(AItem) and (AItem.Properties is TcxCurrencyEditProperties) then
  begin
    S := TcxGridItemDBDataBinding(AItem.DataBinding).FieldName;
    if S[1] = 'S' then S[1] := 'M' else S[1] := 'S';

    for I := 0 to cxgCheckingHCDBBandedTableView2.ColumnCount - 1 do
      if (TcxGridItemDBDataBinding(cxgCheckingHCDBBandedTableView2.Columns[I].DataBinding).FieldName = S) then
        if (ARecord.Values[AItem.Index] <> ARecord.Values[cxgCheckingHCDBBandedTableView2.Columns[I].Index]) then
      begin
        FStyle.Assign(cxgCheckingHCDBBandedTableView2.Styles.Content);
        FStyle.TextColor := clRed;
        AStyle := FStyle;
      end;
  end;
end;

procedure TMainForm.cxPageControlPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if not CheckingHCCDS.Active and (NewPage = cxTabSheetCheckingHC) then
  begin
    deStartDateCheckingHC.Date := deStartDate.Date;
    deEndDateCheckingHC.Date := deEndDate.Date;
    if deEndDateCheckingHC.Date > Date then deEndDateCheckingHC.Date := IncDay(Date, - 1);


    if GetInfoMaster then
    begin
      try
        ZQueryExecute.Close;
        ZQueryExecute.SQL.Text := Format(cSQL_HistoryCost_Branch,
                                         [FormatDateTime('YYYY-MM-DD', deStartDate.Date),
                                          FormatDateTime('YYYY-MM-DD', deEndDate.Date),
                                          edSession.Text,
                                          FormatDateTime('YYYY-MM-DD', deStartDate.Date),
                                          FormatDateTime('YYYY-MM-DD', deEndDate.Date)]);
        ZQueryExecute.Open;

        BranchCDS.Close;
        BranchCDS.CreateDataSet;
        ZQueryExecute.First;
        while not ZQueryExecute.Eof do
        begin
          BranchCDS.Append;
          BranchCDS.FieldByName('BranchId').AsInteger := ZQueryExecute.FieldByName('BranchId').AsInteger;
          if ZQueryExecute.FieldByName('BranchName').AsString = '' then
            BranchCDS.FieldByName('BranchName').AsString := 'Без филиала'
          else BranchCDS.FieldByName('BranchName').AsString := ZQueryExecute.FieldByName('BranchName').AsString;
          BranchCDS.Post;
          ZQueryExecute.Next;
        end;
        BranchCDS.First;
        cbBranchCheckingHC.EditValue := 0;
      except
        on E: Exception do
          SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]), True);
      end;
      ZConnection.Disconnect;
    end;
  end;
end;

procedure TMainForm.btnUpdateMasterClick(Sender: TObject);
begin
  if not GetInfoMaster then Exit;
  try
    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtMasterDatabase.Text]);
    ZQuery.Open;
    SaveRewiringLog('Версия сервера: ' + ZQuery.FieldByName('Version').AsString);
    SaveRewiringLog('Кодировка: ' + ZQuery.FieldByName('Encodings').AsString);

    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('Не мастере не найдена схема <_replica> работа невозможна.');
      Exit;
    end;

//    // Создаем (обновляем) на мастере функцию загрузки HistoryCost
//    SaveRewiringLog('Создаем (обновляем) на мастере функцию выполнения HistoryCost');
//    ZQueryExecute.Close;
//    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Master_RewiringHistoryCost);
//    ZQueryExecute.ExecSQL;
//
//    // Создаем (обновляем) на мастере функцию загрузки перепроведенных документов
//    SaveRewiringLog('Создаем (обновляем) на мастере функцию загрузки перепроведенных документов');
//    ZQueryExecute.Close;
//    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Master_LoadMovement);
//    ZQueryExecute.ExecSQL;

    // Создаем функцию с пареметрами подключения е базе
    SaveRewiringLog('Создаем функцию с пареметрами подключения е базе');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := Format(LiadScripts(cSQLSP_Master_Connect),
        [edtSlaveServerIn.Text, edtSlaveDatabase.Text, edtSlavePort.Text, edtSlaveUser.Text,
         edtSlavePassword.Text]);
    ZQueryExecute.ExecSQL;

    SaveRewiringLog('Выполнено.');
    ZConnection.Disconnect;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnCopyFunctionClick(Sender: TObject);
  var FunctionThread: TFunctionThread;
begin

  if MessageDlg('Запустить копирование функций с мастера на слейв?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

  cxPageProcessing.ActivePage := tsPageProcessingEmpty;
  cxPageControl.ActivePage := cxTabSheetProcess;

  FTerminated := False;
  cxTabSheetSettings.TabVisible := False;
  cxTabSheetCheckingHC.TabVisible := False;

  btnReadInfo.Enabled := False;
  btnHistoryCost.Enabled := False;
  btnRewiring.Enabled := False;
  btnSendDocument.Enabled := False;

  cxGrid1DBTableView1.OptionsData.Editing := False;
  FisProcessingEmpty := False;

  FunctionThread := TFunctionThread.Create(True);
  FunctionThread.FreeOnTerminate:=True;
  FunctionThread.HostName := MainForm.edtSlaveServer.Text;
  FunctionThread.Database := MainForm.edtSlaveDatabase.Text;
  FunctionThread.User := MainForm.edtSlaveUser.Text;
  FunctionThread.Password := MainForm.edtSlavePassword.Text;
  FunctionThread.Port := StrToInt(MainForm.edtSlavePort.Text);
  FunctionThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;

  FunctionThread.Session := edSession.Text;

  FunctionThread.OnFinish := FunctionThreadFinish;
  FunctionThread.OnProcess := FunctionThreadProcess;

  FListProcessing.AddObject('1', FunctionThread);
  FunctionThread.Resume;
  FisProcessingEmpty := True;
end;

procedure TMainForm.btnCreateUserRCClick(Sender: TObject);
  var S : String;
begin
  try

    if edtSlaveUserRC.Text = '' then
    begin
      if GetInfoSlave then
      begin
        if MessageDlg('Создать роль на сервере ' + edtSlaveServer.Text +
           ' для перепроведения документов?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

        S := '';
        if not InputQuery('Создать роль на сервере ' + edtSlaveServer.Text, 'Имя роли для перепроведения документов', S) then Exit;
        if S = '' then Exit;

        SaveRewiringLog('Создание роли для загрузки изменений на сервере: ' + edtSlaveDatabase.Text);
        ZQuery.Close;
        ZQuery.SQL.Text := Format(cSQLCreateUser, [S, edtSlavePassword.Text, s, s]);
        ZQuery.ExecSQL;
        SaveRewiringLog('Роль: ' + S + ' на сервере ' + edtSlaveServer.Text + ' создана.');

        edtSlaveUserRC.Text := S;
        edtSlavePasswordRC.Text := edtSlavePassword.Text;

        SaveRewiringLog('Выполнено.');
        ZConnection.Disconnect;
      end;
    end;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

end;

procedure TMainForm.btnEqualizationBreakClick(Sender: TObject);
  var I : Integer;
begin
  if FListProcessing.Count = 0 then
  begin
    ShowMessage('Нет запущенных процессов.');
    Exit;
  end;


  if FTerminated then
  begin
    ShowMessage('Дождитесь завершения текущих процессов.');
    Exit;
  end;

  if MessageDlg('Прервать выполнение процессов?', mtInformation, mbOKCancel, 0) = mrOk then
    FTerminated := True;

  for I := 0 to FListProcessing.Count - 1 do TThread(FListProcessing.Objects[I]).Terminate;

end;

procedure TMainForm.btnHistoryCostClick(Sender: TObject);
begin

  if cxPageProcessing.ActivePage <> tsPageProcessingHistoryCost then
  begin
    cxPageProcessing.ActivePage := tsPageProcessingHistoryCost;
    ReadInfo;
    if rgMICSlave.ItemIndex < 0 then rgMICSlave.ItemIndex := 0;
    Exit;
  end;

  if not HistoryCost_BranchCDS.Active then Exit;
  if HistoryCost_BranchCDS.RecordCount <= 0 then Exit;
  if edSession.Text = '' then
  begin
    SaveRewiringLog('Не получена сессия пользователя.', True);
    Exit;
  end;

  if MessageDlg('Запустить выполнение перерасчета цен?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

  FTerminated := False;
  cxTabSheetSettings.TabVisible := False;
  cxTabSheetCheckingHC.TabVisible := False;

  btnReadInfo.Enabled := False;
  btnHistoryCost.Enabled := False;
  btnRewiring.Enabled := False;
  btnSendDocument.Enabled := False;
  rgMICSlave.Enabled := False;

  cxGrid1DBTableView1.OptionsData.Editing := False;
  FisProcessingEmpty := False;

  lblActionTake.Caption := 'Перерасчет цен';
  pbProcess.Properties.Marquee := True;

  TimerHistoryCost.Enabled := True;
end;

procedure TMainForm.btnReadInfoClick(Sender: TObject);
begin
  if FListProcessing.Count > 0 then Exit;
  ReadInfo;
end;

procedure TMainForm.btnRewiringClick(Sender: TObject);
begin
  if cxPageProcessing.ActivePage <> tsPageProcessingRewiring then
  begin
    cxPageProcessing.ActivePage := tsPageProcessingRewiring;
    ReadInfo;
    if rgStepRewiring.ItemIndex < 0 then rgStepRewiring.ItemIndex := 0;
    Exit;
  end;

  if MessageDlg('Запустить выполнение перепроведение докeментов?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

  FTerminated := False;
  cxTabSheetSettings.TabVisible := False;
  cxTabSheetCheckingHC.TabVisible := False;

  btnReadInfo.Enabled := False;
  btnHistoryCost.Enabled := False;
  btnRewiring.Enabled := False;
  btnSendDocument.Enabled := False;

  cxGrid1DBTableView1.OptionsData.Editing := False;
  rgStepRewiring.Enabled := False;

  FisProcessingEmpty := False;

  lblActionTake.Caption := 'Перепроведение докeментов';
  pbProcess.Properties.Marquee := True;

  TimerRewiring.Enabled := True;

end;

procedure TMainForm.btnScriptPathClick(Sender: TObject);
var
  sScriptFolder, sInitPath: string;
begin
  sInitPath := TSettings.ScriptPath;
  if not TDirectory.Exists(sInitPath) then
    sInitPath := ExtractFilePath(ParamStr(0));

  {$WARNINGS OFF}
  with opndlgMain do
  begin
    Title := 'Выберите папку со скриптами';
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    OkButtonLabel := 'Выбрать';
    DefaultFolder := sInitPath;
    if Execute then
    begin
      sScriptFolder        := FileName;
      edtScriptPath.Text   := sScriptFolder;
      TSettings.ScriptPath := sScriptFolder;
    end;
  end;
  {$WARNINGS ON}

//  if Length(sScriptFolder) > 0 then
//  begin
//    FreeAndNil(FScriptFiles);
//    FScriptFiles := TScriptFiles.Create(sScriptFolder, LogApplyScript);
//  end;
end;

procedure TMainForm.btnSendDocumentClick(Sender: TObject);
  var SendMovementThread: TSendMovementThread;
begin
  if cxPageProcessing.ActivePage <> tsPageProcessingEmpty then
  begin
    cxPageProcessing.ActivePage := tsPageProcessingEmpty;
    ReadInfo;
    Exit;
  end;

  if MessageDlg('Запустить выполнение переноса докeментов?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

  FTerminated := False;
  cxTabSheetSettings.TabVisible := False;
  cxTabSheetCheckingHC.TabVisible := False;

  btnReadInfo.Enabled := False;
  btnHistoryCost.Enabled := False;
  btnRewiring.Enabled := False;
  btnSendDocument.Enabled := False;

  cxGrid1DBTableView1.OptionsData.Editing := False;
  FisProcessingEmpty := False;

  SendMovementThread := TSendMovementThread.Create(True);
  SendMovementThread.FreeOnTerminate:=True;
  SendMovementThread.HostName := MainForm.edtSlaveServer.Text;
  SendMovementThread.Database := MainForm.edtSlaveDatabase.Text;
  SendMovementThread.User := MainForm.edtSlaveUser.Text;
  SendMovementThread.Password := MainForm.edtSlavePassword.Text;
  SendMovementThread.Port := StrToInt(MainForm.edtSlavePort.Text);
  SendMovementThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;

  SendMovementThread.Session := edSession.Text;

  SendMovementThread.OnFinish := SendMovementThreadFinish;
  SendMovementThread.OnProcess := SendMovementThreadProcess;

  FListProcessing.AddObject('1', SendMovementThread);
  SendMovementThread.Resume;
  FisProcessingEmpty := True;

end;

procedure TMainForm.btnUpdateSleveClick(Sender: TObject);
begin
  try
    if not GetInfoSlave then Exit;

    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtSlaveDatabase.Text]);
    ZQuery.Open;
    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('Не слейве не найдена схема <_replica> работа невозможна.');
      Exit;
    end;

    // Создаем (обновляем) на слейве таблицу RewiringProtocol
    SaveRewiringLog('Создаем (обновляем) на слейве таблицу RewiringProtocol');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQL_RewiringProtocol);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве таблицу HistoryCost_Rewiring
    SaveRewiringLog('Создаем (обновляем) на слейве таблицу HistoryCost_Rewiring');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQL_Slave_HistoryCost_Rewiring);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве таблицу MovementItemContainer_Rewiring
    SaveRewiringLog('Создаем (обновляем) на слейве таблицу MovementItemContainer_Rewiring');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQL_Slave_MovementItemContainer_Rewiring);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве таблицу MovementProtocol_Rewiring
    SaveRewiringLog('Создаем (обновляем) на слейве таблицу MovementProtocol_Rewiring');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQL_MovementProtocol_Rewiring);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию расчета HistoryCost
    SaveRewiringLog('Создаем (обновляем) на слейве функцию расчета HistoryCost');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_HistoryCost_Rewiring);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию проверки HistoryCost на слейве
    SaveRewiringLog('Создаем (обновляем) на слейве функцию проверки HistoryCost на слейве');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_CheckingHistoryCost_Slave);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию проверки HistoryCost на мастере
    SaveRewiringLog('Создаем (обновляем) на слейве функцию проверки HistoryCost на мастере');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_CheckingHistoryCost_Master);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию для проверки HistoryCost
    SaveRewiringLog('Создаем (обновляем) на слейве функцию для проверки HistoryCost');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSP_Slave_CheckingHistoryCost);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию получения проводок для перерасчета HistoryCost на мастере
    SaveRewiringLog('Создаем (обновляем) на слейве функцию получения проводок');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSP_Slave_MovementItemContainer);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию отправки документа
    SaveRewiringLog('Создаем (обновляем) на слейве функцию отправки документа');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_SendMovement);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию что отправить надо
    SaveRewiringLog('Создаем (обновляем) на слейве функцию что отправить надо');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_RewiringProtocol);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию данных для перепроведения
    SaveRewiringLog('Создаем (обновляем) на слейве функцию данных для перепроведения');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_RewiringParams);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию перепроводки документа
    SaveRewiringLog('Создаем (обновляем) на слейве функцию перепроводки документа');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_MovementId);
    ZQueryExecute.ExecSQL;

    // Создаем (обновляем) на слейве функцию получения изменившихся свойств
    SaveRewiringLog('Создаем (обновляем) на слейве функцию получения изменившихся свойств');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_Slave_MovementProperties);
    ZQueryExecute.ExecSQL;

    // Cоздаем (обновляем) на слейве функцию Подсчитываем количества функций
    SaveRewiringLog('Cоздаем (обновляем) на слейве функцию Подсчитываем количества функций');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPCalcFunctionMaster);
    ZQueryExecute.ExecSQL;

    // Cоздаем (обновляем) на слейве функцию Копирование функций
    SaveRewiringLog('Cоздаем (обновляем) на слейве функцию Копирование функций');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Function);
    ZQueryExecute.ExecSQL;

    // Создаем функцию с пареметрами подключения е базе
    SaveRewiringLog('Создаем функцию с пареметрами подключения е базе');
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := Format(LiadScripts(cSQLSP_Slave_Connect),
        [edtMasterServerIn.Text, edtMasterDatabase.Text, edtMasterPort.Text, edtMasterUser.Text,
         edtMasterPassword.Text, edtSlaveUserRC.Text, edtSlavePasswordRC.Text]);
    ZQueryExecute.ExecSQL;

//    if edtSlaveUserRC.Text <> '' then
//    begin
//
//      // Создаем (обновляем) на слейве функцию определения что под ролью для перепроведения
//      SaveRewiringLog('Создаем функцию определения что под ролью для перепроведения');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := Format(LiadScripts(cSQLzc_isUserRewiring), [edtSlaveUserRC.Text]);
//      ZQueryExecute.ExecSQL;
//
//      // Создаем (обновляем) на слейве тригерную функцию notice_changed_data
//      SaveRewiringLog('Создаем тригерную функцию notice_changed_data');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLTR_Data);
//      ZQueryExecute.ExecSQL;
//
//      // Создаем (обновляем) на слейве тригерную функцию notice_changed_data_container
//      SaveRewiringLog('Создаем тригерную функцию notice_changed_data_container');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLTR_Data_container);
//      ZQueryExecute.ExecSQL;
//
//      // Создаем (обновляем) на слейве тригерную функцию notice_changed_data_movement
//      SaveRewiringLog('Создаем тригерную функцию notice_changed_data_movement');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLTR_Data_movement);
//      ZQueryExecute.ExecSQL;
//
//      // Создаем (обновляем) на слейве тригерную функцию notice_changed_data_movementitemcontainer
//      SaveRewiringLog('Создаем тригерную функцию notice_changed_data_movementitemcontainer');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLTR_Data_movementitemcontainer);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Container
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Container');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Container);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - Asset
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - Asset');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_Asset);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - InvNumber
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - InvNumber');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_InvNumber);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - OS
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - OS');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_OS);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionDate
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionDate');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_PartionDate);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionDate - NEW
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionDate - NEW');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_PartionDate_NEW);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionString
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionString');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_PartionString);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionString_20202
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionGoods - PartionString_20202');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionGoods_PartionString_20202);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertFind_Object_PartionMovement
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertFind_Object_PartionMovement');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertFind_Object_PartionMovement);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertUpdate_MovementItemContainer
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertUpdate_MovementItemContainer');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertUpdate_MovementItemContainer);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsertUpdate_MovementItemContainer_byTable
//      SaveRewiringLog('Обновляем на слейве функцию lpInsertUpdate_MovementItemContainer_byTable');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsertUpdate_MovementItemContainer_byTable);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpDelete_MovementItemContainer
//      SaveRewiringLog('Обновляем на слейве функцию lpDelete_MovementItemContainer');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpDelete_MovementItemContainer);
//      ZQueryExecute.ExecSQL;
//
//      // Обновляем на слейве функцию lpInsert_MovementProtocol
//      SaveRewiringLog('Обновляем на слейве функцию lpInsert_MovementProtocol');
//      ZQueryExecute.Close;
//      ZQueryExecute.SQL.Text := LiadScripts(cSQLlpInsert_MovementProtocol);
//      ZQueryExecute.ExecSQL;
//
//    end else SaveRewiringLog('Не создана роль для проведения перепроведения. Тригера не обновлены', True);

    SaveRewiringLog('Выполнено.');
    ZConnection.Disconnect;

    ReadInfo;
  except
    on E: Exception do
      SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FListProcessing.Count > 0 then
  begin
    Action := caNone;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  mmoScriptLog.Lines.Clear;
  mmoScriptLogRewiring.Lines.Clear;
  edSession.Text := '';
  FListProcessing := TStringList.Create;
  FListProcessing.Sorted := True;
  FListProcessing.OwnsObjects:= False;
  FTerminated := False;
  FStyle := TcxStyle.Create(nil);


  ReadSettings;

  edtScriptPath.Text := TSettings.ScriptPath;

  ZConnection.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  if (edtSlaveServer.Text = '') or (edtSlaveServer.Text = '') then
  begin
    cxPageControl.Properties.ActivePage := cxTabSheetSettings;
    Exit;
  end else cxPageControl.Properties.ActivePage := cxTabSheetProcess;
  cxPageProcessing.ActivePage := tsPageProcessingEmpty;

  SaveRewiringLog('Запуск программы - Rewiring');

  ReadInfo;

//  if (ParamCount >= 1) and (CompareText(ParamStr(1), 'equalization') = 0) then
//  begin
//    FTimerEqualization := True;
//    FCloseFoeFinish := True;
//    cxTabSheetDocSettings.TabVisible := False;
//    cxTabSheetSnapshot.TabVisible := False;
//
//    btnEqualizationAll.Enabled := False;
//    btnEqualizationLoad.Enabled := False;
//    btnEqualizationSend.Enabled := False;
//    btnlInfoEqualizationView.Enabled := False;
//
//    deDateSnapshot.Enabled := False;
//    deDateSend.Enabled := False;
//    deDateEqualization.Enabled := False;
//
//    TimerEqualization.Enabled := True;
//  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  WriteSettings;
  SaveRewiringLog('Закрытие программы - BranchService');
  FreeAndNil(FListProcessing);
  FStyle.Free;
end;

procedure TMainForm.ReadSettings;
begin
  edtMasterServer.Text      := TSettings.MasterServer;
  edtMasterServerIn.Text    := TSettings.MasterServerIn;
  edtMasterDatabase.Text    := TSettings.MasterDatabase;
  edtMasterUser.Text        := TSettings.MasterUser;
  edtMasterPassword.Text    := TSettings.MasterPassword;
  edtMasterPort.Text        := IntToStr(TSettings.MasterPort);
  edtMasterUserRun.Text     := TSettings.MasterUserRun;

  edtSlaveServer.Text       := TSettings.SlaveServer;
  edtSlaveServerIn.Text     := TSettings.SlaveServerIn;
  edtSlaveDatabase.Text     := TSettings.SlaveDatabase;
  edtSlaveUser.Text         := TSettings.SlaveUser;
  edtSlavePassword.Text     := TSettings.SlavePassword;
  edtSlavePort.Text         := IntToStr(TSettings.SlavePort);
  edtSlaveUserRC.Text       := TSettings.SlaveUserRC;
  edtSlavePasswordRC.Text   := TSettings.SlavePasswordRC;

  edCountThread.Value       := TSettings.CountThread;
end;

procedure TMainForm.ReadInfo;
begin
  if FListProcessing.Count > 0 then Exit;
  FTerminated := False;
  try
    try
      if GetInfoMaster then
      begin

        try
          ZQuery.Close;
          ZQuery.SQL.Text := cSQL_StartDate_Auto_PrimeCost;
          ZQuery.Open;
          deDateStartDate.Date := ZQuery.FieldByName('StartDate').AsVariant;
          deStartDate.Date := deDateStartDate.Date;
          deEndDate.Date := IncDay(IncMonth(deDateStartDate.Date), - 1);
        except
          on E: Exception do
            SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]), True);
        end;

        try
          ZQuery.Close;
          ZQuery.SQL.Text := Format(cSQL_Session, [edtMasterUserRun.Text]);
          ZQuery.Open;
          edSession.Text := ZQuery.FieldByName('Session').AsString;
        except
          on E: Exception do
            SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]), True);
        end;

        if edSession.Text = '' then
        begin
          SaveRewiringLog('Не получена сессия пользователя.', True);
          Exit;
        end;

        if cxPageProcessing.ActivePage = tsPageProcessingHistoryCost then
        begin
          try
            ZQueryExecute.Close;
            ZQueryExecute.SQL.Text := Format(cSQL_HistoryCost_Branch,
                                             [FormatDateTime('YYYY-MM-DD', deStartDate.Date),
                                              FormatDateTime('YYYY-MM-DD', deEndDate.Date),
                                              edSession.Text,
                                              FormatDateTime('YYYY-MM-DD', deStartDate.Date),
                                              FormatDateTime('YYYY-MM-DD', deEndDate.Date)]);
            ZQueryExecute.Open;

            HistoryCost_BranchCDS.Close;
            HistoryCost_BranchCDS.CreateDataSet;
            ZQueryExecute.First;
            while not ZQueryExecute.Eof do
            begin
              HistoryCost_BranchCDS.Append;
              HistoryCost_BranchCDS.FieldByName('isCalculate').AsBoolean := True;
              HistoryCost_BranchCDS.FieldByName('Process').AsString := 'Ожидание';
              HistoryCost_BranchCDS.FieldByName('StartDate').AsDateTime := ZQueryExecute.FieldByName('StartDate').AsDateTime;
              HistoryCost_BranchCDS.FieldByName('EndDate').AsDateTime := ZQueryExecute.FieldByName('EndDate').AsDateTime;
              HistoryCost_BranchCDS.FieldByName('BranchId').AsInteger := ZQueryExecute.FieldByName('BranchId').AsInteger;
              if ZQueryExecute.FieldByName('BranchName').AsString = '' then
                HistoryCost_BranchCDS.FieldByName('BranchName').AsString := 'Без филиала'
              else HistoryCost_BranchCDS.FieldByName('BranchName').AsString := ZQueryExecute.FieldByName('BranchName').AsString;
              HistoryCost_BranchCDS.Post;
              ZQueryExecute.Next;
            end;
            HistoryCost_BranchCDS.First;
          except
            on E: Exception do
              SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]), True);
          end;
        end;

        if cxPageProcessing.ActivePage = tsPageProcessingRewiring then
        begin
          try
            if GetInfoSlave then
            begin
              ZQueryExecute.Close;
              ZQueryExecute.SQL.Text := Format(cSQL_RewiringParams_Branch, [edSession.Text]);
              ZQueryExecute.Open;

              Rewiring_BranchCDS.Close;
              Rewiring_BranchCDS.CreateDataSet;
              ZQueryExecute.First;
              while not ZQueryExecute.Eof do
              begin
                Rewiring_BranchCDS.Append;
                Rewiring_BranchCDS.FieldByName('isCalculate').AsBoolean := True;
                Rewiring_BranchCDS.FieldByName('Process').AsString := 'Ожидание';
                Rewiring_BranchCDS.FieldByName('Position').AsInteger := 0;
                Rewiring_BranchCDS.FieldByName('StartDate').AsDateTime := deStartDate.Date;
                Rewiring_BranchCDS.FieldByName('EndDate').AsDateTime := deEndDate.Date;
                Rewiring_BranchCDS.FieldByName('GroupId').AsInteger := ZQueryExecute.FieldByName('GroupId').AsInteger;
                Rewiring_BranchCDS.FieldByName('GroupName').AsString := ZQueryExecute.FieldByName('GroupName').AsString;
                Rewiring_BranchCDS.FieldByName('IsSale').AsBoolean := ZQueryExecute.FieldByName('IsSale').AsBoolean;
                Rewiring_BranchCDS.FieldByName('IsBefoHistoryCost').AsBoolean := rgStepRewiring.ItemIndex <= 0;
                Rewiring_BranchCDS.Post;
                ZQueryExecute.Next;
              end;
              Rewiring_BranchCDS.First;
            end;
          except
            on E: Exception do
              SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]), True);
          end;
        end;

        ZConnection.Disconnect;
      end;

    except
      on E: Exception do
        begin
          SaveRewiringLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
          cxPageControl.Properties.ActivePage := cxTabSheetSettings;
        end;
    end;
  finally

  end;
end;

procedure TMainForm.WriteSettings;
begin
  TSettings.MasterServer      := edtMasterServer.Text;
  TSettings.MasterServerIn    := edtMasterServerIn.Text;
  TSettings.MasterDatabase    := edtMasterDatabase.Text;
  TSettings.MasterUser        := edtMasterUser.Text;
  TSettings.MasterPassword    := edtMasterPassword.Text;
  TSettings.MasterPort        := StrToIntDef(edtMasterPort.Text, TSettings.DefaultPort);
  TSettings.MasterUserRun     := edtMasterUserRun.Text;

  TSettings.SlaveServer       := edtSlaveServer.Text;
  TSettings.SlaveServerIn     := edtSlaveServerIn.Text;
  TSettings.SlaveDatabase     := edtSlaveDatabase.Text;
  TSettings.SlaveUser         := edtSlaveUser.Text;
  TSettings.SlavePassword     := edtSlavePassword.Text;
  TSettings.SlavePort         := StrToIntDef(edtSlavePort.Text, TSettings.DefaultPort);
  TSettings.SlaveUserRC       := edtSlaveUserRC.Text;
  TSettings.SlavePasswordRC   := edtSlavePasswordRC.Text;

  TSettings.CountThread       := Round(edCountThread.Value);
end;

procedure TMainForm.HistoryCostThreadFinish(AError : String; ABranchId : Integer);
begin
  TThread.CreateAnonymousThread(procedure
      var I : Integer;
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          if FListProcessing.Find(IntToStr(ABranchId), I) then FListProcessing.Delete(I);
          if AError <> '' then SaveRewiringLog(AError);
          if HistoryCost_BranchCDS.Locate('BranchId', ABranchId, []) then
          begin
            HistoryCost_BranchCDS.Edit;
            if AError = '' then
              HistoryCost_BranchCDS.FieldByName('Process').AsString := 'Выполнено'
            else HistoryCost_BranchCDS.FieldByName('Process').AsString := 'Ошибка выполнения';
            HistoryCost_BranchCDS.Post;
          end;
        end)
    end).Start;
end;

procedure TMainForm.HistoryCostThreadProcess(AText : String; ABranchId : Integer);
begin
  if AText <> '' then
    TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            while HistoryCost_BranchCDS.ControlsDisabled do Sleep(100);

            if HistoryCost_BranchCDS.Locate('BranchId', ABranchId, []) then
            begin
              HistoryCost_BranchCDS.Edit;
              HistoryCost_BranchCDS.FieldByName('Process').AsString := AText;
              HistoryCost_BranchCDS.Post;
            end;
          end)
      end).Start;
end;

procedure TMainForm.RewiringThreadFinish(AError : String; AGroupId : Integer);
begin
  TThread.CreateAnonymousThread(procedure
      var I : Integer;
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          if FListProcessing.Find(IntToStr(AGroupId), I) then FListProcessing.Delete(I);
          if AError <> '' then SaveRewiringLog(AError);
          if Rewiring_BranchCDS.Locate('GroupId', AGroupId, []) then
          begin
            Rewiring_BranchCDS.Edit;
            if AError = '' then
              Rewiring_BranchCDS.FieldByName('Process').AsString := 'Выполнено'
            else Rewiring_BranchCDS.FieldByName('Process').AsString := 'Ошибка выполнения';
            Rewiring_BranchCDS.Post;
          end;
        end)
    end).Start;
end;

procedure TMainForm.RewiringThreadProcess(AText: String; AGroupId, APosition, AMax : Integer);
begin
  if AText <> '' then
    TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            while Rewiring_BranchCDS.ControlsDisabled do Sleep(100);

            Rewiring_BranchCDS.DisableControls;
            try
              if Rewiring_BranchCDS.Locate('GroupId', AGroupId, []) then
              begin
                if (Rewiring_BranchCDS.FieldByName('Process').AsString <> AText) or
                   (Rewiring_BranchCDS.FieldByName('Position').AsInteger < (100 * APosition div AMax)) then
                begin
                  Rewiring_BranchCDS.Edit;
                  Rewiring_BranchCDS.FieldByName('Process').AsString := AText;
                  if AMax > 0 then
                  begin
                    if Rewiring_BranchCDS.FieldByName('Position').AsInteger < (100 * APosition div AMax) then
                      Rewiring_BranchCDS.FieldByName('Position').AsInteger := 100 * APosition div AMax
                  end else Rewiring_BranchCDS.FieldByName('Position').AsInteger := 0;
                  Rewiring_BranchCDS.Post;
                end;
              end;
            finally
              Rewiring_BranchCDS.EnableControls;
            end;
          end)
      end).Start;

end;

procedure TMainForm.rgStepRewiringClick(Sender: TObject);
begin
  Rewiring_BranchCDS.DisableControls;
  try
    Rewiring_BranchCDS.First;
    while not Rewiring_BranchCDS.Eof do
    begin
      Rewiring_BranchCDS.Edit;
      Rewiring_BranchCDS.FieldByName('IsBefoHistoryCost').AsBoolean := rgStepRewiring.ItemIndex = 0;
      Rewiring_BranchCDS.Post;
      Rewiring_BranchCDS.Next;
    end;
    Rewiring_BranchCDS.First;
  finally
    Rewiring_BranchCDS.EnableControls;
  end;
end;

procedure TMainForm.SendMovementThreadFinish(AError : String; AGroupId : Integer);
begin
  TThread.CreateAnonymousThread(procedure
      var I : Integer;
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          if FListProcessing.Find(IntToStr(AGroupId), I) then FListProcessing.Delete(I);
          if AError <> '' then SaveRewiringLog(AError, True);
          SaveRewiringLog('Отправка данных на мастер выполнена.');

          cxTabSheetSettings.TabVisible := True;
          cxTabSheetCheckingHC.TabVisible := True;

          btnReadInfo.Enabled := True;
          btnHistoryCost.Enabled := True;
          btnRewiring.Enabled := True;
          btnSendDocument.Enabled := True;


          cxGrid1DBTableView1.OptionsData.Editing := True;
          lblActionTake.Caption := 'Ожидание задания';
          pbProcess.Properties.Marquee := False;
          pbProcess.Properties.ShowTextStyle := cxtsPercent;
          pbProcess.Position := 0;
        end)
    end).Start;
end;

procedure TMainForm.SendMovementThreadProcess(AText: String; AGroupId, APosition, AMax : Integer);
begin
  if AText <> '' then
    TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            if ((lblActionTake.Caption <> AText) or
               (pbProcess.Position < (100 * APosition div AMax))) and
               (FListProcessing.Count > 0) then
            begin
              lblActionTake.Caption := AText;
              if AMax > 0 then
              begin
                if pbProcess.Position < (100 * APosition div AMax) then
                  pbProcess.Position := 100 * APosition div AMax
              end else pbProcess.Position := 0;
            end;
          end)
      end).Start;
end;

procedure TMainForm.FunctionThreadFinish(AError : String; AGroupId : Integer);
begin
  TThread.CreateAnonymousThread(procedure
      var I : Integer;
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          if FListProcessing.Find(IntToStr(AGroupId), I) then FListProcessing.Delete(I);
          cxTabSheetSettings.TabVisible := True;
          cxTabSheetCheckingHC.TabVisible := True;
          cxPageControl.ActivePage := cxTabSheetSettings;
          if AError <> '' then SaveRewiringLog(AError, True);
          SaveRewiringLog('Копирование функций с мастера на слейв выполненао.');


          btnReadInfo.Enabled := True;
          btnHistoryCost.Enabled := True;
          btnRewiring.Enabled := True;
          btnSendDocument.Enabled := True;


          cxGrid1DBTableView1.OptionsData.Editing := True;
          lblActionTake.Caption := 'Ожидание задания';
          pbProcess.Properties.Marquee := False;
          pbProcess.Properties.ShowTextStyle := cxtsPercent;
          pbProcess.Position := 0;
        end)
    end).Start;
end;

procedure TMainForm.FunctionThreadProcess(AText: String; AGroupId, APosition, AMax : Integer);
begin
  if AText <> '' then
    TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            if ((lblActionTake.Caption <> AText) or
               (pbProcess.Position < (100 * APosition div AMax))) and
               (FListProcessing.Count > 0) then
            begin
              lblActionTake.Caption := AText;
              if AMax > 0 then
              begin
                if pbProcess.Position < (100 * APosition div AMax) then
                  pbProcess.Position := 100 * APosition div AMax
              end else pbProcess.Position := 0;
            end;
          end)
      end).Start;
end;

procedure TMainForm.CheckingHistoryCostThreadFinish(AError : String; AisMaster : Boolean; AUUId : String);
begin
  TThread.CreateAnonymousThread(procedure
      var I : Integer;
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          if AisMaster then
          begin
            if FListProcessing.Find('2', I) then FListProcessing.Delete(I);
            FMasterUUId := AUUId;
            if AError <> '' then SaveRewiringLog(AError, True)
            else SaveRewiringLog('Получены данные с мастера.');
          end else
          begin
            if FListProcessing.Find('1', I) then FListProcessing.Delete(I);
            FSlaveUUId := AUUId;
            if AError <> '' then SaveRewiringLog(AError, True)
            else SaveRewiringLog('Получены данные с слейва".');
          end;

          if FListProcessing.Count <= 0 then TimerCheckingHistoryCost.Enabled := True;

        end)
    end).Start;
end;

end.
