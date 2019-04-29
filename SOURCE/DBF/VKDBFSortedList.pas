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
unit VKDBFSortedList;

interface

uses
  Windows, Messages, SysUtils, Classes, contnrs;

const
  FNULL = -1;
  FROOT = -2;
  COLOR_BLACK = 0;
  COLOR_RED = 1;

type

  {TVKSortedListAbstract}
  TVKSortedListAbstract = class(TObjectList)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  {TVKSortedObject}
  TVKSortedObject = class
  private
    Fbalance: ShortInt;
    Fdad: TVKSortedObject;
    Flson: TVKSortedObject;
    Frson: TVKSortedObject;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearTreeEntrance;
    function cpm(sObj: TVKSortedObject): Integer; virtual;
    property rson: TVKSortedObject read Frson write Frson;
    property lson: TVKSortedObject read Flson write Flson;
    property dad: TVKSortedObject read Fdad write Fdad;
    property balance: ShortInt read Fbalance write Fbalance;
  end;

  TSortedListTraversalEvent = procedure(Sender: TVKSortedListAbstract; SortedObject: TVKSortedObject) of object;

  {TVKSortedList}
  TVKSortedList = class(TVKSortedListAbstract)
  private
    FOnTraversal: TSortedListTraversalEvent;
    FMaxLevel: Integer;
    procedure LeftRotate(NodeObject: TVKSortedObject);
    procedure RightRotate(NodeObject: TVKSortedObject);
    function AddInTree(NodeObject: TVKSortedObject): boolean;
    function DeleteFromTree(NodeObject: TVKSortedObject): boolean;
    function Balance(NodeObject: TVKSortedObject; BalanceFactor: ShortInt): boolean;
    function BalanceForDel(NodeObject: TVKSortedObject; BalanceFactor: ShortInt): boolean;
  protected
    Root: TVKSortedObject;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function Add(AObject: TVKSortedObject): Integer;
    procedure Insert(Index: Integer; AObject: TVKSortedObject);
    function Remove(AObject: TVKSortedObject): Integer;
    procedure UpdateObjectInTree(AObject: TVKSortedObject);
    function FindKey(KeyObject: TVKSortedObject): TVKSortedObject;
    procedure Traversal;
    property MaxLevel: Integer read FMaxLevel;
    property OnTraversal: TSortedListTraversalEvent read FOnTraversal write FOnTraversal;
  end;

implementation

{ TVKSortedListAbstract }

constructor TVKSortedListAbstract.Create;
begin
  inherited Create;
end;

destructor TVKSortedListAbstract.Destroy;
begin
  inherited Destroy;
end;

{ TVKSortedObject }

procedure TVKSortedObject.ClearTreeEntrance;
begin
  Fbalance := 0;
  Fdad  := nil;
  Flson := nil;
  Frson := nil;
end;

function TVKSortedObject.cpm(sObj: TVKSortedObject): Integer;
begin
  Result := 1;
end;

constructor TVKSortedObject.Create;
begin
  inherited Create;
  Fbalance := 0;
  Fdad   := nil;
  Flson  := nil;
  Frson  := nil;
end;

destructor TVKSortedObject.Destroy;
begin
  inherited Destroy;
end;

{ TVKSortedList }

function TVKSortedList.Add(AObject: TVKSortedObject): Integer;
begin
  Result := inherited Add(AObject);
  AddInTree(AObject);
end;

function TVKSortedList.AddInTree(NodeObject: TVKSortedObject): boolean;
var
  Level: Integer;

  function AddInTreeInternal(RootNodeObject: TVKSortedObject): boolean;
  var
    c: Integer;
    CurrentObject: TVKSortedObject;
  begin
    Inc(Level);
    c := RootNodeObject.cpm(NodeObject);  //for root object alwase get 1
    if c >= 0 then begin //NodeObject >= RootNodeObject
      CurrentObject := RootNodeObject.rson;
      if CurrentObject <> nil then
        Result := AddInTreeInternal(CurrentObject)
      else begin
        RootNodeObject.rson := NodeObject;
        NodeObject.dad := RootNodeObject;
        Result := true;
      end;
    end else begin
      CurrentObject := RootNodeObject.lson;
      if CurrentObject <> nil then
        Result := AddInTreeInternal(CurrentObject)
      else begin
        RootNodeObject.lson := NodeObject;
        NodeObject.dad := RootNodeObject;
        Result := true;
      end;
    end;
  end;

