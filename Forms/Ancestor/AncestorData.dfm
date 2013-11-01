inherited AncestorDataForm: TAncestorDataForm
  PixelsPerInch = 96
  TextHeight = 13
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spMainData
      StoredProcList = <
        item
          StoredProc = spMainData
        end>
    end
  end
  object MainDataDS: TDataSource
    DataSet = MainDataCDS
    Left = 48
    Top = 16
  end
  object MainDataCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 16
  end
  object spMainData: TdsdStoredProc
    DataSet = MainDataCDS
    DataSets = <
      item
        DataSet = MainDataCDS
      end>
    Params = <>
    Left = 80
    Top = 16
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 120
    Top = 16
    DockControlHeights = (
      0
      0
      26
      0)
    object Bar: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
  end
end
