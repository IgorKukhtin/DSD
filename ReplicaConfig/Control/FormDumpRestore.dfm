object DumpRestoreForm: TDumpRestoreForm
  Left = 0
  Top = 0
  Caption = 'DumpRestoreForm'
  ClientHeight = 618
  ClientWidth = 942
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    942
    618)
  PixelsPerInch = 120
  TextHeight = 16
  object lblPathScript: TLabel
    Left = 24
    Top = 11
    Width = 73
    Height = 16
    Caption = 'Output script'
  end
  object lblProcess: TLabel
    Left = 832
    Top = 107
    Width = 52
    Height = 16
    Caption = 'Running'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object lblDirBin: TLabel
    Left = 24
    Top = 40
    Width = 87
    Height = 16
    Caption = 'PostgreSQL bin'
  end
  object lblHost: TLabel
    Left = 165
    Top = 81
    Width = 56
    Height = 16
    Caption = 'hostname'
  end
  object lblDB: TLabel
    Left = 368
    Top = 81
    Width = 52
    Height = 16
    Caption = 'database'
  end
  object lblUser: TLabel
    Left = 575
    Top = 81
    Width = 68
    Height = 16
    Caption = 'usermname'
  end
  object lblLog: TLabel
    Left = 8
    Top = 159
    Width = 59
    Height = 16
    Caption = 'Output log'
  end
  object sbCleraLog: TSpeedButton
    Left = 911
    Top = 184
    Width = 23
    Height = 22
    OnClick = sbCleraLogClick
  end
  object lblPassword: TLabel
    Left = 705
    Top = 81
    Width = 55
    Height = 16
    Caption = 'password'
  end
  object lblPort: TLabel
    Left = 304
    Top = 81
    Width = 23
    Height = 16
    Caption = 'port'
  end
  object mmLog: TMemo
    Left = 8
    Top = 184
    Width = 889
    Height = 426
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Iosevka'
    Font.Style = []
    Lines.Strings = (
      'mmLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edPath: TEdit
    Left = 128
    Top = 8
    Width = 673
    Height = 24
    TabOrder = 1
    Text = '.\script.sql'
  end
  object rbDump: TRadioButton
    Left = 24
    Top = 99
    Width = 87
    Height = 17
    Caption = 'pg_dump'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = rbDumpClick
  end
  object rbRestore: TRadioButton
    Left = 24
    Top = 128
    Width = 87
    Height = 17
    Caption = 'pg_restore'
    TabOrder = 3
    OnClick = rbDumpClick
  end
  object btnExecute: TButton
    Left = 822
    Top = 129
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 4
    OnClick = btnExecuteClick
  end
  object edDirBin: TEdit
    Left = 128
    Top = 38
    Width = 673
    Height = 24
    TabOrder = 5
    Text = 'c:\Program Files\PostgreSQL\12\bin\'
  end
  object edHostDump: TEdit
    Left = 117
    Top = 99
    Width = 172
    Height = 24
    TabOrder = 6
    Text = 'project-vds.vds.colocall.com'
  end
  object edDBDump: TEdit
    Left = 344
    Top = 99
    Width = 200
    Height = 24
    TabOrder = 8
    Text = 'pod_test'
  end
  object edUserDump: TEdit
    Left = 551
    Top = 99
    Width = 120
    Height = 24
    TabOrder = 9
    Text = 'postgres'
  end
  object edHostRestore: TEdit
    Left = 117
    Top = 129
    Width = 172
    Height = 24
    Enabled = False
    TabOrder = 10
    Text = 'project-vds.vds.colocall.com'
  end
  object edDBRestore: TEdit
    Left = 345
    Top = 129
    Width = 200
    Height = 24
    Enabled = False
    TabOrder = 12
    Text = 'pod_test_slave'
  end
  object edUserRestore: TEdit
    Left = 551
    Top = 129
    Width = 120
    Height = 24
    Enabled = False
    TabOrder = 13
    Text = 'postgres'
  end
  object chbDrop: TCheckBox
    Left = 779
    Top = 68
    Width = 161
    Height = 17
    Caption = 'Generate drop objects'
    Checked = True
    State = cbChecked
    TabOrder = 14
  end
  object edPswDump: TEdit
    Left = 681
    Top = 99
    Width = 120
    Height = 24
    TabOrder = 15
    Text = 'sqoII5szOnrcZxJVF1BL'
  end
  object edPswRestore: TEdit
    Left = 681
    Top = 129
    Width = 120
    Height = 24
    Enabled = False
    TabOrder = 16
    Text = 'sqoII5szOnrcZxJVF1BL'
  end
  object edPortDump: TEdit
    Left = 291
    Top = 99
    Width = 50
    Height = 24
    TabOrder = 7
    Text = '5432'
  end
  object edPortRestore: TEdit
    Left = 291
    Top = 129
    Width = 50
    Height = 24
    Enabled = False
    TabOrder = 11
    Text = '5432'
  end
end
