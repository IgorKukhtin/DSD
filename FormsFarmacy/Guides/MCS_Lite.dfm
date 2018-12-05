inherited MCS_LiteForm: TMCS_LiteForm
  Caption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
  ClientHeight = 419
  ClientWidth = 1061
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1077
  ExplicitHeight = 457
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel
    Width = 1061
    ExplicitWidth = 1061
    inherited cbisMCSAuto: TcxCheckBox
      ExplicitHeight = 21
    end
  end
  inherited PageControl: TcxPageControl
    Width = 1061
    Height = 336
    TabOrder = 2
    ExplicitWidth = 1061
    ExplicitHeight = 336
    ClientRectBottom = 336
    ClientRectRight = 1061
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1061
      ExplicitHeight = 336
      inherited cxGrid: TcxGrid
        Width = 1061
        Height = 336
        ExplicitWidth = 1061
        ExplicitHeight = 336
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited StartDate: TcxGridDBColumn [13]
            Visible = False
            VisibleForCustomization = False
          end
          inherited DateChange: TcxGridDBColumn [14]
            Visible = False
          end
          inherited Price: TcxGridDBColumn [15]
            Visible = False
            Options.Editing = False
          end
          inherited MCSDateChange: TcxGridDBColumn [16]
            Visible = False
          end
          inherited MCSValue: TcxGridDBColumn [17]
          end
          inherited MCSPeriod: TcxGridDBColumn [18]
            Visible = False
            VisibleForCustomization = False
          end
          inherited MCSDay: TcxGridDBColumn [19]
            Visible = False
            VisibleForCustomization = False
          end
          inherited MCSValue_min: TcxGridDBColumn [20]
          end
          inherited MCSIsClose: TcxGridDBColumn [21]
          end
          inherited MCSIsCloseDateChange: TcxGridDBColumn [22]
          end
          inherited MCSNotRecalc: TcxGridDBColumn [23]
          end
          inherited MCSNotRecalcDateChange: TcxGridDBColumn [24]
          end
          inherited Fix: TcxGridDBColumn [25]
            Options.Editing = False
          end
          inherited FixDateChange: TcxGridDBColumn [26]
          end
          inherited isErased: TcxGridDBColumn [27]
          end
          inherited RemainsNotMCS: TcxGridDBColumn [28]
            Visible = False
            VisibleForCustomization = False
          end
          inherited SummaNotMCS: TcxGridDBColumn [29]
            Visible = False
            VisibleForCustomization = False
          end
          inherited MinExpirationDate: TcxGridDBColumn [30]
            Visible = False
            VisibleForCustomization = False
          end
          inherited Remains: TcxGridDBColumn [31]
            Visible = False
            VisibleForCustomization = False
          end
          inherited SummaRemains: TcxGridDBColumn [32]
            Visible = False
            VisibleForCustomization = False
          end
          inherited Color_ExpirationDate: TcxGridDBColumn [33]
          end
          inherited isPromo: TcxGridDBColumn [34]
            Visible = False
            VisibleForCustomization = False
          end
          inherited isSecond: TcxGridDBColumn [35]
          end
          inherited PriceRetSP: TcxGridDBColumn [36]
          end
          inherited PriceOptSP: TcxGridDBColumn [37]
          end
          inherited PriceSP: TcxGridDBColumn [38]
          end
          inherited PaymentSP: TcxGridDBColumn [39]
          end
          inherited isSp: TcxGridDBColumn [40]
          end
          inherited ConditionsKeepName: TcxGridDBColumn [41]
          end
          inherited MCSValueOld: TcxGridDBColumn [42]
          end
          inherited StartDateMCSAuto: TcxGridDBColumn [43]
          end
          inherited EndDateMCSAuto: TcxGridDBColumn [44]
          end
          inherited isMCSAuto: TcxGridDBColumn [45]
          end
          inherited isMCSNotRecalcOld: TcxGridDBColumn [46]
          end
          inherited isFirst: TcxGridDBColumn [47]
          end
          inherited DiffSP2: TcxGridDBColumn [48]
          end
          inherited Reserved: TcxGridDBColumn [49]
          end
          inherited SummaReserved: TcxGridDBColumn [50]
          end
          inherited CheckPriceDate: TcxGridDBColumn [51]
          end
          inherited isCorrectMCS: TcxGridDBColumn [52]
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
        Name = 'inMCSValue_min'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSValue_min'
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
        Name = 'inDays'
        Value = Null
        Component = ceDays
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
        Name = 'inisMCSAuto'
        Value = Null
        Component = cbisMCSAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisMCSAuto'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMCSAuto'
        DataType = ftBoolean
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
      end
      item
        Name = 'outMCSValueOld'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSValueOld'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDateMCSAuto'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'StartDateMCSAuto'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDateMCSAuto'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'EndDateMCSAuto'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisMCSNotRecalcOld'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMCSNotRecalcOld'
        DataType = ftBoolean
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
        Value = Null
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
