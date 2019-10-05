using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ReportingEditor
{
    public partial class fmMain : Form
    {
        public fmMain()
        {
            InitializeComponent();
        }

        private Boolean SetConnection()
        {

            fmLogin fm = new fmLogin();

            fm.ShowDialog();

            if (fm.DialogResult == DialogResult.OK)
                return true;
            else
                return false;

        }

        private void SetMenuItems(Boolean show)
        {
            if (show == true)
            {
                miDisconnect.Visible = true;
                miConnect.Visible = false;
            } else
            {
                miDisconnect.Visible = false;
                miConnect.Visible = true;
            }
        }

        private void Disconnect()
        {

        }

        private void CloseApp()
        {
            if (MessageBox.Show("Дійсно хочете вийти з програми?","Увага!",MessageBoxButtons.YesNo,MessageBoxIcon.Question,MessageBoxDefaultButton.Button2) == DialogResult.Yes)
            {
                Disconnect();
                Close();
            }
        }

        private void miConnect_Click(object sender, EventArgs e)
        {
            Boolean res = SetConnection();

            if (res == true)
            {
                SetMenuItems(true);
            }
        }

        private void miClose_Click(object sender, EventArgs e)
        {
            CloseApp();
        }

        private void miDisconnect_Click(object sender, EventArgs e)
        {
            SetMenuItems(false);
        }

        private void довідникиToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Utils.ErrorMsg("Some error has occured......");
        }
    }
}
