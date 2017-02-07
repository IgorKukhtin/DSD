inherited MainForm: TMainForm
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1079#1072#1082#1072#1079#1072#1084#1080
  ClientHeight = 171
  ClientWidth = 666
  KeyPreview = True
  ExplicitWidth = 682
  ExplicitHeight = 230
  PixelsPerInch = 96
  TextHeight = 13
  inherited ActionList: TActionList
    Left = 328
    inherited actAbout: TAction
      Category = 'but'
    end
    object actUser: TdsdOpenForm [4]
      Category = 'but'
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actForms: TdsdOpenForm [8]
      Category = 'but'
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
    object actRole: TdsdOpenForm [9]
      Category = 'but'
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actProtocol: TdsdOpenForm
      Category = 'but'
    end
    inherited actInfoMoneyGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoneyDestination: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoney: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLoss: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 496
    Top = 24
  end
  inherited StoredProc: TdsdStoredProc
    Left = 48
  end
  inherited ClientDataSet: TClientDataSet
    Left = 104
    Top = 104
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
    Left = 200
  end
  inherited MainMenu: TMainMenu
    Top = 88
    object miLoad: TMenuItem [1]
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      object miImportGroup: TMenuItem
        Action = actImportGroup
      end
    end
    inherited miService: TMenuItem
      inherited N221: TMenuItem
        object N20: TMenuItem [0]
          Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
          object N21: TMenuItem
            Action = actAccountGroup
          end
          object N22: TMenuItem
            Action = actAccountDirection
          end
          object N23: TMenuItem
            Action = actAccount
          end
          object N24: TMenuItem
            Caption = '-'
          end
          object N25: TMenuItem
            Action = actInfoMoneyGroup
          end
          object N26: TMenuItem
            Action = actInfoMoneyDestination
          end
          object N27: TMenuItem
            Action = actInfoMoney
          end
          object N28: TMenuItem
            Caption = '-'
          end
          object N29: TMenuItem
            Action = actProfitLossGroup
          end
          object N30: TMenuItem
            Action = actProfitLossDirection
          end
          object N31: TMenuItem
            Action = actProfitLoss
          end
        end
        object N6: TMenuItem [1]
          Caption = '-'
        end
        object N74: TMenuItem [2]
          Action = actForms
        end
      end
      object miUser: TMenuItem [1]
        Action = actUser
      end
      object miRole: TMenuItem [2]
        Action = actRole
      end
      object miImportType: TMenuItem [3]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [4]
        Action = actImportSettings
      end
      object miImportExportLink: TMenuItem [5]
        Action = actImportExportLink
      end
    end
  end
end