begin
  Level := 0;
  NodeObject.ClearTreeEntrance;
  Result := AddInTreeInternal(Root);
  if Level > FMaxLevel then FMaxLevel := Level;
  if NodeObject.dad.rson = NodeObject then
    Balance(NodeObject.dad, 1)
  else
    Balance(NodeObject.dad, -1);
end;

function TVKSortedList.Balance(NodeObject: TVKSortedObject;
  BalanceFactor: ShortInt): boolean;
var
  Son, GrandSon: TVKSortedObject;
begin
  Result := False;
  if NodeObject.dad <> nil then begin
    NodeObject.balance := NodeObject.balance + BalanceFactor;
    case NodeObject.balance of
      0: Result := True;
      1, -1:
        begin
          if NodeObject.dad.rson = NodeObject then
            Result := Balance(NodeObject.dad, 1)
          else
            Result := Balance(NodeObject.dad, -1);
        end;
      2, -2:
        begin
          if NodeObject.balance > 0 then begin
            Son := NodeObject.rson;
            case Son.balance of
              0:
                begin
                  LeftRotate(NodeObject);
                  NodeObject.balance := 1;
                  Son.balance := -1;
                  Result := True;
                end;
              1:
                begin
                  LeftRotate(NodeObject);
                  NodeObject.balance := 0;
                  Son.balance := 0;
                  Result := True;
                end;
              -1:
                begin
                  GrandSon := Son.lson;
                  RightRotate(Son);
                  LeftRotate(NodeObject);
                  case GrandSon.balance of
                    -1:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := 1;
                        GrandSon.balance := 0;
                      end;
                    0:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := 0;
                        GrandSon.balance := 0;
                      end;
                    1:
                      begin
                        NodeObject.balance := -1;
                        Son.balance := 0;
                        GrandSon.balance := 0;
                      end;
                  else
                    raise Exception.Create('TVKSortedList.Balance: Illegal range of balance factor - [' + IntToStr(GrandSon.balance) + '] !');
                  end;
                  Result := True;
                  (*
                  if GrandSon.dad.rson = GrandSon then
                    Result := Balance(GrandSon.dad, 1)
                  else
                    Result := Balance(GrandSon.dad, -1);
                  *)
                end;
            end;
          end else begin
            Son := NodeObject.lson;
            case Son.balance of
              -1:
                begin
                  RightRotate(NodeObject);
                  NodeObject.balance := 0;
                  Son.balance := 0;
                  Result := True;
                end;
              0:
                begin
                  RightRotate(NodeObject);
                  NodeObject.balance := -1;
                  Son.balance := 1;
                  Result := True;
                end;
              1:
                begin
                  GrandSon := Son.rson;
                  LeftRotate(Son);
                  RightRotate(NodeObject);
                  case GrandSon.balance of
                    -1:
                      begin
                        NodeObject.balance := 1;
                        Son.balance := 0;
                        GrandSon.balance := 0;
                      end;
                    0:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := 0;
                        GrandSon.balance := 0;
                      end;
                    1:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := -1;
                        GrandSon.balance := 0;
                      end;
                  else
                    raise Exception.Create('TVKSortedList.Balance: Illegal range of balance factor - [' + IntToStr(GrandSon.balance) + '] !');
                  end;
                  Result := True;
                  (*
                  if GrandSon.dad.rson = GrandSon then
                    Result := Balance(GrandSon.dad, 1)
                  else
                    Result := Balance(GrandSon.dad, -1);
                  *)
                end;
            end;
          end;
        end;
    else
      raise Exception.Create('TVKSortedList.Balance: Illegal range of balance factor - [' + IntToStr(NodeObject.balance) + '] !');
    end;
  end;
end;

function TVKSortedList.BalanceForDel(NodeObject: TVKSortedObject;
  BalanceFactor: ShortInt): boolean;
var
  Son, GrandSon: TVKSortedObject;
  NewBalance: ShortInt;
