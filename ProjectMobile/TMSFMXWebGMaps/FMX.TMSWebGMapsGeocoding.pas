{***************************************************************************)
{ TMS FMX WebGMaps component                                                }
{ for Delphi                                                                }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2013 - 2016                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}
unit FMX.TMSWebGMapsGeocoding;

{$I TMSDEFS.INC}

interface

uses
  SysUtils, Classes, FMX.TMSWebGMapsCommon,
  FMX.TMSWebGMapsConst, StrUtils, variants, TypInfo,
  xmldoc, XMLIntf, FMX.TMSWebGMapsCommonFunctions, FMX.TMSWebGMapsWebKit;

const
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 2; // Release nr.
  BLD_VER = 0; // Build nr.

  // version history
  // v1.0.0.0 : First release
  // v1.0.0.1 : Fixed : Issue with NSURLConnection bad system call with no active internet connection
  // v1.0.2.0 : New : Published property APIKey

type
  {$IFDEF DELPHIXE5_LVL}
  [ComponentPlatformsAttribute(pidiOSSimulator or {$IFDEF DELPHIXE8_LVL}pidiOSDevice32 or pidiOSDevice64{$ELSE}pidiOSDevice{$ENDIF} or pidOSX32 or pidAndroid or pidWin32 or pidWin64)]
  {$ELSE}
  [ComponentPlatformsAttribute(pidiOSSimulator or pidiOSDevice or pidOSX32 or pidWin32 or pidWin64)]
  {$ENDIF}
  TTMSFMXWebGMapsGeocoding = class(TTMSFMXWebGMapsGeocodingService)
  private
    FAddress: String;
    FResultLatitude: Double;
    FResultLongitude: Double;
    FResultLocationType: TLocationType;
    FAPIKey: string;
    procedure SetAddress(const Value: String);
    function FoundNode(XmlNode: IXmlNode; NodeName: String): IXmlNode;
    function GetVersion: string;
    procedure SetVersion(const Value: string);
  protected
    function GetVersionNr: integer; virtual;
    function GetCoord(s: string): double;
  public
    destructor Destroy; override;
    Constructor Create(AOwner:TComponent); override;
    function LaunchGeocoding : TGeocodingResult;
  published
    property APIKey: string read FAPIKey write FAPIKey;
    property Address : String read FAddress write SetAddress;
    property ResultLatitude     : Double read FResultLatitude;
    property ResultLongitude    : Double read FResultLongitude;
    property ResultLocationType : TLocationType read FResultLocationType;
    property Version: string read GetVersion write SetVersion;
  end;

implementation

{$IFDEF DELPHIXE7_LVL}
uses
{$IFDEF MSWINDOWS}
  Xml.Win.msxmldom;
{$ELSE}
  Xml.omnixmldom;
{$ENDIF}
{$ENDIF}

{ TWebGMaps }

constructor TTMSFMXWebGMapsGeocoding.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FAPIKey             := '';
  FAddress            := '';
  FResultLatitude     := 0;
  FResultLongitude    := 0;
  FResultLocationType := ltNotInitialize;
end;

destructor TTMSFMXWebGMapsGeocoding.Destroy;
begin
  inherited Destroy;
end;

function TTMSFMXWebGMapsGeocoding.FoundNode(XmlNode : IXmlNode;NodeName : String) : IXmlNode;
var
 i : integer;
begin
  Result := nil;

  if XMLNode.NodeType <> ntElement then
    Exit;

  if XMLNode.IsTextElement then
    if UpperCase(XmlNode.NodeName) = UpperCase(NodeName) then
    begin
      Result := XmlNode;
      Exit;
    end;

  for i := 0 to XMLNode.AttributeNodes.Count - 1 do
    if UpperCase(XMLNode.AttributeNodes.Nodes[I].NodeName) = Uppercase(NodeName) then
    begin
      Result := XMLNode.AttributeNodes.Nodes[I];
      Exit;
    end;

  if XMLNode.HasChildNodes then
    for I := 0 to XMLNode.ChildNodes.Count - 1 do
    begin
      Result := FoundNode(XmlNode.ChildNodes.Nodes[I],NodeName);
      if Result <> nil then
        Exit;
    end;
