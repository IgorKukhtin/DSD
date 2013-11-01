inherited AncestorReportForm: TAncestorReportForm
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxGrid: TcxGrid
    Top = 57
    Height = 251
    inherited cxGridDBTableView: TcxGridDBTableView
      Styles.Inactive = nil
      Styles.Selection = nil
      Styles.Footer = nil
      Styles.Header = nil
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 26
    Width = 575
    Height = 31
    Align = alTop
    TabOrder = 5
    ExplicitLeft = -754
    ExplicitWidth = 1329
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 41395d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 41395d
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 16
    Top = 88
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 72
    Top = 96
  end
end
