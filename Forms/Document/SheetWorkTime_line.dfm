object SheetWorkTime_lineForm: TSheetWorkTime_lineForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080' *>'
  ClientHeight = 508
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
    Top = 313
    Width = 971
    Height = 63
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
        Width = 30
      end
      object MemberName: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'MemberName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
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
        Width = 123
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Width = 103
      end
      object PositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
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
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 90
    Width = 971
    Height = 215
    Align = alTop
    TabOrder = 3
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
      object MemberCode_ch1: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'MemberCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 30
      end
      object MemberName_ch1: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'MemberName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Width = 183
      end
      object DateOut_ch1: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'DateOut'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.DateButtons = [btnClear]
        Properties.DisplayFormat = 'DD.MM.YYYY'
        Properties.EditFormat = 'DD.MM.YYYY'
        Properties.ReadOnly = True
        Properties.SaveTime = False
        Properties.ShowTime = False
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        MinWidth = 70
        Options.Editing = False
        Options.Moving = False
        Width = 82
      end
      object PositionName_ch1: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Options.Moving = False
        Width = 103
      end
      object PositionLevelName_ch1: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 101
      end
      object PersonalGroupName_ch1: TcxGridDBColumn
        Caption = #1041#1088#1080#1075#1072#1076#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 73
      end
      object StorageLineName_ch1: TcxGridDBColumn
        Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
        DataBinding.FieldName = 'StorageLineName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 100
      end
      object AmountHours_ch: TcxGridDBColumn
        Caption = '1.'#1095#1072#1089#1099
        DataBinding.FieldName = 'AmountHours'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1095#1072#1089#1086#1074
        MinWidth = 15
        Options.Editing = False
        Width = 63
      end
      object CountDay_ch: TcxGridDBColumn
        Caption = '2.'#1089#1084'.'
        DataBinding.FieldName = 'CountDay'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1089#1084#1077#1085
        MinWidth = 15
        Options.Editing = False
        Width = 63
      end
      object Amount_3_ch: TcxGridDBColumn
        Caption = '3.'#1096#1090'.'#1077#1076
        DataBinding.FieldName = 'Amount_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1096#1090#1072#1090#1085#1099#1093' '#1077#1076#1080#1085#1080#1094
        MinWidth = 15
        Options.Editing = False
        Width = 58
      end
      object Amount_4_ch: TcxGridDBColumn
        Caption = '4.'#1041#1051
        DataBinding.FieldName = 'Amount_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1041#1086#1083#1100#1085#1080#1095#1085#1099#1077
        MinWidth = 15
        Options.Editing = False
        Width = 63
      end
      object Amount_5_ch: TcxGridDBColumn
        Caption = '5.'#1086#1090#1087'.'
        DataBinding.FieldName = 'Amount_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1086#1090#1087#1091#1089#1082
        MinWidth = 15
        Options.Editing = False
        Width = 63
      end
      object Amount_6_ch: TcxGridDBColumn
        Caption = '6.'#1087#1088#1086#1075'.'
        DataBinding.FieldName = 'Amount_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1075#1091#1083#1086#1074
        MinWidth = 15
        Options.Editing = False
        Width = 63
      end
      object ShortName_1: TcxGridDBColumn
        Caption = '1'
        DataBinding.FieldName = 'ShortName_1'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm1
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm2
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm3
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm4
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm5
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm6
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm7
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm8
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm9
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm10
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm11
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm12
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm13
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm14
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm15
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm16
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm17
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm18
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm19
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm20
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm21
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm22
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm23
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm24
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm25
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm26
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm27
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm28
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm29
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm30
            Default = True
            Kind = bkEllipsis
          end>
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
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenWorkTimeKindForm31
            Default = True
            Kind = bkEllipsis
          end>
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
    Top = 305
    Width = 971
    Height = 8
    AlignSplitter = salTop
    Control = cxGrid1
  end
  object cxGrid3: TcxGrid
    Left = 0
    Top = 384
    Width = 971
    Height = 124
    Align = alBottom
    TabOrder = 8
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView2: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = TotalDS
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
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Name: TcxGridDBColumn
        Caption = #1044#1072#1085#1085#1099#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 111
      end
      object Amount: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object Amount1: TcxGridDBColumn
        Caption = '1'
        DataBinding.FieldName = 'Amount_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount2: TcxGridDBColumn
        Caption = '2'
        DataBinding.FieldName = 'Amount_2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount3: TcxGridDBColumn
        Caption = '3'
        DataBinding.FieldName = 'Amount_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount4: TcxGridDBColumn
        Caption = '4'
        DataBinding.FieldName = 'Amount_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount5: TcxGridDBColumn
        Caption = '5'
        DataBinding.FieldName = 'Amount_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount6: TcxGridDBColumn
        Caption = '6'
        DataBinding.FieldName = 'Amount_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount7: TcxGridDBColumn
        Caption = '7'
        DataBinding.FieldName = 'Amount_7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount8: TcxGridDBColumn
        Caption = '8'
        DataBinding.FieldName = 'Amount_8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount9: TcxGridDBColumn
        Caption = '9'
        DataBinding.FieldName = 'Amount_9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount10: TcxGridDBColumn
        Caption = '10'
        DataBinding.FieldName = 'Amount_10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount11: TcxGridDBColumn
        Caption = '11'
        DataBinding.FieldName = 'Amount_11'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount12: TcxGridDBColumn
        Caption = '12'
        DataBinding.FieldName = 'Amount_12'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount13: TcxGridDBColumn
        Caption = '13'
        DataBinding.FieldName = 'Amount_13'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount14: TcxGridDBColumn
        Caption = '14'
        DataBinding.FieldName = 'Amount_14'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount15: TcxGridDBColumn
        Caption = '15'
        DataBinding.FieldName = 'Amount_15'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount16: TcxGridDBColumn
        Caption = '16'
        DataBinding.FieldName = 'Amount_16'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount17: TcxGridDBColumn
        Caption = '17'
        DataBinding.FieldName = 'Amount_17'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount18: TcxGridDBColumn
        Caption = '18'
        DataBinding.FieldName = 'Amount_18'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount19: TcxGridDBColumn
        Caption = '19'
        DataBinding.FieldName = 'Amount_19'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount20: TcxGridDBColumn
        Caption = '20'
        DataBinding.FieldName = 'ShortName_20'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount21: TcxGridDBColumn
        Caption = '21'
        DataBinding.FieldName = 'Amount_21'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount22: TcxGridDBColumn
        Caption = '22'
        DataBinding.FieldName = 'Amount_22'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount23: TcxGridDBColumn
        Caption = '23'
        DataBinding.FieldName = 'Amount_23'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount24: TcxGridDBColumn
        Caption = '24'
        DataBinding.FieldName = 'Amount_24'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount25: TcxGridDBColumn
        Caption = '25'
        DataBinding.FieldName = 'Amount_25'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount26: TcxGridDBColumn
        Caption = '26'
        DataBinding.FieldName = 'Amount_26'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount27: TcxGridDBColumn
        Caption = '27'
        DataBinding.FieldName = 'Amount_27'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount28: TcxGridDBColumn
        Caption = '28'
        DataBinding.FieldName = 'Amount_28'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount29: TcxGridDBColumn
        Caption = '29'
        DataBinding.FieldName = 'Amount_29'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount30: TcxGridDBColumn
        Caption = '30'
        DataBinding.FieldName = 'Amount_30'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object Amount31: TcxGridDBColumn
        Caption = '31'
        DataBinding.FieldName = 'Amount_31'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
    end
    object cxGridLevel3: TcxGridLevel
      GridView = cxGridDBTableView2
    end
  end
  object cxSplitter2: TcxSplitter
    Left = 0
    Top = 376
    Width = 971
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = cxGrid3
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
      end
      item
        DataSet = DayCDS
      end
      item
        DataSet = TotalCDS
      end>
    OutputType = otMultiDataSet
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
      Action = MovementItemProtocolOpenForm
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
    object actOpenWorkTimeKindForm2: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm2'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_2'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm3: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm3'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_3'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm4: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm4'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_4'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm5: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm5'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_5'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm6: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm6'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_6'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm7: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm7'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_7'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_7'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm8: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm8'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_8'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_8'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm9: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm9'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_9'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_9'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm10: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm10'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_10'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_10'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm11: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm11'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_11'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_11'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm12: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm12'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_12'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_12'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm13: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm13'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_13'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_13'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm14: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm14'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_14'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_14'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm15: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm15'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_15'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_15'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm16: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm16'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_16'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_16'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm17: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm17'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_17'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_17'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm18: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm18'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_18'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_18'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm19: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm19'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_19'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_19'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm20: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm20'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_20'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_20'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm21: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm21'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_21'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_21'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm22: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm22'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_22'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_22'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm23: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm23'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_23'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_23'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm24: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm24'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_24'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_24'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm25: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm2'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_25'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_25'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm26: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm26'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_26'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_26'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm27: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm27'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_27'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_27'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm28: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm28'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_28'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_28'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm29: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm29'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_29'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_29'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm30: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm30'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_30'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_30'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenWorkTimeKindForm31: TOpenChoiceForm
      Category = 'WorkTimeKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenWorkTimeKindForm31'
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DayCDS
          ComponentItem = 'WorkTimeKindId_31'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = DayCDS
          ComponentItem = 'ShortName_31'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDayDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI1
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI1
        end
        item
          StoredProc = spInsertUpdateMI2
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
    object actOpenWorkTimeKindForm1: TOpenChoiceForm
      Category = 'WorkTimeKind'
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
          Action = actOpenWorkTimeKindForm1
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
      FormName = 'TMovementItemProtocolSWTForm'
      FormNameParam.Value = 'TMovementItemProtocolSWTForm'
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
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
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
          Component = edOperDate
          DataType = ftDateTime
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
    Top = 279
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = DayDS
    PacketRecords = 0
    Params = <>
    Left = 48
    Top = 287
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
  object spInsertUpdateMI1: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SheetWorkTime_line1'
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
        Component = edOperDate
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
        Name = 'ioShortName_2'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_2'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_3'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_3'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_4'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_4'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_5'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_5'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_6'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_6'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_7'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_7'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_8'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_8'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_9'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_9'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_10'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_10'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_11'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_11'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_12'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_12'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_13'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_13'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_14'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_14'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_15'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_15'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_1_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_1_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_2_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_2_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_3_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_3_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_4_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_4_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_5_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_5_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_6_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_6_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_7_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_7_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_8_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_8_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_9_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_9_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_10_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_10_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_11_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_11_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_12_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_12_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_13_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_13_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_14_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_14_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_15_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_15_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_1'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_1'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_2'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_2'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_3'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_3'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_4'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_4'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_5'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_5'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_6'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_6'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_7'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_7'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_8'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_8'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_9'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_9'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_10'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_10'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_11'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_11'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_12'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_12'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_13'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_13'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_14'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_14'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_15'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_15'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_1_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_1_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_2_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_2_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_3_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_3_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_4_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_4_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_5_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_5_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_6_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_6_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_7_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_7_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_8_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_8_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_9_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_9_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_10_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_10_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_11_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_11_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_12_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_12_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_13_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_13_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_14_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_14_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_15_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_15_old'
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
    Left = 246
    Top = 375
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
    Left = 392
    Top = 264
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
    ObjectView = False
    Params = <>
    Left = 512
    Top = 359
  end
  object TotalDS: TDataSource
    DataSet = TotalCDS
    Left = 558
    Top = 359
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
    Left = 40
    Top = 144
  end
  object DayCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 72
    Top = 120
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
    PropertiesCellList = <>
    Left = 192
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
    Top = 391
  end
  object spInsertUpdateMI2: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SheetWorkTime_line2'
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
        Value = 42335d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_16'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_16'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_17'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_17'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_18'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_18'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_19'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_19'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_20'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_20'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_21'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_21'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_22'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_22'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_23'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_23'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_24'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_24'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_25'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_25'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_26'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_26'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_27'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_27'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_28'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_28'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_29'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_29'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_30'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_30'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_31'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_31'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_16_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_16_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_17_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_17_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_18_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_18_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_19_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_19_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_20_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_20_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_21_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_21_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_22_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_22_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_23_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_23_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_24_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_24_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_25_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_25_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_26_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_26_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_27_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_27_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_28_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_28_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_29_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_29_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_30_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_30_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_31_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_31_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_16'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_16'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_17'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_17'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_18'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_18'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_19'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_19'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_20'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_20'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_21'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_21'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_22'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_22'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_23'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_23'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_24'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_24'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_25'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_25'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_26'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_26'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_27'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_27'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_28'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_28'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_29'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_29'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_30'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_30'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_31'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_31'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_16_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_16_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_17_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_17_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_18_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_18_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_19_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_19_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_20_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_20_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_21_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_21_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_22_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_22_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_23_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_23_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_24_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_24_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_25_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_25_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_26_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_26_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_27_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_27_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_28_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_28_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_29_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_29_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_30_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_30_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_31_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_31_old'
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
    Left = 334
    Top = 359
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
        Value = 42335d
        Component = edOperDate
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
        Name = 'ioShortName_2'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_2'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_3'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_3'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_4'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_4'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_5'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_5'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_6'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_6'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_7'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_7'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_8'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_8'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_9'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_9'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_10'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_10'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_11'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_11'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_12'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_12'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_13'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_13'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_14'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_14'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_15'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_15'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_16'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_16'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_17'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_17'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_18'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_18'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_19'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_19'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_20'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_20'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_21'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_21'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_22'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_22'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_23'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_23'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_24'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_24'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_25'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_25'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_26'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_26'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_27'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_27'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_28'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_28'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_29'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_29'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_30'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_30'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_31'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_31'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_1_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_1_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_2_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_2_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_3_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_3_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_4_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_4_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_5_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_5_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_6_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_6_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_7_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_7_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_8_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_8_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_9_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_9_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_10_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_10_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_11_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_11_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_12_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_12_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_13_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_13_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_14_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_14_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_15_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_15_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_16_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_16_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_17_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_17_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_18_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_18_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_19_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_19_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_20_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_20_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_21_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_21_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_22_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_22_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_23_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_23_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_24_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_24_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_25_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_25_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_26_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_26_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_27_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_27_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_28_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_28_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_29_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_29_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_30_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_30_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioShortName_31_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'ShortName_31_old'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_1'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_1'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_2'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_2'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_3'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_3'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_4'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_4'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_5'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_5'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_6'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_6'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_7'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_7'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_8'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_8'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_9'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_9'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_10'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_10'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_11'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_11'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_12'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_12'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_13'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_13'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_14'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_14'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_15'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_15'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_16'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_16'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_17'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_17'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_18'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_18'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_19'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_19'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_20'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_20'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_21'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_21'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_22'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_22'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_23'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_23'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_24'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_24'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_25'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_25'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_26'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_26'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_27'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_27'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_28'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_28'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_29'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_29'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_30'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_30'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_31'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_31'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_1_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_1_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_2_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_2_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_3_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_3_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_4_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_4_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_5_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_5_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_6_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_6_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_7_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_7_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_8_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_8_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_9_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_9_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_10_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_10_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_11_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_11_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_12_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_12_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_13_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_13_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_14_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_14_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_15_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_15_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_16_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_16_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_17_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_17_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_18_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_18_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_19_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_19_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_20_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_20_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_21_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_21_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_22_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_22_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_23_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_23_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_24_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_24_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_25_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_25_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_26_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_26_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_27_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_27_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_28_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_28_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_29_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_29_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_30_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_30_old'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_31_old'
        Value = Null
        Component = DayCDS
        ComponentItem = 'WorkTimeKindId_31_old'
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
    Left = 238
    Top = 319
  end
  object dsdDBViewAddOn_total: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
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
    Left = 560
    Top = 416
  end
end
