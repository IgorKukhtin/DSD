object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1080#1079' '#1090#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090#1072
  ClientHeight = 702
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 257
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 1025
      Height = 31
      Align = alTop
      TabOrder = 0
      ExplicitTop = -6
      object btnSendTelegram: TButton
        Left = 635
        Top = 0
        Width = 130
        Height = 25
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
        TabOrder = 1
      end
      object btnProcesMessages: TButton
        Left = 207
        Top = 0
        Width = 154
        Height = 25
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
        TabOrder = 0
        OnClick = btnProcesMessagesClick
      end
      object btnTestSendTelegram: TButton
        Left = 771
        Top = 0
        Width = 106
        Height = 25
        Caption = #1058#1077#1089#1090'. '#1089#1086#1086#1073#1097#1077#1085#1080#1077
        TabOrder = 2
        OnClick = btnTestSendTelegramClick
      end
      object btnTestSendManualTelegram: TButton
        Left = 883
        Top = 0
        Width = 106
        Height = 25
        Caption = #1058#1077#1089#1090'. '#1089#1086#1086#1073#1097#1077#1085#1080#1077
        TabOrder = 3
        OnClick = btnTestSendManualTelegramClick
      end
      object btnUpdate: TButton
        Left = 995
        Top = 0
        Width = 26
        Height = 25
        Caption = 'U'
        TabOrder = 4
        OnClick = btnUpdateClick
      end
      object btnGetMessagesTelegram: TButton
        Left = 19
        Top = 0
        Width = 182
        Height = 25
        Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
        TabOrder = 5
        OnClick = btnGetMessagesTelegramClick
      end
      object btnProcesTimer2: TButton
        Left = 391
        Top = 0
        Width = 138
        Height = 25
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1088#1086#1074#1077#1088#1082#1080
        TabOrder = 6
        OnClick = btnProcesTimer2Click
      end
    end
    object grChatId: TcxGrid
      Left = 496
      Top = 31
      Width = 529
      Height = 226
      Align = alRight
      TabOrder = 1
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object grChatIdDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ChatIdDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ciLastName
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsBehavior.IncSearchItem = ciLastName
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        object cidID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          HeaderAlignmentHorz = taCenter
          Width = 90
        end
        object ciFirstName: TcxGridDBColumn
          DataBinding.FieldName = 'FirstName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 147
        end
        object ciLastName: TcxGridDBColumn
          DataBinding.FieldName = 'LastName'
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 145
        end
        object ciUserName: TcxGridDBColumn
          DataBinding.FieldName = 'UserName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 154
        end
      end
      object grChatIdLevel: TcxGridLevel
        GridView = grChatIdDBTableView
      end
    end
    object cxGrid1: TcxGrid
      Left = 0
      Top = 31
      Width = 496
      Height = 226
      Align = alClient
      TabOrder = 2
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableView2: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = MessagesTelegramDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        object slChatId: TcxGridDBColumn
          DataBinding.FieldName = 'ChatId'
          Options.Editing = False
          Width = 96
        end
        object slText: TcxGridDBColumn
          DataBinding.FieldName = 'Text'
          Options.Editing = False
          Width = 370
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableView2
      end
    end
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 257
    Width = 1025
    Height = 445
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 441
    ClientRectLeft = 4
    ClientRectRight = 1021
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
      ImageIndex = 0
      object grReport: TcxGrid
        Left = 0
        Top = 0
        Width = 1017
        Height = 417
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsReport_Upload
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.CellEndEllipsis = True
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          object ObjectId: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'ObjectId'
            Options.Editing = False
            Width = 80
          end
          object TelegramId: TcxGridDBColumn
            DataBinding.FieldName = 'TelegramId'
            Options.Editing = False
            Width = 82
          end
          object Message: TcxGridDBColumn
            Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
            DataBinding.FieldName = 'Message'
            Width = 841
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 5432
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 128
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 48
    Top = 88
  end
  object MessagesTelegramDS: TDataSource
    DataSet = MessagesTelegramCDS
    Left = 400
    Top = 88
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    Params = <>
    Properties.Strings = (
      '')
    Left = 428
    Top = 392
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 624
    Top = 392
  end
  object ChatIdDS: TDataSource
    AutoEdit = False
    Left = 552
    Top = 80
  end
  object dsReport: TDataSource
    DataSet = qryReport
    Left = 624
    Top = 472
  end
  object qryReport: TZQuery
    Connection = ZConnection1
    Params = <>
    Properties.Strings = (
      '')
    Left = 428
    Top = 472
  end
  object spProcesMessagesTelegram: TZStoredProc
    Connection = ZConnection1
    Params = <
      item
        DataType = ftInteger
        Name = 'inChatId'
        ParamType = ptInput
      end
      item
        DataType = ftWideString
        Name = 'inText'
        ParamType = ptInput
      end
      item
        DataType = ftWideString
        Name = 'outResult'
        ParamType = ptOutput
      end>
    StoredProcName = 'gpSelect_TelegramBot_ProcesMessages'
    Left = 428
    Top = 545
    ParamData = <
      item
        DataType = ftInteger
        Name = 'inChatId'
        ParamType = ptInput
      end
      item
        DataType = ftWideString
        Name = 'inText'
        ParamType = ptInput
      end
      item
        DataType = ftWideString
        Name = 'outResult'
        ParamType = ptOutput
      end>
  end
  object MessagesTelegramCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 264
    Top = 88
  end
  object tiServise: TTrayIcon
    AnimateInterval = 500
    Hint = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1080#1079' '#1090#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090#1072
    BalloonTimeout = 500
    BalloonFlags = bfWarning
    Icon.Data = {
      0000010001002020000001002000A81000001600000028000000200000004000
      0000010020000000000000100000000700000007000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E2A32700E2A42800E2A42800E2A22600E2A2
      2400E1A02100E1A02100E1A12300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E3A7
      3000E3A62E00E3A73100E3A73000E3A52D02E2A42B04E2A42904E2A32703E2A2
      2603E2A22404E1A12204E1A12102E1A02000E19E1F00E1A02100E1A021000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E4A93700E4A93400E5AA
      3700E5AA3800E4A83303E3A83302E3A73200E3A73200E8C36B00000000000000
      0000E1A52A00E1A02100E1A12100E1A12202E1A02103E2A92A00E19C1D00E1A0
      2100E1A220000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5AB3B00E4AA3900E4AA3900E4AA
      3902E4AA3803E4A93500E2A62D02E3A52D36E2A42B76E2A42998E2A327A5E2A2
      25A4E2A12495E1A1226FE1A1212CE1A62C00E3BA5500E1A12203E1A12201E1A1
      2200E1A12200E1A1220000000000000000000000000000000000000000000000
      0000000000000000000000000000E5AD4000E5AC3E00E5AC3E00E5AC3D02E4AB
      3B018A680000E4A8335FE3A730C0E3A62EB3E3A52B7EE2A42954E2A32841E2A2
      2642E2A22459E1A12386E1A122BAE1A122B9E1A0214CE1A12300E1A22402E1A1
      2302E1A12300E1A12300E1A12400000000000000000000000000000000000000
      00000000000000000000E6B04500E6AF4300E6AF4300E5AC3E03E4AA3800E5AB
      3A1EE4AA37BCE4A834ABE3A7312CE4A63000E4A83301E3A83200000000000000
      0000E1A12400E1A01E00E19F1C00E1A1233BE1A122BBE1A122A9E1A1210EDF9F
      1D00E1A12302E2A22500E2A22500E3A126000000000000000000000000000000
      00000000000000000000E7B04800E6B04800E5AD4003E5AC3D00E5AD3E31E5AB
      3CD9E4AA3958E5AB3A00E5AC3D01E3A52D02E3A52B04E2A42903E2A32802E2A3
      2602E2A22503E1A12304E1A12102E2A12101E2A12200E1A12374E1A123CFE1A1
      2319E1A02100E1A12402E2A32700E2A327000000000000000000000000000000
      000000000000E7B34D00E7B24C00E6AE4202E6AE4100E6AF4321E5AD40D9E5AC
      3E3BE5AC3E00E4AA3805E3A73202E9B14900E6AD4000E4AB3A00E5A93700E5AB
      3A00E5AB3A00E5A93703E4A93502E1A02002E1A12305E2A22400E2A2255BE2A2
      25CEE2A2240BE2A02100E2A12301E2A42A00E2A4290000000000000000000000
      000000000000E8B45000E6AF4300E6AF4301E5AB3B00E6AF45C0E6AF4457E6AF
      4400E5AD3E06F0BE6800E7AF4600E6AE4200E6AE4201E6AD4102E6AC3F00E5AC
      3D01E5AC3D02E5AB3C00E5AA3901E8B24B00E1A12200E1A22506E2A32700E2A3
      277BE2A327A6E2A32700E2A32803E1A12100E3A52C0000000000000000000000
      000000000000E8B55300E7B14A03E7B14900E7B14A6CE7B149A0E7B24B00E6AF
      4505E4A93700E5AC3E00E7AC3F00E7AD4000E5AA3C01E7B04600E6AE4204E6AC
      3F01E4A73300E5A93663E4A93544E4A93500E4A93502E2A52D00E2A22503E2A4
      2900E2A429B9E2A42948E2A42900E2A42802E3A62F0000000000000000000000
      0000E9B75800E8B34F00E9B55400EBB85B03E7B34EBDE7B24C28E7B34F00E7B3
      4E01E6AF4300E6AD4000E6AD4002E6AD4000E6AD406CE6AD4038E6AD4000E5AD
      3E11E5AB3B98E5AA39FFE5A938A9E5A93700E5AA3803E5AA3A00E3A52C03E3A5
      2C00E3A52C48E3A52BADE2A52B00E2A52B02E3A52C0000000000000000000000
      0000E9B95C00E8B55203E8B55200E8B55246E8B451A8E8B55300E8B45103EBBB
      6200E6B04800E8B24F00E6AF4404E6AE4300E6AE4383E6AE43D9E6AE424FE6AD
      40C2E5AC3EF0E5AC3DE4E5AB3BC7E5AA3A07E5AA3900E5AB3B01E4A73200DF9F
      1F00DEA12900E3A62EB8E3A62E26E3A62E00E3A62E02E3A83500000000000000
      0000EBB95D00E8B65504E8B65500E8B65584E8B6556FE8B65600E8B65503E9B7
      5800E9B65602E8B65503E7B14A04E6B04600E6B0486BE6B046F0E6AF44E3E6AE
      43E2E6AE42D9E6AD40DFE6AD3FE0E5AC3E25E5AC3E00E5AC3E02E3A52C00E3A7
      3104E3A73100E3A73190E3A73162E3A73100E3A73103E4AA3700000000000000
      0000E9B85A00E9B75903E9B75900E9B859A4E9B75844E9B75900E9B75902E7B3
      4F00E7AE4800E7AE4800E7B04903E7B24B00E7B14A25E7B14AC9E7B149DDE6B0
      47D2E6AF45DAE6AF44D8E6AE42EAE6AD414EE6AD4100E6AE4103E4A93500E4A8
      3403E4A83400E4A83467E4A83488E4A83400E4A83404E3A73400000000000000
      0000E9B95D00E9B95B02E9B95C00E9B95CAFE9B95C2FE9B95C00E9BA6001E9B7
      5809E9B6562DE8B55466E8B452A9E8B45174E9B35204E7B24B17E7B24CBBE7B2
      4BE2E7B149D1E6B048D4E6AF46E8E6AF457AE6AF4500E6AF4503E7B14900E4AA
      3703E4AA3700E4AA3750E4AA379AE4AA3700E4AA3704E4A93700000000000000
      0000EABB6000EABA5F02EABA5F00EABA60AFEABA5F2EEABB6100E9B75800E9B8
      5951E9B758D6E9B657E3E9B655D6E8B554D6E8B552B3E8B55333E7AE4405E8B3
      4EA4E8B34DE4E7B24BCDE7B14AE0E7B048A3E6B14900E7B14A01E7B14900E5AB
      3B03E5AB3B00E5AB3B50E5AB3A9AE5AB3B00E5AB3B04E4AA3900000000000000
      0000EABC6300EABC6303EABC6300EABC63A5EABC6343EABC6200EABB6202E9B7
      6201EAB85B23E9B85A69E9B759AEE9B758CEE9B656DAE8B554D9E8B5547BE8B5
      5213E8B34F89E8B34FE0E8B34DD5E7B24CC1E7B24B0DE7B24B00E7B24C01E5AC
      3E03E5AC3E00E5AC3E66E5AC3E89E5AC3E00E5AC3E04E5AB3D00000000000000
      0000E9BB6000EBBD6604EBBD6600EBBD6685EBBD666EEBBD6500EBBD6504EABA
      5C00EAB85B00EAB85C00EAB85C08E9B85A40E9B85989E9B758C0E9B657E6E9B6
      56C2E8B65549E8B4517BE8B451CFE8B34FD3E8B34E2CE8B34E00E8B34E02E6AE
      4104E6AE4100E6AE428EE6AE4163E6AE4100E6AE4103E4AB3800000000000000
      0000EABB6100EBBE6903EBBE6900EBBE6949EBBE69A6EBBE6900EBBE6A03E9B7
      5B00E9B85A02E9B85903E9B75500E9B85900E9B85800EAB85B19E9B85A5BE9B7
      58ABE9B757DCE9B6579AE8B555B2E8B553DBE8B45250E8B45200E8B45103E8B1
      4801E5A83200E6AF45B8E6AF4428E6AF4400E6AF4502E5AB3B00000000000000
      0000EABD6500EBBF6C01EBBF6C00EBBF6C04EBBF6BBEEBBF6B25EBBE6900EBBF
      6A01EBBF6B00EAB85A00E9B75A01E9B85903E9B75802ECBE6400FADC9B00EDBE
      6502EAB85A30E9B75987E9B758BAE9B657E3E9B65682E9B65600E8B45106E7B1
      4800E7B14A44E7B149AFE7B24B00E8B24B02E6B0470000000000000000000000
      000000000000EBBE6800ECC06E03ECC06E00ECC06E70ECC06E9CECC06E00ECC1
      7005ECC37600ECC27300EAB95D00EBB46100E9B65B00E9B85A01E9B75903E8B6
      5601EAB85A00EAB85A00EABA5B0EE9B85959E9B75841E9B85900E8B65505E6B1
      4A00E7B34EB6E7B24C4CE7B34D00E7B34D03E6AE430000000000000000000000
      000000000000EBBF6A00EDC27300E9BC6200ECC16F00ECC170C3ECC17052ECC1
      7000ECC27205EDC37600EDC37600EDC37400EAB75A00E9B85900EAB85A00EAB8
      5A00E9B85902E9B75803F1CB7400E9B75B00EABA5F00E9B75806E8B55200E8B5
      5376E8B451AAE8B55300E8B45103E8B75600E6B0470000000000000000000000
      000000000000ECC06D00ECBF6C00ECC27202ECC27300ECC27225ECC272D9ECC2
      7235ECC27200EDC37405EDC37402EDC37600EDC37600EDC37400EBC17200EAB8
      5A00EABA6000EDBE6400EAB95A01EABA5E06E9B95C07E9B75800E9B75854E8B6
      56D1E7B4510EE8B65600E8B65601E7B24B00E7B1490000000000000000000000
      00000000000000000000ECC17000ECC16F00EDC27303EDC37400EDC37436EDC3
      74DAEDC37450EDC37400EDC37501EDC37503EDC37404ECC27203ECC17102ECC1
      6F02ECC06D03EBBF6B04EBBE6902E8B75701E8B95C00E9B95E6DE9B85BD2E9B7
      581EEAB85B00E9B75702E7B34F00E7B34F000000000000000000000000000000
      00000000000000000000ECC27100ECC27200ECC27100EDC27303EDC37600EDC3
      7623EDC375C1EDC375A5EDC37425EDC37600EDC37601EDC27100000000000000
      0000EBBC6500E9BC6301E9BD6600EABD6534EABB62B6EABA5FAFE9B95C11EABB
      6100E9B75902E8B55400E8B55400E9B552000000000000000000000000000000
      0000000000000000000000000000ECC37300EDC37300ECC27300EDC37402ECC0
      6D01EDC77D02EDC47667EDC375C3EDC374AFECC27377ECC2724DECC1713AECC1
      6F3BECC06D52EBBF6B7FEBBE69B7EBBD66BDEABC6453EABC6400EAB95D02E9B8
      5A02E9B75900E9B75900E9B75600000000000000000000000000000000000000
      000000000000000000000000000000000000EDC37500EDC37500EDC37500EDC3
      7502EDC37502EDC57800EDC57904EDC3753EEDC3747DECC2739EECC272A9ECC1
      70A8ECC06E9BEBBF6C76EBBF6A33EDBF6901E9B85900EABA5F03E9B95D01EABA
      5E00E9B95E00E9B95B0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EDC47600EDC47600EDC4
      7700EDC47700EDC37504EDC37401EDC37500EDC3750000000000000000000000
      0000ECB75500EABC6500EABC6500EABC6402EABC6403E9B55100EAB95B00EABB
      6200E9BB60000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EDC4
      7700EDC47600EDC47700EDC47600EDC37502EDC37404ECC27304ECC17103ECC1
      6F03ECC06E04EBBF6C04EBBF6A02EBBD6600EBBC6400EBBE6900EBBD66000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EDC37400ECC27400EDC37400EDC37400ECC27300ECC1
      7100ECC06E00ECC06E00ECC17000EEC171000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FFFFFFFC7FFFFFA005FFFE8BD37FFD2008BFFA40025FF50990AFEA200457E448
      8227C4A92123C9504893D1090893D228044BD208044B9228044B920004499300
      04499200024BD220024BD204024BD1210293C9482293C4A51923E4492227EA20
      0457F50990AFFA00025FFD2004BFFE8BD17FFFA005FFFFFC3FFFFFFFFFFF}
    PopupMenu = pmServise
    Visible = True
    Left = 48
    Top = 160
  end
  object pmServise: TPopupMenu
    Left = 796
    Top = 401
    object pmClose: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1086#1073#1088#1072#1073#1086#1090#1095#1080#1082' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1080#1079' '#1090#1077#1083#1077#1075#1088#1072#1084
      OnClick = pmCloseClick
    end
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = Timer2Timer
    Left = 128
    Top = 160
  end
end
