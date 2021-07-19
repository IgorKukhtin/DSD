unit GuidePersonal;

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
 ,UtilScale,DataModul;

type
  TGuidePersonalForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbPersonalCode: TGroupBox;
    EditPersonalCode: TEdit;
    gbPersonalName: TGroupBox;
    EditPersonalName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    PersonalCode: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PositionCode: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditPersonalNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPersonalCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPersonalCodeChange(Sender: TObject);
    procedure EditPersonalNameChange(Sender: TObject);
    procedure EditPersonalCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditPersonalNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterPersonalCode:Boolean;
    fEnterPersonalName:Boolean;

    ParamsPersonal_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsPersonal:TParams): boolean;
  end;

var
  GuidePersonalForm: TGuidePersonalForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuidePersonalForm.Execute(var execParamsPersonal:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsPersonal,ParamsPersonal_local);

     EditPersonalCode.Text:='';
     EditPersonalName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsPersonal_local.ParamByName('PersonalId').AsInteger<>0
     then CDS.Locate('PersonalId',ParamsPersonal_local.ParamByName('PersonalId').AsString,[])
     else if ParamsPersonal_local.ParamByName('PersonalCode').AsInteger<>0
          then CDS.Locate('PersonalCode',ParamsPersonal_local.ParamByName('PersonalCode').AsString,[]);

     fEnterPersonalCode:=false;
     fEnterPersonalName:=false;
     ActiveControl:=EditPersonalName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsPersonal_local,execParamsPersonal);
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditPersonalCode)
                       then ActiveControl:=EditPersonalName
                       else if (ActiveControl=EditPersonalName)
                            then ActiveControl:=EditPersonalCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterPersonalCode)and(trim(EditPersonalCode.Text)<>'')
     then
       if  (EditPersonalCode.Text=DataSet.FieldByName('PersonalCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterPersonalName)and(trim(EditPersonalName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditPersonalName.Text),AnsiUpperCase(DataSet.FieldByName('PersonalName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuidePersonalForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditPersonalName
     else with ParamsPersonal_local do
          begin
               ParamByName('PersonalId').AsInteger:= CDS.FieldByName('PersonalId').AsInteger;
               ParamByName('PersonalCode').AsInteger:= CDS.FieldByName('PersonalCode').AsInteger;
               ParamByName('PersonalName').asString:= CDS.FieldByName('PersonalName').asString;
               ParamByName('PositionId').AsInteger:= CDS.FieldByName('PositionId').AsInteger;
               ParamByName('PositionCode').AsInteger:= CDS.FieldByName('PositionCode').AsInteger;
               ParamByName('PositionName').asString:= CDS.FieldByName('PositionName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalCodeChange(Sender: TObject);
begin
     if fEnterPersonalCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPersonalCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditPersonalName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterPersonalCode:=true;
          fEnterPersonalName:=false;
          EditPersonalName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalNameChange(Sender: TObject);
begin
     if fEnterPersonalName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPersonalName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditPersonalCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterPersonalCode:=false;
          fEnterPersonalName:=true;
          EditPersonalCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.EditPersonalNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.actRefreshExecute(Sender: TObject);
var PersonalId:String;
begin
    with spSelect do begin
        PersonalId:= DataSet.FieldByName('PersonalId').AsString;
        Execute;
        if PersonalId <> '' then
          DataSet.Locate('PersonalId',PersonalId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.FormCreate(Sender: TObject);
begin
  Create_ParamsPersonal(ParamsPersonal_local,'');

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Personal';
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuidePersonalForm.FormDestroy(Sender: TObject);
begin
  ParamsPersonal_local.Free;
end;
{------------------------------------------------------------------------------}
end.
