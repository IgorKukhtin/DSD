object PUSHMessageCashForm: TPUSHMessageCashForm
  Left = 0
  Top = 0
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 337
  ClientWidth = 566
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 566
    Height = 296
    Align = alClient
    Caption = 'pn1'
    ShowCaption = False
    TabOrder = 0
    object Memo: TcxMemo
      Left = 1
      Top = 1
      Align = alClient
      Lines.Strings = (
        'jhjghjkghkfgkf'
        'gdfgdfshdsghsg'
        'kfgkfjlkfh')
      ParentFont = False
      Properties.Alignment = taLeftJustify
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Color = clCream
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyDown = MemoKeyDown
      Height = 294
      Width = 564
    end
  end
  object pn2: TPanel
    Left = 0
    Top = 296
    Width = 566
    Height = 41
    Align = alBottom
    Caption = 'pn2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      566
      41)
    object bbCancel: TcxButton
      Left = 474
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 8
      TabOrder = 3
    end
    object bbOk: TcxButton
      Left = 381
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 4
    end
    object btOpenForm: TcxButton
      Left = 10
      Top = 7
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1050#1085#1086#1087#1082#1072
      TabOrder = 0
      Visible = False
      OnClick = btOpenFormClick
    end
    object bbYes: TcxButton
      Left = 150
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1044#1072
      ModalResult = 6
      TabOrder = 1
      Visible = False
    end
    object bbNo: TcxButton
      Left = 332
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1053#1077#1090
      ModalResult = 7
      TabOrder = 2
      Visible = False
    end
  end
end
