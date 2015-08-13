inherited ReportMovementCheckForm: TReportMovementCheckForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
  ClientWidth = 702
  ExplicitWidth = 710
  ExplicitHeight = 342
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 60
    Width = 702
    Height = 248
    TabOrder = 3
    ExplicitTop = 81
    ExplicitHeight = 227
    ClientRectBottom = 244
    ClientRectRight = 698
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitWidth = 569
      ExplicitHeight = 221
      inherited cxGrid: TcxGrid
        Width = 696
        Height = 242
        ExplicitWidth = 569
        ExplicitHeight = 221
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSumma
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaMargin
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colGoodsName
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            Width = 27
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            Width = 50
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            Width = 151
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            Width = 49
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1089'/'#1089
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Width = 62
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Width = 66
          end
          object colSumma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1089'/'#1089
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Width = 66
          end
          object colSummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Width = 72
          end
          object colSummaMargin: TcxGridDBColumn
            Caption = #1053#1072#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'SummaMargin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Width = 78
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 702
    Height = 32
    Visible = False
    ExplicitHeight = 32
    inherited deStart: TcxDateEdit
      Left = 29
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 234
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 325
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Width = 188
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_Check'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 80
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
    DockControlHeights = (
      0
      0
      28
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem5'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem6'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel2
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deEnd
    end
    object dxBarControlContainerItem5: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel3
    end
    object dxBarControlContainerItem6: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceUnit
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 456
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 496
    Top = 0
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 296
    Top = 24
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 336
    Top = 24
  end
end
