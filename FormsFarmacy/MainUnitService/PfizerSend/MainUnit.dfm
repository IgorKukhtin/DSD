object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 
    #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080#1093#1086#1076#1085#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1086#1090' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1086#1088#1072' '#1074' '#1084#1077#1076#1088#1077#1077#1089#1090#1088' Pfizer' +
    ' '#1052#1044#1052
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
      Top = 2
      Width = 265
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1072
      ImageIndex = 27
      TabOrder = 0
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
    Left = 392
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
    Left = 400
    Top = 160
  end
  object ActionList1: TActionList
    Left = 32
    Top = 145
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
    Left = 488
    Top = 80
  end
  object spSelectUnloadMovement: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Pfizer'
    DataSets = <>
    Params = <
      item
        Name = 'inDiscountExternalId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 90
  end
end
