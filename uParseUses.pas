unit uParseUses;

interface

uses
  Classes;

type
  TParseUses = class
  private
    var
      FInUses: Boolean;
      FUseSectionCount: Integer;
      FDone: Boolean;
      FOnUsesFound: TGetStrProc;
      FInKeywordFound: Boolean;
      FInComment: Boolean;
      FInCurlyComment: Boolean;
    procedure ProcessLine(const ALine: string);
    function StripComments(const ALine: string): string;
    function StipQuotes(const ALine: string): string;
  protected
    procedure DoUsesFound(const UsesName: string);
  public
    constructor Create;
    procedure ProcessProjectUses(const ProjFilename: string);
    procedure ProcessUsedUses(const UnitFilename: string);
    property OnUsesFound: TGetStrProc read FOnUsesFound write FOnUsesFound;
    property InKeywordFound: Boolean read FInKeywordFound write FInKeywordFound;
  end;

implementation

{ TParseUses }

uses
  SysUtils, StrUtils;

constructor TParseUses.Create;
begin
  inherited;

  FInComment := False;
  FInCurlyComment := False;
end;

procedure TParseUses.DoUsesFound(const UsesName: string);
begin
  if Assigned(FOnUsesFound) then
    FOnUsesFound(UsesName);
end;

function TParseUses.StipQuotes(const ALine: string): string;
begin
  Result := ALine.Replace('''', '');
end;

function TParseUses.StripComments(const ALine: string): string;
begin
  Result := EmptyStr;

  for var i := 1 to ALine.Length do begin
    if ALine[i] = '{' then
      FInCurlyComment := True
    else if (ALine[i] = '}') and FInCurlyComment then begin
      FInCurlyComment := False;
      Continue;
    end else if StartsStr('(*', Copy(ALine, i, ALine.Length)) then
      FInComment := True
    else if StartsStr('*)', Copy(ALine, i, ALine.Length)) then begin
      FInCurlyComment := False;
      FInComment := False;
      Continue;
    end else if (not FInCurlyComment) and (not FInComment) and StartsStr('//', Copy(ALine, i, ALine.Length)) then
      // double-slash is a comment for the rest of the line, so we're done with this line
      Break;

    if (not FInComment) and (not FInCurlyComment) then
      Result := Result + ALine[i];
  end;
end;

procedure TParseUses.ProcessLine(const ALine: string);
var
  LineParts: TStringList;
  CurrLine: string;
  IsUsesLine: Boolean;
begin
  LineParts := TStringList.Create;
  try
    FInKeywordFound := False;
    LineParts.CommaText := StripComments(ALine);
    for var i := 0 to LineParts.Count - 1 do begin
      CurrLine := LineParts[i];
      IsUsesLine := SameText(CurrLine, 'uses');

      if (not FInUses) and IsUsesLine then begin
        FInUses := True;
        Inc(FUseSectionCount);
      end;

      if (not IsUsesLine) and (not CurrLine.IsEmpty) then begin
        if FInUses then begin
          CurrLine := StipQuotes(CurrLine);
          if SameText(CurrLine, 'in') then
            FInKeywordFound := True;
          if not SameText(CurrLine, 'in') then begin
            if CurrLine.Contains(';') then begin
              CurrLine := CurrLine.Replace(';', ' ').Trim;
              FInUses := False;
            end;

            DoUsesFound(CurrLine);
          end;
        end;
      end;
    end;
  finally
    LineParts.Free;
  end;
end;

procedure TParseUses.ProcessProjectUses(const ProjFilename: string);
var
  ProjectLines: TStringList;
begin
  ProjectLines := TStringList.Create;
  try
    ProjectLines.LoadFromFile(ProjFilename);

    FUseSectionCount := 0;
    FInUses := False;
    FDone := False;
    for var i := 0 to ProjectLines.Count - 1 do begin
      // process a line of the project, looking and parsing USES units
      ProcessLine(TrimLeft(ProjectLines[i]));

      // project files only have one USES section,
      // so if we're not in a USES section but the UseSectionCount has been incremented once,
      // it means we're done with the file
      if (not FInUses) and (FUseSectionCount > 0) then
        Break;
    end;
  finally
    ProjectLines.Free;
  end;
end;


procedure TParseUses.ProcessUsedUses(const UnitFilename: string);
var
  UnitLines: TStringList;
begin
  UnitLines := TStringList.Create;
  try
    UnitLines.LoadFromFile(UnitFilename);

    FUseSectionCount := 0;
    FInUses := False;
    FDone := False;
    for var i := 0 to UnitLines.Count - 1 do begin
      // process a line of the project, looking and parsing USES units
      ProcessLine(TrimLeft(UnitLines[i]));

      // unit files have two USES section, interface and implementation;
      // so we're not done until the UseSectionCount has been incremented twice
      if (not FInUses) and (FUseSectionCount > 1) then
        Break;
    end;
  finally
    UnitLines.Free;
  end;
end;

end.
