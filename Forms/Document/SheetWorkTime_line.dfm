object SheetWorkTime_lineForm: TSheetWorkTime_lineForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080' *>'
  ClientHeight = 462
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 971
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edOperDate: TcxDateEdit
      Left = 1
      Top = 20
      EditValue = 42335d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 108
    end
    object cxLabel2: TcxLabel
      Left = 1
      Top = 2
      Caption = #1044#1072#1090#1072
    end
    object edUnit: TcxButtonEdit
      Left = 115
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.Color = clWhite
      TabOrder = 0
      Width = 278
    end
    object cxLabel4: TcxLabel
      Left = 115
      Top = 2
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cbCheckedHead: TcxCheckBox
      Left = 430
      Top = 7
      Hint = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 165
    end
    object edCheckedHead_date: TcxDateEdit
      Left = 609
      Top = 7
      EditValue = 44417d
      Properties.AssignedValues.DisplayFormat = True
      Properties.Kind = ckDateTime
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 120
    end
    object edCheckedHead: TcxTextEdit
      Left = 735
      Top = 7
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 226
    end
    object cbCheckedPersonal: TcxCheckBox
      Left = 430
      Top = 33
      Hint = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 173
    end
    object edCheckedPersonal_date: TcxDateEdit
      Left = 609
      Top = 33
      EditValue = 44417d
      Properties.AssignedValues.DisplayFormat = True
      Properties.Kind = ckDateTime
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 120
    end
    object edCheckedPersonal: TcxTextEdit
      Left = 735
      Top = 33
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 226
    end
  end
  object cxGrid2: TcxGrid
    Left = 0
    Top = 90
    Width = 971
    Height = 254
    Align = alClient
    TabOrder = 1
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
      DataController.Filter.TranslateBetween = True
      DataController.Filter.TranslateIn = True
      DataController.Filter.TranslateLike = True
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
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.###;-,0.###; ;'
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
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
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
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object MemberCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'MemberCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Width = 30
      end
      object MemberName: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'MemberName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Options.Filtering = False
        Width = 183
      end
      object DateOut: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'DateOut'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.DateButtons = [btnClear]
        Properties.DisplayFormat = 'DD.MM.YYYY'
        Properties.EditFormat = 'DD.MM.YYYY'
        Properties.ReadOnly = True
        Properties.SaveTime = False
        Properties.ShowTime = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        MinWidth = 70
        Options.Editing = False
        Options.Filtering = False
        Width = 123
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Options.Filtering = False
        Width = 103
      end
      object PositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Filtering = False
        Width = 101
      end
      object PersonalGroupName: TcxGridDBColumn
        Caption = #1041#1088#1080#1075#1072#1076#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Filtering = False
        Width = 73
      end
      object StorageLineName: TcxGridDBColumn
        Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
        DataBinding.FieldName = 'StorageLineName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Filtering = False
        Width = 127
      end
      object WorkTimeKindName_key: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1089#1084'.'
        DataBinding.FieldName = 'WorkTimeKindName_key'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1080#1076' '#1089#1084#1077#1085#1099
        Options.Editing = False
        Width = 34
      end
      object AmountHours: TcxGridDBColumn
        Caption = '1.'#1095#1072#1089#1099
        DataBinding.FieldName = 'AmountHours'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1095#1072#1089#1086#1074
        MinWidth = 15
        Options.Editing = False
        Options.Filtering = False
        Width = 48
      end
      object CountDay: TcxGridDBColumn
        Caption = '2.'#1089#1084'.'
        DataBinding.FieldName = 'CountDay'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1089#1084#1077#1085
        MinWidth = 15
        Options.Editing = False
        Options.Filtering = False
        Width = 43
      end
      object Amount_3: TcxGridDBColumn
        Caption = '3.'#1096#1090'.'#1077#1076
        DataBinding.FieldName = 'Amount_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1096#1090#1072#1090#1085#1099#1093' '#1077#1076#1080#1085#1080#1094
        MinWidth = 15
        Options.Editing = False
        Options.Filtering = False
        Width = 58
      end
      object Amount_4: TcxGridDBColumn
        Caption = '4.'#1041#1051
        DataBinding.FieldName = 'Amount_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1041#1086#1083#1100#1085#1080#1095#1085#1099#1077
        MinWidth = 15
        Options.Editing = False
        Options.Filtering = False
        Width = 64
      end
      object Amount_5: TcxGridDBColumn
        Caption = '5.'#1086#1090#1087'.'
        DataBinding.FieldName = 'Amount_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1086#1090#1087#1091#1089#1082
        MinWidth = 15
        Options.Editing = False
        Options.Filtering = False
        Width = 64
      end
      object Amount_6: TcxGridDBColumn
        Caption = '6.'#1087#1088#1086#1075'.'
        DataBinding.FieldName = 'Amount_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1075#1091#1083#1086#1074
        MinWidth = 15
        Options.Editing = False
        Options.Filtering = False
        Width = 64
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 352
    Width = 971
    Height = 110
    Align = alBottom
    TabOrder = 6
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DayDS
      DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
      DataController.Filter.TranslateBetween = True
      DataController.Filter.TranslateIn = True
      DataController.Filter.TranslateLike = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ShortName_1: TcxGridDBColumn
        Caption = '1'
        DataBinding.FieldName = 'ShortName_1'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_1: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_1'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_2: TcxGridDBColumn
        Caption = '2'
        DataBinding.FieldName = 'ShortName_2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_2: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_2'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_3: TcxGridDBColumn
        Caption = '3'
        DataBinding.FieldName = 'ShortName_3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_3: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_3'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_4: TcxGridDBColumn
        Caption = '4'
        DataBinding.FieldName = 'ShortName_4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_4: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_4'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_5: TcxGridDBColumn
        Caption = '5'
        DataBinding.FieldName = 'ShortName_5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_5: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_5'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_6: TcxGridDBColumn
        Caption = '6'
        DataBinding.FieldName = 'ShortName_6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_6: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_6'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_7: TcxGridDBColumn
        Caption = '7'
        DataBinding.FieldName = 'ShortName_7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_7: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_7'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_8: TcxGridDBColumn
        Caption = '8'
        DataBinding.FieldName = 'ShortName_8'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_8: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_8'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_9: TcxGridDBColumn
        Caption = '9'
        DataBinding.FieldName = 'ShortName_9'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_9: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_9'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_10: TcxGridDBColumn
        Caption = '10'
        DataBinding.FieldName = 'ShortName_10'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_10: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_10'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_11: TcxGridDBColumn
        Caption = '11'
        DataBinding.FieldName = 'ShortName_11'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_11: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_11'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_12: TcxGridDBColumn
        Caption = '12'
        DataBinding.FieldName = 'ShortName_12'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_12: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_12'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_13: TcxGridDBColumn
        Caption = '13'
        DataBinding.FieldName = 'ShortName_13'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_13: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_13'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_14: TcxGridDBColumn
        Caption = '14'
        DataBinding.FieldName = 'ShortName_14'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_14: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_14'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_15: TcxGridDBColumn
        Caption = '15'
        DataBinding.FieldName = 'ShortName_15'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_15: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_15'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_16: TcxGridDBColumn
        Caption = '16'
        DataBinding.FieldName = 'ShortName_16'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_16: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_16'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_17: TcxGridDBColumn
        Caption = '17'
        DataBinding.FieldName = 'ShortName_17'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_17: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_17'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_18: TcxGridDBColumn
        Caption = '18'
        DataBinding.FieldName = 'ShortName_18'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_18: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_18'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_19: TcxGridDBColumn
        Caption = '19'
        DataBinding.FieldName = 'ShortName_19'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_19: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_19'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_20: TcxGridDBColumn
        Caption = '20'
        DataBinding.FieldName = 'ShortName_20'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_20: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_20'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_21: TcxGridDBColumn
        Caption = '21'
        DataBinding.FieldName = 'ShortName_21'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_21: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_21'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_22: TcxGridDBColumn
        Caption = '22'
        DataBinding.FieldName = 'ShortName_22'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_22: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_22'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_23: TcxGridDBColumn
        Caption = '23'
        DataBinding.FieldName = 'ShortName_23'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_23: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_23'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_24: TcxGridDBColumn
        Caption = '24'
        DataBinding.FieldName = 'ShortName_24'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_24: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_24'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_25: TcxGridDBColumn
        Caption = '25'
        DataBinding.FieldName = 'ShortName_25'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_25: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_25'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_26: TcxGridDBColumn
        Caption = '26'
        DataBinding.FieldName = 'ShortName_26'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_26: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_26'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_27: TcxGridDBColumn
        Caption = '27'
        DataBinding.FieldName = 'ShortName_27'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_27: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_27'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_28: TcxGridDBColumn
        Caption = '28'
        DataBinding.FieldName = 'ShortName_28'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_28: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_28'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_29: TcxGridDBColumn
        Caption = '29'
        DataBinding.FieldName = 'ShortName_29'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_29: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_29'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_30: TcxGridDBColumn
        Caption = '30'
        DataBinding.FieldName = 'ShortName_30'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_30: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_30'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
      object ShortName_31: TcxGridDBColumn
        Caption = '31'
        DataBinding.FieldName = 'ShortName_31'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Color_Calc_31: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc_31'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
        Width = 40
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 344
    Width = 971
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
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
      end>
    Left = 214
    Top = 223
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_SheetWorkTime_line'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inDate'
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
        Name = 'inisErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 143
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
    Left = 342
    Top = 135
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
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbUpdate'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMISetErased'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbLoadFromTransport'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCheckedHead'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCheckedPersonal'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenProtocolPersonal'
        end
        item
          Visible = True
          ItemName = 'bbOpenProtocolMember'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbUpdate: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbLoadFromTransport: TdxBarButton
      Action = actInsertUpdate_SheetWorkTime_FromTransport
      Category = 0
    end
    object bbMISetErased: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object bbMISetUnErased: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbUpdateCheckedHead: TdxBarButton
      Action = macUpdateCheckedHead
      Category = 0
    end
    object bbUpdateCheckedPersonal: TdxBarButton
      Action = macUpdateCheckedPersonal
      Category = 0
    end
    object bbMovementItemProtocolOpenForm: TdxBarButton
      Action = macMovementItemProtocolOpenForm
      Category = 0
    end
    object bbOpenProtocolMember: TdxBarButton
      Action = actOpenProtocolMember
      Category = 0
    end
    object bbOpenProtocolPersonal: TdxBarButton
      Action = actOpenProtocolPersonal
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Width')
      end
      item
        Properties.Strings = (
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Width')
      end
      item
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Properties.Strings = (
          'Visible'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 481
    Top = 160
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 403
    Top = 143
    object actUpdateDayDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI
        end>
      Caption = 'actUpdateDayDS'
      DataSource = DayDS
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
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
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
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actOpenWorkTimeKindForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_1'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshGet: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMI_days
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenWorkTimeKindForm
        end
        item
          Action = actUpdateDayDS
        end>
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1074' '#1090#1072#1073#1077#1083#1100
      ImageIndex = 0
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
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
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldMemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionLevelId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPersonalGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldStorageLineId'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1074' '#1090#1072#1073#1077#1083#1100
      ImageIndex = 27
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
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
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldMemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionLevelId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPersonalGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldStorageLineId'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      ImageIndex = 1
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
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
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldMemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldStorageLineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertUpdate_SheetWorkTime_FromTransport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_SheetWorkTime_FromTransport
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_SheetWorkTime_FromTransport
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074
      ImageIndex = 41
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
    end
    object actMISetErased: TdsdUpdateErased
      Category = 'DSDLib'
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
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
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
    object actUpdate_CheckedHead: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CheckedHead
      StoredProcList = <
        item
          StoredProc = spUpdate_CheckedHead
        end>
      Caption = 'actUpdate_CheckedHead'
      ImageIndex = 76
    end
    object actUpdate_CheckedPersonal: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CheckedPersonal
      StoredProcList = <
        item
          StoredProc = spUpdate_CheckedPersonal
        end>
      Caption = 'actUpdate_CheckedHead'
      ImageIndex = 77
    end
    object macUpdateCheckedHead: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CheckedHead
        end
        item
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084'>?'
      InfoAfterExecute = #1055#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084'> '#1080#1079#1084#1077#1085#1077#1085
      Caption = 'macUpdateCheckedHead'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084'>'
      ImageIndex = 76
    end
    object macUpdateCheckedPersonal: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CheckedPersonal
        end
        item
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072'>?'
      InfoAfterExecute = #1055#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072'> '#1080#1079#1084#1077#1085#1077#1085
      Caption = 'macUpdateCheckedHead'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072'>'
      ImageIndex = 77
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
          Component = FormParams
          ComponentItem = 'outMovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'outOperDate'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macMovementItemProtocolOpenForm: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_byProtocol
        end
        item
          Action = MovementItemProtocolOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
    end
    object actGet_byProtocol: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = Get_byProtocol
      StoredProcList = <
        item
          StoredProc = Get_byProtocol
        end>
      Caption = 'actGet_byProtocol'
      ImageIndex = 34
    end
    object actOpenProtocolMember: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1060#1080#1079'.'#1083#1080#1094#1086'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1060#1080#1079'.'#1083#1080#1094#1086'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenProtocolPersonal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 94
    Top = 127
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 159
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_SheetWorkTimeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_SheetWorkTimeForm'
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
    Left = 200
    Top = 8
  end
  object spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SheetWorkTime_line'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = HeaderCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_1'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_1'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId_1'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_key'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId_key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPersonalGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 254
    Top = 359
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 240
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = edOperDate
      end
      item
        Component = GuidesUnit
      end>
    Left = 344
    Top = 16
  end
  object spInsertUpdate_SheetWorkTime_FromTransport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_SheetWorkTime_FromTransport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
      end>
    PackSize = 1
    Left = 400
    Top = 296
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMI_SheetWorkTime_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId_key'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId_key'
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
        Name = 'ioIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 518
    Top = 207
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SheetWorkTime_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCheckedHead'
        Value = False
        Component = cbCheckedHead
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCheckedPersonal'
        Value = 0d
        Component = cbCheckedPersonal
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedHead_date'
        Value = 'null'
        Component = edCheckedHead_date
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedPersonal_date'
        Value = Null
        Component = edCheckedPersonal_date
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedHeadName'
        Value = ''
        Component = edCheckedHead
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedPersonalName'
        Value = ''
        Component = edCheckedPersonal
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 112
  end
  object spUpdate_CheckedHead: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SheetWorkTime_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
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
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChecked'
        Value = False
        Component = cbCheckedHead
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_MovementBoolean_CheckedHead'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 112
  end
  object spUpdate_CheckedPersonal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SheetWorkTime_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChecked'
        Value = False
        Component = cbCheckedPersonal
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_MovementBoolean_CheckedPersonal'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 152
  end
  object TotalCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = MasterDS
    ObjectView = False
    PacketRecords = 0
    Params = <>
    Left = 512
    Top = 367
  end
  object TotalDS: TDataSource
    DataSet = TotalCDS
    Left = 582
    Top = 359
  end
  object CrossDBViewAddOnTotal: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    Left = 624
    Top = 400
  end
  object Get_byProtocol: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_SheetWorkTime_byProtocol'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId_key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = HeaderCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'outMovementId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'outMovementItemId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'outOperDate'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 822
    Top = 215
  end
  object DayDS: TDataSource
    DataSet = DayCDS
    Left = 48
    Top = 288
  end
  object DayCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 104
    Top = 280
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 144
    Top = 144
  end
  object dsdDBViewAddOn_days: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = ShortName_1
        BackGroundValueColumn = Color_Calc_1
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_2
        BackGroundValueColumn = Color_Calc_2
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_3
        BackGroundValueColumn = Color_Calc_3
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_4
        BackGroundValueColumn = Color_Calc_4
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_5
        BackGroundValueColumn = Color_Calc_5
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_6
        BackGroundValueColumn = Color_Calc_6
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_7
        BackGroundValueColumn = Color_Calc_7
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_8
        BackGroundValueColumn = Color_Calc_8
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_9
        BackGroundValueColumn = Color_Calc_9
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_10
        BackGroundValueColumn = Color_Calc_10
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_11
        BackGroundValueColumn = Color_Calc_11
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_12
        BackGroundValueColumn = Color_Calc_12
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_13
        BackGroundValueColumn = Color_Calc_13
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_14
        BackGroundValueColumn = Color_Calc_14
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_15
        BackGroundValueColumn = Color_Calc_15
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_16
        BackGroundValueColumn = Color_Calc_16
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_17
        BackGroundValueColumn = Color_Calc_17
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_18
        BackGroundValueColumn = Color_Calc_18
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_19
        BackGroundValueColumn = Color_Calc_19
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_20
        BackGroundValueColumn = Color_Calc_20
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_21
        BackGroundValueColumn = Color_Calc_21
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_22
        BackGroundValueColumn = Color_Calc_22
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_23
        BackGroundValueColumn = Color_Calc_23
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_24
        BackGroundValueColumn = Color_Calc_24
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_25
        BackGroundValueColumn = Color_Calc_25
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_26
        BackGroundValueColumn = Color_Calc_26
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_27
        BackGroundValueColumn = Color_Calc_27
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_28
        BackGroundValueColumn = Color_Calc_28
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_29
        BackGroundValueColumn = Color_Calc_29
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_30
        BackGroundValueColumn = Color_Calc_30
        ColorValueList = <>
      end
      item
        ColorColumn = ShortName_31
        BackGroundValueColumn = Color_Calc_31
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    KeepSelectColor = True
    PropertiesCellList = <>
    Left = 160
    Top = 280
  end
  object spSelectMI_days: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_SheetWorkTime_line'
    DataSet = DayCDS
    DataSets = <
      item
        DataSet = DayCDS
      end>
    Params = <
      item
        Name = 'inDate'
        Value = 42335d
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
        Name = 'inisErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 367
  end
end
