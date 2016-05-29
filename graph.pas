unit graph;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, printers, mssqlconn, Math, sqldb, DB, FileUtil, TADbSource,
TAGraph, TAStyles, TASources, TANavigation, TASeries, TAMultiSeries, LR_Class,
LR_Desgn, LR_DBSet, LR_PGrid, LR_Shape, Forms, Controls, Graphics, Dialogs,
StdCtrls, ExtCtrls, ComCtrls, Grids;

type
TTeachers = class
private

  idTeach: integer;
end;

type

{ TForm1 }

TForm1 = class(TForm)
  Chart1: TChart;
  Chart1BarSeries1: TBarSeries;
  Chart1BarSeries2: TBarSeries;
  Chart2: TChart;
  Chart2BarSeries1: TBarSeries;
  frDesigner1: TfrDesigner;
  frReport1: TfrReport;
  grb: TGroupBox;
  Image1: TImage;
  LableChartSource: TListChartSource;
  Main: TGroupBox;
  Ok: TPanel;
  Panel1: TPanel;
  Panel2: TPanel;
  Panel3: TPanel;
  Panel4: TPanel;
  PassEdit: TEdit;
  ForPass: TPanel;
  LoginEdit: TEdit;
  ForLogin: TPanel;
  Registration: TGroupBox;
  MSSQLConnection1: TMSSQLConnection;
  SQLQuery1: TSQLQuery;
  SQLTransaction1: TSQLTransaction;
  StringGrid1: TStringGrid;
  View: TTreeView;


  procedure grbMouseDown(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure grbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  procedure grbMouseUp(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure Image1Click(Sender: TObject);
  procedure OkClick(Sender: TObject);
  procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure Panel2MouseUp(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure Panel3Click(Sender: TObject);
  procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure Panel4Click(Sender: TObject);
  procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);
  procedure Panel4MouseUp(Sender: TObject; Button: TMouseButton;
		    Shift: TShiftState; X, Y: Integer);

  procedure ViewChange(Sender: TObject; Node: TTreeNode);
  procedure Panel2Click(Sender: TObject);
  procedure ForInfo ;
  procedure MyResize(NewWidth: integer);
  procedure FormActivate(Sender: TObject);
  procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
  procedure StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
		  );
  procedure StringGrid1Up(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
   procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
  procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
		  );
  procedure Chart1Up(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
  procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
private
  { private declarations }
public
  { public declarations }
end;

var
Form1: TForm1;

implementation

var
selectedNode: TTreeNode;
idnode: integer;
IdAnk, Counted, Summary, Average,pers: integer;
Sur, forcap,GR: string;
Draging: Boolean;
X0, Y0: integer;

{$R *.lfm}

{ TForm1 }


procedure TForm1.frReport1GetValue(const ParName: String; var ParValue: Variant
		  );
var a:string;
begin
       a:=inttostr(idank);
       if ParName = 'count' then ParValue := Counted;
       if ParName = 'surname' then ParValue := Sur;
       if ParName = 'idank' then ParValue := a;
       if ParName = 'average' then ParValue := inttostr(Average);
       if ParName = 'sum' then ParValue := inttostr(Summary);
end;

procedure TForm1.MyResize(NewWidth: integer);
var
  J: integer;
  N: integer;
  S: integer;
begin
  N := Abs(NewWidth - Self.Width);
  S := Sign(NewWidth - Self.Width);
  for J := 1 to N do
    begin
    Self.Width := Self.Width + S;
    Sleep(0);
    Application.ProcessMessages;
    end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  form1.Left := (Screen.Width - Width) div 2;
end;

procedure TForm1.OkClick(Sender: TObject);
var
  new: integer;
  tree: tteachers;
  l: TTreeNode;
begin
  if (Loginedit.Text <> 'Admin') or (PassEdit.text <> '1234') then
    begin
    ShowMessage('Пользователя не существует');
    Loginedit.Text:='';
    PassEdit.text:='';
    end
  else

  try
    form1.Height:=410;
    MyResize(90);
    Main.Visible:=true;
    SqlQuery1.SQL.Clear;
    SqlQuery1.SQL.Add('SELECT * from Teacher');
    SqlQuery1.Open;
    while not SqlQuery1.EOF do
      begin
      Registration.Visible := False;
      tree := TTeachers.Create();
      tree.idTeach := SQLQuery1.FieldByName('Teacher_Id').AsInteger;
      l := View.Items.add(nil, SQLQuery1.FieldByName('Surname').AsString);
      l.Data := tree;
      SQLQuery1.Next;
      end;
    SqlQuery1.Close;
    except
    on E: mssqlconn.EMSSQLDatabaseError do
      begin
      ShowMessage('Error 404');
      SqlQuery1.Close;
      end;
    end;
end;

procedure TForm1.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
                 Panel2.Color := $00A25151;
end;

procedure TForm1.Panel2MouseUp(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
           Panel2.Color:= $00775100;
end;

 procedure TForm1.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
    Draging := true;
  x0 := x;
  y0 := y;
end;

procedure TForm1.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
		  );
begin
                  if Draging = true then
  begin
   Chart1.Left := Chart1.Left + X - X0;
    Chart1.top := Chart1.top + Y - Y0;
  end;
end;

procedure TForm1.Chart1Up(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
                   Draging := false;
end;



procedure TForm1.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
    Draging := true;
  x0 := x;
  y0 := y;
end;

procedure TForm1.StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
		  );
begin
                  if Draging = true then
  begin
    StringGrid1.Left := StringGrid1.Left + X - X0;
    StringGrid1.top := StringGrid1.top + Y - Y0;
  end;
end;

procedure TForm1.StringGrid1Up(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
                   Draging := false;
end;

procedure TForm1.grbMouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
    Draging := true;
  x0 := x;
  y0 := y;
end;

procedure TForm1.grbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
		  );
begin
                  if Draging = true then
  begin
    grb.Left := Grb.Left + X - X0;
    Grb.top := Grb.top + Y - Y0;
  end;
end;

procedure TForm1.grbMouseUp(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
                   Draging := false;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

   frReport1.LoadFromFile('report.lrf');
   frReport1.ShowReport;
end;



procedure TForm1.ForInfo ;
begin
  SQLQuery1.Sql.Clear;
  SqlQuery1.SQL.Add('exec Allinfo @Id=:IDTEA ');
  SQLQuery1.ParamByName('IdTea').AsInteger := idnode;
  SQLQuery1.Open;
  if not SQLQuery1.EOF then
    begin
    idank := SQLQuery1.FieldByName('ID_Anketa').AsInteger;
    sur := SQLQuery1.FieldByName('Surname').AsString;
    Counted := SQLQuery1.FieldByName('Counted').AsInteger;
    Summary := SQLQuery1.FieldByName('Summary').AsInteger;
    Average := SQLQuery1.FieldByName('Average').AsInteger;
    end;
  SQLTransaction1.Commit;
  SqlQuery1.Close;
  Chart1BarSeries1.Clear;
  Chart1BarSeries1.Add(Average, 'Average', clYellow);
  Chart1BarSeries1.Add(Summary, 'Summary', clGreen);
  forcap := 'Статистика по ' + IntToStr(Counted) + ' ответам';
  panel1.Caption := forcap;
end;

procedure TForm1.Panel3Click(Sender: TObject);
begin
    IF chart1.Visible =true THEN
      Chart1.Visible:=false
      else
        chart1.Visible:=true;
end;

procedure TForm1.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
                  Panel3.color:= $00A25151;
end;

procedure TForm1.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
             Panel3.Color:= $00775100;
end;

procedure TForm1.Panel4Click(Sender: TObject);
var
col:TColor;
r:byte;
begin
  col:=ColorToRGB(clPurple);
    if grb.Visible=true then
      grb.Visible:=false
      else
        grb.Visible:=true;
 SQLQuery1.Sql.Clear;
  SqlQuery1.SQL.Add('exec Persantage @Id=:IDTEA ');
  SQLQuery1.ParamByName('IdTea').AsInteger := idnode;
  SQLQuery1.Open;
  Chart2BarSeries1.Clear;
  while not SQLQuery1.EOF do
    begin
    col:=col+$00EBD2BA;
    GR := SQLQuery1.FieldByName('GroupNumber').AsString;
    Pers := strtoint(SQLQuery1.FieldByName('SatisfactionPercentage').AsString);
  Chart2BarSeries1.Add(Pers, GR, col);
  SQLQuery1.Next;
    end;
  SQLTransaction1.Commit;
  SqlQuery1.Close;

end;

procedure TForm1.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
            Panel4.color:= $00A25151;
end;

procedure TForm1.Panel4MouseUp(Sender: TObject; Button: TMouseButton;
		  Shift: TShiftState; X, Y: Integer);
begin
                 Panel4.Color:= $00775100;
end;






procedure TForm1.ViewChange(Sender: TObject; Node: TTreeNode);

begin
  MyResize(688);
  selectedNode := node;
  idnode := TTeachers(node.Data).idTeach;
  forinfo;

end;

procedure TForm1.Panel2Click(Sender: TObject);
begin

   if StringGrid1.Visible = false then
     StringGrid1.Visible := true
      else
        StringGrid1.Visible := false;

    try
    SQLQuery1.SQL.Clear;
    SQLQuery1.SQL.Add('Exec Allteach ');
    SQLQuery1.Open;
    StringGrid1.ColCount := 4;
    StringGrid1.RowCount := 1;
    StringGrid1.Cells[0, 0] := 'Фамилия';
    StringGrid1.Cells[1, 0] := 'Всего ответов';
    StringGrid1.Cells[2, 0] := 'Средний балл';
    StringGrid1.Cells[3, 0] := 'Суммарный балл';
    while not SQLQuery1.EOF do
      begin
      StringGrid1.RowCount := StringGrid1.RowCount + 1;
      StringGrid1.Cells[0, StringGrid1.RowCount - 1] :=
        SQLQuery1.FieldByName('Surname').AsString;
      StringGrid1.Cells[1, StringGrid1.RowCount - 1] :=
       SQLQuery1.FieldByName('Counted').AsString;
      StringGrid1.Cells[2, StringGrid1.RowCount - 1] :=
        SQLQuery1.FieldByName('Average').AsString;
      StringGrid1.Cells[3, StringGrid1.RowCount - 1] :=
        SQLQuery1.FieldByName('Summary').AsString;
      SQLQuery1.Next;
      end;
    StringGrid1.AutoSizeColumns;
    SqlQuery1.Close;
    SQLTransaction1.Commit;
    SqlQuery1.SQL.Clear;
    except
    on E: EDataBaseError do
      begin
      SQLTransaction1.Rollback;
      ShowMessage(e.Message);
      end;
    end;


end;



end.
