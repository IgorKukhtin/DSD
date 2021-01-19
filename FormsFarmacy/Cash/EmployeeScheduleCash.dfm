inherited EmployeeScheduleCashForm: TEmployeeScheduleCashForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1074#1086#1076' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072
  ClientHeight = 545
  ClientWidth = 789
  Position = poScreenCenter
  ExplicitWidth = 795
  ExplicitHeight = 574
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 789
    Height = 102
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object cbEndHour: TcxComboBox
      Left = 371
      Top = 44
      Properties.Items.Strings = (
        ''
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15'
        '16'
        '17'
        '18'
        '19'
        '20'
        '21'
        '22'
        '23')
      TabOrder = 0
      Width = 54
    end
    object cbEndMin: TcxComboBox
      Left = 438
      Top = 44
      Properties.Items.Strings = (
        ''
        '00'
        '30')
      TabOrder = 1
      Width = 54
    end
    object cbServiceExit: TcxCheckBox
      Left = 26
      Top = 40
      Hint = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1074#1099#1093#1086#1076' ('#1074#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072' '#1085#1077' '#1079#1072#1087#1086#1083#1085#1103#1090#1100')'
      Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1074#1099#1093#1086#1076
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object cbStartHour: TcxComboBox
      Left = 371
      Top = 21
      Properties.Items.Strings = (
        ''
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15'
        '16'
        '17'
        '18'
        '19'
        '20'
        '21'
        '22'
        '23')
      TabOrder = 3
      Width = 54
    end
    object cbStartMin: TcxComboBox
      Left = 438
      Top = 21
      Properties.Items.Strings = (
        ''
        '00'
        '30')
      TabOrder = 4
      Width = 54
    end
    object cxLabel2: TcxLabel
      Left = 26
      Top = 21
      Caption = #1057#1077#1075#1086#1076#1085#1103
    end
    object cxLabel3: TcxLabel
      Left = 206
      Top = 21
      Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072':'
    end
    object cxLabel4: TcxLabel
      Left = 206
      Top = 44
      Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1093#1086#1076#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 206
      Top = 2
      Caption = 
        #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072'  '#1074#1074#1086#1076#1080#1090#1089#1103' '#1082#1088#1072#1090#1085#1086' 30 '#1084#1080#1085'. '#1074' '#1074#1080 +
        #1076#1077' '#1063#1063':MM'
    end
    object cxLabel6: TcxLabel
      Left = 425
      Top = 22
      Caption = ' : '
    end
    object cxLabel7: TcxLabel
      Left = 425
      Top = 45
      Caption = ' : '
    end
    object edOperDate: TcxDateEdit
      Left = 79
      Top = 20
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 100
    end
    object cxButton1: TcxButton
      Left = 184
      Top = 69
      Width = 183
      Height = 25
      Cancel = True
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1091#1093#1086#1076#1072
      TabOrder = 12
      OnClick = cxButton1Click
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 102
    Width = 789
    Height = 443
    Align = alClient
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    object cxGridSubstitution: TcxGrid
      Left = 1
      Top = 218
      Width = 787
      Height = 224
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = MasterDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.DataRowSizing = True
        OptionsData.CancelOnExit = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      end
      object cxGridDBBandedTableViewSubstitution: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = SubstitutionDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        Styles.Content = dmMain.cxContentStyle
        Styles.Header = dmMain.cxContentStyle
        Styles.Inactive = dmMain.cxSelection
        Styles.Selection = dmMain.cxSelection
        Bands = <
          item
            Caption = #1043#1088#1072#1092#1080#1082' '#1087#1086#1076#1084#1077#1085
            FixedKind = fkLeft
            Styles.Header = dmMain.cxFooterStyle
            Width = 259
          end
          item
            Caption = #1055#1077#1088#1080#1086#1076
            Width = 55
          end>
        object Substitution_Note: TcxGridDBBandedColumn
          Caption = #1055#1077#1088#1080#1086#1076
          DataBinding.FieldName = 'Note'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 98
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object Substitution_UnitName: TcxGridDBBandedColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 161
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object Substitution_NoteStart: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'NoteStart'
          Width = 98
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 1
        end
        object Substitution_NoteEnd: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'NoteEnd'
          Width = 98
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 2
        end
        object Substitution_NoteNext: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'NoteNext'
          Width = 98
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 3
        end
        object Substitution_Value: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Value'
          Visible = False
          HeaderAlignmentHorz = taCenter
          MinWidth = 45
          Options.Editing = False
          Styles.Content = dmMain.cxFooterStyle
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object Substitution_ValueEnd: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueEnd'
          Visible = False
          Options.Editing = False
          Options.ShowCaption = False
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 2
        end
        object Substitution_ValueStart: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueStart'
          Visible = False
          Options.Editing = False
          Options.ShowCaption = False
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 1
        end
        object Substitution_ValueNext: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueNext'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.Header = dmMain.cxHeaderL4Style
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 3
        end
        object Substitution_Color_CalcFont: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Color_CalcFont'
          Visible = False
          Options.Editing = False
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object Substitution_Nil1: TcxGridDBBandedColumn
          Width = 161
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 1
        end
        object Substitution_Nil2: TcxGridDBBandedColumn
          Width = 161
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 2
        end
        object Substitution_Nil3: TcxGridDBBandedColumn
          Width = 161
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 3
        end
      end
      object cxGridLevelSubstitution: TcxGridLevel
        GridView = cxGridDBBandedTableViewSubstitution
      end
    end
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 787
      Height = 217
      Align = alTop
      TabOrder = 1
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = MasterDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.DataRowSizing = True
        OptionsData.CancelOnExit = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      end
      object cxGridDBBandedTableView1: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = MasterDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        Styles.Content = dmMain.cxContentStyle
        Styles.Header = dmMain.cxContentStyle
        Styles.Inactive = dmMain.cxSelection
        Styles.Selection = dmMain.cxSelection
        Bands = <
          item
            Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1076#1085#1103#1084
            FixedKind = fkLeft
            Styles.Header = dmMain.cxFooterStyle
            Width = 259
          end
          item
            Caption = #1055#1077#1088#1080#1086#1076
            Width = 55
          end>
        object Note: TcxGridDBBandedColumn
          Caption = #1044#1072#1090#1099' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
          DataBinding.FieldName = 'Note'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object NoteStart: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'NoteStart'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 1
        end
        object NoteEnd: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'NoteEnd'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 2
        end
        object NoteNext: TcxGridDBBandedColumn
          Caption = #1044#1072#1090#1099' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
          DataBinding.FieldName = 'NoteNext'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.Header = dmMain.cxHeaderL4Style
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 3
        end
        object Value: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Value'
          Visible = False
          HeaderAlignmentHorz = taCenter
          MinWidth = 45
          Options.Editing = False
          Styles.Content = dmMain.cxFooterStyle
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object ValueStart: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueStart'
          Visible = False
          HeaderAlignmentHorz = taCenter
          MinWidth = 45
          Options.Editing = False
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 1
        end
        object ValueEnd: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueEnd'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 2
        end
        object ValueNext: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueNext'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.Header = dmMain.cxHeaderL4Style
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 3
        end
        object Color_Calc: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Color_Calc'
          Visible = False
          Options.Editing = False
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object Color_CalcFont: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Color_CalcFont'
          Visible = False
          Options.Editing = False
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object Color_CalcFontUser: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Color_CalcFont'
          Visible = False
          Options.Editing = False
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBBandedTableView1
      end
    end
  end
  inherited bbCancel: TcxButton [2]
    Left = 393
    Top = 69
    TabOrder = 2
    ExplicitLeft = 393
    ExplicitTop = 69
  end
  inherited bbOk: TcxButton [3]
    Left = 79
    Top = 69
    ModalResult = 0
    TabOrder = 3
    OnClick = bbOkClick
    ExplicitLeft = 79
    ExplicitTop = 69
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 88
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 536
    Top = 88
  end
  inherited ActionList: TActionList
    Left = 327
    Top = 87
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PromoCodeGUID'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeID'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeChangePercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 544
    Top = 32
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 24
    Top = 168
  end
  object SubstitutionDS: TDataSource
    DataSet = SubstitutionCDS
    Left = 360
    Top = 360
  end
  object SubstitutionCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 368
    Top = 320
  end
  object HeaderUserCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 600
    Top = 152
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 464
    Top = 144
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_EmployeeSchedule_User'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = HeaderUserCDS
      end
      item
        DataSet = MasterCDS
      end
      item
        DataSet = SubstitutionCDS
      end>
    OutputType = otMultiDataSet
    Params = <>
    PackSize = 1
    Left = 80
    Top = 168
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 24
    Top = 248
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_EmployeeSchedule_User'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'OperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartHour'
        Value = ''
        Component = cbStartHour
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartMin'
        Value = ''
        Component = cbStartMin
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndHour'
        Value = ''
        Component = cbEndHour
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndMin'
        Value = ''
        Component = cbEndMin
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceExit'
        Value = False
        Component = cbServiceExit
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 144
  end
  object CrossDBViewAddOnSubstitutionNext: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableViewSubstitution
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderUserCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_ValueNext
    Left = 680
    Top = 376
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Value
        ValueColumn = Color_CalcFont
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 480
    Top = 232
  end
  object CrossDBViewStartAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldNill'
    TemplateColumn = ValueStart
    Left = 624
    Top = 240
  end
  object CrossDBViewEndAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Value
        ValueColumn = Color_CalcFont
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldNill'
    TemplateColumn = ValueEnd
    Left = 480
    Top = 280
  end
  object CrossDBViewNextAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderUserCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = ValueNext
    Left = 616
    Top = 280
  end
  object CrossDBViewAddOnSubstitution: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableViewSubstitution
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Substitution_Value
        ValueColumn = Substitution_Color_CalcFont
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_Value
    Left = 504
    Top = 376
  end
  object CrossDBViewAddOnSubstitutionValueStart: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableViewSubstitution
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Substitution_Value
        ValueColumn = Substitution_Color_CalcFont
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_ValueStart
    Left = 504
    Top = 432
  end
  object CrossDBViewAddOnSubstitutionValueEnd: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableViewSubstitution
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Substitution_Value
        ValueColumn = Substitution_Color_CalcFont
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_ValueEnd
    Left = 672
    Top = 432
  end
end
