inherited SendMenegerForm: TSendMenegerForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1084#1077#1085#1077#1076#1078#1077#1088#1099')>'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 3
    inherited tsMain: TcxTabSheet
      inherited cxSplitter1: TcxSplitter [0]
      end
      inherited cxGrid1: TcxGrid [1]
        TabOrder = 0
        inherited cxGridDBTableView1: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
      inherited cxGrid: TcxGrid [2]
        TabOrder = 2
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited AmountManual: TcxGridDBColumn
            Options.Editing = False
          end
          inherited AmountStorage: TcxGridDBColumn
            Options.Editing = False
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    TabOrder = 1
  end
  inherited edComment: TcxTextEdit
    TabOrder = 4
  end
  inherited edIsAuto: TcxCheckBox
    TabOrder = 5
  end
  inherited edPeriod: TcxCurrencyEdit
    TabOrder = 7
  end
  inherited edDay: TcxCurrencyEdit
    TabOrder = 9
  end
  inherited ceChecked: TcxCheckBox
    TabOrder = 11
  end
  inherited ActionList: TActionList
    inherited actPrint: TdsdPrintAction
      DataSets = <
        item
          DataSet = PrintHeaderCDS
        end
        item
          DataSet = PrintItemsCDS
        end>
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end>
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
end
