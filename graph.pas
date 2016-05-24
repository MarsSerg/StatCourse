unit graph;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, mssqlconn, sqldb, DB, FileUtil, TADbSource, TAGraph,
TAStyles, TASources, TANavigation, TASeries, TAMultiSeries, Forms, Controls,
Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids;

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
  GRB: TGroupBox;
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
  procedure OkClick(Sender: TObject);
  procedure Panel3Click(Sender: TObject);
  procedure Panel4Click(Sender: TObject);
  procedure ViewChange(Sender: TObject; Node: TTreeNode);
  procedure Panel2Click(Sender: TObject);
  procedure ForInfo ;
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

{$R *.lfm}

{ TForm1 }

procedure TForm1.OkClick(Sender: TObject);
var
  new: integer;
  tree: tteachers;
  l: TTreeNode;
begin
    try
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
  forcap := 'Статистика по ' + IntToStr(Counted) + ' вопросам';
  panel1.Caption := forcap;
end;

procedure TForm1.Panel3Click(Sender: TObject);
begin
    IF chart1.Visible =true THEN
      Chart1.Visible:=false
      else
        chart1.Visible:=true;
end;

procedure TForm1.Panel4Click(Sender: TObject);
begin
    if grb.Visible=true then
      grb.Visible:=false
      else
        grb.Visible:=true;
 SQLQuery1.Sql.Clear;
  SqlQuery1.SQL.Add('exec Persantage @Id=:IDTEA ');
  SQLQuery1.ParamByName('IdTea').AsInteger := idnode;
  SQLQuery1.Open;
  if not SQLQuery1.EOF then
    begin
    GR := SQLQuery1.FieldByName('GroupNumber').AsString;
    Pers := strtoint(SQLQuery1.FieldByName('SatisfactionPercentage').AsString);
    end;
  SQLTransaction1.Commit;
  SqlQuery1.Close;
  Chart2BarSeries1.Clear;
  Chart2BarSeries1.Add(Pers, 'Persantage', clPurple);

end;




procedure TForm1.ViewChange(Sender: TObject; Node: TTreeNode);

begin

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
    StringGrid1.ColCount := 5;
    StringGrid1.RowCount := 1;
    StringGrid1.Cells[1, 0] := 'Фамилия';
    StringGrid1.Cells[2, 0] := 'Всего вопросов';
    StringGrid1.Cells[3, 0] := 'Средний балл';
    StringGrid1.Cells[4, 0] := 'Суммарный балл';
    while not SQLQuery1.EOF do
      begin
      StringGrid1.RowCount := StringGrid1.RowCount + 1;
      StringGrid1.Cells[1, StringGrid1.RowCount - 1] :=
        SQLQuery1.FieldByName('Surname').AsString;
      StringGrid1.Cells[2, StringGrid1.RowCount - 1] :=
       SQLQuery1.FieldByName('Counted').AsString;
      StringGrid1.Cells[3, StringGrid1.RowCount - 1] :=
        SQLQuery1.FieldByName('Average').AsString;
      StringGrid1.Cells[4, StringGrid1.RowCount - 1] :=
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
