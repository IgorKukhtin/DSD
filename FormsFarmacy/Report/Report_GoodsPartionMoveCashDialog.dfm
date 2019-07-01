inherited Report_GoodsPartionMoveCashDialogForm: TReport_GoodsPartionMoveCashDialogForm
  Caption = 'Report_GoodsPartionMoveCashDialogForm'
  ExplicitWidth = 330
  ExplicitHeight = 288
  PixelsPerInch = 96
  TextHeight = 13
  inherited edUnit: TcxButtonEdit
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Style.Color = clBtnFace
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Report_GoodsPartionMoveDialogForm.Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
  end
  inherited UnitGuides: TdsdGuides
    DisableGuidesOpen = True
  end
end
