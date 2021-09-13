object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1072#1082#1091#1084#1072
  ClientHeight = 268
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 31
    Align = alTop
    TabOrder = 0
    object btnAll: TButton
      Left = 16
      Top = 0
      Width = 97
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1074#1089#1077#1084'!'
      TabOrder = 0
      OnClick = btnAllClick
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 31
    Width = 467
    Height = 237
    Align = alClient
    ReadOnly = True
    TabOrder = 1
  end
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 5432
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 216
    Top = 56
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 128
  end
  object qryMaker: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'select * from gpSelect_Object_Maker( '#39'3'#39')'
      
        'WHERE SendPlan <= CURRENT_TIMESTAMP AND (SendReal < SendPlan OR ' +
        'SendReal IS NULL) AND'
      
        '(COALESCE (isReport1, FALSE) = TRUE OR COALESCE (isReport2, FALS' +
        'E) = TRUE OR'
      
        'COALESCE (isReport3, FALSE) = TRUE OR COALESCE (isReport4, FALSE' +
        ') = TRUE  OR'
      
        'COALESCE (isReport5, FALSE) = TRUE OR COALESCE (isReport6, FALSE' +
        ') = TRUE) AND'
      'COALESCE (Mail, '#39#39') <> '#39#39';')
    Params = <>
    Left = 144
    Top = 384
  end
  object dsMaker: TDataSource
    DataSet = qryMaker
    Left = 224
    Top = 384
  end
  object qryMailParam: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'SELECT'
      '    zc_Mail_From() AS Mail_From,'
      '    zc_Mail_Host() AS Mail_Host,'
      '    zc_Mail_Port() AS Mail_Port,'
      '    zc_Mail_User() AS Mail_User,'
      '    zc_Mail_Password() AS Mail_Password')
    Params = <>
    Left = 144
    Top = 328
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 556
    Top = 336
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 680
    Top = 336
  end
  object qrySetDateSend: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      
        'select * from gpUpdate_Object_Maker_SendDate (:inMaker, :inAddMo' +
        'nth, :inAddDay, '#39'3'#39');')
    Params = <
      item
        DataType = ftUnknown
        Name = 'inMaker'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddMonth'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddDay'
        ParamType = ptUnknown
      end>
    Left = 144
    Top = 448
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'inMaker'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddMonth'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'inAddDay'
        ParamType = ptUnknown
      end>
  end
  object ZQuery: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 216
    Top = 128
  end
  object ZQueryTable: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'SELECT table_name FROM information_schema.tables'
      
        '                    WHERE table_schema NOT IN ('#39'information_sche' +
        'ma'#39','#39'pg_catalog'#39')'
      '                      AND table_type = '#39'BASE TABLE'#39
      '                    ORDER BY table_name;')
    Params = <>
    Left = 304
    Top = 128
  end
end
