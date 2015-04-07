inherited GlobalConstForm: TGlobalConstForm
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1080#1089#1090#1077#1084#1099
  ClientWidth = 275
  ExplicitWidth = 283
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 275
    ClientRectRight = 275
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 275
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colBankStatementDate: TcxGridDBColumn
            Caption = #1040#1082#1090#1091#1072#1083#1100#1085#1086#1089#1090#1100' '#1073#1072#1085#1082#1086#1074#1089#1082#1086#1081' '#1074#1099#1087#1080#1089#1082#1080
            DataBinding.FieldName = 'ActualBankStatementDate'
            Width = 246
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object dsdUpdateDataSet1: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGlobalConst
      StoredProcList = <
        item
          StoredProc = spUpdateGlobalConst
        end>
      Caption = 'dsdUpdateDataSet1'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GlobalConst'
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spUpdateGlobalConst: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GlobalConst'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inActualBankStatementDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ActualBankStatementDate'
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 136
    Top = 112
  end
end
