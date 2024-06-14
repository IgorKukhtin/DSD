unit DataModul;

interface

uses
  SysUtils, Classes, ImgList, Controls, frxClass, cxClasses, cxStyles,
  cxGridBandedTableView, cxGridTableView, cxTL, Data.DB, Datasnap.DBClient,
  dsdAddOn, cxPropertiesStore, cxLookAndFeels, dxSkinsCore,
  dxSkinsDefaultPainters, frxExportPDF, cxGraphics, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon
  {$IFDEF VER330} , cxImageList, System.ImageList, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, frxExportBaseDialog {$ENDIF}
  {$IFDEF VER340} , cxImageList, System.ImageList {$ENDIF}
  {$IFDEF VER350} , cxImageList, System.ImageList {$ENDIF}
  {$IFDEF VER360} , cxImageList, System.ImageList {$ENDIF};

type

  {форма содержит компоненты с картинками}
  TdmMain = class(TDataModule)
    ImageList1: TcxImageList;
    MainImageList: TImageList;
    TreeImageList: TImageList;
    frxReport: TfrxReport;
    cxStyleRepository: TcxStyleRepository;
    cxGridBandedTableViewStyleSheet: TcxGridBandedTableViewStyleSheet;
    cxHeaderStyle: TcxStyle;
    cxGridTableViewStyleSheet: TcxGridTableViewStyleSheet;
    SortImageList: TImageList;
    cxTreeListStyleSheet: TcxTreeListStyleSheet;
    cxFooterStyle: TcxStyle;
    cxSelection: TcxStyle;
    cxContentStyle: TcxStyle;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLookAndFeelController: TcxLookAndFeelController;
    cxRemainsContentStyle: TcxStyle;
    frxPDFExport1: TfrxPDFExport;
    cxImageList1: TcxImageList;
    ImageList: TImageList;
    cxGreenEdit: TcxStyle;
    cxHeaderL1Style: TcxStyle;
    cxHeaderL2Style: TcxStyle;
    cxHeaderL3Style: TcxStyle;
    cxRemainsCashContentStyle: TcxStyle;
    cxHeaderL4Style: TcxStyle;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

var dmMain: TdmMain;
implementation

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
end;

end.
