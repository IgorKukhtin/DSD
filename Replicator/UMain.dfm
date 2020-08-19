object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Replicator'
  ClientHeight = 662
  ClientWidth = 984
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
    Width = 984
    Height = 662
    ActivePage = tsSettings
    Align = alClient
    TabOrder = 0
    object tsLog: TTabSheet
      Caption = #1051#1086#1075
      object pnlLogTop: TPanel
        Left = 0
        Top = 0
        Width = 976
        Height = 220
        Align = alTop
        TabOrder = 0
        DesignSize = (
          976
          220)
        object grpAllData: TGroupBox
          Left = 21
          Top = 6
          Width = 932
          Height = 76
          Anchors = [akLeft, akTop, akRight]
          Caption = '  '#1042#1089#1077' '#1076#1072#1085#1085#1099#1077'  '
          Color = clCream
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          DesignSize = (
            932
            76)
          object lbAllMinId: TLabel
            Left = 18
            Top = 24
            Width = 29
            Height = 13
            Caption = 'min Id'
          end
          object lbAllMaxId: TLabel
            Left = 169
            Top = 24
            Width = 33
            Height = 13
            Caption = 'max Id'
          end
          object lbAllStart: TLabel
            Left = 526
            Top = 24
            Width = 99
            Height = 13
            Caption = #1085#1072#1095#1072#1083#1086' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          end
          object lbAllRecCount: TLabel
            Left = 329
            Top = 24
            Width = 71
            Height = 13
            Caption = #1074#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081
          end
          object lbAllElapsed: TLabel
            Left = 772
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
            Left = 206
            Top = 21
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 1
          end
          object edtAllRecCount: TEdit
            Left = 404
            Top = 21
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 2
          end
          object pbAll: TProgressBar
            Left = 18
            Top = 56
            Width = 893
            Height = 8
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
          end
        end
        object grpSession: TGroupBox
          Left = 21
          Top = 95
          Width = 932
          Height = 113
          Anchors = [akLeft, akTop, akRight]
          Caption = '  '#1057#1077#1089#1089#1080#1103'  '
          Color = clCream
          ParentBackground = False
          ParentColor = False
          TabOrder = 1
          DesignSize = (
            932
            113)
          object lbSsnMinId: TLabel
            Left = 18
            Top = 62
            Width = 29
            Height = 13
            Caption = 'min Id'
          end
          object lbSsnMaxId: TLabel
            Left = 169
            Top = 62
            Width = 33
            Height = 13
            Caption = 'max Id'
          end
          object lbSsnRecCount: TLabel
            Left = 329
            Top = 62
            Width = 71
            Height = 13
            Caption = #1074#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081
          end
          object lbSsnStart: TLabel
            Left = 526
            Top = 62
            Width = 72
            Height = 13
            Caption = #1085#1072#1095#1072#1083#1086' '#1089#1077#1089#1089#1080#1080
          end
          object lbSsnElapsed: TLabel
            Left = 772
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
            Left = 465
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
            Left = 206
            Top = 59
            Width = 100
            Height = 21
            ReadOnly = True
            TabOrder = 1
          end
          object edtSsnRecCount: TEdit
            Left = 404
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
            MaxValue = 1000000
            MinValue = 0
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
            MaxValue = 999000000
            MinValue = 0
            TabOrder = 4
            Value = 10000
            OnChange = seSelectRangeChange
          end
          object pbSession: TProgressBar
            Left = 18
            Top = 91
            Width = 893
            Height = 8
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 5
            Visible = False
          end
          object chkStopIfErr: TCheckBox
            Left = 689
            Top = 21
            Width = 219
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
        Width = 132
        Height = 414
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
          Top = 11
          Width = 122
          Height = 25
          Caption = 'Test Master'
          TabOrder = 1
          OnClick = btnTestMasterClick
        end
        object btnTestSlave: TButton
          Left = 4
          Top = 40
          Width = 122
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
          Top = 78
          Width = 57
          Height = 25
          Caption = 'Min Id'
          TabOrder = 4
          OnClick = btnMinIdClick
        end
        object btnMaxId: TButton
          Left = 4
          Top = 107
          Width = 122
          Height = 25
          Caption = 'Max Id'
          TabOrder = 5
          OnClick = btnMaxIdClick
        end
        object btnUseMinId: TButton
          Left = 59
          Top = 78
          Width = 67
          Height = 25
          Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' MinId '#1082#1072#1082' '#1089#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          Caption = #1082#1072#1082' '#1089#1090#1072#1088#1090
          TabOrder = 6
          OnClick = btnUseMinIdClick
        end
        object btnStartReplication: TButton
          Left = 4
          Top = 150
          Width = 122
          Height = 25
          Caption = #1057#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080
          TabOrder = 7
          OnClick = btnStartReplicationClick
        end
        object btnStop: TButton
          Left = 4
          Top = 179
          Width = 122
          Height = 25
          Caption = #1057#1090#1086#1087
          Enabled = False
          TabOrder = 8
          OnClick = btnStopClick
        end
        object btnMoveProcsToSlave: TButton
          Left = 4
          Top = 221
          Width = 122
          Height = 39
          Caption = #1057#1090#1072#1088#1090' '#1088#1077#1087#1083#1080#1082#1072#1094#1080#1080' table_ddl '#1085#1072' Slave'
          TabOrder = 9
          WordWrap = True
          OnClick = btnMoveProcsToSlaveClick
        end
        object btnStopMoveProcsToSlave: TButton
          Left = 4
          Top = 264
          Width = 122
          Height = 25
          Caption = #1057#1090#1086#1087
          Enabled = False
          TabOrder = 10
          OnClick = btnStopMoveProcsToSlaveClick
        end
      end
      object pnlLog: TPanel
        Left = 132
        Top = 220
        Width = 844
        Height = 414
        Align = alClient
        TabOrder = 2
        object pgcLog: TPageControl
          Left = 1
          Top = 1
          Width = 842
          Height = 412
          ActivePage = tsMemo
          Align = alClient
          TabOrder = 0
          object tsMemo: TTabSheet
            Caption = 'tsMemo'
            TabVisible = False
            object lstLog: TListBox
              Left = 0
              Top = 0
              Width = 834
              Height = 402
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
        Width = 976
        Height = 41
        Align = alTop
        TabOrder = 0
        object lbCompareExecuting: TLabel
          Left = 205
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
          Left = 340
          Top = 12
          Width = 153
          Height = 17
          Caption = #1090#1086#1083#1100#1082#1086' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103
          TabOrder = 1
        end
        object btnCancelCompare: TButton
          Left = 110
          Top = 8
          Width = 75
          Height = 25
          Caption = #1054#1090#1084#1077#1085#1072
          Enabled = False
          TabOrder = 2
          OnClick = btnCancelCompareClick
        end
      end
      object pnlCompareGrid: TPanel
        Left = 0
        Top = 41
        Width = 976
        Height = 593
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object grdCompare: TDBGrid
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 970
          Height = 587
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
      ExplicitLeft = 0
      ExplicitTop = 28
      DesignSize = (
        976
        634)
      object lbLibLocation: TLabel
        Left = 24
        Top = 536
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1091#1090#1100' '#1082' libpq.dll'
      end
      object lbReconnectTimeout: TLabel
        Left = 24
        Top = 586
        Width = 305
        Height = 13
        Caption = #1087#1088#1080' '#1087#1086#1090#1077#1088#1077' '#1089#1074#1103#1079#1080' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1077#1088#1077#1087#1086#1076#1082#1083#1102#1095#1072#1090#1100#1089#1103' '#1095#1077#1088#1077#1079' '
      end
      object lbReconnectMinute: TLabel
        Left = 417
        Top = 586
        Width = 288
        Height = 13
        Caption = #1084#1080#1085#1091#1090'   ( 0  '#1086#1079#1085#1072#1095#1072#1077#1090' "'#1085#1077' '#1074#1099#1087#1086#1083#1085#1103#1090#1100' '#1087#1077#1088#1077#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077'")'
      end
      object grpMaster: TGroupBox
        Left = 24
        Top = 23
        Width = 346
        Height = 185
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
          Width = 200
          Height = 21
          TabOrder = 0
        end
        object edtMasterDatabase: TEdit
          Left = 115
          Top = 54
          Width = 200
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
        Width = 346
        Height = 185
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
          Width = 200
          Height = 21
          TabOrder = 0
        end
        object edtSlaveDatabase: TEdit
          Left = 115
          Top = 54
          Width = 200
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
        Left = 103
        Top = 533
        Width = 500
        Height = 21
        TabOrder = 5
        OnChange = edtLibLocationChange
      end
      object btnLibLocation: TButton
        Left = 604
        Top = 531
        Width = 25
        Height = 25
        Hint = #1055#1091#1090#1100' '#1082' '#1082#1083#1080#1077#1085#1090#1089#1082#1086#1081' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1077' PostgreSQL'
        Caption = '...'
        TabOrder = 6
        OnClick = btnLibLocationClick
      end
      object chkWriteLog: TCheckBox
        Left = 219
        Top = 446
        Width = 169
        Height = 17
        Caption = ' '#1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1083#1086#1075' '#1074' '#1092#1072#1081#1083
        TabOrder = 3
        OnClick = chkWriteLogClick
      end
      object chkShowLog: TCheckBox
        Left = 24
        Top = 446
        Width = 153
        Height = 17
        Caption = ' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1083#1086#1075' '#1085#1072' '#1101#1082#1088#1072#1085#1077
        TabOrder = 2
        OnClick = chkShowLogClick
      end
      object chkWriteCommands: TCheckBox
        Left = 395
        Top = 446
        Width = 177
        Height = 17
        Caption = ' '#1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1082#1086#1084#1072#1085#1076#1099' '#1074' '#1092#1072#1081#1083
        TabOrder = 4
        OnClick = chkWriteCommandsClick
      end
      object seReconnectTimeout: TSpinEdit
        Left = 333
        Top = 583
        Width = 80
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 7
        Value = 0
        OnChange = seReconnectTimeoutChange
      end
      object grpScripts: TGroupBox
        Left = 402
        Top = 23
        Width = 551
        Height = 395
        Anchors = [akLeft, akTop, akRight]
        Caption = '  '#1057#1082#1088#1080#1087#1090#1099'  '
        TabOrder = 8
        object pnlScriptBottom: TPanel
          Left = 2
          Top = 353
          Width = 547
          Height = 40
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          object btnApplyScript: TButton
            Left = 21
            Top = 7
            Width = 134
            Height = 25
            Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1089#1082#1088#1080#1087#1090#1099
            TabOrder = 0
            OnClick = btnApplyScriptClick
          end
          object btnCancelScript: TButton
            Left = 167
            Top = 7
            Width = 134
            Height = 25
            Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077
            Enabled = False
            TabOrder = 1
            OnClick = btnCancelScriptClick
          end
          object btnUpdateScriptIni: TButton
            Left = 363
            Top = 7
            Width = 169
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1074' INI-'#1092#1072#1081#1083#1077
            TabOrder = 2
            OnClick = btnUpdateScriptIniClick
          end
        end
        object pnlScriptTop: TPanel
          Left = 2
          Top = 15
          Width = 547
          Height = 338
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            547
            338)
          object lbScriptPath: TLabel
            Left = 15
            Top = 12
            Width = 25
            Height = 13
            Caption = #1055#1091#1090#1100
          end
          object pnlScriptList: TPanel
            Left = 14
            Top = 37
            Width = 522
            Height = 299
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            object mmoScriptLog: TMemo
              Left = 1
              Top = 1
              Width = 520
              Height = 297
              Align = alClient
              Color = clWindowText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Lines.Strings = (
                #1047#1076#1077#1089#1100' '#1073#1091#1076#1077#1090' '#1087#1086#1082#1072#1079#1072#1085#1072' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1093#1086#1076#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
                '')
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 0
              OnChange = mmoScriptLogChange
            end
          end
          object edtScriptPath: TEdit
            Left = 44
            Top = 9
            Width = 466
            Height = 21
            TabOrder = 1
          end
          object btnScriptPath: TButton
            Left = 513
            Top = 7
            Width = 25
            Height = 25
            Caption = '...'
            TabOrder = 2
            OnClick = btnScriptPathClick
          end
        end
      end
      object chkSaveErr1: TCheckBox
        Left = 24
        Top = 485
        Width = 193
        Height = 17
        Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1096#1072#1075#1072' '#8470'1 '#1074' '#1041#1044
        TabOrder = 9
        OnClick = chkSaveErr1Click
      end
      object chkSaveErr2: TCheckBox
        Left = 261
        Top = 485
        Width = 190
        Height = 17
        Caption = #1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1096#1072#1075#1072' '#8470'2 '#1074' '#1041#1044
        TabOrder = 10
        OnClick = chkSaveErr2Click
      end
    end
  end
  object opndlgMain: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 660
    Top = 601
  end
  object tmrElapsed: TTimer
    Enabled = False
    OnTimer = tmrElapsedTimer
    Left = 809
    Top = 600
  end
  object dsCompare: TDataSource
    Left = 740
    Top = 601
  end
  object tmrRestartReplica: TTimer
    Enabled = False
    Left = 892
    Top = 600
  end
end
