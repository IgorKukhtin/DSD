inherited ContractEditForm: TContractEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
  ClientHeight = 387
  ClientWidth = 789
  ExplicitWidth = 795
  ExplicitHeight = 419
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 353
    TabOrder = 2
    ExplicitTop = 353
  end
  inherited bbCancel: TcxButton
    Top = 353
    ExplicitTop = 353
  end
  object edInvNumber: TcxTextEdit [2]
    Left = 116
    Top = 23
    TabOrder = 0
    Width = 228
  end
  object LbInvNumber: TcxLabel [3]
    Left = 116
    Top = 5
    Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel3: TcxLabel [4]
    Left = 16
    Top = 165
    Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel4: TcxLabel [5]
    Left = 16
    Top = 85
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceComment: TcxTextEdit [6]
    Left = 16
    Top = 317
    TabOrder = 4
    Width = 328
  end
  object cxLabel5: TcxLabel [7]
    Left = 16
    Top = 302
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edContractKind: TcxButtonEdit [8]
    Left = 16
    Top = 183
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 162
  end
  object edJuridical: TcxButtonEdit [9]
    Left = 16
    Top = 103
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 215
  end
  object edSigningDate: TcxDateEdit [10]
    Left = 18
    Top = 63
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 103
  end
  object cxLabel1: TcxLabel [11]
    Left = 16
    Top = 45
    Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103
  end
  object cxLabel2: TcxLabel [12]
    Left = 127
    Top = 45
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
  end
  object edStartDate: TcxDateEdit [13]
    Left = 127
    Top = 63
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 103
  end
  object edEndDate: TcxDateEdit [14]
    Left = 241
    Top = 63
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 12
    Width = 103
  end
  object cxLabel6: TcxLabel [15]
    Left = 241
    Top = 45
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
  end
  object cxLabel9: TcxLabel [16]
    Left = 183
    Top = 125
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object edInfoMoney: TcxButtonEdit [17]
    Left = 183
    Top = 143
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 161
  end
  object edPaidKind: TcxButtonEdit [18]
    Left = 241
    Top = 103
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 103
  end
  object cxLabel10: TcxLabel [19]
    Left = 241
    Top = 85
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel11: TcxLabel [20]
    Left = 16
    Top = 5
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit [21]
    Left = 16
    Top = 23
    Enabled = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 19
    Width = 89
  end
  object cxLabel12: TcxLabel [22]
    Left = 183
    Top = 165
    Caption = #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' '#8470
  end
  object edInvNumberArchive: TcxTextEdit [23]
    Left = 183
    Top = 183
    TabOrder = 21
    Width = 161
  end
  object cxLabel7: TcxLabel [24]
    Left = 16
    Top = 258
    Caption = #1054#1090#1074'.'#1089#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object edPersonal: TcxButtonEdit [25]
    Left = 16
    Top = 275
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 162
  end
  object cxLabel8: TcxLabel [26]
    Left = 183
    Top = 258
    Caption = #1056#1077#1075#1080#1086#1085
  end
  object edArea: TcxButtonEdit [27]
    Left = 183
    Top = 275
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 162
  end
  object cxLabel13: TcxLabel [28]
    Left = 16
    Top = 210
    Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractArticle: TcxButtonEdit [29]
    Left = 16
    Top = 231
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 162
  end
  object cxLabel14: TcxLabel [30]
    Left = 183
    Top = 210
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractStateKind: TcxButtonEdit [31]
    Left = 183
    Top = 231
    Properties.Buttons = <
      item
        Action = actGetStateKindUnSigned
        Kind = bkGlyph
      end
      item
        Action = actGetStateKindPartner
        Kind = bkGlyph
      end
      item
        Action = actGetStateKindSigned
        Default = True
        Kind = bkGlyph
      end
      item
        Action = actGetStateKindClose
        Kind = bkGlyph
      end>
    Properties.Images = dmMain.ImageList
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 162
  end
  object Panel: TPanel [32]
    Left = 356
    Top = 0
    Width = 433
    Height = 387
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 30
    object cxGridContractCondition: TcxGrid
      Left = 0
      Top = 26
      Width = 433
      Height = 172
      Align = alTop
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableViewContractCondition: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ContractConditionDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object cContractConditionKindName: TcxGridDBColumn
          Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
          DataBinding.FieldName = 'ContractConditionKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ContractConditionKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentVert = vaCenter
          Width = 601
        end
        object clValue: TcxGridDBColumn
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          DataBinding.FieldName = 'Value'
          HeaderAlignmentVert = vaCenter
          Width = 553
        end
        object colisErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
        end
      end
      object cxGridContractConditionLevel: TcxGridLevel
        GridView = cxGridDBTableViewContractCondition
      end
    end
    object dxBarDockControl1: TdxBarDockControl
      Left = 0
      Top = 0
      Width = 433
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object dxBarDockControl2: TdxBarDockControl
      Left = 0
      Top = 198
      Width = 433
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object cxDBVerticalGrid: TcxDBVerticalGrid
      Left = 0
      Top = 224
      Width = 433
      Height = 163
      Align = alClient
      Images = dmMain.ImageList
      LayoutStyle = lsMultiRecordView
      OptionsView.RowHeaderWidth = 109
      OptionsView.RowHeight = 60
      OptionsView.ValueWidth = 104
      OptionsData.Editing = False
      OptionsData.Appending = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      Navigator.Buttons.CustomButtons = <>
      Styles.Header = dmMain.cxHeaderStyle
      TabOrder = 3
      DataController.DataSource = DocumentDS
      Version = 1
      object colFileName: TcxDBEditorRow
        Options.CanAutoHeight = False
        Height = 142
        Properties.Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
        Properties.HeaderAlignmentHorz = taCenter
        Properties.HeaderAlignmentVert = vaCenter
        Properties.ImageIndex = 28
        Properties.EditPropertiesClassName = 'TcxLabelProperties'
        Properties.EditProperties.Alignment.Horz = taCenter
        Properties.EditProperties.Alignment.Vert = taVCenter
        Properties.EditProperties.WordWrap = True
        Properties.DataBinding.FieldName = 'FileName'
        Properties.Options.Editing = False
        ID = 0
        ParentID = -1
        Index = 0
        Version = 1
      end
    end
  end
  object cxLabel15: TcxLabel [33]
    Left = 16
    Top = 125
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edMainJuridical: TcxButtonEdit [34]
    Left = 16
    Top = 143
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 38
    Width = 162
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 331
    Top = 360
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 184
    Top = 344
  end
  inherited ActionList: TActionList
    Left = 159
    Top = 343
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectContractCondition
        end
        item
          StoredProc = spDocumentSelect
        end>
    end
    object actConditionRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ContractConditionKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ContractConditionKindChoiceForm'
      FormName = 'TContractConditionKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindId'
        end
        item
          Name = 'TextValue'
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object InsertRecordCCK: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableViewContractCondition
      Action = ContractConditionKindChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1058#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object actContractCondition: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateContractCondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractCondition
        end>
      Caption = 'actUpdateDataSetCCK'
      DataSource = ContractConditionDS
    end
    object actInsertDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertDocument
      StoredProcList = <
        item
          StoredProc = spInsertDocument
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 0
    end
    object DocumentRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spDocumentSelect
      StoredProcList = <
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object DocumentOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      Document = Document
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 60
    end
    object MultiActionInsertContractCondition: TMultiAction
      Category = 'DSDLib'
      ActionList = <
        item
          Action = spInserUpdateContract
        end
        item
          Action = InsertRecordCCK
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object MultiActionInsertDocument: TMultiAction
      Category = 'DSDLib'
      ActionList = <
        item
          Action = spInserUpdateContract
        end
        item
          Action = actInsertDocument
        end
        item
          Action = DocumentRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object spInserUpdateContract: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'spInserUpdateContract'
    end
    object actSetErasedContractCondition: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErasedCondition
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCondition
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ContractConditionDS
    end
    object actSetUnErasedContractCondition: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErasedCondition
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCondition
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ContractConditionDS
    end
    object actDeleteDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spDeleteDocument
      StoredProcList = <
        item
          StoredProc = spDeleteDocument
        end
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
    end
    object actGetStateKindUnSigned: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spGetStateKindUnSigned
      StoredProcList = <
        item
          StoredProc = spGetStateKindUnSigned
        end>
      Caption = 'actGetStateKindUnSigned'
      ImageIndex = 11
    end
    object actGetStateKindSigned: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spGetStateKindSigned
      StoredProcList = <
        item
          StoredProc = spGetStateKindSigned
        end>
      Caption = 'actGetStateKindSigned'
      ImageIndex = 12
    end
    object actGetStateKindPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spGetStateKindPartner
      StoredProcList = <
        item
          StoredProc = spGetStateKindPartner
        end>
      Caption = 'actGetStateKindClose'
      ImageIndex = 66
    end
    object actGetStateKindClose: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spGetStateKindClose
      StoredProcList = <
        item
          StoredProc = spGetStateKindClose
        end>
      Caption = 'actGetStateKindClose'
      ImageIndex = 13
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 112
    Top = 316
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Contract'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberArchive'
        Value = ''
        Component = edInvNumberArchive
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inSigningDate'
        Value = 0d
        Component = edSigningDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Value = 0d
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 0d
        Component = edEndDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalBasisId'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ParamType = ptInput
      end
      item
        Name = 'inContractKindId'
        Value = ''
        Component = ContractKindGuides
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ParamType = ptInput
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = PersonalGuides
        ParamType = ptInput
      end
      item
        Name = 'inAreaId'
        Value = ''
        Component = AreaGuides
        ParamType = ptInput
      end
      item
        Name = 'inContractArticleId'
        Value = ''
        Component = ContractArticleGuides
        ParamType = ptInput
      end
      item
        Name = 'inContractStateKindId'
        Value = ''
        Component = ContractStateKindGuides
        ParamType = ptInput
      end>
    Left = 320
    Top = 336
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Contract'
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'InvNumberArchive'
        Value = ''
        Component = edInvNumberArchive
        DataType = ftString
      end
      item
        Name = 'SigningDate'
        Value = 0d
        Component = edSigningDate
        DataType = ftDateTime
      end
      item
        Name = 'StartDate'
        Value = 0d
        Component = edStartDate
        DataType = ftDateTime
      end
      item
        Name = 'EndDate'
        Value = 0d
        Component = edEndDate
        DataType = ftDateTime
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractKindId'
        Value = ''
        Component = ContractKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractKindName'
        Value = ''
        Component = ContractKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'AreaId'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'AreaName'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractArticleId'
        Value = ''
        Component = ContractArticleGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractArticleName'
        Value = ''
        Component = ContractArticleGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractStateKindId'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractStateKindName'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 272
    Top = 320
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 88
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 143
  end
  object ContractKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractKind
    FormNameParam.Value = 'TContractKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = 0
      end>
    Left = 112
    Top = 183
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 271
  end
  object AreaGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 240
    Top = 271
  end
  object ContractArticleGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractArticle
    FormNameParam.Value = 'TContractArticleForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractArticleForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractArticleGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractArticleGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 72
    Top = 223
  end
  object ContractStateKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractStateKind
    FormNameParam.Value = 'TContractStateKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractStateKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 223
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 280
    Top = 96
  end
  object ContractConditionDS: TDataSource
    DataSet = ContractConditionCDS
    Left = 446
    Top = 125
  end
  object ContractConditionCDS: TClientDataSet
    Aggregates = <>
    PacketRecords = 0
    Params = <>
    Left = 433
    Top = 149
  end
  object spInsertUpdateContractCondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inValue'
        Component = ContractConditionCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inContractConditionKindId'
        Component = ContractConditionCDS
        ComponentItem = 'ContractConditionKindId'
        ParamType = ptInput
      end>
    Left = 392
    Top = 88
  end
  object spSelectContractCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractConditionByContract'
    DataSet = ContractConditionCDS
    DataSets = <
      item
        DataSet = ContractConditionCDS
      end>
    Params = <
      item
        Name = 'incontractid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 418
    Top = 117
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 32
    Top = 344
    DockControlHeights = (
      0
      0
      0
      0)
    object BarManagerBar1: TdxBar
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1088#1072#1073#1086#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl1
      DockedDockControl = dxBarDockControl1
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 811
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertCondition'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedContractCondition'
        end
        item
          Visible = True
          ItemName = 'bbSetUnerasedCondition'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbConditionRefresh'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBar2: TdxBar
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl2
      DockedDockControl = dxBarDockControl2
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 811
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbAddDocument'
        end
        item
          Visible = True
          ItemName = 'bbDeleteDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'bbRefreshDoc'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbAddDocument: TdxBarButton
      Action = MultiActionInsertDocument
      Category = 0
    end
    object bbRefreshDoc: TdxBarButton
      Action = DocumentRefresh
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Enabled = False
      Hint = '   '
      Visible = ivAlways
    end
    object bbOpenDocument: TdxBarButton
      Action = DocumentOpenAction
      Category = 0
    end
    object bbInsertCondition: TdxBarButton
      Action = MultiActionInsertContractCondition
      Category = 0
    end
    object bbConditionRefresh: TdxBarButton
      Action = actConditionRefresh
      Category = 0
    end
    object bbSetErasedContractCondition: TdxBarButton
      Action = actSetErasedContractCondition
      Category = 0
    end
    object bbSetUnerasedCondition: TdxBarButton
      Action = actSetUnErasedContractCondition
      Category = 0
    end
    object bbDeleteDocument: TdxBarButton
      Action = actDeleteDocument
      Category = 0
    end
  end
  object spDocumentSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractDocument'
    DataSet = DocumentCDS
    DataSets = <
      item
        DataSet = DocumentCDS
      end>
    Params = <
      item
        Name = 'incontractid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 496
    Top = 320
  end
  object DocumentDS: TDataSource
    DataSet = DocumentCDS
    Left = 544
    Top = 296
  end
  object DocumentCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 576
    Top = 280
  end
  object Document: TDocument
    GetBlobProcedure = spGetDocument
    Left = 520
    Top = 240
  end
  object spInsertDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'indocumentname'
        Value = ''
        Component = Document
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'incontractdocumentdata'
        Value = '789C535018D10000F1E01FE1'
        Component = Document
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
      end>
    Left = 488
    Top = 288
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ContractDocument'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'incontractdocumentid'
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 584
    Top = 232
  end
  object MainJuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMainJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MainJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 136
  end
  object spErasedUnErasedCondition: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 496
    Top = 72
  end
  object DBViewAddOnCondition: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContractCondition
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    Left = 616
    Top = 72
  end
  object spDeleteDocument: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_ContractDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 648
    Top = 272
  end
  object spGetStateKindUnSigned: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 2
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 352
    Top = 224
  end
  object spGetStateKindSigned: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 1
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 368
    Top = 240
  end
  object spGetStateKindClose: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 3
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 392
    Top = 248
  end
  object spGetStateKindPartner: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 4
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 416
    Top = 232
  end
end
