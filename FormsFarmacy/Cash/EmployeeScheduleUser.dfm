inherited EmployeeScheduleUserForm: TEmployeeScheduleUserForm
  Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1085#1072' '#1088#1072#1073#1086#1090#1091' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1075#1088#1072#1092#1080#1082#1072
  ClientHeight = 318
  ClientWidth = 792
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 808
  ExplicitHeight = 357
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 792
    Height = 243
    TabOrder = 5
    ExplicitTop = 75
    ExplicitWidth = 792
    ExplicitHeight = 243
    ClientRectBottom = 243
    ClientRectRight = 792
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 792
      ExplicitHeight = 243
      inherited cxGrid: TcxGrid
        Width = 792
        Height = 243
        ExplicitWidth = 792
        ExplicitHeight = 243
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
              FixedKind = fkLeft
              Width = 227
            end
            item
              Caption = #1055#1077#1088#1080#1086#1076
              Width = 55
            end>
          object WhoInput: TcxGridDBBandedColumn
            Caption = #1054#1090#1084#1077#1090#1082#1080
            DataBinding.FieldName = 'WhoInput'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 220
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
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
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 792
    Height = 49
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    object edOperDate: TcxDateEdit
      Left = 79
      Top = 15
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 26
      Top = 16
      Caption = #1057#1077#1075#1086#1076#1085#1103
    end
    object cxLabel1: TcxLabel
      Left = 194
      Top = 16
      Caption = #1042#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1075#1088#1072#1092#1080#1082#1072
    end
    object cbValueUser: TcxComboBox
      Left = 384
      Top = 15
      Properties.Items.Strings = (
        ''
        '7:00'
        '8:00'
        '9:00'
        '10:00'
        '21:00'
        #1042)
      TabOrder = 0
      Text = 'cbValueUser'
      Width = 121
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
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
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
    Left = 256
    Top = 104
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
        Name = 'ValueUser'
        Value = Null
        Component = cbValueUser
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
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
        Name = 'inValueUser'
        Value = ''
        Component = cbValueUser
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 346
    Top = 200
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateEmployeeScheduleUser
    ControlList = <
      item
        Control = cbValueUser
      end>
    GetStoredProc = spGet
    ActionAfterExecute = actRefresh
    Left = 344
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 464
    Top = 168
  end
end
