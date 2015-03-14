unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  Node = class
  public
    symbol: String;
    _not: bool;
    left, right: Node;
  published
    constructor Create;
end;

type
  Tree = class
  public
    root: Node;
    value: String;
  published
    constructor Create;
end;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label4: TLabel;
    Edit3: TEdit;
    Button5: TButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  view: String;
  count_vars, count_box, id, width, height, from, _to, from_size, to_size: Integer;
  vars, boxs, variables, arcs, buff: TStringList;
  {
        public List<int> buff = new List<int>();
  }
  procedure buildTree(str: String; _node: Node; list: TStringList; _not: bool);
  function brackets(str: String): TStringList;
  function IndexOfAny(str: String; sep: String): Integer;
  procedure drawTree(_node: Node);
  procedure findVariable(_node: Node);
  procedure drawFormula(_node: Node);
  procedure functionWriteFilePrepare(_tree: Tree);
  procedure functionWriteFile();

implementation
uses Unit2;
{$R *.dfm}
constructor Node.Create;
begin
  inherited;
  self.symbol := '';
  self._not := false;
  self.left := nil;
  self.right := nil;
end;
constructor Tree.Create;
begin
  inherited;
  self.root := nil;
  self.value := '';
end;
////////////////////////////////////////////////////////////////////////////////////////
function IndexOfAny(str: String; sep: String): Integer;
var
   i, index: Integer;
begin
  index := MaxInt;
  for i := 1 to Length(sep) do
    if (AnsiPos(sep[i], str) <> 0) and (AnsiPos(sep[i], str) < index) then index := AnsiPos(sep[i], str);
  if index = MaxInt then index := 0;
  IndexOfAny := index;
end;
////////////////////////////////////////////////////////////////////////////////////////
function brackets(str: String): TStringList;
var
  input, output, list: TStringList;
  i, j, max: Integer;
begin
  input  := TStringList.Create;
  output := TStringList.Create;
  list   := TStringList.Create;

  for i := 0 to Length(str) do begin
    if str[i] = '(' then
      begin
        input.Append(IntToStr(i));
      end;
    if str[i] = ')' then
      begin
        output.Append(IntToStr(i));
      end;
  end;
  for i := 0 to output.Count - 1 do
  begin
    max := 0;
    for j := 0 to input.Count - 1 do
    begin
      if (StrToInt(input.Strings[j]) < StrToInt(output.Strings[i])) and
         (StrToInt(input.Strings[j]) > max) then
        max := StrToInt(input[j]);
    end;
    input.Delete(input.IndexOf(IntToStr(max)));
    list.Add(Format('%s=%s', [IntToStr(max), output[i]]))
  end;
  brackets := list;
end;
////////////////////////////////////////////////////////////////////////////////////////
procedure buildTree(str: String; _node: Node; list: TStringList; _not: bool);
var
  index1, index2, last, index: Integer;
  left, right, value, tmp: String;
  leftNot, rightNot: Bool;
  leftNode, rightNode: Unit1.Node;
