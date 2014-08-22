unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, jpeg;

type
  TFormMain = class(TForm)
    Timer_msSQL: TTimer;
    Timer_dotNet: TTimer;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Image1: TImage;
    TabSheet3: TTabSheet;
    Image2: TImage;
    Image3: TImage;
    Label5: TLabel;
    EditPass: TEdit;
    Label7: TLabel;
    BtnNext: TBitBtn;
    BtnCancel: TBitBtn;
    Label8: TLabel;
    MemoBatch: TMemo;
    TabSheet4: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Image4: TImage;
    Label_Status: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label6: TLabel;
    TabSheet5: TTabSheet;
    Label11: TLabel;
    Image5: TImage;
    BtnMDF: TBitBtn;
    BtnLDF: TBitBtn;
    Label12: TLabel;
    Label13: TLabel;
    OpenDialogMDF: TOpenDialog;
    OpenDialogLDF: TOpenDialog;
    TabSheet6: TTabSheet;
    Label14: TLabel;
    Image6: TImage;
    Label15: TLabel;
    img_MDF: TImage;
    img_LDF: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Timer_msSQLTimer(Sender: TObject);
    procedure Timer_dotNetTimer(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure EditPassKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnMDFClick(Sender: TObject);
    procedure BtnLDFClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function get_dotNetInstallInform:Boolean;
    function get_msSQL2005InstallInform:Boolean;
    function is_WindowsXP:Boolean;

    procedure dotNetPerform;
    procedure msSQLPerform;
    procedure run_Query;

    procedure dotNet_Install(SN:Integer);
    procedure msSQL_Install(SN:Integer);


    procedure FinishInstallation;

    function myComputerName:String;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  ShellApi, Registry;
//==============================================================================
var


  dotNet_StpNum:Integer;

  MainText:array[1..12] of PAnsiChar;

  StaticText:array[1..12] of PAnsiChar;
  ButtonText:array[1..12] of PAnsiChar;
  CheckBoxText:PAnsiChar;
  RadioButtonText:PAnsiChar;

  StepNumber:Integer;
  ElapsedTime:Integer;
  SleepInterval:Integer;

  PageIndex:Integer=0;

  CopyDir:String;
  sqlCmdpath:String;
  file_M, file_L:String;

  MDFfilename, LDFfilename:String;

//==============================================================================
procedure TFormMain.FormCreate(Sender: TObject);
var
  i:Integer;
begin

  dotNet_StpNum:=1;
  StepNumber:=1;

  MDFfilename:='';
  LDFfilename:='';

  PageControl1.ActivePageIndex:=PageIndex;

  SleepInterval:=500;
  for i:=1 to 12 do
  begin
    MainText[i]:='';
    StaticText[i]:='';
    ButtonText[i]:='';
  end;



  MainText[1]:='Microsoft SQL Server 2005 Setup';
  StaticText[1]:='End User License Agreement';
  ButtonText[1]:='&Next >';

  CheckBoxText:='I &accept the licensing terms and conditions';

  MainText[2]:='Microsoft SQL Server 2005 Setup';
  StaticText[2]:='Installing Prerequisites';
  ButtonText[2]:='&Next >';

  MainText[3]:='Microsoft SQL Server 2005 Setup';
  StaticText[3]:='Welcome to the Microsoft SQL Server Installation Wizard';
  ButtonText[3]:='&Next >';

  MainText[4]:='Microsoft SQL Server 2005 Setup';
  StaticText[4]:='System Configuration Check';
  ButtonText[4]:='&Next >';

  MainText[5]:='Microsoft SQL Server 2005 Express Edition Setup';
  StaticText[5]:='Registration Information';
  ButtonText[5]:='&Next >';

  MainText[6]:='Microsoft SQL Server 2005 Express Edition Setup';
  StaticText[6]:='Feature Selection ';
  ButtonText[6]:='&Next >';

  MainText[7]:='Microsoft SQL Server 2005 Express Edition Setup';
  StaticText[7]:='Authentication Mode';
  ButtonText[7]:='&Next >';

  RadioButtonText:='&Mixed Mode (Windows Authentication and SQL Server Authentication)';

  MainText[8]:='Microsoft SQL Server 2005 Express Edition Setup';
  StaticText[8]:='Configuration Options';
  ButtonText[8]:='&Next >';

  MainText[9]:='Microsoft SQL Server 2005 Express Edition Setup';
  StaticText[9]:='Error and Usage Report Settings';
  ButtonText[9]:='&Next >';

  MainText[10]:='Microsoft SQL Server 2005 Express Edition Setup';
  StaticText[10]:='Ready to Install ';
  ButtonText[10]:='&Install';

  MainText[11]:='Microsoft SQL Server 2005 Setup';
  StaticText[11]:='Setup Progress';
  ButtonText[11]:='&Next >>';

  MainText[12]:='Microsoft SQL Server 2005 Setup';
  StaticText[12]:='Completing Microsoft SQL Server 2005 Setup';
  ButtonText[12]:='&Finish';

end;
//==============================================================================
procedure TFormMain.msSQL_Install(SN: Integer);
var
  MainWindow, StaticWindow, ButtonWindow, RadioWindow, CheckWindow, EditWindow:THandle;
  TestStr:array[0..255] of char;
  SN_Increable:Boolean;

  ck_R:TRect;
begin

  SN_Increable:=False;

  Memo1.Lines.Add('Step'+IntToStr(SN));
  Memo1.Lines.Add(MainText[SN]);
  Memo1.Lines.Add(StaticText[SN]);
  Memo1.Lines.Add(ButtonText[SN]);
  Memo1.Lines.Add('=============================================================');

    case SN of
      1:
      begin
        MainWindow:=FindWindow(nil, MainText[SN]);
        if MainWindow<>0 then
        begin
          SetForegroundWindow(MainWindow);
          StaticWindow:=FindWindowEx(MainWindow, 0, nil, StaticText[SN]);
          if StaticWindow<>0 then
          begin
            CheckWindow:=FindWindowEx(MainWindow,0,nil,CheckBoxText);
            if CheckWindow<>0 then
            begin
              SendMessage(CheckWindow, BM_CLICK, 0, 0);
            end;
            ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
            if ButtonWindow<>0 then
            begin
              Sleep(SleepInterval);
              SendMessage(ButtonWindow, BM_CLICK, 0, 0);
              SN_Increable:=True;
            end;
          end;
        end;
      end;

      2, 5, 8, 9, 10, 11, 12:
      begin
        MainWindow:=FindWindow(nil, MainText[SN]);
        if MainWindow<>0 then
        begin
          SetForegroundWindow(MainWindow);
          StaticWindow:=FindWindowEx(MainWindow, 0, nil, StaticText[SN]);
          if StaticWindow<>0 then
          begin

            if SN=2 then
            begin
              ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
              if ButtonWindow=0 then
                ButtonWindow:=FindWindowEx(MainWindow, 0, nil, '&Install');
            end
            else
            begin
              ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
            end;

            if ButtonWindow<>0 then
            begin
              while StaticWindow<>0 do
              begin
                Sleep(SleepInterval);
                StaticWindow:=FindWindowEx(MainWindow, 0, nil, StaticText[SN]);
                SendMessage(ButtonWindow, BM_CLICK, 0, 0);
                SN_Increable:=True;
              end;
            end;

          end;
        end;
      end;

      3:
      begin
        MainWindow:=FindWindow(nil, MainText[SN]);
        if MainWindow<>0 then
        begin
          SetForegroundWindow(MainWindow);

          StaticWindow:=GetWindow(MainWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_HWNDNEXT);
          GetWindowText(StaticWindow, @TestStr, 255);

          if Strpas(@TestStr)=Strpas(StaticText[SN]) then
          begin
            ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
            if ButtonWindow<>0 then
            begin
              Sleep(SleepInterval);
              SendMessage(ButtonWindow, BM_CLICK, 0, 0);
              SN_Increable:=True;
            end;
          end;
        end;
      end;

      4:
      begin
        MainWindow:=FindWindow(nil, MainText[SN]);
        if MainWindow<>0 then
        begin
          SetForegroundWindow(MainWindow);

          StaticWindow:=GetWindow(MainWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_CHILD);
          StaticWindow:=GetWindow(StaticWindow, GW_HWNDNEXT);
          GetWindowText(StaticWindow, @TestStr, 255);

          if Strpas(@TestStr)=Strpas(StaticText[SN]) then
          begin
            ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
            ButtonWindow:=GetWindow(ButtonWindow, GW_HWNDNEXT);
            ButtonWindow:=GetWindow(ButtonWindow, GW_HWNDNEXT);

            if ButtonWindow<>0 then
            begin
              Sleep(SleepInterval*4);
              SendMessage(ButtonWindow, BM_CLICK, 0, 0);
              SN_Increable:=True;
            end;
          end;
        end;
      end;

      6:
      begin
        MainWindow:=FindWindow(nil, MainText[SN]);
        if MainWindow<>0 then
        begin
          SetForegroundWindow(MainWindow);

          GetWindowRect(MainWindow,ck_R );

          sleep(200);

          SetCursorPos(100+ ck_R.Left ,175+ ck_R.Top )  ;
          mouse_event(MOUSEEVENTF_LEFTDOWN,100+ ck_R.Left,175+ ck_R.Top,0,0);
          mouse_event(MOUSEEVENTF_LEFTUP,100+ ck_R.Left,175+ ck_R.Top,0,0);

          Sleep(200);

          SetCursorPos(100+ ck_R.Left ,200+ ck_R.Top )  ;
          mouse_event(MOUSEEVENTF_LEFTDOWN,100+ ck_R.Left,200+ ck_R.Top,0,0);
          mouse_event(MOUSEEVENTF_LEFTUP,100+ ck_R.Left,200+ ck_R.Top,0,0);

          StaticWindow:=FindWindowEx(MainWindow, 0, nil, StaticText[SN]);
          if StaticWindow<>0 then
          begin

            if SN=2 then
            begin
              ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
              if ButtonWindow=0 then
                ButtonWindow:=FindWindowEx(MainWindow, 0, nil, '&Install');
            end
            else
            begin
              ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);
            end;

            if ButtonWindow<>0 then
            begin
              while StaticWindow<>0 do
              begin
                Sleep(SleepInterval);
                StaticWindow:=FindWindowEx(MainWindow, 0, nil, StaticText[SN]);
                SendMessage(ButtonWindow, BM_CLICK, 0, 0);
                SN_Increable:=True;
              end;
            end;

          end;
        end;
      end;

      7:
      begin
        MainWindow:=FindWindow(nil, MainText[SN]);
        if MainWindow<>0 then
        begin
          SetForegroundWindow(MainWindow);
          StaticWindow:=FindWindowEx(MainWindow, 0, nil, StaticText[SN]);
          if StaticWindow<>0 then
          begin

            RadioWindow:=GetWindow(MainWindow, GW_CHILD);
            RadioWindow:=GetWindow(RadioWindow, GW_CHILD);
            RadioWindow:=GetWindow(RadioWindow, GW_HWNDNEXT);

            GetWindowText(RadioWindow, @TestStr, 255);

            if Strpas(@TestStr)=Strpas(RadioButtonText) then
              SendMessage(RadioWindow, BM_CLICK, 0, 0);

            EditWindow:=FindWindowEx(MainWindow, 0, nil, '&Enter password:');
            EditWindow:=GetWindow(EditWindow, GW_HWNDNEXT);

            SendMessage(EditWindow, WM_SETTEXT, 0, LPARAM(PAnsiChar('kerdhin')));
            SendMessage(EditWindow, WM_LBUTTONDBLCLK, 0, 0);

            EditWindow:=FindWindowEx(MainWindow, 0, nil, 'Confirm &password:');
            EditWindow:=GetWindow(EditWindow, GW_HWNDNEXT);


            SendMessage(EditWindow, WM_SETTEXT, 0, LPARAM(PAnsiChar('kerdhin')));
            SendMessage(EditWindow, WM_LBUTTONDBLCLK, 0, 0);

            ButtonWindow:=FindWindowEx(MainWindow, 0, nil, ButtonText[SN]);

            if ButtonWindow<>0 then
            begin
              Sleep(SleepInterval);
              SendMessage(ButtonWindow, BM_CLICK, 0, 0);
              SN_Increable:=True;
            end;
          end;
        end;
      end;

    end;


    if SN_Increable then
    begin
      Inc(StepNumber);
      SN_Increable:=False;

    end;

