inherited ProtocolForm: TProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083
  ClientHeight = 359
  ClientWidth = 933
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 949
  ExplicitHeight = 398
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 82
    Width = 933
    Height = 277
    ExplicitTop = 82
    ExplicitWidth = 933
    ExplicitHeight = 277
    ClientRectBottom = 277
    ClientRectRight = 933
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 933
      ExplicitHeight = 277
      inherited cxGrid: TcxGrid
        Width = 521
        Height = 277
        Align = alLeft
        ExplicitWidth = 521
        ExplicitHeight = 277
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInsert: TcxGridDBColumn
            Caption = '+'
            DataBinding.FieldName = 'IsInsert'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object colDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object colUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object colObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colObjectTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072
            DataBinding.FieldName = 'ObjectTypeName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
        end
      end
      object cxSplitter: TcxSplitter
        Left = 521
        Top = 0
        Width = 4
        Height = 277
        Control = cxGrid
      end
      object cxGridProtocolData: TcxGrid
        Left = 525
        Top = 0
        Width = 408
        Height = 277
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 2
        object cxGridViewProtocolData: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ProtocolDataDS
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
          OptionsView.CellAutoHeight = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cxGridDBColumn1: TcxGridDBColumn
            Caption = #1048#1084#1103' '#1087#1086#1083#1103
            DataBinding.FieldName = 'FieldName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
          end
          object cxGridDBColumn2: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'FieldValue'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 128
          end
        end
        object cxGridLevelProtocolData: TcxGridLevel
          GridView = cxGridViewProtocolData
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 933
    Height = 56
    ExplicitWidth = 933
    ExplicitHeight = 56
    inherited deStart: TcxDateEdit
      EditValue = 41640d
    end
    inherited deEnd: TcxDateEdit
      Left = 335
      EditValue = 41640d
      ExplicitLeft = 335
    end
    object edUser: TcxButtonEdit [3]
      Left = 101
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 121
    end
    object edObjectDesc: TcxButtonEdit [4]
      Left = 335
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 121
    end
    object edObject: TcxButtonEdit [5]
      Left = 583
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 183
    end
    object cxLabel3: TcxLabel [6]
      Left = 21
      Top = 30
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    inherited cxLabel2: TcxLabel
      Left = 225
      ExplicitLeft = 225
    end
    object cxLabel4: TcxLabel
      Left = 241
      Top = 30
      Caption = #1058#1080#1087' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 463
      Top = 30
      Caption = #1069#1083#1077#1084#1077#1085#1090' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 216
  end
  inherited ActionList: TActionList
    Left = 95
    object actGridTwoToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGridProtocolData
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
    end
  end
  inherited MasterDS: TDataSource
    Top = 111
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 143
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Protocol'
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
        Name = 'inUserId'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectDescId'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 103
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 31
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridTwoToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbGridTwoToExcel: TdxBarButton
      Action = actGridTwoToExcel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 384
    Top = 192
  end
  inherited PopupMenu: TPopupMenu
    Left = 160
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UserGuides
      end
      item
        Component = ObjectGuides
      end
      item
        Component = ObjectDescGuides
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end>
    Left = 184
    Top = 176
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 72
  end
  object ObjectDescGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObjectDesc
    FormNameParam.Value = 'TObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 24
  end
  object ObjectGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObject
    FormNameParam.Value = 'TObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDescId'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 16
  end
  object dsdXMLTransform: TdsdXMLTransform
    DataSource = MasterDS
    XMLDataFieldName = 'ProtocolData'
    DataSet = ProtocolDataCDS
    Left = 440
    Top = 112
  end
  object ProtocolDataCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 592
    Top = 127
    object ProtocolDataCDSFieldName: TStringField
      FieldName = 'FieldName'
      Size = 100
    end
    object ProtocolDataCDSFieldValue: TStringField
      FieldName = 'FieldValue'
      Size = 255
    end
  end
  object ProtocolDataDS: TDataSource
    DataSet = ProtocolDataCDS
    Left = 672
    Top = 119
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 136
  end
end
