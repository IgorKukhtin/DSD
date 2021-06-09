inherited Report_GoodsRemains_byPackForm: TReport_GoodsRemains_byPackForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1082#1080' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080'>'
  ClientHeight = 405
  ClientWidth = 1058
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1074
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1058
    Height = 325
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1058
    ExplicitHeight = 325
    ClientRectBottom = 325
    ClientRectRight = 1058
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1058
      ExplicitHeight = 325
      inherited cxGrid: TcxGrid
        Width = 1058
        Height = 325
        ExplicitWidth = 1058
        ExplicitHeight = 325
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_dop
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_pack_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_dop_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_sale_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_pack_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_calc_Weight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_dop
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_pack_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIn_dop_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_sale_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOut_pack_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_calc_Weight
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 138
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1075#1083'.)'
            DataBinding.FieldName = 'GoodsCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsName_basis: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1075#1083'.)'
            DataBinding.FieldName = 'GoodsName_basis'
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
            Width = 35
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 151
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RemainsStart: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'RemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RemainsEnd: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'RemainsEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RemainsStart_Weight: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1086#1089#1090'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'RemainsStart_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object RemainsEnd_Weight: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085'. '#1086#1089#1090'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'RemainsEnd_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object CountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'CountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 70
          end
          object CountIn_pack: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093' '#1091#1087#1072#1082
            DataBinding.FieldName = 'CountIn_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093' '#1091#1087#1072#1082
            Options.Editing = False
            Width = 70
          end
          object CountIn_dop: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1076#1088#1091#1075#1086#1081
            DataBinding.FieldName = 'CountIn_dop'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1076#1088#1091#1075#1086#1081
            Options.Editing = False
            Width = 70
          end
          object CountOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'CountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 70
          end
          object CountOut_sale: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' ('#1088#1077#1072#1083#1080#1079'.)'
            DataBinding.FieldName = 'CountOut_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' ('#1088#1077#1072#1083#1080#1079'.+'#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077')'
            Options.Editing = False
            Width = 70
          end
          object CountOut_pack: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1074' '#1094#1077#1093' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'CountOut_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1074' '#1094#1077#1093' '#1091#1087#1072#1082'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerPrior: TcxGridDBColumn
            Caption = #1053#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartnerPrior'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountIn_Weight: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1055#1088#1080#1093#1086#1076' ('#1074#1077#1089')'
            DataBinding.FieldName = 'CountIn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' ('#1074#1077#1089')'
            Options.Editing = False
            Width = 112
          end
          object CountIn_pack_Weight: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093' '#1091#1087#1072#1082' ('#1074#1077#1089')'
            DataBinding.FieldName = 'CountIn_pack_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093' '#1091#1087#1072#1082' ('#1074#1077#1089')'
            Options.Editing = False
            Width = 70
          end
          object CountIn_dop_Weight: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1076#1088#1091#1075#1086#1081' ('#1074#1077#1089')'
            DataBinding.FieldName = 'CountIn_dop_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1076#1088#1091#1075#1086#1081' ('#1074#1077#1089')'
            Options.Editing = False
            Width = 70
          end
          object CountOut_Weight: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1056#1072#1089#1093#1086#1076' ('#1074#1077#1089')'
            DataBinding.FieldName = 'CountOut_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' ('#1074#1077#1089')'
            Options.Editing = False
            Width = 101
          end
          object CountOut_sale_Weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' ('#1088#1077#1072#1083#1080#1079'.) ('#1074#1077#1089')'
            DataBinding.FieldName = 'CountOut_sale_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' ('#1088#1077#1072#1083#1080#1079'.+'#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077') ('#1074#1077#1089')'
            Options.Editing = False
            Width = 70
          end
          object CountOut_pack_Weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1074' '#1094#1077#1093' '#1091#1087#1072#1082'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'CountOut_pack_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1074' '#1094#1077#1093' '#1091#1087#1072#1082'. ('#1074#1077#1089')'
            Options.Editing = False
            Width = 70
          end
          object AmountPartner_Weight: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1072' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountPartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object AmountPartnerPrior_Weight: TcxGridDBColumn
            Caption = #1053#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountPartnerPrior_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RemainsEnd_calc: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085'. '#1086#1089#1090'. ('#1088#1072#1089#1095#1077#1090'.)'
            DataBinding.FieldName = 'RemainsEnd_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1085'. '#1086#1089#1090#1072#1090#1086#1082' '#1079#1072' '#1084#1080#1085#1091#1089#1086#1084' '#1079#1072#1103#1074#1086#1082
            Width = 70
          end
          object RemainsEnd_calc_Weight: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085'. '#1086#1089#1090'. ('#1088#1072#1089#1095#1077#1090'.) ('#1074#1077#1089')'
            DataBinding.FieldName = 'RemainsEnd_calc_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1085'. '#1086#1089#1090#1072#1090#1086#1082' '#1079#1072' '#1084#1080#1085#1091#1089#1086#1084' '#1079#1072#1103#1074#1086#1082' ('#1074#1077#1089')'
            Width = 95
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1058
    Height = 54
    ExplicitWidth = 1058
    ExplicitHeight = 54
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
    object cxLabel3: TcxLabel
      Left = 224
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 314
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 210
    end
    object cxLabel5: TcxLabel
      Left = 222
      Top = 30
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 314
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 210
    end
    object cxLabel7: TcxLabel
      Left = 536
      Top = 31
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 576
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 192
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
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actRefreshDataPersonalGroup: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshData: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1076#1072#1090#1072#1084
      Hint = #1087#1086' '#1076#1072#1090#1072#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshMov: TdsdDataSetRefresh [2]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 41640d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 41640d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1054#1089#1090#1072#1090#1082#1080' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      Hint = #1054#1090#1095#1077#1090' '#1054#1089#1090#1072#1090#1082#1080' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName_basis;OperDate;GoodsName;GoodsKindN' +
            'ame'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
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
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1054#1089#1090#1072#1090#1082#1080' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1054#1089#1090#1072#1090#1082#1080' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintByGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 41640d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 41640d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103', '#1087#1086' '#1090#1086#1074#1072#1088#1091')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103', '#1087#1086' '#1090#1086#1074#1072#1088#1091')'
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'PartnerName;GoodsGroupName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportType'
          Value = '3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsRemains_byPackDialogForm'
      FormNameParam.Value = 'TReport_GoodsRemains_byPackDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
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
          Name = 'GoodsGroupId'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
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
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsRemains_byPack'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
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
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 160
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      Visible = ivNever
    end
    object bbPrintByGoods: TdxBarButton
      Action = actPrintByGoods
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 104
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 208
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inDescId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InDescName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
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
    Left = 352
    Top = 65528
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 8
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 3
  end
end
