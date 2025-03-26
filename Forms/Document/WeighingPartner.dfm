object WeighingPartnerForm: TWeighingPartnerForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')>'
  ClientHeight = 462
  ClientWidth = 1366
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
    Width = 1366
    Height = 129
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 175
      Top = 22
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 80
    end
    object cxLabel1: TcxLabel
      Left = 175
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 262
      Top = 22
      EditValue = 42184d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 96
    end
    object cxLabel2: TcxLabel
      Left = 262
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 365
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 216
    end
    object edTo: TcxButtonEdit
      Left = 588
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 264
    end
    object cxLabel3: TcxLabel
      Left = 365
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object cxLabel4: TcxLabel
      Left = 588
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object cxLabel5: TcxLabel
      Left = 114
      Top = 5
      Caption = #8470' '#1074#1079#1074#1077#1096'.'
    end
    object cxLabel6: TcxLabel
      Left = 365
      Top = 45
      Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'.'
    end
    object edStartWeighing: TcxDateEdit
      Left = 365
      Top = 63
      EditValue = 42184d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 4
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
      TabOrder = 12
      Width = 160
    end
    object cxLabel9: TcxLabel
      Left = 476
      Top = 45
      Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
    end
    object edEndWeighing: TcxDateEdit
      Left = 476
      Top = 63
      EditValue = 42184d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 105
    end
    object cxLabel8: TcxLabel
      Left = 859
      Top = 4
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
    end
    object edUser: TcxButtonEdit
      Left = 984
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 118
    end
    object cxLabel10: TcxLabel
      Left = 588
      Top = 45
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 588
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 69
    end
    object edOperDate_parent: TcxDateEdit
      Left = 262
      Top = 63
      EditValue = 42184d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 19
      Width = 96
    end
    object cxLabel12: TcxLabel
      Left = 262
      Top = 45
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085')'
    end
    object edInvNumber_parent: TcxTextEdit
      Left = 175
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 80
    end
    object cxLabel14: TcxLabel
      Left = 175
      Top = 45
      Caption = #8470' '#1076#1086#1082'.('#1075#1083#1072#1074#1085')'
    end
    object cxLabel15: TcxLabel
      Left = 9
      Top = 5
      Caption = #8470' '#1076#1086#1082'. '#1086#1089#1085#1086#1074#1072#1085#1080#1077
    end
    object cxLabel16: TcxLabel
      Left = 670
      Top = 45
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContract: TcxButtonEdit
      Left = 660
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 25
      Width = 92
    end
    object cxLabel17: TcxLabel
      Left = 761
      Top = 45
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object cxLabel18: TcxLabel
      Left = 859
      Top = 45
      Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
    end
    object edPartionGoods: TcxTextEdit
      Left = 859
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 28
      Width = 118
    end
    object edWeighingNumber: TcxCurrencyEdit
      Left = 115
      Top = 22
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      TabOrder = 29
      Width = 54
    end
    object edContractTag: TcxButtonEdit
      Left = 755
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 30
      Width = 97
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 1161
      Top = 5
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 85
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 984
      Top = 63
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 32
      Width = 171
    end
    object cxLabel20: TcxLabel
      Left = 1115
      Top = 4
      Caption = '% '#1053#1044#1057
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 1115
      Top = 22
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 34
      Width = 40
    end
    object cxLabel22: TcxLabel
      Left = 1161
      Top = 45
      Caption = #8470' '#1073#1088#1080#1075#1072#1076#1099
    end
    object edPersonalGroup: TcxButtonEdit
      Left = 1161
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 36
      Width = 94
    end
    object cxLabel23: TcxLabel
      Left = 262
      Top = 84
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object ed: TcxButtonEdit
      Left = 262
      Top = 99
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 38
      Width = 208
    end
    object cxLabel24: TcxLabel
      Left = 476
      Top = 84
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 476
      Top = 99
      Properties.ReadOnly = True
      TabOrder = 40
      Width = 276
    end
    object cbisList: TcxCheckBox
      Left = 756
      Top = 99
      Hint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      Caption = #1048#1085#1074#1077#1085#1090'. '#1076#1083#1103' '#1089#1087#1080#1089#1082#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 41
      Width = 125
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 175
      Top = 99
      Properties.ReadOnly = True
      TabOrder = 42
      Width = 80
    end
    object cxLabel26: TcxLabel
      Left = 175
      Top = 84
      Caption = #8470' '#1076#1086#1082'.'#1091' '#1082#1086#1085#1090#1088'.'
    end
    object cbDocPartner: TcxCheckBox
      Left = 883
      Top = 99
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090'.'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 44
      Width = 104
    end
    object cbReason1: TcxCheckBox
      Left = 1058
      Top = 99
      Caption = #1057#1082'. '#1087#1086' '#1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1077
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 45
      Width = 129
    end
    object cbReason2: TcxCheckBox
      Left = 1188
      Top = 99
      Caption = #1057#1082'. '#1087#1086' '#1050#1072#1095#1077#1089#1090#1074#1091
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 46
      Width = 112
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 155
    Width = 1366
    Height = 307
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 307
    ClientRectRight = 1366
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1366
        Height = 283
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
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UpdateDate
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCount_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LevelNumber
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UpdateDate
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCount_mi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LevelNumber
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
          object PartionNum: TcxGridDBColumn
            Caption = #8470' '#1055#1072#1089#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'PartionNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isBarCode: TcxGridDBColumn
            Caption = #1057#1082#1072#1085
            DataBinding.FieldName = 'isBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object isAmountPartnerSecond: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' "'#1073#1077#1079' '#1086#1087#1083#1072#1090#1099'"'
            DataBinding.FieldName = 'isAmountPartnerSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1079#1085#1072#1082' "'#1073#1077#1079' '#1086#1087#1083#1072#1090#1099'" ('#1076#1072' / '#1085#1077#1090')'
            Options.Editing = False
            Width = 66
          end
          object isPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 63
          end
          object isReturnOut: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isReturnOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1086#1079#1074#1088#1072#1090' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 63
          end
          object PriceRetOutDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1094#1077#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090'.)'
            DataBinding.FieldName = 'PriceRetOutDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1083#1103' '#1094#1077#1085#1099' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 75
          end
          object RealWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080' '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
            DataBinding.FieldName = 'CountTare'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object WeightTare: TcxGridDBColumn
            Caption = #1042#1077#1089' 1 '#1090#1072#1088#1099
            DataBinding.FieldName = 'WeightTare'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object CountTare1: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'1'
            DataBinding.FieldName = 'CountTare1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'1'
            Width = 70
          end
          object WeightTare1: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'1'
            DataBinding.FieldName = 'WeightTare1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1086#1076#1085#1086#1075#1086' '#1103#1097'. '#1074#1080#1076#1072'1'
            Width = 55
          end
          object CountTare2: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'2'
            DataBinding.FieldName = 'CountTare2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'2'
            Width = 70
          end
          object WeightTare2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'2'
            DataBinding.FieldName = 'WeightTare2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1086#1076#1085#1086#1075#1086' '#1103#1097'. '#1074#1080#1076#1072'2'
            Width = 55
          end
          object CountTare3: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'3'
            DataBinding.FieldName = 'CountTare3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'3'
            Width = 70
          end
          object WeightTare3: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'3'
            DataBinding.FieldName = 'WeightTare3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1086#1076#1085#1086#1075#1086' '#1103#1097'. '#1074#1080#1076#1072'3'
            Width = 55
          end
          object CountTare4: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'4'
            DataBinding.FieldName = 'CountTare4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'4'
            Width = 70
          end
          object WeightTare4: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'4'
            DataBinding.FieldName = 'WeightTare4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1086#1076#1085#1086#1075#1086' '#1103#1097'. '#1074#1080#1076#1072'4'
            Width = 55
          end
          object CountTare5: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'5'
            DataBinding.FieldName = 'CountTare5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'5'
            Width = 70
          end
          object WeightTare5: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'5'
            DataBinding.FieldName = 'WeightTare5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1086#1076#1085#1086#1075#1086' '#1103#1097'. '#1074#1080#1076#1072'5'
            Width = 55
          end
          object CountTare6: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'6'
            DataBinding.FieldName = 'CountTare6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'6'
            Width = 70
          end
          object WeightTare6: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'6'
            DataBinding.FieldName = 'WeightTare6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1086#1076#1085#1086#1075#1086' '#1103#1097'. '#1074#1080#1076#1072'6'
            Width = 55
          end
          object CountPack: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'CountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object WeightPack: TcxGridDBColumn
            Caption = #1042#1077#1089'  1-'#1086#1081' '#1091#1087'.'
            DataBinding.FieldName = 'WeightPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_mi: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'Amount_mi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ChangePercentAmount: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089
            DataBinding.FieldName = 'ChangePercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerSecond: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'AmountPartnerSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountChangePercent: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'AmountChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPartner_mi: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'AmountPartner_mi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PricePartner: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PricePartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object SummPartner: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'SummPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Count: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076#1080#1085#1080#1094
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Count_mi: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076#1080#1085#1080#1094' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'Count_mi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object HeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074' ('#1086#1073#1074'.)'
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object HeadCount_mi: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074' ('#1086#1073#1074'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'HeadCount_mi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object LevelNumber: TcxGridDBColumn
            Caption = #8470' '#1089#1083#1086#1103
            DataBinding.FieldName = 'LevelNumber'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object BoxNumber: TcxGridDBColumn
            Caption = #8470' '#1103#1097#1080#1082#1072
            DataBinding.FieldName = 'BoxNumber'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object BoxCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1092'. '#1103#1097'.'
            DataBinding.FieldName = 'BoxCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object BoxCount_mi: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1092'. '#1103#1097'. ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'BoxCount_mi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object BoxName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1075#1086#1092'. '#1103#1097'.'
            DataBinding.FieldName = 'BoxName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PriceListName: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089
            DataBinding.FieldName = 'PriceListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ReasonName_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' / '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            DataBinding.FieldName = 'ReasonName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PricePromo: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'PricePromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementPromo: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'MovementPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
          object StartBegin: TcxGridDBColumn
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'StartBegin'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object EndBegin: TcxGridDBColumn
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
            DataBinding.FieldName = 'EndBegin'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object diffBegin_sec: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082'.'
            DataBinding.FieldName = 'diffBegin_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082#1091#1085#1076' '#1087#1088#1080' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1080' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object AssetName: TcxGridDBColumn
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1054#1057'-1'
            DataBinding.FieldName = 'AssetName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080'-1'
            Options.Editing = False
            Width = 80
          end
          object AssetName_two: TcxGridDBColumn
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1054#1057'-2'
            DataBinding.FieldName = 'AssetName_two'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080'-2'
            Options.Editing = False
            Width = 80
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
  end
  object cxLabel19: TcxLabel
    Left = 984
    Top = 45
    Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
  end
  object cbPromo: TcxCheckBox
    Left = 1161
    Top = 24
    Caption = #1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 100
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
    TabOrder = 5
    Width = 104
  end
  object cxLabel13: TcxLabel
    Left = 1261
    Top = 5
    Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edMovementDescName: TcxButtonEdit
    Left = 1261
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 98
  end
  object cxLabel7: TcxLabel
    Left = 1261
    Top = 45
    Caption = #1050#1086#1076' '#1086#1087#1077#1088'.('#1074#1079#1074#1077#1096'.)'
  end
  object edMovementDescNumber: TcxTextEdit
    Left = 1261
    Top = 63
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 98
  end
  object cxLabel21: TcxLabel
    Left = 984
    Top = 4
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  end
  object edMember: TcxButtonEdit
    Left = 859
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 118
  end
  object cxLabel25: TcxLabel
    Left = 67
    Top = 84
    Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088'.'
  end
  object edOperDatePartner: TcxDateEdit
    Left = 67
    Top = 99
    Hint = #1044#1072#1090#1072' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
    EditValue = 42184d
    ParentShowHint = False
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    ShowHint = True
    TabOrder = 13
    Width = 102
  end
  object cxLabel27: TcxLabel
    Left = 987
    Top = 84
    Caption = '% '#1089#1082'. '#1074' '#1082#1086#1083'.'
  end
  object edChangePercentAmount: TcxCurrencyEdit
    Left = 988
    Top = 99
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 64
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
    Left = 262
    Top = 375
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_WeighingPartner'
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
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
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
    Left = 264
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBox'
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
          ItemName = 'bbUpdatePersonalComlete'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbactWeighingPartner_ActDiffF'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
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
      Caption = '     '
      Category = 0
      Visible = ivAlways
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
    object bbactWeighingPartner_ActDiffF: TdxBarButton
      Action = actWeighingPartner_ActDiffF
      Category = 0
    end
    object bbPrint_diff: TdxBarButton
      Action = actPrint_diff
      Category = 0
    end
    object bbPrint_all: TdxBarButton
      Action = actPrint_all
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_diff'
        end
        item
          Visible = True
          ItemName = 'bbPrint_all'
        end
        item
          Visible = True
          ItemName = 'bbSelectMIPrintPassport'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end>
    end
    object bbPrintAction1: TdxBarButton
      Action = dsdPrintAction1
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbSelectMIPrintPassport: TdxBarButton
      Action = actSelectMIPrintPassport
      Category = 0
    end
    object bbUpdateBox: TdxBarButton
      Action = macUpdateBox
      Category = 0
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
    object dsdPrintAction1: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_allPartner
      StoredProcList = <
        item
          StoredProc = spSelectPrint_allPartner
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#8470' '#1087#1086#1089#1090'.)'
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#8470' '#1087#1086#1089#1090'.)'
      ImageIndex = 17
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
    object actRefreshMI: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
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
          Component = dsdGuidesFrom
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
      Guides = StatusGuides
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
      Guides = StatusGuides
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
      Guides = StatusGuides
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
    object actWeighingPartner_ActDiffF: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      ImageIndex = 43
      FormName = 'TWeighingPartner_ActDiffForm'
      FormNameParam.Value = 'TWeighingPartner_ActDiffForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSelectMIPrintPassport: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMIPrintPassport
      StoredProcList = <
        item
          StoredProc = spSelectMIPrintPassport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.Value = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macUpdateBox: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateBox
        end
        item
          Action = actRefreshMI
        end
        item
          Action = actSelectMIPrintPassport
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      ImageIndex = 69
    end
    object actPrint_all: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_all
      StoredProcList = <
        item
          StoredProc = spSelectPrint_all
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 17
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
    object actPrint_diff: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_diff
      StoredProcList = <
        item
          StoredProc = spSelectPrint_diff
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 20
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
          Value = 'false'
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
    object actUpdateBox: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      ImageIndex = 69
      FormName = 'TWeighingProductionBoxEditForm'
      FormNameParam.Value = 'TWeighingProductionBoxEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'RealWeight'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RealWeight'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
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
  object dsdGuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 8
  end
  object dsdGuidesTo: TdsdGuides
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
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 776
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 720
    Top = 256
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
    Left = 347
    Top = 337
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 806
    Top = 263
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
        Control = edTo
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
    Left = 296
    Top = 217
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WeighingPartner'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        Name = 'InvNumber_parent'
        Value = ''
        Component = edInvNumber_parent
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
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_parent'
        Value = 0d
        Component = edOperDate_parent
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
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
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
        Value = ''
        Component = ContractTagGuides
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
        Name = 'UserId'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionGoods'
        Value = Null
        Component = edPartionGoods
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementDescName'
        Value = Null
        Component = MovementDescGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementDescNumber'
        Value = Null
        Component = edMovementDescNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId1'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalName1'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId1'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionName1'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId2'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalName2'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId2'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionName2'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId3'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalName3'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId3'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionName31'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId4'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalName4'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId4'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionName4'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId55'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId5'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalName5'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId5'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionName5'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId1_Stick'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId1_Stick'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName1_Stick'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalName1_Stick'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId1_Stick'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId1_Stick'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName1_Stick'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionName1_Stick'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocName'
        Value = Null
        Component = GuidesSubjectDoc
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
        Name = 'isList'
        Value = Null
        Component = cbisList
        DataType = ftBoolean
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
        Name = 'isDocPartner'
        Value = Null
        Component = cbDocPartner
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercentAmount'
        Value = Null
        Component = edChangePercentAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReason1'
        Value = Null
        Component = cbReason1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReason2'
        Value = Null
        Component = cbReason1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 224
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 422
    Top = 306
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = dsdGuidesFrom
      end
      item
        Guides = dsdGuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 144
    Top = 200
  end
  object ChangeStatus: TChangeStatus
    KeyField = 'Code'
    LookupControl = ceStatus
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProcName = 'gpUpdate_Status_WeighingPartner'
    Left = 109
    Top = 32
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
    Left = 638
    Top = 288
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 23
    Top = 2
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_WeighingPartner'
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
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 68
    Top = 18
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUser_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUser_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1040
    Top = 8
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 616
    Top = 56
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
    Left = 688
    Top = 56
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
    Left = 771
    Top = 44
  end
  object spUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_WeighingPartner'
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
        Name = 'inWeighingNumber'
        Value = '0'
        Component = edWeighingNumber
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 433
    Top = 256
  end
  object HeaderSaver2: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateMovement
    ControlList = <
      item
        Control = edWeighingNumber
      end>
    GetStoredProc = spGet
    Left = 368
    Top = 217
  end
  object OrderChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
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
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerName'
        Value = ''
        Component = dsdGuidesTo
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
    Left = 68
    Top = 65528
  end
  object HeaderSaver3: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateMovement_Order
    ControlList = <
      item
        Control = edInvNumberOrder
      end>
    GetStoredProc = spGet
    Left = 432
    Top = 209
  end
  object spUpdateMovement_Order: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_WeighingPartner_Order'
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
        Name = 'inInvNumberOrder'
        Value = Null
        Component = OrderChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Order'
        Value = 0.000000000000000000
        Component = OrderChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 529
    Top = 248
  end
  object MovementDescGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMovementDescName
    FormNameParam.Value = 'TMovementDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMovementDescForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MovementDescGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MovementDescGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1280
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
    Left = 913
    Top = 3
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
    Left = 1018
    Top = 240
  end
  object GuidesPersonalGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalGroup
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1128
    Top = 16
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = ed
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
    Left = 366
    Top = 64
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1188
    Top = 257
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1188
    Top = 286
  end
  object spSelectPrint_diff: TdsdStoredProc
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1127
    Top = 256
  end
  object spSelectPrint_all: TdsdStoredProc
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
    Left = 1103
    Top = 312
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
    Left = 999
    Top = 336
  end
  object spSelectMIPrintPassport: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_WeighingProduction_PrintPassport'
    DataSet = PrintItemsCDS
    DataSets = <
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 831
    Top = 336
  end
end
