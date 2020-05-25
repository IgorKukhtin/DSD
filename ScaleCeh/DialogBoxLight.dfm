inherited DialogBoxLightForm: TDialogBoxLightForm
  Caption = #1042#1074#1086#1076' '#1064'/'#1050' '#1080#1083#1080' '#1082#1086#1076' '#1103#1097#1080#1082#1072
  ClientHeight = 216
  ClientWidth = 374
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 390
  ExplicitHeight = 251
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 175
    Width = 374
    ExplicitTop = 175
    ExplicitWidth = 374
    inherited bbOk: TBitBtn
      Left = 51
      Top = 9
      Default = False
      ExplicitLeft = 51
      ExplicitTop = 9
    end
    inherited bbCancel: TBitBtn
      Left = 135
      Top = 9
      ExplicitLeft = 135
      ExplicitTop = 9
    end
  end
  object PanelValue: TPanel
    Left = 0
    Top = 0
    Width = 374
    Height = 175
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Box3Panel: TPanel
      Left = 0
      Top = 41
      Width = 374
      Height = 41
      Align = alTop
      TabOrder = 0
      object Box3Label: TcxLabel
        Left = 38
        Top = 11
        Caption = #1051#1080#1085#1080#1103' 3 :'
      end
      object BoxCode3Label: TcxLabel
        Left = 108
        Top = 11
        Caption = '(123)'
        Properties.Alignment.Horz = taRightJustify
        AnchorX = 138
      end
      object Light_3Memo: TMemo
        Left = 278
        Top = 10
        Width = 33
        Height = 22
        ReadOnly = True
        TabOrder = 2
        OnEnter = Light_1MemoEnter
      end
      object Box3Edit: TcxTextEdit
        Left = 144
        Top = 10
        Properties.MaxLength = 128
        Properties.OnChange = Box3EditChange
        TabOrder = 3
        OnEnter = Box3EditEnter
        OnExit = Box3EditExit
        OnKeyDown = Box3EditKeyDown
        OnKeyPress = Box3EditKeyPress
        Width = 117
      end
    end
    object infoMsgPanel: TPanel
      Left = 0
      Top = 0
      Width = 374
      Height = 41
      Align = alTop
      TabOrder = 1
      object MsgBlinkLabel: TcxLabel
        Left = 1
        Top = 19
        Align = alClient
        Caption = #1055#1088#1086#1089#1082#1072#1085#1080#1088#1091#1081#1090#1077' '#1085#1072' '#1082#1072#1082#1086#1081' '#1083#1080#1085#1080#1080' '#1073#1091#1076#1091#1090' '#1064#1058'.'
        ParentColor = False
        ParentFont = False
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebsSingle
        Style.Color = clBtnFace
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Arial Narrow'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        AnchorX = 187
        AnchorY = 30
      end
      object MsgMainLabel: TcxLabel
        Left = 1
        Top = 1
        Align = alTop
        Caption = #1042#1072#1084' '#1087#1086#1085#1072#1076#1086#1073#1080#1090#1089#1103' 3 '#1103#1097#1080#1082#1072' '#1045'2 (12 '#1082#1075'.) '#1076#1083#1103' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
        ParentFont = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.HotTrack = False
        Style.Shadow = False
        Style.IsFontAssigned = True
        Properties.Alignment.Horz = taCenter
        AnchorX = 187
      end
    end
    object Box1Panel: TPanel
      Left = 0
      Top = 123
      Width = 374
      Height = 41
      Align = alTop
      TabOrder = 2
      object Box1Label: TcxLabel
        Left = 38
        Top = 11
        Caption = #1051#1080#1085#1080#1103' 1 :'
      end
      object BoxCode1Label: TcxLabel
        Left = 108
        Top = 11
        Caption = '(123)'
        Properties.Alignment.Horz = taRightJustify
        AnchorX = 138
      end
      object Light_1Memo: TMemo
        Left = 278
        Top = 10
        Width = 33
        Height = 22
        ReadOnly = True
        TabOrder = 2
        OnEnter = Light_1MemoEnter
      end
      object Box1Edit: TcxTextEdit
        Left = 144
        Top = 10
        Properties.MaxLength = 128
        Properties.OnChange = Box1EditChange
        TabOrder = 3
        OnEnter = Box1EditEnter
        OnExit = Box1EditExit
        OnKeyDown = Box1EditKeyDown
        OnKeyPress = Box1EditKeyPress
        Width = 117
      end
    end
    object Box2Panel: TPanel
      Left = 0
      Top = 82
      Width = 374
      Height = 41
      Align = alTop
      TabOrder = 3
      object Box2Label: TcxLabel
        Left = 38
        Top = 11
        Caption = #1051#1080#1085#1080#1103' 2 :'
      end
      object BoxCode2Label: TcxLabel
        Left = 108
        Top = 11
        Caption = '(123)'
        Properties.Alignment.Horz = taRightJustify
        AnchorX = 138
      end
      object Light_2Memo: TMemo
        Left = 278
        Top = 10
        Width = 33
        Height = 22
        ReadOnly = True
        TabOrder = 2
        OnEnter = Light_1MemoEnter
      end
      object Box2Edit: TcxTextEdit
        Left = 144
        Top = 10
        Properties.MaxLength = 128
        Properties.OnChange = Box2EditChange
        TabOrder = 3
        OnEnter = Box2EditEnter
        OnExit = Box2EditExit
        OnKeyDown = Box2EditKeyDown
        OnKeyPress = Box2EditKeyPress
        Width = 117
      end
    end
  end
  object Timer: TTimer
    Interval = 400
    OnTimer = TimerTimer
    Left = 264
    Top = 176
  end
end
