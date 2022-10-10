unit GuidePersonalGroup;

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
  dxSkinXmas2008Blue;

type
  TGuidePersonalGroupForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbPersonalGroupCode: TGroupBox;
    EditPersonalGroupCode: TEdit;
    gbPersonalGroupName: TGroupBox;
    EditPersonalGroupName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    PersonalGroupCode: TcxGridDBColumn;
    PersonalGroupName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure EditPersonalGroupNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalGroupCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPersonalGroupCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalGroupNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalGroupCodeChange(Sender: TObject);
    procedure EditPersonalGroupNameChange(Sender: TObject);
    procedure EditPersonalGroupCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditPersonalGroupNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterPersonalGroupCode:Boolean;
    fEnterPersonalGroupName:Boolean;

    ParamsPersonalGroup_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure RefreshDataSet;
  public
    function Execute(var execParamsPersonalGroup:TParams): boolean;
  end;

var
  GuidePersonalGroupForm: TGuidePersonalGroupForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuidePersonalGroupForm.Execute(var execParamsPersonalGroup:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsPersonalGroup,ParamsPersonalGroup_local);
     //
     RefreshDataSet;
     //
     if ParamsPersonalGroup_local.ParamByName('UnitId').AsInteger = 0
     then begin
           Result:=false;
           ShowMessage('Ошибка.Не выбрана операция перемещения.');
           exit;
     end;
     //
     EditPersonalGroupCode.Text:='';
     EditPersonalGroupName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsPersonalGroup_local.ParamByName('PersonalGroupId').AsInteger<>0
     then CDS.Locate('PersonalGroupId',ParamsPersonalGroup_local.ParamByName('PersonalGroupId').AsString,[])
     else if ParamsPersonalGroup_local.ParamByName('PersonalGroupCode').AsInteger<>0
          then CDS.Locate('PersonalGroupCode',ParamsPersonalGroup_local.ParamByName('PersonalGroupCode').AsString,[]);

     fEnterPersonalGroupCode:=false;
     fEnterPersonalGroupName:=false;
     ActiveControl:=EditPersonalGroupName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     CancelCxFilter;
     CDS.Filtered:=false;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsPersonalGroup_local,execParamsPersonalGroup);
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditPersonalGroupCode)
                       then ActiveControl:=EditPersonalGroupName
                       else if (ActiveControl=EditPersonalGroupName)
                            then ActiveControl:=EditPersonalGroupCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterPersonalGroupCode)and(trim(EditPersonalGroupCode.Text)<>'')
     then
       if  (EditPersonalGroupCode.Text=DataSet.FieldByName('PersonalGroupCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterPersonalGroupName)and(trim(EditPersonalGroupName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditPersonalGroupName.Text),AnsiUpperCase(DataSet.FieldByName('PersonalGroupName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuidePersonalGroupForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditPersonalGroupName
     else with ParamsPersonalGroup_local do
          begin
               ParamByName('PersonalGroupId').AsInteger:= CDS.FieldByName('PersonalGroupId').AsInteger;
               ParamByName('PersonalGroupCode').AsInteger:= CDS.FieldByName('PersonalGroupCode').AsInteger;
               ParamByName('PersonalGroupName').asString:= CDS.FieldByName('PersonalGroupName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupCodeChange(Sender: TObject);
begin
     if fEnterPersonalGroupCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPersonalGroupCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditPersonalGroupName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterPersonalGroupCode:=true;
          fEnterPersonalGroupName:=false;
          EditPersonalGroupName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupNameChange(Sender: TObject);
begin
     if fEnterPersonalGroupName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPersonalGroupName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditPersonalGroupCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterPersonalGroupCode:=false;
          fEnterPersonalGroupName:=true;
          EditPersonalGroupCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.EditPersonalGroupNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.actRefreshExecute(Sender: TObject);
var PersonalGroupId:String;
begin
    with spSelect do begin
        PersonalGroupId:= DataSet.FieldByName('PersonalGroupId').AsString;
        Execute;
        if PersonalGroupId <> '' then
          DataSet.Locate('PersonalGroupId',PersonalGroupId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.FormCreate(Sender: TObject);
begin
  Create_ParamsPersonalGroup(ParamsPersonalGroup_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_ScaleCeh_PersonalGroup';
       Params.AddParam('inUnitId', ftInteger, ptInput, 0);
       OutputType:=otDataSet;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.RefreshDataSet;
begin
     with spSelect do
     begin
          ParamByName('inUnitId').Value:=ParamsPersonalGroup_local.ParamByName('UnitId').AsInteger;
          Execute;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalGroupForm.FormDestroy(Sender: TObject);
begin
  ParamsPersonalGroup_local.Free;
end;
{------------------------------------------------------------------------------}
end.
