inherited Report_GoodsRemainsCashForm: TReport_GoodsRemainsCashForm
  Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
  ClientHeight = 495
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitHeight = 534
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Height = 431
    TabOrder = 0
    ExplicitTop = 64
    ExplicitHeight = 431
    ClientRectBottom = 431
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 431
      inherited cxGrid: TcxGrid
        Height = 431
        ExplicitTop = 0
        ExplicitHeight = 431
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited Panel: TPanel
    TabOrder = 2
    inherited edUnit: TcxButtonEdit
      Left = 323
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.Color = clBtnFace
      ExplicitLeft = 323
    end
    inherited cbVendorminPrices: TcxCheckBox
      ExplicitHeight = 21
    end
  end
  inherited cbPartion: TcxCheckBox
    TabOrder = 4
    ExplicitHeight = 21
  end
  inherited cbPartionPrice: TcxCheckBox
    TabOrder = 6
    ExplicitHeight = 21
  end
  inherited cbJuridical: TcxCheckBox
    ExplicitHeight = 21
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Report_GoodsRemainsForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    inherited actOpenPartionReport: TdsdOpenForm
      Enabled = False
    end
    inherited ExecuteDialog: TExecuteDialog
      FormName = 'TReport_GoodsRemainsCashDialogForm'
      FormNameParam.Value = 'TReport_GoodsRemainsCashDialogForm'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited GuidesUnit: TdsdGuides
    DisableGuidesOpen = True
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 320
  end
end
