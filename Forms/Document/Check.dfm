inherited CheckForm: TCheckForm
  Caption = #1050#1072#1089#1089#1086#1074#1099#1081' '#1095#1077#1082
  ClientHeight = 600
  ClientWidth = 810
  ExplicitWidth = 828
  ExplicitHeight = 647
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 265
    Width = 810
    Height = 215
    ExplicitTop = 265
    ExplicitWidth = 810
    ExplicitHeight = 215
    ClientRectBottom = 215
    ClientRectRight = 810
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 810
      ExplicitHeight = 191
      inherited cxGrid: TcxGrid
        Width = 810
        Height = 191
        ExplicitWidth = 810
        ExplicitHeight = 191
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colName
            end
            item
              Format = ',0.000'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSale
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object colIntenalSPName: TcxGridDBColumn [2]
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
          object colChangePercent: TcxGridDBColumn [3]
            Caption = '% c'#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colAmount: TcxGridDBColumn [4]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colAmountOrder: TcxGridDBColumn [5]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colPrice: TcxGridDBColumn [6]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colPriceSale: TcxGridDBColumn [7]
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colSummChangePercent: TcxGridDBColumn [8]
            Caption = #1057#1091#1084#1084#1072' '#1057#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object List_UID: TcxGridDBColumn [9]
            Caption = 'UID '#1101#1083#1077#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'List_UID'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colSumm: TcxGridDBColumn [10]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colSummSale: TcxGridDBColumn [11]
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'SummSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colisSp: TcxGridDBColumn [12]
            Caption = #1059#1095'. '#1074' '#1057#1055
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1077
            Options.Editing = False
            Width = 60
          end
          object PartionDateKindName: TcxGridDBColumn [13]
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colNDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object colDiscountExternalName: TcxGridDBColumn
            Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
            DataBinding.FieldName = 'DiscountExternalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object colDivisionPartiesName: TcxGridDBColumn
            Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1081
            DataBinding.FieldName = 'DivisionPartiesName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1081' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 146
          end
          object colisPresent: TcxGridDBColumn
            Caption = #1055#1086#1076#1072#1088#1086#1082
            DataBinding.FieldName = 'isPresent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colColor_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            VisibleForCustomization = False
          end
          object CommentCheckName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
            DataBinding.FieldName = 'CommentCheckName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 810
    Height = 235
    ExplicitWidth = 810
    ExplicitHeight = 235
    inherited edInvNumber: TcxTextEdit
      Left = 7
      Top = 14
      Text = 'edInvNumber'
      ExplicitLeft = 7
      ExplicitTop = 14
      ExplicitWidth = 142
      Width = 142
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      Top = -1
      ExplicitLeft = 7
      ExplicitTop = -1
    end
    inherited edOperDate: TcxDateEdit
      Left = 155
      Top = 14
      EditValue = 42261d
      Properties.ReadOnly = True
      ExplicitLeft = 155
      ExplicitTop = 14
      ExplicitWidth = 90
      Width = 90
    end
    inherited cxLabel2: TcxLabel
      Left = 155
      Top = -1
      ExplicitLeft = 155
      ExplicitTop = -1
    end
    inherited cxLabel15: TcxLabel
      Top = 33
      ExplicitTop = 33
    end
    inherited ceStatus: TcxButtonEdit
      Top = 48
      PopupMenu = nil
      ExplicitTop = 48
      ExplicitWidth = 141
      ExplicitHeight = 22
      Width = 141
    end
    object edCashRegisterName: TcxTextEdit
      Left = 586
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 81
    end
    object cxLabel3: TcxLabel
      Left = 251
      Top = -1
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel4: TcxLabel
      Left = 464
      Top = -1
      Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
    end
    object cxLabel5: TcxLabel
      Left = 586
      Top = -1
      Caption = #1050#1072#1089#1089#1072
    end
    object edPaidTypeName: TcxTextEdit
      Left = 464
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 121
    end
    object lblCashMember: TcxLabel
      Left = 251
      Top = 32
      Caption = #1052#1077#1085#1077#1076#1078#1077#1088
    end
    object edCashMember: TcxTextEdit
      Left = 251
      Top = 48
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 212
    end
    object lblBayer: TcxLabel
      Left = 8
      Top = 71
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object edBayer: TcxTextEdit
      Left = 8
      Top = 87
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 237
    end
    object cxLabel6: TcxLabel
      Left = 723
      Top = -1
      Caption = #8470' '#1092#1080#1089#1082'. '#1095#1077#1082#1072
    end
    object edFiscalCheckNumber: TcxTextEdit
      Left = 723
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 78
    end
    object chbNotMCS: TcxCheckBox
      Left = 155
      Top = 68
      Caption = #1053#1077' '#1076#1083#1103' '#1053#1058#1047
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 82
    end
    object cxLabel7: TcxLabel
      Left = 464
      Top = 33
      Caption = #8470' '#1082#1072#1088#1090#1099
    end
    object edDiscountCard: TcxTextEdit
      Left = 464
      Top = 48
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 121
    end
    object edManualDiscount: TcxTextEdit
      Left = 732
      Top = 87
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 69
    end
    object cxLabel20: TcxLabel
      Left = 732
      Top = 71
      Caption = #1056#1091#1095'. '#1089#1082#1080#1076#1082#1072
    end
    object cxLabel21: TcxLabel
      Left = 708
      Top = 33
      Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1099
    end
    object edTotalSummPayAdd: TcxTextEdit
      Left = 708
      Top = 48
      Properties.Alignment.Horz = taRightJustify
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 93
    end
    object cxLabel22: TcxLabel
      Left = 8
      Top = 110
      Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object edMemberSP: TcxButtonEdit
      Left = 8
      Top = 125
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 25
      Width = 237
    end
    object cxLabel23: TcxLabel
      Left = 251
      Top = 110
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094'-'#1090#1072
    end
    object edGroupMemberSP: TcxButtonEdit
      Left = 251
      Top = 125
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 95
    end
    object cxLabel24: TcxLabel
      Left = 350
      Top = 110
      Caption = #1053#1086#1084#1077#1088'/'#1089#1077#1088#1080#1103' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1087#1072#1094'-'#1090#1072
    end
    object cxLabel25: TcxLabel
      Left = 508
      Top = 110
      Caption = #1048#1053#1053' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object edPassport: TcxTextEdit
      Left = 350
      Top = 125
      Properties.ReadOnly = True
      TabOrder = 30
      Width = 155
    end
    object edInn: TcxTextEdit
      Left = 508
      Top = 125
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 92
    end
    object cxLabel26: TcxLabel
      Left = 603
      Top = 110
      Caption = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object edAddress: TcxTextEdit
      Left = 603
      Top = 125
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 198
    end
    object cbSite: TcxCheckBox
      Left = 102
      Top = 68
      Hint = #1095#1077#1088#1077#1079' '#1089#1072#1081#1090
      Caption = #1089#1072#1081#1090
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 34
      Width = 47
    end
    object edBankPOSTerminal: TcxButtonEdit
      Left = 7
      Top = 194
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 35
      Width = 177
    end
    object cxLabel27: TcxLabel
      Left = 7
      Top = 179
      Caption = 'POS '#1090#1077#1088#1084#1080#1085#1072#1083
    end
    object edJackdawsChecks: TcxButtonEdit
      Left = 190
      Top = 194
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 37
      Width = 186
    end
    object cxLabel28: TcxLabel
      Left = 190
      Top = 179
      Caption = #1058#1080#1087' '#1075#1072#1083#1082#1080
    end
    object cbDelay: TcxCheckBox
      Left = 102
      Top = 107
      Hint = 
        #1063#1077#1082' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1091#1076#1072#1083#1077#1085' '#1087#1086' '#1080#1089#1090#1077#1095#1077#1085#1080#1080' 2 '#1076#1085#1077#1081', '#1076#1083#1103' '#1089#1072#1081#1090#1072' 2 '#1076#1085#1103' '#1087#1086 +
        #1089#1083#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
      Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1081' VIP '#1095#1077#1082
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 39
      Width = 143
    end
    object edLoyaltySMDiscount: TcxTextEdit
      Left = 603
      Top = 194
      Properties.ReadOnly = True
      TabOrder = 40
      Width = 94
    end
    object cxLabel30: TcxLabel
      Left = 603
      Top = 178
      Caption = #1055#1088'. '#1085#1072#1082'. '#1089#1082#1080#1076#1082#1072
    end
    object edLoyaltySMSumma: TcxTextEdit
      Left = 700
      Top = 194
      Properties.ReadOnly = True
      TabOrder = 42
      Width = 101
    end
    object cxLabel31: TcxLabel
      Left = 700
      Top = 178
      Caption = #1055#1088'. '#1085#1072#1082'. '#1085#1072#1082#1086#1087#1083#1077#1085
    end
    object cbCorrectMarketing: TcxCheckBox
      Left = 8
      Top = 213
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1089#1091#1084#1084#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072' '#1074' '#1047#1055' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Caption = #1050#1086#1088'-'#1082#1072' '#1089#1091#1084#1084#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 44
      Width = 161
    end
    object cbCorrectIlliquidMarketing: TcxCheckBox
      Left = 164
      Top = 213
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1089#1091#1084#1084#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072' '#1074' '#1047#1055' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Caption = #1085#1077#1083#1080#1082#1074#1080#1076#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 45
      Width = 263
    end
    object cbDoctors: TcxCheckBox
      Left = 312
      Top = 213
      Hint = #1042#1088#1072#1095#1080
      Caption = #1042#1088#1072#1095#1080
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 46
      Width = 61
    end
    object cbDiscountCommit: TcxCheckBox
      Left = 368
      Top = 213
      Hint = #1042#1088#1072#1095#1080
      Caption = #1044#1080#1089#1082#1086#1085#1090' '#1087#1088#1086#1074'. '#1085#1072' '#1089#1072#1081#1090#1077
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 47
      Width = 151
    end
    object edZReport: TcxTextEdit
      Left = 667
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 48
      Width = 55
    end
    object cxLabel32: TcxLabel
      Left = 667
      Top = -1
      Caption = 'Z '#1086#1090#1095#1077#1090
    end
    object cbOffsetVIP: TcxCheckBox
      Left = 516
      Top = 213
      Hint = #1042#1088#1072#1095#1080
      Caption = #1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 50
      Width = 94
    end
    object cbErrorRRO: TcxCheckBox
      Left = 603
      Top = 213
      Hint = #1042#1088#1072#1095#1080
      Caption = #1054#1096#1080#1073#1082#1072' '#1056#1056#1054
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 51
      Width = 94
    end
    object cbConfirmByPhone: TcxCheckBox
      Left = 693
      Top = 213
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1090#1077#1083#1077#1092#1086#1085#1085#1099#1084' '#1079#1074#1086#1085#1082#1086#1084
      Caption = #1055#1086#1076#1090'. '#1090#1077#1083' '#1079#1074#1086#1085#1082#1086#1084
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 52
      Width = 108
    end
  end
  object edInvNumberOrder: TcxTextEdit [2]
    Left = 155
    Top = 48
    Properties.ReadOnly = True
    TabOrder = 6
    Text = 'edInvNumberOrder'
    Width = 90
  end
  object cxLabel9: TcxLabel [3]
    Left = 155
    Top = 33
    Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
  end
  object cxLabel10: TcxLabel [4]
    Left = 251
    Top = 70
    Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' ('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
  end
  object edBayerPhone: TcxTextEdit [5]
    Left = 251
    Top = 87
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 212
  end
  object cxLabel8: TcxLabel [6]
    Left = 464
    Top = 71
    Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
  end
  object edConfirmedKind: TcxTextEdit [7]
    Left = 464
    Top = 87
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1057#1086#1089#1090#1086#1103#1085#1080#1077' VIP-'#1095#1077#1082#1072')'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 136
  end
  object edConfirmedKindClient: TcxTextEdit [8]
    Left = 603
    Top = 87
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 128
  end
  object cxLabel11: TcxLabel [9]
    Left = 602
    Top = 71
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
    Caption = #1057#1090#1072#1090#1091#1089' '#1057#1052#1057'/'#1047#1074#1086#1085#1086#1082
  end
  object cxLabel12: TcxLabel [10]
    Left = 8
    Top = 144
    Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077'('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
  end
  object edPartnerMedical: TcxTextEdit [11]
    Left = 8
    Top = 160
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 237
  end
  object cxLabel13: TcxLabel [12]
    Left = 251
    Top = 145
    Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edOperDateSP: TcxDateEdit [13]
    Left = 251
    Top = 160
    EditValue = 42261d
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 90
  end
  object cxLabel14: TcxLabel [14]
    Left = 347
    Top = 144
    Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edInvNumberSP: TcxTextEdit [15]
    Left = 347
    Top = 160
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 116
  end
  object cxLabel16: TcxLabel [16]
    Left = 464
    Top = 144
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
  end
  object edMedicSP: TcxTextEdit [17]
    Left = 464
    Top = 160
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 123
  end
  object cxLabel17: TcxLabel [18]
    Left = 590
    Top = 144
    Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
  end
  object edAmbulance: TcxTextEdit [19]
    Left = 589
    Top = 160
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 93
  end
  object cxLabel18: TcxLabel [20]
    Left = 684
    Top = 144
    Caption = #1042#1080#1076' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
  end
  object edSPKind: TcxTextEdit [21]
    Left = 684
    Top = 160
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 117
  end
  object cxLabel19: TcxLabel [22]
    Left = 586
    Top = 33
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
    Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076' ('#1076#1086#1082'.)'
  end
  object edInvNumber_PromoCode_Full: TcxTextEdit [23]
    Left = 586
    Top = 48
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 121
  end
  object edUnitName: TcxButtonEdit [24]
    Left = 251
    Top = 14
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 212
  end
  object cxLabel29: TcxLabel [25]
    Left = 379
    Top = 179
    Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
  end
  object edPartionDateKind: TcxButtonEdit [26]
    Left = 379
    Top = 194
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 218
  end
  object cxGrid1: TcxGrid [27]
    Left = 0
    Top = 488
    Width = 810
    Height = 112
    Align = alBottom
    PopupMenu = PopupMenu
    TabOrder = 31
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DetailDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmount
        end
        item
          Format = ',0.####'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmount
        end
        item
          Format = ',0.####'
          Kind = skSum
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
      object chAmount: TcxGridDBColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
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
      object chisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object cxSplitter1: TcxSplitter [28]
    Left = 0
    Top = 480
    Width = 810
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 349
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 349
  end
  inherited ActionList: TActionList
    Top = 348
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
    end
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
      ShortCut = 0
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Enabled = False
      ShortCut = 0
    end
    inherited actShowErased: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actShowAll: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      Enabled = False
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus [8]
      Enabled = False
    end
    inherited actCompleteMovement: TChangeGuidesStatus [9]
      Enabled = False
    end
    inherited actDeleteMovement: TChangeGuidesStatus [10]
      Enabled = False
    end
    inherited actMovementItemContainer: TdsdOpenForm [11]
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm [12]
    end
    inherited MultiAction: TMultiAction [13]
      Enabled = False
    end
    inherited actNewDocument: TdsdInsertUpdateAction [14]
      Enabled = False
    end
    inherited actFormClose: TdsdFormClose [15]
    end
    inherited actAddMask: TdsdExecStoredProc [16]
      Enabled = False
    end
    object actShowMessage: TShowMessageAction [17]
      Category = 'DSDLib'
      MoveParams = <>
    end
    object ChoiceCashRegister: TOpenChoiceForm [18]
      Category = 'EditMovement'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ChoiceCashRegister'
      FormName = 'TCashRegisterForm'
      FormNameParam.Value = 'TCashRegisterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CashRegisterId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = edCashRegisterName
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PrintDialog: TExecuteDialog [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actCheckPrintDialog'
      ImageIndex = 3
      FormName = 'TCheckPrintDialogForm'
      FormNameParam.Value = 'TCheckPrintDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = edFiscalCheckNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = edBayer
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    inherited actPrint: TdsdPrintAction [20]
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
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091
      ReportNameParam.Value = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091
      ReportNameParam.ParamType = ptInput
    end
    object macPrint: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = PrintDialog
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 3
    end
    object ChoicePaidType: TOpenChoiceForm
      Category = 'EditMovement'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ChoiceCashRegister'
      FormName = 'TPaidTypeForm'
      FormNameParam.Value = 'TPaidTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PaidTypeId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = 'cxTextEdit3'
          Component = edPaidTypeName
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = FormParams
          ComponentItem = 'PaidTypeCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_Movement_Check: TdsdExecStoredProc
      Category = 'EditMovement'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
    end
    object actEditDocument: TMultiAction
      Category = 'EditMovement'
      MoveParams = <>
      ActionList = <
        item
          Action = ChoiceCashRegister
        end
        item
          Action = ChoicePaidType
        end
        item
          Action = actUpdate_Movement_Check
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1088#1086#1087#1080#1089#1072#1090#1100' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1080' '#1090#1080#1087' '#1086#1087#1083#1072#1090#1099
      Hint = #1055#1088#1086#1087#1080#1089#1072#1090#1100' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1080' '#1090#1080#1087' '#1086#1087#1083#1072#1090#1099
      ImageIndex = 43
    end
    object actUpdateOperDate: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdateMovement_OperDate
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_OperDate
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 24
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogUpdateOperDate: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 24
      FormName = 'TDataTimeDialogForm'
      FormNameParam.Value = 'TDataTimeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateOperDate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateOperDate
        end
        item
          Action = actUpdateOperDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 67
    end
    object actUpdateSpParam: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_SpParam
      StoredProcList = <
        item
          StoredProc = spUpdate_SpParam
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogSP: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      ImageIndex = 26
      FormName = 'TCheck_SPEditForm'
      FormNameParam.Value = 'TCheck_SPEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDateSp'
          Value = 42261d
          Component = edOperDateSP
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumberSP'
          Value = Null
          Component = edInvNumberSP
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMedicSPName'
          Value = Null
          Component = edMedicSP
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAmbulance'
          Value = Null
          Component = edAmbulance
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerMedicalName'
          Value = Null
          Component = edPartnerMedical
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerMedicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inPartnerMedicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inSPKindName'
          Value = Null
          Component = edSPKind
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InSPKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'InSPKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateSpParam: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogSP
        end
        item
          Action = actUpdateSpParam
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      ImageIndex = 26
    end
    object actUpdateUnit: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceUnitTreeForm
        end
        item
          Action = actExecStoredUpdateUnit
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ImageIndex = 8
    end
    object actChoiceUnitTreeForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceUnitTreeForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitID'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecStoredUpdateUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateUnit
      StoredProcList = <
        item
          StoredProc = spUpdateUnit
        end>
      Caption = 'actExecStoredUpdateUnit'
    end
    object macUpdateMemberSp: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateMemberSp
        end
        item
          Action = actExecStoredUpdateMemberSp
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1094#1080#1077#1085#1090#1072'?'
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1094#1080#1077#1085#1090#1072
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1094#1080#1077#1085#1090#1072
      ImageIndex = 8
    end
    object actExecStoredUpdateMemberSp: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMemberSP
      StoredProcList = <
        item
          StoredProc = spUpdateMemberSP
        end>
      Caption = 'actExecStoredUpdateUnit'
    end
    object actChoiceMemberSpForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceMemberSpForm'
      FormName = 'TMemberSPForm'
      FormNameParam.Value = 'TMemberSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ExecuteDialogUpdateMemberSp: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1094#1080#1077#1085#1090#1072
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1094#1080#1077#1085#1090#1072
      ImageIndex = 55
      FormName = 'TMemberSPChoiceDialogForm'
      FormNameParam.Value = 'TMemberSPChoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMemberSPId'
          Value = 42261d
          Component = FormParams
          ComponentItem = 'MemberSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerMedicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inPartnerMedicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerMedicalName'
          Value = Null
          Component = edPartnerMedical
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actBankPOSTerminal: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceBankPOSTerminal
        end
        item
          Action = actExecBankPOSTerminal
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' POS '#1090#1077#1088#1084#1080#1085#1072#1083
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' POS '#1090#1077#1088#1084#1080#1085#1072#1083
      ImageIndex = 42
    end
    object actChoiceBankPOSTerminal: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceBankPOSTerminal'
      FormName = 'TBankPOSTerminalForm'
      FormNameParam.Value = 'TBankPOSTerminalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'BankPOSTerminal'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecBankPOSTerminal: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateBankPOSTerminal
      StoredProcList = <
        item
          StoredProc = spUpdateBankPOSTerminal
        end>
      Caption = 'actExecBankPOSTerminal'
    end
    object actJackdawsChecks: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceJackdawsChecks
        end
        item
          Action = actExecJackdawsChecks
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1080#1087' '#1075#1072#1083#1082#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1080#1087' '#1075#1072#1083#1082#1080
      ImageIndex = 66
    end
    object actChoiceJackdawsChecks: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceJackdawsChecks'
      FormName = 'TJackdawsChecksForm'
      FormNameParam.Value = 'TJackdawsChecksForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'JackdawsChecks'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecJackdawsChecks: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateJackdawsChecks
      StoredProcList = <
        item
          StoredProc = spUpdateJackdawsChecks
        end>
      Caption = 'actExecJackdawsChecks'
    end
    object actReLinkContainer: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecReLinkContainer
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1082#1088#1077#1087#1080#1090#1100' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1082' '#1087#1072#1088#1090#1080#1103#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1055#1077#1088#1077#1082#1088#1077#1087#1080#1090#1100' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1082' '#1087#1072#1088#1090#1080#1103#1084
      Hint = #1055#1077#1088#1077#1082#1088#1077#1087#1080#1090#1100' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1082' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
    end
    object actExecReLinkContainer: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spReLinkContainer
      StoredProcList = <
        item
          StoredProc = spReLinkContainer
        end>
      Caption = 'actExecReLinkContainer'
    end
    object actUpdate_MovementIten_PartionDateKind: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = astChoicePartionDateKind
        end
        item
          Action = actExec_MovementIten_PartionDateKind
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1090#1080#1087#1072' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082' '#1091' '#1087#1086#1079#1080#1094#1080#1080' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1090#1080#1087#1072' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082' '#1091' '#1087#1086#1079#1080#1094#1080#1080' '#1095#1077#1082#1072
      ImageIndex = 35
    end
    object astChoicePartionDateKind: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'astChoicePartionDateKind'
      FormName = 'TPartionDateKindForm'
      FormNameParam.Value = 'TPartionDateKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExec_MovementIten_PartionDateKind: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PartionDateKind
      StoredProcList = <
        item
          StoredProc = spUpdate_PartionDateKind
        end>
      Caption = 'actExec_MovementIten_PartionDateKind'
    end
    object actPartionGoods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      ImageIndex = 28
      FormName = 'TPartionGoodsListForm'
      FormNameParam.Value = 'TPartionGoodsListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitID'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
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
        end>
      isShowModal = False
    end
    object actAddGoods: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGoodsChoice
        end
        item
          Action = actAmountDialog
        end
        item
          Action = actExecAddGoods
        end
        item
          Action = actRefresh
        end>
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1095#1077#1082
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1095#1077#1082
      ImageIndex = 54
    end
    object actGoodsChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsChoice'
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAmountDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAmountDialog'
      FormName = 'TAmountDialogForm'
      FormNameParam.Value = 'TAmountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = Null
          Component = FormParams
          ComponentItem = 'Amount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecAddGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spAddGoods
      StoredProcList = <
        item
          StoredProc = spAddGoods
        end>
      Caption = 'actExecAddGoods'
    end
    object actEditAmount: TMultiAction
      MoveParams = <>
      ActionList = <
        item
          Action = actAmountDialog
        end
        item
          Action = actExecEditAmount
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1074#1072#1088#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 45
    end
    object actExecEditAmount: TdsdExecStoredProc
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spEditAmount
      StoredProcList = <
        item
          StoredProc = spEditAmount
        end>
      Caption = 'actExecEditAmount'
    end
    object actUpdateNotMCS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = SPUpdate_NotMCS
      StoredProcList = <
        item
          StoredProc = SPUpdate_NotMCS
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1076#1083#1103' '#1053#1058#1047'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1076#1083#1103' '#1053#1058#1047'"'
      ImageIndex = 36
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1076#1083#1103' '#1053#1058#1047'"?'
    end
    object actSetPromoCodeDoctor: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoicePromoCodeDoctor
      PostDataSetBeforeExecute = False
      StoredProc = spSetPromoCode
      StoredProcList = <
        item
          StoredProc = spSetPromoCode
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1074#1088#1072#1095#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1074#1088#1072#1095#1072
      ImageIndex = 74
    end
    object actChoicePromoCodeDoctor: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePromoCodeDoctor'
      FormName = 'TPromoCodeDoctorForm'
      FormNameParam.Value = 'TPromoCodeDoctorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceNDSKind: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceNDSKind'
      FormName = 'TNDSKindForm'
      FormNameParam.Value = 'TNDSKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'NDSKindId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecspUpdateNDSKindId: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoiceNDSKind
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateNDSKindId
      StoredProcList = <
        item
          StoredProc = spUpdateNDSKindId
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1080#1076' '#1053#1044#1057' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1080#1076' '#1053#1044#1057' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      ImageIndex = 79
    end
    object actChoiceDivisionPartiesKind: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceDivisionPartiesKind'
      FormName = 'TDivisionPartiesForm'
      FormNameParam.Value = 'TDivisionPartiesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'DivisionPartiesId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecDivisionParties: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoiceDivisionPartiesKind
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateDivisionPartiesId
      StoredProcList = <
        item
          StoredProc = spUpdateDivisionPartiesId
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1080#1076' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' '#1087#1072#1088#1090#1080#1081' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1080#1076' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' '#1087#1072#1088#1090#1080#1081' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      ImageIndex = 76
    end
    object actPriceDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAmountDialog'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = Null
          Component = FormParams
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1094#1077#1085#1091' '#1090#1086#1074#1072#1088#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actSetPrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actPriceDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePrice
      StoredProcList = <
        item
          StoredProc = spUpdatePrice
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1094#1077#1085#1091' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1094#1077#1085#1091' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      ImageIndex = 75
    end
    object actUpdate_Doctors: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Doctors
      StoredProcList = <
        item
          StoredProc = spUpdate_Doctors
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1042#1088#1072#1095#1080'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1042#1088#1072#1095#1080'>'
      ImageIndex = 80
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1042#1088#1072#1095#1080'>?'
    end
    object actUpdate_ClearFiscal: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ClearFiscal
      StoredProcList = <
        item
          StoredProc = spUpdate_ClearFiscal
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077
      ImageIndex = 77
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077'?'
    end
    object actPriceSaleDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAmountDialog'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1094#1077#1085#1091' '#1090#1086#1074#1072#1088#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdatePriceSale: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actPriceSaleDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePriceSale
      StoredProcList = <
        item
          StoredProc = spUpdatePriceSale
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1094#1077#1085#1091' '#1073#1072#1079' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1094#1077#1085#1091' '#1073#1072#1079' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1089#1090#1088#1086#1095#1082#1077
      ImageIndex = 75
    end
    object actUpdate_OffsetVIP: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_OffsetVIP
      StoredProcList = <
        item
          StoredProc = spUpdate_OffsetVIP
        end>
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084'>'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084'>'
      ImageIndex = 7
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084'>?'
    end
    object actUpdate_MedicForSale: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoicespMedicForSale
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MedicForSale
      StoredProcList = <
        item
          StoredProc = spUpdate_MedicForSale
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1060#1048#1054' '#1074#1088#1072#1095#1072' ('#1085#1072' '#1087#1088#1086#1076#1072#1078#1091')"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1060#1048#1054' '#1074#1088#1072#1095#1072' ('#1085#1072' '#1087#1088#1086#1076#1072#1078#1091')"'
      ImageIndex = 8
    end
    object actChoicespMedicForSale: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicespMedicForSale'
      FormName = 'TMedicForSaleForm'
      FormNameParam.Value = 'TMedicForSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MedicForSaleId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_BuyerForSale: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoiceBuyerForSale
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_BuyerForSale
      StoredProcList = <
        item
          StoredProc = spUpdate_BuyerForSale
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1060#1048#1054' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1085#1072' '#1087#1088#1086#1076#1072#1078#1091')"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1060#1048#1054' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1085#1072' '#1087#1088#1086#1076#1072#1078#1091')"'
      ImageIndex = 8
    end
    object actChoiceBuyerForSale: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceBuyerForSale'
      FormName = 'TBuyerForSaleForm'
      FormNameParam.Value = 'TBuyerForSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BuyerForSaleId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actDateOffsetVIPDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDateOffsetVIPDialog'
      FormName = 'TDataChoiceDialogForm'
      FormNameParam.Value = 'TDataChoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'DateOffsetVIP'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080' '#1076#1072#1090#1091' '#1079#1072#1095#1077#1090#1072' '#1042#1048#1055' '#1084#1077#1085#1077#1076#1078#1077#1088#1072#1084' '#1095#1077#1082#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_SetOffsetVIP: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDateOffsetVIPDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SetOffsetVIP
      StoredProcList = <
        item
          StoredProc = spUpdate_SetOffsetVIP
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084'>'
      ImageIndex = 7
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084'>?'
    end
  end
  inherited MasterDS: TDataSource
    Top = 306
  end
  inherited MasterCDS: TClientDataSet
    Top = 306
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Check'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 306
  end
  inherited BarManager: TdxBarManager
    Top = 305
    DockControlHeights = (
      0
      0
      30
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateOperDate'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbPrint: TdxBarButton
      Action = macPrint
    end
    object dxBarButton1: TdxBarButton
      Action = actEditDocument
      Category = 0
    end
    object bbUpdateOperDate: TdxBarButton
      Action = macUpdateOperDate
      Category = 0
    end
    object bbUpdateSpParam: TdxBarButton
      Action = macUpdateSpParam
      Category = 0
    end
    object bbUpdateUnit: TdxBarButton
      Action = actUpdateUnit
      Category = 0
    end
    object bbUpdateMemberSp: TdxBarButton
      Action = macUpdateMemberSp
      Category = 0
      ImageIndex = 55
    end
    object dxBarButton2: TdxBarButton
      Action = actBankPOSTerminal
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actJackdawsChecks
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actReLinkContainer
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdate_MovementIten_PartionDateKind
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actPartionGoods
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actAddGoods
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actEditAmount
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actUpdateNotMCS
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actSetPromoCodeDoctor
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = actExecspUpdateNDSKindId
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = actExecDivisionParties
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = actSetPrice
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = actUpdate_Doctors
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = actUpdate_ClearFiscal
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = actUpdatePriceSale
      Category = 0
    end
    object dxBarButton19: TdxBarButton
      Action = actUpdate_OffsetVIP
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateUnit'
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
          ItemName = 'bbUpdateSpParam'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMemberSp'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton21'
        end
        item
          Visible = True
          ItemName = 'dxBarButton20'
        end
        item
          Visible = True
          ItemName = 'dxBarButton22'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton19'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object dxBarButton20: TdxBarButton
      Action = actUpdate_BuyerForSale
      Category = 0
    end
    object dxBarButton21: TdxBarButton
      Action = actUpdate_MedicForSale
      Category = 0
    end
    object dxBarButton22: TdxBarButton
      Action = actUpdate_SetOffsetVIP
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = colColor_calc
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    Top = 299
  end
  inherited PopupMenu: TPopupMenu
    Top = 349
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
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidTypeId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidTypeCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankPOSTerminal'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JackdawsChecks'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'DivisionPartiesId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormCaption'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicForSaleId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'BuyerForSaleId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateOffsetVIP'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 397
  end
  inherited StatusGuides: TdsdGuides
    Top = 306
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Check'
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
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 306
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check'
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
        Value = 42132d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterName'
        Value = Null
        Component = edCashRegisterName
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidTypeName'
        Value = 'cxTextEdit3'
        Component = edPaidTypeName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashMember'
        Value = Null
        Component = edCashMember
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Bayer'
        Value = Null
        Component = edBayer
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FiscalCheckNumber'
        Value = Null
        Component = edFiscalCheckNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NotMCS'
        Value = Null
        Component = chbNotMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSite'
        Value = Null
        Component = cbSite
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountCardName'
        Value = Null
        Component = edDiscountCard
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = Null
        Component = edBayerPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = 'edInvNumberOrder'
        Component = edInvNumberOrder
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedKindName'
        Value = Null
        Component = edConfirmedKind
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedKindClientName'
        Value = Null
        Component = edConfirmedKindClient
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        Component = edPartnerMedical
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateSP'
        Value = Null
        Component = edOperDateSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberSP'
        Value = Null
        Component = edInvNumberSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPName'
        Value = Null
        Component = edMedicSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Ambulance'
        Value = Null
        Component = edAmbulance
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPartnerMedicalId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SPKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inSPKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SPKindName'
        Value = Null
        Component = edSPKind
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_PromoCode_Full'
        Value = Null
        Component = edInvNumber_PromoCode_Full
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ManualDiscount'
        Value = Null
        Component = edManualDiscount
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPayAdd'
        Value = Null
        Component = edTotalSummPayAdd
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSPid'
        Value = Null
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSPName'
        Value = Null
        Component = GuidesMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPId'
        Value = Null
        Component = GuidesGroupMemberSP
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPName'
        Value = Null
        Component = GuidesGroupMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address_MemberSP'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN_MemberSP'
        Value = Null
        Component = edInn
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport_MemberSP'
        Value = Null
        Component = edPassport
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankPOSTerminalID'
        Value = Null
        Component = GuidesBankPOSTerminal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankPOSTerminalName'
        Value = Null
        Component = GuidesBankPOSTerminal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JackdawsChecksId'
        Value = Null
        Component = GuidesJackdawsChecks
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JackdawsChecksName'
        Value = Null
        Component = GuidesJackdawsChecks
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'Delay'
        Value = Null
        Component = cbDelay
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltySMDiscount'
        Value = Null
        Component = edLoyaltySMDiscount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltySMSumma'
        Value = Null
        Component = edLoyaltySMSumma
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCorrectMarketing'
        Value = Null
        Component = cbCorrectMarketing
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCorrectIlliquidMarketing'
        Value = Null
        Component = cbCorrectIlliquidMarketing
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDoctors'
        Value = Null
        Component = cbDoctors
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ZReport'
        Value = Null
        Component = edZReport
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOffsetVIP'
        Value = Null
        Component = cbOffsetVIP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isErrorRRO'
        Value = Null
        Component = cbErrorRRO
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Caption'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormCaption'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isConfirmByPhone'
        Value = Null
        Component = cbConfirmByPhone
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 397
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidTypeId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PaidTypeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashRegisterId'
        Value = ''
        Component = FormParams
        ComponentItem = 'CashRegisterId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 186
    Top = 357
  end
  inherited GuidesFiller: TGuidesFiller
    Top = 306
  end
  inherited HeaderSaver: THeaderSaver
    Left = 320
    Top = 398
  end
  inherited RefreshAddOn: TRefreshAddOn
    Top = 325
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Top = 346
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 406
    Top = 325
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    Left = 536
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 424
    Top = 357
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 500
    Top = 260
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check_Print'
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
    Left = 632
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 772
    Top = 361
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 764
    Top = 302
  end
  object spUpdateMovement_OperDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_OperDate'
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
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = 'edInvNumber'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 482
    Top = 424
  end
  object spUpdate_SpParam: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_SpParam'
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
        Name = 'inSPKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inSPKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPartnerMedicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateSP'
        Value = 42261d
        Component = edOperDateSP
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmbulance'
        Value = 'edInvNumber'
        Component = edAmbulance
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMedicSP'
        Value = Null
        Component = edMedicSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSP'
        Value = Null
        Component = edInvNumberSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 554
    Top = 336
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitName
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 352
    Top = 16
  end
  object spUpdateUnit: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_Unit'
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
        Name = 'inUnitId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 690
    Top = 328
  end
  object GuidesMemberSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberSP
    FormNameParam.Value = 'TMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = ''
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport'
        Value = ''
        Component = edPassport
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Inn'
        Value = ''
        Component = edInn
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 128
  end
  object GuidesGroupMemberSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGroupMemberSP
    FormNameParam.Value = 'TGroupMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGroupMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGroupMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGroupMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 112
  end
  object spUpdateMemberSP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_MemberSP'
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
        Name = 'inMemberSPId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MemberSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 698
    Top = 384
  end
  object GuidesBankPOSTerminal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankPOSTerminal
    FormNameParam.Value = 'TBankPOSTerminalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankPOSTerminalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankPOSTerminal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankPOSTerminal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 144
  end
  object spUpdateBankPOSTerminal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_BankPOSTerminal'
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
        Name = 'inBankPOSTerminalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'BankPOSTerminal'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 554
    Top = 384
  end
  object GuidesJackdawsChecks: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJackdawsChecks
    FormNameParam.Value = 'TJackdawsChecksForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJackdawsChecksForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJackdawsChecks
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJackdawsChecks
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 144
  end
  object spUpdateJackdawsChecks: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_JackdawsChecks'
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
        Name = 'inJackdawsChecksId'
        Value = Null
        Component = FormParams
        ComponentItem = 'JackdawsChecks'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 450
    Top = 144
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
    Left = 648
    Top = 112
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
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 318
    Top = 529
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 168
    Top = 544
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Check_Child'
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
  object spReLinkContainer: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Check_ReLinkContainer'
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
    Left = 690
    Top = 456
  end
  object spUpdate_PartionDateKind: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementIten_Check_PartionDateKind'
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
        Name = 'inMovementItemID'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionDateKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'PartionDateKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 370
    Top = 440
  end
  object spAddGoods: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Check_Goods'
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
        Name = 'inGoodsID'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 658
    Top = 177
  end
  object spEditAmount: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Check_AmountAdmin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
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
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 754
    Top = 177
  end
  object SPUpdate_NotMCS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check__NotMCS'
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
        Name = 'inisNotMCS'
        Value = Null
        Component = chbNotMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotMCS'
        Value = Null
        Component = chbNotMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 394
    Top = 256
  end
  object spSetPromoCode: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_SetPromoCode'
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
        Name = 'inPromoCodeId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'PromoCodeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 402
    Top = 400
  end
  object spUpdate_MovementIten_PartionDateKind: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementIten_Check_PartionDateKind'
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
        Name = 'inMovementItemID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionDateKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionDateKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 162
    Top = 464
  end
  object spUpdateNDSKindId: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Check_NDSKindId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
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
        Name = 'inNDSKindId'
        Value = 0c
        Component = FormParams
        ComponentItem = 'NDSKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 650
    Top = 281
  end
  object spUpdateDivisionPartiesId: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Check_DivisionPartiesId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
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
        Name = 'inDivisionPartiesId'
        Value = Null
        Component = FormParams
        ComponentItem = 'DivisionPartiesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 490
    Top = 329
  end
  object spUpdatePrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementIten_Check_Price'
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
        Name = 'inMovementItemID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = FormParams
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 170
    Top = 400
  end
  object spUpdate_Doctors: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_Doctors'
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
        Name = 'inisDoctors'
        Value = Null
        Component = cbDoctors
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDoctors'
        Value = Null
        Component = cbDoctors
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 258
    Top = 401
  end
  object spUpdate_ClearFiscal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_ClearFiscal'
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
    Left = 490
    Top = 472
  end
  object spUpdatePriceSale: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementIten_Check_PriceSale'
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
        Name = 'inMovementItemID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSale'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 50
    Top = 472
  end
  object spUpdate_OffsetVIP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_OffsetVIP'
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
        Name = 'inisOffsetVIP'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOffsetVIP'
        Value = False
        Component = cbOffsetVIP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 258
    Top = 441
  end
  object spUpdate_MedicForSale: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_MedicForSale'
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
        Name = 'inMedicForSaleId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MedicForSaleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 138
    Top = 264
  end
  object spUpdate_BuyerForSale: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_BuyerForSale'
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
        Name = 'inBuyerForSaleId'
        Value = Null
        Component = FormParams
        ComponentItem = 'BuyerForSaleId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 264
  end
  object spUpdate_SetOffsetVIP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_SetOffsetVIP'
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
        Name = 'inisOffsetVIP'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateOffsetVIP'
        Value = Null
        Component = FormParams
        ComponentItem = 'DateOffsetVIP'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOffsetVIP'
        Value = False
        Component = cbOffsetVIP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 234
    Top = 497
  end
end
