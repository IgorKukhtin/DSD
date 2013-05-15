unit dsdAddOn;

interface

uses Classes, cxDBTL, cxTL, Vcl.ImgList;

type


  TdsdDBTreeAddOn = class(TComponent)
  private
    FDBTreeList: TcxDBTreeList;
    procedure SetDBTreeList(const Value: TcxDBTreeList);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure onGetNodeImageIndex(Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
              AIndexType: TcxTreeListImageIndexType; var AIndex: TImageIndex);
  published
    property DBTreeList: TcxDBTreeList read FDBTreeList write SetDBTreeList;
  end;

  procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdDBTreeAddOn]);
end;

{ TdsdDBTreeAddOn }

procedure TdsdDBTreeAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DBTreeList) then
     DBTreeList := nil;
end;

procedure TdsdDBTreeAddOn.onGetNodeImageIndex(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
  var AIndex: TImageIndex);
begin
  if ANode.Expanded then
     AIndex := 1
  else
     AIndex := 0;
end;

procedure TdsdDBTreeAddOn.SetDBTreeList(const Value: TcxDBTreeList);
begin
  FDBTreeList := Value;
  if Assigned(FDBTreeList) then
     FDBTreeList.OnGetNodeImageIndex := onGetNodeImageIndex;
end;

initialization

  RegisterClass(TdsdDBTreeAddOn);

end.
