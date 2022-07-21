inherited InventoryForm: TInventoryForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103'>'
  ClientHeight = 643
  ClientWidth = 878
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 894
  ExplicitHeight = 682
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 878
    Height = 528
    ExplicitTop = 115
    ExplicitWidth = 878
    ExplicitHeight = 528
    ClientRectBottom = 528
    ClientRectRight = 878
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 878
      ExplicitHeight = 504
      inherited cxGrid: TcxGrid
        Width = 878
        Height = 504
        ExplicitWidth = 878
        ExplicitHeight = 504
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
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
              Format = ',0.####'
              Kind = skSum
              Column = colSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRemains_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountUser
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
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
              Column = colSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRemains_Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colDeficit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colDeficitSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colProicit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colProicitSumm
            end
            item
              Format = '+ ,0.####;- ,0.####; '
              Kind = skSum
              Column = colDiff
            end
            item
              Format = '+ ,0.00;- ,0.00; '
              Kind = skSum
              Column = colDiffSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRemains_Summ
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colName
            end
            item
              Format = '+ ,0.####;- ,0.####; '
              Kind = skSum
              Column = Diff_calc
            end
            item
              Format = '+ ,0.####;- ,0.####; '
              Kind = skSum
              Column = Diff_diff
            end
            item
              Format = '+ ,0.00;- ,0.00; '
              Kind = skSum
              Column = DiffSumm_calc
            end
            item
              Format = '+ ,0.00;- ,0.00; '
              Kind = skSum
              Column = DiffSumm_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountUser
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_Save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_SumSave
            end>
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
          object colCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object colName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 259
          end
          object minExpirationDate: TcxGridDBColumn [2]
            Caption = #1052#1080#1085'. '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object colRemains_Amount: TcxGridDBColumn [3]
            AlternateCaption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            Caption = #1056#1072#1089#1095'. '#1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            Options.Editing = False
            Width = 56
          end
          object colPrice: TcxGridDBColumn [4]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colRemains_Summ: TcxGridDBColumn [5]
            Caption = 'C'#1091#1084#1084#1072' '#1088#1072#1089#1095'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'Remains_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colSumm: TcxGridDBColumn [6]
            Caption = 'C'#1091#1084#1084#1072' '#1092#1072#1082#1090' '#1086#1089#1090'.'
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colAmount: TcxGridDBColumn [7]
            AlternateCaption = #1048#1090#1086#1075#1086' '#1074#1074#1077#1076#1077#1085#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            Caption = #1060#1072#1082#1090' '#1080#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1074#1074#1077#1076#1077#1085#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            Options.Editing = False
            Width = 65
          end
          object colAmountUser: TcxGridDBColumn [8]
            AlternateCaption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081' '#1086#1089#1090#1072#1090#1086#1082'  ('#1090#1077#1082'.'#1087#1086#1083#1100#1079'.)'
            Caption = #1060#1072#1082#1090'. '#1086#1089#1090#1072#1090#1086#1082' ('#1090#1077#1082'.'#1087#1086#1083#1100#1079'.)'
            DataBinding.FieldName = 'AmountUser'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082', '#1082#1086#1090#1086#1088#1099#1081' '#1074#1074#1077#1083' "'#1090#1077#1082#1091#1097#1080#1081'" '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            Width = 91
          end
          object colCountUser: TcxGridDBColumn [9]
            AlternateCaption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1100#1079'.'
            DataBinding.FieldName = 'CountUser'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1100#1079'. '#1082#1086#1090#1086#1088#1099#1077' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1083#1080' '#1086#1089#1090#1072#1090#1086#1082
            Options.Editing = False
            Width = 50
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colDeficit: TcxGridDBColumn
            Caption = #1053#1077#1076#1086#1089#1090#1072#1095#1072
            DataBinding.FieldName = 'Deficit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colDeficitSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1077#1076#1086#1089#1090#1072#1095#1080
            DataBinding.FieldName = 'DeficitSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colProicit: TcxGridDBColumn
            Caption = #1048#1079#1083#1080#1096#1077#1082
            DataBinding.FieldName = 'Proficit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colProicitSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1080#1079#1083#1080#1096#1082#1072
            DataBinding.FieldName = 'ProficitSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object colDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.####;- ,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Diff_calc: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' ('#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'Diff_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.####;- ,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DiffSumm_calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085#1080#1094#1099'  ('#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'DiffSumm_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.00;- ,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object Diff_diff: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1080#1089#1087#1088#1072#1074#1083'.'
            DataBinding.FieldName = 'Diff_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.####;- ,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DiffSumm_diff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1080#1089#1087#1088#1072#1074#1083'.'
            DataBinding.FieldName = 'DiffSumm_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.00;- ,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colDiffSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085#1080#1094#1099
            DataBinding.FieldName = 'DiffSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.00;- ,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object colMIComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'MIComment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object clisAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Remains_Save: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1088#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080
            DataBinding.FieldName = 'Remains_Save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object Remains_SumSave: TcxGridDBColumn
            Caption = #1057#1091#1084'. '#1086#1089#1090#1072#1090#1086#1082#1072' '#1087#1088#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080
            DataBinding.FieldName = 'Remains_SumSave'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
        end
      end
    end
    object cxTabSheetChild: TcxTabSheet
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1096'/'#1082
      ImageIndex = 2
      object cxGridChild: TcxGrid
        Left = 0
        Top = 54
        Width = 878
        Height = 450
        Align = alClient
        TabOrder = 1
        object cxGridChildDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object isLast: TcxGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081
            DataBinding.FieldName = 'isLast'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object Num: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'Num'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 209
          end
          object chAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 180
          end
          object UserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 272
          end
          object Date_Insert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'Date_Insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 139
          end
        end
        object cxGridChildLevel: TcxGridLevel
          GridView = cxGridChildDBTableView
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 46
        Width = 878
        Height = 8
        HotZoneClassName = 'TcxXPTaskBarStyle'
        HotZone.Visible = False
        AlignSplitter = salTop
        Control = Panel1
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 878
        Height = 46
        Align = alTop
        ShowCaption = False
        TabOrder = 0
        object edBarCode: TcxTextEdit
          Left = 16
          Top = 22
          TabOrder = 1
          Width = 193
        end
        object ceAmount: TcxCurrencyEdit
          Left = 220
          Top = 22
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####'
          TabOrder = 0
          Width = 90
        end
        object cxLabel4: TcxLabel
          Left = 16
          Top = 5
          Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
        end
        object cxLabel5: TcxLabel
          Left = 220
          Top = 5
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        end
        object ceAmountAdd: TcxCurrencyEdit
          Left = 727
          Top = 22
          TabStop = False
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####'
          Properties.ReadOnly = True
          TabOrder = 4
          Width = 90
        end
        object cxLabel6: TcxLabel
          Left = 735
          Top = 5
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        end
        object edGoodsCode: TcxTextEdit
          Left = 335
          Top = 22
          TabStop = False
          Properties.ReadOnly = True
          TabOrder = 6
          Width = 66
        end
        object cxLabel7: TcxLabel
          Left = 335
          Top = 4
          Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088
        end
        object edGoodsName: TcxTextEdit
          Left = 407
          Top = 22
          TabStop = False
          Properties.ReadOnly = True
          TabOrder = 8
          Width = 314
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 878
    Height = 89
    TabOrder = 3
    ExplicitWidth = 878
    ExplicitHeight = 89
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
      Left = 89
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 88
      Width = 88
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Left = 607
      ExplicitLeft = 607
    end
    inherited ceStatus: TcxButtonEdit
      Left = 607
      ExplicitLeft = 607
      ExplicitWidth = 154
      ExplicitHeight = 22
      Width = 154
    end
    object cxLabel3: TcxLabel
      Left = 179
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 179
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 270
    end
    object chbFullInvent: TcxCheckBox
      Left = 455
      Top = 23
      Caption = #1055#1086#1083#1085#1072#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Width = 146
    end
    object edComment: TcxTextEdit
      Left = 8
      Top = 60
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 441
    end
    object cxLabel8: TcxLabel
      Left = 8
      Top = 42
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 107
    Top = 136
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 144
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actRefreshChild: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      TabSheet = cxTabSheetChild
      MoveParams = <>
      Enabled = False
      StoredProc = spSelect_MI_Child
      StoredProcList = <
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1080#1103' '#1086#1089#1090#1072#1090#1082#1086#1074
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1080#1103' '#1086#1089#1090#1072#1090#1082#1086#1074
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshStart: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectBarCode
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
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
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      BeforeAction = actPUSHInfo
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
      ReportName = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.Value = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
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
      BeforeAction = actPUSHCompile
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1076' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077#1084' '#1085#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1074' Exel-'#1092#1072#1081#1083
      InfoAfterExecute = #1053#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1074' Exel'
    end
    object actOpenInventoryPartionForm: TdsdOpenForm [14]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1072#1088#1090#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1072#1088#1090#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 26
      FormName = 'TInventoryPartionForm'
      FormNameParam.Value = 'TInventoryPartionForm'
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
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inOperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actStorageChoice: TOpenChoiceForm [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageChoice'
      FormName = 'TStoragePlace_ObjectForm'
      FormNameParam.Value = 'TStoragePlace_ObjectForm'
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
    object actAssetChoice: TOpenChoiceForm [17]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AssetChoice'
      FormName = 'TAssetForm'
      FormNameParam.Value = 'TAssetForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertUpdateMIAmount: TdsdExecStoredProc [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIAmount
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIAmount
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1085#1072' '#1076#1072#1090#1091
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1085#1072' '#1076#1072#1090#1091
      ImageIndex = 50
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' ' +
        #1085#1072' '#1076#1072#1090#1091'?'
      InfoAfterExecute = '<'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1085#1072' '#1076#1072#1090#1091' '#1079#1072#1087#1086#1083#1085#1077#1085#1086' '#1091#1089#1087#1077#1096#1085#1086'.'
    end
    object actUnitChoice: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoice'
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
    object actGoodsKindChoice: TOpenChoiceForm [20]
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
    object actStartLoad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actInsertUpdate_MovementItem_Inventory_Set_Zero
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1086#1089#1090#1072#1090#1082#1072' '#1074' '#1090#1077#1082#1091#1097#1091#1102' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1102'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1089#1090#1072#1090#1082#1080
      ImageIndex = 41
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
    object actInsertUpdate_MovementItem_Inventory_Set_Zero: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MovementItem_Inventory_Set_Zero
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MovementItem_Inventory_Set_Zero
        end>
      Caption = 'actInsertUpdate_MovementItem_Inventory_Set_Zero'
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = Null
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
    object actSelect: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = 'actSelect'
    end
    object actBarCodeScan: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSpBarCodeScan
        end>
      Caption = 'actBarCodeScan'
    end
    object actSpBarCodeScan: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_Inventory
      StoredProcList = <
        item
          StoredProc = spInsert_MI_Inventory
        end
        item
          StoredProc = spSelect_MI_Child
        end
        item
          StoredProc = spSelectBarCode
        end>
      Caption = 'actSpBarCodeScan'
    end
    object actPUSHInfo: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHInfo
      StoredProcList = <
        item
          StoredProc = spPUSHInfo
        end>
      Caption = 'actPUSHInfo'
      PUSHMessageType = pmtInformation
    end
    object actPUSHCompile: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHCompile
      StoredProcList = <
        item
          StoredProc = spPUSHCompile
        end>
      Caption = 'actPUSHCompile'
    end
    object actShowDeviated: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1080' '#1089' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103#1084#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1080' '#1089' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103#1084#1080
      ImageIndex = 76
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1087#1086#1079#1080#1094#1080#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1080' '#1089' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103#1084#1080
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1087#1086#1079#1080#1094#1080#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1080' '#1089' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103#1084#1080
      ImageIndexTrue = 77
      ImageIndexFalse = 76
    end
    object actOpenInventoryHouseholdInventory: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecGetInventoryHouseholdInventoryID
        end
        item
          Action = actOFInventoryHouseholdInventory
        end>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      Hint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      ImageIndex = 42
    end
    object actExecGetInventoryHouseholdInventoryID: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetInventoryHouseholdInventoryID
      StoredProcList = <
        item
          StoredProc = spGetInventoryHouseholdInventoryID
        end>
      Caption = 'actExecGetInventoryHouseholdInventoryID'
    end
    object actOFInventoryHouseholdInventory: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOFInventoryHouseholdInventory'
      FormName = 'TInventoryHouseholdInventoryForm'
      FormNameParam.Value = 'TInventoryHouseholdInventoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'InventoryHouseholdInventoryId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPUSHInventBarcode: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHInventBarcode
      StoredProcList = <
        item
          StoredProc = spPUSHInventBarcode
        end>
      Caption = 'actPUSHInventBarcode'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Inventory'
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
        Name = 'inShowDeviated'
        Value = False
        Component = actShowDeviated
        DataType = ftBoolean
        ParamType = ptInput
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
    Left = 88
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMIAmount'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenInventoryHouseholdInventory'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInventoryPartion'
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
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton1'
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
          ItemName = 'dxBarButton2'
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
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbInsertUpdateMIAmount: TdxBarButton
      Action = actInsertUpdateMIAmount
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Category = 0
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Visible = ivNever
      ImageIndex = 22
    end
    object dxBarButton1: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbInventoryPartion: TdxBarButton
      Action = actOpenInventoryPartionForm
      Category = 0
    end
    object bb: TdxBarButton
      Action = actRefreshChild
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actShowDeviated
      Category = 0
    end
    object bbOpenInventoryHouseholdInventory: TdxBarButton
      Action = actOpenInventoryHouseholdInventory
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 758
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 568
    Top = 416
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
        Name = 'ReportNameInventory'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FullInvent'
        Value = Null
        Component = chbFullInvent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InventoryHouseholdInventoryId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 144
  end
  inherited StatusGuides: TdsdGuides
    Left = 72
    Top = 24
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Inventory'
    Left = 144
    Top = 16
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Inventory'
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
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FullInvent'
        Value = False
        Component = FormParams
        ComponentItem = 'FullInvent'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Inventory'
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
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFullInvent'
        Value = False
        Component = FormParams
        ComponentItem = 'FullInvent'
        DataType = ftBoolean
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
      end>
    Left = 162
    Top = 312
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
        Action = actSelect
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edComment
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edUnit
      end
      item
        Control = chbFullInvent
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
      end
      item
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 640
    Top = 224
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetErased'
    Left = 486
    Top = 464
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetUnErased'
    Left = 486
    Top = 416
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory'
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
        Name = 'outAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUser'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountUser'
        DataType = ftFloat
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MIComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumma'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDeficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Deficit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDeficitSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DeficitSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outProficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Proficit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outProficitSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ProficitSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Diff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiffSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiffSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountUser'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountUser'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSummInventory'
    Left = 612
    Top = 300
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <>
    Left = 512
    Top = 328
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
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Inventory_Print'
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
    Left = 319
    Top = 184
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
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
    Left = 296
    Top = 16
  end
  object spInsertUpdateMIAmount: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_Amount'
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
    Left = 322
    Top = 384
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
        Value = 'TInventoryForm;zc_Object_ImportSetting_Inventory'
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
    Left = 152
    Top = 448
  end
  object spInsertUpdate_MovementItem_Inventory_Set_Zero: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_Set_Zero'
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
    Left = 322
    Top = 432
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 280
    Top = 552
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 336
    Top = 552
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Inventory_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
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
    Left = 440
    Top = 552
  end
  object dsdDBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridChildDBTableView
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
    Left = 526
    Top = 553
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
      end
      item
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 560
    Top = 152
  end
  object spSelectBarCode: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Inventory_BarCode'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'BarCode'
        Value = Null
        Component = edBarCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 440
    Top = 168
  end
  object spInsert_MI_Inventory: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_Inventory'
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
        Name = 'inBarCode'
        Value = Null
        Component = edBarCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUser'
        Value = 1.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsCode'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName'
        Value = Null
        Component = edGoodsName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountAdd'
        Value = Null
        Component = ceAmountAdd
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 163
  end
  object dsdEnterManager: TdsdEnterManager
    ControlList = <
      item
        Action = actBarCodeScan
        Control = edBarCode
      end
      item
        Control = ceAmount
        GotoControl = edBarCode
      end>
    TabSheetList = <
      item
        TabSheet = cxTabSheetChild
        Control = edBarCode
      end>
    PageControl = PageControl
    Left = 760
    Top = 296
  end
  object spPUSHInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_Inventory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
    Left = 754
    Top = 368
  end
  object spPUSHCompile: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowCompilePUSH_Inventory'
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
        Name = 'inUnitID'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
    Left = 754
    Top = 440
  end
  object spGetInventoryHouseholdInventoryID: TdsdStoredProc
    StoredProcName = 'gpGet_InventoryHouseholdInventoryID'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitID'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
        Name = 'outMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'InventoryHouseholdInventoryId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 748
    Top = 499
  end
  object spPUSHInventBarcode: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PUSH_InventBarcode'
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
        Name = 'inBarCode'
        Value = ''
        Component = edBarCode
        DataType = ftString
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
    Left = 650
    Top = 368
  end
end
