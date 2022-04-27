object OLAPSetupForm: TOLAPSetupForm
  Left = 427
  Top = 103
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1054#1083#1072#1087#1072
  ClientHeight = 623
  ClientWidth = 965
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 92
    Top = 102
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object sbMain: TScrollBox
    Left = 0
    Top = 0
    Width = 965
    Height = 623
    Align = alClient
    TabOrder = 0
    object fpSettings: TPanel
      Left = 0
      Top = 0
      Width = 961
      Height = 619
      Align = alClient
      TabOrder = 0
      object ScrollBox1: TScrollBox
        Left = 1
        Top = 1
        Width = 959
        Height = 617
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object Label1: TLabel
          Left = 162
          Top = 569
          Width = 150
          Height = 13
          Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
        end
        object Label3: TLabel
          Left = 427
          Top = 49
          Width = 47
          Height = 13
          Caption = #1044#1072#1085#1085#1099#1077': '
        end
        object Label4: TLabel
          Left = 22
          Top = 49
          Width = 53
          Height = 13
          Caption = #1060#1080#1083#1100#1090#1088#1099': '
        end
        object Label5: TLabel
          Left = 704
          Top = 49
          Width = 35
          Height = 13
          Caption = #1044#1072#1090#1099': '
        end
        object laFilterCaption: TLabel
          Left = 705
          Top = 220
          Width = 54
          Height = 13
          Caption = #1044#1072#1085#1085#1099#1077': '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 602
          Top = 568
          Width = 182
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1087#1080#1089#1077#1081':'
        end
        object cxDimension: TcxGrid
          Left = 18
          Top = 68
          Width = 381
          Height = 487
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = cxcbsNone
          TabOrder = 1
          LookAndFeel.Kind = lfStandard
          LookAndFeel.NativeStyle = True
          RootLevelOptions.DetailFrameColor = clBtnShadow
          RootLevelOptions.DetailFrameWidth = 1
          object cxDimensionDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = DimensionDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsCustomize.ColumnHorzSizing = False
            OptionsCustomize.ColumnMoving = False
            OptionsCustomize.ColumnSorting = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.FocusRect = False
            OptionsView.ExpandButtonsForEmptyDetails = False
            OptionsView.GridLines = glNone
            OptionsView.GroupByBox = False
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object cxDimensionName: TcxGridDBColumn
              Caption = #1048#1079#1084#1077#1088#1077#1085#1080#1077
              DataBinding.FieldName = 'Name'
              Options.Editing = False
              Options.Moving = False
              Width = 250
            end
            object cxDimensionShow: TcxGridDBColumn
              Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
              DataBinding.FieldName = 'isShow'
              MinWidth = 64
              Options.Moving = False
            end
            object cxDimensionFiltered: TcxGridDBColumn
              Caption = #1060#1080#1083#1100#1090#1088
              DataBinding.FieldName = 'isFiltered'
              MinWidth = 64
              Options.Editing = False
              Options.Moving = False
            end
          end
          object cxDimensionLevel: TcxGridLevel
            GridView = cxDimensionDBTableView
          end
        end
        object cxData: TcxGrid
          Left = 427
          Top = 68
          Width = 259
          Height = 487
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = cxcbsNone
          TabOrder = 2
          LookAndFeel.Kind = lfStandard
          LookAndFeel.NativeStyle = False
          RootLevelOptions.DetailFrameColor = clBtnShadow
          RootLevelOptions.DetailFrameWidth = 1
          object cxDataTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = DataDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsCustomize.ColumnHorzSizing = False
            OptionsCustomize.ColumnMoving = False
            OptionsCustomize.ColumnSorting = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.FocusRect = False
            OptionsView.ExpandButtonsForEmptyDetails = False
            OptionsView.GridLines = glNone
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object cxDataName: TcxGridDBColumn
              DataBinding.FieldName = 'Name'
              Options.Editing = False
              Options.Moving = False
              Width = 200
            end
            object cxDataisShow: TcxGridDBColumn
              DataBinding.FieldName = 'isShow'
            end
            object cxDataCalculateType: TcxGridDBColumn
              DataBinding.FieldName = 'CalculateType'
              Visible = False
            end
          end
          object cxDataLevel: TcxGridLevel
            GridView = cxDataTableView
          end
        end
        object cxDate: TcxGrid
          Left = 705
          Top = 68
          Width = 238
          Height = 145
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = cxcbsNone
          TabOrder = 0
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = False
          RootLevelOptions.DetailFrameColor = clBtnShadow
          RootLevelOptions.DetailFrameWidth = 1
          object cxDateTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = DateDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsCustomize.ColumnHorzSizing = False
            OptionsCustomize.ColumnMoving = False
            OptionsCustomize.ColumnSorting = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.FocusRect = False
            OptionsView.ExpandButtonsForEmptyDetails = False
            OptionsView.GridLines = glNone
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object cxDateName: TcxGridDBColumn
              DataBinding.FieldName = 'Name'
              Options.Editing = False
              Options.Moving = False
              Width = 200
            end
            object cxDateisShow: TcxGridDBColumn
              DataBinding.FieldName = 'isShow'
              Options.Moving = False
            end
          end
          object cxDateLevel: TcxGridLevel
            GridView = cxDateTableView
          end
        end
        object cbPreparedSettings: TComboBox
          Left = 321
          Top = 565
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnCloseUp = cbPreparedSettingsCloseUp
        end
        object cxFilter: TcxGrid
          Left = 705
          Top = 239
          Width = 238
          Height = 316
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = cxcbsNone
          TabOrder = 4
          LookAndFeel.Kind = lfStandard
          LookAndFeel.NativeStyle = False
          RootLevelOptions.DetailFrameColor = clBtnShadow
          RootLevelOptions.DetailFrameWidth = 1
          object tvFilterTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = FilterDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsCustomize.ColumnHorzSizing = False
            OptionsCustomize.ColumnMoving = False
            OptionsCustomize.ColumnSorting = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.FocusRect = False
            OptionsView.ExpandButtonsForEmptyDetails = False
            OptionsView.GridLines = glNone
            OptionsView.GroupByBox = False
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object tvFilterName: TcxGridDBColumn
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              DataBinding.FieldName = 'Name'
              Options.Editing = False
              Options.Moving = False
              Width = 230
            end
          end
          object cxFilterLevel: TcxGridLevel
            GridView = tvFilterTableView
          end
        end
        object cxMaxRecordCount: TcxCurrencyEdit
          Left = 788
          Top = 564
          EditValue = 1000000
          ParentFont = False
          Properties.Alignment.Horz = taRightJustify
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0'
          Properties.EditFormat = '0'
          Properties.UseThousandSeparator = True
          TabOrder = 6
          Width = 99
        end
        object lblPeriodType: TcxLabel
          Left = 19
          Top = 5
          AutoSize = False
          Caption = #1058#1080#1087' '#1087#1077#1088#1080#1086#1076#1072':'
          ParentFont = False
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          Properties.Orientation = cxoLeft
          Visible = False
          Height = 17
          Width = 132
          AnchorY = 14
        end
        object fldPeriodType: TcxImageComboBox
          Left = 161
          Top = 3
          ParentFont = False
          Properties.Items = <
            item
              Description = #1055#1086' '#1076#1072#1090#1077' '#1089#1086#1079#1076#1072#1085#1080#1103
              ImageIndex = 0
              Value = 0
            end
            item
              Description = #1055#1086' '#1076#1072#1090#1077' '#1086#1090#1075#1088#1091#1079#1082#1080
              Value = 1
            end>
          TabOrder = 8
          Visible = False
          Width = 239
        end
        object ELLabel1: TcxLabel
          Left = 19
          Top = 27
          AutoSize = False
          Caption = #1058#1080#1087' '#1086#1090#1095#1077#1090#1072':'
          ParentFont = False
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          Properties.Orientation = cxoLeft
          Height = 17
          Width = 124
          AnchorY = 36
        end
        object fldReportType: TcxImageComboBox
          Left = 161
          Top = 26
          ParentFont = False
          Properties.Items = <
            item
              Description = 'Quantum grid'
              ImageIndex = 0
              Value = 0
            end
            item
              Description = 'Pivot grid'
              Value = 1
            end>
          Properties.OnChange = fldReportTypePropertiesChange
          TabOrder = 9
          Width = 239
        end
        object DatePanel: TPanel
          Left = 883
          Top = 69
          Width = 40
          Height = 143
          BevelOuter = bvNone
          Color = clCaptionText
          TabOrder = 11
          Visible = False
        end
        object lHorizontalTotal: TcxLabel
          Left = 424
          Top = 28
          AutoSize = False
          Caption = #1048#1090#1086#1075#1080' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080':'
          ParentFont = False
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          Properties.Orientation = cxoLeft
          Visible = False
          Height = 17
          Width = 124
          AnchorY = 37
        end
        object cbHorizontalTotal: TcxImageComboBox
          Left = 585
          Top = 26
          EditValue = 0
          ParentFont = False
          Properties.Items = <
            item
              Description = #1041#1077#1079' '#1080#1090#1086#1075#1086#1074
              ImageIndex = 0
              Value = 0
            end
            item
              Description = #1057#1091#1084#1084#1072
              ImageIndex = 0
              Value = 1
            end
            item
              Description = #1052#1080#1085#1080#1084#1091#1084
              Value = 2
            end
            item
              Description = #1052#1072#1082#1089#1080#1084#1091#1084
              Value = 3
            end
            item
              Description = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
              Value = 4
            end
            item
              Description = #1057#1088#1077#1076#1085#1077#1077
              Value = 5
            end
            item
              Description = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1085#1080#1082#1072#1083#1100#1085#1099#1093
              Value = 6
            end>
          Properties.OnChange = fldReportTypePropertiesChange
          TabOrder = 12
          Visible = False
          Width = 239
        end
        object cxButton1: TcxButton
          Left = 848
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Ok'
          TabOrder = 13
          OnClick = btnRunOlapClick
        end
        object cxButton2: TcxButton
          Left = 848
          Top = 39
          Width = 75
          Height = 25
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 14
        end
        object deStart: TcxDateEdit
          Left = 536
          Top = 3
          EditValue = 44562d
          Properties.SaveTime = False
          Properties.ShowTime = False
          TabOrder = 15
          Width = 85
        end
        object cxLabel2: TcxLabel
          Left = 629
          Top = 4
          Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
        end
        object deEnd: TcxDateEdit
          Left = 739
          Top = 3
          EditValue = 44562d
          Properties.SaveTime = False
          Properties.ShowTime = False
          TabOrder = 17
          Width = 85
        end
        object cxLabel1: TcxLabel
          Left = 439
          Top = 4
          Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
        end
        object cxButton3: TcxButton
          Left = 470
          Top = 565
          Width = 125
          Height = 20
          Caption = #1059#1076#1072#1083#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1091
          OptionsImage.ImageIndex = 72
          OptionsImage.Images = dmMain.ImageList
          TabOrder = 19
          OnClick = ELDeletePreparedSettingsClick
        end
        object cxButton4: TcxButton
          Left = 470
          Top = 591
          Width = 125
          Height = 20
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1091
          OptionsImage.ImageIndex = 0
          OptionsImage.Images = dmMain.ImageList
          TabOrder = 20
          OnClick = ELSavePreparedSettingsClick
        end
        object cxLabel5: TcxLabel
          Left = 545
          Top = 45
          Caption = #1041#1080#1079#1085#1077#1089
          Visible = False
        end
        object edBusiness: TcxButtonEdit
          Left = 589
          Top = 41
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 22
          Visible = False
          Width = 97
        end
      end
    end
    object txPreparedSettings: TcxTextEdit
      Left = 322
      Top = 593
      ParentFont = False
      TabOrder = 1
      Width = 145
    end
  end
  object DimensionDS: TDataSource
    DataSet = DimensionFields
    Left = 238
    Top = 132
  end
  object DataDS: TDataSource
    DataSet = DataFields
    Left = 582
    Top = 110
  end
  object DateDS: TDataSource
    DataSet = DateFields
    Left = 806
    Top = 78
  end
  object FilterDS: TDataSource
    DataSet = FilterTable
    Left = 784
    Top = 272
  end
  object DimensionFields: TClientDataSet
    Aggregates = <>
    Filter = 'isOlapFilter=false'
    Params = <>
    AfterScroll = DimensionFieldsAfterScroll
    Left = 304
    Top = 192
    object DimensionFieldsName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object DimensionFieldsisShow: TBooleanField
      FieldName = 'isShow'
    end
    object DimensionFieldsField_Name: TStringField
      FieldName = 'Field_Name'
      Size = 100
    end
    object DimensionFieldsisFiltered: TBooleanField
      FieldName = 'isFiltered'
    end
    object DimensionFieldsChoiceForm: TIntegerField
      FieldName = 'ChoiceForm'
    end
    object DimensionFieldsisOLAPFilter: TBooleanField
      FieldName = 'isOLAPFilter'
    end
  end
  object DataFields: TClientDataSet
    Aggregates = <>
    Filter = 'isOlapFilter=false'
    Params = <>
    AfterPost = DataFieldsAfterPost
    Left = 624
    Top = 168
    object DataFieldsName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object DataFieldsisShow: TBooleanField
      FieldName = 'isShow'
    end
    object DataFieldsField_Name: TStringField
      FieldName = 'Field_Name'
      Size = 100
    end
    object DataFieldsCalculateType: TSmallintField
      FieldName = 'CalculateType'
    end
    object DataFieldsisOLAPFilter: TBooleanField
      FieldName = 'isOLAPFilter'
    end
  end
  object DateFields: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 856
    Top = 120
    object DateFieldsName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object DateFieldsisShow: TBooleanField
      FieldName = 'isShow'
    end
    object DateFieldsField_Name: TStringField
      FieldName = 'Field_Name'
      Size = 100
    end
  end
  object FilterTable: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 832
    Top = 272
    object FilterTableName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object FilterTableKeyName: TStringField
      FieldName = 'KeyName'
      Size = 100
    end
    object FilterTableID: TStringField
      FieldName = 'ID'
    end
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 184
    Top = 136
  end
  object OlapReportOptionCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 72
    Top = 40
  end
  object spOlapReportOption: TdsdStoredProc
    StoredProcName = 'gpGet_OlapSoldReportOption'
    DataSet = OlapReportOptionCDS
    DataSets = <
      item
        DataSet = OlapReportOptionCDS
      end>
    Params = <>
    PackSize = 1
    Left = 72
    Top = 104
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 320
    Top = 112
  end
  object GuidesBusiness: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 624
    Top = 56
  end
  object spOlapSoldReportBusiness: TdsdStoredProc
    StoredProcName = 'gpGet_OlapSoldReportBusiness'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'BusinessId'
        Value = Null
        Component = GuidesBusiness
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = Null
        Component = GuidesBusiness
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 256
  end
end
