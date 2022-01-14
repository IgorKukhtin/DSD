inherited AncestorReportForm: TAncestorReportForm
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Height = 251
    ExplicitTop = 57
    ExplicitHeight = 251
    ClientRectBottom = 251
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 251
      inherited cxGrid: TcxGrid
        Height = 251
        ExplicitHeight = 251
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 575
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 42370d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 42370d
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
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end>
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
    inherited dxBarStatic: TdxBarStatic
      Caption = ''
      Hint = ''
      ShowCaption = False
    end
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 16
    Top = 88
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 72
    Top = 96
  end
end