begin
  Result := False;
  if NodeObject.dad <> nil then begin
    NewBalance := NodeObject.balance + BalanceFactor;
    NodeObject.balance := NewBalance;
    case NewBalance of
      0:
        begin
          if NodeObject.dad.rson = NodeObject then
            Result := BalanceForDel(NodeObject.dad, -1)
          else
            Result := BalanceForDel(NodeObject.dad, 1);
        end;
      1, -1: Result := True;
      2, -2:
        begin
          if NewBalance > 0 then begin
            Son := NodeObject.rson;
            case Son.balance of
              0:
                begin
                  LeftRotate(NodeObject);
                  NodeObject.balance := 1;
                  Son.balance := -1;
                  Result := True;
                end;
              1:
                begin
                  LeftRotate(NodeObject);
                  NodeObject.balance := 0;
                  Son.balance := 0;
                  //
                  if Son.dad.rson = Son then
                    Result := BalanceForDel(Son.dad, -1)
                  else
                    Result := BalanceForDel(Son.dad, 1);
                  //
                end;
              -1:
                begin
                  grandson := Son.lson;
                  RightRotate(son);
                  LeftRotate(NodeObject);
                  case grandson.balance of
                    -1:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := 1;
                        grandson.balance := 0;
                      end;
                    0:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := 0;
                        grandson.balance := 0;
                      end;
                    1:
                      begin
                        NodeObject.balance := -1;
                        son.balance := 0;
                        grandson.balance := 0;
                      end;
                  else
                    raise Exception.Create('TVKSortedList.BalanceForDel: Illegal range of balance factor!');
                  end;
                  //
                  if grandson.dad.rson = grandson then
                    Result := BalanceForDel(grandson.dad, -1)
                  else
                    Result := BalanceForDel(grandson.dad, 1);
                  //
                end;
            else
              raise Exception.Create('TVKSortedList.BalanceForDel: Illegal range of balance factor!');
            end;
          end else begin
            son := NodeObject.lson;
            case Son.balance of
              -1:
                begin
                  RightRotate(NodeObject);
                  NodeObject.balance := 0;
                  Son.balance := 0;
                  //
                  if Son.dad.rson = Son then
                    Result := BalanceForDel(Son.dad, -1)
                  else
                    Result := BalanceForDel(Son.dad, 1);
                  //
                end;
              0:
                begin
                  RightRotate(NodeObject);
                  NodeObject.balance := -1;
                  Son.balance := 1;
                  Result := True;
                end;
              1:
                begin
                  grandson := son.rson;
                  LeftRotate(son);
                  RightRotate(NodeObject);
                  case grandson.balance of
                    -1:
                      begin
                        NodeObject.balance := 1;
                        Son.balance := 0;
                        grandson.balance := 0;
                      end;
                    0:
                      begin
                        NodeObject.balance := 0;
                        son.balance := 0;
                        grandson.balance := 0;
                      end;
                    1:
                      begin
                        NodeObject.balance := 0;
                        Son.balance := -1;
                        grandson.balance := 0;
                      end;
                  else
                    raise Exception.Create('TVKSortedList.BalanceForDel: Illegal range of balance factor!');
                  end;
                  //
                  if grandson.dad.rson = grandson then
                    Result := BalanceForDel(grandson.dad, -1)
                  else
                    Result := BalanceForDel(grandson.dad, 1);
                  //
                end;
            else
              raise Exception.Create('TVKSortedList.BalanceForDel: Illegal range of balance factor!');
            end;
          end;
        end;
    else
      raise Exception.Create('TVKSortedList.BalanceForDel: Illegal range of balance factor!');
    end;

  end;

end;

procedure TVKSortedList.Clear;
begin
  inherited Clear;
  if Root <> nil then Root.ClearTreeEntrance;
end;

constructor TVKSortedList.Create;
begin
  inherited Create;
  Root := TVKSortedObject.Create;
  FMaxLevel := 0;
end;

function TVKSortedList.DeleteFromTree(
  NodeObject: TVKSortedObject): boolean;
var
  x, y: TVKSortedObject;
  BalanceInc: ShortInt;
