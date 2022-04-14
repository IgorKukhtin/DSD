inherited OrderInternalForm: TOrderInternalForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1054#1073#1097#1080#1081' '#1079#1072#1082#1072#1079'>'
  ClientHeight = 529
  ClientWidth = 1229
  AddOnFormData.PUSHMessage = actPUSHInfo
  ExplicitWidth = 1245
  ExplicitHeight = 568
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 1229
    Height = 454
    ExplicitTop = 75
    ExplicitWidth = 1229
    ExplicitHeight = 454
    ClientRectBottom = 454
    ClientRectRight = 1229
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1229
      ExplicitHeight = 430
      inherited cxGrid: TcxGrid
        Width = 1229
        Height = 200
        ExplicitWidth = 1229
        ExplicitHeight = 200
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDeferred
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsInUnit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCS
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CheckAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Reserved
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ListDiffAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCS_GoodsCategory
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsSUN
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendSUNAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendDefSUNAmount_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendSUNAmount_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Layout
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSF
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SupplierFailuresAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
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
              Column = AmountAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CalcAmountAll
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAll
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDeferred
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsInUnit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCS
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CheckAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Reserved
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ListDiffAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCS_GoodsCategory
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsSUN
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendSUNAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendDefSUNAmount_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SendSUNAmount_save
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountSUA
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = FinalSUA
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = FinalSUASend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Layout
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSF
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SupplierFailuresAmount
            end>
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          OptionsView.HeaderEndEllipsis = True
          OptionsView.HeaderHeight = 32
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isResolution_224: TcxGridDBColumn [0]
            Caption = #1055#1086#1089#1090'. 224'
            DataBinding.FieldName = 'isResolution_224'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            Width = 53
          end
          object Comment: TcxGridDBColumn [1]
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            Width = 91
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 43
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 206
          end
          object isOneJuridical: TcxGridDBColumn [4]
            Caption = #1054#1076#1080#1085' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'isOneJuridical'
            Options.Editing = False
            Width = 45
          end
          object RemainsInUnit: TcxGridDBColumn [5]
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'RemainsInUnit'
            HeaderHint = #1058#1077#1082#1091#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080
            Options.Editing = False
            Width = 47
          end
          object Reserved: TcxGridDBColumn [6]
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            DataBinding.FieldName = 'Reserved'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            Options.Editing = False
            Width = 51
          end
          object Remains_Diff: TcxGridDBColumn [7]
            Caption = #1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1089' '#1091#1095'. '#1086#1090#1083#1086#1078'. '#1095#1077#1082#1086#1084
            DataBinding.FieldName = 'Remains_Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1089' '#1091#1095#1077#1090#1086#1084' '#1086#1090#1083#1086#1078'. '#1095#1077#1082#1086#1074
            Options.Editing = False
            Width = 51
          end
          object MCS: TcxGridDBColumn [8]
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            Options.Editing = False
            Width = 37
          end
          object MCS_GoodsCategory: TcxGridDBColumn [9]
            Caption = #1053#1058#1047' ('#1072#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088'.)'
            DataBinding.FieldName = 'MCS_GoodsCategory'
            HeaderHint = #1053#1058#1047' ('#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1072#1103' '#1084#1072#1090#1088#1080#1094#1072')'
            Options.Editing = False
            Width = 42
          end
          object Layout: TcxGridDBColumn [10]
            Caption = #1042#1099#1082#1083#1072#1076#1082#1072
            DataBinding.FieldName = 'Layout'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object MCSNotRecalc: TcxGridDBColumn [11]
            Caption = #1057#1087#1077#1094#1082#1086#1085#1090#1088#1086#1083#1100' '#1082#1086#1076#1072
            DataBinding.FieldName = 'MCSNotRecalc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1087#1077#1088#1077#1089#1095#1080#1090#1099#1074#1072#1090#1100' '#1053#1058#1047
            Options.Editing = False
            Width = 59
          end
          object MCSIsClose: TcxGridDBColumn [12]
            Caption = #1059#1076#1072#1083#1077#1085' '#1082#1086#1076
            DataBinding.FieldName = 'MCSIsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object Income_Amount: TcxGridDBColumn [13]
            Caption = #1055#1088#1080#1093#1086#1076#1099' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'Income_Amount'
            Options.Editing = False
            Width = 62
          end
          object CheckAmount: TcxGridDBColumn [14]
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1079#1072' '#1090#1077#1082'.'#1076#1077#1085#1100
            DataBinding.FieldName = 'CheckAmount'
            Options.Editing = False
            Width = 62
          end
          object SendAmount: TcxGridDBColumn [15]
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1074#1089#1077
            DataBinding.FieldName = 'SendAmount'
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1074#1089#1077' '#1085#1077#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077
            Options.Editing = False
            Width = 62
          end
          object ListDiffAmount: TcxGridDBColumn [16]
            Caption = #1054#1090#1082#1072#1079#1099
            DataBinding.FieldName = 'ListDiffAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1086#1090#1082#1072#1079
            Options.Editing = False
            Width = 35
          end
          object SupplierFailuresAmount: TcxGridDBColumn [17]
            Caption = #1055#1077#1088#1077#1079#1072#1082#1072#1079' '#1086#1090#1082#1072#1079' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'SupplierFailuresAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Options.Editing = False
            Width = 49
          end
          object AmountReal: TcxGridDBColumn [18]
            Caption = #1047#1072#1082#1072#1079' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1057#1059#1053
            DataBinding.FieldName = 'AmountReal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1055#1077#1088#1074#1086#1085#1072#1095#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1057#1059#1053
            Options.Editing = False
            Options.IncSearch = False
            Width = 71
          end
          object RemainsSUN: TcxGridDBColumn [19]
            Caption = #1054#1089#1090'. '#1089#1088#1086#1082#1086#1074#1099#1093
            DataBinding.FieldName = 'RemainsSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1090#1077#1082'. '#1072#1087#1090#1077#1082#1077' '#1089#1088#1086#1082#1086#1074#1099#1093
            Options.Editing = False
            Options.IncSearch = False
            Width = 48
          end
          object SendSUNAmount: TcxGridDBColumn [20]
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' '#1079#1072' '#1089#1077#1075#1086#1076#1085#1103' ('#1091#1076#1072#1083#1077#1085')'
            DataBinding.FieldName = 'SendSUNAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' '#1079#1072' '#1089#1077#1075#1086#1076#1085#1103' ('#1091#1076#1072#1083#1077#1085')'
            Options.Editing = False
            Options.IncSearch = False
            Width = 48
          end
          object SendSUNAmount_save: TcxGridDBColumn [21]
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'-1 ('#1089#1086#1093#1088#1072#1085#1077#1085#1086')'
            DataBinding.FieldName = 'SendSUNAmount_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'-1 ('#1089#1086#1093#1088#1072#1085#1077#1085#1086')'
            Options.Editing = False
            Options.IncSearch = False
            Width = 48
          end
          object SendDefSUNAmount_save: TcxGridDBColumn [22]
            Caption = #1055#1077#1088#1077#1084#1077#1097'. '#1087#1086' '#1057#1059#1053'-2+2'#1055#1048' ('#1089#1086#1093#1088#1072#1085#1077#1085#1086')'
            DataBinding.FieldName = 'SendDefSUNAmount_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097'. '#1087#1086' '#1057#1059#1053'-2-'#1055#1048' ('#1089#1086#1093#1088#1072#1085#1077#1085#1086')'
            Options.Editing = False
            Options.IncSearch = False
            Width = 48
          end
          object MinimumLot: TcxGridDBColumn [23]
            Caption = #1052#1080#1085'. '#1086#1082#1088#1091#1075#1083'.'
            DataBinding.FieldName = 'MinimumLot'
            Options.Editing = False
            Width = 53
          end
          object Multiplicity: TcxGridDBColumn [24]
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'Multiplicity'
            Options.Editing = False
            Width = 62
          end
          object CalcAmountAll: TcxGridDBColumn [25]
            Caption = #1042#1089#1077#1075#1086' '#1089' '#1086#1082#1088#1091#1075#1083'.'
            DataBinding.FieldName = 'CalcAmountAll'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.####'
            Properties.Precision = 4
            HeaderHint = 
              '(['#1057#1087#1077#1094#1079#1072#1082#1072#1079'] + ['#1040#1074#1086#1079#1072#1082#1072#1079']+  ['#1054#1090#1082#1072#1079']) '#1089' '#1091#1095#1077#1090#1086#1084' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1075#1086' '#1086#1082#1088#1091#1075 +
              #1083#1077#1085#1080#1103
            Options.IncSearch = False
          end
          object Price: TcxGridDBColumn [26]
            Caption = #1062#1077#1085#1072', '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price'
            Options.Editing = False
            Width = 40
          end
          object SuperFinalPrice_Deferment: TcxGridDBColumn [27]
            Caption = #1062#1077#1085#1072' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1082#1088#1077#1076'.'#1088#1077#1089'.)'
            DataBinding.FieldName = 'SuperFinalPrice_Deferment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PriceOptSP: TcxGridDBColumn [28]
            Caption = #1052#1072#1082#1089'. '#1094#1077#1085#1072' '#1087#1086#1089#1090'-'#1082#1072' '#1087#1086' '#1057#1055' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1090'.-'#1074#1110#1076#1087'. '#1094#1110#1085#1072' '#1079#1072' '#1091#1087'. (11)'
            Options.Editing = False
            Width = 91
          end
          object SummAll: TcxGridDBColumn [29]
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072', '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'SummAll'
            HeaderHint = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' = ['#1042#1089#1077#1075#1086' '#1089' '#1084#1080#1085'. '#1086#1082#1088'.] '#1061' ['#1062#1077#1085#1072']'
            Options.Editing = False
            Width = 56
          end
          object isCalculated: TcxGridDBColumn [30]
            Caption = #1040#1074#1090#1086
            DataBinding.FieldName = 'isCalculated'
            Options.Editing = False
            Width = 33
          end
          object PartnerGoodsCode: TcxGridDBColumn [31]
            Caption = #1050#1086#1076' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1072
            DataBinding.FieldName = 'PartnerGoodsCode'
            Options.Editing = False
            Width = 65
          end
          object PartnerGoodsName: TcxGridDBColumn [32]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            Options.Editing = False
            Width = 80
          end
          object MakerName: TcxGridDBColumn [33]
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Options.Editing = False
            Width = 65
          end
          object ContractName: TcxGridDBColumn [34]
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'ContractName'
            Options.Editing = False
            Width = 60
          end
          object PartionGoodsDate: TcxGridDBColumn [35]
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            Options.Editing = False
            Width = 75
          end
          object NDSKindName: TcxGridDBColumn [36]
            Caption = #1042#1080#1076' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object NDS: TcxGridDBColumn [37]
            Caption = #1057#1090#1072#1074#1082#1072' '#1053#1044#1057
            DataBinding.FieldName = 'NDS'
            Options.Editing = False
            Width = 71
          end
          object NDS_PriceList: TcxGridDBColumn [38]
            Caption = #1053#1044#1057' ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'NDS_PriceList'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1053#1044#1057' ('#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            Options.Editing = False
            Width = 65
          end
          object PartionGoodsDateColor: TcxGridDBColumn [39]
            DataBinding.FieldName = 'PartionGoodsDateColor'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object isPriceDiff: TcxGridDBColumn [40]
            Caption = #1054#1090#1082#1083'. '#1087#1086' '#1094#1077#1085#1077' '#1057#1055
            DataBinding.FieldName = 'isPriceDiff'
            Options.Editing = False
            Width = 60
          end
          object isTopColor: TcxGridDBColumn [41]
            DataBinding.FieldName = 'isTopColor'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object IsClose: TcxGridDBColumn [42]
            Caption = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object isFirst: TcxGridDBColumn [43]
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn [44]
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isTOP: TcxGridDBColumn [45]
            Caption = #1058#1054#1055' '#1089#1077#1090#1080
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperDatePromo: TcxGridDBColumn [46]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1073#1086#1085#1091#1089#1085' .'#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'OperDatePromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isPromo: TcxGridDBColumn [47]
            Caption = #1041#1086#1085#1091#1089#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1086#1085#1091#1089#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090'  '#1087#1086#1089#1090#1072#1074#1097#1080#1082' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 50
          end
          object isPromoAll: TcxGridDBColumn [48]
            Caption = #1052#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPromoAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 50
          end
          object AmountDeferred: TcxGridDBColumn [49]
            Caption = #1047#1072#1082#1072#1079' '#1086#1090#1083#1086#1078#1077#1085
            DataBinding.FieldName = 'AmountDeferred'
            Options.Editing = False
            Width = 62
          end
          object AmountSF: TcxGridDBColumn [50]
            Caption = #1054#1090#1082#1072#1079' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'AmountSF'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Amount: TcxGridDBColumn [51]
            Caption = #1057#1087#1077#1094#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.Precision = 4
            HeaderAlignmentHorz = taCenter
            Options.IncSearch = False
            Width = 48
          end
          object AmountAll: TcxGridDBColumn [52]
            Caption = #1057#1087#1077#1094' + '#1040#1074#1090#1086
            DataBinding.FieldName = 'AmountAll'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.####'
            Properties.Precision = 2
            HeaderHint = #1057#1087#1077#1094#1079#1072#1082#1072#1079' + '#1040#1074#1090#1086#1079#1072#1082#1072#1079
            Options.Editing = False
            Width = 62
          end
          object isTOP_Price: TcxGridDBColumn [53]
            Caption = #1058#1054#1055' '#1090#1086#1095#1082#1080
            DataBinding.FieldName = 'isTOP_Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          inherited colIsErased: TcxGridDBColumn
            VisibleForCustomization = False
          end
          object AVGPrice: TcxGridDBColumn
            Caption = #1057#1088'. '#1094#1077#1085#1072' '#1087#1088#1080#1093'. '#1079#1072' '#1084#1077#1089#1103#1094
            DataBinding.FieldName = 'AVGPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088'. '#1094#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' '#1087#1088#1080#1093'. '#1079#1072' '#1084#1077#1089#1103#1094
            Options.Editing = False
            Width = 81
          end
          object AVGPriceWarning: TcxGridDBColumn
            AlternateCaption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1073#1086#1083#1077#1077' 10 %'
            Caption = '>10%'
            DataBinding.FieldName = 'AVGPriceWarning'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1073#1086#1083#1077#1077' 10 %'
            Options.Editing = False
            Width = 47
          end
          object InvNumberPromo: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1073#1086#1085#1091#1089#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'InvNumberPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 47
          end
          object isZakazToday: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'isZakazToday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isDostavkaToday: TcxGridDBColumn
            Caption = #1044#1086#1089#1090'. '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'isDostavkaToday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1089#1090#1072#1074#1082#1072' '#1089#1077#1075#1086#1076#1085#1103
            Options.Editing = False
            Width = 55
          end
          object OperDate_Zakaz: TcxGridDBColumn
            Caption = #1041#1083#1080#1078'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'OperDate_Zakaz'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1073#1083#1080#1078#1072#1081#1097#1077#1075#1086' '#1079#1072#1082#1072#1079#1072
            Options.Editing = False
            Width = 60
          end
          object OperDate_Dostavka: TcxGridDBColumn
            Caption = #1041#1083#1080#1078'. '#1076#1086#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'OperDate_Dostavka'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1073#1083#1080#1078#1072#1081#1097#1077#1081' '#1076#1086#1089#1090#1072#1074#1082#1080
            Options.Editing = False
            Width = 60
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 42
          end
          object isMarketToday: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1085#1072' '#1088#1099#1085#1082#1077' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'isMarketToday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1090#1100' '#1085#1072' '#1088#1099#1085#1082#1077' '#1089#1077#1075#1086#1076#1085#1103' ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 70
          end
          object LastPriceDate: TcxGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'LastPriceDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 60
          end
          object CountPrice: TcxGridDBColumn
            Caption = #1053#1072' '#1088#1099#1085#1082#1077' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
            DataBinding.FieldName = 'CountPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OrderShedule_Color: TcxGridDBColumn
            DataBinding.FieldName = 'OrderShedule_Color'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object clisDefault: TcxGridDBColumn
            Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            DataBinding.FieldName = 'isDefault'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1075#1080#1086#1085' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            Options.Editing = False
            Width = 50
          end
          object DiscountName: TcxGridDBColumn
            Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
            DataBinding.FieldName = 'DiscountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object DiscountJuridical: TcxGridDBColumn
            Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1086#1089'-'#1082#1080' '#1044#1080#1089#1082#1086#1085#1090' '#1087#1088#1086#1077#1082#1090#1072
            DataBinding.FieldName = 'DiscountJuridical'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 141
          end
          object AmountSUA: TcxGridDBColumn
            Caption = #1042' '#1079#1072#1082#1072#1079' '#1087#1086' '#1057#1059#1040
            DataBinding.FieldName = 'AmountSUA'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object FinalSUA: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086#1074#1099#1081' '#1057#1059#1040
            DataBinding.FieldName = 'FinalSUA'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object FinalSUASend: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086#1074#1099#1081' '#1057#1059#1040' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            DataBinding.FieldName = 'FinalSUASend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object SupplierFailuresColor: TcxGridDBColumn
            DataBinding.FieldName = 'SupplierFailuresColor'
            Visible = False
            VisibleForCustomization = False
          end
          object isSupplierFailures: TcxGridDBColumn
            Caption = #1042' '#1086#1090#1082#1072#1079#1072#1093' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'isSupplierFailures'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 205
        Width = 1229
        Height = 225
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082')'
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object isDefault: TcxGridDBColumn
            Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            DataBinding.FieldName = 'isDefault'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1075#1080#1086#1085' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            Options.Editing = False
            Width = 50
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1087#1086#1089#1090'-'#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object colMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colBonus: TcxGridDBColumn
            Caption = '% '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'Bonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#### %;-,0.#### %; ;'
            Options.Editing = False
            Width = 49
          end
          object colNDS_PriceList: TcxGridDBColumn
            Caption = #1053#1044#1057' ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'NDS_PriceList'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1053#1044#1057' ('#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            Options.Editing = False
            Width = 65
          end
          object colContractName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'ContractName'
            Options.Editing = False
            Width = 90
          end
          object colDeferment: TcxGridDBColumn
            Caption = #1054#1090#1089#1088'.'
            DataBinding.FieldName = 'Deferment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0; ; '
            Options.Editing = False
            Width = 44
          end
          object colAreaName_Goods: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1090#1086#1074#1072#1088')'
            DataBinding.FieldName = 'AreaName_Goods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object coCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colPercent: TcxGridDBColumn
            Caption = '% '#1074#1099#1073#1086#1088' '#1092#1072#1082#1090'/'#1086#1090#1089#1088
            DataBinding.FieldName = 'Percent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.## %;-,0.## %; ;'
            Visible = False
            Options.Editing = False
            Width = 70
          end
          object colSuperFinalPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'SuperFinalPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object colPersent_Deferment: TcxGridDBColumn
            Caption = '% '#1089#1090#1086#1080#1084'. '#1082#1088'. '#1089#1088'-'#1074
            DataBinding.FieldName = 'Persent_Deferment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#### %;-,0.#### %; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1082#1088#1077#1076#1080#1090'. '#1089#1088#1077#1076#1089#1090#1074
            Options.Editing = False
            Width = 72
          end
          object colSuperFinalPrice_Deferment: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1082#1088#1077#1076'.'#1088#1077#1089'.)'
            DataBinding.FieldName = 'SuperFinalPrice_Deferment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object colPartionGoodsDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            Width = 80
          end
          object colPartionGoodsDateColor: TcxGridDBColumn
            DataBinding.FieldName = 'PartionGoodsDateColor'
            Visible = False
            VisibleForCustomization = False
            IsCaptionAssigned = True
          end
          object colMinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'MinimumLot'
            Width = 86
          end
          object colRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object colisPromo: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colOperDatePromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1073#1086#1085#1091#1089#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'OperDatePromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object colInvNumberPromo: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1073#1086#1085#1091#1089#1085'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'InvNumberPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object colChangePercentPromo: TcxGridDBColumn
            Caption = '% '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            DataBinding.FieldName = 'ChangePercentPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#### %;-,0.#### %; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object colConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSupplierFailuresColor: TcxGridDBColumn
            DataBinding.FieldName = 'SupplierFailuresColor'
            Visible = False
            VisibleForCustomization = False
          end
          object colisSupplierFailures: TcxGridDBColumn
            Caption = #1054#1090#1082#1072#1079' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'isSupplierFailures'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 200
        Width = 1229
        Height = 5
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1229
    Height = 49
    ParentBackground = False
    TabOrder = 3
    ExplicitWidth = 1229
    ExplicitHeight = 49
    inherited edInvNumber: TcxTextEdit
      Left = 155
      Top = 22
      ExplicitLeft = 155
      ExplicitTop = 22
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 155
      Top = 4
      ExplicitLeft = 155
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 238
      Top = 22
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.TextColor = 25088
      ExplicitLeft = 238
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 239
      Top = 4
      ExplicitLeft = 239
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 5
      Top = 4
      ExplicitLeft = 5
      ExplicitTop = 4
    end
    inherited ceStatus: TcxButtonEdit
      Left = 5
      Top = 22
      ExplicitLeft = 5
      ExplicitTop = 22
      ExplicitWidth = 142
      ExplicitHeight = 22
      Width = 142
    end
    object edUnit: TcxButtonEdit
      Left = 347
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 270
    end
    object cxLabel4: TcxLabel
      Left = 347
      Top = 3
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel3: TcxLabel
      Left = 624
      Top = 4
      Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
    end
    object edOrderKind: TcxButtonEdit
      Left = 624
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.Color = clWindow
      TabOrder = 9
      Width = 137
    end
    object cxLabel6: TcxLabel
      Left = 969
      Top = 3
      Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')'
    end
    object edOrderInternalPromo: TcxButtonEdit
      Left = 969
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 232
    end
  end
  object edIsDocument: TcxCheckBox [2]
    Left = 783
    Top = 22
    Caption = #1044#1072#1085#1085#1099#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1099' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 167
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 155
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actAddMask
        Properties.Strings = (
          'CancelAction'
          'Caption'
          'Category'
          'Enabled'
          'Hint'
          'ImageIndex'
          'InfoAfterExecute'
          'MoveParams'
          'Name'
          'QuestionBeforeExecute'
          'SecondaryShortCuts'
          'ShortCut'
          'StoredProc'
          'StoredProcList'
          'TabSheet'
          'Tag')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 24
    Top = 160
  end
  inherited ActionList: TActionList
    Left = 127
    Top = 215
    object actReportSendDefSUN: TdsdOpenForm [0]
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086' '#1054#1090#1083#1086#1078#1077#1085#1085#1086#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Hint = #1055#1086#1076#1088#1086#1073#1085#1086' '#1054#1090#1083#1086#1078#1077#1085#1085#1086#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      ImageIndex = 28
      FormName = 'TReport_GoodsSendSUNForm'
      FormNameParam.Value = 'TReport_GoodsSendSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSendDefSUN'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactDeleteLinkGroup: TMultiAction [1]
      Category = 'DeleteLink'
      MoveParams = <>
      ActionList = <
        item
          Action = mactDeleteLinkDS
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 72
    end
    object mactDeleteLinkDS: TMultiAction [2]
      Category = 'DeleteLink'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end>
      DataSource = ChildDS
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 72
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale2'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale2'
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdateRealSun: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateRealSun
      StoredProcList = <
        item
          StoredProc = spUpdateRealSun
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1073#1077#1079' '#1057#1059#1053' '#1080' '#1086#1089#1090'. '#1089#1088#1086#1082#1086#1074#1099#1093
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1073#1077#1079' '#1057#1059#1053' '#1080' '#1054#1089#1090'. '#1089#1088#1086#1082#1086#1074#1099#1093
      ImageIndex = 60
    end
    object actUpdatePrioritetPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePrioritetPartner
      StoredProcList = <
        item
          StoredProc = spUpdatePrioritetPartner
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1091#1102' '#1094#1077#1085#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1091#1102' '#1094#1077#1085#1091
      ImageIndex = 55
      ShortCut = 114
    end
    object actSetLinkGoodsForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100
      ShortCut = 9
      FormName = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.Value = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUpdateListDiff: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actPUSHListDiffVIPSend
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateListDiff
      StoredProcList = <
        item
          StoredProc = spUpdateListDiff
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1086#1090#1082#1072#1079#1072#1084
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1086#1090#1082#1072#1079#1072#1084
      ImageIndex = 10
    end
    object mactDeleteLink: TMultiAction
      Category = 'DeleteLink'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 72
    end
    object actDeleteLink: TdsdExecStoredProc
      Category = 'DeleteLink'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_LinkGoodsByGoods
      StoredProcList = <
        item
          StoredProc = spDelete_Object_LinkGoodsByGoods
        end>
      Caption = 'actDeleteLink'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actReportSendSUN: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Hint = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      ImageIndex = 24
      FormName = 'TReport_GoodsSendSUNForm'
      FormNameParam.Value = 'TReport_GoodsSendSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementItemProtocolChild: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefresh_Link: TdsdDataSetRefresh
      Category = 'Dataset'
      MoveParams = <>
      StoredProc = spSelect_Link
      StoredProcList = <
        item
          StoredProc = spSelect_Link
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089' '#1087#1088#1086#1074#1077#1088#1082#1086#1081' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089' '#1087#1088#1086#1074#1077#1088#1082#1086#1081' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ImageIndex = 50
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPUSHInfo: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSH
      StoredProcList = <
        item
          StoredProc = spPUSH
        end
        item
          StoredProc = spPUSHEVip
        end
        item
          StoredProc = spPUSHSUA
        end
        item
          StoredProc = spPUSHZeroingSUA
        end>
      Caption = 'actPUSHInfo'
      PUSHMessageType = pmtInformation
    end
    object actOpenReport_GoodsPartionDate: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      ImageIndex = 25
      FormName = 'TReport_GoodsPartionDateForm'
      FormNameParam.Value = 'TReport_GoodsPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDetail'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateFinalSUA: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateFinalSUA
      StoredProcList = <
        item
          StoredProc = spUpdateFinalSUA
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1048#1090#1086#1075#1086#1074#1086#1084#1091' '#1057#1059#1040
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1048#1090#1086#1075#1086#1074#1086#1084#1091' '#1057#1059#1040
      ImageIndex = 80
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1048#1090#1086#1075#1086#1074#1086#1084#1091' '#1057#1059#1040'?'
    end
    object actPUSHDiscount: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHDiscount
      StoredProcList = <
        item
          StoredProc = spPUSHDiscount
        end>
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' '#1076#1080#1089#1082#1086#1085#1090#1085#1099#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1072#1084
      Hint = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' '#1076#1080#1089#1082#1086#1085#1090#1085#1099#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1072#1084
      ImageIndex = 67
    end
    object actPUSHListDiffVIPSend: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHListDiffVIPSend
      StoredProcList = <
        item
          StoredProc = spPUSHListDiffVIPSend
        end>
      Caption = 'actPUSHListDiffVIPSend'
    end
    object actOrderInternalZeroingSUA: TdsdOpenForm
      Category = 'Report'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1047#1072#1085#1091#1083#1077#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080' '#1087#1086' '#1057#1059#1040
      Hint = #1047#1072#1085#1091#1083#1077#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080' '#1087#1086' '#1057#1059#1040
      ImageIndex = 79
      FormName = 'TOrderInternalZeroingSUAForm'
      FormNameParam.Value = 'TOrderInternalZeroingSUAForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = ''
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actListDiffFormVIPSend: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1087#1086' '#1083#1080#1089#1090#1072#1084' '#1086#1090#1082#1072#1079#1086#1074
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1087#1086' '#1083#1080#1089#1090#1072#1084' '#1086#1090#1082#1072#1079#1086#1074
      ImageIndex = 29
      FormName = 'TListDiffFormVIPSendForm'
      FormNameParam.Value = 'TListDiffFormVIPSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDataDialog'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateDialog'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateSupplierFailures: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDataDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateSupplierFailures
      StoredProcList = <
        item
          StoredProc = spUpdateSupplierFailures
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100
      ImageIndex = 80
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 376
  end
  inherited MasterCDS: TClientDataSet
    Left = 72
    Top = 376
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternal_Master'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
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
        Name = 'inIsLink'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbSelect_Link'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateListDiff'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateSupplierFailures'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrioritetPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPUSHDiscount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetGoodsLink'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeleteLink'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateFinalSUA'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbListDiffFormVIPSend'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateRealSun'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReport_GoodsPartionDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReportSendSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocolChild'
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
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbPrioritetPartner: TdxBarButton
      Action = actUpdatePrioritetPartner
      Category = 0
    end
    object bbSetGoodsLink: TdxBarButton
      Action = actSetLinkGoodsForm
      Category = 0
    end
    object bbDeleteLink: TdxBarButton
      Action = mactDeleteLink
      Category = 0
    end
    object bbMovementItemProtocolChild: TdxBarButton
      Action = actMovementItemProtocolChild
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbSelect_Link: TdxBarButton
      Action = actRefresh_Link
      Category = 0
      ShortCut = 8308
    end
    object bbUpdateListDiff: TdxBarButton
      Action = actUpdateListDiff
      Align = iaCenter
      Category = 0
    end
    object bbOpenReport_GoodsPartionDate: TdxBarButton
      Action = actOpenReport_GoodsPartionDate
      Category = 0
    end
    object bbUpdateRealSun: TdxBarButton
      Action = actUpdateRealSun
      Category = 0
    end
    object bbReportSendSUN: TdxBarButton
      Action = actReportSendSUN
      Category = 0
    end
    object bbReportSendDefSUN: TdxBarButton
      Action = actReportSendDefSUN
      Category = 0
    end
    object bbUpdateFinalSUA: TdxBarButton
      Action = actUpdateFinalSUA
      Category = 0
    end
    object bbPUSHDiscount: TdxBarButton
      Action = actPUSHDiscount
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actOrderInternalZeroingSUA
      Category = 0
    end
    object bbListDiffFormVIPSend: TdxBarButton
      Action = actListDiffFormVIPSend
      Category = 0
    end
    object bbUpdateSupplierFailures: TdxBarButton
      Action = actUpdateSupplierFailures
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = PartionGoodsDateColor
        BackGroundValueColumn = OrderShedule_Color
        ColorValueList = <>
      end
      item
        ColorColumn = PartionGoodsDate
        ValueColumn = PartionGoodsDateColor
        BackGroundValueColumn = OrderShedule_Color
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = PartionGoodsDateColor
        BackGroundValueColumn = SupplierFailuresColor
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    SearchAsFilter = False
    Left = 454
    Top = 145
  end
  inherited PopupMenu: TPopupMenu
    Left = 24
    Top = 208
    object N3: TMenuItem [0]
      Action = mactDeleteLinkGroup
    end
    object N2: TMenuItem [1]
      Caption = '-'
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderInternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderInternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderInternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateDialog'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 416
  end
  inherited StatusGuides: TdsdGuides
    Left = 64
    Top = 160
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderInternal'
    Top = 144
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderInternal'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderKindId'
        Value = Null
        Component = GuidesOrderKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderKindName'
        Value = Null
        Component = GuidesOrderKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDocument'
        Value = Null
        Component = edIsDocument
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterId'
        Value = Null
        Component = GuidesOrderInternaPromo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterInvNumber'
        Value = Null
        Component = GuidesOrderInternaPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderInternal'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderKindId'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 258
    Top = 352
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
        Guides = GuidesUnit
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actPUSHInfo
      end>
    Left = 208
    Top = 152
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edUnit
      end
      item
        Control = edOrderKind
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'OrderInternalJournalForm'
    DataSet = 'MasterCDS'
    Left = 113
    Top = 161
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased'
    Left = 710
    Top = 360
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased'
    Left = 710
    Top = 312
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternal'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CalcAmountAll'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerGoodsCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartnerGoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioJuridicalName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioContractName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCalcAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CalcAmount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummAll'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAll'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountAll'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountAll'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCalcAmountAll'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CalcAmountAll'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMakerName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 360
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Top = 204
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 528
    Top = 360
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 351
    Top = 192
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 144
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 872
    Top = 192
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementItemId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 944
    Top = 184
  end
  object DBViewChildAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ValueColumn = colPartionGoodsDateColor
        ColorValueList = <>
      end
      item
        ColorColumn = colGoodsName
        ValueColumn = colPartionGoodsDateColor
        BackGroundValueColumn = colSupplierFailuresColor
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
        Column = colGoodsName
      end
      item
        Column = Amount
      end
      item
        Column = CalcAmountAll
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 926
    Top = 145
  end
  object spUpdatePrioritetPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_OrderInternal_PrioritetPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'JuridicalName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSuperPrice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'SuperFinalPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSuperPrice_Deferment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'SuperFinalPrice_Deferment'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SuperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SuperFinalPrice'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SuperPrice_Deferment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SuperFinalPrice_Deferment'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 216
  end
  object spDelete_Object_LinkGoodsByGoods: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoodsByGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 144
  end
  object GuidesOrderKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderKind
    FormNameParam.Value = 'TOrderKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 144
  end
  object spSelect_Link: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternal'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
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
        Name = 'inIsLink'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 264
  end
  object spUpdateListDiff: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternal_ListDiff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 376
  end
  object GuidesOrderInternaPromo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderInternalPromo
    FormNameParam.Value = 'TOrderInternalJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderInternalJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderInternaPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderInternaPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1072
    Top = 8
  end
  object spPUSH: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_OrderInternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitID'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 802
    Top = 360
  end
  object spUpdateRealSun: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternal_AmountReal_RemainsSun'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 368
  end
  object spSelectChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternal_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
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
        Name = 'inIsLink'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 248
  end
  object spPUSHEVip: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSHVIP_OrderInternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 802
    Top = 416
  end
  object spUpdateFinalSUA: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternal_FinalSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 432
  end
  object spPUSHSUA: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSHSUA_OrderInternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 626
    Top = 424
  end
  object spPUSHDiscount: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_Discount_OrderInternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1058
    Top = 360
  end
  object spPUSHListDiffVIPSend: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_ListDiffVIPSend'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 416
  end
  object spPUSHZeroingSUA: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_OrderInternal_ZeroingSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 698
    Top = 424
  end
  object spUpdateSupplierFailures: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternal_SupplierFailures'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperdate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDateDialog'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1128
    Top = 384
  end
end
