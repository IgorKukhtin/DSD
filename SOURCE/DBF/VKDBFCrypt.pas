{**********************************************************************************}
{                                                                                  }
{ Project vkDBF - dbf ntx clipper compatibility delphi component                   }
{                                                                                  }
{ This Source Code Form is subject to the terms of the Mozilla Public              }
{ License, v. 2.0. If a copy of the MPL was not distributed with this              }
{ file, You can obtain one at http://mozilla.org/MPL/2.0/.                         }
{                                                                                  }
{ The Initial Developer of the Original Code is Vlad Karpov (KarpovVV@protek.ru).  }
{                                                                                  }
{ Contributors:                                                                    }
{   Sergey Klochkov (HSerg@sklabs.ru)                                              }
{                                                                                  }
{ You may retrieve the latest version of this file at the Project vkDBF home page, }
{ located at http://sourceforge.net/projects/vkdbf/                                }
{                                                                                  }
{**********************************************************************************}
unit VKDBFCrypt;

interface

uses
  Classes, DB, VKDBFGostCrypt;

type

  TCryptMethod = (cmNone, cmXOR, cmGost, cmGost1, cmCustomer);
  TOnCrypt = procedure(Sender: TObject; Context: LongWord; Buff: Pointer; Size: Integer) of object;

  {TVKDBFCrypt}
  TVKDBFCrypt = class(TPersistent)
  private
    FActive: boolean;
    FCryptMethod: TCryptMethod;
    FPassword: AnsiString;
    FOnEncrypt: TOnCrypt;
    FOnDecrypt: TOnCrypt;
    FOnActivate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FObjectID: LongWord;
    FCustomerObject: TVKDBFCrypt;
    FReCryptObject: TVKDBFCrypt;
    function GetActive: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetActive(const Value: boolean); virtual;
  public
    SmartDBF: TDataSet;
    constructor Create;
    destructor Destroy; override;
    procedure Encrypt(Context: LongWord; Buff: Pointer; Size: Integer); virtual;
    procedure Decrypt(Context: LongWord; Buff: Pointer; Size: Integer); virtual;
    property ObjectID: LongWord read FObjectID write FObjectID;
    property CustomerObject: TVKDBFCrypt read FCustomerObject write FCustomerObject;
    property ReCryptObject: TVKDBFCrypt read FReCryptObject write FReCryptObject;
  published
    property Active: boolean read GetActive write SetActive;
    property CryptMethod: TCryptMethod read FCryptMethod write FCryptMethod;
    property Password: AnsiString read FPassword write FPassword;
    property OnActivateCrypt: TNotifyEvent read FOnActivate write FOnActivate;
    property OnDeactivateCrypt: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnEncrypt: TOnCrypt read FOnEncrypt write FOnEncrypt;
    property OnDecrypt: TOnCrypt read FOnDecrypt write FOnDecrypt;
  end;

implementation

{ TVKDBFCrypt }

constructor TVKDBFCrypt.Create;
begin
  inherited Create;
  FActive := false;
  FCryptMethod := cmNONE;
  FPassword := '';
  FOnEncrypt := nil;
  FOnDecrypt := nil;
  FCustomerObject := nil;
  FReCryptObject := nil;
end;

destructor TVKDBFCrypt.Destroy;
begin
  Active := false;
  inherited Destroy;
end;

procedure TVKDBFCrypt.Decrypt(Context: LongWord; Buff: Pointer; Size: Integer);
begin
  if FActive then begin
    if not Assigned(FOnDecrypt) then
      case FCryptMethod of
        cmXOR: XORDecrypt(FObjectID, Context, Buff, Size);
        cmGost, cmGost1: GostDecrypt(FObjectID, Context, Buff, Size);
        cmCustomer: FCustomerObject.Decrypt(Context, Buff, Size);
      end
    else
      FOnDecrypt(self, Context, Buff, Size);
  end;
end;

procedure TVKDBFCrypt.Encrypt(Context: LongWord; Buff: Pointer; Size: Integer);
begin
  if FReCryptObject = nil then begin
    if not Assigned(FOnEncrypt) then
      case FCryptMethod of
        cmXOR: XOREncrypt(FObjectID, Context, Buff, Size);
        cmGost, cmGost1: GostEncrypt(FObjectID, Context, Buff, Size);
        cmCustomer: FCustomerObject.Encrypt(Context, Buff, Size);
      end
    else
      FOnEncrypt(self, Context, Buff, Size);
  end else
    FReCryptObject.Encrypt(Context, Buff, Size);
end;

procedure TVKDBFCrypt.SetActive(const Value: boolean);
begin
  if Value <> FActive then begin
    FActive := Value;
    if FActive then begin
      if Assigned(FOnActivate) then
        FOnActivate(self)
      else
        case FCryptMethod of
          cmXOR: FObjectID := XORActivate(FPassword);
          cmGost: FObjectID := GostActivate(FPassword);
          cmGost1: FObjectID := Gost1Activate(FPassword);
          cmCustomer: FCustomerObject.Active := Value;
        end;
    end else begin
      if Assigned(FOnDeactivate) then
        FOnDeactivate(self)
      else
        case FCryptMethod of
          cmXOR: XORDeactivate(FObjectID);
          cmGost, cmGost1: GostDeactivate(FObjectID);
          cmCustomer: FCustomerObject.Active := Value;
        end;
    end;
  end;
end;

procedure TVKDBFCrypt.AssignTo(Dest: TPersistent);
begin
  TVKDBFCrypt(Dest).FReCryptObject    := nil;
  TVKDBFCrypt(Dest).CryptMethod       := CryptMethod;
  TVKDBFCrypt(Dest).CustomerObject    := CustomerObject;
  TVKDBFCrypt(Dest).Password          := Password;
  TVKDBFCrypt(Dest).OnActivateCrypt   := OnActivateCrypt;
  TVKDBFCrypt(Dest).OnDeactivateCrypt := OnDeactivateCrypt;
  TVKDBFCrypt(Dest).OnEncrypt         := OnEncrypt;
  TVKDBFCrypt(Dest).OnDecrypt         := OnDecrypt;
  TVKDBFCrypt(Dest).Active            := False;
  TVKDBFCrypt(Dest).Active            := Active;
end;

function TVKDBFCrypt.GetActive: boolean;
begin
  if FReCryptObject <> nil then
    Result := FReCryptObject.Active
  else
    Result := FActive;
end;

end.
