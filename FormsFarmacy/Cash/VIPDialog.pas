unit VIPDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  Data.DB, cxDBData, Datasnap.DBClient, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxGridCustomView, cxGrid, CommonData,
  cxNavigator, dxDateRanges, System.Actions;

type
  TVIPDialogForm = class(TAncestorDialogForm)
    ceMember: TcxButtonEdit;
    MemberGuides: TdsdGuides;
    Label1: TLabel;
    edBayerName: TcxTextEdit;
    Label2: TLabel;
    grtvMember: TcxGridDBTableView;
    grlMember: TcxGridLevel;
    grMember: TcxGrid;
    grtvMemberName: TcxGridDBColumn;
    dsMember: TDataSource;
    cdsMember: TClientDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  VIPDialogForm: TVIPDialogForm;

function VIPDialogExecute(var AManagerID: Integer; var AManagerName: String; var BayerName: String): boolean;

implementation
uses
  LocalWorkUnit;
{$R *.dfm}

function VIPDialogExecute(var AManagerID: Integer; var AManagerName: String; var BayerName: String): boolean;
Begin
  if NOT assigned(VIPDialogForm) then
    VIPDialogForm := TVIPDialogForm.Create(Application);
  With VIPDialogForm do
  Begin
    try
      if gc_User.Local then
      Begin
        label1.Visible := False;
        ceMember.Visible := False;
        grMember.Visible := true;
        if not cdsMember.Active then LoadLocalData(cdsMember, Member_lcl);
        ActiveControl := grMember;
      End
      else
      Begin
        label1.Visible := true;
        ceMember.Visible := true;
        grMember.Visible := false;
        ActiveControl := ceMember;
      End;
      Result := ShowModal = mrOK;
      if Result then
      Begin
        if gc_User.Local then
        Begin
          AManagerID := cdsMember.FieldByName('Id').AsInteger;
          AManagerName := cdsMember.FieldByName('Name').AsString;
        End
        else
        Begin
          AManagerID := FormParams.ParamByName('MemberId').Value;
          AManagerName := FormParams.ParamByName('MemberName').Value;
        End;
        BayerName := edBayerName.Text;
      End;
    Except ON E: Exception DO
    Begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      result := False;
    End;
    end;
  End;
End;

end.
