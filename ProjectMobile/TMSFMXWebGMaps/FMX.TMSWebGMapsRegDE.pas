{**************************************************************************}
{ TMS FMX WebGMaps component                                               }
{ for Delphi & C++Builder                                                  }
{                                                                          }
{ Copyright © 2017                                                         }
{   TMS Software                                                           }
{   Email : info@tmssoftware.com                                           }
{   Web : http://www.tmssoftware.com                                       }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit FMX.TMSWebGMapsRegDE;

interface

uses
  Windows, Classes, DesignIntf, DesignEditors, FMX.TMSWebGMaps;

type
  TTMSFMXWebGMapsEditor = class(TDefaultEditor)
  protected
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

procedure Register;

implementation

uses
  SysUtils, VCL.Graphics, ToolsApi, VCL.Dialogs, VCL.Forms, ShellAPI;

{$I TMSProductSplash.inc}

procedure Register;
begin
  ForceDemandLoadState(dlDisable);
  AddSplash;
  RegisterComponentEditor(TTMSFMXWebGMaps, TTMSFMXWebGMapsEditor);
end;

{ TTMSFMXWebGMapsEditor }

procedure TTMSFMXWebGMapsEditor.ExecuteVerb(Index: integer);
begin
  case Index of
    0: MessageDlg(Component.ClassName + ' ' + (Component as TTMSFMXWebGMaps).GetVersion + #13#10'© 2017 TMS Software', mtInformation, [mbOK], 0);
    1:
    begin
      ShellExecute(0, 'open', 'http://www.tmssoftware.biz/download/manuals/TMSFMXWebGMapsDevGuide.pdf', nil, nil, SW_SHOW);
    end;
    2:
    begin
      ShellExecute(0, 'open', 'http://www.tmssoftware.com/site/tmsfmxwebgmaps.asp?s=faq', nil, nil, SW_SHOW);
    end;
  end;
end;

function TTMSFMXWebGMapsEditor.GetVerb(index: integer): string;
begin
  case index of
    0: Result := '&About';
    1: Result := '&Manual';
    2: Result := '&Tips && FAQ';
  end;
end;

function TTMSFMXWebGMapsEditor.GetVerbCount: integer;
begin
  Result := 3;
end;

end.
