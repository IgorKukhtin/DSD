object AncestorMainForm: TAncestorMainForm
  Left = 0
  Top = 0
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' '#1059#1095#1077#1090' '#171'Project'#187
  ClientHeight = 170
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 192
    Top = 40
    object actExit: TFileExit
      Category = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = #1042#1099'&x'#1086#1076
      Hint = #1042#1099#1093#1086#1076'|'#1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      ShortCut = 16472
    end
    object actAbout: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
      OnExecute = actAboutExecute
    end
    object actUpdateProgram: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1074#1077#1088#1089#1080#1102' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ShortCut = 57429
      OnExecute = actUpdateProgramExecute
    end
    object actLookAndFeel: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072
      OnExecute = actLookAndFeelExecute
    end
    object actImportSettings: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072
      Hint = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      FormName = 'TImportSettingsForm'
      FormNameParam.Value = 'TImportSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actImportGroup: TdsdOpenForm
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      Hint = #1047#1072#1075#1088#1091#1079#1082#1080
      FormName = 'TImportGroupForm'
      FormNameParam.Value = 'TImportGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actImportType: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      Hint = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      FormName = 'TImportTypeForm'
      FormNameParam.Value = 'TImportTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actImportExportLink: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1080' '#1086#1073#1098#1077#1082#1090#1086#1074
      Hint = #1057#1074#1103#1079#1080' '#1086#1073#1098#1077#1082#1090#1086#1074
      FormName = 'TImportExportLinkForm'
      FormNameParam.Name = 'ff'
      FormNameParam.Value = 'TImportExportLinkForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProtocolUser: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TUserProtocolForm'
      FormNameParam.Value = 'TUserProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProtocolMovement: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProtocol: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoneyGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
      FormName = 'TInfoMoneyGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoneyDestination: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      FormName = 'TInfoMoneyDestinationForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoney: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      FormName = 'TInfoMoneyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAccountGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
      FormName = 'TAccountGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAccountDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      FormName = 'TAccountDirectionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Hint = #1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      FormName = 'TProfitLossGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      FormName = 'TProfitLossDirectionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1095#1077#1090#1072
      Hint = #1057#1095#1077#1090#1072
      FormName = 'TAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLoss: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Hint = #1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      FormName = 'TProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMovementDesc: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      FormName = 'TMovementDescDataForm'
      FormNameParam.Value = 'TMovementDescDataForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 32
    Top = 72
  end
  object StoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ActionByUser'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 72
    Top = 72
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 88
  end
  object frxXMLExport: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssNotSplit
    Left = 288
    Top = 104
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 240
    Top = 56
  end
  object MainMenu: TMainMenu
    Images = dmMain.ImageList
    Left = 496
    Top = 56
    object miGuide: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    object miService: TMenuItem
      Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      object miServiceGuide: TMenuItem
        Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
        object miMovementDesc: TMenuItem
          Action = actMovementDesc
        end
      end
      object miLine801: TMenuItem
        Caption = '-'
      end
      object miProtocolAll: TMenuItem
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083
        object miProtocol: TMenuItem
          Action = actProtocol
          Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
        end
        object miMovementProtocol: TMenuItem
          Action = actProtocolMovement
        end
        object miUserProtocol: TMenuItem
          Action = actProtocolUser
        end
      end
      object miLine802: TMenuItem
        Caption = '-'
      end
      object miLookAndFillSettings: TMenuItem
        Action = actLookAndFeel
      end
      object miAbout: TMenuItem
        Action = actAbout
      end
      object miUpdateProgramm: TMenuItem
        Action = actUpdateProgram
      end
    end
    object miExit: TMenuItem
      Action = actExit
    end
  end
  object frxXLSExport: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 344
    Top = 104
  end
end
