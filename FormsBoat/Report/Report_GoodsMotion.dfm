inherited Report_GoodsMotionForm: TReport_GoodsMotionForm
  Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084'>'
  ClientHeight = 341
  ClientWidth = 1189
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitLeft = 0
  ExplicitWidth = 1205
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1189
    Height = 261
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1071
    ExplicitHeight = 261
    ClientRectBottom = 261
    ClientRectRight = 1189
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 261
      inherited cxGrid: TcxGrid
        Width = 1189
        Height = 261
        ExplicitWidth = 1071
        ExplicitHeight = 261
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountEnd
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountEnd
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LocationDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1084#1077#1089#1090#1072' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'LocationDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object LocationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
            DataBinding.FieldName = 'LocationCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object LocationName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'LocationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsTagName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Article: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Article_all: TcxGridDBColumn
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_all'
            Visible = False
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object PartNumber: TcxGridDBColumn
            Caption = 'S/N'
            DataBinding.FieldName = 'PartNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Enabled = False
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1077#1088#1080#1081#1085#1099#1081' '#8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            Width = 100
          end
          object InvNumberFull_OrderClient: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumberFull_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1079#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object CIN_OrderClient: TcxGridDBColumn
            Caption = 'CIN Nr.'
            DataBinding.FieldName = 'CIN_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProductName_OrderClient: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object FromName_OrderClient: TcxGridDBColumn
            Caption = 'Kunden'
            DataBinding.FieldName = 'FromName_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 120
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsSizeName: TcxGridDBColumn
            Caption = 'Gr'#246#223'e'
            DataBinding.FieldName = 'GoodsSizeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ProdColorName: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1077#1090#1072#1083#1080
            DataBinding.FieldName = 'GoodsTypeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            Options.Editing = False
            Width = 70
          end
          object CostPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099
            DataBinding.FieldName = 'CostPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' '#1079#1072#1090#1088#1072#1090#1099
            Options.Editing = False
            Width = 70
          end
          object Summ_cost: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1079#1072#1090#1088#1072#1090#1099
            DataBinding.FieldName = 'Summ_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1079#1072#1090#1088#1072#1090' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 80
          end
          object AmountStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1085#1072#1095'. '#1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1085#1072' '#1085#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
          object SummStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'SummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'SummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountEnd: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Price_end: TcxGridDBColumn
            Caption = #1082#1086#1085#1077#1095'. '#1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'Price_end'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
          object SummEnd: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'SummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Price_partner_start: TcxGridDBColumn
            Caption = #1085#1072#1095'. '#1062#1077#1085#1072' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'Price_partner_start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1085#1072' '#1085#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
          object Price_partner_end: TcxGridDBColumn
            Caption = #1082#1086#1085#1077#1095'. '#1062#1077#1085#1072' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'Price_partner_end'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
          object GoodsId: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1189
    Height = 54
    ExplicitWidth = 1071
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 44562d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 44562d
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
      Left = 536
      Top = 6
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077':'
    end
    object edGoods: TcxButtonEdit
      Left = 629
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 239
    end
    object cxLabel5: TcxLabel
      Left = 267
      Top = 32
      Caption = #1055#1072#1088#1090#1080#1103':'
    end
    object edPartion: TcxButtonEdit
      Left = 318
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
    object cxLabel8: TcxLabel
      Left = 228
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 318
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 210
    end
    object cbPartNumber: TcxCheckBox
      Left = 874
      Top = 32
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' S/N'
      Properties.ReadOnly = False
      TabOrder = 10
      Width = 117
    end
    object Код: TcxLabel
      Left = 573
      Top = 31
      Caption = 'Interne Nr'
    end
    object ceCode: TcxCurrencyEdit
      Left = 629
      Top = 30
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 90
    end
    object edArticle: TcxTextEdit
      Left = 778
      Top = 30
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 90
    end
    object cxLabel18: TcxLabel
      Left = 729
      Top = 31
      Caption = 'Artikel Nr'
    end
    object cbPartner: TcxCheckBox
      Left = 997
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Width = 82
    end
  end
  object lbSearchArticle: TcxLabel [2]
    Left = 155
    Top = 221
    Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchArticle: TcxTextEdit [3]
    Left = 152
    Top = 247
    TabOrder = 7
    DesignSize = (
      125
      21)
    Width = 125
  end
  object cbPartion: TcxCheckBox [4]
    Left = 874
    Top = 5
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1055#1072#1088#1090#1080#1103' '#8470
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Width = 83
  end
  object cbOrderClient: TcxCheckBox [5]
    Left = 963
    Top = 5
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072' '#8470
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Width = 117
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
        Component = GuidesPartion
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnitGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbPartNumber
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    object actPrintSum: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1074#1093'.'#1094#1077#1085#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1074#1093'.'#1094#1077#1085#1072')'
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'PartnerName;GoodsGroupNameFull;Article;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' ('#1074#1093' '#1094#1077#1085#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' ('#1074#1093' '#1094#1077#1085#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1082#1086#1083'-'#1074#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1082#1086#1083'-'#1074#1086')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'PartnerName;GoodsGroupNameFull;Article;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' ('#1082#1086#1083'-'#1074#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' ('#1082#1086#1083'-'#1074#1086')'
      ReportNameParam.DataType = ftString
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
      FormName = 'TReport_GoodsMotionDialogForm'
      FormNameParam.Value = 'TReport_GoodsMotionDialogForm'
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
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = ''
          Component = GuidesPartion
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionName'
          Value = ''
          Component = GuidesPartion
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ceCode
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = edArticle
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOrderClient'
          Value = Null
          Component = cbOrderClient
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = Null
          Component = cbPartion
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = Null
          Component = cbPartner
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartNumber'
          Value = Null
          Component = cbPartNumber
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
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
          Name = 'PartionId'
          Value = Null
          Component = GuidesPartion
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = GuidesPartion
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
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
    StoredProcName = 'gpReport_GoodsMotion'
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
        Name = 'inUnitGroupId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionId'
        Value = Null
        Component = GuidesPartion
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartNumber'
        Value = Null
        Component = cbPartNumber
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = Null
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOrderClient'
        Value = Null
        Component = cbOrderClient
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
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
          ItemName = 'bblbSearchArticle'
        end
        item
          Visible = True
          ItemName = 'bbedSearchArticle'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintSum'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbSumm_branch: TdxBarControlContainerItem
      Caption = 'bbSumm_branch'
      Category = 0
      Hint = 'bbSumm_branch'
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbPrintSum: TdxBarButton
      Action = actPrintSum
      Category = 0
    end
    object bblbSearchArticle: TdxBarControlContainerItem
      Caption = 'lbSearchArticle'
      Category = 0
      Hint = 'lbSearchArticle'
      Visible = ivAlways
      Control = lbSearchArticle
    end
    object bbedSearchArticle: TdxBarControlContainerItem
      Caption = 'edSearchArticle'
      Category = 0
      Hint = 'edSearchArticle'
      Visible = ivAlways
      Control = edSearchArticle
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnitGroup
      end
      item
      end
      item
        Component = GuidesPartion
      end
      item
        Component = GuidesGoods
      end>
    Left = 168
    Top = 144
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
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
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 648
    Top = 11
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
  end
  object GuidesPartion: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartion
    FormNameParam.Value = 'TPartionGoodsChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartionGoodsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartion
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartion
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitName'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 24
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 200
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 168
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = Null
        Component = GuidesPartion
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = GuidesPartion
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = MasterCDS
    Column = Article_all
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 224
    Top = 184
  end
end
