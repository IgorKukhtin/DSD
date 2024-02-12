inherited EmailSettingsForm: TEmailSettingsForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1087#1086#1095#1090#1099
  ClientHeight = 316
  ClientWidth = 753
  ExplicitWidth = 769
  ExplicitHeight = 355
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 753
    Height = 258
    ExplicitTop = 58
    ExplicitWidth = 753
    ExplicitHeight = 258
    ClientRectBottom = 258
    ClientRectRight = 753
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 753
      ExplicitHeight = 258
      inherited cxGrid: TcxGrid
        Width = 753
        Height = 258
        ExplicitWidth = 753
        ExplicitHeight = 258
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object EmailKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'EmailKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1087#1086#1095#1090#1099
            Options.Editing = False
            Width = 140
          end
          object EmailToolsName: TcxGridDBColumn
            Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            DataBinding.FieldName = 'EmailToolsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            Options.Editing = False
            Width = 244
          end
          object Value: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'Value'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 753
    Height = 32
    Align = alTop
    TabOrder = 5
    object cxLabel4: TcxLabel
      Left = 8
      Top = 7
      Caption = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
    end
    object ceEmailKind: TcxButtonEdit
      Left = 161
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1058#1080#1087' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 1
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1058#1080#1087' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099'>'
      Width = 252
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = EmailKindGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actInsertUpdate: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actInsertUpdate'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_EmailSettings'
    Params = <
      item
        Name = 'inEmailKindId'
        Value = '0'
        Component = EmailKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 80
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
          ItemName = 'bbChoice'
        end
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
        end>
    end
    object bbLabel: TdxBarControlContainerItem
      Caption = 'bbLabel'
      Category = 0
      Hint = 'bbLabel'
      Visible = ivAlways
    end
    object bbGuides: TdxBarControlContainerItem
      Caption = 'bbGuides'
      Category = 0
      Hint = 'bbGuides'
      Visible = ivAlways
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 416
    Top = 248
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_EmailSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmailKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmailKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmailToolsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmailToolsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 88
  end
  object EmailKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceEmailKind
    Key = '0'
    FormNameParam.Value = 'TEmailKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TEmailKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = EmailKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = EmailKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 424
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = EmailKindGuides
      end>
    Left = 120
    Top = 144
  end
end
