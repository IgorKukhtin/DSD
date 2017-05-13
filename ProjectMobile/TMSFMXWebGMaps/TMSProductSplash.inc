{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2016                                        }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

{$I TMSProductInfo.inc}

const
  SplashSize = 24;

{$R TMSProductSplash.res}

function GetProductCategoryIcon(AProductCategory: TProductCategory): TBitmap;
begin
  Result := TBitmap.Create;
  case AProductCategory of
    pcVCL: Result.LoadFromResourceName(HInstance, 'VCL');
    pcFMX: Result.LoadFromResourceName(HInstance, 'FMX');
    pcFNC: Result.LoadFromResourceName(HInstance, 'FNC');
    pcBIZ: Result.LoadFromResourceName(HInstance, 'BIZ');
    pcNET: Result.LoadFromResourceName(HInstance, 'NET');
    pcIW: Result.LoadFromResourceName(HInstance, 'IW');
    pcLCL: Result.LoadFromResourceName(HInstance, 'LCL');
    pcDEV: Result.LoadFromResourceName(HInstance, 'DEV');
    pcFREE: Result.LoadFromResourceName(HInstance, 'FREE');
  end;

  Result.Canvas.Brush.Style := bsClear;
  Result.Canvas.Pen.Color := clFuchsia;
  Result.Canvas.Rectangle(Bounds(0, 0, Result.Width, Result.Height));
end;

procedure AddSplash;
var
  bmp: TBitmap;
begin
  ForceDemandLoadState(dlDisable);
  bmp := GetProductCategoryIcon(GetProductCategory);
  try
    SplashScreenServices.AddPluginBitmap(GetProductName + ' ' + GetProductVersion, bmp.Handle, false, GetProductKindName(GetProductKind),'');
  finally
    bmp.Free;
  end;
end;
