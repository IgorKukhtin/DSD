inherited CheckJournalUserForm: TCheckJournalUserForm
  ClientHeight = 513
  ExplicitHeight = 551
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Height = 436
    TabOrder = 2
    ClientRectBottom = 436
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Height = 436
        ExplicitLeft = 3
        ExplicitTop = -25
        inherited cxGridDBTableView: TcxGridDBTableView
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
          object colDiscountCardName: TcxGridDBColumn
            Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1072#1103' '#1082#1072#1088#1090#1072
            DataBinding.FieldName = 'DiscountCardName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
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
    inherited actSimpleReCompleteList: TMultiAction
      Enabled = False
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
