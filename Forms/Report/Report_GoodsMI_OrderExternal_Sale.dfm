inherited Report_GoodsMI_OrderExternal_SaleForm: TReport_GoodsMI_OrderExternal_SaleForm
  Caption = #1054#1090#1095#1077#1090' <'#1047#1072#1103#1074#1082#1072' / '#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'>'
  ClientHeight = 387
  ClientWidth = 1055
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1071
  ExplicitHeight = 422
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 149
    Width = 1055
    Height = 238
    TabOrder = 3
    ExplicitTop = 149
    ExplicitWidth = 1055
    ExplicitHeight = 238
    ClientRectBottom = 238
    ClientRectRight = 1055
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1055
      ExplicitHeight = 238
      inherited cxGrid: TcxGrid
        Width = 1055
        Height = 238
        ExplicitWidth = 1055
        ExplicitHeight = 238
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSummTotal
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm2
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh2
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight2
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
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight_Itog
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh_Itog
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Weight_Dozakaz
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_Sh_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount12
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_WeightSK
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Weight
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Sh
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight1
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSummTotal
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm2
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight2
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
              Column = Amount_Weight_Itog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh_Itog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight_Dozakaz
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSumm_Dozakaz
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount12
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_WeightSK
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Weight
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale_Sh
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object RouteSortingName: TcxGridDBColumn
            Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
            DataBinding.FieldName = 'RouteSortingName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object FromCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082'.'
            DataBinding.FieldName = 'FromCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object FromName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Amount_Sh1: TcxGridDBColumn
            Caption = #1047#1072#1082'1, '#1096#1090' '
            DataBinding.FieldName = 'Amount_Sh1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Weight1: TcxGridDBColumn
            Caption = #1047#1072#1082'1, '#1082#1075' '
            DataBinding.FieldName = 'Amount_Weight1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Sh2: TcxGridDBColumn
            Caption = #1047#1072#1082'2, '#1096#1090' '
            DataBinding.FieldName = 'Amount_Sh2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Weight2: TcxGridDBColumn
            Caption = #1047#1072#1082'2, '#1082#1075' '
            DataBinding.FieldName = 'Amount_Weight2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Weight_Itog: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1082#1075', '#1080#1090#1086#1075
            DataBinding.FieldName = 'Amount_Weight_Itog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount_Sh_Itog: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1096#1090', '#1080#1090#1086#1075
            DataBinding.FieldName = 'Amount_Sh_Itog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount_Weight_Dozakaz: TcxGridDBColumn
            Caption = #1044#1086#1079#1072#1082#1072#1079', '#1074#1077#1089
            DataBinding.FieldName = 'Amount_Weight_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount_Sh_Dozakaz: TcxGridDBColumn
            Caption = #1044#1086#1079#1072#1082#1072#1079', '#1096#1090
            DataBinding.FieldName = 'Amount_Sh_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object AmountSumm1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' 1, '#1075#1088#1085
            DataBinding.FieldName = 'AmountSumm1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSumm2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' 2, '#1075#1088#1085
            DataBinding.FieldName = 'AmountSumm2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSummTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085
            DataBinding.FieldName = 'AmountSummTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSumm_Dozakaz: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1086#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountSumm_Dozakaz'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount12: TcxGridDBColumn
            Caption = #1050#1086#1083' 1+2'
            DataBinding.FieldName = 'Amount12'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_WeightSK: TcxGridDBColumn
            Caption = #1057'/'#1050', '#1074#1077#1089' '
            DataBinding.FieldName = 'Amount_WeightSK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSale_Weight: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072', '#1074#1077#1089
            DataBinding.FieldName = 'AmountSale_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSale_Sh: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072', '#1096#1090
            DataBinding.FieldName = 'AmountSale_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1055
    Height = 123
    ExplicitWidth = 1055
    ExplicitHeight = 123
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 42005d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 42005d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 31
      ExplicitLeft = 6
      ExplicitTop = 31
    end
    object cxLabel4: TcxLabel
      Left = 457
      Top = 12
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 457
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 240
    end
    object cxLabel13: TcxLabel
      Left = 215
      Top = 53
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
    end
    object edRouteSorting: TcxButtonEdit
      Left = 215
      Top = 72
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 224
    end
    object cxLabel7: TcxLabel
      Left = 457
      Top = 54
      Caption = #1052#1072#1088#1096#1088#1091#1090
    end
    object edRoute: TcxButtonEdit
      Left = 457
      Top = 72
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 146
    end
    object cxLabel3: TcxLabel
      Left = 215
      Top = 12
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
    end
    object edPartner: TcxButtonEdit
      Left = 215
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 11
      Width = 224
    end
    object edByDoc: TcxCheckBox
      Left = 615
      Top = 72
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'  ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 12
      Visible = False
      Width = 231
    end
  end
  object edTo: TcxButtonEdit [2]
    Left = 714
    Top = 30
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 132
  end
  object cxLabel8: TcxLabel [3]
    Left = 714
    Top = 12
    Caption = #1057#1082#1083#1072#1076':'
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
      end
      item
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 247
    Top = 135
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object actPrint_byType: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ImageIndex = 21
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'goodskindname;GoodsGroupNameFull;goodsname'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ReportNameParam.DataType = ftString
    end
    object actPrint_byPack: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      ImageIndex = 19
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'routesortingname;GoodsGroupNameFull;goodsname;goodskindname'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      ReportNameParam.DataType = ftString
    end
    object actPrint_byProduction: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ImageIndex = 20
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      ReportNameParam.DataType = ftString
    end
    object actPrint_byRouteItog: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'InfoMoneyName;routename'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      ReportNameParam.DataType = ftString
    end
    object actPrint_byRoute: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'routename;routesortingname;fromname'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      ReportNameParam.DataType = ftString
    end
    object actPrint_byByer: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ImageIndex = 18
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'FromName;RouteSortingName;RouteName;GoodsGroupNameFull;GoodsName' +
            ';GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      ReportNameParam.DataType = ftString
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_Sale'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inIsByDoc'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 200
    Top = 208
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byPack'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byProduction'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byType'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byRoute'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byRouteItog'
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
    object bbPrint: TdxBarButton
      Action = actPrint_byByer
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byPack: TdxBarButton
      Action = actPrint_byPack
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byProduction: TdxBarButton
      Action = actPrint_byProduction
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byType: TdxBarButton
      Action = actPrint_byType
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byRoute: TdxBarButton
      Action = actPrint_byRoute
      Category = 0
      Visible = ivNever
    end
    object bbPrint_byRouteItog: TdxBarButton
      Action = actPrint_byRouteItog
      Category = 0
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 696
    Top = 136
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
    Top = 32
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesRoute
      end
      item
        Component = GuidesRouteSorting
      end
      item
        Component = GuidesTo
      end
      item
      end>
    Left = 592
    Top = 144
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 560
    Top = 8
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 360
    Top = 122
  end
  object GuidesRouteSorting: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 352
    Top = 72
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 488
    Top = 72
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 312
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 760
    Top = 4
  end
end
