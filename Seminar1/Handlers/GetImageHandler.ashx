<%@ WebHandler Language="C#" Class="GetImageHandler" %>
using System;
using System.Web;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

public class GetImageHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "image/jpeg";
        string id = context.Request.QueryString["id"];
        if (string.IsNullOrEmpty(id)) return;

        using (var conn = new OracleConnection(
            "User ID=STUD_IGNATR; Password=student; Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=37.120.249.41)(PORT=1521)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=orcls)));"))
        {
            conn.Open();
            using (var cmd = new OracleCommand("PROC_EXPORT_IMAGINE", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("vID", OracleDbType.Int32).Value = Convert.ToInt32(id);
                var pOut = cmd.Parameters.Add("flux", OracleDbType.Blob);
                pOut.Direction = System.Data.ParameterDirection.Output;
                cmd.ExecuteScalar();
                var blob = (OracleBlob)pOut.Value;
                if (blob != null && !blob.IsNull)
                {
                    byte[] bytes = new byte[blob.Length];
                    blob.Read(bytes, 0, bytes.Length);
                    context.Response.BinaryWrite(bytes);
                }
            }
        }
    }

    public bool IsReusable => false;
}
