object PUSHMessageForm: TPUSHMessageForm
  Left = 0
  Top = 0
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 337
  ClientWidth = 601
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 601
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
        '')
      ParentFont = False
      PopupMenu = PopupMenu
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Color = clCream
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Courier New'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyDown = MemoKeyDown
      Height = 294
      Width = 599
    end
  end
  object pn2: TPanel
    Left = 0
    Top = 296
    Width = 601
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
      601
      41)
    object bbCancel: TcxButton
      Left = 509
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 8
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 416
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Active = False
    Left = 72
    Top = 16
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
        Component = Memo
        Properties.Strings = (
          'Style.Color'
          'Style.TextColor'
          'Style.Font')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 72
    Top = 88
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 72
    Top = 152
  end
  object ColorDialog: TColorDialog
    Left = 72
    Top = 208
  end
  object PopupMenu: TPopupMenu
    Left = 224
    Top = 160
    object pmSelectAll: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = pmSelectAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmColorDialog: TMenuItem
      Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
      OnClick = pmColorDialogClick
    end
    object pmFontDialog: TMenuItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1096#1088#1080#1092#1090#1072
      OnClick = pmFontDialogClick
    end
  end
end
