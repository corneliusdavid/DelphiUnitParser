program DelphiUnitParser;

uses Vcl.Forms,
  ufrmUnitListMain in 'ufrmUnitListMain.pas' {frmUnitListMain},
  uParseUses in 'uParseUses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmUnitListMain, frmUnitListMain);
  Application.Run;
end.