end;

function TTMSFMXWebGMapsGeocoding.GetCoord(s: string): double;
begin
  if FormatSettings.DecimalSeparator <> '.' then
    s := ReplaceStr(s, '.', FormatSettings.DecimalSeparator);

  Result := StrToFloat(s);
end;

function TTMSFMXWebGMapsGeocoding.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(System.Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(System.Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

function TTMSFMXWebGMapsGeocoding.GetVersionNr: integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TTMSFMXWebGMapsGeocoding.LaunchGeocoding: TGeocodingResult;
var
  Url,s:string;
  XmlDoc:TxmlDocument;
  Node:IXmlNode;
begin
  Result := erOtherProblem;
  XmlDoc := TXMLDocument.Create(Self);
  Url := GEOCODING_BASE_URL + GEOCODING_START_URL;
  Url := Url + string(URLEncode(string(UTF8Encode(FAddress))));
  Url := Url + GEOCODING_END_URL;

  if APIKey <> '' then
    Url := Url + '&key=' + APIKey;

  try
    try
      s := String(HTTPSGet(Url));
      if s <> '' then
      begin
        XmlDoc.XML.Text := s;
        XmlDoc.Active := True;

        Node := FoundNode(XmlDoc.DocumentElement,GEOCODING_STATUS);
        if Assigned(Node) then
        begin
          FResultLocationType := ltNotInitialize;
          if Node.Text = GEOCODINF_STATUS_OK then
            Result := erOk;
          if Node.Text = GEOCODINF_STATUS_ZERO_RESULTS then
            Result := erZeroResults;
          if Node.Text = GEOCODINF_STATUS_OVER_QUERY_LIMIT then
            Result := erOverQueryLimit;
          if Node.Text = GEOCODINF_STATUS_REQUEST_DENIED then
            Result := erRequestDenied;
          if Node.Text = GEOCODINF_STATUS_INVALID_REQUEST then
            Result := erInvalidRequest;
        end;

        if Result = erOk then
        begin
          Node := FoundNode(XmlDoc.DocumentElement,GEOCODING_LATITUDE);
          if Assigned(Node) then
          begin
            try
              FResultLatitude := GetCoord(Node.Text);
            except
              FResultLatitude := 0;
            end;
          end
          else
          begin
            FResultLatitude := 0;
          end;

          Node := FoundNode(XmlDoc.DocumentElement,GEOCODING_LONGITUDE);
          if Assigned(Node) then
          begin
            try
              FResultLongitude := GetCoord(Node.Text);
            except
              FResultLongitude := 0;
            end;
          end
          else
          begin
            FResultLongitude := 0;
          end;

          Node := FoundNode(XmlDoc.DocumentElement,GEOCODING_LOCATION_TYPE);
          if Assigned(Node) then
          begin
            if Node.Text = GEOCODING_LOCTYPE_ROOFTOP then
              FResultLocationType := ltRoofTop;
            if Node.Text = GEOCODING_LOCTYPE_RANGE_INTERPOLATED then
              FResultLocationType := ltRangeInterpolated;
            if Node.Text = GEOCODING_LOCTYPE_GEOMETRIC_CENTER then
              FResultLocationType := ltGeometricCenter;
            if Node.Text = GEOCODING_LOCTYPE_APPROXIMATE then
              FResultLocationType := ltApproximate;
          end
          else
          begin
            FResultLocationType := ltNotInitialize;
          end;
        end;
      end;
    except
      Result := erOtherProblem;
    end;
  finally
    FreeAndNil(XmlDoc);
  end;
end;

procedure TTMSFMXWebGMapsGeocoding.SetAddress(const Value: String);
begin
  FAddress := Value;
end;

procedure TTMSFMXWebGMapsGeocoding.SetVersion(const Value: string);
begin

end;

end.
