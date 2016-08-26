inherited PriceGroupSettingsTopForm: TPriceGroupSettingsTopForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1086#1074#1099#1093' '#1075#1088#1091#1087#1087' '#1058#1054#1055
  ClientWidth = 407
  ExplicitWidth = 423
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 407
    ExplicitWidth = 407
    ClientRectRight = 407
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 407
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 407
        ExplicitWidth = 407
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1094#1077#1085#1099
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 231
          end
          object colMinPrice: TcxGridDBColumn
            Caption = #1053#1080#1078#1085#1103#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'MinPrice'
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object colPercent: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090
            DataBinding.FieldName = 'Percent'
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object dsdUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      DataSource = MasterDS
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PriceGroupSettingsTop'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PriceGroupSettingsTop'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Percent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 152
  end
end
