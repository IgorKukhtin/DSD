inherited EmployeeScheduleUserForm: TEmployeeScheduleUserForm
  Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1085#1072' '#1088#1072#1073#1086#1090#1091' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1075#1088#1072#1092#1080#1082#1072
  ClientHeight = 518
  ClientWidth = 849
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 865
  ExplicitHeight = 557
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 95
    Width = 849
    Height = 423
    TabOrder = 5
    ExplicitTop = 95
    ExplicitWidth = 800
    ExplicitHeight = 384
    ClientRectBottom = 423
    ClientRectRight = 849
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 800
      ExplicitHeight = 384
      inherited cxGrid: TcxGrid
        Width = 849
        Height = 217
        Align = alTop
        ExplicitWidth = 800
        ExplicitHeight = 217
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
            Caption = #1044#1072#1090#1099' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
            DataBinding.FieldName = 'Note'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object cxGridSubstitution: TcxGrid
        Left = 0
        Top = 217
        Width = 849
        Height = 206
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitWidth = 800
        ExplicitHeight = 167
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
          object Substitution_Note: TcxGridDBBandedColumn
            Caption = #1055#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Note'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
            HeaderAlignmentVert = vaCenter
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
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 849
    Height = 69
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 800
    object edOperDate: TcxDateEdit
      Left = 79
      Top = 18
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 26
      Top = 19
      Caption = #1057#1077#1075#1086#1076#1085#1103
    end
    object cxLabel3: TcxLabel
      Left = 206
      Top = 19
      Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072':'
    end
    object cxLabel4: TcxLabel
      Left = 206
      Top = 42
      Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1093#1086#1076#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 206
      Top = 0
      Caption = 
        #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072'  '#1074#1074#1086#1076#1080#1090#1089#1103' '#1082#1088#1072#1090#1085#1086' 30 '#1084#1080#1085'. '#1074' '#1074#1080 +
        #1076#1077' '#1063#1063':MM'
    end
    object cxButton1: TcxButton
      Left = 523
      Top = 34
      Width = 94
      Height = 25
      Action = InsertUpdateGuides
      Default = True
      TabOrder = 5
    end
    object cbStartHour: TcxComboBox
      Left = 371
      Top = 19
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
      TabOrder = 6
      Width = 54
    end
    object cbStartMin: TcxComboBox
      Left = 438
      Top = 19
      Properties.Items.Strings = (
        ''
        '00'
        '30')
      TabOrder = 7
      Width = 54
    end
    object cxLabel6: TcxLabel
      Left = 425
      Top = 19
      Caption = ' : '
    end
    object cbEndMin: TcxComboBox
      Left = 438
      Top = 42
      Properties.Items.Strings = (
        ''
        '00'
        '30')
      TabOrder = 9
      Width = 54
    end
    object cxLabel7: TcxLabel
      Left = 425
      Top = 42
      Caption = ' : '
    end
    object cbEndHour: TcxComboBox
      Left = 371
      Top = 42
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
      TabOrder = 11
      Width = 54
    end
    object cbServiceExit: TcxCheckBox
      Left = 26
      Top = 38
      Hint = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1074#1099#1093#1086#1076' ('#1074#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072' '#1085#1077' '#1079#1072#1087#1086#1083#1085#1103#1090#1100')'
      Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1074#1099#1093#1086#1076
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      Width = 143
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
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
    end
    object actEmployeeScheduleUnit: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Hint = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      ImageIndex = 55
      FormName = 'TEmployeeScheduleUnitForm'
      FormNameParam.Value = 'TEmployeeScheduleUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEmployeeScheduleUser
      StoredProcList = <
        item
          StoredProc = spUpdateEmployeeScheduleUser
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 14
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
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
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 104
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
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
    object dxBarButton1: TdxBarButton
      Action = actEmployeeScheduleUnit
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = nil
    KeepSelectColor = True
    Left = 352
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '1'
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 176
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
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartHour'
        Value = Null
        Component = cbStartHour
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartMin'
        Value = Null
        Component = cbStartMin
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndHour'
        Value = Null
        Component = cbEndHour
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndMin'
        Value = Null
        Component = cbEndMin
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceExit'
        Value = Null
        Component = cbServiceExit
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 144
  end
  object spUpdateEmployeeScheduleUser: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_EmployeeSchedule_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartHour'
        Value = ''
        Component = cbStartHour
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartMin'
        Value = Null
        Component = cbStartMin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndHour'
        Value = Null
        Component = cbEndHour
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndMin'
        Value = Null
        Component = cbEndMin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceExit'
        Value = Null
        Component = cbServiceExit
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 362
    Top = 200
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateEmployeeScheduleUser
    ControlList = <>
    GetStoredProc = spGet
    ActionAfterExecute = actRefresh
    Left = 368
    Top = 89
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 464
    Top = 96
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 464
    Top = 152
  end
  object HeaderUserCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 600
    Top = 96
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldNill'
    TemplateColumn = ValueStart
    Left = 600
    Top = 152
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
    ColorRuleList = <
      item
        ColorColumn = Substitution_Value
        ValueColumn = Substitution_Color_CalcFont
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_Value
    Left = 488
    Top = 296
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
    HeaderDataSet = HeaderUserCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = ValueNext
    Left = 600
    Top = 200
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldNill'
    TemplateColumn = ValueEnd
    Left = 464
    Top = 200
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_ValueStart
    Left = 488
    Top = 352
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Substitution_ValueEnd
    Left = 656
    Top = 352
  end
end
