using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using Excel = Microsoft.Office.Interop.Excel;
using Outlook = Microsoft.Office.Interop.Outlook;

namespace TaskRunner
{
    public class SingleTask
    {
        [DllImport("user32.dll")]
        static extern int GetWindowThreadProcessId(int hWnd, out int lpdwProcessId);
        Process GetExcelProcess(Excel.Application excelApp)
        {
            int id;
            GetWindowThreadProcessId(excelApp.Hwnd, out id);
            return Process.GetProcessById(id);
        }

        private Excel.Application excel;        //  инстанс Excel
        private Outlook.Application outlook;    //  інстанс Outlook
        private Outlook.MailItem Msg;           //  інстанс MailItem
        private int excelProcessId;             //  код процесса
        private bool fl_killed = false;

        private SingleTaskSettings Settings;
        public Exception LastError;

        public event EventHandler OnSingleTaskEnd;

        void End(bool fl_killed = false)
        {

            //if (OnSingleTaskEnd != null)
            //{
            //    OnSingleTaskEnd(this, EventArgs.Empty);
            //}
            if (!this.fl_killed)
            {
                OnSingleTaskEnd?.Invoke(this, EventArgs.Empty);
                return;
            }

            if (this.LastError != null)
            {
                OnSingleTaskEnd?.Invoke(this, EventArgs.Empty);
                return;
            }
        }

        public SingleTask(SingleTaskSettings Settings)
        {
            this.Settings = Settings;
        }

        public int RunTask()
        {
            try
            {
                // Запускаем excel-шаблон
                /*Excel.Application*/
                excel = new Excel.Application();
                outlook = new Outlook.Application();
                Msg = (Outlook.MailItem)outlook.CreateItem(Outlook.OlItemType.olMailItem);

                excelProcessId = GetExcelProcess(excel).Id;
                Excel.Workbook wb = excel.Workbooks.Open(this.Settings.TemplatePath);
                excel.Application.Visible = true;

                //MessageBox.Show(GetExcelProcess(excel).Id.ToString());

                // Запускаем макрос
                    /*
                        В продвинутой версии, мы должны в c#-коде выполнять все то, что сейчас делаем в максросе в Excel
                            Хотя думаю, что было бы неплохо оставить возможность в шаблоне выполнять что-то макросом,
                            поэтому вызов макроса можно будет оставить.
                    */
                excel.Application.Run("Run", this.Settings.SavePath);
                Thread.Sleep(10000);
                
                // Отправляем письмецо

                Msg.HTMLBody = "Hi! This is a test mail.";
                Msg.Subject = "Task Runner Project Test Letter";
                Msg.To = "maksym.zolotenko@ideabank.ua";
                Msg.Send();

                //  Сворачиваем деятельность и подчищаем за собой
                excel.Application.Quit();
                excel = null;
                outlook = null;

                GC.Collect();

                End();

                return 0;

            } catch(Exception ex)
            {
                this.LastError = ex;

                //MessageBox.Show(ex.Message,"",MessageBoxButtons.OK, MessageBoxIcon.Error);

                GC.Collect();
                End();
                return 1;
            }
        }

        async public Task<int> RunTaskAsync()
        {
            return await Task<int>.Run(()=>RunTask());
        }
        // убиваем задачу
        public void StopTask()
        {
            Process proc = Process.GetProcessById(excelProcessId);
            proc.Kill();
            End(true);
            excel = null;
            outlook = null;
            Msg = null;
            this.fl_killed = true;
            return;
        }
    }

    public class SingleTaskSettings
    {
        public int ReportId { get; set; }
        public string TemplatePath { get; set; }
        public string SavePath { get; set; }
        public byte fl_send_email { get; set; }
        public string EmailList { get; set; }
        public string EmailBody { get; set; }
        public string EmailSubject { get; set; }

        public int fl_attachment;

        public SingleTaskSettings(int ReportId, string TemplatePath, string SavePath, byte fl_send_email, string EmailList, string EmailBody, string EmailSuject, int fl_attachment)
        {
            this.ReportId = ReportId;
            this.TemplatePath = TemplatePath;
            this.SavePath = SavePath;
            this.fl_send_email = fl_send_email;
            this.EmailList = EmailList;
            this.EmailBody = EmailBody;
            this.EmailSubject = EmailSubject;
            this.fl_attachment = fl_attachment;
        }
    }
}
