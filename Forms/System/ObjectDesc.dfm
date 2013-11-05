inherited ObjectDescForm: TObjectDescForm
  Caption = #1058#1080#1087#1099' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxGrid: TcxGrid
    inherited cxGridDBTableView: TcxGridDBTableView
      Styles.Inactive = nil
      Styles.Selection = nil
      Styles.Footer = nil
      Styles.Header = nil
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        Options.Editing = False
      end
    end
  end
  inherited MainDataDS: TDataSource
    Top = 48
  end
  inherited MainDataCDS: TClientDataSet
    Top = 48
  end
  inherited spMainData: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectDesc'
    Top = 48
  end
  inherited BarManager: TdxBarManager
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