end;

//==============================================================================

procedure TFormMain.Timer_msSQLTimer(Sender: TObject);
begin
  Application.ProcessMessages;
  ElapsedTime:=ElapsedTime+Timer_msSQL.Interval;
  Memo1.Lines.Add('');
  Memo1.Lines.Add(FormatFloat('#.#S', ElapsedTime/1000));
  msSQL_Install(StepNumber);
  if StepNumber>12 then
  begin
    Timer_msSQL.Enabled:=False;
    //run_Query;
    Application.MessageBox('MS SQL Server 2005 is installed','Information',MB_ICONINFORMATION);
    Inc(PageIndex);
    BtnNext.Caption:='&Next';
    BtnNext.Enabled:=True;
    BtnCancel.Enabled:=True;
    PageControl1.ActivePageIndex:=PageIndex;
  end;

end;
//==============================================================================

procedure TFormMain.dotNet_Install(SN:Integer);
var

  MainWindow, ChildWindow, ButtonWindow, RadioWindow:THandle;
//  TestStr:array[0..255] of char;

  SN_Increable:Boolean;
begin

  SN_Increable:=False;

  Memo1.Lines.Add('dotNetStep'+IntToStr(SN));
  Memo1.Lines.Add('=============================================================');


  case SN of
    1:
    begin
      MainWindow:=FindWindow(nil, 'Microsoft .NET Framework 3.5 Setup');
      if MainWindow<>0 then
      begin
        SetForegroundWindow(MainWindow);
        ChildWindow:=GetWindow(MainWindow, GW_CHILD);
        ChildWindow:=GetWindow(ChildWindow, GW_HWNDNEXT);
        ChildWindow:=GetWindow(ChildWindow, GW_HWNDNEXT);
        ChildWindow:=GetWindow(ChildWindow, GW_HWNDNEXT);
        ChildWindow:=GetWindow(ChildWindow, GW_HWNDNEXT);
        ChildWindow:=GetWindow(ChildWindow, GW_HWNDNEXT);

        RadioWindow:=FindWindowEx(ChildWindow, 0, nil, 'I have read and &ACCEPT the terms of the License Agreement');

        if RadioWindow<>0 then
        begin
          SendMessage(RadioWindow, BM_CLICK, 0, 0);

          ButtonWindow:=FindWindowEx(ChildWindow, 0, nil, '&Install >');

          if ButtonWindow<>0 then
          begin
            Sleep(SleepInterval);
            SendMessage(ButtonWindow, BM_CLICK, 0, 0);
            SN_Increable:=True;
          end;
        end;
      end;
    end;
    2:
    begin
      MainWindow:=FindWindow(nil, 'Microsoft .NET Framework 3.5 Setup');
      if MainWindow<>0 then
      begin
        SetForegroundWindow(MainWindow);
        ChildWindow:=GetWindow(MainWindow, GW_CHILD);
        ButtonWindow:=FindWindowEx(ChildWindow, 0, nil, 'E&xit');

        if ButtonWindow<>0 then
        begin
          while MainWindow<>0 do
          begin
            Sleep(SleepInterval);
            MainWindow:=FindWindow(nil, 'Microsoft .NET Framework 3.5 Setup');
            //SendMessage(ButtonWindow, BM_CLICK, 0, 0);
            SN_Increable:=True;
          end;
        end;
      end;
    end;

  end;

  if SN_Increable then
  begin
    Inc(dotNet_StpNum);
    SN_Increable:=False;
  end;

