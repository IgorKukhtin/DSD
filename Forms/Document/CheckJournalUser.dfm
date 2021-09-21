inherited CheckJournalUserForm: TCheckJournalUserForm
  ClientHeight = 513
  ExplicitHeight = 552
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Height = 436
    TabOrder = 2
    ExplicitHeight = 436
    ClientRectBottom = 436
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 436
      inherited cxGrid: TcxGrid
        Height = 436
        ExplicitHeight = 436
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummChangePercent
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummChangePercent
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSummPayAdd
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colTotalSummChangePercent: TcxGridDBColumn [7]
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'TotalSummChangePercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          inherited colBayer: TcxGridDBColumn
            HeaderGlyphAlignmentVert = vaTop
          end
          inherited colCashMember: TcxGridDBColumn
            HeaderGlyphAlignmentVert = vaTop
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    inherited ceUnit: TcxButtonEdit
      Enabled = False
    end
    inherited cxLabel3: TcxLabel
      Left = 13
      ExplicitLeft = 13
    end
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
    inherited actCashSummaForDey: TdsdOpenForm
      GuiParams = <
        item
          Name = 'CashRegisterName'
          Component = MasterCDS
          ComponentItem = 'CashRegisterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Date'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSP'
        Value = False
        Component = edIsSP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsVip'
        Value = False
        Component = edIsVip
        DataType = ftBoolean
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
      end>
    Top = 147
  end
  inherited BarManager: TdxBarManager
    Top = 155
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 176
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 264
    Top = 152
  end
end
