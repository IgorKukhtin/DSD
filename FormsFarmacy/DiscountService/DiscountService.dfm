object DiscountServiceForm: TDiscountServiceForm
  Left = 0
  Top = 0
  Caption = 'DiscountService'
  ClientHeight = 187
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object HTTPRIO: THTTPRIO
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 40
    Top = 16
  end
  object spGet_BarCode: TdsdStoredProc
    StoredProcName = 'gpGet_Object_BarCode_value'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBarCode'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 8
  end
  object spGet_DiscountExternal: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiscountExternal_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'URL'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Service'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExternalUnit'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOneSupplier'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTwoPackages'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 64
  end
  object UnloadItemCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 272
    Top = 56
  end
  object spSelectUnloadItem: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Income_Pfizer'
    DataSet = UnloadItemCDS
    DataSets = <
      item
        DataSet = UnloadItemCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 56
  end
  object UnloadMovementCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 272
    Top = 6
  end
  object spSelectUnloadMovement: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Pfizer'
    DataSet = UnloadMovementCDS
    DataSets = <
      item
        DataSet = UnloadMovementCDS
      end>
    Params = <
      item
        Name = 'inDiscountExternalId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 10
  end
  object spUpdateUnload: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_Pfizer'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 24
  end
  object RESTResponse: TRESTResponse
    Left = 552
    Top = 128
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 472
    Top = 128
  end
  object RESTClient: TRESTClient
    ContentType = 'application/xml'
    Params = <>
    Left = 376
    Top = 128
  end
  object spGet_Goods_CodeRazom: TdsdStoredProc
    StoredProcName = 'gpGet_Goods_Juridical_value'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inDiscountExternal'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCodeRazom'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvoiceNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvoiceDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountProcent'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountSum'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 120
  end
  object spGet_DiscountCard_Goods_Amount: TdsdStoredProc
    StoredProcName = 'gpGet_DiscountCard_Goods_Amount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inDiscountCard'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 104
  end
end
