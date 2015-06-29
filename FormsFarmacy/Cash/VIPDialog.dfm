inherited VIPDialogForm: TVIPDialogForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' VIP '#1095#1077#1082#1086#1074
  ClientHeight = 110
  ClientWidth = 554
  Position = poDesktopCenter
  ExplicitWidth = 560
  ExplicitHeight = 135
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 554
    Height = 69
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 24
    ExplicitTop = 8
    ExplicitWidth = 617
    ExplicitHeight = 89
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 57
      Height = 13
      Caption = #1052#1077#1085#1077#1076#1078#1077#1088':'
    end
    object Label2: TLabel
      Left = 295
      Top = 8
      Width = 111
      Height = 13
      Caption = #1060#1072#1084#1080#1083#1080#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103':'
    end
    object ceMember: TcxButtonEdit
      Left = 16
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1084#1077#1085#1077#1076#1078#1077#1088#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 0
      Width = 265
    end
    object edBayerName: TcxTextEdit
      Left = 295
      Top = 27
      TabOrder = 1
      Width = 250
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 69
    Width = 554
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 168
    ExplicitTop = 95
    ExplicitWidth = 185
    object btnOk: TcxButton
      Left = 315
      Top = 9
      Width = 105
      Height = 25
      Caption = 'Ok (Enter)'
      Default = True
      ModalResult = 1
      OptionsImage.ImageIndex = 7
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 0
    end
    object btnCancel: TcxButton
      Left = 440
      Top = 9
      Width = 105
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072' (Esc)'
      ModalResult = 2
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 48
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 48
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 47
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 264
    Top = 48
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 200
    Top = 48
  end
end
