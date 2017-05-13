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

unit FMX.TMSWebGMapsReverseGeocoding;

{$I TMSDEFS.INC}

interface

uses
  SysUtils, Classes, FMX.TMSWebGMapsCommon, FMX.Types,
  FMX.TMSWebGMapsConst, StrUtils, variants, TypInfo,
  xmldoc, XMLIntf, FMX.TMSWebGMapsCommonFunctions, FMX.TMSWebGMapsWebKit;

const
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 3; // Release nr.
  BLD_VER = 0; // Build nr.

  // version history
  // v1.0.0.0 : First release
  // v1.0.0.1 : Fixed : Issue with parsing nodes
  // v1.0.1.0 : New: Language property
  // v1.0.2.0 : New: ResultAddress properties:
  //            Suburb, StateCode, RegionCode, PostalTown
  // v1.0.2.1 : Fixed : Issue with UTF8 encoding in retrieving results
  // v1.0.3.0 : New : Published property APIKey

type

  TWebGMapsAddress = class(TPersistent)
  private
    FWebGmapsGeocodingService: TTMSFMXWebGMapsGeocodingService;
    FFormattedAddress: string;
    FStreetNumber: string;
    FStreet: string;
    FPostalCode: string;
    FCountry: string;
    FCity: string;
    FRegion: string;
    FCountryCode: string;
    FState: string;
    FPostalTown: string;
    FRegionCode: string;
    FStateCode: string;
    FSuburb: string;
    procedure SetFormattedAddress(const Value: string);
    procedure SetStreetNumber(const Value: string);
    procedure SetStreet(const Value: string);
    procedure SetCity(const Value: string);
    procedure SetCountry(const Value: string);
    procedure SetPostalCode(const Value: string);
    procedure SetRegion(const Value: string);
    procedure SetCounntryCode(const Value: string);
    procedure SetState(const Value: string);
    procedure SetPostalTown(const Value: string);
    procedure SetRegionCode(const Value: string);
    procedure SetStateCode(const Value: string);
    procedure SetSuburb(const Value: string);
  protected
  public
    constructor Create(AWebGmapsGeocodingService: TTMSFMXWebGMapsGeocodingService);
  published
    property FormattedAddress: string read FFormattedAddress write SetFormattedAddress;
    property StreetNumber: string read FStreetNumber write SetStreetNumber;
    property Street: string read FStreet write SetStreet;
    property City: string read FCity write SetCity;
    property Suburb: string read FSuburb write SetSuburb;
    property State: string read FState write SetState;
    property StateCode: string read FStateCode write SetStateCode;
    property Region: string read FRegion write SetRegion;
    property RegionCode: string read FRegionCode write SetRegionCode;
    property Country: string read FCountry write SetCountry;
    property CountryCode: string read FCountryCode write SetCounntryCode;
    property PostalCode: string read FPostalCode write SetPostalCode;
    property PostalTown: string read FPostalTown write SetPostalTown;
  end;

  {$IFDEF DELPHIXE5_LVL}
  [ComponentPlatformsAttribute(pidiOSSimulator or {$IFDEF DELPHIXE8_LVL}pidiOSDevice32 or pidiOSDevice64{$ELSE}pidiOSDevice{$ENDIF} or pidOSX32 or pidAndroid or pidWin32 or pidWin64)]
  {$ELSE}
  [ComponentPlatformsAttribute(pidiOSSimulator or pidiOSDevice or pidOSX32 or pidWin32 or pidWin64)]
  {$ENDIF}
  TTMSFMXWebGMapsReverseGeocoding = class(TTMSFMXWebGMapsGeocodingService)
  private
    FLatitude: Double;
    FLongitude: Double;
    FResultAddress: TWebGMapsAddress;
    FLanguage: TLanguageName;
    FAPIKey: string;
    function FoundNode(XmlNode: IXmlNode; NodeName: String): IXmlNode;
    function GetVersion: string;
    procedure SetVersion(const Value: string);
    procedure SetLatitude(const Value: Double);
    procedure SetLongitude(const Value: Double);
    procedure SetLanguage(const Value: TLanguageName);
  protected
    function GetVersionNr: integer; virtual;
    function SetCoord(d: double): string;
  public
    destructor Destroy; override;
    Constructor Create(AOwner:TComponent); override;
    function LaunchReverseGeocoding : TGeocodingResult;
  published
    property APIKey: string read FAPIKey write FAPIKey;
    property ResultAddress : TWebGMapsAddress read FResultAddress;
    property Language : TLanguageName read FLanguage write SetLanguage default lnDefault;
    property Latitude     : Double read FLatitude write SetLatitude;
    property Longitude    : Double read FLongitude write SetLongitude;

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

