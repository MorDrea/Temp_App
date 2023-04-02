unit Unit13;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Unit14,
  FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls, FMX.Controls.Presentation;

type
  TForm13 = class(TForm)
    Timer1: TTimer;
    procedure Splash(Sender: TObject);
    procedure FinTemps(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form13: TForm13;

implementation
var Form14 : TForm14;

{$R *.fmx}

procedure TForm13.FinTemps(Sender: TObject);
begin
  Form13.Visible := true;
  Form14.Close;
end;

procedure TForm13.Splash(Sender: TObject);
begin
  Form14 := TForm14.Create(nil);
   Timer1.Interval := 5000;
   Form13.Visible := false;
   Form14.ShowModal;
end;

end.
