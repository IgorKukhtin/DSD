unit GuideSubjectDoc;

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
  TGuideSubjectDocForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbSubjectDocCode: TGroupBox;
    EditSubjectDocCode: TEdit;
    gbSubjectDocName: TGroupBox;
    EditSubjectDocName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    SubjectDocCode: TcxGridDBColumn;
    SubjectDocName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditSubjectDocNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSubjectDocCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditSubjectDocCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSubjectDocNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSubjectDocCodeChange(Sender: TObject);
    procedure EditSubjectDocNameChange(Sender: TObject);
    procedure EditSubjectDocCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditSubjectDocNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterSubjectDocCode:Boolean;
    fEnterSubjectDocName:Boolean;

    ParamsSubjectDoc_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsSubjectDoc:TParams): boolean;
  end;

var
  GuideSubjectDocForm: TGuideSubjectDocForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideSubjectDocForm.Execute(var execParamsSubjectDoc:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsSubjectDoc,ParamsSubjectDoc_local);

     EditSubjectDocCode.Text:='';
     EditSubjectDocName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsSubjectDoc_local.ParamByName('SubjectDocId').AsInteger<>0
     then CDS.Locate('SubjectDocId',ParamsSubjectDoc_local.ParamByName('SubjectDocId').AsString,[])
     else if ParamsSubjectDoc_local.ParamByName('SubjectDocCode').AsInteger<>0
          then CDS.Locate('SubjectDocCode',ParamsSubjectDoc_local.ParamByName('SubjectDocCode').AsString,[]);

     fEnterSubjectDocCode:=false;
     fEnterSubjectDocName:=false;
     ActiveControl:=EditSubjectDocName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsSubjectDoc_local,execParamsSubjectDoc);
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditSubjectDocCode)
                       then ActiveControl:=EditSubjectDocName
                       else if (ActiveControl=EditSubjectDocName)
                            then ActiveControl:=EditSubjectDocCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterSubjectDocCode)and(trim(EditSubjectDocCode.Text)<>'')
     then
       if  (EditSubjectDocCode.Text=DataSet.FieldByName('SubjectDocCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterSubjectDocName)and(trim(EditSubjectDocName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditSubjectDocName.Text),AnsiUpperCase(DataSet.FieldByName('SubjectDocName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideSubjectDocForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditSubjectDocName
     else with ParamsSubjectDoc_local do
          begin
               ParamByName('SubjectDocId').AsInteger:= CDS.FieldByName('SubjectDocId').AsInteger;
               ParamByName('SubjectDocCode').AsInteger:= CDS.FieldByName('SubjectDocCode').AsInteger;
               ParamByName('SubjectDocName').asString:= CDS.FieldByName('SubjectDocName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocCodeChange(Sender: TObject);
begin
     if fEnterSubjectDocCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditSubjectDocCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditSubjectDocName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterSubjectDocCode:=true;
          fEnterSubjectDocName:=false;
          EditSubjectDocName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocNameChange(Sender: TObject);
begin
     if fEnterSubjectDocName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditSubjectDocName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditSubjectDocCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterSubjectDocCode:=false;
          fEnterSubjectDocName:=true;
          EditSubjectDocCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.EditSubjectDocNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.actRefreshExecute(Sender: TObject);
var GuideSubjectDocId:String;
begin
    with spSelect do begin
        GuideSubjectDocId:= DataSet.FieldByName('SubjectDocId').AsString;
        Execute;
        if GuideSubjectDocId <> '' then
          DataSet.Locate('SubjectDocId',GuideSubjectDocId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.FormCreate(Sender: TObject);
begin
  Create_ParamsSubjectDoc(ParamsSubjectDoc_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_ScaleCeh_SubjectDoc';
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideSubjectDocForm.FormDestroy(Sender: TObject);
begin
  ParamsSubjectDoc_local.Free;
end;
{------------------------------------------------------------------------------}
end.