begin
  Result := False;
  if NodeObject.dad = nil then Exit;
  if NodeObject.rson = nil then begin
    x := NodeObject.lson;
    y := NodeObject.dad;
    if y.rson = NodeObject then
      BalanceInc := -1
    else
      BalanceInc := 1;
  end else
    if NodeObject.lson = nil then begin
      x := NodeObject.rson;
      y := NodeObject.dad;
      if y.rson = NodeObject then
        BalanceInc := -1
      else
        BalanceInc := 1;
    end else begin
      x := NodeObject.lson;
      if x.rson <> nil then begin
        while True do begin
          x := x.rson;
          if x.rson = nil then break;
        end;
        y := x.dad;
        if y.rson = x then
          BalanceInc := -1
        else
          BalanceInc := 1;
        x.dad.rson := x.lson;
        if x.lson <> nil then x.lson.dad := x.dad;
        x.lson := NodeObject.lson;
        if NodeObject.lson <> nil then NodeObject.lson.dad := x;
        x.balance := NodeObject.balance;
      end else begin
        x.balance := NodeObject.balance;
        y := x;
        BalanceInc := 1;
      end;
      x.rson := NodeObject.rson;
      if NodeObject.rson <> nil then NodeObject.rson.dad := x;
    end;
  if x <> nil then x.dad := NodeObject.dad;
  if NodeObject.dad.rson = NodeObject then begin
    NodeObject.dad.rson := x;
  end else begin
    NodeObject.dad.lson := x;
  end;
  BalanceForDel(y, BalanceInc);
  NodeObject.ClearTreeEntrance;
  Result := True;
end;

destructor TVKSortedList.Destroy;
begin
  FreeAndNil(Root);
  inherited Destroy;
end;

function TVKSortedList.FindKey(KeyObject: TVKSortedObject): TVKSortedObject;

  function FindKeyInternal(RootNodeObject: TVKSortedObject): TVKSortedObject;
  var
    c: Integer;
    CurrentObject: TVKSortedObject;
  begin
    c := RootNodeObject.cpm(KeyObject);  //for root object alwase get 1
    if c > 0 then begin //KeyObject > RootNodeObject
      CurrentObject := RootNodeObject.rson;
      if CurrentObject <> nil then
        Result := FindKeyInternal(CurrentObject)
      else begin
        Result := nil;
      end;
    end else if c = 0 then begin
      Result := RootNodeObject;
    end else begin
      CurrentObject := RootNodeObject.lson;
      if CurrentObject <> nil then
        Result := FindKeyInternal(CurrentObject)
      else begin
        Result := nil;
      end;
    end;
  end;

begin
  Result := FindKeyInternal(Root);
end;

procedure TVKSortedList.Insert(Index: Integer; AObject: TVKSortedObject);
begin
  inherited Insert(Index, AObject);
  AddInTree(AObject);
end;

procedure TVKSortedList.LeftRotate(NodeObject: TVKSortedObject);
var
  Dad, Son, GrandSon: TVKSortedObject;
begin
  Dad := NodeObject.dad;
  Son := NodeObject.rson;
  GrandSon := Son.lson;
  if Dad.rson = NodeObject then
    Dad.rson := Son
  else
    Dad.lson := Son;
  NodeObject.dad := Son;
  Son.dad := Dad;
  Son.lson := NodeObject;
  NodeObject.rson := GrandSon;
  if GrandSon <> nil then GrandSon.dad := NodeObject;
end;

function TVKSortedList.Remove(AObject: TVKSortedObject): Integer;
begin
  Result := inherited Remove(AObject);
  DeleteFromTree(AObject);
end;

procedure TVKSortedList.RightRotate(NodeObject: TVKSortedObject);
var
  Dad, Son, GrandSon: TVKSortedObject;
begin
  Dad := NodeObject.dad;
  Son := NodeObject.lson;
  GrandSon := Son.rson;
  if Dad.rson = NodeObject then
    Dad.rson := Son
  else
    Dad.lson := Son;
  NodeObject.dad := Son;
  Son.dad := Dad;
  Son.rson := NodeObject;
  NodeObject.lson := GrandSon;
  if GrandSon <> nil then GrandSon.dad := NodeObject;
end;

procedure TVKSortedList.Traversal;
var
  Level: Integer;

  procedure TraversalInternal(RootNodeObject: TVKSortedObject);
  begin
    Inc(Level);
    if Level > FMaxLevel then FMaxLevel := Level;
    if RootNodeObject.lson <> nil then TraversalInternal(RootNodeObject.lson);
    if Assigned(OnTraversal) then OnTraversal(self, RootNodeObject);
    if RootNodeObject.rson <> nil then TraversalInternal(RootNodeObject.rson);
    Dec(Level);
  end;

begin
  Level := 0;
  FMaxLevel := 0;
  if Root.rson <> nil then TraversalInternal(Root.rson);
end;

procedure TVKSortedList.UpdateObjectInTree(AObject: TVKSortedObject);
begin
  DeleteFromTree(AObject);
  AddInTree(AObject);
end;

end.
