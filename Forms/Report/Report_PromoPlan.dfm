inherited Report_PromoPlanForm: TReport_PromoPlanForm
  Caption = #1054#1090#1095#1077#1090' '#1055#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1086' '#1072#1082#1094#1080#1103#1084
  ClientHeight = 434
  ClientWidth = 885
  AddOnFormData.ExecuteDialogAction = actReport_PromoDialog
  ExplicitWidth = 901
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 885
    Height = 351
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 885
    ExplicitHeight = 351
    ClientRectBottom = 351
    ClientRectRight = 885
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1055#1088#1086#1089#1084#1086#1090#1088
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 885
      ExplicitHeight = 327
      inherited cxGrid: TcxGrid
        Width = 885
        Height = 327
        ExplicitWidth = 885
        ExplicitHeight = 327
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan1_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan7_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan6_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan5_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan4_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan3_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan2_Wh
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale7
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale6
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale5
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale4
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale3
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale2
            end>
          DataController.Summary.FooterSummaryItems = <
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
            end
            item
              Format = #1057#1090#1088#1086#1082' ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan1_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan7_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan6_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan5_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan4_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan3_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan2_Wh
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale7
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale6
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale5
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale4
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale3
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = AmountSale2
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
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object Checked: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086
            DataBinding.FieldName = 'Checked'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1050#1086#1084'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object UnitName_PersonalTrade: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1050#1086#1084'. '#1086#1090#1076#1077#1083')'
            DataBinding.FieldName = 'UnitName_PersonalTrade'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object BranchCode_PersonalTrade: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092#1080#1083'. ('#1050#1086#1084'. '#1086#1090#1076#1077#1083')'
            DataBinding.FieldName = 'BranchCode_PersonalTrade'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object BranchName_PersonalTrade: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1050#1086#1084'. '#1086#1090#1076#1077#1083')'
            DataBinding.FieldName = 'BranchName_PersonalTrade'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object DateStartSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DateStartSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DeteFinalSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DeteFinalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DateStartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateStartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object DateFinalPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateFinalPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object RetailName: TcxGridDBColumn
            Caption = #1057#1077#1090#1100', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1088#1086#1093#1086#1076#1080#1090' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1079#1080#1094#1080#1080
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1055#1086#1079#1080#1094#1080#1103
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object GoodsKindName_List: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_List'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            Options.Editing = False
            Width = 77
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object AmountPlan1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Options.Editing = False
            Width = 55
          end
          object AmountPlan2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPlan3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPlan4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPlan5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPlan6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPlan7: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPlan1_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Options.Editing = False
            Width = 60
          end
          object AmountPlan2_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPlan3_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPlan4_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPlan5_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPlan6_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan6_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPlan7_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountSale1: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 1 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AmountSale2: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 2 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AmountSale3: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 3 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AmountSale4: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 4 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AmountSale5: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 5 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AmountSale6: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 6 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AmountSale7: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 7 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object GoodsWeight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'GoodsWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object UnitName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object MonthPromo: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MonthPromo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'isPromo'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1083#1080' '#1044#1072' - '#1101#1090#1086' '#1040#1082#1094#1080#1103', '#1053#1077#1090' - '#1058#1077#1085#1076#1077#1088#1099
            Options.Editing = False
            Width = 45
          end
        end
      end
    end
    object tsPlan: TcxTabSheet
      Caption = '&2. '#1042#1074#1086#1076' '#1087#1083#1072#1085
      ImageIndex = 4
      object cxGridPlan: TcxGrid
        Left = 0
        Top = 0
        Width = 885
        Height = 327
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewPlan: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan1_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan2_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan3_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan4_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan5_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan6_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan7_Wh
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale2
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale3
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale4
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale5
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale6
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale7
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = '0,###'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082' 0,'
              Kind = skCount
              Column = plGoodsName
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan1_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan2_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan3_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan4_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan5_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan6_Wh
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = plAmountPlan7_Wh
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale2
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale3
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale4
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale5
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale6
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = plAmountSale7
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 50
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object plInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object plChecked: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086
            DataBinding.FieldName = 'Checked'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object plPersonalTradeName: TcxGridDBColumn
            Caption = #1050#1086#1084'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object plPersonalName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object plDateStartSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DateStartSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object plDeteFinalSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DeteFinalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object plDateStartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateStartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object plDateFinalPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateFinalPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object plRetailName: TcxGridDBColumn
            Caption = #1057#1077#1090#1100', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1088#1086#1093#1086#1076#1080#1090' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object plTradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object plGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1079#1080#1094#1080#1080
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object plGoodsName: TcxGridDBColumn
            Caption = #1055#1086#1079#1080#1094#1080#1103
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object plGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object plGoodsKindName_List: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_List'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object plMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object plAmountPlan1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Width = 55
          end
          object plAmountPlan2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plAmountPlan3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plAmountPlan4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plAmountPlan5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plAmountPlan6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plAmountPlan7: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plAmountPlan1_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Options.Editing = False
            Width = 60
          end
          object plAmountPlan2_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plAmountPlan3_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plAmountPlan4_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plAmountPlan5_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plAmountPlan6_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan6_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plAmountPlan7_Wh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7_Wh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plAmountSale1: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 1 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plAmountSale2: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 2 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plAmountSale3: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 3 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plAmountSale4: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 4 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plAmountSale5: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 5 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plAmountSale6: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 6 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plAmountSale7: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1080'  '#1079#1072' 7 ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plGoodsWeight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'GoodsWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object plMonthPromo: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MonthPromo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object plUnitName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object plisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
        object cxGridLevelPlan: TcxGridLevel
          GridView = cxGridDBTableViewPlan
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 885
    Height = 57
    ExplicitWidth = 885
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 114
      EditValue = 42736d
      ExplicitLeft = 114
    end
    inherited deEnd: TcxDateEdit
      Left = 114
      Top = 32
      EditValue = 42736d
      ExplicitLeft = 114
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 22
      ExplicitLeft = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 3
      Top = 33
      ExplicitLeft = 3
      ExplicitTop = 33
    end
    object cxLabel17: TcxLabel
      Left = 211
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 301
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 285
    end
    object cbPromo: TcxCheckBox
      Left = 211
      Top = 32
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080
      State = cbsChecked
      TabOrder = 6
      Width = 144
    end
    object cbTender: TcxCheckBox
      Left = 368
      Top = 32
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1058#1077#1085#1076#1077#1088#1099
      TabOrder = 7
      Width = 165
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 592
    Top = 6
    Caption = #1057#1082#1083#1072#1076':'
  end
  object edUnitSale: TcxButtonEdit [3]
    Left = 633
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 196
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 255
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxMasterDS'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateEnd'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actReport_PromoDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PromoDialogForm'
      FormNameParam.Value = 'TReport_PromoDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPromo'
          Value = Null
          Component = cbPromo
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTender'
          Value = Null
          Component = cbTender
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
      ImageIndex = 1
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdatePlanDS: TdsdUpdateDataSet
      Category = 'Plan'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Plan
      StoredProcList = <
        item
          StoredProc = spUpdate_Plan
        end>
      Caption = 'actUpdatePlanDS'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 336
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Promo_Plan'
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
        Name = 'inIsPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTender'
        Value = Null
        Component = cbTender
        DataType = ftBoolean
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
      end
      item
        Name = 'inUnitId_Sale'
        Value = Null
        Component = GuidesUnitSale
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 328
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
    object dxBarButton1: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actReport_PromoDialog
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actOpenPromo
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenPromo
      end>
    ActionItemList = <
      item
        Action = actOpenPromo
        ShortCut = 13
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 120
    Top = 304
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 176
    Top = 184
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end>
    Left = 208
    Top = 224
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
        DataType = ftString
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
    Left = 420
  end
  object spUpdate_Plan: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoGoods_Plan_byReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan1'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan2'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan3'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan4'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan5'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan6'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan7'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan3'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan5'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan6'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPlan7'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan1_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan1_wh'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan2_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan2_wh'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan3_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan3_wh'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan4_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan4_wh'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan5_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan5_wh'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan6_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan6_wh'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan7_wh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan7_wh'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 248
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPlan
    OnDblClickActionList = <
      item
        Action = actOpenPromo
      end>
    ActionItemList = <
      item
        Action = actOpenPromo
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 712
    Top = 240
  end
  object GuidesUnitSale: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitSale
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitSale
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitSale
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 700
  end
end