end;

//==============================================================================

procedure TFormMain.Timer_dotNetTimer(Sender: TObject);
begin
  Application.ProcessMessages;
  ElapsedTime:=ElapsedTime+Timer_dotNet.Interval;
  Memo1.Lines.Add('');
  Memo1.Lines.Add(FormatFloat('#.#S', ElapsedTime/1000));
  dotNet_Install(dotNet_StpNum);
  if dotNet_StpNum>2 then
  begin
    Timer_dotNet.Enabled:=False;
    Application.MessageBox('.net Framework 3.5 is installed.','Information',MB_ICONINFORMATION);
    msSQLPerform;
  end;

end;
//==============================================================================

procedure TFormMain.BtnNextClick(Sender: TObject);
begin
  Inc(PageIndex);

//  BtnExit.Enabled:=False;
  if PageIndex=0 then
  begin
    BtnNext.Enabled:=True;
    BtnNext.Caption:='&Next';
    BtnCancel.Enabled:=True;
    PageControl1.ActivePageIndex:=PageIndex;
  end
  else if PageIndex=1 then
  begin
    BtnNext.Enabled:=True;
    BtnNext.Caption:='&Next';
    BtnCancel.Enabled:=True;
    PageControl1.ActivePageIndex:=PageIndex;
    EditPass.SetFocus;
  end
  else if PageIndex=2 then
  begin
    if EditPass.Text<>'epos10' then
    begin
      Application.MessageBox('License key is invalid. Please try again later.','Warning', MB_ICONWARNING);
      EditPass.SetFocus;
      PageIndex:=1;
    end
    else
    begin

      PageControl1.ActivePageIndex:=PageIndex;
      
      label4.Caption:='Click Install button to continue.';
      BtnNext.Caption:='&Install';
    end;
    //BtnCancel.Caption:='&Finish';
  end
  else if PageIndex=3 then
  begin
    //PageIndex:=2;
    PageControl1.ActivePageIndex:=PageIndex;
    BtnNext.Enabled:=False;
    BtnCancel.Enabled:=False;
    dotNetPerform;
  end
  else if PageIndex=5 then
  begin
    PageIndex:=4;
    if MDFfilename='' then
    begin
      Application.MessageBox('Please select the MDF file to initialize','Warning',MB_ICONWARNING);

    end
    else if LDFfilename='' then
    begin
      Application.MessageBox('Please select the LDF file to initialize','Warning',MB_ICONWARNING);
    end
    else
    begin
      run_Query;
    end;

  end;
