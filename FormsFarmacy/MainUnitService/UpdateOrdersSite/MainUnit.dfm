object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1086#1074' '#1086#1087#1091#1073#1083#1077#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1086#1084
  ClientHeight = 330
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 33
    Align = alTop
    TabOrder = 0
    object btnAll: TButton
      Left = 16
      Top = 2
      Width = 97
      Height = 25
      Caption = #1042#1089#1077' '#1076#1077#1081#1089#1090#1074#1080#1103'!'
      TabOrder = 1
      OnClick = btnAllClick
    end
    object btnDownloadPublished: TButton
      Left = 128
      Top = 3
      Width = 265
      Height = 25
      Action = actFD_DownloadPublishedSite
      TabOrder = 0
      OnClick = btnDownloadPublishedClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 592
    Height = 297
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 1
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 32
    Top = 80
  end
  object spSite_Param: TdsdStoredProc
    StoredProcName = 'gpGet_MySQL_Site_Param'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outHost'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPort'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDataBase'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_DataBase'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUsername'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Username'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 80
  end
  object spUpdate_PublishedSite: TdsdStoredProc
    StoredProcName = 'gpUpdate_GoodsMain_PublishedSite'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJSON'
        Value = Null
        Component = FormParams
        ComponentItem = 'JSON'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 144
  end
  object ActionList1: TActionList
    Left = 32
    Top = 153
    object actSite_Param: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSite_Param
      StoredProcList = <
        item
          StoredProc = spSite_Param
        end>
      Caption = 'actSite_Param'
    end
    object actUpdate_PublishedSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PublishedSite
      StoredProcList = <
        item
          StoredProc = spUpdate_PublishedSite
        end>
      Caption = 'actUpdate_PublishedSite'
    end
    object actFD_DownloadPublishedSite: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      BeforeAction = actSite_Param
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Catalog = ''
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.HostName = ''
      ZConnection.Port = 0
      ZConnection.Database = ''
      ZConnection.User = ''
      ZConnection.Password = ''
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 
        'select Postgres_drug_id As Id, Status AS isPublished  from pharm' +
        '_drugs'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      Operation = fdoMultiExecuteJSON
      Params = <>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      MultiExecuteAction = actUpdate_PublishedSite
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1072
      ImageIndex = 27
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MySQL_Host'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Port'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_DataBase'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Username'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JSON'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 80
  end
end
