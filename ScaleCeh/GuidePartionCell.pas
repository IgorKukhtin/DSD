unit GuidePartionCell;

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
  dxSkinXmas2008Blue, dsdCommon;

type
  TGuidePartionCellForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbCode: TGroupBox;
    EditCode: TEdit;
    gbName: TGroupBox;
    EditName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    PartionCellCode: TcxGridDBColumn;
    PartionCellName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    Level_cell: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure EditNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCodeChange(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
    procedure EditCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterCode:Boolean;
    fEnterName:Boolean;

    Params_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParams:TParams): boolean;
  end;

var
  GuidePartionCellForm: TGuidePartionCellForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuidePartionCellForm.Execute(var execParams:TParams): boolean;
begin
     CopyValuesParamsFrom(execParams,Params_local);

     EditCode.Text:='';
     EditName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if Params_local.ParamByName('PartionCellId').AsInteger<>0
     then CDS.Locate('PartionCellId',Params_local.ParamByName('PartionCellId').AsString,[]);

     fEnterCode:=false;
     fEnterName:=false;
     ActiveControl:=EditName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(Params_local,execParams);
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditCode)
                       then ActiveControl:=EditName
                       else if (ActiveControl=EditName)
                            then ActiveControl:=EditCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterCode)and(trim(EditCode.Text)<>'')
     then
       if  (EditCode.Text=DataSet.FieldByName('PartionCellCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterName)and(trim(EditName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditName.Text),AnsiUpperCase(DataSet.FieldByName('Name_search').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuidePartionCellForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditName
     else with Params_local do
          begin
               ParamByName('PartionCellId').AsInteger:= CDS.FieldByName('PartionCellId').AsInteger;
               ParamByName('PartionCellCode').AsInteger:= CDS.FieldByName('PartionCellCode').AsInteger;
               ParamByName('PartionCellName').asString:= CDS.FieldByName('PartionCellName').asString;
               ParamByName('InvNumber').asString:= CDS.FieldByName('InvNumber').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditCodeChange(Sender: TObject);
begin
     if fEnterCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterCode:=true;
          fEnterName:=false;
          EditName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditNameChange(Sender: TObject);
begin
     if fEnterName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterCode:=false;
          fEnterName:=true;
          EditCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.EditNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.actRefreshExecute(Sender: TObject);
var ValueId:String;
begin
    with spSelect do begin
        ValueId:= DataSet.FieldByName('PartionCellId').AsString;
        Execute;
        if ValueId <> '' then
          DataSet.Locate('PartionCellId',ValueId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.FormCreate(Sender: TObject);
begin
  Create_ParamsPartionCell(Params_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_ScaleCeh_PartionCell';
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuidePartionCellForm.FormDestroy(Sender: TObject);
begin
  Params_local.Free;
end;
{------------------------------------------------------------------------------}
end.
