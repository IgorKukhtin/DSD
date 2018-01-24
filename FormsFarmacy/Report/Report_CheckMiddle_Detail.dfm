inherited Report_CheckMiddle_DetailForm: TReport_CheckMiddle_DetailForm
  Caption = #1054#1090#1095#1077#1090' <'#1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082' '#1079#1072' '#1087#1077#1088#1080#1086#1076'> '
  ClientHeight = 469
  ClientWidth = 991
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1007
  ExplicitHeight = 508
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 81
    Width = 991
    Height = 388
    TabOrder = 3
    ExplicitTop = 81
    ExplicitWidth = 989
    ExplicitHeight = 388
    ClientRectBottom = 388
    ClientRectRight = 991
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 989
      ExplicitHeight = 388
      inherited cxGrid: TcxGrid
        Top = 8
        Width = 991
        Height = 228
        ExplicitTop = 8
        ExplicitWidth = 989
        ExplicitHeight = 228
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
              Column = SummaSale
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSale_SP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSale_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWith_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPeriod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSalePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleAll
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddle
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddlePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleWithSP
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWith_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPeriod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSalePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleAll
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddle
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddlePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleWithSP
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 142
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 130
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 84
          end
          object AmountPeriod: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountPeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object SummaSalePeriod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaSalePeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'SummaMiddle'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object SummaMiddlePeriod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaMiddlePeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object SummSale_SP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_SP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            Width = 84
          end
          object SummaSaleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaSaleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            Width = 84
          end
          object SummaMiddleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaMiddleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            Width = 84
          end
          object Count_1303: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1086' '#1055#1050#1052#1059' 1303'
            DataBinding.FieldName = 'Count_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1086#1090#1087#1091#1097#1077#1085#1085#1099#1093' '#1087#1086' '#1087#1082#1084#1091' 1303'
            Width = 84
          end
          object SummSale_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1087#1091#1089#1082' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Width = 84
          end
          object AmountWith_1303: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountWith_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Width = 193
          end
          object Persent_AmountLast: TcxGridDBColumn
            AlternateCaption = '70'
            Caption = '% +/- ('#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1086#1090' '#1087#1088#1077#1076'. '#1084#1077#1089#1103#1094#1072')'
            DataBinding.FieldName = 'Persent_AmountLast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1088#1086#1089#1090#1072'/'#1087#1072#1076#1077#1085#1080#1103' '#1082#1086#1083'-'#1074#1072' '#1095#1077#1082#1086#1074' '#1074' '#1089#1088#1072#1074#1085#1077#1085#1080#1080' '#1089' '#1087#1088#1077#1076'.'#1084#1077#1089#1103#1094#1077#1084
            Options.Editing = False
            Width = 99
          end
          object SummaSaleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaSaleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Width = 187
          end
          object Persent_SummaLast: TcxGridDBColumn
            Caption = '% +/- ('#1089#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1086#1090' '#1087#1088#1077#1076'. '#1084#1077#1089#1103#1094#1072')'
            DataBinding.FieldName = 'Persent_SummaLast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = '% '#1088#1086#1089#1090#1072'/'#1087#1072#1076#1077#1085#1080#1103' '#1089#1091#1084#1084#1099' '#1089#1088'. '#1095#1077#1082#1072' '#1074' '#1089#1088#1072#1074#1085#1077#1085#1080#1080' '#1089' '#1087#1088#1077#1076'.'#1084#1077#1089#1103#1094#1077#1084
            Options.Editing = False
            Width = 100
          end
          object SummaMiddleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
            DataBinding.FieldName = 'SummaMiddleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
            Width = 186
          end
          object PersentMiddle: TcxGridDBColumn
            Caption = '%'
            DataBinding.FieldName = 'PersentMiddle'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103
            VisibleForCustomization = False
            Width = 50
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 236
        Width = 991
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        AutoSnap = True
        Control = grChart2
        ExplicitWidth = 989
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 0
        Width = 991
        Height = 8
        AlignSplitter = salTop
        AutoSnap = True
        Control = cxGrid
        ExplicitWidth = 989
      end
      object grChart2: TcxGrid
        Left = 0
        Top = 244
        Width = 991
        Height = 144
        Hint = #1044#1080#1085#1072#1084#1080#1082#1072
        Align = alBottom
        TabOrder = 3
        ExplicitWidth = 989
        object cxGridDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramColumn.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup2: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'unitname'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object cxGridDBChartSeries7: TcxGridDBChartSeries
            DataBinding.FieldName = 'AmountWith_1303'
            DisplayText = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries8: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSaleAll'
            DisplayText = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries9: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddleAll'
            DisplayText = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 991
    Height = 55
    ExplicitWidth = 989
    ExplicitHeight = 55
    inherited deStart: TcxDateEdit
      Left = 26
      EditValue = 43009d
      ExplicitLeft = 26
    end
    object ceUnit: TcxButtonEdit [1]
      Left = 316
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 3
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 314
    end
    inherited deEnd: TcxDateEdit
      Left = 141
      EditValue = 43009d
      TabOrder = 2
      ExplicitLeft = 141
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 117
      Caption = #1087#1086':'
      ExplicitLeft = 117
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 229
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object cbisDay: TcxCheckBox
      Left = 29
      Top = 30
      Action = actRefreshOnDay
      TabOrder = 6
      Width = 66
    end
    object cxLabel19: TcxLabel
      Left = 229
      Top = 31
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object ceRetail: TcxButtonEdit
      Left = 316
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 314
    end
  end
  object cbisMonth: TcxCheckBox [2]
    Left = 114
    Top = 30
    Action = actRefreshOnMonth
    TabOrder = 6
    Width = 86
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
    Left = 135
    Top = 231
    object actGridToExcel1: TdsdGridToExcel [1]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      ImageIndex = 6
      ShortCut = 16472
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckMiddle_DetailDialogForm'
      FormNameParam.Value = 'TReport_CheckMiddle_DetailDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMonth'
          Value = Null
          Component = cbisMonth
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDay'
          Value = Null
          Component = cbisDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshOnMonth: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1052#1077#1089#1103#1094#1072#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshOnDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckMiddle_Detail'
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay'
        Value = Null
        Component = cbisDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMonth'
        Value = Null
        Component = cbisMonth
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 160
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bb: TdxBarButton
      Action = actGridToExcel1
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 248
    Top = 248
  end
  inherited PopupMenu: TPopupMenu
    Left = 104
    Top = 216
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesUnit
      end>
    Left = 456
    Top = 72
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 600
    Top = 48
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
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
    Left = 544
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
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
      end>
    PackSize = 1
    Left = 656
    Top = 48
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 64
    Top = 472
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 168
    Top = 472
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 248
    Top = 480
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 512
  end
end
