inherited Report_MinPrice_onGoodsForm: TReport_MinPrice_onGoodsForm
  Caption = #1054#1090#1095#1077#1090' <'#1043#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099'>'
  ClientHeight = 556
  ClientWidth = 841
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 857
  ExplicitHeight = 594
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 841
    Height = 499
    TabOrder = 3
    ExplicitWidth = 841
    ExplicitHeight = 499
    ClientRectBottom = 499
    ClientRectRight = 841
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 841
      ExplicitHeight = 499
      inherited cxGrid: TcxGrid
        Width = 841
        Height = 272
        ExplicitWidth = 841
        ExplicitHeight = 272
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = isOne
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = isOne
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'PlanDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 168
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 144
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object CountPriceList: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
            DataBinding.FieldName = 'CountPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object isOne: TcxGridDBColumn
            Caption = #1054#1076#1080#1085' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'isOne'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
        end
      end
      object grChart: TcxGrid
        Left = 0
        Top = 280
        Width = 841
        Height = 219
        Align = alBottom
        TabOrder = 1
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramLine.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'plandate'
            DisplayText = #1052#1077#1089#1103#1094
          end
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'unitname'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object serTotalSumma: TcxGridDBChartSeries
            DataBinding.FieldName = 'TotalSumma'
            DisplayText = #1048#1090#1086#1075#1086', '#1075#1088#1085
          end
          object serSummaPromo: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaPromo'
            DisplayText = #1057#1091#1084#1084#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075'.)'
          end
          object serSumma: TcxGridDBChartSeries
            DataBinding.FieldName = 'Summa'
            DisplayText = #1057#1091#1084#1084#1072' ('#1087#1088#1086#1095#1077#1077')'
          end
          object serPercentPromo: TcxGridDBChartSeries
            DataBinding.FieldName = 'PercentPromo'
            DisplayText = '% '#1074#1099#1087'.'
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 272
        Width = 841
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
    end
  end
  inherited Panel: TPanel
    Width = 841
    ExplicitWidth = 841
    inherited deStart: TcxDateEdit
      EditValue = 42705d
      Properties.ReadOnly = True
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42735d
      Properties.ReadOnly = True
    end
    object cxLabel4: TcxLabel
      Left = 430
      Top = 6
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 466
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 271
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_MinPrice_onGoodsDialogForm'
      FormNameParam.Value = 'TReport_MinPrice_onGoodsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42705d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42735d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actContractOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
      Hint = #1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
      ImageIndex = 43
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 120
  end
  inherited MasterCDS: TClientDataSet
    Top = 120
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_MinPrice_onGoods'
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
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 120
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
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
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bb: TdxBarButton
      Action = actContractOpenForm
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 408
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 408
    Top = 56
  end
  object GoodsGuide: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsMainForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMainForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 8
  end
end