end;
//==============================================================================
procedure TFormMain.BtnCancelClick(Sender: TObject);
begin
  if BtnCancel.Caption='&Finish' then
  begin
    Application.Terminate;
  end
  else
  begin
    if Application.MessageBox('Do you really exit installation?', 'Question',MB_ICONQUESTION+MB_YESNO)=ID_YES then
    begin
      Application.Terminate;
    end
  end;
end;
//==============================================================================
function TFormMain.get_dotNetInstallInform: Boolean;
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  if Reg.KeyExists('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft .NET Framework 3.5') then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;
//==============================================================================
function TFormMain.get_msSQL2005InstallInform: Boolean;
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  if Reg.KeyExists('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2005') then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;
//==============================================================================
procedure TFormMain.dotNetPerform;
begin
  Label4.Caption:='Please wait while installing ePos';
  Label_Status.Caption:='Installing .Net FrameWork 3.5...';
  if is_WindowsXP then
  begin
   if get_dotNetInstallInform then
   begin
     Application.MessageBox('.Net FrameWork 3.5 was already installed.','Notify',MB_ICONINFORMATION);
     msSQLPerform;
   end
   else
   begin
     ShellExecute(Handle, 'open', PAnsiChar(ExtractFilePath(Application.ExeName)+'dotNetFramework\dotNetFx35setup.exe'),'',nil, SW_SHOWNORMAL);
     Timer_dotNet.Enabled:=True;
   end;
  end
  else
  begin
    msSQLPerform;
  end;

