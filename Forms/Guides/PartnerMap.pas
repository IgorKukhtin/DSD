unit PartnerMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, Vcl.OleCtrls, SHDocVw,
  GMClasses, GMMap, GMMapVCL, GMLinkedComponents, GMMarker, GMMarkerVCL,
  Vcl.ActnList, dsdAction;

type
  TPartnerMapForm = class(TParentForm)
    gmPartnerMap: TGMMap;
    wbPartnerMap: TWebBrowser;
    gmPartnerMarker: TGMMarker;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
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
