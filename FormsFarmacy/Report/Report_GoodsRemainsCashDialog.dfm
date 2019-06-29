inherited Report_GoodsRemainsCashDialogForm: TReport_GoodsRemainsCashDialogForm
  PixelsPerInch = 96
  TextHeight = 13
  inherited edUnit: TcxButtonEdit
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    Style.Color = clBtnFace
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Report_GoodsRemainsDialogForm.Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
  end
  inherited UnitGuides: TdsdGuides
    DisableGuidesOpen = True
  end
end
