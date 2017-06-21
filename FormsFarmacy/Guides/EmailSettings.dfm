inherited EmailSettingsForm: TEmailSettingsForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1087#1086#1095#1090#1099
  ClientHeight = 316
  ClientWidth = 771
  ExplicitWidth = 787
  ExplicitHeight = 355
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 771
    Height = 258
    ExplicitTop = 58
    ExplicitWidth = 771
    ExplicitHeight = 258
    ClientRectBottom = 258
    ClientRectRight = 771
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 771
      ExplicitHeight = 258
      inherited cxGrid: TcxGrid
        Width = 771
        Height = 258
        ExplicitWidth = 771
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
            Caption = #1058#1080#1087
            DataBinding.FieldName = 'EmailKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            Options.Editing = False
            Width = 140
          end
          object EmailName: TcxGridDBColumn
            Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082
            DataBinding.FieldName = 'EmailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object EmailToolsName: TcxGridDBColumn
            Caption = #1055#1072#1088#1072#1084#1077#1090#1088' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            DataBinding.FieldName = 'EmailToolsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            Options.Editing = False
            Width = 140
          end
          object Value: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'Value'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 180
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 771
    Height = 32
    Align = alTop
    TabOrder = 5
    object cxLabel4: TcxLabel
      Left = 8
      Top = 7
      Caption = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
    end
    object ceEmail: TcxButtonEdit
      Left = 152
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
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082'>'
      Width = 252
    end
    object cxLabel1: TcxLabel
      Left = 419
      Top = 7
      Caption = #1053#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
    end
  end
  object edValue: TcxTextEdit [2]
    Left = 510
    Top = 6
    TabOrder = 6
    Width = 235
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = EmailGuides
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actInsertUpdateJuridical0: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Juridical
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Juridical
        end>
      Caption = 'actInsertUpdateJuridical0'
      ImageIndex = 27
    end
    object mactInsertUpdateJuridical1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateJuridical0
        end>
      View = cxGridDBTableView
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      ImageIndex = 27
    end
    object macInsertUpdateJuridicalList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateJuridical1
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074'  '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1080' '#1085#1086#1074#1086#1075#1086' '#1079#1085#1072#1095#1077#1085#1080#1103'? '
      InfoAfterExecute = #1070#1088'. '#1083#1080#1094#1086' '#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      ImageIndex = 27
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
        Name = 'inEmailId'
        Value = '0'
        Component = EmailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
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
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate'
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
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbInsertUpdate: TdxBarButton
      Action = macInsertUpdateJuridicalList
      Category = 0
    end
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
        Name = 'inEmailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmailId'
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
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 201
    Top = 96
  end
  object EmailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceEmail
    Key = '0'
    FormNameParam.Value = 'TEmailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TEmailForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = EmailGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = EmailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 8
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = EmailGuides
      end>
    Left = 120
    Top = 144
  end
  object spInsertUpdate_Juridical: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_EmailSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
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
        Component = edValue
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmailId'
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
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 120
  end
end
