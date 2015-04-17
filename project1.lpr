{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };
//var
//  tr, tw: text;
//  i, k, n, t: integer;
//  time: array of integer;
//
//begin
//end.

//const n=4;k=2;
//var a:array[1..n] of integer;
//      i:integer;
//
//procedure generate (l,r:integer);
//var i,v:integer;
//begin
//  if (l=r) then
//   begin
//     for i:=1 to k do write(a[i],' ');
//     writeln;
//   end
//     else
//      begin
//        for i:=l to r do
//         begin
//           v:=a[l]; a[l]:=a[i]; a[i]:=v;
//           generate(l+1,r);
//           v:=a[l]; a[l]:=a[i]; a[i]:=v;
//         end;
//      end;
//end;
//
//begin
//  for i:=1 to n do
//  a[i]:=i;
//  generate(1, n);
//readln;
//end.