constructor TTMSFMXWebGMapsReverseGeocoding.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FAPIKey       := '';
  FLatitude     := 0;
  FLongitude    := 0;
  FResultAddress := TWebGMapsAddress.Create(Self);
end;

destructor TTMSFMXWebGMapsReverseGeocoding.Destroy;
begin
  FResultAddress.Free;
  inherited Destroy;
end;

function TTMSFMXWebGMapsReverseGeocoding.FoundNode(XmlNode : IXmlNode;NodeName : String) : IXmlNode;
var
 i : integer;
begin
  Result := nil;

  if not Assigned(XMLNode) then
    Exit;

  if XMLNode.NodeType <> ntElement then
    Exit;

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

function TTMSFMXWebGMapsReverseGeocoding.SetCoord(d: double): string;
begin
  Result := FloatToStr(d);
  if FormatSettings.DecimalSeparator <> '.' then
    Result := ReplaceStr(Result, FormatSettings.DecimalSeparator, '.');
end;

procedure TTMSFMXWebGMapsReverseGeocoding.SetLanguage(
  const Value: TLanguageName);
begin
  FLanguage := Value;
end;

procedure TTMSFMXWebGMapsReverseGeocoding.SetLatitude(const Value: Double);
begin
  FLatitude := Value;
end;

procedure TTMSFMXWebGMapsReverseGeocoding.SetLongitude(const Value: Double);
begin
  FLongitude := Value;
end;