end;
//==============================================================================
procedure TFormMain.msSQLPerform;
begin
  Label_Status.Caption:='Installing Microsot SQL Server 2005...';
if get_msSQL2005InstallInform then
  begin
    Application.MessageBox('MS SQL Sever 2005 was already installed. '#13'For ePos Anytime setting you should uninstall it.'#13'Current Installation will be terminated.','Important Information',MB_ICONWARNING);
    Application.Terminate;
  end
  else
  begin
    ShellExecute(Handle, 'open', PAnsiChar(ExtractFilePath(Application.ExeName)+'SQLEXPR2005\SQLEXPR.exe'),'',nil, SW_SHOWNORMAL);
    Timer_msSQL.Enabled:=True;
  end; (* *)
(*//------------------------------
    Timer_msSQL.Enabled:=False;
    //run_Query;
    Inc(PageIndex);
    BtnNext.Caption:='&Next';
    BtnNext.Enabled:=True;
    BtnCancel.Enabled:=True;
    PageControl1.ActivePageIndex:=PageIndex;
//---------------------------------------------    *)
end;
//==============================================================================

procedure TFormMain.run_Query;
var
  CommandStr:String;
  batchFileName:String;
  qryFile:TStrings;
begin

  Label_Status.Caption:='initializing ePos...';

  qryFile:=TStringList.Create;

  qryFile.Add('CREATE DATABASE INFINITYEPOS ON');
  qryFile.Add('( FILENAME = "'+file_M+'" ),');
  qryFile.Add('( FILENAME = "'+file_L+'" )');
  qryFile.Add('FOR ATTACH');

  qryFile.SaveToFile('C:\myScript.sql');

  Sleep(500);

  CommandStr:='sqlcmd -S '+myComputerName+'\SQLEXPRESS -i C:\myScript.sql';

  ShellExecute(Handle, 'open', PChar('sqlcmd.exe'), PChar(' -S '+myComputerName+'\SQLEXPRESS -i C:\myScript.sql'), nil, SW_SHOW);


  Sleep(500);

  MemoBatch.Lines.Add(CommandStr);

  batchFileName:='C:\myBatch.bat';

  MemoBatch.Lines.SaveToFile(batchFileName);

  ShellExecute(Handle, 'open', PAnsiChar(batchFileName),'',nil, SW_SHOWNORMAL);


  Sleep(500);

  WinExec(PAnsiChar(CommandStr),SW_SHOWNORMAL);


  Sleep(500);

  ShellExecute(Handle, 'open', PChar(sqlCmdpath+'sqlcmd.exe -S '+myComputerName+'\SQLEXPRESS -i C:\myScript.sql'), nil, nil, SW_SHOW);

  Sleep(500);

  ShellExecute(Handle, 'open', PAnsiChar(batchFileName),'',nil, SW_SHOWNORMAL);

  Sleep(500);

  WinExec(PAnsiChar(sqlCmdpath+CommandStr),SW_SHOWNORMAL);

  Application.MessageBox('ePos initialization is finished.','Information',MB_ICONINFORMATION);
  
  FinishInstallation;
end;
//==============================================================================
procedure TFormMain.FinishInstallation;
begin
  Inc(PageIndex);
  PageControl1.ActivePageIndex:=PageIndex;
  BtnNext.Visible:=False;
  BtnCancel.Caption:='&Finish';
  BtnCancel.Enabled:=True;
end;
//==============================================================================
function TFormMain.myComputerName: String;
var
  arr: array[0..127] of char;
  d: DWORD;
begin

  d := SizeOf(arr);
  GetComputerName(arr, d);
  Result:=StrPas(arr);

end;
//==============================================================================
procedure TFormMain.EditPassKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    BtnNextClick(nil);
end;
//==============================================================================
procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('Do you really exit installation?', 'Question',MB_ICONQUESTION+MB_YESNO)=ID_YES then
  begin
    CanClose:=True;
  end
  else
  begin
    CanClose:=False;
  end;
end;
//==============================================================================
function TFormMain.is_WindowsXP: Boolean;
var
  Reg:TRegistry;
  WinVer:Real;
begin
  Result:=False;
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', False) then
  begin
    if Reg.ValueExists('CurrentVersion') then
    begin
      WinVer:=StrToFloat(Reg.ReadString('CurrentVersion'));
      if WinVer>5.1 then
        Result:=False
      else
        Result:=True;
    end;
  end;

end;
//==============================================================================
procedure TFormMain.BtnMDFClick(Sender: TObject);
begin
  if OpenDialogMDF.Execute then
  begin
    MDFfilename:=OpenDialogMDF.FileName;
    if DirectoryExists('C:\Program Files (x86)') then
    begin
      CopyDir:='C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\Data';
    end
    else
    begin
      CopyDir:='C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data';
    end;

    ForceDirectories(CopyDir);

    file_M:=CopyDir+'\'+ExtractFileName(MDFfilename);

    CopyFile(PAnsiChar(MDFfilename), PAnsiChar(file_M), True);
    Sleep(1000);
    img_MDF.Visible:=True;
  end;
end;

procedure TFormMain.BtnLDFClick(Sender: TObject);
begin
  if OpenDialogLDF.Execute then
  begin
    LDFfilename:=OpenDialogLDF.FileName;
    if DirectoryExists('C:\Program Files (x86)') then
    begin
      CopyDir:='C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\Data';
      sqlCmdpath:='C:\Program Files (x86)\Microsoft SQL Server\90\Tools\Binn\';
    end
    else
    begin
      CopyDir:='C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data';
      sqlCmdpath:='C:\Program Files\Microsoft SQL Server\90\Tools\Binn\';
    end;

    ForceDirectories(CopyDir);

    file_L:=CopyDir+'\'+ExtractFileName(LDFfilename);

    CopyFile(PAnsiChar(LDFfilename), PAnsiChar(file_L), True);
    Sleep(1000);
    img_LDF.Visible:=True;
  end;
end;

end.

