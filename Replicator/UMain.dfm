object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Replicator'
  ClientHeight = 768
  ClientWidth = 1184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 1184
    Height = 768
    ActivePage = tsCompare
    Align = alClient
    TabOrder = 0
    object tsLog: TTabSheet
      Caption = #1051#1086#1075
      object pnlLogTop: TPanel
        Left = 0
        Top = 0
        Width = 1176
        Height = 220
        Align = alTop
        TabOrder = 0
        DesignSize = (
          1176
          220)
        object grpAllData: TGroupBox
          Left = 21
          Top = 6
          Width = 1132
          Height = 76
          Anchors = [akLeft, akTop, akRight]
          Caption = '  '#1042#1089#1077' '#1076#1072#1085#1085#1099#1077'  '
          Color = clCream
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          DesignSize = (
            1132
            76)
          object lbAllMinId: TLabel
            Left = 18
            Top = 24
            Width = 29
            Height = 13
            Caption = 'min Id'
          end
          object lbAllMaxId: TLabel
            Left = 184
            Top = 24
            Width = 33
            Height = 13
            Caption = 'max Id'
          end
          object lbAllStart: TLabel
            Left = 572
            Top = 24
            Width = 99
            Height = 13
            Caption = #1085#1072#1095#1072#1083#1086' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          end
          object lbAllRecCount: TLabel
            Left = 357
            Top = 24
            Width = 71
            Height = 13
            Caption = #1074#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081
          end
          object lbAllElapsed: TLabel
            Left = 801
            Top = 24
            Width = 38
            Height = 13
            Caption = #1087#1088#1086#1096#1083#1086
          end
          object edtAllMinId: TEdit
            Left = 51
            Top = 21
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 0
          end
          object edtAllMaxId: TEdit
            Left = 221
            Top = 21
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 1
          end
          object edtAllRecCount: TEdit
            Left = 432
            Top = 21
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 2
          end
          object pbAll: TProgressBar
            Left = 18
            Top = 56
            Width = 1093
            Height = 8
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
          end
        end
        object grpSession: TGroupBox
          Left = 21
          Top = 95
          Width = 1132
          Height = 113
          Anchors = [akLeft, akTop, akRight]
          Caption = '  '#1057#1077#1089#1089#1080#1103'  '
          Color = clCream
          ParentBackground = False
          ParentColor = False
          TabOrder = 1
          DesignSize = (
            1132
            113)
          object lbSsnMinId: TLabel
            Left = 18
            Top = 62
            Width = 29
            Height = 13
            Caption = 'min Id'
          end
          object lbSsnMaxId: TLabel
            Left = 184
            Top = 62
            Width = 33
            Height = 13
            Caption = 'max Id'
          end
          object lbSsnRecCount: TLabel
            Left = 357
            Top = 62
            Width = 71
            Height = 13
            Caption = #1074#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081
          end
          object lbSsnStart: TLabel
            Left = 572
            Top = 62
            Width = 72
            Height = 13
            Caption = #1085#1072#1095#1072#1083#1086' '#1089#1077#1089#1089#1080#1080
          end
          object lbSsnElapsed: TLabel
            Left = 801
            Top = 62
            Width = 38
            Height = 13
            Caption = #1087#1088#1086#1096#1083#1086
          end
          object lbPacketRange: TLabel
            Left = 221
            Top = 22
            Width = 85
            Height = 13
            Caption = #1082#1086#1084#1072#1085#1076' '#1074' '#1087#1072#1082#1077#1090#1077
          end
          object lbSelectRange: TLabel
            Left = 18
            Top = 22
            Width = 80
            Height = 13
            Caption = #1079#1072#1087#1080#1089#1077#1081' '#1074' select'
          end
          object lbSsnNumber: TLabel
            Left = 572
            Top = 22
            Width = 52
            Height = 13
            Caption = #1089#1077#1089#1089#1080#1103' '#8470' '
          end
          object edtSsnMinId: TEdit
            Left = 51
            Top = 59
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 0
          end
          object edtSsnMaxId: TEdit
            Left = 221
            Top = 59
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 1
          end
          object edtSsnRecCount: TEdit
            Left = 432
            Top = 59
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 2
          end
          object sePacketRange: TSpinEdit
            Left = 311
            Top = 19
            Width = 85
            Height = 22
            Increment = 1000
            MaxValue = 100000
            MinValue = 1
            TabOrder = 3
            Value = 1000
            OnChange = sePacketRangeChange
          end
          object seSelectRange: TSpinEdit
            Left = 104
            Top = 19
            Width = 85
            Height = 22
            Increment = 1000
            MaxValue = 100000
            MinValue = 1
            TabOrder = 4
            Value = 1000
            OnChange = seSelectRangeChange
          end
          object pbSession: TProgressBar
            Left = 18
            Top = 91
            Width = 1093
            Height = 8
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 5
            Visible = False
          end
          object chkStopIfErr: TCheckBox
            Left = 801
            Top = 24
            Width = 240
            Height = 17
            Caption = ' '#1086#1089#1090#1072#1085#1086#1074#1080#1090#1100', '#1077#1089#1083#1080' '#1086#1096#1080#1073#1082#1072' '#1085#1072' '#1096#1072#1075#1077' '#8470'1'
            TabOrder = 6
            OnClick = chkStopIfErrClick
          end
        end
      end
      object pnlLogLeft: TPanel
        Left = 0
        Top = 220
        Width = 233
        Height = 520
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object btnSendSinglePacket: TButton
          Left = 4
          Top = 481
          Width = 223
          Height = 25
          Caption = #1058#1077#1089#1090' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1086#1076#1085#1086#1075#1086' '#1087#1072#1082#1077#1090#1072
          TabOrder = 0
          Visible = False
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
          Top = 445
          Width = 223
          Height = 25
          Caption = 'SQL  '#1076#1083#1103' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1082#1086#1084#1072#1085#1076' '#1086#1076#1085#1086#1075#1086' '#1087#1072#1082#1077#1090#1072
          TabOrder = 3
          Visible = False
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
        object btnStartReplication: TButton
          Left = 4
          Top = 98
          Width = 223
          Height = 25
          Caption = #1057#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          TabOrder = 7
          OnClick = btnStartReplicationClick
        end
        object btnStop: TButton
          Left = 4
          Top = 131
          Width = 223
          Height = 25
          Caption = #1057#1090#1086#1087
          Enabled = False
          TabOrder = 8
          OnClick = btnStopClick
        end
      end
      object pnlLog: TPanel
        Left = 233
        Top = 220
        Width = 943
        Height = 520
        Align = alClient
        TabOrder = 2
        object pgcLog: TPageControl
          Left = 1
          Top = 1
          Width = 941
          Height = 518
          ActivePage = tsMemo
          Align = alClient
          TabOrder = 0
          object tsMemo: TTabSheet
            Caption = 'tsMemo'
            TabVisible = False
            object lstLog: TListBox
              Left = 0
              Top = 0
              Width = 933
              Height = 508
              Align = alClient
              Color = clWindowText
              DoubleBuffered = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 14
              ParentDoubleBuffered = False
              ParentFont = False
              TabOrder = 0
            end
          end
          object tsChk: TTabSheet
            Caption = 'tsChk'
            ImageIndex = 1
            TabVisible = False
          end
        end
      end
    end
    object tsCompare: TTabSheet
      Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' Master '#1080' Slave'
      ImageIndex = 2
      object pnlCompareTop: TPanel
        Left = 0
        Top = 0
        Width = 1176
        Height = 41
        Align = alTop
        TabOrder = 0
        object lbCompareExecuting: TLabel
          Left = 131
          Top = 13
          Width = 119
          Height = 13
          Caption = #1074#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#1079#1072#1087#1088#1086#1089' ...'
          Visible = False
        end
        object btnUpdateCompare: TButton
          Left = 22
          Top = 8
          Width = 75
          Height = 25
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btnUpdateCompareClick
        end
        object chkDeviationOnly: TCheckBox
          Left = 297
          Top = 12
          Width = 153
          Height = 17
          Caption = #1090#1086#1083#1100#1082#1086' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103
          TabOrder = 1
        end
      end
      object pnlCompareGrid: TPanel
        Left = 0
        Top = 41
        Width = 1176
        Height = 699
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object grdCompare: TDBGrid
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 1170
          Height = 693
          Align = alClient
          DataSource = dsCompare
          DefaultDrawing = False
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = grdCompareDrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'TableName'
              Title.Alignment = taCenter
              Title.Caption = #1048#1084#1103' '#1090#1072#1073#1083#1080#1094#1099
              Width = 300
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CountMaster'
              Title.Alignment = taCenter
              Title.Caption = #1082#1086#1083'-'#1074#1086' '#1079#1072#1087#1080#1089#1077#1081' Master'
              Width = 125
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CountSlave'
              Title.Alignment = taCenter
              Title.Caption = #1082#1086#1083'-'#1074#1086' '#1079#1072#1087#1080#1089#1077#1081' Slave'
              Width = 125
              Visible = True
            end>
        end
      end
    end
    object tsSettings: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 1
      DesignSize = (
        1176
        740)
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
        Width = 1129
        Height = 185
        Anchors = [akLeft, akTop, akRight]
        Caption = '  Master  '
        TabOrder = 0
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
        Width = 1129
        Height = 185
        Anchors = [akLeft, akTop, akRight]
        Caption = '  Slave  '
        TabOrder = 1
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
        OnChange = edtLibLocationChange
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
        Left = 334
        Top = 446
        Width = 169
        Height = 17
        Caption = ' '#1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1083#1086#1075' '#1074' '#1092#1072#1081#1083
        TabOrder = 4
        OnClick = chkWriteLogClick
      end
      object chkShowLog: TCheckBox
        Left = 139
        Top = 446
        Width = 153
        Height = 17
        Caption = ' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1083#1086#1075' '#1085#1072' '#1101#1082#1088#1072#1085#1077
        TabOrder = 5
        OnClick = chkShowLogClick
      end
      object chkWriteCommands: TCheckBox
        Left = 510
        Top = 446
        Width = 177
        Height = 17
        Caption = ' '#1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1082#1086#1084#1072#1085#1076#1099' '#1074' '#1092#1072#1081#1083
        TabOrder = 6
        OnClick = chkWriteCommandsClick
      end
    end
  end
  object opndlgMain: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 564
    Top = 551
  end
  object tmrElapsed: TTimer
    Enabled = False
    OnTimer = tmrElapsedTimer
    Left = 1049
    Top = 39
  end
  object dsCompare: TDataSource
    Left = 1004
    Top = 249
  end
end
