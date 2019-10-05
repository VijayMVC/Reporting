using System;
using System.Data.SqlClient;

namespace TaskRunner
{
    static class DBConnection
    {
        static private SqlConnection _Connection = new SqlConnection();
        static private DBConnectionState _ConnectionState = DBConnectionState.Disconnected;

        static DBConnection()
        {
            _Connection.StateChange += _Connection_StateChange;
        }

        static public bool SetConnection(string ConnectionString)
        {
            _Connection.ConnectionString = ConnectionString;
            try
            {
                _Connection.Open();
                _ConnectionState = DBConnectionState.Connected;
            } catch(Exception ex)
            {
                return false;
            }

            return true;
        }

        static public void Disconnect()
        {
            _Connection.Close();
            _ConnectionState = DBConnectionState.Disconnected;
        }

        private static void _Connection_StateChange(object sender, System.Data.StateChangeEventArgs e)
        {
            //throw new NotImplementedException();
            //MessageBox.Show("State is changed!");
        }
        
        public static DBConnectionState GetConnectionState()
        {
            return _ConnectionState;
        }

        public static SqlConnection GetConnection()
        {
            if (GetConnectionState() == DBConnectionState.Connected)
            {
                return _Connection;
            } else
            {
                return null;
            }
        }

    }

    //  Статуси стану підключення: підключено/відключено
    public enum DBConnectionState
    {
        Connected,
        Disconnected
    }
}
