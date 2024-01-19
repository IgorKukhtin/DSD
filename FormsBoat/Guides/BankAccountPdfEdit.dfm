object BankAccountPdfEditForm: TBankAccountPdfEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1089#1082#1072#1085' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'>'
  ClientHeight = 487
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 7
    Top = 455
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 119
    Top = 455
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object Panel: TPanel
    Left = 215
    Top = 0
    Width = 652
    Height = 487
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitHeight = 343
    object dxBarDockControl3: TdxBarDockControl
      Left = 0
      Top = 0
      Width = 652
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object cxRightSplitter: TcxSplitter
      Left = 648
      Top = 26
      Width = 4
      Height = 461
      AlignSplitter = salRight
      ExplicitHeight = 317
    end
    object Panel1: TPanel
      Left = 0
      Top = 26
      Width = 249
      Height = 461
      Align = alLeft
      Caption = 'Panel1'
      TabOrder = 2
      ExplicitHeight = 317
      object cxGrid2: TcxGrid
        Left = 1
        Top = 19
        Width = 243
        Height = 441
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 297
        object cxGrid2DBBandedTableView1: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DocumentDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.Header = False
          OptionsView.BandHeaders = False
          Bands = <
            item
            end>
          object DocFileName: TcxGridDBBandedColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
            DataBinding.FieldName = 'FileName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object DocDocTagName: TcxGridDBBandedColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
            DataBinding.FieldName = 'DocTagName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenChoiceFormDocTag
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 1
          end
          object DocComment: TcxGridDBBandedColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 1
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGrid2DBBandedTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 244
        Top = 19
        Width = 4
        Height = 441
        AlignSplitter = salRight
        Control = cxGrid2
        ExplicitHeight = 297
      end
      object cxLabel1: TcxLabel
        Left = 1
        Top = 1
        Align = alTop
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        Properties.Alignment.Horz = taCenter
        AnchorX = 125
      end
    end
    object PanelDocView: TPanel
      Left = 249
      Top = 26
      Width = 399
      Height = 461
      Align = alClient
      Caption = 'PanelDocView'
      ShowCaption = False
      TabOrder = 3
      ExplicitHeight = 317
    end
  end
  object Код: TcxLabel
    Left = 12
    Top = 6
    Caption = 'Interne Nr'
  end
  object cxLabel2: TcxLabel
    Left = 12
    Top = 49
    Caption = #1044#1072#1090#1072
  end
  object ceOperDate: TcxDateEdit
    Left = 12
    Top = 70
    EditValue = 44231d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 120
  end
  object cxLabel3: TcxLabel
    Left = 12
    Top = 95
    Caption = 'External Nr'
  end
  object edInvNumberPartner: TcxTextEdit
    Left = 12
    Top = 116
    Hint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1074#1085#1077#1096#1085#1080#1081')'
    ParentShowHint = False
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 8
    Width = 182
  end
  object cxLabel6: TcxLabel
    Left = 12
    Top = 143
    Caption = 'Lieferanten / Kunden'
  end
  object ceObject: TcxButtonEdit
    Left = 12
    Top = 163
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 182
  end
  object edInvNumber: TcxTextEdit
    Left = 12
    Top = 26
    Properties.ReadOnly = True
    TabOrder = 14
    Text = '0'
    Width = 182
  end
  object cxLabel15: TcxLabel
    Left = 12
    Top = 200
    Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
  end
  object ceInvoice: TcxButtonEdit
    Left = 12
    Top = 221
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 182
  end
  object cxLabel9: TcxLabel
    Left = 12
    Top = 250
    Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
  end
  object edInvoiceKind: TcxButtonEdit
    Left = 12
    Top = 269
    ParentFont = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 18
    Width = 182
  end
  object cxLabel5: TcxLabel
    Left = 12
    Top = 297
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
  end
  object ceAmount: TcxCurrencyEdit
    Left = 12
    Top = 317
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 182
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 576
    Top = 72
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spDocumentSelect
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ImageIndex = 52
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = #1054#1082
      ImageIndex = 80
    end
    object dsdUpdateDataSetDoc: TdsdUpdateDataSet
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_BankAccountPdf
      StoredProcList = <
        item
          StoredProc = spUpdate_BankAccountPdf
        end>
      Caption = 'actUpdateDataSetDoc'
      DataSource = DocumentDS
    end
    object OpenChoiceFormDocTag: TOpenChoiceForm
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'DocTagForm'
      FormName = 'TDocTagForm'
      FormNameParam.Value = 'TDocTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecordDoc: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Action = OpenChoiceFormDocTag
      Params = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'/'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'/'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
  end
  object spInsertUpdate: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticle'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticleVergl'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEAN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inASIN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMatchCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFeeNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisArc'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountMin'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRefer'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEKPrice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTagId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSizeId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountParnerId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 134
    Top = 448
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovmentItemId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 656
    Top = 160
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_BankAccountChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Value'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_parent'
        Value = 0.000000000000000000
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId_child'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inMovmentItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'moneyplaceid'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'moneyplacename'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 14
    Top = 440
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = DBViewAddOn
        Properties.Strings = (
          'ViewDocumentParam')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 153
    Top = 75
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 224
    Top = 320
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 307
    Top = 204
  end
  object DocumentCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 40
  end
  object DocumentDS: TDataSource
    DataSet = DocumentCDS
    Left = 488
    Top = 120
  end
  object Document: TDocument
    GetBlobProcedure = spGetDocument
    Left = 488
    Top = 216
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_BankAccountPdf'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inBankAccountPdfId'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 120
  end
  object spDeleteDocument: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_BankAccountPdf'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 56
  end
  object spDocumentSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_BankAccountPdf'
    DataSet = DocumentCDS
    DataSets = <
      item
        DataSet = DocumentCDS
      end>
    Params = <
      item
        Name = 'inMovmentItemId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inMovmentItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 56
  end
  object spInsertDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_BankAccountPdf'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhotoname'
        Value = ''
        Component = Document
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovmentItemId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inMovmentItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountPdfData'
        Value = '789C535018D10000F1E01FE1'
        Component = Document
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 128
  end
  object ActionList1: TActionList
    Left = 653
    Top = 61
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spDocumentSelect
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'FormClose'
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object actInsertDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertDocument
      StoredProcList = <
        item
          StoredProc = spInsertDocument
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 0
    end
    object DocumentRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spDocumentSelect
      StoredProcList = <
        item
          StoredProc = spDocumentSelect
        end
        item
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object DocumentOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Document
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 60
    end
    object MultiActionInsertDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertDocument
        end
        item
          Action = DocumentRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 0
    end
    object actDeleteDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteDocument
      StoredProcList = <
        item
          StoredProc = spDeleteDocument
        end
        item
          StoredProc = spDocumentSelect
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090'?'
    end
    object spInserUpdateGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'spInserUpdateGoods'
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 232
    Top = 203
    DockControlHeights = (
      0
      0
      0
      0)
    object BarManagerBar1: TdxBar
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1088#1072#1073#1086#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl3
      DockedDockControl = dxBarDockControl3
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 849
      FloatTop = 373
      FloatClientWidth = 51
      FloatClientHeight = 66
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertCondition'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedContractCondition'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPhotoOpenAction'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPhotoRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbAddDocument: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbRefreshDoc: TdxBarButton
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Visible = ivAlways
      ImageIndex = 4
      ShortCut = 116
    end
    object bbStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Enabled = False
      Hint = '   '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbOpenDocument: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Visible = ivAlways
      ImageIndex = 60
    end
    object bbInsertCondition: TdxBarButton
      Action = MultiActionInsertDocument
      Category = 0
    end
    object bbPhotoRefresh: TdxBarButton
      Action = DocumentRefresh
      Category = 0
    end
    object bbSetErasedContractCondition: TdxBarButton
      Action = actDeleteDocument
      Category = 0
    end
    object bbPhotoOpenAction: TdxBarButton
      Action = DocumentOpenAction
      Category = 0
    end
    object bbDeleteDocument: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Visible = ivAlways
      ImageIndex = 2
    end
    object bb: TdxBarButton
      Action = InsertRecordDoc
      Category = 0
      ImageIndex = 1
    end
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGrid2DBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <
      item
        FieldName = 'Image1'
        Image = AccountEditForm.cxLabel1
      end
      item
        FieldName = 'Image2'
        Image = AccountEditForm.edName
      end
      item
        FieldName = 'Image3'
      end>
    ViewDocumentList = <
      item
        FieldName = 'DocumentData'
        Control = PanelDocView
        isFocused = True
      end>
    PropertiesCellList = <>
    Left = 576
    Top = 208
  end
  object GuidesObject: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMoneyPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_order'
        Value = '0'
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_order'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_invoice'
        Value = '0'
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_invoice'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 161
  end
  object spUpdate_BankAccountPdf: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_BankAccountPdf'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inid'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocTagId'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'DocTagId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 264
  end
  object GuidesInvoiceKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvoiceKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TInvoiceKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 247
  end
  object GuidesInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInvoice
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TInvoiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInvoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_parent'
        Value = '0'
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_parent'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 100
    Top = 207
  end
end
