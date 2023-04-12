object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 
    #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080#1093#1086#1076#1085#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1086#1090' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1086#1088#1072' '#1074' '#1084#1077#1076#1088#1077#1077#1089#1090#1088' Pfizer' +
    ' '#1052#1044#1052
  ClientHeight = 330
  ClientWidth = 751
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
    Width = 751
    Height = 33
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 1
    ExplicitTop = -5
    ExplicitWidth = 592
    object btnAll: TButton
      Left = 25
      Top = 2
      Width = 97
      Height = 25
      Caption = #1042#1089#1077' '#1076#1077#1081#1089#1090#1074#1080#1103'!'
      TabOrder = 1
      OnClick = btnAllClick
    end
    object btnOpenIncome: TButton
      Left = 128
      Top = 3
      Width = 137
      Height = 25
      Action = actSelectUnloadMovement
      TabOrder = 0
    end
    object btnSendIncome: TButton
      Left = 271
      Top = 3
      Width = 137
      Height = 25
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 27
      TabOrder = 2
      OnClick = btnSendIncomeClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 751
    Height = 297
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 592
    object cxGrid1: TcxGrid
      Left = 1
      Top = 1
      Width = 749
      Height = 295
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = 0
      ExplicitWidth = 590
      object cxGrid1DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = MasterDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1055#1088#1080#1093#1086#1076#1086#1074' 0'
            Kind = skCount
            Column = ToName
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        object FromName: TcxGridDBColumn
          Caption = #1055#1086#1089#1090'.'
          DataBinding.FieldName = 'FromName'
          HeaderAlignmentHorz = taCenter
          Width = 121
        end
        object ToName: TcxGridDBColumn
          Caption = #1040#1087#1090#1077#1082#1072
          DataBinding.FieldName = 'ToName'
          HeaderAlignmentHorz = taCenter
          Width = 168
        end
        object JuridicalName: TcxGridDBColumn
          Caption = #1070#1088'. '#1083#1080#1094#1086
          DataBinding.FieldName = 'JuridicalName'
          HeaderAlignmentHorz = taCenter
          Width = 99
        end
        object InvNumber: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'.'
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          Width = 70
        end
        object OperDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          Width = 67
        end
        object UserName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079'.'
          DataBinding.FieldName = 'UserName'
          HeaderAlignmentHorz = taCenter
          Width = 108
        end
        object Password: TcxGridDBColumn
          Caption = #1055#1072#1088#1086#1083#1100
          DataBinding.FieldName = 'Password'
          HeaderAlignmentHorz = taCenter
          Width = 69
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 32
    Top = 80
  end
  object ActionList1: TActionList
    Left = 32
    Top = 145
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
    Left = 288
    Top = 80
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
    Left = 144
    Top = 82
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 144
    Top = 145
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 144
    Top = 209
  end
end
