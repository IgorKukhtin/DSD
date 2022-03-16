inherited ChoiceMedicalProgramSPForm: TChoiceMedicalProgramSPForm
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' POS '#1090#1077#1088#1084#1080#1085#1072#1083#1072
  ClientHeight = 222
  ClientWidth = 360
  Position = poScreenCenter
  ExplicitWidth = 376
  ExplicitHeight = 261
  PixelsPerInch = 96
  TextHeight = 13
  object BankPOSTerminalGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 360
    Height = 181
    Align = alClient
    TabOrder = 0
    object BankPOSTerminalGridDBTableView: TcxGridDBTableView
      OnDblClick = BankPOSTerminalGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MedicalProgramSPDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'MedicalProgramSPCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'MedicalProgramSPName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 250
      end
    end
    object BankPOSTerminalGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = BankPOSTerminalGridDBTableView
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 181
    Width = 360
    Height = 41
    Align = alBottom
    TabOrder = 1
    object bbCancel: TcxButton
      Left = 221
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 63
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 104
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 256
    Top = 104
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 167
    Top = 103
  end
  object MedicalProgramSPDS: TDataSource
    Left = 40
    Top = 32
  end
end