begin
  left := ''; right := ''; value := '';
  leftNot := false; rightNot := false;
  index1 := IndexOfAny(str, '+*');
  index2 := IndexOfAny(str, '(');
  if (index1 >= 1) and (index2 >= 1) and (index2 < index1) then     // если первые скобки в левой части
  begin
    if (index2 - 1 >= 1) and (str[index2 - 1] = '^') then leftNot := true;
    tmp := IntToStr(index2);
    last := StrToInt(list.Values[tmp]);    //проверить
    left := Copy(str, index2 + 1, (last - index2) - 1); //проверить
    right := Copy(str, last + 2, MaxInt); //проверить
    if ((last + 1) >= 0) and ((last + 1) < Length(str)) then value := str[last + 1]; //проверить
    index := last + 2;
    if (index >= 0) and (index < Length(str)) and (str[index] = '^') then
    begin
     index := last + 3;
     rightNot := true;
    end;
    if (list.IndexOfName(IntToStr(index)) >= 0) and (list.IndexOfName(IntToStr(index)) < {Length}(list.Count)) then
    begin
      last := StrToInt(list.Values[IntToStr(index)]);
      if (last >= 0) and (last = Length(str) - 1) then
      begin
        if (rightNot = false) then right := Copy(right, 1, Length(right) - 2)
        else right := Copy(right, 2, Length(right) - 3);
      end;
    end
    else if (IndexOfAny(right, '+*') = 0) then
    begin
      if(index >= 0) and (index < Length(str)) then
      begin
        index := last + 2;
        if str[index] = '^' then
        begin
          rightNot := true;
          right := Copy(right, 2, length(right) - 1);
        end;
      end;
    end
    else rightNot := false;
  end
  else
  begin
    if (str[1] <> '^') then left := Copy(str, 1, index1 - 1)
    else if (index1 - 1 >= 0) and (index1 -1 < Length(str)) then
    begin
      left := Copy(str, 2, index1 - 2); leftNot := true;
    end;
    right := Copy(str, index1 + 1, MaxInt);
    if (index1 >= 0) and (index1 < Length(str)) then value := str[index1];
    index := index1 + 1;
    if (index >= 0) and (index < Length(str)) and (str[index] = '^') then
    begin
      index := index1 + 2; rightNot := true;
    end;
    if (list.IndexOfName(IntToStr(index)) >= 0) and (list.IndexOfName(IntToStr(index)) < {Length}(list.Count)) then
    begin
      last := StrToInt(list.Values[IntToStr(index)]);
      if (last >= 0) and (last = Length(str)) then
      begin
        if (rightNot = false) then right := Copy(right, 2, Length(right) - 2)
        else right := Copy(right, 3, Length(right) - 3);
      end;
    end
    else if IndexOfAny(right, '+*') = 0 then
    begin
         if (index >= 0) and (index < Length(str)) then
         begin
           index := index1 + 1;
           if (str[index] = '^') then
           begin
            rightNot := true; right := Copy(right, 2, Length(right) - 1);
           end;
         end;
    end
    else rightNot := false;
  end;

  _node._not   := _not;
  _node.symbol := value;

  if IndexOfAny(left, '+*(') = 0 then
  begin
    leftNode        := Node.Create;
    leftNode.symbol := left;
    leftNode.left   := nil;
    leftNode.right  := nil;
    leftNode._not   := leftNot;

    leftNot   := false;
    _node.left := leftNode;
  end;
  if IndexOfAny(right, '+*(') = 0 then
  begin
    rightNode        := Node.Create;
    rightNode.symbol := right;
    rightNode.left   := nil;
    rightNode.right  := nil;
    rightNode._not   := rightNot;

    rightNot   := false;
    _node.right := rightNode;
  end;
  if IndexOfAny(left, '+*(') <> 0 then
  begin
    _node._not := leftNot;
    _node.left := Node.Create;
    buildTree(left, _node.left, brackets(left), false);
  end;
  if IndexOfAny(right, '+*(') <> 0 then
  begin
    _node.right := Node.Create;
    buildTree(right, _node.right, brackets(right), rightNot);
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////
procedure drawTree(_node: Node);
begin
  if (_node.left = nil) and (_node.right = nil) then
  begin
    if (_node._not = true) then view := view + ' НЕ (' + _node.symbol + ')'
    else view := view + _node.symbol;
  end;
  if (_node.left <> nil) then
  begin
    if (_node.left.left = nil) and (_node.left.right = nil) then
      if _node._not = true then view := view + ' НЕ (';       // 2 вариант
    if (_node.symbol = '*') then view := view + ' И ('
    else if _node.symbol = '+' then view := view + ' ИЛИ (';
    if (_node.left.left <> nil) or (_node.left.right <> nil) then
       if (_node._not = true) then view := view + ' НЕ (';       // 1 вариант
    drawTree(_node.left);
  end;
  if (_node.right <> nil) then
  begin
    if (_node.left.left <> nil) or (_node.left.right <> nil) then
      if (_node._not = true) then view := view + ')';           // 1 вариант
    if (_node.symbol = '*') then view := view +  ';'
    else if (_node.symbol = '+') then view := view +  ';';
    drawTree(_node.right);
    if (_node.symbol = '*') then view := view + ')'
    else if (_node.symbol = '+') then view := view + ')';
    if (_node.left.left = nil) and (_node.left.right = nil) then
      if (_node._not = true) then view := view + ')';           // 2 вариант
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////
procedure findVariable(_node: Node);
begin
  if (_node.left = nil) and (_node.right = nil) then
  begin
    count_vars := count_vars + 1;
    vars.Add(_node.symbol);
  end;
  if (_node.left <> nil) or (_node.right <> nil) then
  begin
    count_box := count_box + 1;
    if (_node._not = true) then count_box := count_box + 1;
    findVariable(_node.left);
    findVariable(_node.right);
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////
procedure drawFormula(_node: Node);
begin
  if (_node.left = nil) and (_node.right = nil) then
  begin
    if (_node._not = true) then
    begin
      boxs.Add('@BOX:' + IntToStr(id) + ',P=(' + IntToStr(width) + ',' + IntToStr(height + 4) + '),S=(24,8),C=(1,1),X=NOT' + #13 + 'T=0');
      width := width - 40;
      id := id + 1;
    end;
    variables.Add('@VAR:' + IntToStr(id) + ',P=(' + IntToStr(width) + ',' + IntToStr(height) + '),S=(32,4),C=(1,1),X=' + _node.symbol);
    height := height + 4;
    id := id + 1;
  end;
  if (_node.left <> nil) or (_node.right <> nil) then
  begin
    if (_node._not = true) then
    begin
     boxs.Add('@BOX:' + IntToStr(id) + ',P=(' + IntToStr(width) + ',' + IntToStr(height + 4) + '),S=(24,8),C=(1,1),X=NOT' + #13 + 'T=0');
     width := width - 40;
     id := id + 1;
    end;
    if (_node.symbol = '*') then
      boxs.Add('@BOX:' + IntToStr(id) + ',P=(' + IntToStr(width) + ',' + IntToStr(height + 2) + '),S=(24,12),C=(2,1),X=AND' + #13 + 'T=0')
    else if (_node.symbol = '+') then
      boxs.Add('@BOX:' + IntToStr(id) + ',P=(' + IntToStr(width) + ',' + IntToStr(height + 2) + '),S=(24,12),C=(2,1),X=OR' + #13 + 'T=0');
    width := width - 40;
    id := id+ 1;
    drawFormula(_node.left);
    drawFormula(_node.right);
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////
procedure functionWriteFilePrepare(_tree: Tree);
var
  str, str_out, str_out2: TStringList;
  f, f2: TextFile;
  i, j, k, n: Integer;
  test: String;
begin
  findVariable(_tree.root);
  vars.Add(_tree.value);

  if (_tree.root._not = false) then for k := 0 to (count_box + count_vars + 1) do buff.Add('0') 
  else for k := 0 to (count_box + count_vars + 2) do buff.Add('0'); 
  width := ((count_box + 2) * 40);
  variables.Add('@VAR:' + IntToStr(id) + ',P=(' + IntToStr(width) + ',' + IntToStr(height) + '),S=(32,4),C=(1,1),X=' + _tree.value); 
  width := width - 32;
  id := id + 1;
  drawFormula(_tree.root); 
end;
////////////////////////////////////////////////////////////////////////////////////////
procedure functionWriteFile();
var
  str, str_out, str_out2: TStringList;
  f, f2: TextFile;
  i, j, k, n: Integer;
  test: String;
begin
  str := TStringList.Create;
  str_out := TStringList.Create;
  AssignFile(f, Unit1.Form1.Edit3.Text);
  str.LoadFromFile(Unit1.Form1.Edit3.Text, TEncoding.ANSI);
  str_out.Add(str[0]); // <?xml version="1.0" encoding="utf-8"?>
  str_out.Add(str[1]); // <Pou FileVersion= ........>
  str_out.Add(str[2]); //   <Program />
  str_out.Add(str[3]); //   <LocalVars>
  for j := 0 to (vars.Count - 1) do
  begin
    if (str_out.IndexOf('    <Variable Name="' + vars[j] + '" DataType="BOOL" InitialValue="" Comment="" Address="" Kind="Var" Alias="" AccessRights="ReadWrite" StringSize="0" />') = -1) then
      str_out.Add('    <Variable Name="' + vars[j] + '" DataType="BOOL" InitialValue="" Comment="" Address="" Kind="Var" Alias="" AccessRights="ReadWrite" StringSize="0" />');
  end;
  str_out.Add('  </LocalVars>');
  str_out.Add('#info= FBD');
  str_out.Add('@@NBID=' + IntToStr(count_box + count_vars + 1));
  for j := 0 to (boxs.Count - 1) do
  begin
   str_out.Add(boxs[j]);
  end;
  for j := 0 to (variables.Count - 1) do
  begin
   str_out.Add(variables[j]);
  end;
  for j := 0 to (arcs.Count - 1) do
  begin
      str_out.Add(arcs[j]);
  end;
  str_out.Add('#end_info');
  str_out.Add('#info= ID_MAX');
  str_out.Add('NextId=' + IntToStr(count_box + count_vars + 1));
  str_out.Add('#end_info');
  str_out.Add('END_PROGRAM]]></PouBody>');
  str_out.Add('</Pou>');
  ReWrite(f);
  for i := 0 to (str_out.Count - 1) do
    WriteLn(f, str_out[i]);
  CloseFile(f);
end;

////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Button1Click(Sender: TObject);
var
  prapare_isaxml: TStringList;
  _tree: Tree;
  _message, output: String;
  f, f2: TextFile;
  i: Integer;
begin
  prapare_isaxml := TStringList.Create;
  prapare_isaxml.LoadFromFile(Unit1.Form1.Edit3.Text, TEncoding.ANSI);
  for i := 0 to (prapare_isaxml.Count - 1) do
  begin
    if (AnsiPos('<LocalVars />', prapare_isaxml[i]) <> 0) then
    begin
     prapare_isaxml[i] := '  <LocalVars>';
     prapare_isaxml.Insert(i + 1, '  </LocalVars>');
    end;
  end;
  AssignFile(f2, Unit1.Form1.Edit3.Text);
  ReWrite(f2);
  for i := 0 to (prapare_isaxml.Count - 1) do
    WriteLn(f2, prapare_isaxml[i]);
  CloseFile(f2);
  AssignFile(f, edit1.Text);
  Reset(f);
  while not Eof(f) do
  begin
    readln(f, _message);
    _message := StringReplace(_message, ' ', '', [rfReplaceAll]);

    output := Copy(_message, 1, IndexOfAny(_message, '=') - 1);
    _message := Copy(_message, IndexOfAny(_message, '=') + 1, MAXINT);

    _tree := Tree.Create;
    _tree.root := Node.Create;
    _tree.value := output;

    view := '';
    buildTree(_message, _tree.root, brackets(_message), false);
    drawTree(_tree.root);

    // запись в файл схемы блоков (foreach tree = для каждой строки формул)
    functionWriteFilePrepare(_tree);
  end;
  functionWriteFile();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DataModule2.OpenDialog1.Title := 'Выберите входной файл с логическими формулами';
  DataModule2.OpenDialog1.Filter := 'Text Files(*.txt)|*.txt';
  DataModule2.OpenDialog1.FilterIndex := 0;
  DataModule2.OpenDialog1.FileName := '';

  if (DataModule2.OpenDialog1.Execute()) then
    Form1.Edit1.Text := DataModule2.OpenDialog1.FileName;
end;
////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Button3Click(Sender: TObject);
begin
  DataModule2.SaveDialog1.Title := 'Выберите выходной файл для функциональных формул';
  DataModule2.SaveDialog1.Filter := 'Text Files(*.txt)|*.txt';
  DataModule2.SaveDialog1.FilterIndex := 0;
  DataModule2.SaveDialog1.FileName := '';

  if (DataModule2.SaveDialog1.Execute()) then
  	Form1.Edit2.Text := DataModule2.SaveDialog1.FileName;
end;
////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Button4Click(Sender: TObject);
var
  _message, _message2 : Array of String;
  f, f2: TextFile;
  i, FileLength: Integer;
  list: TStringList;
  output: String;
  _tree: Unit1.Tree;
begin
  AssignFile(f, edit1.Text);
  Reset(f);
  FileLength := 0;
  while not EOF(f) do
  begin
    readln(f);
    FileLength := FileLength + 1;
  end;
  Reset(f);
  SetLength(_message, FileLength);
  SetLength(_message2, FileLength);
  i := 0;
  while not EOF(f) do
  begin
    readln(f, _message[i]);
    i := i + 1;
  end;
  for i := 0 to (FileLength - 1) do
  begin
    _message[i] := StringReplace(_message[i], ' ', '', [rfReplaceAll]);
    output := Copy(_message[i], 1, IndexOfAny(_message[i], '=') - 1);
    _message[i] := Copy(_message[i], IndexOfAny(_message[i], '=') + 1, MAXINT);

    _tree := Tree.Create;
    _tree.root := Node.Create;
    _tree.value := output;

    view := '';
    buildTree(_message[i], _tree.root, brackets(_message[i]), false);
    drawTree(_tree.root);

    _message2[i] := _tree.value + ' =' + view;
  end;
  AssignFile(f2, edit2.Text);
  ReWrite(f2);
  for i := 0 to FileLength do
    WriteLn(f2, _message2[i]);
  CloseFile(f);
  CloseFile(f2);
end;
/////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Button5Click(Sender: TObject);
begin
  DataModule2.SaveDialog1.Title := 'Выберите выходной файл на языке FBD';
  DataModule2.SaveDialog1.Filter := 'IsaXml Files(*.isaxml)|*.isaxml';
  DataModule2.SaveDialog1.FilterIndex := 0;
  DataModule2.SaveDialog1.FileName := '';

  if (DataModule2.SaveDialog1.Execute()) then
    Form1.Edit3.Text := DataModule2.SaveDialog1.FileName;
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
 view       := '';
 count_vars := 0;
 count_box  := 0;
 vars       := TStringList.Create;
 vars.Duplicates := dupIgnore;
 vars.Sorted  := true;
 id           := 1;
 Unit1.width  := 8;
 Unit1.height := 4;
 boxs         := TStringList.Create;
 variables    := TStringList.Create;
 arcs         := TstringList.Create;
 buff         := TstringList.Create;
 from         := 0;
 _to          := 0;
 from_size    := 0;
 to_size      := 0;
end;

///////////////////////////////////////////////////////////////////////////////////////
end.
