inherited OrderExternalUnitForm: TOrderExternalUnitForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1085#1072' '#1075#1083'.'#1089#1082#1083#1072#1076')>'
  ClientHeight = 399
  ClientWidth = 1024
  ExplicitWidth = 1040
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 166
    Width = 1024
    Height = 233
    ExplicitTop = 166
    ExplicitWidth = 1024
    ExplicitHeight = 233
    ClientRectBottom = 233
    ClientRectRight = 1024
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1024
      ExplicitHeight = 209
      inherited cxGrid: TcxGrid
        Width = 1024
        Height = 209
        ExplicitWidth = 1024
        ExplicitHeight = 209
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
              Column = AmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm_Partner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCalcOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSecond_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff_child
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
              Column = AmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm_Partner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCalcOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSecond_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff_child
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ArticleGLN: TcxGridDBColumn [1]
            Caption = #1040#1088#1090#1080#1082#1091#1083' GLN'
            DataBinding.FieldName = 'ArticleGLN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 250
          end
          object GoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountRemains: TcxGridDBColumn [6]
            Caption = #1054#1089#1090'. '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taRightJustify
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartner: TcxGridDBColumn [7]
            Caption = #1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taRightJustify
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountForecastOrder: TcxGridDBColumn [8]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountForecast: TcxGridDBColumn [9]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountForecast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountCalcOrder: TcxGridDBColumn [10]
            Caption = #1047#1072#1082#1072#1079' '#1087#1086' '#1079#1072#1103#1074'. '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountCalcOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountCalc: TcxGridDBColumn [11]
            Caption = #1047#1072#1082#1072#1079' '#1087#1086' '#1087#1088#1086#1076'. '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountCalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSecond: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price: TcxGridDBColumn [14]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountForPrice: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object AmountSumm: TcxGridDBColumn [16]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object AmountSumm_Partner: TcxGridDBColumn [17]
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'AmountSumm_Partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyCode: TcxGridDBColumn [18]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn [19]
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn [20]
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn [21]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount_child: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090'.'
            DataBinding.FieldName = 'Amount_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072
            Options.Editing = False
            Width = 87
          end
          object AmountSecond_child: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'AmountSecond_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 104
          end
          object AmountDiff_child: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089' ('#1079#1072#1082#1072#1079' + '#1076#1086#1079#1072#1082#1072#1079')'
            DataBinding.FieldName = 'AmountDiff_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089' ('#1079#1072#1082#1072#1079' + '#1076#1086#1079#1072#1082#1072#1079')'
            Options.Editing = False
            Width = 87
          end
          object StartBegin: TcxGridDBColumn
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'StartBegin'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndBegin: TcxGridDBColumn
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
            DataBinding.FieldName = 'EndBegin'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object diffBegin_sec: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082'.'
            DataBinding.FieldName = 'diffBegin_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1024
    Height = 140
    TabOrder = 3
    ExplicitWidth = 1024
    ExplicitHeight = 140
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 180
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 180
      ExplicitWidth = 82
      Width = 82
    end
    inherited cxLabel2: TcxLabel
      Left = 180
      Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
      ExplicitLeft = 180
      ExplicitWidth = 68
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 168
      ExplicitHeight = 22
      Width = 168
    end
    object cxLabel5: TcxLabel
      Left = 88
      Top = 5
      Caption = #8470' '#1079#1072#1103#1074'.'#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edInvNumberOrder: TcxTextEdit
      Left = 88
      Top = 23
      TabOrder = 7
      Width = 88
    end
    object cxLabel3: TcxLabel
      Left = 385
      Top = 85
      Caption = #1044#1072#1090#1072' '#1084#1072#1088#1082#1080#1088#1086#1074'.'
    end
    object edOperDateMark: TcxDateEdit
      Left = 387
      Top = 103
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 9
      Width = 80
    end
    object cxLabel10: TcxLabel
      Left = 180
      Top = 45
      Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
    end
    object edOperDatePartner: TcxDateEdit
      Left = 180
      Top = 63
      EditValue = 42187d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 82
    end
    object cxLabel4: TcxLabel
      Left = 267
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 267
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 200
    end
    object cxLabel6: TcxLabel
      Left = 606
      Top = 45
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 606
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 77
    end
    object cxLabel9: TcxLabel
      Left = 606
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContract: TcxButtonEdit
      Left = 606
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 77
    end
    object cxLabel13: TcxLabel
      Left = 1007
      Top = 85
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
      Visible = False
    end
    object edRouteSorting: TcxButtonEdit
      Left = 1007
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Visible = False
      Width = 118
    end
    object cxLabel7: TcxLabel
      Left = 472
      Top = 45
      Caption = #1052#1072#1088#1096#1088#1091#1090
    end
    object edRoute: TcxButtonEdit
      Left = 472
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 130
    end
    object cxLabel16: TcxLabel
      Left = 473
      Top = 85
      Caption = #1060#1080#1079'. '#1083#1080#1094#1086' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
    end
    object edMember: TcxButtonEdit
      Left = 472
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 130
    end
    object cxLabel11: TcxLabel
      Left = 833
      Top = 5
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 833
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 25
      Width = 176
    end
    object cxLabel8: TcxLabel
      Left = 472
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 472
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 130
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 829
      Top = 40
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 28
      Width = 128
    end
    object cxLabel12: TcxLabel
      Left = 969
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 969
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 30
      Width = 40
    end
    object cxLabel14: TcxLabel
      Left = 684
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 684
      Top = 63
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 32
      Width = 144
    end
    object edContractTag: TcxButtonEdit
      Left = 684
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 144
    end
    object cxLabel17: TcxLabel
      Left = 684
      Top = 5
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object cbPrinted: TcxCheckBox
      Left = 829
      Top = 55
      Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1085' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 35
      Width = 128
    end
    object edDayCount: TcxCurrencyEdit
      Left = 267
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 36
      Width = 31
    end
    object cxLabel18: TcxLabel
      Left = 267
      Top = 45
      Caption = #1044#1085#1080
    end
    object cxLabel19: TcxLabel
      Left = 301
      Top = 45
      Caption = #1055#1088#1086#1075#1085#1086#1079' '#1089
    end
    object cxLabel20: TcxLabel
      Left = 385
      Top = 45
      Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086
    end
    object edOperDateStart: TcxDateEdit
      Left = 301
      Top = 63
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 40
      Width = 82
    end
    object edOperDateEnd: TcxDateEdit
      Left = 385
      Top = 63
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 41
      Width = 82
    end
    object edPartner: TcxButtonEdit
      Left = 833
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 42
      Text = ' '
      Width = 168
    end
    object edRetail: TcxButtonEdit
      Left = 606
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 43
      Width = 222
    end
    object cxLabel23: TcxLabel
      Left = 8
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 8
      Top = 103
      TabOrder = 45
      Width = 208
    end
    object cxLabel21: TcxLabel
      Left = 833
      Top = 86
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
    end
    object cxLabel22: TcxLabel
      Left = 606
      Top = 85
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
    end
    object cxLabel24: TcxLabel
      Left = 222
      Top = 85
      Caption = #1057#1090#1072#1090#1091#1089' ('#1086#1073#1084#1077#1085' '#1089' '#1042#1052#1057')'
    end
    object ceStatus_wms: TcxButtonEdit
      Left = 222
      Top = 103
      Hint = #1057#1090#1072#1090#1091#1089' ('#1086#1073#1084#1077#1085' '#1089' '#1042#1052#1057')promo'
      ParentShowHint = False
      Properties.Buttons = <
        item
          Action = ChangeGuidesStatuswms1
          Kind = bkGlyph
        end
        item
          Action = ChangeGuidesStatuswms2
          Kind = bkGlyph
        end
        item
          Action = ChangeGuidesStatuswms3
          Default = True
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 49
      Width = 161
    end
    object cbIsRemains: TcxCheckBox
      Left = 829
      Top = 70
      Caption = #1056#1077#1079#1077#1088#1074' '#1089#1092#1086#1088#1084'. ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 50
      Width = 141
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 267
    Top = 280
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 96
    Top = 176
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 270
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
        end>
      RefreshOnTabSetChanges = True
    end
    object actPrintSort: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1077#1089#1091' )'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1077#1089#1091' )'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;AmountSort;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderExternal'
      ReportNameParam.Value = 'PrintMovement_OrderExternal'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderExternal'
      ReportNameParam.Value = 'PrintMovement_OrderExternal'
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
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object actGoodsKindChoice: TOpenChoiceForm [14]
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
    object actRefreshPrice: TdsdDataSetRefresh [19]
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
    object actSPSavePrintState: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSavePrintState
      StoredProcList = <
        item
          StoredProc = spSavePrintState
        end>
      Caption = 'actSPSavePrintState'
    end
    object mactPrint_Order: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
    end
    object MultiAmountRemain: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountRemains
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>'
      ImageIndex = 47
    end
    object actUpdateAmountRemains: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountRemains
      StoredProcList = <
        item
          StoredProc = spUpdateAmountRemains
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082
      ImageIndex = 47
    end
    object actUpdateAmountPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountPartner
      StoredProcList = <
        item
          StoredProc = spUpdateAmountPartner
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
      ImageIndex = 48
    end
    object MultiAmountPartner: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountPartner
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 48
    end
    object actUpdateAmountForecast: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountForecast
      StoredProcList = <
        item
          StoredProc = spUpdateAmountForecast
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1075#1085#1086#1079
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1075#1085#1086#1079
      ImageIndex = 49
    end
    object MultiAmountForecast: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountForecast
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>'
      ImageIndex = 49
    end
    object macUpdateMIChild_Amount: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_Amount
        end
        item
          Action = actRefreshMIChild
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object actUpdateMIChild_Amount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_Amount
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_Amount
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object macUpdateMIChild_AmountSecond: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_AmountSecond
        end
        item
          Action = actRefreshMIChild
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 69
    end
    object actUpdateMIChild_AmountSecond: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_AmountSecond
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_AmountSecond
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 69
    end
    object actRefreshMIChild: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshMI: TdsdDataSetRefresh
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
    object actUpdateAmountAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountRemains
        end
        item
          Action = actUpdateAmountPartner
        end
        item
          Action = actUpdateAmountForecast
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077'?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 50
    end
    object mactUpdateFromOrder: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertFromOrder
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      ImageIndex = 59
    end
    object actInsertFromOrder: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertFromOrder
      StoredProcList = <
        item
          StoredProc = spInsertFromOrder
        end>
      Caption = 'actInsertFromOrder'
      Hint = 'aaInsertFromOrder'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object ChangeGuidesStatuswms1: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Status_wms
      StoredProcList = <
        item
          StoredProc = spUpdate_Status_wms
        end
        item
        end>
      Caption = 'CompleteMovement'
      ImageIndex = 12
      Status = mtComplete
      Guides = GuidesStatus_wms
    end
    object ChangeGuidesStatuswms2: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Status_wms
      StoredProcList = <
        item
          StoredProc = spUpdate_Status_wms
        end
        item
        end>
      Caption = 'UnCompleteMovement'
      ImageIndex = 11
      Status = mtUncomplete
      Guides = GuidesStatus_wms
    end
    object ChangeGuidesStatuswms3: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Status_wms
      StoredProcList = <
        item
          StoredProc = spUpdate_Status_wms
        end>
      Caption = 'DeleteMovement'
      ImageIndex = 13
      Status = mtDelete
      Guides = GuidesStatus_wms
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43466d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43466d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
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
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintCell: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1084#1077#1089#1090#1072#1084' '#1086#1090#1073#1086#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderExternal_Cell'
      ReportNameParam.Value = 'PrintMovement_OrderExternal_Cell'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenFormOrderExternalChild: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 24
      FormName = 'TOrderExternalChildForm'
      FormNameParam.Value = 'TOrderExternalChildForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 312
  end
  inherited MasterCDS: TClientDataSet
    Left = 72
    Top = 320
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderExternalUnit'
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
        Name = 'inPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
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
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 72
    Top = 271
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
          ItemName = 'bbUpdateFromOrder'
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
          ItemName = 'bbUpdateAmountAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountRemains'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountPartner'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountForecast'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIChild_Amount'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIChild_AmountSecond'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormOrderExternalChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbPrint: TdxBarButton
      Action = mactPrint_Order
    end
    object bbUpdateAmountRemains: TdxBarButton
      Action = MultiAmountRemain
      Category = 0
    end
    object bbUpdateAmountPartner: TdxBarButton
      Action = MultiAmountPartner
      Category = 0
    end
    object bbUpdateAmountForecast: TdxBarButton
      Action = MultiAmountForecast
      Category = 0
    end
    object bbUpdateAmountAll: TdxBarButton
      Action = actUpdateAmountAll
      Category = 0
    end
    object bbUpdateFromOrder: TdxBarButton
      Action = mactUpdateFromOrder
      Category = 0
    end
    object bbUpdateMIChild_Amount: TdxBarButton
      Action = macUpdateMIChild_Amount
      Category = 0
    end
    object bbUpdateMIChild_AmountSecond: TdxBarButton
      Action = macUpdateMIChild_AmountSecond
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbOpenFormOrderExternalChild: TdxBarButton
      Action = actOpenFormOrderExternalChild
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074#1072' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
      Category = 0
    end
    object bbPrintSort: TdxBarButton
      Action = actPrintSort
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintSort'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintCell'
        end>
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrintCell: TdxBarButton
      Action = actPrintCell
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnAddOnList = <
      item
        Column = GoodsCode
        FindByFullValue = True
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <
      item
        Column = GoodsCode
      end
      item
        Column = GoodsName
      end
      item
        Column = Amount
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
    Left = 558
    Top = 273
  end
  inherited PopupMenu: TPopupMenu
    Left = 40
    Top = 184
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
        Name = 'ReportNameOrderExternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = True
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 336
  end
  inherited StatusGuides: TdsdGuides
    Left = 64
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderExternal'
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
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusName'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Top = 24
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderExternal'
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
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateMark'
        Value = 0d
        Component = edOperDateMark
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberOrder
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId_OrderUnit'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName_OrderUnit'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId_OrderUnit'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName_OrderUnit'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId_OrderUnit'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName_OrderUnit'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCount'
        Value = Null
        Component = edDayCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = Null
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = 0
        Component = PartnerGuides
        ComponentItem = 'PartnerId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode_wms'
        Value = Null
        Component = GuidesStatus_wms
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName_wms'
        Value = Null
        Component = GuidesStatus_wms
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsRemains'
        Value = Null
        Component = cbIsRemains
        DataType = ftBoolean
        ParamType = ptResult
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderExternalUnit '
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
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberOrder
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
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateMark'
        Value = 0d
        Component = edOperDateMark
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDayCount'
        Value = Null
        Component = edDayCount
        DataType = ftFloat
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
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 296
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 144
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberOrder
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
        Control = edOperDateMark
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edRoute
      end
      item
        Control = edRouteSorting
      end
      item
        Control = edContract
      end
      item
        Control = edPaidKind
      end
      item
        Control = edPriceList
      end
      item
        Control = edChangePercent
      end
      item
        Control = edVATPercent
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = cbPrinted
      end
      item
        Control = edOperDateMark
      end
      item
        Control = edMember
      end
      item
        Control = edPartner
      end
      item
        Control = edRetail
      end
      item
        Control = edOperDateStart
      end
      item
        Control = edOperDateEnd
      end
      item
        Control = ceComment
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 616
    Top = 248
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetErased'
    Left = 654
    Top = 304
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetUnErased'
    Left = 590
    Top = 344
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderExternal'
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
        Name = 'inAmountSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 328
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderExternal'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inAmountSecond'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 428
    Top = 244
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
        Component = GuidesFrom
      end
      item
        Component = PriceListGuides
      end
      item
        Component = PartnerGuides
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 532
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 604
    Top = 190
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 356
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderExternal_Print'
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
      end
      item
        Name = 'inIsJuridical'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 295
    Top = 232
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 776
    Top = 96
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 624
    Top = 8
  end
  object GuidesRouteSorting: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1048
    Top = 104
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
      end
      item
        Name = 'RouteId'
        Value = Null
        Component = GuidesRoute
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = Null
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = Null
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = Null
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 336
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 552
    Top = 48
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMemberPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 514
    Top = 99
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 900
    Top = 4
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 531
    Top = 65532
  end
  object ContractTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 739
    Top = 65532
  end
  object spSavePrintState: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_Print'
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
      end
      item
        Name = 'inNewPrinted'
        Value = Null
        Component = FormParams
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = True
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 280
  end
  object spUpdateAmountRemains: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderExternal_AmountRemains'
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
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
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
      end>
    PackSize = 1
    Left = 450
    Top = 208
  end
  object spUpdateAmountPartner: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderExternal_AmountPartner'
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
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 176
  end
  object spUpdateAmountForecast: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderExternal_AmountForecast'
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
        Name = 'inStartDate'
        Value = 0d
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 192
  end
  object PartnerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = 'False'
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = 0.000000000000000000
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 892
    Top = 100
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 732
    Top = 52
  end
  object spInsertFromOrder: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_OrderExternalUnit'
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
      end>
    PackSize = 1
    Left = 434
    Top = 304
  end
  object spUpdate_Status_wms: TdsdStoredProc
    StoredProcName = 'gpUpdate_OrderExternal_Status_wms'
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
        Name = 'inStatusCode_wms'
        Value = ''
        Component = GuidesStatus_wms
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 96
  end
  object GuidesStatus_wms: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus_wms
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 320
    Top = 88
  end
  object spUpdateMIChild_Amount: TdsdStoredProc
    StoredProcName = 'gpUpdateMIChild_OrderExternal_Amount'
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
      end>
    PackSize = 1
    Left = 714
    Top = 200
  end
  object spUpdateMIChild_AmountSecond: TdsdStoredProc
    StoredProcName = 'gpUpdateMIChild_OrderExternal_AmountSecond'
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
      end>
    PackSize = 1
    Left = 810
    Top = 200
  end
end
