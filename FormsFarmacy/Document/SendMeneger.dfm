inherited SendMenegerForm: TSendMenegerForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1084#1077#1085#1077#1076#1078#1077#1088#1099')>'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 3
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPriceIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStorage
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PartionDateKindName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaUnitFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaUnitTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStorageDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colIsErased
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPriceIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStorage
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PartionDateKindName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaUnitFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaUnitTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStorageDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colIsErased
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
      inherited cxGrid1: TcxGrid
        inherited cxGridDBTableView1: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
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
    TabOrder = 6
  end
  inherited edPeriod: TcxCurrencyEdit
    TabOrder = 8
  end
  inherited edDay: TcxCurrencyEdit
    TabOrder = 10
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
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
end
