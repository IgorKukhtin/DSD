object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Replicator'
  ClientHeight = 592
  ClientWidth = 1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 1074
    Height = 592
    ActivePage = tsLog
    Align = alClient
    TabOrder = 0
    object tsLog: TTabSheet
      Caption = #1051#1086#1075
      object pnlLogTop: TPanel
        Left = 0
        Top = 0
        Width = 1066
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lbRange: TLabel
          Left = 540
          Top = 13
          Width = 92
          Height = 13
          Caption = #1056#1072#1079#1084#1077#1088' '#1076#1080#1072#1087#1072#1079#1086#1085#1072
        end
        object lbStartReplica: TLabel
          Left = 268
          Top = 13
          Width = 94
          Height = 13
          Caption = #1057#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
        end
        object lbLastId: TLabel
          Left = 785
          Top = 14
          Width = 235
          Height = 13
          Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1085#1099#1081' Id = <'#1085#1077#1090' '#1076#1072#1085#1085#1099#1093'>'
        end
        object seRange: TSpinEdit
          Left = 636
          Top = 10
          Width = 100
          Height = 22
          Increment = 1000
          MaxValue = 100000
          MinValue = 1
          TabOrder = 0
          Value = 1000
          OnChange = seRangeChange
        end
        object chkShowLog: TCheckBox
          Left = 125
          Top = 12
          Width = 97
          Height = 17
          Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1083#1086#1075
          TabOrder = 1
          OnClick = chkShowLogClick
        end
        object edtStartReplica: TEdit
          Left = 366
          Top = 11
          Width = 121
          Height = 21
          TabOrder = 2
          OnExit = edtStartReplicaExit
        end
      end
      object pnlLogLeft: TPanel
        Left = 0
        Top = 41
        Width = 233
        Height = 523
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object btnSendSinglePacket: TButton
          Left = 4
          Top = 137
          Width = 223
          Height = 25
          Caption = #1058#1077#1089#1090' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1086#1076#1085#1086#1075#1086' '#1087#1072#1082#1077#1090#1072
          TabOrder = 0
          OnClick = btnSendSinglePacketClick
        end
        object btnTestMaster: TButton
          Left = 4
          Top = 32
          Width = 105
          Height = 25
          Caption = 'Test Master'
          TabOrder = 1
          OnClick = btnTestMasterClick
        end
        object btnTestSlave: TButton
          Left = 122
          Top = 32
          Width = 105
          Height = 25
          Caption = 'Test Slave'
          TabOrder = 2
          OnClick = btnTestSlaveClick
        end
        object btnReplicaCommandsSQL: TButton
          Left = 4
          Top = 101
          Width = 223
          Height = 25
          Caption = 'SQL  '#1076#1083#1103' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1082#1086#1084#1072#1085#1076' '#1086#1076#1085#1086#1075#1086' '#1087#1072#1082#1077#1090#1072
          TabOrder = 3
          OnClick = btnReplicaCommandsSQLClick
        end
        object btnMinId: TButton
          Left = 4
          Top = 64
          Width = 42
          Height = 25
          Caption = 'Min Id'
          TabOrder = 4
          OnClick = btnMinIdClick
        end
        object btnMaxId: TButton
          Left = 122
          Top = 64
          Width = 105
          Height = 25
          Caption = 'Max Id'
          TabOrder = 5
          OnClick = btnMaxIdClick
        end
        object btnUseMinId: TButton
          Left = 42
          Top = 64
          Width = 67
          Height = 25
          Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' MinId '#1082#1072#1082' '#1089#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          Caption = #1082#1072#1082' '#1089#1090#1072#1088#1090
          TabOrder = 6
          OnClick = btnUseMinIdClick
        end
        object btnSendPackets: TButton
          Left = 4
          Top = 172
          Width = 223
          Height = 25
          Caption = #1057#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          TabOrder = 7
          OnClick = btnSendPacketsClick
        end
      end
      object pnlLog: TPanel
        Left = 233
        Top = 41
        Width = 833
        Height = 523
        Align = alClient
        TabOrder = 2
        object pgcLog: TPageControl
          Left = 1
          Top = 1
          Width = 831
          Height = 521
          ActivePage = tsMemo
          Align = alClient
          TabOrder = 0
          object tsMemo: TTabSheet
            Caption = 'tsMemo'
            TabVisible = False
            object mmoLog: TMemo
              Left = 0
              Top = 0
              Width = 823
              Height = 511
              Align = alClient
              Color = clWindowText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 0
              OnChange = mmoLogChange
            end
          end
          object tsChk: TTabSheet
            Caption = 'tsChk'
            ImageIndex = 1
            TabVisible = False
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 646
            ExplicitHeight = 448
          end
        end
      end
    end
    object tsSettings: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 1
      DesignSize = (
        1066
        564)
      object lbLibLocation: TLabel
        Left = 60
        Top = 493
        Width = 73
        Height = 13
        Caption = 'Library location'
      end
      object grpMaster: TGroupBox
        Left = 24
        Top = 23
        Width = 1019
        Height = 185
        Anchors = [akLeft, akTop, akRight]
        Caption = '  Master  '
        TabOrder = 0
        ExplicitWidth = 842
        object lbMasterServer: TLabel
          Left = 45
          Top = 27
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Server'
        end
        object lbDatabase: TLabel
          Left = 45
          Top = 57
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Database'
        end
        object lbMasterUser: TLabel
          Left = 45
          Top = 86
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User'
        end
        object lbMasterPort: TLabel
          Left = 45
          Top = 145
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Port'
        end
        object lbMasterPassword: TLabel
          Left = 45
          Top = 115
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Password'
        end
        object edtMasterServer: TEdit
          Left = 115
          Top = 24
          Width = 400
          Height = 21
          TabOrder = 0
        end
        object edtMasterDatabase: TEdit
          Left = 115
          Top = 54
          Width = 400
          Height = 21
          TabOrder = 1
        end
        object edtMasterUser: TEdit
          Left = 115
          Top = 83
          Width = 200
          Height = 21
          TabOrder = 2
          Text = 'admin'
        end
        object edtMasterPort: TEdit
          Left = 115
          Top = 142
          Width = 200
          Height = 21
          TabOrder = 4
          Text = '5432'
        end
        object edtMasterPassword: TEdit
          Left = 115
          Top = 112
          Width = 200
          Height = 21
          TabOrder = 3
        end
      end
      object grpSlave: TGroupBox
        Left = 24
        Top = 233
        Width = 1019
        Height = 185
        Anchors = [akLeft, akTop, akRight]
        Caption = '  Slave  '
        TabOrder = 1
        ExplicitWidth = 842
        object lbSlaveServer: TLabel
          Left = 45
          Top = 26
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Server'
        end
        object lbSlaveDatabase: TLabel
          Left = 45
          Top = 57
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Database'
        end
        object lbSlaveUser: TLabel
          Left = 45
          Top = 88
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User'
        end
        object lbSlavePassword: TLabel
          Left = 45
          Top = 118
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Password'
        end
        object lbSlavePort: TLabel
          Left = 45
          Top = 149
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Port'
        end
        object edtSlaveServer: TEdit
          Left = 115
          Top = 23
          Width = 500
          Height = 21
          TabOrder = 0
        end
        object edtSlaveDatabase: TEdit
          Left = 115
          Top = 54
          Width = 500
          Height = 21
          TabOrder = 1
        end
        object edtSlaveUser: TEdit
          Left = 115
          Top = 85
          Width = 200
          Height = 21
          TabOrder = 2
          Text = 'admin'
        end
        object edtSlavePassword: TEdit
          Left = 115
          Top = 115
          Width = 200
          Height = 21
          TabOrder = 3
        end
        object edtSlavePort: TEdit
          Left = 115
          Top = 146
          Width = 200
          Height = 21
          TabOrder = 4
          Text = '5432'
        end
      end
      object edtLibLocation: TEdit
        Left = 139
        Top = 490
        Width = 500
        Height = 21
        TabOrder = 2
      end
      object btnLibLocation: TButton
        Left = 640
        Top = 488
        Width = 25
        Height = 25
        Hint = #1055#1091#1090#1100' '#1082' '#1082#1083#1080#1077#1085#1090#1089#1082#1086#1081' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1077' PostgreSQL'
        Caption = '...'
        TabOrder = 3
        OnClick = btnLibLocationClick
      end
      object chkWriteLog: TCheckBox
        Left = 139
        Top = 446
        Width = 169
        Height = 17
        Caption = #1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1083#1086#1075' '#1074' '#1092#1072#1081#1083
        TabOrder = 4
        OnClick = chkWriteLogClick
      end
    end
  end
  object opndlgMain: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 716
    Top = 471
  end
end
