inherited SendForm: TSendForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
  ClientHeight = 617
  ClientWidth = 992
  AddOnFormData.SetFocusedAction = actSetFocused
  ExplicitWidth = 1008
  ExplicitHeight = 656
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 155
    Width = 992
    Height = 462
    ExplicitTop = 155
    ExplicitWidth = 992
    ExplicitHeight = 462
    ClientRectBottom = 462
    ClientRectRight = 992
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 992
      ExplicitHeight = 438
      inherited cxGrid: TcxGrid
        Width = 992
        Height = 318
        ExplicitWidth = 992
        ExplicitHeight = 318
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueTo
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCheck
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
              Column = AmountStorage
            end
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
              Column = RemainsFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueTo
            end>
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupName: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 249
          end
          object NDSKindName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1053#1044#1057
            Options.Editing = False
            Width = 68
          end
          object NDS: TcxGridDBColumn [4]
            Caption = #1053#1044#1057', %'
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object IsClose: TcxGridDBColumn [5]
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object IsTop: TcxGridDBColumn [6]
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object isFirst: TcxGridDBColumn [7]
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn [8]
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object AmountCheck: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1086#1090#1083#1086#1078'. '#1095#1077#1082#1072#1093
            DataBinding.FieldName = 'AmountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1095#1077#1082#1072#1093
            Options.Editing = False
            Width = 62
          end
          object PartionDateKindName: TcxGridDBColumn [10]
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object AmountRemains: TcxGridDBColumn [11]
            Caption = #1054#1089#1090'. '#1082#1086#1083'-'#1074#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object Amount: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086', '#1079#1072#1075#1088#1091#1078#1072#1077#1084#1086#1077' '#1074' '#1090#1086#1095#1082#1091'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086', '#1079#1072#1075#1088#1091#1078#1072#1077#1084#1086#1077' '#1074' '#1090#1086#1095#1082#1091'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
            Width = 99
          end
          object AmountManual: TcxGridDBColumn [13]
            Caption = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1095#1082#1080'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'AmountManual'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            Width = 86
          end
          object AmountDiff: TcxGridDBColumn [14]
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1086' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100')'
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1075#1088#1091#1078#1072#1077#1084#1086#1077' '#1082#1086#1083'-'#1074#1086'  '#1084#1080#1085#1091#1089'  '#1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1095#1082#1080'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            Options.Editing = False
            Width = 69
          end
          object AmountStorage: TcxGridDBColumn [15]
            Caption = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1095#1082#1080'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'AmountStorage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1095#1082#1080'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Width = 86
          end
          object AmountStorageDiff: TcxGridDBColumn [16]
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1086' ('#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'AmountStorageDiff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1075#1088#1091#1078#1072#1077#1084#1086#1077' '#1082#1086#1083'-'#1074#1086'  '#1084#1080#1085#1091#1089'  '#1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086' '#1090#1086#1095#1082#1080'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            Options.Editing = False
            Width = 74
          end
          object CommentSendName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
            DataBinding.FieldName = 'CommentSendName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceCommentSend
                Default = True
                Kind = bkEllipsis
              end
              item
                Action = actClearCommentSend
                Hint = #1059#1073#1088#1072#1090#1100' '#1087#1088#1080#1095#1080#1085#1072' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
                Kind = bkGlyph
              end>
            Properties.Images = dmMain.ImageList
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object PriceIn: TcxGridDBColumn
            Caption = #1059#1089#1088#1077#1076'. '#1079#1072#1082#1091#1087'. '#1094#1077#1085#1072' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1059#1089#1088#1077#1076'. '#1094#1077#1085#1072' '#1079#1072#1082#1091#1087'. ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Price: TcxGridDBColumn
            Caption = #1059#1089#1088#1077#1076'. '#1094#1077#1085#1072' '#1079#1072#1082#1091#1087'.'#1089' '#1091#1095'. % '#1082#1086#1088'-'#1082#1080' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PriceUnitFrom: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'PriceUnitFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object PriceUnitTo: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'PriceUnitTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object SummaUnitFrom: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'SummaUnitFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object SummaUnitTo: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'SummaUnitTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object SumPriceIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1091#1089#1088#1077#1076'. '#1079#1072#1082#1091#1087'. '#1094#1077#1085' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'SumPriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummaWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1074' '#1091#1089#1088#1077#1076'. '#1094#1077#1085#1072#1093' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummaWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1074' '#1091#1089#1088#1077#1076'. '#1094#1077#1085#1072#1093' '#1089' '#1091#1095'. % '#1082#1086#1088'-'#1082#1080' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object ReasonDifferencesName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
            DataBinding.FieldName = 'ReasonDifferencesName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ChoiceReasonDifferences
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
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
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DateInsertChild: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'DateInsertChild'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object AccommodationName: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
            DataBinding.FieldName = 'AccommodationName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object DateInsert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'DateInsert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object RemainsFrom: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' ('#1076#1083#1103' '#1089#1093#1077#1084#1099' '#1069'-'#1057#1059#1053')'
            DataBinding.FieldName = 'RemainsFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object RemainsTo: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103'('#1076#1083#1103' '#1089#1093#1077#1084#1099' '#1069'-'#1057#1059#1053')'
            DataBinding.FieldName = 'RemainsTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object ValueFrom: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1088#1086#1076#1072#1078' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' ('#1076#1083#1103' '#1089#1093#1077#1084#1099' '#1069'-'#1057#1059#1053')'
            DataBinding.FieldName = 'ValueFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object ValueTo: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1088#1086#1076#1072#1078' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103'('#1076#1083#1103' '#1089#1093#1077#1084#1099' '#1069'-'#1057#1059#1053')'
            DataBinding.FieldName = 'ValueTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'. '#1082#1086#1085#1090#1072#1088'.'
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object TechnicalRediscountInvNumber: TcxGridDBColumn
            Caption = #1058#1077#1093'. '#1087#1077#1088#1077#1091#1095#1077#1090
            DataBinding.FieldName = 'TechnicalRediscountInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object TechnicalRediscountOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1090#1077#1093'. '#1087#1077#1088#1077#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'TechnicalRediscountOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 318
        Width = 992
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 326
        Width = 992
        Height = 112
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 2
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object PartyRelated: TcxGridDBColumn
            Caption = #1057#1074#1103#1079#1072#1085#1086' '#1089' '#1087#1072#1088#1090#1080#1077#1081
            DataBinding.FieldName = 'PartyRelated'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object chAmount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object chExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object chPartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 174
          end
          object chOperDate_Income: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1072#1087#1090#1077#1082#1080' ('#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'OperDate_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 110
          end
          object chInvnumber_Income: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Invnumber_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 125
          end
          object chContainerId: TcxGridDBColumn
            Caption = #1048#1076#1077#1085#1090'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'ContainerId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1087#1072#1088#1090#1080#1080
            Options.Editing = False
            Width = 155
          end
          object chFromName_Income: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 160
          end
          object chContractName_Income: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 80
          end
          object chDateInsert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'DateInsert'
            PropertiesClassName = 'TcxDateEditProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object chisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chColor_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 992
    Height = 129
    TabOrder = 3
    ExplicitWidth = 992
    ExplicitHeight = 129
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 19
      ExplicitLeft = 8
      ExplicitTop = 19
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 1
      ExplicitLeft = 8
      ExplicitTop = 1
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Top = 19
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitTop = 19
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      Top = 1
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 89
      ExplicitTop = 1
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Top = 41
      ExplicitTop = 41
    end
    inherited ceStatus: TcxButtonEdit
      Top = 59
      ExplicitTop = 59
      ExplicitWidth = 181
      ExplicitHeight = 22
      Width = 181
    end
    object cxLabel3: TcxLabel
      Left = 195
      Top = 1
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 195
      Top = 19
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 270
    end
    object edTo: TcxButtonEdit
      Left = 477
      Top = 19
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 303
    end
    object cxLabel4: TcxLabel
      Left = 477
      Top = 1
      Caption = #1050#1086#1084#1091
    end
    object cxLabel5: TcxLabel
      Left = 804
      Top = 1
      Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1053#1058#1047
    end
    object cbisDeferred: TcxCheckBox
      Left = 667
      Top = 39
      Caption = #1054#1090#1083#1086#1078#1077#1085
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 69
    end
    object cxLabel29: TcxLabel
      Left = 195
      Top = 41
      Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
    end
    object edPartionDateKind: TcxButtonEdit
      Left = 195
      Top = 59
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 199
    end
    object cbSun: TcxCheckBox
      Left = 477
      Top = 67
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' (v.1)'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 14
      Width = 172
    end
    object cbDefSun: TcxCheckBox
      Left = 667
      Top = 81
      Hint = #1054#1090#1083#1086#1078#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Caption = #1054#1090#1083#1086#1078#1077#1085#1086' '#1087#1086' '#1057#1059#1053
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 15
      Width = 126
    end
    object cbReceived: TcxCheckBox
      Left = 667
      Top = 67
      Hint = #1054#1090#1083#1086#1078#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Caption = #1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 16
      Width = 95
    end
    object cbSent: TcxCheckBox
      Left = 667
      Top = 53
      Hint = #1054#1090#1083#1086#1078#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053
      Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086'-'#1076#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 17
      Width = 103
    end
    object edIsAuto: TcxCheckBox
      Left = 477
      Top = 39
      Hint = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 188
    end
    object cbSun_v2: TcxCheckBox
      Left = 477
      Top = 81
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' ('#1074#1077#1088#1089#1080#1103'2)'
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' (v.2)'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 19
      Width = 189
    end
    object cxCurrencyEdit1: TcxCurrencyEdit
      Left = 804
      Top = 19
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 37
    end
    object cxLabel9: TcxLabel
      Left = 400
      Top = 41
      Caption = #1050#1086#1083'-'#1074#1086' '#1084#1077#1089#1090
    end
    object cbSUN_v3: TcxCheckBox
      Left = 477
      Top = 95
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1069'-'#1057#1059#1053
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1069'-'#1057#1059#1053
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 22
      Width = 148
    end
    object cbSUN_v4: TcxCheckBox
      Left = 477
      Top = 109
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 23
      Width = 176
    end
    object cbNotDisplaySUN: TcxCheckBox
      Left = 477
      Top = 53
      Hint = #1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053
      Caption = #1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 188
    end
    object edNumberSeats: TcxCurrencyEdit
      Left = 400
      Top = 59
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = False
      TabOrder = 25
      Width = 65
    end
    object edDay: TcxCurrencyEdit
      Left = 804
      Top = 59
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 37
    end
    object cxLabel6: TcxLabel
      Left = 804
      Top = 41
      Caption = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1053#1058#1047' '#1076#1083#1103' '#1061' '#1076#1085#1077#1081
    end
    object cxLabel8: TcxLabel
      Left = 8
      Top = 87
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1083#1091#1095#1080#1074#1096#1080#1081' '#1090#1086#1074#1072#1088
    end
    object edDriverSun: TcxButtonEdit
      Left = 8
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = False
      TabOrder = 29
      Width = 181
    end
    object cxLabel7: TcxLabel
      Left = 195
      Top = 87
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    end
    object edComment: TcxTextEdit
      Left = 195
      Top = 103
      Properties.ReadOnly = False
      TabOrder = 31
      Width = 270
    end
    object cbVIP: TcxCheckBox
      Left = 667
      Top = 95
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1042#1048#1055
      Caption = #1042#1048#1055
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 32
      Width = 46
    end
    object cbConfirmed: TcxCheckBox
      Left = 667
      Top = 109
      Hint = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1086' '#1089#1073#1086#1088' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' VIP'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 33
      Width = 30
    end
    object cbUrgently: TcxCheckBox
      Left = 716
      Top = 95
      Hint = #1057#1088#1086#1095#1085#1086' '
      Caption = #1057#1088#1086#1095#1085#1086' '
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 34
      Width = 64
    end
    object edConfirmed: TcxTextEdit
      Left = 684
      Top = 109
      TabStop = False
      ParentColor = True
      Properties.ReadOnly = True
      Style.BorderStyle = ebsNone
      TabOrder = 35
      Text = #1054#1078#1080#1076#1072#1077#1090' '#1087#1086#1076#1090#1074#1077#1088#1078#1076'.'
      Width = 125
    end
    object cbisBanFiscalSale: TcxCheckBox
      Left = 799
      Top = 81
      Hint = #1055#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1090#1086#1083#1100#1082#1086' '#1079#1072#1087#1088#1077#1097#1077#1085#1085#1099#1081' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      Caption = #1047#1072#1087#1088'. '#1082' '#1092#1080#1089#1082'. '#1087#1088#1086#1076#1072#1078#1077
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 36
      Width = 126
    end
    object cbSendLoss: TcxCheckBox
      Left = 799
      Top = 95
      Hint = #1055#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1090#1086#1083#1100#1082#1086' '#1079#1072#1087#1088#1077#1097#1077#1085#1085#1099#1081' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      Caption = #1042' '#1087#1086#1083#1085#1086#1077' '#1089#1087#1080#1089#1072#1085#1080#1077
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 37
      Width = 126
    end
  end
  object ceChecked: TcxCheckBox [2]
    Left = 732
    Top = 133
    Caption = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1084'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1084
    TabOrder = 6
    Visible = False
    Width = 220
  end
  object edisComplete: TcxCheckBox [3]
    Left = 514
    Top = 134
    Caption = #1057#1086#1073#1088#1072#1085#1086' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1084'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1077#1084
    TabOrder = 7
    Visible = False
    Width = 214
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 259
    Top = 432
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 47
    Top = 327
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      RefreshOnTabSetChanges = True
    end
    object spUpdateisDeferredNo: TdsdExecStoredProc [7]
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_No
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      ImageIndex = 52
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetTotalSumm
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
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
      ReportName = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ReportNameParam.Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actComplete: TdsdExecStoredProc [11]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
      QuestionBeforeExecute = 
        #1042#1053#1048#1052#1040#1053#1048#1045'! '#1042' '#1050#1040#1057#1057#1059' '#1041#1059#1044#1059#1058' '#1047#1040#1043#1056#1059#1046#1045#1053#1067' '#1082#1086#1083'-'#1074#1072' '#1080#1079' '#1082#1086#1083#1086#1085#1082#1080' "'#1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1091 +
        #1095#1072#1090#1077#1083#1103'". '#1055#1056#1054#1042#1045#1056#1068#1058#1045' '#1048#1061'.'
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
      QuestionBeforeExecute = 
        #1042#1053#1048#1052#1040#1053#1048#1045'! '#1042' '#1050#1040#1057#1057#1059' '#1041#1059#1044#1059#1058' '#1047#1040#1043#1056#1059#1046#1045#1053#1067' '#1082#1086#1083'-'#1074#1072' '#1080#1079' '#1082#1086#1083#1086#1085#1082#1080' "'#1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1091 +
        #1095#1072#1090#1077#1083#1103'". '#1055#1056#1054#1042#1045#1056#1068#1058#1045' '#1048#1061'.'
    end
    object actGoodsKindChoice: TOpenChoiceForm [15]
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
    inherited actNewDocument: TdsdInsertUpdateAction [17]
    end
    inherited MultiAction: TMultiAction [18]
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actStorageChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageForm'
      FormName = 'TStorage_ObjectForm'
      FormNameParam.Value = 'TStorage_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPartionGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionGoodsForm'
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName_Partion'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartion'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsOperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ChoiceReasonDifferences: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1095#1080#1085#1099' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
      FormName = 'TReasonDifferencesForm'
      FormNameParam.Value = 'TReasonDifferencesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsert_Object_Price
      StoredProcList = <
        item
          StoredProc = spInsert_Object_Price
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 56
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actExecuteDialogInsertPrice: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      ImageIndex = 56
      FormName = 'TPriceBySendDialogForm'
      FormNameParam.Value = 'TPriceBySendDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPriceNew'
          Value = 42951d
          Component = FormParams
          ComponentItem = 'inPriceNew'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macInsertPrice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialogInsertPrice
        end
        item
          Action = actInsertPrice
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1062#1077#1085#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1062#1077#1085#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      ImageIndex = 56
    end
    object spUpdateisDeferredYes: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_Yes
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      ImageIndex = 79
    end
    object spWriteRestFromPoint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_Send_WriteRestFromPoint
      StoredProcList = <
        item
          StoredProc = spInsert_Send_WriteRestFromPoint
        end>
      Caption = 'spWriteRestFromPoint'
    end
    object actWriteRestFromPoint: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spWriteRestFromPoint
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080'?'
      Caption = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      Hint = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      ImageIndex = 30
    end
    object actUpdate_SendOverdue: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecUpdate_SendOverdue
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 10
    end
    object actExecUpdate_SendOverdue: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SendOverdue
      StoredProcList = <
        item
          StoredProc = spUpdate_SendOverdue
        end>
      Caption = 'actExecUpdate_SendOverdue'
    end
    object actUpdateDataSetDetailDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateDataSetDetailDS'
      DataSource = DetailDS
    end
    object actSetReceived: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecSetReceived
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
      ImageIndex = 61
    end
    object actExecSetReceived: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Received
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Received
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1077#1085#1086'-'#1076#1072'"'
    end
    object actSetSent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actExecSetSent
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' " '#1054#1090#1087#1088#1072#1074#1083#1077#1085#1086'-'#1076#1072'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' " '#1054#1090#1087#1088#1072#1074#1083#1077#1085#1086' -'#1076#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' " '#1054#1090#1087#1088#1072#1074#1083#1077#1085#1086' -'#1076#1072'"'
      ImageIndex = 43
    end
    object actExecSetSent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Sent
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Sent
        end>
      Caption = 'actExecSetSent'
    end
    object actSetNotDisplaySUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_NotDisplaySUN
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_NotDisplaySUN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053'"'
      ImageIndex = 44
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1073#1086#1088#1072' '#1057#1059#1053'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actCreateLoss: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecCreateLoss
        end
        item
          Action = actOpenLossForm
        end>
      QuestionBeforeExecute = #1057#1086#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103' '#1080' '#1089#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1085#1077#1075#1086' '#1090#1086#1074#1072#1088'?'
      Caption = #1057#1086#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103' '#1080' '#1089#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1085#1077#1075#1086' '#1090#1086#1074#1072#1088
      Hint = #1057#1086#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103' '#1080' '#1089#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1085#1077#1075#1086' '#1090#1086#1074#1072#1088
      ImageIndex = 24
    end
    object actExecCreateLoss: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCreateLoss
      StoredProcList = <
        item
          StoredProc = spCreateLoss
        end>
      Caption = 'actExecCreateLoss'
    end
    object actOpenLossForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenLossForm'
      FormName = 'TLossForm'
      FormNameParam.Value = 'TLossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'LossID'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
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
      isShowModal = False
    end
    object actExecSetConfirmed: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actOpenConfirmedDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Confirmed
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Confirmed
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'"'
      ImageIndex = 51
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'"?'
    end
    object actOpenConfirmedDialog: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageForm'
      FormName = 'TConfirmedDialogForm'
      FormNameParam.Value = 'TConfirmedDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isConfirmed'
          Value = Null
          Component = FormParams
          ComponentItem = 'isConfirmed'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceCommentSend: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actMovementItem_ShowPUSH_Comment
      PostDataSetBeforeExecute = False
      Caption = 'ChoiceCommentSend'
      FormName = 'TCommentSendForm'
      FormNameParam.Value = 'TCommentSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CommentSendId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CommentSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actClearCommentSend: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1059#1073#1088#1072#1090#1100' '#1087#1088#1080#1095#1080#1085#1072' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
      ImageIndex = 52
      DefaultParams = <
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'CommentSendId'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'CommentSendCode'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'CommentSendName'
          Param.DataType = ftString
          Param.MultiSelectSeparator = ','
          Value = Null
        end>
    end
    object actUpdate_MovementItem_ContainerId: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoicePartionDateGoodsList
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MovementItem_ContainerId
      StoredProcList = <
        item
          StoredProc = spUpdate_MovementItem_ContainerId
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1091' '#1082' '#1072#1088#1090#1080#1081#1085#1086#1084#1091' '#1082#1086#1085#1090#1077#1081#1085#1077#1088#1091
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1091' '#1082' '#1072#1088#1090#1080#1081#1085#1086#1084#1091' '#1082#1086#1085#1090#1077#1081#1085#1077#1088#1091
      ImageIndex = 67
    end
    object actChoicePartionDateGoodsList: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePartionDateGoodsList'
      FormName = 'TPartionDateGoodsListForm'
      FormNameParam.Value = 'TPartionDateGoodsListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ContainerID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAddNewLine'
          Value = False
          Component = FormParams
          ComponentItem = 'isAddNewLine'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMovementItem_ShowPUSH_Comment: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementItem_ShowPUSH_Comment
      StoredProcList = <
        item
          StoredProc = spMovementItem_ShowPUSH_Comment
        end>
      Caption = 'actMovementItem_ShowPUSH_Comment'
    end
    object actChoiceIncome: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceIncome'
      FormName = 'TChoiceIncomeForm'
      FormNameParam.Value = 'TChoiceIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'IncomeId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecLoadIncome: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoiceIncome
      PostDataSetBeforeExecute = False
      StoredProc = spAddIncome
      StoredProcList = <
        item
          StoredProc = spAddIncome
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1087#1088#1080#1093#1086#1076#1085#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1087#1088#1080#1093#1086#1076#1085#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 29
    end
    object actMISetErasedDetail: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMasterDetail
      StoredProcList = <
        item
          StoredProc = spErasedMIMasterDetail
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1080#1074#1103#1079#1082#1091' '#1082' '#1087#1072#1088#1090#1080#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1080#1074#1103#1079#1082#1091' '#1082' '#1087#1072#1088#1090#1080#1080'>'
      ImageIndex = 7
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErasedDetail: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIMasterDetail
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMasterDetail
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 80
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    object actUpdteSendLoss: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateSendLoss
      StoredProcList = <
        item
          StoredProc = spUpdateSendLoss
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042' '#1087#1086#1083#1085#1086#1077' '#1089#1087#1080#1089#1072#1085#1080#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042' '#1087#1086#1083#1085#1086#1077' '#1089#1087#1080#1089#1072#1085#1080#1077'"'
      ImageIndex = 77
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042' '#1087#1086#1083#1085#1086#1077' '#1089#1087#1080#1089#1072#1085#1080#1077'"?'
    end
    object actSetFocused: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetFocused'
      ControlName.Value = ''
      ControlName.Component = FormParams
      ControlName.ComponentItem = 'SetFocused'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Top = 424
  end
  inherited MasterCDS: TClientDataSet
    Left = 96
    Top = 440
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send'
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
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
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
          ItemName = 'bbComplete'
        end
        item
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
          ItemName = 'bbMISetErasedDetail'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedDetail'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertPrice'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeferredYes'
        end
        item
          Visible = True
          ItemName = 'bbDeferredNo'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbWriteRestFromPoint'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdteSendLoss'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Width = 16
    end
    inherited bbStatic: TdxBarStatic
      Width = 16
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object bbInsertPrice: TdxBarButton
      Action = macInsertPrice
      Category = 0
    end
    object bbDeferredNo: TdxBarButton
      Action = spUpdateisDeferredNo
      Category = 0
    end
    object bbDeferredYes: TdxBarButton
      Action = spUpdateisDeferredYes
      Category = 0
    end
    object bbWriteRestFromPoint: TdxBarButton
      Action = actWriteRestFromPoint
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdate_SendOverdue
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actSetSent
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actSetReceived
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actSetNotDisplaySUN
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actCreateLoss
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actExecSetConfirmed
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actUpdate_MovementItem_ContainerId
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actExecLoadIncome
      Category = 0
    end
    object bbMISetErasedDetail: TdxBarButton
      Action = actMISetErasedDetail
      Category = 0
    end
    object bbMISetUnErasedDetail: TdxBarButton
      Action = actMISetUnErasedDetail
      Category = 0
    end
    object bbUpdteSendLoss: TdxBarButton
      Action = actUpdteSendLoss
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Left = 454
    Top = 385
  end
  inherited PopupMenu: TPopupMenu
    Left = 520
    Top = 480
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
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
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 43681d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LossID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isConfirmed'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContainerID'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAddNewLine'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeId'
        Value = 'False'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SetFocused'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 456
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Left = 264
    Top = 40
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Send'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
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
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = 0d
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAuto'
        Value = Null
        Component = edIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MCSPeriod'
        Value = Null
        Component = edNumberSeats
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MCSDay'
        Value = Null
        Component = edDay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = Null
        Component = ceChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete'
        Value = Null
        Component = edisComplete
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindId'
        Value = Null
        Component = GuidesPartionDateKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindName'
        Value = Null
        Component = GuidesPartionDateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSun'
        Value = Null
        Component = cbSun
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDefSun'
        Value = Null
        Component = cbDefSun
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSent'
        Value = Null
        Component = cbSent
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReceived'
        Value = False
        Component = cbReceived
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverSunId'
        Value = Null
        Component = GuidesDriverSun
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverSunName'
        Value = Null
        Component = GuidesDriverSun
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotDisplaySUN'
        Value = Null
        Component = cbNotDisplaySUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSun_v2'
        Value = Null
        Component = cbSun_v2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberSeats'
        Value = Null
        Component = edNumberSeats
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUN_v3'
        Value = Null
        Component = cbSUN_v3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUN_v4'
        Value = Null
        Component = cbSUN_v4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVIP'
        Value = Null
        Component = cbVIP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUrgently'
        Value = Null
        Component = cbUrgently
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isConfirmed'
        Value = Null
        Component = cbConfirmed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedText'
        Value = Null
        Component = edConfirmed
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBanFiscalSale'
        Value = Null
        Component = cbisBanFiscalSale
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSendLoss'
        Value = Null
        Component = cbSendLoss
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SetFocused'
        Value = Null
        Component = FormParams
        ComponentItem = 'SetFocused'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Send'
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
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 0d
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = False
        Component = ceChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisComplete'
        Value = False
        Component = edisComplete
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberSeats'
        Value = Null
        Component = edNumberSeats
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDriverSunId'
        Value = Null
        Component = GuidesDriverSun
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
    Left = 160
    Top = 208
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edComment
      end
      item
        Control = ceChecked
      end
      item
        Control = edisComplete
      end
      item
        Control = edNumberSeats
      end
      item
        Control = edDriverSun
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 240
    Top = 217
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 472
    Top = 432
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetErased'
    Left = 638
    Top = 448
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetUnErased'
    Left = 558
    Top = 416
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceUnitFrom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceUnitFrom'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceUnitTo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceUnitTo'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumma'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SumPriceIn'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummaUnitTo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaUnitTo'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountStorage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountStorage'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountStorageDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountStorageDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferencesId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentSendId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CommentSendId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 360
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
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
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 404
    Top = 252
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 304
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
    StoredProcName = 'gpSelect_Movement_Send_Print'
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
    Left = 367
    Top = 376
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 16
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 544
    Top = 16
  end
  object ActionList1: TActionList
    Images = dmMain.ImageList
    Left = 71
    Top = 263
    object dsdDataSetRefresh1: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdGridToExcel1: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actOpenPartionReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'RemainsDate'
          Value = 42370d
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_RemainsOverGoodsDialogForm'
      FormNameParam.Value = 'TReport_RemainsOverGoodsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPeriod'
          Value = 30.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inDay'
          Value = 12.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actSend: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = 'actSend'
      ImageIndex = 41
    end
    object macSend: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSend
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      ImageIndex = 41
    end
  end
  object ActionList2: TActionList
    Images = dmMain.ImageList
    Left = 71
    Top = 263
    object dsdDataSetRefresh2: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdGridToExcel2: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object dsdOpenForm1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'RemainsDate'
          Value = 42370d
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdDataSetRefresh3: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdDataSetRefresh4: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog1: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_RemainsOverGoodsDialogForm'
      FormNameParam.Value = 'TReport_RemainsOverGoodsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPeriod'
          Value = 30.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inDay'
          Value = 12.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = 'dsdExecStoredProc1'
      ImageIndex = 41
    end
    object MultiAction1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      ImageIndex = 41
    end
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Send'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCurrentData'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 288
  end
  object spInsert_Object_Price: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_Price_BySend'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = 42261d
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 'edInvNumber'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceNew'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPriceNew'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceUnitTo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceUnitTo'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummaUnitTo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummaUnitTo'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 274
    Top = 344
  end
  object spUpdate_isDeferred_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_Deferred'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 219
  end
  object spUpdate_isDeferred_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_Deferred'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 283
  end
  object spInsert_Send_WriteRestFromPoint: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Send_WriteRestFromPoint'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 219
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 80
    Top = 544
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 168
    Top = 544
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ValueColumn = chColor_calc
        ColorInValueColumn = False
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    KeepSelectColor = True
    PropertiesCellList = <>
    Left = 318
    Top = 529
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send_Child'
    DataSet = DetailDCS
    DataSets = <
      item
        DataSet = DetailDCS
      end>
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
    Left = 464
    Top = 536
  end
  object GuidesPartionDateKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartionDateKind
    FormNameParam.Value = 'TPartionDateKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartionDateKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartionDateKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartionDateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 64
  end
  object spUpdate_SendOverdue: TdsdStoredProc
    StoredProcName = 'grUpdate_MovementUnit_SendOverdue'
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
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 878
    Top = 336
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ID'
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
        Name = 'inAmount'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 160
    Top = 408
  end
  object GuidesDriverSun: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDriverSun
    FormNameParam.Value = 'TDriverSunForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDriverSunForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDriverSun
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDriverSun
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 96
  end
  object spUpdate_Movement_Received: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Received'
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
        Name = 'inisReceived'
        Value = Null
        Component = cbReceived
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReceived'
        Value = Null
        Component = cbReceived
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 355
  end
  object spUpdate_Movement_Sent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sent'
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
        Name = 'inisSent'
        Value = Null
        Component = cbSent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSent'
        Value = Null
        Component = cbSent
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 419
  end
  object spUpdate_Movement_NotDisplaySUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_NotDisplaySUN'
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
        Name = 'inisNotDisplaySUN'
        Value = False
        Component = cbNotDisplaySUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotDisplaySUN'
        Value = False
        Component = cbNotDisplaySUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 491
  end
  object spCreateLoss: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Loss_FromSend'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outLossID'
        Value = Null
        Component = FormParams
        ComponentItem = 'LossID'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 878
    Top = 400
  end
  object spUpdate_Movement_Confirmed: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Confirmed'
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
        Name = 'inisConfirmed'
        Value = False
        Component = FormParams
        ComponentItem = 'isConfirmed'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisConfirmed'
        Value = False
        Component = cbConfirmed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outConfirmedText'
        Value = Null
        Component = edConfirmed
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 291
  end
  object spUpdate_MovementItem_ContainerId: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Send_ContainerId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = False
        Component = DetailDCS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContainerID'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'ContainerID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAddNewLine'
        Value = Null
        Component = FormParams
        ComponentItem = 'isAddNewLine'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 379
  end
  object spMovementItem_ShowPUSH_Comment: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send_ShowPUSH_Comment'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCommentSendId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CommentSendId'
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
    Left = 383
    Top = 424
  end
  object spAddIncome: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_AddIncome'
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
        Name = 'inIncomeId'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 606
    Top = 280
  end
  object spErasedMIMasterDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetErasedDetail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 670
    Top = 544
  end
  object spUnErasedMIMasterDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetUnErasedDetail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 582
    Top = 544
  end
  object spUpdateSendLoss: TdsdStoredProc
    StoredProcName = 'grUpdate_Movement_SendLoss'
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
        Name = 'inisSendLoss'
        Value = Null
        Component = cbSendLoss
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 886
    Top = 496
  end
end
