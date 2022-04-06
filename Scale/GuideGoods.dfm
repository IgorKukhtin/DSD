object GuideGoodsForm: TGuideGoodsForm
  Left = 578
  Top = 242
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
  ClientHeight = 646
  ClientWidth = 982
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 256
    Width = 982
    Height = 390
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 982
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object bbExit: TSpeedButton
        Left = 511
        Top = 3
        Width = 31
        Height = 29
        Action = actExit
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888808077708888888880807770880800008080777088888880008077
          7088888880088078708800808000807770888888000000777088888888008007
          7088888880008077708888888800800770888888888880000088888888888888
          8888888888884444888888888888488488888888888844448888}
        ParentShowHint = False
        ShowHint = True
      end
      object bbRefresh: TSpeedButton
        Left = 306
        Top = 3
        Width = 31
        Height = 29
        Action = actRefresh
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000000
          00007777770FFFFFFFF000700000FF0F00F0E00BFBFB0FFFFFF0E0BFBF000FFF
          F0F0E0FBFBFBF0F00FF0E0BFBF00000B0FF0E0FBFBFBFBF0FFF0E0BF0000000F
          FFF0000BFB00B0FF00F07770000B0FFFFFF0777770B0FFFF000077770B0FF00F
          0FF07770B00FFFFF0F077709070FFFFF00777770770000000777}
        ParentShowHint = False
        ShowHint = True
      end
      object bbSave: TSpeedButton
        Left = 67
        Top = 3
        Width = 31
        Height = 29
        Action = actSave
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888888888888888888888888888888873333333333338887BB3B33B3B3
          B38887B3B3B13B3B3388873B3B9913B3B38887B3B399973B3388873B397B9973
          B38887B397BBB997338887FFFFFFFF91BB8888FBBBBB88891888888FFFF88888
          9188888888888888898888888888888888988888888888888888}
        ParentShowHint = False
        ShowHint = True
      end
      object bbSaveDialog: TSpeedButton
        Left = 179
        Top = 3
        Width = 31
        Height = 29
        Hint = 'F2 - '#1057#1086#1093#1088#1072#1085#1080#1100' '#1073#1077#1079' '#1079#1072#1082#1088#1099#1090#1080#1103
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF001DE6B5004CB12200FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF001DE6B5001DE6B5001DE6B5004CB12200FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF001DE6B5001DE6B5001DE6B5004CB12200FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF001DE6B5001DE6B5001DE6B5001DE6B5001DE6B5004CB12200FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF001DE6B5001DE6B5001DE6B5001DE6B5001DE6B5001DE6B5004CB12200FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000F2
          FF001DE6B5001DE6B5004CB12200FF00FF001DE6B5001DE6B5001DE6B5004CB1
          2200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000F2FF001DE6
          B5004CB12200FF00FF00FF00FF00FF00FF00FF00FF001DE6B5001DE6B5004CB1
          2200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001DE6B5001DE6B5001DE6
          B5004CB12200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001DE6B5001DE6
          B5004CB12200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001DE6
          B5001DE6B5004CB12200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0000F2FF001DE6B5004CB12200FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0000F2FF001DE6B5004CB12200FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF001DE6B5001DE6B5004CB12200FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbSaveDialogClick
      end
    end
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 33
      Width = 982
      Height = 357
      Align = alClient
      TabOrder = 1
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_OrderWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_WeighingWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_diffWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Remains
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_OrderWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_WeighingWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_diffWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Remains
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076
          DataBinding.FieldName = 'GoodsKindName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 55
        end
        object GoodsKindName_max: TcxGridDBColumn
          Caption = #1042#1080#1076' ('#1052#1040#1050#1057')'
          DataBinding.FieldName = 'GoodsKindName_max'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object GoodsKindId_list: TcxGridDBColumn
          Caption = #1042#1080#1076' ('#1050#1051#1070#1063#1048')'
          DataBinding.FieldName = 'GoodsKindId_list'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 30
        end
        object Weight: TcxGridDBColumn
          Caption = #1042#1077#1089
          DataBinding.FieldName = 'Weight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 40
        end
        object WeightTare: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1074#1090#1091#1083#1082#1080
          DataBinding.FieldName = 'WeightTare'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 40
        end
        object Amount_Remains: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1090#1086#1082
          DataBinding.FieldName = 'Amount_Remains'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 35
        end
        object CountForWeight: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1076#1083#1103' '#1042#1077#1089#1072
          DataBinding.FieldName = 'CountForWeight'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 40
        end
        object isPromo: TcxGridDBColumn
          Caption = #1040#1082#1094#1080#1103
          DataBinding.FieldName = 'isPromo'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 40
        end
        object Price: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object Price_Return: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' ('#1074#1086#1079#1074#1088'.)'
          DataBinding.FieldName = 'Price_Return'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' ('#1074#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
          Width = 50
        end
        object Price_Income: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' ('#1087#1088#1080#1093#1086#1076')'
          DataBinding.FieldName = 'Price_Income'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
          Options.Editing = False
          Width = 55
        end
        object Amount_Order: TcxGridDBColumn
          Caption = #1047#1072#1103#1074#1082#1072
          DataBinding.FieldName = 'Amount_Order'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object Amount_Weighing: TcxGridDBColumn
          Caption = #1054#1090#1075#1088#1091#1079#1082#1072
          DataBinding.FieldName = 'Amount_Weighing'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object Amount_diff: TcxGridDBColumn
          Caption = #1056#1072#1079#1085#1080#1094#1072
          DataBinding.FieldName = 'Amount_diff'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object GoodsGroupNameFull: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupNameFull'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
        object Amount_OrderWeight: TcxGridDBColumn
          Caption = #1047#1072#1103#1074#1082#1072' ('#1074#1077#1089')'
          DataBinding.FieldName = 'Amount_OrderWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object Amount_WeighingWeight: TcxGridDBColumn
          Caption = #1054#1090#1075#1088#1091#1079#1082#1072' ('#1074#1077#1089')'
          DataBinding.FieldName = 'Amount_WeighingWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object Amount_diffWeight: TcxGridDBColumn
          Caption = #1056#1072#1079#1085#1080#1094#1072' ('#1074#1077#1089')'
          DataBinding.FieldName = 'Amount_diffWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object isPartionGoods_20103: TcxGridDBColumn
          Caption = #1055#1072#1088#1090#1080#1103' '#1064#1080#1085
          DataBinding.FieldName = 'isPartionGoods_20103'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object Color_calc: TcxGridDBColumn
          DataBinding.FieldName = 'Color_calc'
          Visible = False
          VisibleForCustomization = False
          Width = 55
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object ParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 982
    Height = 256
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object infoPanelTare: TPanel
      Left = 502
      Top = 0
      Width = 230
      Height = 256
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object rgTareWeight: TRadioGroup
        Left = 0
        Top = 504
        Width = 230
        Height = 77
        Align = alClient
        Caption = #1058#1072#1088#1072' '#1074#1077#1089
        Color = clBtnFace
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        OnClick = rgTareWeightClick
      end
      object PanelTare: TPanel
        Left = 0
        Top = 0
        Width = 230
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object gbTareCount: TGroupBox
          Left = 0
          Top = 0
          Width = 155
          Height = 41
          Align = alClient
          Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
          TabOrder = 0
          object EditTareCount: TEdit
            Left = 5
            Top = 17
            Width = 100
            Height = 22
            TabOrder = 0
            Text = 'EditTareCount'
            OnEnter = EditTareCountEnter
            OnExit = EditTareCountExit
            OnKeyPress = EditTareCountKeyPress
          end
        end
        object gbTareWeightCode: TGroupBox
          Left = 155
          Top = 0
          Width = 75
          Height = 41
          Align = alRight
          Caption = #1050#1086#1076' '#1074#1077#1089
          TabOrder = 1
          object EditTareWeightCode: TEdit
            Left = 5
            Top = 17
            Width = 60
            Height = 22
            TabOrder = 0
            Text = 'EditTareWeightCode'
            OnChange = EditTareWeightCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditTareWeightCodeExit
            OnKeyPress = EditTareWeightCodeKeyPress
          end
        end
      end
      object infoPanelChangePercentAmount: TPanel
        Left = 0
        Top = 181
        Width = 230
        Height = 75
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        object rgChangePercentAmount: TRadioGroup
          Left = 0
          Top = 38
          Width = 230
          Height = 37
          Align = alClient
          Caption = #1057#1082#1080#1076#1082#1072' '#1087#1086' '#1074#1077#1089#1091
          Color = clBtnFace
          Columns = 3
          ParentColor = False
          TabOrder = 1
          OnClick = rgChangePercentAmountClick
          OnEnter = rgChangePercentAmountClick
        end
        object gbChangePercentAmountCode: TGroupBox
          Left = 0
          Top = 0
          Width = 230
          Height = 38
          Align = alTop
          Caption = #1050#1086#1076' '#1089#1082#1080#1076#1082#1080
          TabOrder = 0
          object EditChangePercentAmountCode: TEdit
            Left = 5
            Top = 14
            Width = 100
            Height = 22
            TabOrder = 0
            Text = 'EditChangePercentAmountCode'
            OnChange = EditChangePercentAmountCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditChangePercentAmountCodeExit
            OnKeyPress = EditChangePercentAmountCodeKeyPress
          end
        end
      end
      object gbTareWeightEnter: TGroupBox
        Left = 0
        Top = 41
        Width = 230
        Height = 41
        Align = alTop
        Caption = #1042#1077#1089' '#1090#1072#1088#1099
        TabOrder = 1
        object EditTareWeightEnter: TEdit
          Left = 5
          Top = 17
          Width = 100
          Height = 22
          TabOrder = 0
          Text = 'EditTareWeightEnter'
          OnEnter = EditTareCountEnter
          OnExit = EditTareWeightEnterExit
        end
      end
      object infoPanelTareFix: TPanel
        Left = 0
        Top = 82
        Width = 230
        Height = 422
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 4
        object infoPanelTare1: TPanel
          Left = 0
          Top = 0
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 0
          object PanelTare1: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare1: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 1.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare1: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 0
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare1KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare1: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare1: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare1: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare1'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object infoPanelTare0: TPanel
          Left = 0
          Top = 132
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 1
          object PanelTare0: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare0: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 0.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare0: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 4
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare0KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare0: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare0: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare0: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare0'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object infoPanelTare2: TPanel
          Left = 0
          Top = 22
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 2
          object PanelTare2: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare2: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 2.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare2: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 0
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare2KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare2: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare2: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare2: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare2'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object infoPanelTare5: TPanel
          Left = 0
          Top = 88
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 3
          object PanelTare5: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare5: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 5.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare5: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 0
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare5KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare5: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare5: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare5: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare5'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object infoPanelTare4: TPanel
          Left = 0
          Top = 66
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 4
          object PanelTare4: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare4: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 4.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare4: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 0
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare4KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare4: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare4: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare4: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare4'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object infoPanelTare3: TPanel
          Left = 0
          Top = 44
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 5
          object PanelTare3: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare3: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 3.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare3: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 0
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare3KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare3: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare3: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare3: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare3'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object infoPanelTare6: TPanel
          Left = 0
          Top = 110
          Width = 230
          Height = 22
          Align = alTop
          TabOrder = 6
          object PanelTare6: TPanel
            Left = 1
            Top = 1
            Width = 120
            Height = 20
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LabelTare6: TLabel
              Left = 0
              Top = 0
              Width = 120
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 6.0 '#1082#1075
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 81
            end
            object EditTare6: TcxCurrencyEdit
              Left = 5
              Top = 12
              Properties.Alignment.Horz = taRightJustify
              Properties.Alignment.Vert = taVCenter
              Properties.AssignedValues.DisplayFormat = True
              Properties.DecimalPlaces = 0
              Properties.OnChange = EditTare1PropertiesChange
              TabOrder = 0
              OnEnter = EditTareCountEnter
              OnExit = EditTare1Exit
              OnKeyDown = EditTare6KeyDown
              Width = 100
            end
          end
          object infoPanelWeightTare6: TPanel
            Left = 121
            Top = 1
            Width = 108
            Height = 20
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object LabelWeightTare6: TLabel
              Left = 0
              Top = 0
              Width = 108
              Height = 14
              Align = alTop
              Alignment = taCenter
              Caption = #1042#1077#1089
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ExplicitWidth = 19
            end
            object PanelWeightTare6: TPanel
              Left = 0
              Top = 14
              Width = 108
              Height = 6
              Align = alClient
              BevelOuter = bvNone
              Caption = 'PanelWeightTare6'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
        end
      end
    end
    object infoPanelPriceList: TPanel
      Left = 732
      Top = 0
      Width = 250
      Height = 256
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 3
      object rgPriceList: TRadioGroup
        Left = 0
        Top = 41
        Width = 250
        Height = 215
        Align = alClient
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        OnClick = rgPriceListClick
        OnEnter = rgPriceListClick
      end
      object gbPriceListCode: TGroupBox
        Left = 0
        Top = 0
        Width = 250
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditPriceListCode: TEdit
          Left = 5
          Top = 17
          Width = 140
          Height = 22
          TabOrder = 0
          Text = 'EditPriceListCode'
          OnChange = EditPriceListCodeChange
          OnEnter = EditTareCountEnter
          OnExit = EditPriceListCodeExit
          OnKeyPress = EditPriceListCodeKeyPress
        end
      end
    end
    object infoPanelGoods: TPanel
      Left = 0
      Top = 0
      Width = 135
      Height = 256
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object bbGoodsRemains: TSpeedButton
        Left = 14
        Top = 216
        Width = 113
        Height = 31
        Caption = #1055#1086#1076#1073#1086#1088' '#1086#1089#1090#1072#1090#1082#1072
        OnClick = bbGoodsRemainsClick
      end
      object gbGoodsName: TGroupBox
        Left = 0
        Top = 41
        Width = 135
        Height = 41
        Align = alTop
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        TabOrder = 1
        object EditGoodsName: TEdit
          Left = 4
          Top = 17
          Width = 125
          Height = 22
          TabOrder = 0
          Text = 'EditGoodsName'
          OnChange = EditGoodsNameChange
          OnEnter = EditGoodsNameEnter
          OnExit = EditGoodsNameExit
          OnKeyDown = EditGoodsNameKeyDown
          OnKeyPress = EditGoodsNameKeyPress
        end
      end
      object gbGoodsCode: TGroupBox
        Left = 0
        Top = 0
        Width = 135
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditGoodsCode: TEdit
          Left = 4
          Top = 17
          Width = 125
          Height = 22
          TabOrder = 0
          Text = 'EditGoodsCode'
          OnChange = EditGoodsCodeChange
          OnEnter = EditGoodsCodeEnter
          OnExit = EditGoodsCodeExit
          OnKeyDown = EditGoodsCodeKeyDown
          OnKeyPress = EditGoodsCodeKeyPress
        end
      end
      object gbGoodsWieghtValue: TGroupBox
        Left = 0
        Top = 164
        Width = 135
        Height = 41
        Align = alTop
        Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
        TabOrder = 2
        object PanelGoodsWieghtValue: TPanel
          Left = 2
          Top = 16
          Width = 131
          Height = 23
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWieghtValue'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbWeightValue: TGroupBox
        Left = 0
        Top = 82
        Width = 135
        Height = 41
        Align = alTop
        Caption = #1042#1074#1086#1076' '#1050#1054#1051#1048#1063#1045#1057#1058#1042#1054
        TabOrder = 3
        object EditWeightValue: TcxCurrencyEdit
          Left = 5
          Top = 18
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          TabOrder = 0
          OnEnter = EditTareCountEnter
          OnExit = EditWeightValueExit
          OnKeyDown = EditWeightValueKeyDown
          Width = 125
        end
      end
      object gbPrice: TGroupBox
        Left = 0
        Top = 123
        Width = 135
        Height = 41
        Align = alTop
        Caption = #1042#1074#1086#1076' '#1062#1045#1053#1040
        TabOrder = 4
        object EditPrice: TcxCurrencyEdit
          Left = 4
          Top = 16
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 4
          TabOrder = 0
          OnEnter = EditTareCountEnter
          OnExit = EditWeightValueExit
          OnKeyDown = EditPriceKeyDown
          Width = 125
        end
      end
      object gbPartionGoods_20103: TGroupBox
        Left = 0
        Top = 205
        Width = 135
        Height = 41
        Align = alTop
        Caption = #1055#1072#1088#1090#1080#1103
        TabOrder = 5
        object EditPartionGoods_20103: TcxCurrencyEdit
          Left = 4
          Top = 16
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 4
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 125
        end
      end
    end
    object infoPanelGoodsKind: TPanel
      Left = 135
      Top = 0
      Width = 367
      Height = 256
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object rgGoodsKind: TRadioGroup
        Left = 0
        Top = 41
        Width = 367
        Height = 215
        Align = alClient
        Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
        Color = clBtnFace
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = rgGoodsKindClick
      end
      object gbGoodsKindCode: TGroupBox
        Left = 0
        Top = 0
        Width = 367
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1091#1087#1072#1082#1086#1074#1082#1080
        TabOrder = 0
        object EditGoodsKindCode: TEdit
          Left = 5
          Top = 17
          Width = 108
          Height = 22
          TabOrder = 0
          Text = 'EditGoodsKindCode'
          OnChange = EditGoodsKindCodeChange
          OnEnter = EditTareCountEnter
          OnExit = EditGoodsKindCodeExit
          OnKeyPress = EditGoodsKindCodeKeyPress
        end
      end
    end
  end
  object DS: TDataSource
    DataSet = CDS
    OnDataChange = DSDataChange
    Left = 320
    Top = 336
  end
  object spSelect: TdsdStoredProc
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 224
    Top = 344
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    OnFilterRecord = CDSFilterRecord
    Left = 272
    Top = 384
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoice
      end>
    ActionItemList = <
      item
        Action = actChoice
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = Amount_diff
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_diffWeight
        ValueColumn = Color_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 408
    Top = 392
  end
  object ActionList: TActionList
    Left = 592
    Top = 352
    object actRefresh: TAction
      Category = 'ScaleLib'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      OnExecute = actRefreshExecute
    end
    object actChoice: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103
      OnExecute = actChoiceExecute
    end
    object actExit: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actSave: TAction
      Category = 'ScaleLib'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actSaveExecute
    end
  end
end
