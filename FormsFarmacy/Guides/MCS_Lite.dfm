inherited MCS_LiteForm: TMCS_LiteForm
  Caption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
  ClientHeight = 419
  ClientWidth = 758
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  ExplicitWidth = 774
  ExplicitHeight = 457
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel
    Width = 758
    ExplicitWidth = 758
  end
  inherited PageControl: TcxPageControl
    Width = 758
    Height = 361
    TabOrder = 2
    ExplicitWidth = 758
    ExplicitHeight = 361
    ClientRectBottom = 361
    ClientRectRight = 758
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 758
      ExplicitHeight = 361
      inherited cxGrid: TcxGrid
        Width = 758
        Height = 361
        ExplicitWidth = 758
        ExplicitHeight = 361
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited clNDSKindName: TcxGridDBColumn
            Options.Editing = False
          end
          inherited StartDate: TcxGridDBColumn [13]
            Visible = False
            VisibleForCustomization = False
          end
          inherited clDateChange: TcxGridDBColumn [14]
            Visible = False
          end
          inherited clPrice: TcxGridDBColumn [15]
            Visible = False
            Options.Editing = False
          end
          inherited clMCSDateChange: TcxGridDBColumn [16]
            Visible = False
          end
          inherited clMCSValue: TcxGridDBColumn [17]
          end
          inherited clMCSPeriod: TcxGridDBColumn [18]
            Visible = False
            VisibleForCustomization = False
          end
          inherited clMCSDay: TcxGridDBColumn [19]
            Visible = False
            VisibleForCustomization = False
          end
          inherited clMCSIsClose: TcxGridDBColumn [20]
          end
          inherited colMCSIsCloseDateChange: TcxGridDBColumn [21]
          end
          inherited clMCSNotRecalc: TcxGridDBColumn [22]
          end
          inherited colMCSNotRecalcDateChange: TcxGridDBColumn [23]
          end
          inherited colFix: TcxGridDBColumn [24]
            Options.Editing = False
          end
          inherited colFixDateChange: TcxGridDBColumn [25]
          end
          inherited clisErased: TcxGridDBColumn [26]
          end
          inherited clRemainsNotMCS: TcxGridDBColumn [27]
            Visible = False
            VisibleForCustomization = False
          end
          inherited clSummaNotMCS: TcxGridDBColumn [28]
            Visible = False
            VisibleForCustomization = False
          end
          inherited colMinExpirationDate: TcxGridDBColumn [29]
            Visible = False
            VisibleForCustomization = False
          end
          inherited colRemains: TcxGridDBColumn [30]
            Visible = False
            VisibleForCustomization = False
          end
          inherited SummaRemains: TcxGridDBColumn [31]
            Visible = False
            VisibleForCustomization = False
          end
          inherited Color_ExpirationDate: TcxGridDBColumn [32]
          end
          inherited clisPromo: TcxGridDBColumn [33]
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
    end
  end
  inherited ceUnit: TcxButtonEdit
    Enabled = False
    TabOrder = 4
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 208
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = PriceForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 63
    Top = 319
    inherited actStartLoadPrice: TMultiAction
      Enabled = False
    end
    object actGet_UserUnit: TdsdExecStoredProc [12]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh [13]
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
    inherited actRecalcMCSDialog: TExecuteDialog
      FormName = ''
      FormNameParam.Value = ''
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Price_Lite'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited dxBarButton4: TdxBarButton
      Action = nil
      Enabled = False
      Visible = ivNever
    end
    inherited dxBarButton6: TdxBarButton
      Enabled = False
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited UnitGuides: TdsdGuides
    Left = 200
    Top = 8
  end
  inherited FormParams: TdsdFormParams
    Left = 296
    Top = 96
  end
  inherited spInsertUpdate: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStartDate'
        Value = 73051d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSPeriod'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSDay'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSIsClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSIsClose'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSNotRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSNotRecalc'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFix'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Fix'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTop'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'DateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMCSDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'MCSDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMCSIsCloseDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'MCSIsCloseDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMCSNotRecalcDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'MCSNotRecalcDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFixDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'FixDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTOPDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'TOPDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPercentMarkupDateChange'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'PercentMarkupDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 264
  end
  inherited rdUnit: TRefreshDispatcher
    Left = 200
  end
  inherited spRecalcMCS: TdsdStoredProc
    Left = 400
    Top = 192
  end
  inherited spDelete_Object_MCS: TdsdStoredProc
    Left = 520
    Top = 176
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 152
  end
end
