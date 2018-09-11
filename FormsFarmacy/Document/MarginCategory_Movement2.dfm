inherited MarginCategory_Movement2Form: TMarginCategory_Movement2Form
  Caption = '2 '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1057#1040#1059#1062')'
  ClientHeight = 596
  ClientWidth = 1121
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1137
  ExplicitHeight = 634
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 123
    Width = 1121
    Height = 373
    ExplicitTop = 123
    ExplicitWidth = 1121
    ExplicitHeight = 373
    ClientRectBottom = 373
    ClientRectRight = 1121
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1121
      ExplicitHeight = 349
      inherited cxGrid: TcxGrid
        Width = 1121
        Height = 224
        ExplicitWidth = 1121
        ExplicitHeight = 224
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Remains
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys
            end
            item
              Format = #1057#1090#1088#1086#1082' ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Remains
            end>
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 34
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object isChecked: TcxGridDBColumn
            Caption = #1057#1040#1059#1062
            DataBinding.FieldName = 'isChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1057#1040#1059#1062' ('#1076#1072'/'#1085#1077#1090')'
            Width = 50
          end
          object isReport: TcxGridDBColumn
            Caption = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            Width = 45
          end
          object MarginPercent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'MarginPercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
          end
          object MarginPercentNew: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1085#1086#1074#1099#1081')'
            DataBinding.FieldName = 'MarginPercentNew'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1085#1086#1074#1099#1081')'
            Options.Editing = False
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1082#1091#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076'. '#1085#1072' '#1084#1086#1084#1077#1085#1090' '#1092#1086#1088#1084'.'#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 41
          end
          object cPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1086#1079#1085'.'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1062#1077#1085#1072' '#1088#1086#1079#1085'. '#1085#1072' '#1084#1086#1084#1077#1085#1090' '#1092#1086#1088#1084'. '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 55
          end
          object AmountMid: TcxGridDBColumn
            Caption = #1057#1088'. '#1082#1086#1083'. '#1087#1088'. '#1074' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountMid'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1089#1088#1077#1076#1085#1103#1103' '#1087#1088#1086#1076#1072#1078#1072' '#1074' '#1087#1077#1088#1080#1086#1076#1077
            Options.Editing = False
            Width = 55
          end
          object AmountAnalys: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079
            DataBinding.FieldName = 'AmountAnalys'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079
            Options.Editing = False
            Width = 55
          end
          object PersentMin: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'. '#1084#1080#1085'.'
            DataBinding.FieldName = 'PersentMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083'. '#1087#1088#1086#1076'. '#1079#1072' '#1072#1085#1072#1083#1080#1079' '#1086#1090' '#1084#1080#1085'.'
            Options.Editing = False
            Width = 51
          end
          object AmountMin: TcxGridDBColumn
            Caption = #1084#1080#1085' '#1082#1086#1083'. '#1087#1088'. '#1079#1072' '#1072#1085#1072#1083#1080#1079
            DataBinding.FieldName = 'AmountMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079
            Options.Editing = False
            Width = 55
          end
          object NumberMin: TcxGridDBColumn
            Caption = #8470' '#1087#1077#1088'. '#1084#1080#1085'. '#1087#1088'.'
            DataBinding.FieldName = 'NumberMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087#1077#1088#1080#1086#1076#1072' '#1084#1080#1085'. '#1087#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 42
          end
          object PersentMax: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'. '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'PersentMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083'. '#1087#1088#1086#1076'. '#1079#1072' '#1072#1085#1072#1083#1080#1079' '#1086#1090' '#1084#1072#1082#1089'.'
            Options.Editing = False
            Width = 52
          end
          object AmountMax: TcxGridDBColumn
            Caption = #1084#1072#1082#1089' '#1082#1086#1083'. '#1087#1088'. '#1079#1072' '#1072#1085#1072#1083#1080#1079
            DataBinding.FieldName = 'AmountMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1072#1082#1089' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079
            Options.Editing = False
            Width = 58
          end
          object NumberMax: TcxGridDBColumn
            Caption = #8470' '#1087#1077#1088'. '#1084#1072#1082#1089'. '#1087#1088'.'
            DataBinding.FieldName = 'NumberMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087#1077#1088#1080#1086#1076#1072' '#1084#1072#1082#1089'. '#1087#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 42
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 57
          end
          object MCSValue: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object MCSNotRecalc: TcxGridDBColumn
            Caption = #1057#1087#1077#1094#1082#1086#1085#1090#1088#1086#1083#1100' '#1082#1086#1076#1072
            DataBinding.FieldName = 'MCSNotRecalc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1087#1077#1088#1077#1089#1095#1080#1090#1099#1074#1072#1090#1100' '#1053#1058#1047
            Options.Editing = False
            Width = 53
          end
          object MCSIsClose: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' '#1082#1086#1076
            DataBinding.FieldName = 'MCSIsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 38
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 27
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 63
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
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 90
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 232
        Width = 1121
        Height = 117
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.DeletingConfirmation = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object MarginCategoryName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'MarginCategoryName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = MarginCategoryChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 206
          end
          object MinPrice: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'MinPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 156
          end
          object clAmount: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 141
          end
          object clAmountDiff: TcxGridDBColumn
            Caption = '%  '#1080#1079#1084'. '#1085#1072#1094'-'#1082#1080
            DataBinding.FieldName = 'AmountDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 175
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 392
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 165
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 224
        Width = 1121
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1121
    Height = 97
    TabOrder = 3
    ExplicitWidth = 1121
    ExplicitHeight = 97
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 88
      ExplicitLeft = 88
      ExplicitWidth = 78
      Width = 78
    end
    inherited cxLabel2: TcxLabel
      Left = 88
      ExplicitLeft = 88
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 62
      ExplicitTop = 62
      ExplicitWidth = 158
      ExplicitHeight = 22
      Width = 158
    end
    object lblUnit: TcxLabel
      Left = 171
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 171
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 270
    end
    object cxLabel7: TcxLabel
      Left = 447
      Top = 6
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 447
      Top = 23
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 182
    end
    object cxLabel10: TcxLabel
      Left = 633
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
    end
    object edInsertName: TcxButtonEdit
      Left = 633
      Top = 23
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
    object edUpdateName: TcxButtonEdit
      Left = 878
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 118
    end
    object cxLabel11: TcxLabel
      Left = 878
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
    end
  end
  object edStartSale: TcxDateEdit [2]
    Left = 171
    Top = 62
    EditValue = 42485d
    TabOrder = 6
    Width = 81
  end
  object cxLabel3: TcxLabel [3]
    Left = 171
    Top = 45
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1086#1090#1095'.'
  end
  object edEndSale: TcxDateEdit [4]
    Left = 257
    Top = 62
    EditValue = 42485d
    TabOrder = 8
    Width = 86
  end
  object cxLabel6: TcxLabel [5]
    Left = 257
    Top = 45
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1086#1090#1095'.'
  end
  object cxLabel8: TcxLabel [6]
    Left = 551
    Top = 44
    Caption = #1084#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1087#1088'.'
  end
  object edAmount: TcxCurrencyEdit [7]
    Left = 551
    Top = 62
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 78
  end
  object cxLabel9: TcxLabel [8]
    Left = 633
    Top = 44
    Caption = '% '#1086#1090#1082#1083'.'
  end
  object edChangePercent: TcxCurrencyEdit [9]
    Left = 633
    Top = 62
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 13
    Width = 49
  end
  object cxLabel4: TcxLabel [10]
    Left = 349
    Top = 45
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1085#1072#1094'-'#1082#1080
  end
  object edOperDateStart: TcxDateEdit [11]
    Left = 349
    Top = 62
    EditValue = 42485d
    TabOrder = 15
    Width = 92
  end
  object edOperDateEnd: TcxDateEdit [12]
    Left = 447
    Top = 62
    EditValue = 42485d
    TabOrder = 16
    Width = 98
  end
  object cxLabel5: TcxLabel [13]
    Left = 447
    Top = 45
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1085#1072#1094'-'#1082#1080
  end
  object cxLabel12: TcxLabel [14]
    Left = 756
    Top = 6
    Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
  end
  object edInsertdate: TcxDateEdit [15]
    Left = 756
    Top = 23
    EditValue = 42485d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 120
  end
  object cxLabel13: TcxLabel [16]
    Left = 999
    Top = 6
    Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
  end
  object edUpdateDate: TcxDateEdit [17]
    Left = 999
    Top = 23
    EditValue = 42485d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 120
  end
  object cxLabel14: TcxLabel [18]
    Left = 686
    Top = 44
    Caption = #1044#1085'. '#1072#1085#1072#1083#1080#1079#1072
  end
  object edDayCount: TcxCurrencyEdit [19]
    Left = 686
    Top = 62
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 23
    Width = 66
  end
  object cxLabel16: TcxLabel [20]
    Left = 756
    Top = 44
    Caption = #1084#1080#1085' '#1088#1086#1079#1085'. '#1094#1077#1085#1072
  end
  object edPriceMin: TcxCurrencyEdit [21]
    Left = 756
    Top = 62
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 25
    Width = 79
  end
  object cxLabel17: TcxLabel [22]
    Left = 838
    Top = 44
    Caption = #1084#1072#1082#1089' '#1088#1086#1079#1085'. '#1094#1077#1085#1072
  end
  object edPriceMax: TcxCurrencyEdit [23]
    Left = 838
    Top = 62
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 27
    Width = 82
  end
  object cxSplitter3: TcxSplitter [24]
    Left = 0
    Top = 496
    Width = 1121
    Height = 8
    Touch.ParentTabletOptions = False
    Touch.TabletOptions = [toPressAndHold]
    AlignSplitter = salBottom
    Control = cxGrid2
  end
  object cxGrid2: TcxGrid [25]
    Left = 0
    Top = 504
    Width = 1121
    Height = 92
    Align = alBottom
    PopupMenu = PopupMenu
    TabOrder = 29
    object cxGridDBTableView2: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = UnitDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.IncSearch = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Appending = True
      OptionsData.CancelOnExit = False
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ObjectCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'ObjectCode'
        Width = 85
      end
      object ObjectName: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082#1072' / '#1070#1088'. '#1083#1080#1094#1086
        DataBinding.FieldName = 'ObjectName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = Juridical_UnitChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 767
      end
      object clIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'IsErased'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 255
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableView2
    end
  end
  inherited ActionList: TActionList
    Left = 239
    Top = 367
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMarginCategoryUnit
        end
        item
        end
        item
        end>
    end
    object actLoad_SAMP: TdsdExecStoredProc [2]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spLoad_SAMP
      StoredProcList = <
        item
          StoredProc = spLoad_SAMP
        end>
      Caption = 'actLoad_SAMP'
    end
    object actMISetErasedChild: TdsdUpdateErased [3]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1085#1072#1094#1077#1085#1082#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1085#1072#1094#1077#1085#1082#1080'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErasedChild: TdsdUpdateErased [5]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMarginCategoryUnit
        end>
    end
    object InsertRecordChild: TInsertRecord [9]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView1
      Action = MarginCategoryChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1085#1072#1094#1077#1085#1082#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1085#1072#1094#1077#1085#1082#1080'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actInsertRecordUnit: TInsertRecord [10]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView2
      Action = Juridical_UnitChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1040#1087#1090#1077#1082#1091' / '#1102#1088'. '#1083#1080#1094#1086'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1040#1087#1090#1077#1082#1091' / '#1102#1088'. '#1083#1080#1094#1086'>'
      ImageIndex = 0
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object actUpdateChildDS: TdsdUpdateDataSet [12]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateChildDS'
      DataSource = DetailDS
    end
    object actDoLoad: TExecuteImportSettingsAction [13]
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object dsdUpdateUnitDS: TdsdUpdateDataSet [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMarginCategoryUnit
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMarginCategoryUnit
        end
        item
          StoredProc = spSelectMarginCategoryUnit
        end>
      Caption = 'actUpdateUnitDS'
      DataSource = UnitDS
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = gpUpdate_isReport
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
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    object actSetErasedMarginCategoryUnit: TdsdUpdateErased [23]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSetErasedMarginCategoryUnit
      StoredProcList = <
        item
          StoredProc = spSetErasedMarginCategoryUnit
        end
        item
          StoredProc = spSelectMarginCategoryUnit
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1040#1087#1090#1077#1082#1091' / '#1070#1088'. '#1083#1080#1094#1086'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1040#1087#1090#1077#1082#1091' / '#1070#1088'. '#1083#1080#1094#1086'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'IsErased'
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actSetUnErasedMarginCategoryUnit: TdsdUpdateErased [24]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnCompleteMarginCategoryUnit
      StoredProcList = <
        item
          StoredProc = spUnCompleteMarginCategoryUnit
        end
        item
          StoredProc = spSelectMarginCategoryUnit
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object Juridical_UnitChoiceForm: TOpenChoiceForm [27]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Juridical_UnitChoiceForm'
      FormName = 'TJuridical_Unit_ObjectForm'
      FormNameParam.Value = 'TJuridical_Unit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = UnitrDCS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = UnitrDCS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = UnitrDCS
          ComponentItem = 'ObjectCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PartnerChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridicalForm'
      FormNameParam.Value = 'TJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MarginCategoryChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'MarginCategoryChoiceForm'
      FormName = 'TMarginCategoryForm'
      FormNameParam.Value = 'TMarginCategoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'MarginCategoryId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'MarginCategoryName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsertPromoPartner: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertPromoPartner
        end
        item
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102'?'
      InfoAfterExecute = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ImageIndex = 27
    end
    object actUpdateisReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdate_isReport
      StoredProcList = <
        item
          StoredProc = gpUpdate_isReport
        end>
      Caption = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1044#1072'/'#1053#1077#1090
      Hint = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1044#1072'/'#1053#1077#1090
    end
    object actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actInsertUpdate_MovementItem_Promo_Set_Zero'
    end
    object spUpdateisReportNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdate_isReport_No
      StoredProcList = <
        item
          StoredProc = gpUpdate_isReport_No
        end>
      Caption = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1053#1077#1090
      Hint = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1053#1077#1090
    end
    object spUpdateisReportYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdate_isReport_Yes
      StoredProcList = <
        item
          StoredProc = gpUpdate_isReport_Yes
        end>
      Caption = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1044#1072
      Hint = #1076#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1044#1072
    end
    object actGetImportSettingId: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSettingId'
    end
    object actStartLoad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actInsertUpdate_MovementItem_Promo_Set_Zero
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1072#1085#1085#1099#1093' '#1074' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 41
    end
    object macUpdateisReportNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisReportNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1053#1045#1058
      ImageIndex = 58
    end
    object macUpdateisReportYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisReportYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1083#1103' '#1086#1090#1095#1077#1090#1072' - '#1044#1072
      ImageIndex = 52
    end
    object actInsertPromoPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProcList = <
        item
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ImageIndex = 27
    end
    object macLoad_SAMP: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actLoad_SAMP
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090
    end
    object actOpenReportSimple: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1090#1077#1082'.'#1090#1086#1074#1072#1088#1072' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1090#1077#1082'.'#1090#1086#1074#1072#1088#1072' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
      ImageIndex = 24
      FormName = 'TReport_SAMP_AnalysisForm'
      FormNameParam.Value = 'TReport_SAMP_AnalysisForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartSale'
          Value = 42485d
          Component = edStartSale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndSale'
          Value = 42485d
          Component = edEndSale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DayCount'
          Value = 0.000000000000000000
          Component = edDayCount
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object spUpdateisCheckedNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isChecked_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isChecked_No
        end>
      Caption = #1057#1040#1059#1062' - '#1053#1077#1090
      Hint = #1057#1040#1059#1062' - '#1053#1077#1090
    end
    object spUpdateisCheckedYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isChecked_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isChecked_Yes
        end>
      Caption = #1057#1040#1059#1062' - '#1044#1072
      Hint = #1057#1040#1059#1062' - '#1044#1072
    end
    object macUpdateisCheckedNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisCheckedNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1057#1040#1059#1062' - '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1057#1040#1059#1062' - '#1053#1045#1058
      ImageIndex = 58
    end
    object macUpdateisCheckedYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisCheckedYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1057#1040#1059#1062' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1057#1040#1059#1062' - '#1044#1072
      ImageIndex = 52
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084'>'
      ImageIndex = 25
      FormName = 'TReport_SAMP_AnalysisForm'
      FormNameParam.Value = 'TReport_SAMP_AnalysisForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartSale'
          Value = 'NULL'
          Component = edStartSale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndSale'
          Value = 'NULL'
          Component = edEndSale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DayCount'
          Value = Null
          Component = edDayCount
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_MarginCategory'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = DetailDCS
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 376
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordUnit'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedMarginCategoryUnit'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedMarginCategoryUnit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisCheckedYes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisCheckedNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbUpdateisReportYes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisReportNo'
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
          ItemName = 'bbLoad_SAMP'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReport'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportSimple'
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
    inherited bbErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbMISetErasedChild: TdxBarButton
      Action = actMISetErasedChild
      Category = 0
      Visible = ivNever
    end
    object bbMISetUnErasedChild: TdxBarButton
      Action = actMISetUnErasedChild
      Category = 0
      Visible = ivNever
    end
    object bbactStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbInsertRecordChild: TdxBarButton
      Action = InsertRecordChild
      Category = 0
      Visible = ivNever
    end
    object bbLoad_SAMP: TdxBarButton
      Action = macLoad_SAMP
      Category = 0
      ImageIndex = 74
    end
    object bbUpdateisCheckedYes: TdxBarButton
      Action = macUpdateisCheckedYes
      Category = 0
    end
    object bbUpdateisCheckedNo: TdxBarButton
      Action = macUpdateisCheckedNo
      Category = 0
    end
    object bbUpdateisReportNo: TdxBarButton
      Action = macUpdateisReportNo
      Category = 0
      ImageIndex = 77
    end
    object bbUpdateisReportYes: TdxBarButton
      Action = macUpdateisReportYes
      Category = 0
      ImageIndex = 76
    end
    object bbOpenReport: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbOpenReportSimple: TdxBarButton
      Action = actOpenReportSimple
      Category = 0
    end
    object bbSetErasedMarginCategoryUnit: TdxBarButton
      Action = actSetErasedMarginCategoryUnit
      Category = 0
    end
    object bbSetUnErasedMarginCategoryUnit: TdxBarButton
      Action = actSetUnErasedMarginCategoryUnit
      Category = 0
    end
    object bbInsertRecordUnit: TdxBarButton
      Action = actInsertRecordUnit
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Left = 518
    Top = 233
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
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Left = 160
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_MarginCategory'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Top = 216
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_MarginCategory'
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
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        Name = 'StartSale'
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSale'
        Value = 'NULL'
        Component = edEndSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = 'NULL'
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = 'NULL'
        Component = edOperDateEnd
        DataType = ftDateTime
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
        Name = 'InsertId'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
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
        Name = 'Amount'
        Value = Null
        Component = edAmount
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
        Name = 'UpdateId'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = 'NULL'
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Insertdate'
        Value = 'NULL'
        Component = edInsertdate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceMax'
        Value = Null
        Component = edPriceMax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceMin'
        Value = Null
        Component = edPriceMin
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 288
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_MarginCategory'
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
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartSale'
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = 'NULL'
        Component = edEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateStart'
        Value = 'NULL'
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = 'NULL'
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = edAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCount'
        Value = Null
        Component = edDayCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceMin'
        Value = Null
        Component = edPriceMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceMax'
        Value = Null
        Component = edPriceMax
        DataType = ftFloat
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
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesUnit
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
      end>
    Left = 288
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edUnit
      end
      item
        Control = edComment
      end
      item
        Control = edStartSale
      end
      item
        Control = edEndSale
      end
      item
        Control = edInsertdate
      end
      item
        Control = edInsertName
      end
      item
        Control = edAmount
      end
      item
        Control = edChangePercent
      end
      item
        Control = edOperDateEnd
      end
      item
        Control = edOperDateStart
      end
      item
        Control = edUpdateDate
      end
      item
        Control = edUpdateName
      end
      item
        Control = edDayCount
      end
      item
        Control = edPriceMax
      end
      item
        Control = edPriceMin
      end>
    Left = 256
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 112
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 550
    Top = 304
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 622
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Master'
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
        Name = 'inisChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isChecked'
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 368
    Top = 248
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 928
    Top = 184
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_TotalSumm'
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
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummPrimeCost'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 900
    Top = 228
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
    Left = 320
    Top = 8
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SaleExactly_Print'
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
    Left = 879
    Top = 304
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 692
    Top = 222
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
    Top = 209
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 328
    Top = 496
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 400
    Top = 488
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    SearchAsFilter = False
    Left = 646
    Top = 481
  end
  object spUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiff'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 488
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
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
    Left = 566
    Top = 352
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
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
    Left = 654
    Top = 312
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPromoForm;zc_Object_ImportSetting_Promo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 264
  end
  object GuidesInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert
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
    Left = 666
    Top = 6
  end
  object GuidesUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdateName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUpdate
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
    Left = 810
    Top = 70
  end
  object spLoad_SAMP: TdsdStoredProc
    StoredProcName = 'gpReport_SAMP_Load2'
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
      end
      item
        Name = 'inStartSale'
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = 'NULL'
        Component = edEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = edAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCount'
        Value = Null
        Component = edDayCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceMin'
        Value = Null
        Component = edPriceMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceMax'
        Value = Null
        Component = edPriceMax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 424
    Top = 328
  end
  object spUpdate_isChecked_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Checked'
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
        Name = 'inisChecked'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isChecked'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 395
  end
  object spUpdate_isChecked_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Checked'
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
        Name = 'inisChecked'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isChecked'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 483
  end
  object gpUpdate_isReport_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Report'
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
        Name = 'inisList'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 403
  end
  object gpUpdate_isReport_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Report'
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
        Name = 'inisList'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 459
  end
  object gpUpdate_isReport: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_MarginCategory_Report'
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
        Name = 'inisList'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport'
        Value = 'FALSE'
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 355
  end
  object UnitrDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 56
    Top = 496
  end
  object UnitDS: TDataSource
    DataSet = UnitrDCS
    Left = 104
    Top = 512
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    SearchAsFilter = False
    Left = 190
    Top = 497
  end
  object spInsertMarginCategoryUnit: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_MarginCategoryUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 272
    Top = 536
  end
  object spSelectMarginCategoryUnit: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MarginCategoryUnit'
    DataSet = UnitrDCS
    DataSets = <
      item
        DataSet = UnitrDCS
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 536
  end
  object spInsertUpdateMarginCategoryUnit: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_MarginCategoryUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = UnitrDCS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = UnitrDCS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 560
    Top = 544
  end
  object spSetErasedMarginCategoryUnit: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_MarginCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = UnitrDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 684
    Top = 528
  end
  object spUnCompleteMarginCategoryUnit: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_MarginCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = UnitrDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 544
  end
end
