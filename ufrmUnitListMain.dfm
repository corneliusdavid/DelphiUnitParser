object frmUnitListMain: TfrmUnitListMain
  Left = 0
  Top = 0
  Caption = 'Delphi Project Unit Parser'
  ClientHeight = 484
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 665
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      665
      41)
    object edtProjectToParse: TDBLabeledEdit
      Left = 128
      Top = 10
      Width = 459
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      EditLabel.Width = 114
      EditLabel.Height = 15
      EditLabel.Caption = 'Delphi Project (*.dpr):'
      LabelPosition = lpLeft
    end
    object btnFindProject: TButton
      Left = 593
      Top = 9
      Width = 66
      Height = 25
      Action = actFindProject
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object pnlIgnore: TPanel
    Left = 0
    Top = 41
    Width = 149
    Height = 443
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 147
      Height = 17
      Align = alTop
      Alignment = taCenter
      Caption = 'Ignored Units'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 84
    end
    object pnlIgnoreMod: TPanel
      Left = 1
      Top = 362
      Width = 147
      Height = 80
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 0
      object btnAddIgnoreUnit: TButton
        Left = 5
        Top = 51
        Width = 66
        Height = 25
        Action = actAddIgnoreUnit
        TabOrder = 0
      end
      object btnDelIgnoreUnit: TButton
        Left = 77
        Top = 51
        Width = 66
        Height = 25
        Action = actDelIgnoreUnit
        TabOrder = 1
      end
      object edtAddUnitIgnore: TLabeledEdit
        Left = 5
        Top = 22
        Width = 138
        Height = 23
        EditLabel.Width = 101
        EditLabel.Height = 15
        EditLabel.Caption = 'Add Unit to Ignore:'
        TabOrder = 2
        Text = ''
      end
    end
    object lbIgnoreList: TListBox
      Left = 1
      Top = 18
      Width = 147
      Height = 344
      Align = alClient
      ItemHeight = 15
      Sorted = True
      TabOrder = 1
    end
  end
  object pnlProjectUnits: TPanel
    Left = 149
    Top = 41
    Width = 284
    Height = 443
    Align = alLeft
    TabOrder = 2
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 282
      Height = 17
      Align = alTop
      Alignment = taCenter
      Caption = 'Project Units'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 79
    end
    object lbProjUnits: TListBox
      Left = 1
      Top = 18
      Width = 282
      Height = 382
      Align = alClient
      ItemHeight = 15
      Sorted = True
      TabOrder = 0
    end
    object pnlProjBottom: TPanel
      Left = 1
      Top = 400
      Width = 282
      Height = 42
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 1
      DesignSize = (
        282
        42)
      object btnProjUnits: TButton
        Left = 72
        Top = 5
        Width = 137
        Height = 33
        Action = actGetProjectUnits
        Anchors = [akTop]
        TabOrder = 0
      end
    end
  end
  object actUnitList: TActionList
    Left = 208
    Top = 272
    object actAddIgnoreUnit: TAction
      Caption = '&Add Unit'
      OnExecute = actAddIgnoreUnitExecute
    end
    object actDelIgnoreUnit: TAction
      Caption = '&Remove'
      OnExecute = actDelIgnoreUnitExecute
    end
    object actFindProject: TAction
      Caption = '&Find ...'
      OnExecute = actFindProjectExecute
    end
    object actGetProjectUnits: TAction
      Caption = '&Refresh Project Units'
      OnExecute = actGetProjectUnitsExecute
    end
  end
  object dlgFindProject: TOpenDialog
    DefaultExt = '*.dpr'
    FileName = 'V:\UnitList\UnitLister.dpr'
    Filter = 'Delphi Project Files|*.dpr'
    InitialDir = 'v:\'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoTestFileCreate, ofNoNetworkButton, ofEnableSizing]
    Title = 'Find Delphi Project'
    Left = 208
    Top = 184
  end
end
