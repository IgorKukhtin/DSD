unit TestShowForm;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  Authentication, TestFramework, dxSkinOffice2007Green, dxSkinXmas2008Blue, dsdDB, cxLookAndFeels,
  dxSkinDarkSide, cxGridCustomView, cxMaskEdit, dxSkinValentine, dxSkinCoffee,
  dxSkinSilver, dxSkinOffice2007Black, System.Classes, dxSkiniMaginary, cxNavigator,
  dsdAddOn, Vcl.StdActns, dxSkinsdxBarPainter, dxSkinBlueprint,
  cxCustomData, dxSkinDarkRoom, dxBarBuiltInMenu,
  dxSkinSummer2008, System.Variants, cxPropertiesStore,
  dxSkinsDefaultPainters, dxSkinPumpkin, Data.DB, cxData, cxBlobEdit, cxStyles,
  cxGridDBTableView, dxSkinDevExpressStyle, dxSkinSharp, dxBar, dxSkinBlue,
  dxSkinOffice2010Silver, Vcl.Menus, dsdGuides,
  cxDataStorage, dxSkinSevenClassic, ImportGroup,
  dxSkinTheAsphaltWorld, dxSkinSeven, dxSkinBlack, dxSkinLilian, cxGridLevel, cxPC,
  Vcl.Graphics, Vcl.Forms, dxSkinMoneyTwins,
  dxSkinGlassOceans, dxSkinFoggy, dxSkinSpringTime, dxSkinHighContrast, dxBarExtItems,
  dxSkinMcSkin, cxDropDownEdit, cxSplitter, cxGraphics,
  cxFilter, cxGrid, cxClasses, dsdAction, dxSkinLondonLiquidSky, dxSkinsCore,
  cxButtonEdit, ExternalLoad, dxSkinDevExpressDarkStyle,
  dxSkinscxPCPainter, dxSkinOffice2007Pink, cxEdit, Datasnap.DBClient, AncestorDBGrid,
  Vcl.Controls, cxPCdxBarPopupMenu, dxSkinStardust, cxGridCustomTableView,
  dxSkinCaramel, Winapi.Windows, cxControls, Winapi.Messages, dxSkinSharpPlus,
  dxSkinOffice2007Blue, cxLookAndFeelPainters, Vcl.Dialogs,
  dxSkinLiquidSky, dxSkinOffice2010Blue,
  dxSkinOffice2007Silver, dxSkinWhiteprint, Vcl.ActnList, cxLabel,
  dxSkinOffice2010Black, System.SysUtils, cxDBData,
  cxTextEdit, cxGridTableView, dxSkinVS2010, cxContainer;

type
  // Test methods for class TImportGroupForm

  TTestShowForm = class(TTestCase)
  strict private
    actOpenForm: TdsdOpenForm;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Test;
  end;

implementation

uses Storage, UtilConst, CommonData;

procedure TTestShowForm.SetUp;
begin
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, gc_User);
  actOpenForm := TdsdOpenForm.Create(nil);

  actOpenForm.FormNameParam.Value := 'TAccommodationForm';
end;

procedure TTestShowForm.TearDown;
begin
  actOpenForm.Free;
  actOpenForm := nil;
end;

procedure TTestShowForm.Test;
begin
  actOpenForm.Execute;
end;

initialization
  TestFramework.RegisterTest('���� �����', TTestShowForm.Suite);
end.

