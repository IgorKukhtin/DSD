unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, frxBarcode, dxSkinsdxBarPainter;

type
  TMainForm = class(TAncestorMainForm)
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    miLoad: TMenuItem;
    miImportGroup: TMenuItem;
    miUser: TMenuItem;
    N6: TMenuItem;
    miRole: TMenuItem;
    miImportType: TMenuItem;
    miImportSettings: TMenuItem;
    miImportExportLink: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    actForms: TdsdOpenForm;
    N74: TMenuItem;
    actMeasure: TdsdOpenForm;
    N1: TMenuItem;
    actCompositionGroup: TdsdOpenForm;
    N4: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses // UploadUnloadData,
 Dialogs, Forms, SysUtils, IdGlobal
// , RepriceUnit
 ;
{$R *.dfm}

end.
