using System;
using System.Collections.Generic;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;

/*
 * 
 *  2019-08-15, Золотенко М.
 *  
 *  Інструмент для побудови і відправки звітності. C#-альтернатива макросу.
 *          
 * 
 * 
 * 
 */

namespace TaskRunner
{
    public partial class fmMain : Form
    {

        public const int WM_NCLBUTTONDOWN = 0xA1;
        public const int HT_CAPTION = 0x2;

        [DllImportAttribute("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
        [DllImportAttribute("user32.dll")]
        public static extern bool ReleaseCapture();


        TaskManager TM = new TaskManager(3);

        List<SingleTask> _SingleTasklst = new List<SingleTask>();
        bool fl_connected = false;

        private void OnSingleTaskEnd(object sender, EventArgs e)
        {
            WriteLog("Задача заверешна.");
            //_SingleTask = null;
            _SingleTasklst.RemoveAt(_SingleTasklst.IndexOf((SingleTask)sender));
            btnStop.Enabled = false;
            btnStop.BackgroundImage = Properties.Resources.square_shape_shadow_12_gray;
            btnRun.Enabled = true;
            btnRun.BackgroundImage = Properties.Resources.flash_24;

            //((SingleTask)sender)
        }

        public void WriteLog(string Msg)
        {
            //rtbLog.Text = (DateTime.Now +": "+ Msg + " "+(new String('.', 200))).Substring(0,120) + System.Environment.NewLine + rtbLog.Text;
            //MessageBox.Show(this.rtbLog.Text);
            this.rtbLog.Text = DateTime.Now + ": " + Msg + System.Environment.NewLine + this.rtbLog.Text;
        }

        private void CloseApp()
        {
            Close();
        }

        private void AfterConnection()
        {
            fl_connected = true;
            btnRun.BackgroundImage = Properties.Resources.flash_24;
            btnRun.Enabled = true;
            //btnKill.Enabled = true;
            pnlStatus.BackColor = Color.Teal;
            WriteLog("Connection is established.");
        }

        private void AfterDisconnection()
        {
            fl_connected = false;
            btnRun.BackgroundImage = Properties.Resources.flash_24_gray6;
            btnRun.Enabled = false;
            btnStop.Enabled = false;
            btnStop.BackgroundImage = Properties.Resources.square_shape_shadow_12_gray;
            pnlStatus.BackColor = Color.Tomato;

            WriteLog("Disconnected.");
        }

        public fmMain()
        {
            InitializeComponent();

            TM.OnMessage += TM_OnMessage;
        }

        private void TM_OnMessage(object sender, EventArgs e)
        {
            WriteLog(((TaskManagerEventArgs)e).GetMsg());
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            CloseApp();
        }

        private void fmMain_Load(object sender, EventArgs e)
        {

        }

        private void btnConnect_Click(object sender, EventArgs e)
        {

            if (!fl_connected)
            {
                ((Button)sender).Visible = false;
                this.Cursor = Cursors.WaitCursor;
                this.Refresh();
                //Thread.Sleep(1000);
                if (DBConnection.SetConnection("Server=scback;Database=OblKred;Trusted_Connection=True;Connection Timeout=5"))
                {
                    AfterConnection();
                }
                this.Cursor = Cursors.Default;
                ((Button)sender).Visible = true;
            }
            else
            {
                DBConnection.Disconnect();
                AfterDisconnection();
            }
        }

        private void fmMain_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                ReleaseCapture();
                SendMessage(Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
            }
        }

        private async void btnRun_Click(object sender, EventArgs e)
        {
            btnRun.Enabled = false;
            btnRun.BackgroundImage = Properties.Resources.flash_24_gray6;
            btnStop.Enabled = true;
            btnStop.BackgroundImage = Properties.Resources.square_shape_shadow_12;

            TM.Run();




            SingleTask _ST;
            
            _ST = new SingleTask(new SingleTaskSettings(1, @"\\fileserverlviv\backup\Кредитні ризики\Max\! Сектор Звітності\!Excel\_MacroTemplate.xlsm", @"C:\Max\Result.xlsx", 1, @"maksym.zolotenko@ideabank.ua", null, null, 0));
            _SingleTasklst.Add(_ST);
            _SingleTasklst[_SingleTasklst.IndexOf(_ST)].OnSingleTaskEnd += OnSingleTaskEnd;
            _SingleTasklst[_SingleTasklst.IndexOf(_ST)].RunTaskAsync();
            WriteLog("Задача запущена");

            _ST = new SingleTask(new SingleTaskSettings(1, @"C:\Max\_MacroTemplate1.xlsm", @"C:\Max\Result1.xlsx", 1, @"maksym.zolotenko@ideabank.ua", null, null, 0));
            _SingleTasklst.Add(_ST);
            _SingleTasklst[_SingleTasklst.IndexOf(_ST)].OnSingleTaskEnd += OnSingleTaskEnd;
            _SingleTasklst[_SingleTasklst.IndexOf(_ST)].RunTaskAsync();
            WriteLog("Задача запущена");

            _ST = new SingleTask(new SingleTaskSettings(1, @"C:\Max\_MacroTemplate2.xlsm", @"C:\Max\Result2.xlsx", 1, @"maksym.zolotenko@ideabank.ua", null, null, 0));
            _SingleTasklst.Add(_ST);
            _SingleTasklst[_SingleTasklst.IndexOf(_ST)].OnSingleTaskEnd += OnSingleTaskEnd;
            _SingleTasklst[_SingleTasklst.IndexOf(_ST)].RunTaskAsync();
            WriteLog("Задача запущена");

        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            /*if (_SingleTasklst != null)
            {
                _SingleTasklst[0].StopTask();
            }*/

            TM.Stop();

            while (_SingleTasklst.Count != 0)
            {
                _SingleTasklst[0].StopTask();
            }
        }

        private void Timer()
        {
            /*
             * Получить список задач на выполнение
             * 
             * 
             * */
            
            return;
        }
    }
}
