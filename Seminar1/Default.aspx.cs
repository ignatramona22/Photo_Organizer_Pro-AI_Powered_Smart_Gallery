using System;
using System.Web.UI;

namespace Seminar1
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Pagina de landing nu necesită logică server-side
            // Tot conținutul este static și se renderează direct în HTML

            // Opțional: poți adăuga analytics sau tracking aici
            if (!IsPostBack)
            {
                // Log visitor
                LogPageVisit();
            }
        }

        private void LogPageVisit()
        {
            // Opțional: salvează vizita în baza de date sau log file
            string userIP = Request.UserHostAddress;
            string userAgent = Request.UserAgent;
            DateTime visitTime = DateTime.Now;

            // Exemplu: salvare în log
            System.Diagnostics.Debug.WriteLine($"[LANDING PAGE] Visitor from {userIP} at {visitTime}");
        }
    }
}