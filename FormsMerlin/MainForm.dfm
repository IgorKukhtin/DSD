inherited MainForm: TMainForm
  Caption = 'Merlin'
  ClientHeight = 168
  ClientWidth = 805
  KeyPreview = True
  ExplicitWidth = 821
  ExplicitHeight = 226
  PixelsPerInch = 96
  TextHeight = 13
  inherited ActionList: TActionList
    Left = 336
    Top = 8
    object actReport_Goods: TdsdOpenForm [0]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitTree: TdsdOpenForm [1]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1054#1090#1076#1077#1083#1099
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTaxKindEdit: TdsdOpenForm [2]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1053#1044#1057' ('#1082#1086#1088#1088'.)'
      FormName = 'TTaxKindEditForm'
      FormNameParam.Value = 'TTaxKindEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm [3]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1054#1090#1076#1077#1083#1099' ('#1089#1087#1080#1089#1086#1082')'
      FormName = 'TUnitForm'
      FormNameParam.Value = 'TUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCashTree: TdsdOpenForm [4]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1099
      FormName = 'TCashTreeForm'
      FormNameParam.Value = 'TCashTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDocTag: TdsdOpenForm [5]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      FormName = 'TDocTagForm'
      FormNameParam.Value = 'TDocTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateMessage: TdsdOpenForm [6]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1057#1086#1086#1073#1097#1077#1085#1080#1081
      FormName = 'TTranslateMessageForm'
      FormNameParam.Value = 'TTranslateMessageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorKind: TdsdOpenForm [7]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' Boat Structure'
      FormName = 'TProdColorKindForm'
      FormNameParam.Value = 'TProdColorKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actExit: TFileExit
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    object actUser: TdsdOpenForm [12]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actForms: TdsdOpenForm [16]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      FormName = 'TFormsForm'
      FormNameParam.Value = 'TFormsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm [17]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actImportExportLink: TdsdOpenForm
      Enabled = False
    end
    inherited actAccount: TdsdOpenForm [27]
    end
    inherited actProfitLossGroup: TdsdOpenForm [28]
    end
    inherited actProfitLossDirection: TdsdOpenForm [29]
    end
    object actCurrency: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1072
      FormName = 'TCurrencyForm'
      FormNameParam.Value = 'TCurrencyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TMemberForm'
      FormNameParam.Value = 'TMemberForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1099' ('#1089#1087#1080#1089#1086#1082')'
      FormName = 'TCashForm'
      FormNameParam.Value = 'TCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = 'TBankAccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLanguage: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1071#1079#1099#1082#1080' '#1087#1077#1088#1077#1074#1086#1076#1072
      FormName = 'TLanguageForm'
      FormNameParam.Value = 'TLanguageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateWord: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1089#1083#1086#1074
      FormName = 'TTranslateWordForm'
      FormNameParam.Value = 'TTranslateWordForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 152
    Top = 8
  end
  inherited StoredProc: TdsdStoredProc
    Left = 48
    Top = 8
  end
  inherited ClientDataSet: TClientDataSet
    Left = 48
    Top = 56
  end
  inherited frxXMLExport: TfrxXMLExport
    Left = 152
    Top = 56
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 48
    Top = 112
  end
  inherited MainMenu: TMainMenu
    Left = 272
    Top = 8
    object miMovement: TMenuItem [0]
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object miHistory: TMenuItem [1]
      Caption = #1048#1089#1090#1086#1088#1080#1080
    end
    object miReport: TMenuItem [2]
      Caption = #1054#1090#1095#1077#1090#1099
    end
    inherited miGuide: TMenuItem
      object miUnit: TMenuItem
        Action = actUnitTree
      end
      object N1: TMenuItem
        Action = actUnit
      end
      object miPriceList: TMenuItem
        Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
        Enabled = False
        Visible = False
      end
      object miLine83: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miCashTree: TMenuItem
        Action = actCashTree
      end
      object miCash: TMenuItem
        Action = actCash
      end
      object miBankAccount: TMenuItem
        Action = actBankAccount
      end
      object miBank: TMenuItem
        Action = actBank
      end
      object miCurrency: TMenuItem
        Action = actCurrency
      end
      object miLine84: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miMember: TMenuItem
        Action = actMember
      end
      object miPersonal: TMenuItem
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      end
      object miPosition: TMenuItem
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      end
    end
    inherited miService: TMenuItem
      inherited miServiceGuide: TMenuItem
        object miForms: TMenuItem [0]
          Action = actForms
        end
      end
      object miUser: TMenuItem [1]
        Action = actUser
      end
      object miRole: TMenuItem [2]
        Action = actRole
      end
      inherited miLine802: TMenuItem [3]
      end
      object miImportType: TMenuItem [4]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [5]
        Action = actImportSettings
      end
      inherited miLine801: TMenuItem [6]
      end
      inherited miProtocolAll: TMenuItem [7]
        inherited miProtocol: TMenuItem
          Enabled = False
          Visible = False
        end
        inherited miMovementProtocol: TMenuItem
          Enabled = False
          Visible = False
        end
      end
    end
  end
  inherited frxXLSExport: TfrxXLSExport
    Left = 152
    Top = 112
  end
end
