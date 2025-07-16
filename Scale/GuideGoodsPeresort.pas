unit GuideGoodsPeresort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid,dsdAddOn, Vcl.ActnList,
  dsdAction
 ,UtilScale,DataModul, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon, cxCheckBox;

type
  TGuideGoodsPeresortForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    Weight_gd: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    infoPanelGoods_in2: TPanel;
    infoPanelGoodsCode_in: TPanel;
    LabelGoodsCode_in: TLabel;
    PanelGoodsCode_in: TPanel;
    infoPanelGoodsKindName_in: TPanel;
    LabelGoodsKindName_in: TLabel;
    PanelGoodsName_in: TPanel;
    Panel1: TPanel;
    cbAll: TcxCheckBox;
    Key_str: TcxGridDBColumn;
    infoPanelGoodsCode_out: TPanel;
    Label1: TLabel;
    EditGoodsCode: TEdit;
    infoPanelGoodsName_out: TPanel;
    LabelGoodsName_out: TLabel;
    EditGoodsName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure cbAllPropertiesChange(Sender: TObject);
  private
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;

    fStartWrite : Boolean;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsMI:TParams): boolean;
  end;

var
  GuideGoodsPeresortForm: TGuideGoodsPeresortForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideGoodsPeresortForm.Execute(var execParamsMI:TParams): boolean;
begin
     fStartWrite:= true;

     EditGoodsCode.Text:='';
     EditGoodsName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;
     //
     with spSelect do
     begin
          Params.Clear;
          Params.AddParam('inGoodsId_in', ftInteger, ptInput, execParamsMI.ParamByName('GoodsId').AsInteger);
          Params.AddParam('inGoodsKindId_in', ftInteger, ptInput, execParamsMI.ParamByName('GoodsKindId').AsInteger);
          Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
          Execute;
     end;
     //
     PanelGoodsCode_in.Caption:= execParamsMI.ParamByName('GoodsCode').AsString;
     PanelGoodsName_in.Caption:= execParamsMI.ParamByName('GoodsName').AsString + ' ' + execParamsMI.ParamByName('GoodsKindName').AsString;

     if execParamsMI.ParamByName('GoodsId_out').AsInteger<>0
     then CDS.Locate('Key_str',execParamsMI.ParamByName('GoodsId_out').AsString+'_'+execParamsMI.ParamByName('GoodsKindId_out').AsString,[])
     ;

     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;
     ActiveControl:=EditGoodsName;
     //
     Application.ProcessMessages;

     cbAll.Checked:= FALSE;
     fStartWrite:= false;

     result:=ShowModal=mrOk;
     //if result then CopyValuesParamsFrom(ParamsGoods_local,execParamsGoods);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.cbAllPropertiesChange(Sender: TObject);
begin
     //
     if fStartWrite = TRUE then exit;
     //
     with spSelect do
     begin
          Params.Clear;
          if cbAll.Checked = TRUE then
          begin
            Params.AddParam('inGoodsId_in', ftInteger, ptInput, 0);
            Params.AddParam('inGoodsKindId_in', ftInteger, ptInput, 0);
          end
          else begin
            Params.AddParam('inGoodsId_in', ftInteger, ptInput, ParamsMI.ParamByName('GoodsId').AsInteger);
            Params.AddParam('inGoodsKindId_in', ftInteger, ptInput, ParamsMI.ParamByName('GoodsKindId').AsInteger);
          end;
          Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
          Execute;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditGoodsCode)
                       then ActiveControl:=EditGoodsName
                       else if (ActiveControl=EditGoodsName)
                            then ActiveControl:=EditGoodsCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterGoodsCode)and(trim(EditGoodsCode.Text)<>'')
     then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterGoodsName)and(trim(EditGoodsName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideGoodsPeresortForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditGoodsName
     else with ParamsMI do
          begin
               ParamByName('GoodsId_out').AsInteger:= CDS.FieldByName('GoodsId').AsInteger;
               ParamByName('GoodsCode_out').AsInteger:= CDS.FieldByName('GoodsCode').AsInteger;
               ParamByName('GoodsName_out').asString:= CDS.FieldByName('GoodsName').asString;
               ParamByName('GoodsKindId_out').AsInteger:= CDS.FieldByName('GoodsKindId').AsInteger;
               ParamByName('GoodsKindCode_out').AsInteger:= CDS.FieldByName('GoodsKindCode').AsInteger;
               ParamByName('GoodsKindName_out').asString:= CDS.FieldByName('GoodsKindName').asString;
               ParamByName('MeasureId_out').AsInteger:= CDS.FieldByName('MeasureId').AsInteger;
               ParamByName('MeasureName_out').AsString:= CDS.FieldByName('MeasureName').AsString;
               ParamByName('Weight_gd_out').asFloat:= CDS.FieldByName('Weight_gd').asFloat;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsCodeChange(Sender: TObject);
begin
     if fEnterGoodsCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGoodsCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditGoodsName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsNameChange(Sender: TObject);
begin
     if fEnterGoodsName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGoodsName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.actRefreshExecute(Sender: TObject);
var Key_str:String;
begin
    with spSelect do begin
        Key_str:= DataSet.FieldByName('Key_str').AsString;
        Execute;
        if Key_str <> '' then
          DataSet.Locate('Key_str',Key_str,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsPeresortForm.FormCreate(Sender: TObject);
begin
  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_GoodsByGoodsKindPeresort';
       OutputType:=otDataSet;
  end;
  //
end;
{------------------------------------------------------------------------------}
end.
