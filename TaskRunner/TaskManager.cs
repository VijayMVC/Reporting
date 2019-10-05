using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace TaskRunner
{
    //  
    //  Класс для управления простыми задачами
    //  
    public class TaskManager
    {

        /*
         * Взаємодія з БД буде відбуватись через статичний клас DBConnection
         * 
         * 
         * 
        */

        private Dictionary<int, SingleTask> SingelTaskLst = new Dictionary<int, SingleTask>(); //  Mapping: ID - SingleTask
        private int _RefreshInterval = 60;                          //  частота, с которой будет обновляться состояние (в секундах)
        private System.Threading.Timer tmr;                         //  timer
        private TaskManagerState _State = TaskManagerState.Stop;    //  current state of Manager: stop or running
        private SqlConnection _Connection;

        public event EventHandler OnMessage;                        //  відправка повідомлення у основну форму

        public TaskManager(int RefreshInterval)
        {
            _RefreshInterval = RefreshInterval;
            this.tmr = new System.Threading.Timer(new System.Threading.TimerCallback(RunTimerStatic), this, System.Threading.Timeout.Infinite, _RefreshInterval*1000);
        }

        public void Run()
        {
            /*
             *  Запускаєм таймер
             *  
             *  
             *  
            */

            if (DBConnection.GetConnectionState() == DBConnectionState.Connected)
            {
                tmr.Change(0, _RefreshInterval * 1000);
                OnMessage?.Invoke(this, new TaskManagerEventArgs("TaskManager has been started."));
            }

            return;
        }

        public void Stop()
        {
            tmr.Change(System.Threading.Timeout.Infinite, _RefreshInterval*1000);
            OnMessage?.Invoke(this, new TaskManagerEventArgs("TaskManager has been stopped."));

            return;
        }

        public void CreateST(int ID, SingleTaskSettings Settings)
        {
            SingelTaskLst.Add(ID, new SingleTask(Settings));

            return;
        }

        static private void RunTimerStatic(object obj)
        {
            ((TaskManager)obj).RunTimer();

            return;
        }

        private void RunTimer()
        {
            //OnMessage?.Invoke(this, new TaskManagerEventArgs("Task Manager is running....."));

            return;
        }

        public TaskManagerState GetState()
        {
            return this._State;
        }
    }

    public enum TaskManagerState
    {
        Stop,
        Running
    }

    public class TaskManagerEventArgs: EventArgs
    {
        string _Msg;

        public TaskManagerEventArgs(string Msg)
        {
            _Msg = Msg;
        }

        public string GetMsg()
        {
            return _Msg;
        }
    }

}
