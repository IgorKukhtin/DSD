object WeighingPartner_ActDiffForm: TWeighingPartner_ActDiffForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
  ClientHeight = 440
  ClientWidth = 1112
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1112
    Height = 129
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 175
      Top = 22
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 89
    end
    object cxLabel1: TcxLabel
      Left = 175
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 270
      Top = 22
      EditValue = 42184d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 88
    end
    object cxLabel2: TcxLabel
      Left = 270
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 367
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 216
    end
    object cxLabel3: TcxLabel
      Left = 367
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object cxLabel5: TcxLabel
      Left = 114
      Top = 5
      Caption = #8470' '#1074#1079#1074#1077#1096'.'
    end
    object cxLabel6: TcxLabel
      Left = 369
      Top = 45
      Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'.'
    end
    object edStartWeighing: TcxDateEdit
      Left = 367
      Top = 63
      EditValue = 42184d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 105
    end
    object cxLabel11: TcxLabel
      Left = 8
      Top = 45
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 63
      Properties.Buttons = <
        item
          Action = CompleteMovement
          Kind = bkGlyph
        end
        item
          Action = UnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = DeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 160
    end
    object cxLabel9: TcxLabel
      Left = 478
      Top = 45
      Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
    end
    object edEndWeighing: TcxDateEdit
      Left = 478
      Top = 63
      EditValue = 42184d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 105
    end
    object cxLabel10: TcxLabel
      Left = 589
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 589
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 148
    end
    object cxLabel15: TcxLabel
      Left = 9
      Top = 5
      Caption = #8470' '#1076#1086#1082'. '#1086#1089#1085#1086#1074#1072#1085#1080#1077
    end
    object cxLabel16: TcxLabel
      Left = 589
      Top = 45
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContract: TcxButtonEdit
      Left = 589
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 17
      Width = 148
    end
    object cxLabel17: TcxLabel
      Left = 589
      Top = 84
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object edWeighingNumber: TcxCurrencyEdit
      Left = 115
      Top = 22
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 54
    end
    object edContractTag: TcxButtonEdit
      Left = 589
      Top = 102
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 148
    end
    object cxLabel24: TcxLabel
      Left = 9
      Top = 84
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 9
      Top = 102
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 349
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 175
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 89
    end
    object cxLabel26: TcxLabel
      Left = 175
      Top = 45
      Caption = #8470' '#1076#1086#1082'. '#1087#1086#1089#1090#1072#1074#1097'.'
    end
    object cbDocPartner: TcxCheckBox
      Left = 405
      Top = 102
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 25
      Width = 141
    end
    object cxLabel25: TcxLabel
      Left = 270
      Top = 45
      Caption = #1044#1072#1090#1072' '#1076#1086#1082' '#1091' '#1082#1086#1085#1090#1088'.'
    end
    object edOperDatePartner: TcxDateEdit
      Left = 270
      Top = 63
      Hint = #1044#1072#1090#1072' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      EditValue = 42184d
      ParentShowHint = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ShowHint = True
      TabOrder = 27
      Width = 88
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 155
    Width = 1112
    Height = 285
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 285
    ClientRectRight = 1112
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1112
        Height = 261
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerWVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerNoVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummWVAT_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNoVAT_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_income_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerWVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_income
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerNoVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummWVAT_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNoVAT_income
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_income_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_diff
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
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
          object Ord: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object AmountPartnerSecond: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'AmountPartnerSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object PricePartnerNoVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090'. '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'PricePartnerNoVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object PricePartnerWVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090'. '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PricePartnerWVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object SummPartnerNoVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1090'. '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'SummPartnerNoVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object SummPartnerWVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1090'. '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SummPartnerWVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object Amount_income: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount_income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object PriceNoVAT_Income: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'PriceNoVAT_Income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object PriceWVat_Income: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'PriceWVat_Income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object SummNoVAT_income: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummNoVAT_income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 75
          end
          object SummWVAT_income: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummWVAT_income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 75
          end
          object ChangePercentAmount: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'ChangePercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object Amount_income_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090'. '#1089#1086' '#1089#1082#1080#1076'.'
            DataBinding.FieldName = 'Amount_income_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1055#1086#1089#1090#1072#1074#1096#1080#1082' '#1089' '#1091#1095#1077#1090#1086#1084' % '#1089#1082#1080#1076#1082#1080' '#1082#1086#1083'-'#1074#1086
            Options.Editing = False
            Width = 80
          end
          object isReason_2: TcxGridDBColumn
            Caption = #1079#1072' '#1050#1072#1095'.'
            DataBinding.FieldName = 'isReason_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1079#1072' '#1085#1077#1089#1086#1086#1090#1074#1077#1089#1090#1074#1077#1090#1089#1090#1074#1080#1077' '#1082#1072#1095#1077#1089#1090#1074#1091
            Width = 50
          end
          object isReason_1: TcxGridDBColumn
            Caption = #1079#1072' '#1058#1077#1084#1087'.'
            DataBinding.FieldName = 'isReason_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1079#1072' '#1085#1077#1089#1086#1086#1090#1074#1077#1089#1090#1074#1077#1090#1089#1090#1074#1080#1077' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1099
            Width = 50
          end
          object ReasonName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ReasonName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartner_income: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090'. '
            DataBinding.FieldName = 'AmountPartner_income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object Amount_diff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1077
            DataBinding.FieldName = 'Amount_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1077
            Options.Editing = False
            Width = 82
          end
          object Price_diff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1094#1077#1085#1077' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1094#1077#1085#1077' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object Summ_diff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085#1080#1094#1099' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Summ_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object isAmountPartnerSecond: TcxGridDBColumn
            Caption = #1041#1077#1079' '#1086#1087#1083#1072#1090#1099' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isAmountPartnerSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1079#1085#1072#1082' '#1041#1077#1079' '#1086#1087#1083#1072#1090#1099' ('#1076#1072'/'#1085#1077#1090')'
            Width = 66
          end
          object isReturnOut: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isReturnOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1079#1085#1072#1082' '#1042#1086#1079#1074#1088#1072#1090' ('#1076#1072'/'#1085#1077#1090')'
            Width = 66
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
  end
  object edInvNumberOrder: TcxButtonEdit
    Left = 9
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 102
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
        Name = 'FormName'
        Value = 'TWeighingPartnerEditForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 150
    Top = 303
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_WeighingPartner_diff'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
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
        Value = Null
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
    PackSize = 1
    Left = 233
    Top = 287
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 22
    Top = 231
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertDiffEdit'
        end
        item
          Visible = True
          ItemName = 'bbActDiffEdit'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbCompletePrint'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_DiffPartner'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byPartner'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintDiff'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_AllPartner'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actUpdateDocument
      Category = 0
    end
    object bbUpdatePersonalComlete: TdxBarButton
      Action = macUpdatePersonalComlete
      Category = 0
    end
    object bbActDiffEdit: TdxBarButton
      Action = actActDiffEdit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbPrint_byPartner: TdxBarButton
      Action = actPrint_byPartner
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end>
    end
    object bbPrintDiff: TdxBarButton
      Action = actPrintDiff
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbPrint_DiffPartner: TdxBarButton
      Action = actPrint_DiffPartner
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbPrint_AllPartner: TdxBarButton
      Action = actPrint_AllPartner
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1086' '#8470' '#1087#1086#1089#1090#1072#1074#1097'.)'
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbCompletePrint: TdxBarButton
      Action = mactCompletePrint
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbInsertDiffEdit: TdxBarButton
      Action = actInsertDiffEdit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 81
    Top = 232
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 231
    object actInsertDiffEdit: TdsdInsertUpdateAction
      Category = 'Edit'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 0
      FormName = 'TWeighingPartner_ActDiffEditForm'
      FormNameParam.Value = 'TWeighingPartner_ActDiffEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_check'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actPrint_DiffPartner: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_diffPartner
      StoredProcList = <
        item
          StoredProc = spSelectPrint_diffPartner
        end
        item
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1072#1084
      Hint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1072#1084
      ImageIndex = 16
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
          Name = 'isAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingPartner'
      ReportNameParam.Value = 'PrintMovement_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actPrintDiff_noPrew: TdsdPrintAction
      Category = 'Complete'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrint_Act
      StoredProcList = <
        item
          StoredProc = spPrint_Act
        end>
      Caption = #1040#1082#1090' '#1056#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      Hint = #1040#1082#1090' '#1056#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'PrintMovement_Income_wp_ActDiff'
      ReportNameParam.Value = 'PrintMovement_Income_wp_ActDiff'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actPrint_byPartneк_noPrew: TdsdPrintAction
      Category = 'Complete'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_byPartnerl
      StoredProcList = <
        item
          StoredProc = spSelectPrint_byPartnerl
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1055#1088#1080#1093#1086#1076' ('#1080#1090#1086#1075#1086')'
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1055#1088#1080#1093#1086#1076' ('#1080#1090#1086#1075#1086')'
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'PrintMovement_Income'
      ReportNameParam.Value = 'PrintMovement_Income'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actPrint_AllPartner: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_allPartner
      StoredProcList = <
        item
          StoredProc = spSelectPrint_allPartner
        end
        item
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 21
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
          Name = 'isAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingPartner'
      ReportNameParam.Value = 'PrintMovement_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI
      StoredProcList = <
        item
          StoredProc = spUpdateMI
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actCompleteMovement_: TChangeGuidesStatus
      Category = 'Complete'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = GuidesStatus
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = GuidesStatus
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = GuidesStatus
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
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
          Component = MasterCDS
          ComponentItem = 'Id'
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
    object actUpdateDocument: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TWeighingPartnerEditForm'
      FormNameParam.Value = 'TWeighingPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object ExecuteDialogPersonalComlete: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 55
      FormName = 'TWeighingPartnerDialogForm'
      FormNameParam.Value = 'TWeighingPartnerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPersonalId1'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName1'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalName1'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId2'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName2'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalName2'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId3'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName3'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalName3'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId4'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId4'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName4'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalName4'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId5'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId5'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName5'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalName5'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId1'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionId1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName1'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionName1'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId2'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionId2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName2'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionName2'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId3'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionId3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName3'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionName3'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId4'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionId4'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName4'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionName4'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId5'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionId5'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName5'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionName5'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId1_Stick'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId1_Stick'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName1_Stick'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalName1_Stick'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId1_Stick'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionId1_Stick'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName1_Stick'
          Value = Null
          Component = FormParams
          ComponentItem = 'PositionName1_Stick'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdatePersonalComlete: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_PersonalComlete
      StoredProcList = <
        item
          StoredProc = spUpdate_PersonalComlete
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 55
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdatePersonalComlete: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPersonalComlete
        end
        item
          Action = actUpdatePersonalComlete
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 55
    end
    object actPrintDiff: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrint_Act
      StoredProcList = <
        item
          StoredProc = spPrint_Act
        end>
      Caption = #1040#1082#1090' '#1056#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      Hint = #1040#1082#1090' '#1056#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'PrintMovement_Income_wp_ActDiff'
      ReportNameParam.Value = 'PrintMovement_Income_wp_ActDiff'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actActDiffEdit: TdsdInsertUpdateAction
      Category = 'Edit'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 1
      FormName = 'TWeighingPartner_ActDiffEditForm'
      FormNameParam.Value = 'TWeighingPartner_ActDiffEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_check'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id_check'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = False
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actPrint_byPartner: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_byPartnerl
      StoredProcList = <
        item
          StoredProc = spSelectPrint_byPartnerl
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1055#1088#1080#1093#1086#1076' ('#1080#1090#1086#1075#1086')'
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1055#1088#1080#1093#1086#1076' ('#1080#1090#1086#1075#1086')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = 'PrintMovement_Income'
      ReportNameParam.Value = 'PrintMovement_Income'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_all: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <
        item
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 21
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
          Name = 'isAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingPartner'
      ReportNameParam.Value = 'PrintMovement_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actComplete_del: TdsdChangeMovementStatus
      Category = 'Complete'
      MoveParams = <>
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
    end
    object mactCompletePrint: TMultiAction
      Category = 'Complete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end
        item
          Action = actPrint_byPartneк_noPrew
        end
        item
          Action = actContinueAction
        end
        item
          Action = actPrintDiff_noPrew
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080
      ImageIndex = 12
    end
    object actContinueAction: TdsdContinueAction
      Category = 'Complete'
      MoveParams = <>
      Caption = 'actContinueAction'
      Continue.Value = False
      Continue.Component = FormParams
      Continue.ComponentItem = 'IsPrintAct'
      Continue.DataType = ftBoolean
      Continue.MultiSelectSeparator = ','
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'Complete'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spStutusComplete
      StoredProcList = <
        item
          StoredProc = spStutusComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = 'dsdExecStoredProc1'
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 54
    Top = 311
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 303
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 464
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    DisableGuidesOpen = True
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
    Left = 752
    Top = 112
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 672
    Top = 208
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 331
    Top = 273
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 694
    Top = 271
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edStartWeighing
      end
      item
      end
      item
        Control = edFrom
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    GetStoredProc = spGet
    Left = 320
    Top = 217
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WeighingPartner_diff'
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
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = GuidesStatus
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = GuidesStatus
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = OrderChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = ''
        Component = OrderChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeighingNumber'
        Value = 0.000000000000000000
        Component = edWeighingNumber
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
        Name = 'StartWeighing'
        Value = 0d
        Component = edStartWeighing
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndWeighing'
        Value = 0d
        Component = edEndWeighing
        DataType = ftDateTime
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
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
        Name = 'isDocPartner'
        Value = Null
        Component = cbDocPartner
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiff'
        Value = Null
        Component = FormParams
        ComponentItem = 'IsPrintAct'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 240
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 406
    Top = 242
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
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
      end>
    Left = 144
    Top = 200
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
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
    Left = 630
    Top = 224
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
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
    Left = 798
    Top = 328
  end
  object GuidesStatus: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 135
    Top = 58
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_WeighingPartner_diff'
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
        Name = 'inStatusCode'
        Value = ''
        Component = GuidesStatus
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 52
    Top = 74
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 696
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    DisableGuidesOpen = True
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 824
    Top = 120
  end
  object GuidesContractTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    DisableGuidesOpen = True
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 811
    Top = 52
  end
  object spUpdateMI: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_WeighingPartner_diff'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inId_check'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id_check'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_WeighingPartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_WeighingPartner'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'ChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReason_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReason_1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReason_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReason_2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAmountPartnerSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPartnerSecond'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReturnOut'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReturnOut'
        DataType = ftBoolean
        ParamType = ptInput
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
      end>
    PackSize = 1
    Left = 425
    Top = 304
  end
  object OrderChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TOrderExternal_SendOnPriceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternal_SendOnPriceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = OrderChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = OrderChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 260
    Top = 232
  end
  object spUpdate_PersonalComlete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Scale_Movement_PersonalComlete'
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
        Name = 'inPersonalId1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId1_Stick'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId1_Stick'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId1_Stick'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId1_Stick'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1058
    Top = 240
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    DisableGuidesOpen = True
    FormNameParam.Value = 'TDocumentKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 486
    Top = 200
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 796
    Top = 273
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 796
    Top = 230
  end
  object spSelectPrint_byPartnerl: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Print_byPartner'
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
    Left = 888
    Top = 240
  end
  object spPrint_Act: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner_Print_Act'
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
    Left = 880
    Top = 288
  end
  object spSelectPrint_allPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner_Print'
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
        Name = 'inisShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 967
    Top = 312
  end
  object spSelectPrint_diffPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner_Print'
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
        Name = 'inIsShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1015
    Top = 312
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_WeighingPartner'
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
    Left = 208
    Top = 352
  end
  object spStutusComplete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_WeighingPartner_diff'
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
        Name = 'inStatusCode'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 548
    Top = 306
  end
end
