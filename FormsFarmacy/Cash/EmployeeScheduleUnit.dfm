inherited EmployeeScheduleUnitForm: TEmployeeScheduleUnitForm
  Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
  ClientHeight = 498
  ClientWidth = 820
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 836
  ExplicitHeight = 537
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 820
    Height = 472
    ExplicitWidth = 820
    ExplicitHeight = 472
    ClientRectBottom = 472
    ClientRectRight = 820
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 820
      ExplicitHeight = 472
      inherited cxGrid: TcxGrid
        Width = 820
        Height = 265
        Align = alTop
        ExplicitWidth = 820
        ExplicitHeight = 265
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
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
          OptionsSelection.CellSelect = False
          OptionsView.GroupByBox = False
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Header = dmMain.cxContentStyle
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
            Caption = #1055#1077#1088#1080#1086#1076' '#1090#1077#1082'.'
            DataBinding.FieldName = 'Note'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object NoteUser: TcxGridDBBandedColumn
            Caption = ' '
            DataBinding.FieldName = 'NoteUser'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 1
          end
          object NoteNext: TcxGridDBBandedColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1089#1083#1077#1076'.'
            DataBinding.FieldName = 'NoteNext'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Header = dmMain.cxHeaderL4Style
            Width = 104
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 2
          end
          object PersonalName: TcxGridDBBandedColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object PersonNull: TcxGridDBBandedColumn
            Caption = ' '
            Options.Editing = False
            Width = 155
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 2
          end
          object PersonNull1: TcxGridDBBandedColumn
            Options.Editing = False
            Width = 155
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 1
          end
          object Value: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Value'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 45
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object ValueUser: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValueUser'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 45
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 1
          end
          object ValueNext: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValueNext'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Styles.Content = dmMain.cxGreenEdit
            Styles.Header = dmMain.cxHeaderL4Style
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 2
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object cxGridSubstitution: TcxGrid
        Left = 0
        Top = 273
        Width = 820
        Height = 199
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
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
          OptionsSelection.CellSelect = False
          OptionsView.GroupByBox = False
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Header = dmMain.cxContentStyle
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
          object Substitution_PersonalName: TcxGridDBBandedColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 166
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Substitution_PersonNull: TcxGridDBBandedColumn
            Caption = ' '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 165
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 1
          end
          object Substitution_Note: TcxGridDBBandedColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1090#1077#1082'.'
            DataBinding.FieldName = 'Note'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Substitution_NoteNext: TcxGridDBBandedColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1089#1083#1077#1076'.'
            DataBinding.FieldName = 'NoteNext'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Header = dmMain.cxHeaderL4Style
            Width = 93
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 1
          end
          object Substitution_Value: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Value'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 45
            Options.Editing = False
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Substitution_ValueNext: TcxGridDBBandedColumn
            DataBinding.FieldName = 'ValueNext'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxGreenEdit
            Styles.Header = dmMain.cxHeaderL4Style
            Width = 65
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 1
          end
        end
        object cxGridLevelSubstitution: TcxGridLevel
          GridView = cxGridDBBandedTableViewSubstitution
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 265
        Width = 820
        Height = 8
        AlignSplitter = salTop
        Control = cxGrid
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 243
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 120
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_EmployeeSchedule_Unit'
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
    Left = 88
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 120
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = nil
    KeepSelectColor = True
    Left = 360
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '1'
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 104
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    ControlList = <
      item
      end>
    ActionAfterExecute = actRefresh
    Left = 344
    Top = 105
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 464
    Top = 104
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 464
    Top = 176
  end
  object HeaderUserCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 600
    Top = 104
  end
  object CrossDBViewUserAddOn: TCrossDBViewAddOn
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldUser'
    TemplateColumn = ValueUser
    Left = 584
    Top = 176
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
    Left = 360
    Top = 304
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
    HeaderDataSet = HeaderUserCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_ValueNext
    Left = 664
    Top = 296
  end
  object CrossDBViewAddOnSubstitution: TCrossDBViewAddOn
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_Value
    Left = 488
    Top = 296
  end
  object CrossDBViewAddOnNext: TCrossDBViewAddOn
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
    HeaderDataSet = HeaderUserCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = ValueNext
    Left = 712
    Top = 176
  end
end
