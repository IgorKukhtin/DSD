inherited VIPDialogForm: TVIPDialogForm
  ActiveControl = ceMember
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' VIP '#1095#1077#1082#1086#1074
  ClientHeight = 117
  ClientWidth = 554
  Position = poDesktopCenter
  ExplicitWidth = 560
  ExplicitHeight = 142
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 57
    Height = 13
    Caption = #1052#1077#1085#1077#1076#1078#1077#1088':'
  end
  object Label2: TLabel [1]
    Left = 295
    Top = 8
    Width = 111
    Height = 13
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103':'
  end
  inherited bbOk: TcxButton
    Left = 190
    Top = 75
    ExplicitLeft = 190
    ExplicitTop = 75
  end
  inherited bbCancel: TcxButton
    Left = 311
    Top = 75
    ExplicitLeft = 311
    ExplicitTop = 75
  end
  object ceMember: TcxButtonEdit [4]
    Left = 16
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 2
    Width = 265
  end
  object edBayerName: TcxTextEdit [5]
    Left = 295
    Top = 27
    TabOrder = 3
    Width = 250
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
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MemberId'
        Value = Null
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 112
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
