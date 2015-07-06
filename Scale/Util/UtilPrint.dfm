object UtilPrintForm: TUtilPrintForm
  Left = 0
  Top = 0
  Caption = 'Print'
  ClientHeight = 640
  ClientWidth = 926
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 828
    Top = 70
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 828
    Top = 126
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 828
    Top = 177
  end
  object spGetReporNameTax: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportNameTax'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'gpGet_Movement_Sale_ReportNameTax'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSaleTax'
        DataType = ftString
      end>
    PackSize = 1
    Left = 328
    Top = 120
  end
  object spGetReportName_Sale: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'gpGet_Movement_Sale_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSale'
        DataType = ftString
      end>
    PackSize = 1
    Left = 96
    Top = 240
  end
  object spGetReporNameBill: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportNameBill'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'gpGet_Movement_Sale_ReportNameBill'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSaleBill'
        DataType = ftString
      end>
    PackSize = 1
    Left = 584
    Top = 16
  end
  object spSelectTax_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inisClientCopy'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 327
    Top = 64
  end
  object spSelectTax_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 327
    Top = 16
  end
  object spSelectPrint_Sale: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 175
    Top = 256
  end
  object spSelectPrint_ExpInvoice: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_ExpInvoice_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 455
    Top = 24
  end
  object spSelectPrint_TTN: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 687
    Top = 80
  end
  object spSelectPrint_ExpPack: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_ExpPack_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 447
    Top = 80
  end
  object spSelectPrint_Pack: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Pack_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_by'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_by'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 583
    Top = 120
  end
  object spSelectPrint_Spec: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Spec_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_by'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_by'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 583
    Top = 176
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'ReportNameSale'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ReportNameSaleTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
      end
      item
        Name = 'MovementId_by'
        Value = Null
      end
      item
        Name = 'ReportType'
        Value = Null
      end
      item
        Name = 'EDIEventsName'
        Value = Null
        DataType = ftString
      end>
    Left = 40
    Top = 16
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 39
    Top = 74
    object mactPrint_QualityDoc: TMultiAction
      Category = 'Print_QualityDoc'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_QualityDoc
        end
        item
          Action = actPrint_QualityDoc
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      ImageIndex = 16
    end
    object actDialog_QualityDoc: TdsdOpenForm
      Category = 'Print_QualityDoc'
      MoveParams = <>
      Caption = 'actDialog_QualityDoc'
      Hint = 'actDialog_QualityDoc'
      FormName = 'TQualityDocForm'
      FormNameParam.Value = 'TQualityDocForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      isShowModal = True
    end
    object mactPrint_TTN: TMultiAction
      Category = 'Print_TTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_TTN
        end
        item
          Action = actPrint_TTN
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 15
    end
    object actDialog_TTN: TdsdOpenForm
      Category = 'Print_TTN'
      MoveParams = <>
      Caption = 'actDialog_TTN'
      Hint = 'actDialog_TTN'
      FormName = 'TTransportGoodsForm'
      FormNameParam.Value = 'TTransportGoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_by'
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
        end>
      isShowModal = True
    end
    object actPrint_ExpInvoice: TdsdPrintAction
      Category = 'Print_Export'
      MoveParams = <>
      StoredProc = spSelectPrint_ExpInvoice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ExpInvoice
        end>
      Caption = #1048#1085#1074#1086#1081#1089' ('#1101#1082#1089#1087#1086#1088#1090')'
      Hint = #1048#1085#1074#1086#1081#1089' ('#1101#1082#1089#1087#1086#1088#1090')'
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupName_Juridical;GoodsName_Juridical;GoodsName;GoodsKindName'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SaleInvoice'
      ReportNameParam.Name = 'PrintMovement_SaleInvoice'
      ReportNameParam.Value = 'PrintMovement_SaleInvoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_Tax_ReportName: TdsdExecStoredProc
      Category = 'Print_Tax'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTax
      StoredProcList = <
        item
          StoredProc = spGetReporNameTax
        end>
      Caption = 'actPrint_Tax_ReportName'
    end
    object actPrint_ExpSpec: TdsdPrintAction
      Category = 'Print_Export'
      MoveParams = <>
      StoredProc = spSelectPrint_ExpInvoice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ExpInvoice
        end>
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1101#1082#1089#1087#1086#1088#1090')'
      Hint = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1101#1082#1089#1087#1086#1088#1090')'
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'goodsgroupname;GroupName_Juridical;GoodsName_Juridical;GoodsName' +
            ';GoodsKindName'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SaleSpec'
      ReportNameParam.Value = 'PrintMovement_SaleSpec'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_ExpPack: TdsdPrintAction
      Category = 'Print_Export'
      MoveParams = <>
      StoredProc = spSelectPrint_ExpPack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ExpPack
        end>
      Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1101#1082#1089#1087#1086#1088#1090')'
      Hint = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1101#1082#1089#1087#1086#1088#1090')'
      ImageIndex = 20
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupName_Juridical;GoodsName_Juridical;GoodsName;GoodsKindName'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SalePack'
      ReportNameParam.Name = 'PrintMovement_SalePack'
      ReportNameParam.Value = 'PrintMovement_SalePack'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint_Sale: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_Sale_ReportName
        end
        item
          Action = actPrint_Sale
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
    end
    object actPrint_Sale_ReportName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName_Sale
      StoredProcList = <
        item
          StoredProc = spGetReportName_Sale
        end>
      Caption = 'actPrint_Sale_ReportName'
    end
    object actPrint_Sale: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Sale
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Sale
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint_ReturnIn: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_ReturnIn_ReportName
        end
        item
          Action = actPrint_ReturnIn
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      ShortCut = 16464
    end
    object actPrint_ReturnIn_ReportName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName_ReturnIn
      StoredProcList = <
        item
          StoredProc = spGetReportName_ReturnIn
        end>
      Caption = 'actSPPrintProcName'
    end
    object actPrint_ReturnIn: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_ReturnIn
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ReturnIn
        end>
      Caption = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportName'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint_Account: TMultiAction
      Category = 'Print_Account'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_Account_ReportName
        end
        item
          Action = actPrint_Account
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 21
    end
    object actPrint_Account_ReportName: TdsdExecStoredProc
      Category = 'Print_Account'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameBill
      StoredProcList = <
        item
          StoredProc = spGetReporNameBill
        end>
      Caption = 'actPrint_Account_ReportName'
    end
    object actPrint_Account: TdsdPrintAction
      Category = 'Print_Account'
      MoveParams = <>
      StoredProc = spSelectPrint_Sale
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Sale
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1057#1095#1077#1090
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleBill'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint_Tax_Us: TMultiAction
      Category = 'Print_Tax'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_Tax_ReportName
        end
        item
          Action = actPrintTax_Us
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 16
    end
    object actPrintTax_Us: TdsdPrintAction
      Category = 'Print_Tax'
      MoveParams = <>
      StoredProc = spSelectTax_Us
      StoredProcList = <
        item
          StoredProc = spSelectTax_Us
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsSverkaCDS
          UserName = 'frxDBDSverka'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint_Tax_Client: TMultiAction
      Category = 'Print_Tax'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_Tax_ReportName
        end
        item
          Action = actPrintTax_Client
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object actPrintTax_Client: TdsdPrintAction
      Category = 'Print_Tax'
      MoveParams = <>
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsSverkaCDS
          UserName = 'frxDBDSverka'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_Pack: TdsdPrintAction
      Category = 'Print_Fozzy'
      MoveParams = <>
      StoredProc = spSelectPrint_Pack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Pack
        end>
      Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1092#1086#1079#1079#1080')'
      Hint = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1092#1086#1079#1079#1080')'
      ImageIndex = 23
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'WeighingNumber;GoodsGroupNameFull;GoodsName_two;GoodsKindName;Nu' +
            'mOrder'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SalePack21'
      ReportNameParam.Value = 'PrintMovement_SalePack21'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_Spec: TdsdPrintAction
      Category = 'Print_Fozzy'
      MoveParams = <>
      StoredProc = spSelectPrint_Spec
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Spec
        end>
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1092#1086#1079#1079#1080')'
      Hint = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1092#1086#1079#1079#1080')'
      ImageIndex = 17
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'WeighingNumber;BoxNumber;NumOrder'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SalePack22'
      ReportNameParam.Value = 'PrintMovement_SalePack22'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actInvoice: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediInvoice
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actPrint_TTN: TdsdPrintAction
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1058#1058#1053
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = 'PrintMovement_TTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actOrdSpr: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediOrdrsp
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actDesadv: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediDesadv
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object mactInvoice: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'EDIEventsName'
          FromParam.Value = 'zc_MovementBoolean_EdiInvoice'
          FromParam.DataType = ftString
          ToParam.Name = 'EDIEventsName'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'EDIEventsName'
          ToParam.DataType = ftString
        end>
      ActionList = <
        item
          Action = actEDIEvents
        end
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrintStoredProc
        end
        item
          Action = actInvoice
        end
        item
          Action = actUpdateEdiInvoiceTrue
        end>
      Caption = #1057#1095#1077#1090
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1089#1095#1077#1090#1072
    end
    object mactOrdSpr: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'EDIEventsName'
          FromParam.Value = 'zc_MovementBoolean_EdiOrdSpr'
          FromParam.DataType = ftString
          ToParam.Name = 'EDIEventsName'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'EDIEventsName'
          ToParam.DataType = ftString
        end>
      ActionList = <
        item
          Action = actEDIEvents
        end
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrintStoredProc
        end
        item
          Action = actOrdSpr
        end
        item
          Action = actUpdateEdiOrdsprTrue
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
    end
    object mactDesadv: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'EDIEventsName'
          FromParam.Value = 'zc_MovementBoolean_EdiDesadv'
          FromParam.DataType = ftString
          ToParam.Name = 'EDIEventsName'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'EDIEventsName'
          ToParam.DataType = ftString
        end>
      ActionList = <
        item
          Action = actEDIEvents
        end
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrintStoredProc
        end
        item
          Action = actDesadv
        end
        item
          Action = actUpdateEdiDesadvTrue
        end>
      Caption = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
    end
    object actUpdateEdiDesadvTrue: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiDesadv
      StoredProcList = <
        item
          StoredProc = spUpdateEdiDesadv
        end>
      Caption = 'actUpdateEdiDesadvTrue'
    end
    object actUpdateEdiInvoiceTrue: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiInvoice
      StoredProcList = <
        item
          StoredProc = spUpdateEdiInvoice
        end>
      Caption = 'actUpdateEdiInvoiceTrue'
    end
    object actUpdateEdiOrdsprTrue: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiOrdspr
      StoredProcList = <
        item
          StoredProc = spUpdateEdiOrdspr
        end>
      Caption = 'actUpdateEdiOrdsprTrue'
    end
    object actExecPrintStoredProc: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrint_Sale
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Sale
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object actSetDefaults: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDefaultEDI
      StoredProcList = <
        item
          StoredProc = spGetDefaultEDI
        end>
      Caption = 'actSetDefaults'
    end
    object actEDIEvents: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spEDIEvents
      StoredProcList = <
        item
          StoredProc = spEDIEvents
        end>
      Caption = 'actSetDefaults'
    end
    object actPrint_QualityDoc: TdsdPrintAction
      Category = 'Print_QualityDoc'
      MoveParams = <>
      StoredProc = spSelectPrint_Quality
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Quality
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'QualityCode;GoodsGroupName;GoodsName;GoodsKindName'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster2'
          IndexFieldNames = 'QualityCode;GoodsGroupName;GoodsName;GoodsKindName'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_Quality'
      ReportNameParam.Value = 'PrintMovement_Quality'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_SendOnPrice_out: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'ReportType'
          FromParam.Value = 0
          ToParam.Name = 'ReportType'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'ReportType'
        end>
      StoredProc = spSelectPrint_SendOnPrice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SendOnPrice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1088#1072#1089#1093#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 19
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_SendOnPrice_in: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'ReportType'
          FromParam.Value = 1
          ToParam.Name = 'ReportType'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'ReportType'
        end>
      StoredProc = spSelectPrint_SendOnPrice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SendOnPrice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1087#1088#1080#1093#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1087#1088#1080#1093#1086#1076')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Name = #1055#1088#1080#1093#1086#1076
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_Income: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Income
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Income
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_Income'
      ReportNameParam.Value = 'PrintMovement_Income'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_ReturnOut: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_ReturnOut
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ReturnOut
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_ReturnOut'
      ReportNameParam.Value = 'PrintMovement_ReturnOut'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_Send: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Send
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Send
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_Loss: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Loss
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Loss
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_Loss'
      ReportNameParam.Value = 'PrintMovement_Loss'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_ProductionSeparate: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_ProductionSeparate
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ProductionSeparate
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1086#1073#1074#1072#1083#1082#1077
      ReportNameParam.Value = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1086#1073#1074#1072#1083#1082#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
  end
  object spSelectPrint_ReturnIn: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 162
    Top = 322
  end
  object spGetReportName_ReturnIn: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'gpGet_Movement_ReturnIn_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
      end>
    PackSize = 1
    Left = 72
    Top = 304
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.Component = FormParams
    ConnectionParams.Host.ComponentItem = 'Host'
    ConnectionParams.Host.DataType = ftString
    ConnectionParams.User.Value = Null
    ConnectionParams.User.Component = FormParams
    ConnectionParams.User.ComponentItem = 'UserName'
    ConnectionParams.User.DataType = ftString
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.Component = FormParams
    ConnectionParams.Password.ComponentItem = 'Password'
    ConnectionParams.Password.DataType = ftString
    Left = 312
    Top = 264
  end
  object spUpdateEdiDesadv: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiDesadv'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 448
    Top = 320
  end
  object spUpdateEdiInvoice: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiInvoice'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 384
    Top = 296
  end
  object spUpdateEdiOrdspr: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiOrdspr'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 320
    Top = 320
  end
  object spGetDefaultEDI: TdsdStoredProc
    StoredProcName = 'gpGetDefaultEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
      end>
    PackSize = 1
    Left = 600
    Top = 248
  end
  object spSelectPrint_Quality: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Quality_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 687
    Top = 128
  end
  object spSelectPrint_SendOnPrice: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SendOnPrice_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inReportType'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ReportType'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 151
    Top = 456
  end
  object spSelectPrint_ReturnOut: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnOut_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 368
    Top = 440
  end
  object spSelectPrint_Income: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 296
    Top = 416
  end
  object spSelectPrint_Send: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 159
    Top = 528
  end
  object spSelectPrint_Loss: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Loss_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 263
    Top = 504
  end
  object spSelectPrint_ProductionSeparate: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Ceh_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_by'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 351
    Top = 528
  end
  object spEDIEvents: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_EDIEvents'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = Null
        Component = FormParams
        ComponentItem = 'EDIEventsName'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 576
    Top = 352
  end
end
