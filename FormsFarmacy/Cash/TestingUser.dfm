object TestingUserForm: TTestingUserForm
  Left = 367
  Top = 319
  Caption = #1058#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
  ClientHeight = 459
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 622
    Height = 153
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      622
      153)
    object meQuestion: TcxMemo
      Left = 1
      Top = 80
      TabStop = False
      Align = alBottom
      ParentFont = False
      Properties.ReadOnly = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      StyleFocused.BorderColor = clAqua
      TabOrder = 0
      ExplicitTop = 76
      Height = 72
      Width = 620
    end
    object laTime: TcxLabel
      Left = 552
      Top = 4
      Anchors = [akTop, akRight]
      Caption = '100 '#1089#1077#1082'.'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taRightJustify
      AnchorX = 614
    end
    object cxLabel2: TcxLabel
      Left = 16
      Top = 6
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel3: TcxLabel
      Left = 16
      Top = 29
      Caption = #1042#1086#1087#1088#1086#1089#1086#1074' 16 '#1087#1088#1086#1081#1076#1077#1085#1086' 0'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel4: TcxLabel
      Left = 93
      Top = 6
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object sgViewingResults: TStringGrid
      Left = 1
      Top = 47
      Width = 620
      Height = 33
      Align = alBottom
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      GradientStartColor = clWindow
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 5
      Visible = False
      OnDrawCell = sgViewingResultsDrawCell
      OnSelectCell = sgViewingResultsSelectCell
    end
    object cbLastMonth: TcxCheckBox
      Left = 491
      Top = 23
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1096#1083#1099#1081' '#1084#1077#1089#1103#1094
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 6
      OnClick = cbLastMonthClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 153
    Width = 622
    Height = 306
    Align = alClient
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 0
    object cxLabel1: TcxLabel
      Left = 1
      Top = 1
      Align = alTop
      Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1086#1090#1074#1077#1090#1086#1074
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      AnchorX = 311
    end
    object Panel5: TPanel
      Left = 1
      Top = 21
      Width = 296
      Height = 284
      Align = alLeft
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 1
      object mePossibleAnswer1: TcxMemo
        Tag = 1
        Left = 1
        Top = 1
        Align = alTop
        Lines.Strings = (
          #1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072' 1')
        ParentFont = False
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        StyleFocused.Color = clYellow
        StyleFocused.TextColor = clBlue
        TabOrder = 0
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 136
        Width = 294
      end
      object mePossibleAnswer2: TcxMemo
        Tag = 2
        Left = 1
        Top = 238
        Align = alClient
        Lines.Strings = (
          #1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072' 2')
        ParentFont = False
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        StyleFocused.Color = clYellow
        StyleFocused.TextColor = clBlue
        TabOrder = 1
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 45
        Width = 294
      end
      object imPossibleAnswer1: TcxImage
        Tag = 1
        Left = 1
        Top = 137
        Align = alTop
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        TabOrder = 2
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 101
        Width = 294
      end
      object imPossibleAnswer2: TcxImage
        Tag = 2
        Left = 1
        Top = 238
        Align = alClient
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        TabOrder = 3
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 45
        Width = 294
      end
    end
    object Panel6: TPanel
      Left = 297
      Top = 21
      Width = 324
      Height = 284
      Align = alClient
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 2
      object mePossibleAnswer3: TcxMemo
        Tag = 3
        Left = 1
        Top = 1
        Align = alTop
        Lines.Strings = (
          #1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072' 3')
        ParentFont = False
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        StyleFocused.Color = clYellow
        StyleFocused.TextColor = clBlue
        TabOrder = 0
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 136
        Width = 322
      end
      object mePossibleAnswer4: TcxMemo
        Tag = 4
        Left = 1
        Top = 237
        Align = alClient
        Lines.Strings = (
          #1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072' 4')
        ParentFont = False
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        StyleFocused.Color = clYellow
        StyleFocused.TextColor = clBlue
        TabOrder = 1
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 46
        Width = 322
      end
      object imPossibleAnswer3: TcxImage
        Tag = 3
        Left = 1
        Top = 137
        Align = alTop
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        TabOrder = 2
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 100
        Width = 322
      end
      object imPossibleAnswer4: TcxImage
        Tag = 4
        Left = 1
        Top = 237
        Align = alClient
        Properties.ReadOnly = True
        Style.BorderStyle = ebsThick
        StyleFocused.BorderColor = clRed
        StyleFocused.BorderStyle = ebsThick
        TabOrder = 3
        OnClick = mePossibleAnswer1Click
        OnDblClick = mePossibleAnswer1DblClick
        OnKeyUp = imPossibleAnswer1KeyUp
        Height = 46
        Width = 322
      end
    end
  end
  object bOk: TcxButton
    Left = 183
    Top = 134
    Width = 233
    Height = 35
    Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1077' '#1074#1072#1088#1080#1072#1085#1090' 1'
    TabOrder = 2
    Visible = False
    OnExit = bOkExit
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = bOkClick
    OnKeyDown = bOkKeyDown
  end
  object ActionList1: TActionList
    Left = 16
    Top = 241
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 552
    Top = 112
  end
  object spTitle: TdsdStoredProc
    StoredProcName = 'gpGet_TestingUser_Title'
    DataSet = TitleCDS
    DataSets = <
      item
        DataSet = TitleCDS
      end>
    Params = <>
    PackSize = 1
    Left = 97
    Top = 238
  end
  object TitleCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 96
    Top = 296
  end
  object TaskCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 176
    Top = 296
  end
  object spTask: TdsdStoredProc
    StoredProcName = 'gpSelect_TestingTuning_Task'
    DataSet = TaskCDS
    DataSets = <
      item
        DataSet = TaskCDS
      end>
    Params = <>
    PackSize = 1
    Left = 177
    Top = 238
  end
  object TaskDS: TDataSource
    AutoEdit = False
    DataSet = TaskCDS
    Left = 177
    Top = 358
  end
  object actInsertUpdate_TestingUser: TdsdStoredProc
    StoredProcName = 'lpInsertUpdate_MovementItem_TestingUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inResult'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTest'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 361
    Top = 238
  end
end
