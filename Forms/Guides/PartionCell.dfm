object PartionCellForm: TPartionCellForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')>'
  ClientHeight = 376
  ClientWidth = 502
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 502
    Height = 350
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object clName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 156
      end
      object Level_l1: TcxGridDBColumn
        Caption = '1.'#1059#1088#1086#1074#1077#1085#1100
        DataBinding.FieldName = 'Level_l1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Length_l1: TcxGridDBColumn
        Caption = '1.'#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Length_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Width_l1: TcxGridDBColumn
        Caption = '1.'#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Width_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Height_l1: TcxGridDBColumn
        Caption = '1.'#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Height_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l1: TcxGridDBColumn
        Caption = '1.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        DataBinding.FieldName = 'BoxCount_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 135
      end
      object RowBoxCount_l1: TcxGridDBColumn
        Caption = '1.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 99
      end
      object RowWidth_l1: TcxGridDBColumn
        Caption = '1.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        DataBinding.FieldName = 'RowWidth_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object RowHeight_l1: TcxGridDBColumn
        Caption = '1.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        DataBinding.FieldName = 'RowHeight_l1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Comment_l1: TcxGridDBColumn
        Caption = '1.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Level_l2: TcxGridDBColumn
        Caption = '2.'#1059#1088#1086#1074#1077#1085#1100
        DataBinding.FieldName = 'Level_l2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Length_l2: TcxGridDBColumn
        Caption = '2.'#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Length_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Width_l2: TcxGridDBColumn
        Caption = '2.'#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Width_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Height_l2: TcxGridDBColumn
        Caption = '2.'#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Height_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l2: TcxGridDBColumn
        Caption = '2.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        DataBinding.FieldName = 'BoxCount_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 135
      end
      object RowBoxCount_l2: TcxGridDBColumn
        Caption = '2.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 99
      end
      object RowWidth_l2: TcxGridDBColumn
        Caption = '2.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        DataBinding.FieldName = 'RowWidth_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object RowHeight_l2: TcxGridDBColumn
        Caption = '2.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        DataBinding.FieldName = 'RowHeight_l2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Comment_l2: TcxGridDBColumn
        Caption = '2.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Level_l3: TcxGridDBColumn
        Caption = '3.'#1059#1088#1086#1074#1077#1085#1100
        DataBinding.FieldName = 'Level_l3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Length_l3: TcxGridDBColumn
        Caption = '3.'#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Length_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Width_l3: TcxGridDBColumn
        Caption = '3.'#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Width_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Height_l3: TcxGridDBColumn
        Caption = '3.'#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Height_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l3: TcxGridDBColumn
        Caption = '3.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        DataBinding.FieldName = 'BoxCount_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 135
      end
      object RowBoxCount_l3: TcxGridDBColumn
        Caption = '3.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 99
      end
      object RowWidth_l3: TcxGridDBColumn
        Caption = '3.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        DataBinding.FieldName = 'RowWidth_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object RowHeight_l3: TcxGridDBColumn
        Caption = '3.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        DataBinding.FieldName = 'RowHeight_l3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Comment_l3: TcxGridDBColumn
        Caption = '3.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Level_l4: TcxGridDBColumn
        Caption = '4.'#1059#1088#1086#1074#1077#1085#1100
        DataBinding.FieldName = 'Level_l4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Length_l4: TcxGridDBColumn
        Caption = '4.'#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Length_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Width_l4: TcxGridDBColumn
        Caption = '4.'#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Width_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Height_l4: TcxGridDBColumn
        Caption = '4.'#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Height_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l4: TcxGridDBColumn
        Caption = '4.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        DataBinding.FieldName = 'BoxCount_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 135
      end
      object RowBoxCount_l4: TcxGridDBColumn
        Caption = '4.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 99
      end
      object RowWidth_l4: TcxGridDBColumn
        Caption = '4.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        DataBinding.FieldName = 'RowWidth_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object RowHeight_l4: TcxGridDBColumn
        Caption = '4.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        DataBinding.FieldName = 'RowHeight_l4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Comment_l4: TcxGridDBColumn
        Caption = '4.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Level_l5: TcxGridDBColumn
        Caption = '5.'#1059#1088#1086#1074#1077#1085#1100
        DataBinding.FieldName = 'Level_l5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Length_l5: TcxGridDBColumn
        Caption = #1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Length_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Width_l5: TcxGridDBColumn
        Caption = '5.'#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Width_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Height_l5: TcxGridDBColumn
        Caption = '5.'#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Height_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l5: TcxGridDBColumn
        Caption = '5.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        DataBinding.FieldName = 'BoxCount_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 135
      end
      object RowBoxCount_l5: TcxGridDBColumn
        Caption = '5.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 99
      end
      object RowWidth_l5: TcxGridDBColumn
        Caption = '5.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        DataBinding.FieldName = 'RowWidth_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object RowHeight_l5: TcxGridDBColumn
        Caption = '5.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        DataBinding.FieldName = 'RowHeight_l5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Comment_l5: TcxGridDBColumn
        Caption = '5.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Level_l6: TcxGridDBColumn
        Caption = '5.'#1059#1088#1086#1074#1077#1085#1100
        DataBinding.FieldName = 'Level_l6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Length_l6: TcxGridDBColumn
        Caption = '5.'#1044#1083#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Length_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Width_l6: TcxGridDBColumn
        Caption = '6.'#1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Width_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Height_l6: TcxGridDBColumn
        Caption = '6.'#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080', '#1084#1084
        DataBinding.FieldName = 'Height_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object BoxCount_l6: TcxGridDBColumn
        Caption = '6.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
        DataBinding.FieldName = 'BoxCount_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 135
      end
      object RowBoxCount_l6: TcxGridDBColumn
        Caption = '6.'#1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1074' '#1088#1103#1076#1091
        DataBinding.FieldName = 'RowBoxCount_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 99
      end
      object RowWidth_l6: TcxGridDBColumn
        Caption = '6.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
        DataBinding.FieldName = 'RowWidth_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object RowHeight_l6: TcxGridDBColumn
        Caption = '6.'#1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
        DataBinding.FieldName = 'RowHeight_l6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
      end
      object Comment_l6: TcxGridDBColumn
        Caption = '6.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment_l6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
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
    Left = 344
    Top = 128
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
    Left = 264
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChoice'
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
      Action = actUpdate
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
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 304
    Top = 112
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TPartionCellEditForm'
      FormNameParam.Value = 'TPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
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
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
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
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
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
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
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
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
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
    Left = 136
    Top = 224
  end
end
