inherited MovementItemProtocolSWTForm: TMovementItemProtocolSWTForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'> '
  ClientHeight = 293
  ClientWidth = 785
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 801
  ExplicitHeight = 332
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 785
    Height = 210
    ExplicitTop = 83
    ExplicitWidth = 785
    ExplicitHeight = 210
    ClientRectBottom = 210
    ClientRectRight = 785
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 785
      ExplicitHeight = 210
      inherited cxGrid: TcxGrid
        Width = 497
        Height = 210
        Align = alLeft
        ExplicitWidth = 497
        ExplicitHeight = 210
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object clMovementItemId: TcxGridDBColumn
            Caption = 'Id '#1089#1090#1088#1086#1082#1080
            DataBinding.FieldName = 'MovementItemId'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object clUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
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
          object OperDate_swt: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1090#1072#1073#1077#1083#1103
            DataBinding.FieldName = 'OperDate_swt'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
      object cxGridProtocolData: TcxGrid
        Left = 497
        Top = 0
        Width = 288
        Height = 210
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = 487
        ExplicitWidth = 298
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
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 785
    Height = 57
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 100
      Top = 5
      EditValue = 42005d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 302
      Top = 5
      EditValue = 42005d
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object edUser: TcxButtonEdit
      Left = 100
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 206
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 32
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    object cxLabel2: TcxLabel
      Left = 195
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 329
      Top = 32
      Caption = #1054#1073#1098#1077#1082#1090':'
    end
    object edObject: TcxButtonEdit
      Left = 376
      Top = 32
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 217
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemProtocolSWT'
    Params = <
      item
        Name = 'inStartDate'
        Value = 42005d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42005d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = '0'
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inUnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inStorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 136
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 416
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = edObject
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 128
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    Key = '0'
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
    Left = 176
    Top = 32
  end
  object ProtocolDataCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 584
    Top = 119
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
    Left = 648
    Top = 119
  end
  object dsdXMLTransform: TdsdXMLTransform
    DataSource = MasterDS
    XMLDataFieldName = 'ProtocolData'
    DataSet = ProtocolDataCDS
    Left = 496
    Top = 112
  end
end
