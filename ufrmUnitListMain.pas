unit ufrmUnitListMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.DBCtrls;

type
  TfrmUnitListMain = class(TForm)
    pnlTop: TPanel;
    actUnitList: TActionList;
    actAddIgnoreUnit: TAction;
    actDelIgnoreUnit: TAction;
    edtProjectToParse: TDBLabeledEdit;
    btnFindProject: TButton;
    actFindProject: TAction;
    dlgFindProject: TOpenDialog;
    pnlIgnore: TPanel;
    pnlIgnoreMod: TPanel;
    btnAddIgnoreUnit: TButton;
    btnDelIgnoreUnit: TButton;
    edtAddUnitIgnore: TLabeledEdit;
    lbIgnoreList: TListBox;
    Label1: TLabel;
    pnlProjectUnits: TPanel;
    Label2: TLabel;
    lbProjUnits: TListBox;
    actGetProjectUnits: TAction;
    pnlProjBottom: TPanel;
    btnProjUnits: TButton;
    pnlAllUsedUnits: TPanel;
    Label3: TLabel;
    lbAllUsedUnits: TListBox;
    Panel2: TPanel;
    btnAllUnits: TButton;
    actGetAllUsedUnits: TAction;
    procedure actAddIgnoreUnitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDelIgnoreUnitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actFindProjectExecute(Sender: TObject);
    procedure actGetProjectUnitsExecute(Sender: TObject);
    procedure actGetAllUsedUnitsExecute(Sender: TObject);
  private
    const
      IGNORELIST_FILENAME = 'IgnoreList.txt';
    var
      FProjectPath: string;
    procedure AddProjectUses(const UsesName: string);
    procedure AddAllUses(const UsesName: string);
    procedure SaveIgnoreList;
    procedure LoadIgnoreList;
    procedure LoadStuff;
    procedure SaveStuff;
  end;

var
  frmUnitListMain: TfrmUnitListMain;

implementation

{$R *.dfm}

uses
  System.IOUtils, System.StrUtils,
  uParseUses;

procedure TfrmUnitListMain.actAddIgnoreUnitExecute(Sender: TObject);
begin
  if Length(edtAddUnitIgnore.Text) > 0 then begin
    lbIgnoreList.Items.Add(edtAddUnitIgnore.Text);
    edtAddUnitIgnore.Text := EmptyStr;
    edtAddUnitIgnore.SetFocus;
  end;
end;

procedure TfrmUnitListMain.actDelIgnoreUnitExecute(Sender: TObject);
begin
  if lbIgnoreList.ItemIndex > -1 then
    lbIgnoreList.Items.Delete(lbIgnoreList.ItemIndex);
end;

procedure TfrmUnitListMain.actFindProjectExecute(Sender: TObject);
begin
  if dlgFindProject.Execute then
    edtProjectToParse.Text := dlgFindProject.FileName;
end;

procedure TfrmUnitListMain.actGetAllUsedUnitsExecute(Sender: TObject);
var
  CurrUnit: string;
begin
  lbAllUsedUnits.Items.Clear;

  for var i := 0 to lbProjUnits.Items.Count - 1 do begin
    CurrUnit := lbProjUnits.Items[i];
    if not TFile.Exists(CurrUnit) then
      CurrUnit := TPath.Combine(FProjectPath, CurrUnit);

    if TFile.Exists(CurrUnit) then begin
      var ParseUses := TParseUses.Create;
      try
        ParseUses.OnUsesFound := AddAllUses;
        ParseUses.ProcessUsedUses(CurrUnit);
      finally
        ParseUses.Free;
      end;
    end;
  end;
end;

procedure TfrmUnitListMain.actGetProjectUnitsExecute(Sender: TObject);
var
  s: string;
begin
  lbProjUnits.Items.Clear;

  if Length(edtProjectToParse.Text) > 0 then begin
    s := Trim(edtProjectToParse.Text);
    if TFile.Exists(s) then begin
      FProjectPath := ExtractFilePath(s);

      var ParseUses := TParseUses.Create;
      try
        ParseUses.OnUsesFound := AddProjectUses;
        ParseUses.ProcessProjectUses(s);
      finally
        ParseUses.Free;
      end;
    end else
      ShowMessage('Cannot find project file: ' + s);
  end;
end;

procedure TfrmUnitListMain.AddAllUses(const UsesName: string);
begin
  if (lbIgnoreList.Items.IndexOf(UsesName) = -1) and (not UsesName.IsEmpty) then begin
    // if a uses entry is in the form: MyUnit in 'MyUnit.pas'
    // then delete the previous entry as it was just the base name
    var basename: string;
    basename := ChangeFileExt(ExtractFileName(UsesName), '');
    var baseidx := lbAllUsedUnits.Items.IndexOf(basename);
    if baseidx <> -1 then
      lbAllUsedUnits.Items.Delete(baseidx);

    lbAllUsedUnits.Items.Add(UsesName);
  end;
end;

procedure TfrmUnitListMain.AddProjectUses(const UsesName: string);
begin
  if (lbIgnoreList.Items.IndexOf(UsesName) = -1) and (not UsesName.IsEmpty) then begin
    // if a uses entry is in the form: MyUnit in 'MyUnit.pas'
    // then delete the previous entry as it was just the base name
    var basename: string;
    basename := ChangeFileExt(ExtractFileName(UsesName), '');
    var baseidx := lbProjUnits.Items.IndexOf(basename);
    if baseidx <> -1 then
      lbProjUnits.Items.Delete(baseidx);

    lbProjUnits.Items.Add(UsesName);
  end;
end;

procedure TfrmUnitListMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveStuff;
end;

procedure TfrmUnitListMain.FormCreate(Sender: TObject);
begin
  LoadStuff;
end;

procedure TfrmUnitListMain.LoadStuff;
begin
  LoadIgnoreList;
end;

procedure TfrmUnitListMain.SaveStuff;
begin
  SaveIgnoreList;
end;

procedure TfrmUnitListMain.SaveIgnoreList;
begin
  lbIgnoreList.Items.SaveToFile(TPath.Combine(ExtractFilePath(Application.ExeName), IGNORELIST_FILENAME));
end;

procedure TfrmUnitListMain.LoadIgnoreList;
begin
  lbIgnoreList.Items.LoadFromFile(TPath.Combine(ExtractFilePath(Application.ExeName), IGNORELIST_FILENAME));
end;

end.
