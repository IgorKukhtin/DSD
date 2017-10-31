unit PartnerMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, Vcl.OleCtrls, SHDocVw,
  GMClasses, GMMap, GMMapVCL, GMLinkedComponents, GMMarker, GMMarkerVCL,
  Vcl.ActnList, dsdAction, dsdAddOn, GMGeoCode, Data.DB, Datasnap.DBClient, GMDirection,
  GMDirectionVCL;

type
  TPartnerMapForm = class(TParentForm)
    gmPartnerMarker: TGMMarker;
    gmPartnerMap: TdsdGMMap;
    gmPartnerGeoCode: TGMGeoCode;
    wbPartner: TdsdWebBrowser;
    gmPartnerDirection: TGMDirection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PartnerMapForm: TPartnerMapForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartnerMapForm);

end.
