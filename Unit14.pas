unit Unit14;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ExtCtrls;

type
  TForm14 = class(TForm)
    ImageViewer1: TImageViewer;
    Brush1: TBrushObject;
    Label1: TLabel;
    Timer1: TTimer;
    StyleBook1: TStyleBook;
    procedure tcre(Sender: TObject);
    procedure finTC(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form14: TForm14;
  i : Integer = 1;

implementation

{$R *.fmx}

procedure TForm14.finTC(Sender: TObject);
begin
  Timer1.Enabled := false;
  if i<=3 then
  begin
    Label1.Text := Label1.Text + '.';
    i := i + 1;
  end else begin
      Label1.Text :='Chargement en cours ';
      i := 1;
  end;
  Timer1.Enabled := true;
end;

procedure TForm14.tcre(Sender: TObject);
begin
Timer1.Enabled := true;
Timer1.Interval := 300;
end;

end.
