inherited Week_DateForm: TWeek_DateForm
  Caption = #1042#1099#1073#1086#1088' '#1085#1077#1076#1077#1083#1080
  ClientHeight = 376
  ClientWidth = 440
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 456
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Width = 440
    Height = 319
    TabOrder = 0
    ExplicitTop = 57
    ExplicitWidth = 440
    ExplicitHeight = 319
    ClientRectBottom = 319
    ClientRectRight = 440
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 440
      ExplicitHeight = 319
      inherited cxGrid: TcxGrid
        Width = 440
        Height = 319
        ExplicitWidth = 440
        ExplicitHeight = 319
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Editing = False
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object WeekNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1085#1077#1076#1077#1083#1080
            DataBinding.FieldName = 'WeekNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1085#1077#1076#1077#1083#1100
            Width = 120
          end
          object StartDate_WeekNumber: TcxGridDBColumn
            Caption = #1053#1077#1076#1077#1083#1103' '#1089
            DataBinding.FieldName = 'StartDate_WeekNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 141
          end
          object EndDate_WeekNumber: TcxGridDBColumn
            Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086
            DataBinding.FieldName = 'EndDate_WeekNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 165
          end
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 440
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 45658d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 45658d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
      end>
    Left = 24
    Top = 224
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 279
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WeekNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WeekNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate_WeekNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartDate_WeekNumber'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate_WeekNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EndDate_WeekNumber'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'WeekNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WeekNumber'
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateObject
      StoredProcList = <
        item
          StoredProc = spUpdateObject
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Week_Date'
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
      end>
    Left = 88
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 136
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 216
    Top = 256
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 280
  end
  object spUpdateObject: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_OrderPeriodKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeek'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Week'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 232
    Top = 96
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 208
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = deEnd
      end
      item
        Component = deStart
      end>
    Left = 328
    Top = 88
  end
end
