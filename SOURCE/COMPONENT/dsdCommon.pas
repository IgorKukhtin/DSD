unit dsdCommon;

interface

uses System.Classes, VCL.Controls;

type
  TdsdComponent = class(TComponent)
  private
  protected
  public
  end;

implementation

initialization
  StartClassGroup(TControl);
  GroupDescendentsWith(TdsdComponent, TControl);

end.