function TTMSFMXWebGMapsReverseGeocoding.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(System.Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(System.Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

function TTMSFMXWebGMapsReverseGeocoding.GetVersionNr: integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TTMSFMXWebGMapsReverseGeocoding.LaunchReverseGeocoding: TGeocodingResult;
var
  Url:String;
  XmlDoc:TxmlDocument;
  Node, Nodes:IXmlNode;
  i: integer;
  LanguageCode: string;
begin
  LanguageCode := GetEnumName(TypeInfo(TLanguageCode),ord(Language));
  LanguageCode := ReplaceText(LanguageCode,'_','-');  Result := erOtherProblem;

  XmlDoc := TXMLDocument.Create(Self);
  Url := GEOCODING_BASE_URL + GEOCODING_REVERSESTART_URL;
  Url := Url + string(URLEncode(string(UTF8Encode(SetCoord(FLatitude) + ',' + SetCoord(FLongitude)))));
  Url := Url + '&language=' + languagecode;
  Url := Url + GEOCODING_END_URL;

  if APIKey <> '' then
    Url := Url + '&key=' + APIKey;

  try
    try
      XmlDoc.XML.Text := String(HTTPSGet(Url));
      XmlDoc.Active := True;

      Node := FoundNode(XmlDoc.DocumentElement,GEOCODING_STATUS);
      if Assigned(Node) then
      begin
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
        Node := FoundNode(XmlDoc.DocumentElement,GEOCODING_ADDRESS);
        if Assigned(Node) then
        begin
          try
            FResultAddress.FormattedAddress := Node.Text;
          except
            FResultAddress.FormattedAddress := '';
          end;
        end
        else
        begin
          FResultAddress.FormattedAddress := '';
        end;

        Node := FoundNode(XmlDoc.DocumentElement,'result');

        FResultAddress.Street := '';
        FResultAddress.StreetNumber := '';
        FResultAddress.Suburb := '';
        FResultAddress.City := '';
        FResultAddress.Region := '';
        FResultAddress.RegionCode := '';
        FResultAddress.PostalCode := '';
        FResultAddress.PostalTown := '';
        FResultAddress.Country := '';
        FResultAddress.CountryCode := '';

        if Assigned(Node) then
        begin
          for I := 0 to Node.ChildNodes.Count - 1 do
          begin
            try
              if Node.ChildNodes[I].NodeName = 'address_component' then
              begin
                Nodes := Node.ChildNodes[I];
                if Nodes.ChildNodes.Count >= 2 then
                begin
                  if Nodes.ChildNodes[2].Text = 'route' then
                    FResultAddress.Street := Nodes.ChildNodes[0].Text;
                  if Nodes.ChildNodes[2].Text = 'street_number' then
                    FResultAddress.StreetNumber := Nodes.ChildNodes[0].Text;
                  if Nodes.ChildNodes[2].Text = 'locality' then
                    FResultAddress.City := Nodes.ChildNodes[0].Text;
                  if Nodes.ChildNodes[2].Text = 'sublocality' then
                    FResultAddress.Suburb := Nodes.ChildNodes[0].Text;
                  if Nodes.ChildNodes[2].Text = 'country' then
                  begin
                    FResultAddress.Country := Nodes.ChildNodes[0].Text;
                    FResultAddress.CountryCode := Nodes.ChildNodes[1].Text;
                  end;
                  if (Nodes.ChildNodes[2].Text = 'postal_code') or (Nodes.ChildNodes[2].Text = 'postal_code_prefix') then
                    FResultAddress.PostalCode := Nodes.ChildNodes[0].Text;
                  if Nodes.ChildNodes[2].Text = 'postal_town' then
                    FResultAddress.PostalTown := Nodes.ChildNodes[0].Text;
                  if Nodes.ChildNodes[2].Text = 'administrative_area_level_2' then
                  begin
                    FResultAddress.Region := Nodes.ChildNodes[0].Text;
                    FResultAddress.RegionCode := Nodes.ChildNodes[1].Text;
                  end;
                  if Nodes.ChildNodes[2].Text = 'administrative_area_level_1' then
                  begin
                    FResultAddress.State := Nodes.ChildNodes[0].Text;
                    FResultAddress.StateCode := Nodes.ChildNodes[1].Text;
                  end;
                end;
              end;
            except
              //
            end;
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

{ TWebGMapsAddress }

constructor TWebGMapsAddress.Create(
  AWebGmapsGeocodingService: TTMSFMXWebGMapsGeocodingService);
begin
  inherited Create;
  FWebGmapsGeocodingService       := AWebGmapsGeocodingService;
  FFormattedAddress := '';
  FStreetNumber := '';
  FStreet := '';
  FSuburb := '';
  FCity := '';
  FCountry := '';
  FRegion := '';
  FRegionCode := '';
  FPostalCode := '';
  FPostalTown := '';
  FCountryCode := '';
  FState := '';
  FStateCode := '';
end;

procedure TWebGMapsAddress.SetCity(const Value: string);
begin
  FCity := Value;
end;

procedure TWebGMapsAddress.SetCounntryCode(const Value: string);
begin
  FCountryCode := Value;
end;

procedure TWebGMapsAddress.SetCountry(const Value: string);
begin
  FCountry := Value;
end;

procedure TWebGMapsAddress.SetFormattedAddress(const Value: string);
begin
  FFormattedAddress := Value;
end;

procedure TWebGMapsAddress.SetPostalCode(const Value: string);
begin
  FPostalCode := Value;
end;

procedure TWebGMapsAddress.SetPostalTown(const Value: string);
begin
  FPostalTown := Value;
end;

procedure TWebGMapsAddress.SetRegion(const Value: string);
begin
  FRegion := Value;
end;

procedure TWebGMapsAddress.SetRegionCode(const Value: string);
begin
  FRegionCode := Value;
end;

procedure TWebGMapsAddress.SetState(const Value: string);
begin
  FState := Value;
end;

procedure TWebGMapsAddress.SetStateCode(const Value: string);
begin
  FStateCode := Value;
end;

procedure TWebGMapsAddress.SetStreet(const Value: string);
begin
  FStreet := Value;
end;

procedure TWebGMapsAddress.SetStreetNumber(const Value: string);
begin
  FStreetNumber := Value;
end;

procedure TWebGMapsAddress.SetSuburb(const Value: string);
begin
  FSuburb := Value;
end;

procedure TTMSFMXWebGMapsReverseGeocoding.SetVersion(const Value: string);
begin

end;

end.
