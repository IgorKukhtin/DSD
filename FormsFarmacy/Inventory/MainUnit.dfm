object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
  ClientHeight = 330
  ClientWidth = 751
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 751
    Height = 330
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 33
    ExplicitHeight = 297
  end
  object ActionList1: TActionList
    Left = 32
    Top = 57
    object actSelectUnloadMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectUnloadMovement
      StoredProcList = <
        item
          StoredProc = spSelectUnloadMovement
        end>
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
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
    Left = 32
    Top = 128
  end
  object spSelectUnloadMovement: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Pfizer'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <>
    PackSize = 1
    Left = 136
    Top = 66
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 177
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 136
    Top = 121
  end
end
