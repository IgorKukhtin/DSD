inherited ContractEditForm: TContractEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
  ClientHeight = 668
  ClientWidth = 911
  ExplicitWidth = 917
  ExplicitHeight = 693
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 67
    Top = 638
    Height = 23
    TabOrder = 2
    ExplicitLeft = 67
    ExplicitTop = 638
    ExplicitHeight = 23
  end
  inherited bbCancel: TcxButton
    Left = 213
    Top = 638
    Height = 23
    ExplicitLeft = 213
    ExplicitTop = 638
    ExplicitHeight = 23
  end
  object edInvNumber: TcxTextEdit [2]
    Left = 16
    Top = 85
    TabOrder = 0
    Width = 104
  end
  object LbInvNumber: TcxLabel [3]
    Left = 16
    Top = 68
    Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel3: TcxLabel [4]
    Left = 16
    Top = 226
    Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel4: TcxLabel [5]
    Left = 127
    Top = 147
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceComment: TcxTextEdit [6]
    Left = 16
    Top = 487
    TabOrder = 4
    Width = 162
  end
  object cxLabel5: TcxLabel [7]
    Left = 16
    Top = 473
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edContractKind: TcxButtonEdit [8]
    Left = 16
    Top = 244
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
    Left = 127
    Top = 164
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 217
  end
  object edSigningDate: TcxDateEdit [10]
    Left = 16
    Top = 124
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 104
  end
  object cxLabel1: TcxLabel [11]
    Left = 16
    Top = 106
    Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103
  end
  object cxLabel2: TcxLabel [12]
    Left = 127
    Top = 106
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
  end
  object edStartDate: TcxDateEdit [13]
    Left = 127
    Top = 124
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 103
  end
  object edEndDate: TcxDateEdit [14]
    Left = 241
    Top = 124
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 12
    Width = 103
  end
  object cxLabel6: TcxLabel [15]
    Left = 241
    Top = 106
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
  end
  object cxLabel9: TcxLabel [16]
    Left = 18
    Top = 187
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object edInfoMoney: TcxButtonEdit [17]
    Left = 16
    Top = 203
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 162
  end
  object edPaidKind: TcxButtonEdit [18]
    Left = 16
    Top = 164
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 104
  end
  object cxLabel10: TcxLabel [19]
    Left = 18
    Top = 147
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel11: TcxLabel [20]
    Left = 16
    Top = 21
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit [21]
    Left = 16
    Top = 38
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 104
  end
  object cxLabel12: TcxLabel [22]
    Left = 183
    Top = 226
    Caption = #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' '#8470
  end
  object edInvNumberArchive: TcxTextEdit [23]
    Left = 183
    Top = 245
    TabOrder = 21
    Width = 161
  end
  object cxLabel7: TcxLabel [24]
    Left = 16
    Top = 309
    Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
  end
  object edPersonal: TcxButtonEdit [25]
    Left = 16
    Top = 326
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
    Left = 184
    Top = 310
    Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
  end
  object edAreaContract: TcxButtonEdit [27]
    Left = 183
    Top = 328
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 161
  end
  object cxLabel13: TcxLabel [28]
    Left = 18
    Top = 267
    Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractArticle: TcxButtonEdit [29]
    Left = 16
    Top = 284
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
    Top = 267
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractStateKind: TcxButtonEdit [31]
    Left = 183
    Top = 285
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
    Width = 161
  end
  object Panel: TPanel [32]
    Left = 352
    Top = 0
    Width = 559
    Height = 668
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 30
    object cxGridContractCondition: TcxGrid
      Left = 0
      Top = 26
      Width = 559
      Height = 198
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
        object clBonusKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1073#1086#1085#1091#1089#1072
          DataBinding.FieldName = 'BonusKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = BonusKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object cContractConditionKindName: TcxGridDBColumn
          Caption = #1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
          DataBinding.FieldName = 'ContractConditionKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ContractConditionKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object clValue: TcxGridDBColumn
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          DataBinding.FieldName = 'Value'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 44
        end
        object clccInfoMoneyName: TcxGridDBColumn
          Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = InfoMoneyChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 87
        end
        object colComment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 59
        end
        object colisErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
        end
      end
      object cxGridContractConditionLevel: TcxGridLevel
        GridView = cxGridDBTableViewContractCondition
      end
    end
    object dxBarDockControl1: TdxBarDockControl
      Left = 0
      Top = 0
      Width = 559
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object dxBarDockControl2: TdxBarDockControl
      Left = 0
      Top = 224
      Width = 559
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object cxDBVerticalGrid: TcxDBVerticalGrid
      Left = 0
      Top = 250
      Width = 559
      Height = 418
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
    Left = 184
    Top = 473
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edMainJuridical: TcxButtonEdit [34]
    Left = 183
    Top = 487
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 163
  end
  object cxLabel16: TcxLabel [35]
    Left = 16
    Top = 432
    Caption = #1041#1072#1085#1082' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
  end
  object edBankId: TcxButtonEdit [36]
    Left = 16
    Top = 449
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 36
    Width = 162
  end
  object edBankAccountExternal: TcxTextEdit [37]
    Left = 183
    Top = 449
    TabOrder = 38
    Width = 161
  end
  object cxLabel17: TcxLabel [38]
    Left = 184
    Top = 432
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
  end
  object cbisDefault: TcxCheckBox [39]
    Left = 127
    Top = 38
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    TabOrder = 39
    Width = 97
  end
  object ceisStandart: TcxCheckBox [40]
    Left = 127
    Top = 10
    Caption = #1058#1080#1087#1086#1074#1086#1081
    TabOrder = 42
    Width = 67
  end
  object cxLabel18: TcxLabel [41]
    Left = 184
    Top = 353
    Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
  end
  object cxLabel19: TcxLabel [42]
    Left = 16
    Top = 353
    Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
  end
  object edPersonalTrade: TcxButtonEdit [43]
    Left = 183
    Top = 370
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 161
  end
  object edPersonalCollation: TcxButtonEdit [44]
    Left = 16
    Top = 370
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 46
    Width = 162
  end
  object cxLabel20: TcxLabel [45]
    Left = 18
    Top = 394
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1074#1093'.'#1087#1083#1072#1090#1077#1078')'
  end
  object cxLabel21: TcxLabel [46]
    Left = 127
    Top = 67
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractTag: TcxButtonEdit [47]
    Left = 127
    Top = 85
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 47
    Width = 217
  end
  object ceBankAccount: TcxButtonEdit [48]
    Left = 16
    Top = 409
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 162
  end
  object ceisPersonal: TcxCheckBox [49]
    Left = 222
    Top = 10
    Caption = #1057#1083#1091#1078#1077#1073#1085#1072#1103' '#1079#1072#1087#1080#1089#1082#1072
    TabOrder = 49
    Width = 122
  end
  object ceIsUnique: TcxCheckBox [50]
    Left = 222
    Top = 38
    Caption = #1056#1072#1089#1095#1077#1090' '#1076#1086#1083#1075#1072
    TabOrder = 51
    Width = 108
  end
  object cxLabel22: TcxLabel [51]
    Left = 185
    Top = 394
    Caption = #1050#1086#1076' GLN - '#1087#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edGLNCode: TcxTextEdit [52]
    Left = 183
    Top = 409
    TabOrder = 53
    Width = 161
  end
  object cxLabel23: TcxLabel [53]
    Left = 183
    Top = 187
    Caption = #1070#1088'. '#1083#1080#1094#1086'('#1087#1077#1095#1072#1090#1100' '#1076#1086#1082'.)'
  end
  object edJuridicalDocument: TcxButtonEdit [54]
    Left = 183
    Top = 203
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 55
    Width = 163
  end
  object cxLabel24: TcxLabel [55]
    Left = 18
    Top = 509
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  end
  object cePriceList: TcxButtonEdit [56]
    Left = 18
    Top = 525
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 160
  end
  object cxLabel25: TcxLabel [57]
    Left = 184
    Top = 509
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1040#1082#1094#1080#1086#1085#1085#1099#1081')'
  end
  object cePriceListPromo: TcxButtonEdit [58]
    Left = 183
    Top = 525
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 59
    Width = 161
  end
  object cxLabel26: TcxLabel [59]
    Left = 18
    Top = 547
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
  end
  object edStartPromo: TcxDateEdit [60]
    Left = 18
    Top = 566
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 61
    Width = 100
  end
  object cxLabel27: TcxLabel [61]
    Left = 184
    Top = 547
    Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1072#1082#1094#1080#1080
  end
  object edEndPromo: TcxDateEdit [62]
    Left = 183
    Top = 566
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 64
    Width = 100
  end
  object cxLabel28: TcxLabel [63]
    Left = 18
    Top = 590
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsProperty: TcxButtonEdit [64]
    Left = 20
    Top = 609
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 68
    Width = 326
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 499
    Top = 476
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 392
    Top = 467
  end
  inherited ActionList: TActionList
    Left = 405
    Top = 437
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
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ContractConditionKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractConditionKindChoiceForm'
      FormName = 'TContractConditionKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object InsertRecordCCK: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewContractCondition
      Action = ContractConditionKindChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1058#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object InfoMoneyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'InfoMoneyChoiceForm'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actContractCondition: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateContractCondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractCondition
        end>
      Caption = 'actUpdateDataSetCCK'
      DataSource = ContractConditionDS
    end
    object BonusKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BonusKindChoiceForm'
      FormName = 'TBonusKindForm'
      FormNameParam.Value = 'TBonusKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'BonusKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'BonusKindName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actInsertDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      MoveParams = <>
      StoredProc = spDocumentSelect
      StoredProcList = <
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object DocumentOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Document
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      ImageIndex = 60
    end
    object MultiActionInsertContractCondition: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spInserUpdateContract
        end
        item
          Action = InsertRecordCCK
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object MultiActionInsertDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
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
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      ImageIndex = 0
    end
    object spInserUpdateContract: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'spInserUpdateContract'
    end
    object actSetErasedContractCondition: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedCondition
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCondition
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ContractConditionDS
    end
    object actSetUnErasedContractCondition: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteDocument
      StoredProcList = <
        item
          StoredProc = spDeleteDocument
        end
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
    end
    object actGetStateKindUnSigned: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetStateKind_Partner
      StoredProcList = <
        item
          StoredProc = spGetStateKind_Partner
        end>
      Caption = 'actGetStateKindClose'
      ImageIndex = 66
    end
    object actGetStateKindClose: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
    Left = 488
    Top = 423
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
        Name = 'inBankAccountExternal'
        Value = ''
        Component = edBankAccountExternal
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNCode'
        Value = ''
        Component = edGLNCode
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
        Name = 'inJuridicalDocumentId'
        Value = Null
        Component = JuridicalDocumentGuides
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
        Name = 'inPersonalTradeId'
        Value = ''
        Component = PersonalTradeGuides
        ParamType = ptInput
      end
      item
        Name = 'inPersonalCollationId'
        Value = ''
        Component = PersonalCollationGuides
        ParamType = ptInput
      end
      item
        Name = 'inBankAccountId'
        Value = ''
        Component = BankAccountGuides
        ParamType = ptInput
      end
      item
        Name = 'inContractTagId'
        Value = ''
        Component = ContractTagGuides
        ParamType = ptInput
      end
      item
        Name = 'inAreaContractId'
        Value = ''
        Component = AreaContractGuides
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
      end
      item
        Name = 'inBankId'
        Value = ''
        Component = BankGuides
        ParamType = ptInput
      end
      item
        Name = 'inisDefault'
        Value = 'False'
        Component = cbisDefault
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inisStandart'
        Value = 'False'
        Component = ceisStandart
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inisPersonal'
        Value = 'False'
        Component = ceisPersonal
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inisUnique'
        Value = 'False'
        Component = ceIsUnique
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListPromoId'
        Value = Null
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inStartPromo'
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'InEndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 592
    Top = 420
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
        Name = 'PersonalTradeId'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalTradeName'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalCollationId'
        Value = ''
        Component = PersonalCollationGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalCollationName'
        Value = ''
        Component = PersonalCollationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BankAccountId'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BankAccountName'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractTagId'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractTagName'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'AreaContractId'
        Value = ''
        Component = AreaContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'AreaContractName'
        Value = ''
        Component = AreaContractGuides
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
        Name = 'BankAccountExternal'
        Value = ''
        Component = edBankAccountExternal
        DataType = ftString
      end
      item
        Name = 'GLNCode'
        Value = ''
        Component = edGLNCode
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
      end
      item
        Name = 'JuridicalDocumentId'
        Value = Null
        Component = JuridicalDocumentGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalDocumentName'
        Value = Null
        Component = JuridicalDocumentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BankId'
        Value = ''
        Component = BankGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BankName'
        Value = ''
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'isDefault'
        Value = 'False'
        Component = cbisDefault
        DataType = ftBoolean
      end
      item
        Name = 'isStandart'
        Value = 'False'
        Component = ceisStandart
        DataType = ftBoolean
      end
      item
        Name = 'isPersonal'
        Value = 'False'
        Component = ceisPersonal
        DataType = ftBoolean
      end
      item
        Name = 'isUnique'
        Value = 'False'
        Component = ceIsUnique
        DataType = ftBoolean
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = dsdPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PriceListPromoId'
        Value = Null
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PriceListPromoName'
        Value = Null
        Component = dsdPriceListPromoGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'StartPromo'
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'GoodsPropertyName'
        Value = Null
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 632
    Top = 395
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Left = 245
    Top = 132
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
    Left = 46
    Top = 181
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
    Left = 96
    Top = 220
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
    Top = 314
  end
  object AreaContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAreaContract
    FormNameParam.Value = 'TAreaContractForm'
    FormNameParam.DataType = ftString
    FormName = 'TAreaContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AreaContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AreaContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 245
    Top = 312
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
    Left = 128
    Top = 267
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
    Left = 364
    Top = 267
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
    Left = 88
    Top = 141
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
    Left = 481
    Top = 135
  end
  object spInsertUpdateContractCondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue'
        Value = Null
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
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'ContractConditionKindId'
        ParamType = ptInput
      end
      item
        Name = 'inBonusKindId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'BonusKindId'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 736
    Top = 72
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
    PackSize = 1
    Left = 442
    Top = 63
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
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
    Left = 376
    Top = 435
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
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefreshDoc'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
    PackSize = 1
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
    PackSize = 1
    Left = 448
    Top = 344
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ContractDocument'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'incontractdocumentid'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 584
    Top = 232
  end
  object MainJuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMainJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Left = 256
    Top = 463
  end
  object spErasedUnErasedCondition: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 512
    Top = 80
  end
  object DBViewAddOnCondition: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContractCondition
    OnDblClickActionList = <>
    ActionItemList = <
      item
        Action = actSetErasedContractCondition
        ShortCut = 46
        SecondaryShortCuts.Strings = (
          'Del')
      end
      item
        Action = actSetUnErasedContractCondition
        ShortCut = 46
        SecondaryShortCuts.Strings = (
          'Del')
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
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
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
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
    PackSize = 1
    Left = 768
    Top = 362
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
    PackSize = 1
    Left = 768
    Top = 410
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
    PackSize = 1
    Left = 768
    Top = 458
  end
  object spGetStateKind_Partner: TdsdStoredProc
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
    PackSize = 1
    Left = 768
    Top = 306
  end
  object BankGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankId
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 437
  end
  object PersonalTradeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 348
    Top = 331
  end
  object PersonalCollationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalCollation
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalCollationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalCollationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 358
  end
  object BankAccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 67
    Top = 395
  end
  object ContractTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 344
    Top = 52
  end
  object JuridicalDocumentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalDocument
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalDocumentGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalDocumentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 245
    Top = 196
  end
  object dsdPriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceList
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 97
    Top = 506
  end
  object dsdPriceListPromoGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceListPromo
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 280
    Top = 490
  end
  object GoodsPropertyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 152
    Top = 592
  end
end
