object PartionCellForm: TPartionCellForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103'> ('#1074#1089#1077')'
  ClientHeight = 376
  ClientWidth = 958
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 958
    Height = 350
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
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
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code_l1: TcxGridDBColumn
        Caption = '1.1 '#1050#1086#1076
        DataBinding.FieldName = 'Code_l1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '1.1 '#1050#1086#1076' '#1103#1095#1077#1081#1082#1080
        Options.Editing = False
        Width = 58
      end
      object Name_l1: TcxGridDBColumn
        Caption = '1.1 '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'Name_l1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l1: TcxGridDBColumn
        Caption = '1.2.  '#1050#1086#1083'-'#1074#1086' '#1045'2'
        DataBinding.FieldName = 'BoxCount_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '1.2 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        Width = 135
      end
      object Length_l1: TcxGridDBColumn
        Caption = '1.3. '#1044#1083#1080#1085#1072
        DataBinding.FieldName = 'Length_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '1.3 '#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Width_l1: TcxGridDBColumn
        Caption = '1.4 '#1064#1080#1088#1080#1085#1072
        DataBinding.FieldName = 'Width_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '1.4 '#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Height_l1: TcxGridDBColumn
        Caption = '1.5 '#1042#1099#1089#1086#1090#1072
        DataBinding.FieldName = 'Height_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '1.5 '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object RowBoxCount_l1: TcxGridDBColumn
        Caption = '1.6 '#1071#1097'. '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '1.6 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        Options.Editing = False
        Width = 99
      end
      object RowWidth_l1: TcxGridDBColumn
        Caption = '1.7. '#1075#1083#1091#1073#1080#1085#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowWidth_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '1.7 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        Options.Editing = False
        Width = 90
      end
      object RowHeight_l1: TcxGridDBColumn
        Caption = '1.8. '#1074#1099#1089#1086#1090#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowHeight_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '1.8 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        Options.Editing = False
        Width = 90
      end
      object Comment_l1: TcxGridDBColumn
        Caption = '1.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l1'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object Code_l2: TcxGridDBColumn
        Caption = '2.1 '#1050#1086#1076
        DataBinding.FieldName = 'Code_l2'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '2.1 '#1050#1086#1076' '#1103#1095#1077#1081#1082#1080
        Options.Editing = False
        Width = 55
      end
      object Name_l2: TcxGridDBColumn
        Caption = '2.1 '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'Name_l2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l2: TcxGridDBColumn
        Caption = '2.2.  '#1050#1086#1083'-'#1074#1086' '#1045'2'
        DataBinding.FieldName = 'BoxCount_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '2.2 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        Width = 135
      end
      object Length_l2: TcxGridDBColumn
        Caption = '2.3. '#1044#1083#1080#1085#1072
        DataBinding.FieldName = 'Length_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '2.3 '#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Width_l2: TcxGridDBColumn
        Caption = '2.4 '#1064#1080#1088#1080#1085#1072
        DataBinding.FieldName = 'Width_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '2.4 '#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Height_l2: TcxGridDBColumn
        Caption = '2.5 '#1042#1099#1089#1086#1090#1072
        DataBinding.FieldName = 'Height_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '2.5 '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object RowBoxCount_l2: TcxGridDBColumn
        Caption = '2.6 '#1071#1097'. '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '2.6 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        Options.Editing = False
        Width = 99
      end
      object RowWidth_l2: TcxGridDBColumn
        Caption = '2.7. '#1075#1083#1091#1073#1080#1085#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowWidth_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '2.7 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        Options.Editing = False
        Width = 90
      end
      object RowHeight_l2: TcxGridDBColumn
        Caption = '2.8. '#1074#1099#1089#1086#1090#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowHeight_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '2.8 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        Options.Editing = False
        Width = 90
      end
      object Comment_l2: TcxGridDBColumn
        Caption = '2.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l2'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object Code_l3: TcxGridDBColumn
        Caption = '3.1 '#1050#1086#1076
        DataBinding.FieldName = 'Code_l3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '3.1 '#1050#1086#1076' '#1103#1095#1077#1081#1082#1080
        Options.Editing = False
        Width = 55
      end
      object Name_l3: TcxGridDBColumn
        Caption = '3.1 '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'Name_l3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l3: TcxGridDBColumn
        Caption = '3.2.  '#1050#1086#1083'-'#1074#1086' '#1045'2'
        DataBinding.FieldName = 'BoxCount_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '3.2 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        Width = 135
      end
      object Length_l3: TcxGridDBColumn
        Caption = '3.3. '#1044#1083#1080#1085#1072
        DataBinding.FieldName = 'Length_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '3.3 '#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Width_l3: TcxGridDBColumn
        Caption = '3.4 '#1064#1080#1088#1080#1085#1072
        DataBinding.FieldName = 'Width_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '3.4 '#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Height_l3: TcxGridDBColumn
        Caption = '3.5 '#1042#1099#1089#1086#1090#1072
        DataBinding.FieldName = 'Height_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '3.5 '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object RowBoxCount_l3: TcxGridDBColumn
        Caption = '3.6 '#1071#1097'. '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '3.6 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        Options.Editing = False
        Width = 99
      end
      object RowWidth_l3: TcxGridDBColumn
        Caption = '3.7. '#1075#1083#1091#1073#1080#1085#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowWidth_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '3.7 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        Options.Editing = False
        Width = 90
      end
      object RowHeight_l3: TcxGridDBColumn
        Caption = '3.8. '#1074#1099#1089#1086#1090#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowHeight_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '3.8 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        Options.Editing = False
        Width = 90
      end
      object Comment_l3: TcxGridDBColumn
        Caption = '3.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l3'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object Code_l4: TcxGridDBColumn
        Caption = '4.1 '#1050#1086#1076' '#1103#1095'.'
        DataBinding.FieldName = 'Code_l4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '4.1 '#1050#1086#1076' '#1103#1095#1077#1081#1082#1080
        Options.Editing = False
        Width = 55
      end
      object Name_l4: TcxGridDBColumn
        Caption = '4.1 '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'Name_l4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l4: TcxGridDBColumn
        Caption = '4.2.  '#1050#1086#1083'-'#1074#1086' '#1045'2'
        DataBinding.FieldName = 'BoxCount_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '4.2 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        Width = 135
      end
      object Length_l4: TcxGridDBColumn
        Caption = '4.3. '#1044#1083#1080#1085#1072
        DataBinding.FieldName = 'Length_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '4.3 '#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Width_l4: TcxGridDBColumn
        Caption = '4.4 '#1064#1080#1088#1080#1085#1072
        DataBinding.FieldName = 'Width_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '4.4 '#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Height_l4: TcxGridDBColumn
        Caption = '4.5 '#1042#1099#1089#1086#1090#1072
        DataBinding.FieldName = 'Height_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '4.5 '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object RowBoxCount_l4: TcxGridDBColumn
        Caption = '4.6 '#1071#1097'. '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '4.6 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        Options.Editing = False
        Width = 99
      end
      object RowWidth_l4: TcxGridDBColumn
        Caption = '4.7. '#1075#1083#1091#1073#1080#1085#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowWidth_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '4.7 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        Options.Editing = False
        Width = 90
      end
      object RowHeight_l4: TcxGridDBColumn
        Caption = '4.8. '#1074#1099#1089#1086#1090#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowHeight_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '4.8 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        Options.Editing = False
        Width = 90
      end
      object Comment_l4: TcxGridDBColumn
        Caption = '4.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l4'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object Name_l5: TcxGridDBColumn
        Caption = '5.1 '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'Name_l5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object Code_l5: TcxGridDBColumn
        Caption = '5.1 '#1050#1086#1076' '#1103#1095'.'
        DataBinding.FieldName = 'Code_l5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '1.1 '#1050#1086#1076' '#1103#1095#1077#1081#1082#1080
        Options.Editing = False
        Width = 55
      end
      object BoxCount_l5: TcxGridDBColumn
        Caption = '5.2.  '#1050#1086#1083'-'#1074#1086' '#1045'2'
        DataBinding.FieldName = 'BoxCount_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '5.2 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        Width = 135
      end
      object Length_l5: TcxGridDBColumn
        Caption = '5.3. '#1044#1083#1080#1085#1072
        DataBinding.FieldName = 'Length_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '5.3 '#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Width_l5: TcxGridDBColumn
        Caption = '5.4 '#1064#1080#1088#1080#1085#1072
        DataBinding.FieldName = 'Width_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '5.4 '#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Height_l5: TcxGridDBColumn
        Caption = '5.5 '#1042#1099#1089#1086#1090#1072
        DataBinding.FieldName = 'Height_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '5.5 '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object RowBoxCount_l5: TcxGridDBColumn
        Caption = '5.6 '#1071#1097'. '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '5.6 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        Options.Editing = False
        Width = 99
      end
      object RowWidth_l5: TcxGridDBColumn
        Caption = '5.7. '#1075#1083#1091#1073#1080#1085#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowWidth_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '5.7 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        Options.Editing = False
        Width = 90
      end
      object RowHeight_l5: TcxGridDBColumn
        Caption = '5.8. '#1074#1099#1089#1086#1090#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowHeight_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '5.8 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        Options.Editing = False
        Width = 90
      end
      object Comment_l5: TcxGridDBColumn
        Caption = '5.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l5'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object Code_l6: TcxGridDBColumn
        Caption = '6.1 '#1050#1086#1076' '#1103#1095'.'
        DataBinding.FieldName = 'Code_l6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '6.1 '#1050#1086#1076' '#1103#1095#1077#1081#1082#1080
        Options.Editing = False
        Width = 55
      end
      object Name_l6: TcxGridDBColumn
        Caption = '6.1 '#1071#1095#1077#1081#1082#1072
        DataBinding.FieldName = 'Name_l6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l6: TcxGridDBColumn
        Caption = '6.2.  '#1050#1086#1083'-'#1074#1086' '#1045'2'
        DataBinding.FieldName = 'BoxCount_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '6.2. '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        Width = 135
      end
      object Length_l6: TcxGridDBColumn
        Caption = '6.3. '#1044#1083#1080#1085#1072
        DataBinding.FieldName = 'Length_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '6.3 '#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Width_l6: TcxGridDBColumn
        Caption = '6.4 '#1064#1080#1088#1080#1085#1072
        DataBinding.FieldName = 'Width_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '6.4 '#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object Height_l6: TcxGridDBColumn
        Caption = '6.5 '#1042#1099#1089#1086#1090#1072
        DataBinding.FieldName = 'Height_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '6.5 '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        Options.Editing = False
        Width = 90
      end
      object RowBoxCount_l6: TcxGridDBColumn
        Caption = '6.6 '#1071#1097'. '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '6.6 '#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        Options.Editing = False
        Width = 99
      end
      object RowWidth_l6: TcxGridDBColumn
        Caption = '6.7. '#1075#1083#1091#1073#1080#1085#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowWidth_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '6.7 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        Options.Editing = False
        Width = 90
      end
      object RowHeight_l6: TcxGridDBColumn
        Caption = '6.8. '#1074#1099#1089#1086#1090#1072' - '#1056#1103#1076#1099
        DataBinding.FieldName = 'RowHeight_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = '6.8 '#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        Options.Editing = False
        Width = 90
      end
      object Comment_l6: TcxGridDBColumn
        Caption = '6.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l6'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 144
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
    Left = 480
    Top = 120
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
    Left = 256
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbUpdate2'
        end
        item
          Visible = True
          ItemName = 'bbUpdate3'
        end
        item
          Visible = True
          ItemName = 'bbUpdate4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate5'
        end
        item
          Visible = True
          ItemName = 'bbUpdate6'
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
          ItemName = 'bbOpenPartionCell_list'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadBox'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol1'
        end
        item
          Visible = True
          ItemName = 'bbProtocol2'
        end
        item
          Visible = True
          ItemName = 'bbProtocol3'
        end
        item
          Visible = True
          ItemName = 'bbProtocol4'
        end
        item
          Visible = True
          ItemName = 'bbProtocol5'
        end
        item
          Visible = True
          ItemName = 'bbProtocol6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
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
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate1
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbOpenPartionCell_list: TdxBarButton
      Action = actOpenPartionCell_list
      Category = 0
    end
    object bbUpdate2: TdxBarButton
      Action = actUpdate2
      Category = 0
    end
    object bbUpdate3: TdxBarButton
      Action = actUpdate3
      Category = 0
    end
    object bbUpdate4: TdxBarButton
      Action = actUpdate4
      Category = 0
    end
    object bbUpdate5: TdxBarButton
      Action = actUpdate5
      Category = 0
    end
    object bbUpdate6: TdxBarButton
      Action = actUpdate6
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
    object bbProtocol1: TdxBarButton
      Action = actProtocol1
      Category = 0
    end
    object bbProtocol2: TdxBarButton
      Action = actProtocol2
      Category = 0
    end
    object bbProtocol3: TdxBarButton
      Action = actProtocol3
      Category = 0
    end
    object bbProtocol4: TdxBarButton
      Action = actProtocol4
      Category = 0
    end
    object bbProtocol5: TdxBarButton
      Action = actProtocol5
      Category = 0
    end
    object bbProtocol6: TdxBarButton
      Action = actProtocol6
      Category = 0
    end
    object bbStartLoadBox: TdxBarButton
      Action = macStartLoadBox
      Caption = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080'  '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1071#1097#1080#1082#1086#1074' '#1045'2 '#1080#1079' '#1092 +
        #1072#1081#1083#1072
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 368
    Top = 120
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object macStartLoadBox: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingIdBox
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1071#1097#1080#1082#1086#1074' '#1045'2' +
        ' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1080' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1071#1097#1080#1082#1086#1074' '#1045'2 '#1080#1079' '#1092#1072 +
        #1081#1083#1072
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1071#1097#1080#1082#1086#1074' '#1045'2 '#1080#1079' '#1092#1072 +
        #1081#1083#1072
      ImageIndex = 27
    end
    object actGetImportSettingIdBox: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingIdBox
      StoredProcList = <
        item
          StoredProc = spGetImportSettingIdBox
        end>
      Caption = 'actGetImportSetting'
    end
    object actUpdate1: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 1'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 1'
      ShortCut = 115
      ImageIndex = 47
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate2: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 2'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 2'
      ShortCut = 115
      ImageIndex = 48
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate3: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 3'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 3'
      ShortCut = 115
      ImageIndex = 49
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate4: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 4'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 4'
      ShortCut = 115
      ImageIndex = 68
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l4'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate5: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 5'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 5'
      ShortCut = 115
      ImageIndex = 69
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l5'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate6: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 6'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100' 6'
      ShortCut = 115
      ImageIndex = 70
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l6'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l1'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l1'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_l1'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_l2'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_l3'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_l4'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_l5'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id_l6'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name_l1'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l1'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name_l2'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l2'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name_l3'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l3'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name_l4'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l4'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name_l5'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l5'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name_l6'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l6'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actOpenPartionCell_list: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1086#1082
      Hint = #1057#1087#1080#1089#1086#1082
      ImageIndex = 26
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateParams
      StoredProcList = <
        item
          StoredProc = spUpdateParams
        end>
      Caption = 'actUpdateRemains'
      DataSource = DataSource
    end
    object actProtocol1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095'.1'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095#1077#1081#1082#1072' 1'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l1'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol2: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095'.2'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095#1077#1081#1082#1072' 2'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l2'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inDate_BUH'
          Value = 45047d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actProtocol3: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095'.3'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095#1077#1081#1082#1072' 3'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l3'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol4: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095'.4'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095#1077#1081#1082#1072' 4'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l4'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l4'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol5: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095'.5'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095#1077#1081#1082#1072' 5'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l5'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l5'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol6: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095'.6'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1103#1095#1077#1081#1082#1072' 6'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id_l6'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name_l6'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1053#1072#1079#1074#1072#1085#1080#1081' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1072#1079#1074#1072#1085#1080#1103' '#1091#1088#1086#1074#1085#1077#1081' '#1089#1090#1077#1083#1072#1078#1077#1081' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PartionCell'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 144
    Top = 104
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 176
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 200
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate1
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate1
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 136
    Top = 224
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
        Value = 'TPartionCellForm;zc_Object_ImportSetting_PartionCell'
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
    Left = 648
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 216
  end
  object spUpdateParams: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PartionCell_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId_1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id_l1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id_l2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id_l3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id_l4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id_l5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id_l6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount_1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BoxCount_l1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount_2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BoxCount_l2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount_3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BoxCount_l3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount_4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BoxCount_l4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount_5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BoxCount_l5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount_6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BoxCount_l6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 588
    Top = 201
  end
  object spGetImportSettingIdBox: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPartionCellForm;zc_Object_ImportSetting_PartionCell_BoxCount'
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
    Left = 784
    Top = 80
  end
end
