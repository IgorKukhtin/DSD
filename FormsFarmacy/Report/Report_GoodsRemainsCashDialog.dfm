inherited Report_GoodsRemainsCashDialogForm: TReport_GoodsRemainsCashDialogForm
  ClientHeight = 181
  ClientWidth = 340
  ExplicitWidth = 346
  ExplicitHeight = 210
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
  inherited сbPartion: TcxCheckBox
    ExplicitHeight = 21
  end
  inherited cbPartionPrice: TcxCheckBox
    ExplicitHeight = 21
  end
  inherited сbJuridical: TcxCheckBox
    ExplicitHeight = 21
  end
  inherited cbVendorminPrices: TcxCheckBox
    ExplicitHeight = 21
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
  inherited ActionList: TActionList
    inherited actRefreshStart: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spGet_OperDate
        end>
    end
  end
  object spGet_OperDate: TdsdStoredProc
    StoredProcName = 'gpGet_OperDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'OperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 128
  end
end
