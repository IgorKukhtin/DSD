object Report_WageWarehouseBranchForm: TReport_WageWarehouseBranchForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1047#1055' '#1057#1082#1083#1072#1076'  '#1092#1080#1083#1080#1072#1083'>'
  ClientHeight = 496
  ClientWidth = 1295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 84
    Width = 1295
    Height = 412
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI_1
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountStick_2
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement_1
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg_1
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_3
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI1_3
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_3
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_4
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_4
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_5
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement_1_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI_1_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg_1_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountStick_2_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_3_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI1_3_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_3_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_4_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_4_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_5_koef
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI_1
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountStick_2
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement_1
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg_1
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_3
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI1_3
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_3
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_4
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_4
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_5
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement_1_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI_1_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg_1_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountStick_2_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_3_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMI1_3_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_3_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = CountMovement1_4_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_4_koef
        end
        item
          Format = ',0.'
          Kind = skSum
          Column = TotalCountKg1_5_koef
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
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PersonalCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PersonalCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 169
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 180
      end
      object PositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
        DataBinding.FieldName = 'PositionLevelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 113
      end
      object CountMovement_1: TcxGridDBColumn
        Caption = '1.1. '#1044#1086#1082#1091#1084#1077#1085#1090
        DataBinding.FieldName = 'CountMovement_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103' - '#1073#1072#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Options.Editing = False
        Width = 70
      end
      object CountMovement_1_koef: TcxGridDBColumn
        Caption = '1.1. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'CountMovement_1_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Options.Editing = False
        Width = 70
      end
      object CountMI_1: TcxGridDBColumn
        Caption = '1.2. '#1040#1088#1090#1080#1082#1091#1083
        DataBinding.FieldName = 'CountMI_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103' - '#1073#1072#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
        Options.Editing = False
        Width = 70
      end
      object CountMI_1_koef: TcxGridDBColumn
        Caption = '1.2. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'CountMI_1_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
        Options.Editing = False
        Width = 70
      end
      object TotalCountKg_1: TcxGridDBColumn
        Caption = '1.3. '#1042#1077#1089','#1082#1075
        DataBinding.FieldName = 'TotalCountKg_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103' - '#1073#1072#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Options.Editing = False
        Width = 70
      end
      object TotalCountKg_1_koef: TcxGridDBColumn
        Caption = '1.3. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'TotalCountKg_1_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Options.Editing = False
        Width = 70
      end
      object TotalCountStick_2: TcxGridDBColumn
        Caption = '2. '#1050#1086#1083'-'#1074#1086' '#1057#1090#1080#1082#1077#1088#1086#1074
        DataBinding.FieldName = 'TotalCountStick_2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1090#1080#1082#1077#1088#1086#1074#1082#1072' - '#1073#1072#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1059#1087#1072#1082#1086#1074#1086#1082
        Options.Editing = False
        Width = 70
      end
      object TotalCountStick_2_koef: TcxGridDBColumn
        Caption = '2. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'TotalCountStick_2_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1090#1080#1082#1077#1088#1086#1074#1082#1072' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1059#1087#1072#1082#1086#1074#1086#1082
        Options.Editing = False
        Width = 70
      end
      object CountMovement1_3: TcxGridDBColumn
        Caption = '3.1. '#1044#1086#1082#1091#1084#1077#1085#1090
        DataBinding.FieldName = 'CountMovement1_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'+'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103' - '#1073#1072#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Width = 70
      end
      object CountMovement1_3_koef: TcxGridDBColumn
        Caption = '3.1. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'CountMovement1_3_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'+'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Width = 70
      end
      object CountMI1_3: TcxGridDBColumn
        Caption = '3.2. '#1040#1088#1090#1080#1082#1091#1083
        DataBinding.FieldName = 'CountMI1_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'+'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103' - '#1073#1072#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
        Width = 70
      end
      object CountMI1_3_koef: TcxGridDBColumn
        Caption = '3.2. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'CountMI1_3_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'+'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
        Width = 70
      end
      object TotalCountKg1_3: TcxGridDBColumn
        Caption = '3.3. '#1042#1077#1089','#1082#1075
        DataBinding.FieldName = 'TotalCountKg1_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'+'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103' - '#1073#1072#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Width = 70
      end
      object TotalCountKg1_3_koef: TcxGridDBColumn
        Caption = '3.3. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'TotalCountKg1_3_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'+'#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1103' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Width = 70
      end
      object CountMovement1_4: TcxGridDBColumn
        Caption = '4.1. '#1044#1086#1082#1091#1084#1077#1085#1090
        DataBinding.FieldName = 'CountMovement1_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1085#1072' '#1092#1080#1083#1080#1072#1083' - '#1073#1072#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Width = 70
      end
      object CountMovement1_4_koef: TcxGridDBColumn
        Caption = '4.1. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'CountMovement1_4_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1085#1072' '#1092#1080#1083#1080#1072#1083' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
        Width = 70
      end
      object TotalCountKg1_4: TcxGridDBColumn
        Caption = '4.2. '#1042#1077#1089','#1082#1075
        DataBinding.FieldName = 'TotalCountKg1_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1085#1072' '#1092#1080#1083#1080#1072#1083' - '#1073#1072#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Width = 70
      end
      object TotalCountKg1_4_koef: TcxGridDBColumn
        Caption = '4.2. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'TotalCountKg1_4_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1085#1072' '#1092#1080#1083#1080#1072#1083' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Width = 70
      end
      object TotalCountKg1_5: TcxGridDBColumn
        Caption = '5. '#1042#1077#1089','#1082#1075
        DataBinding.FieldName = 'TotalCountKg1_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1074' '#1044#1085#1077#1087#1088' - '#1073#1072#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Width = 70
      end
      object TotalCountKg1_5_koef: TcxGridDBColumn
        Caption = '5. '#1057#1091#1084#1084#1072
        DataBinding.FieldName = 'TotalCountKg1_5_koef'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.#;-,0.#; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090#1099' '#1074' '#1044#1085#1077#1087#1088' - '#1057#1091#1084#1084#1072' '#1079#1072' '#1042#1077#1089' '#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1295
    Height = 58
    Align = alTop
    TabOrder = 2
    object deStart: TcxDateEdit
      Left = 60
      Top = 5
      EditValue = 44927d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 44927d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 85
    end
    object edPersonal: TcxButtonEdit
      Left = 473
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 203
    end
    object cxLabel3: TcxLabel
      Left = 406
      Top = 6
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082':'
    end
    object edPosition: TcxButtonEdit
      Left = 473
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 203
    end
    object cxLabel4: TcxLabel
      Left = 405
      Top = 31
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
    end
    object cxLabel5: TcxLabel
      Left = 13
      Top = 6
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object cxLabel6: TcxLabel
      Left = 6
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object vbKoef_11: TcxCurrencyEdit
      Left = 807
      Top = 5
      EditValue = 0.100000000000000000
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 2
      TabOrder = 8
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 35
    end
    object Код: TcxLabel
      Left = 714
      Top = 8
      Caption = '1.'#1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103':'
    end
    object vbKoef_12: TcxCurrencyEdit
      Left = 846
      Top = 5
      EditValue = 0.300000000000000000
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 2
      TabOrder = 10
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 35
    end
    object vbKoef_13: TcxCurrencyEdit
      Left = 885
      Top = 5
      EditValue = 0.150000000000000000
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 2
      TabOrder = 11
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 35
    end
    object cxLabel7: TcxLabel
      Left = 998
      Top = 8
      Caption = '2.'#1057#1090#1080#1082#1077#1088':'
    end
    object cxLabel8: TcxLabel
      Left = 709
      Top = 31
      Caption = '3.'#1042#1079#1074#1077#1096#1080#1074'.+'#1076#1086#1082'.:'
    end
    object vbKoef_31: TcxCurrencyEdit
      Left = 807
      Top = 30
      EditValue = 0.400000000000000000
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 2
      TabOrder = 14
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 35
    end
    object vbKoef_32: TcxCurrencyEdit
      Left = 845
      Top = 30
      EditValue = 0.300000000000000000
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 2
      TabOrder = 15
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 35
    end
    object vbKoef_33: TcxCurrencyEdit
      Left = 885
      Top = 30
      EditValue = 0.220000000000000000
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 2
      TabOrder = 16
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 35
    end
    object cxLabel9: TcxLabel
      Left = 930
      Top = 31
      Caption = '4.'#1042#1086#1079#1074#1088#1072#1090#1099' '#1085#1072' '#1060#1080#1083#1080#1072#1083':'
    end
    object cbIsDay: TcxCheckBox
      Left = 167
      Top = 29
      Action = actIsDay
      Properties.ReadOnly = False
      TabOrder = 18
      Width = 74
    end
  end
  object cxLabel1: TcxLabel
    Left = 151
    Top = 6
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit
    Left = 197
    Top = 3
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 198
  end
  object cxLabel2: TcxLabel
    Left = 1141
    Top = 31
    Caption = '5.'#1042#1086#1079#1074#1088'. '#1085#1072' '#1044#1085#1077#1087#1088':'
  end
  object vbKoef_41: TcxCurrencyEdit
    Left = 1055
    Top = 30
    EditValue = 0.400000000000000000
    Properties.AssignedValues.DisplayFormat = True
    Properties.DecimalPlaces = 2
    TabOrder = 5
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 35
  end
  object vbKoef_42: TcxCurrencyEdit
    Left = 1093
    Top = 30
    EditValue = 0.200000000000000000
    Properties.AssignedValues.DisplayFormat = True
    Properties.DecimalPlaces = 2
    TabOrder = 6
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 35
  end
  object vbKoef_22: TcxCurrencyEdit
    Left = 1054
    Top = 5
    EditValue = 0.100000000000000000
    Properties.AssignedValues.DisplayFormat = True
    Properties.DecimalPlaces = 2
    TabOrder = 7
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 35
  end
  object vbKoef_43: TcxCurrencyEdit
    Left = 1244
    Top = 30
    EditValue = 0.200000000000000000
    Properties.AssignedValues.DisplayFormat = True
    Properties.DecimalPlaces = 2
    TabOrder = 12
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 35
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 248
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 96
    Top = 176
  end
  object cxPropertiesStore: TcxPropertiesStore
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
        Component = PersonalGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PositionGuides
        Properties.Strings = (
          'Key'
          'TextValue')
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
        Component = BranchGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 312
    Top = 232
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
    Left = 128
    Top = 264
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrintBy_Goods: TdxBarButton
      Action = actPrint1
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Hint = '   '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrint3: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbIsDay: TdxBarControlContainerItem
      Caption = 'bbIsDay'
      Category = 0
      Hint = 'bbIsDay'
      Visible = ivAlways
    end
    object bbIsMovement: TdxBarControlContainerItem
      Caption = 'bbIsMovement'
      Category = 0
      Hint = 'bbIsMovement'
      Visible = ivAlways
    end
    object bbisMonth: TdxBarControlContainerItem
      Caption = 'bbisMonth'
      Category = 0
      Hint = 'bbisMonth'
      Visible = ivAlways
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
    object actRefreshMov: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = gpGet_Koeff
      StoredProcList = <
        item
          StoredProc = gpGet_Koeff
        end
        item
          StoredProc = spReport
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
      StoredProc = gpGet_Koeff
      StoredProcList = <
        item
          StoredProc = gpGet_Koeff
        end
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_WageWarehouseBranchDialogForm'
      FormNameParam.Value = 'TReport_WageWarehouseBranchDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Name = 'PersonalId'
          Value = ''
          Component = PersonalGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = ''
          Component = PersonalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = ''
          Component = PositionGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = ''
          Component = PositionGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = Null
          Component = BranchGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = BranchGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsDay'
          Value = Null
          Component = cbIsDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsMovement'
          Value = Null
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisDoc'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMonth'
          Value = Null
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object SaleJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SaleJournal'
      FormName = 'TMovementGoodsJournalForm'
      FormNameParam.Value = 'TMovementGoodsJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = 0
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
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
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId_Detail'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_Detail'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = Null
          Component = PersonalGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = PersonalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SaleDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actIsMonth: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1086' '#1084#1077#1089#1103#1094#1072#1084
      Hint = #1055#1086' '#1084#1077#1089#1103#1094#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actIsDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1086' '#1076#1085#1103#1084
      Hint = #1055#1086' '#1076#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'operDate;PersonalName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = ''
          Component = PersonalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = ''
          Component = PositionGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsDay'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrint'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
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
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'operDate;PersonalName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = ''
          Component = PersonalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = ''
          Component = PositionGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsDay'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrint'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_WageWarehouseBranch'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inPersonalId'
        Value = '0'
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = '0'
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = '0'
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDay'
        Value = Null
        Component = cbIsDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_11'
        Value = Null
        Component = vbKoef_11
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_12'
        Value = Null
        Component = vbKoef_12
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_13'
        Value = False
        Component = vbKoef_13
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_22'
        Value = Null
        Component = vbKoef_22
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_31'
        Value = Null
        Component = vbKoef_31
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_32'
        Value = Null
        Component = vbKoef_32
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_33'
        Value = False
        Component = vbKoef_33
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_41'
        Value = Null
        Component = vbKoef_41
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_42'
        Value = Null
        Component = vbKoef_42
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoef_43'
        Value = False
        Component = vbKoef_43
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 176
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <
      item
        Action = SaleJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 432
    Top = 344
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 288
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPosition
    Key = '0'
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 65528
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
    Top = 176
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    Key = '0'
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 304
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = PersonalGuides
      end
      item
        Component = PositionGuides
      end
      item
        Component = deEnd
      end
      item
        Component = deStart
      end
      item
        Component = BranchGuides
      end
      item
      end
      item
      end>
    Left = 144
    Top = 344
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inIsDay'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 224
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceCorrectiveDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceCorrectiveDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangeCurrencyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ChangeCurrencyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 264
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    Key = '0'
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 560
    Top = 16
  end
  object gpGet_Koeff: TdsdStoredProc
    StoredProcName = 'gpGetReport_WageWarehouseBranch'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_11'
        Value = Null
        Component = vbKoef_11
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_12'
        Value = Null
        Component = vbKoef_12
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_13'
        Value = Null
        Component = vbKoef_13
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_22'
        Value = Null
        Component = vbKoef_22
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_31'
        Value = Null
        Component = vbKoef_31
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_32'
        Value = Null
        Component = vbKoef_32
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_33'
        Value = Null
        Component = vbKoef_33
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_41'
        Value = Null
        Component = vbKoef_41
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_42'
        Value = Null
        Component = vbKoef_42
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'koeff_43'
        Value = Null
        Component = vbKoef_43
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 176
  end
end
