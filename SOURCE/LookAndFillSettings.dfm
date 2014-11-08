object LookAndFillSettingsForm: TLookAndFillSettingsForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1085#1077#1096#1085#1077#1075#1086' '#1074#1080#1076#1072' '#1092#1086#1088#1084
  ClientHeight = 283
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 96
    Width = 483
    Height = 187
    Align = alBottom
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object cxGridDBTableViewRecId: TcxGridDBColumn
        DataBinding.FieldName = 'RecId'
        Visible = False
        Options.Editing = False
      end
      object cxGridDBTableViewcolOne: TcxGridDBColumn
        DataBinding.FieldName = 'colOne'
        Options.Editing = False
        Width = 246
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 9
    Caption = #1057#1082#1080#1085#1099
    ParentFont = False
  end
  object cxVerticalGrid1: TcxVerticalGrid
    Left = 280
    Top = 8
    Width = 150
    Height = 63
    TabOrder = 2
    Version = 1
    object crContentStyle: TcxCategoryRow
      Properties.Caption = #1057#1090#1080#1083#1100' '#1090#1077#1082#1089#1090#1072
      ID = 0
      ParentID = -1
      Index = 0
      Version = 1
    end
    object erContentFontSize: TcxEditorRow
      Properties.Caption = #1056#1072#1079#1084#1077#1088' '#1096#1088#1080#1092#1090#1072
      Properties.EditPropertiesClassName = 'TcxSpinEditProperties'
      Properties.EditProperties.Alignment.Horz = taRightJustify
      Properties.EditProperties.ImmediatePost = True
      Properties.EditProperties.LargeIncrement = 1.000000000000000000
      Properties.EditProperties.MaxValue = 72.000000000000000000
      Properties.EditProperties.MinValue = 4.000000000000000000
      Properties.EditProperties.OnChange = erContentFontSizeEditPropertiesChange
      Properties.DataBinding.ValueType = 'Smallint'
      Properties.Value = 7
      ID = 1
      ParentID = -1
      Index = 1
      Version = 1
    end
  end
  object cxSkinComboBox: TcxComboBox
    Left = 75
    Top = 8
    ParentFont = False
    Properties.DropDownListStyle = lsFixedList
    Properties.ImmediatePost = True
    Properties.ImmediateUpdateText = True
    Properties.OnChange = cxSkinComboBoxPropertiesChange
    TabOrder = 3
    Width = 166
  end
  object dxMemData: TdxMemData
    Active = True
    Indexes = <>
    Persistent.Data = {
      5665728FC2F5285C8FFE3F010000001400000001000700636F6C4F6E6500010B
      000000D2E5F1F220F8F0E8F4F2E0010B000000D2E5F1F220F8F0E8F4F2E0}
    SortOptions = []
    Left = 40
    Top = 120
    object dxMemDatacolOne: TStringField
      FieldName = 'colOne'
    end
  end
  object DataSource: TDataSource
    DataSet = dxMemData
    Left = 112
    Top = 128
  end
end
