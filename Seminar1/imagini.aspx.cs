using System;
using System.Configuration;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Linq;

namespace Seminar1
{
    public partial class imagini : System.Web.UI.Page
    {
        private OracleConnection GetConn()
        {
            string cons =
                "User ID=STUD_IGNATR; Password=student; Data Source=(DESCRIPTION=" +
                "(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=37.120.249.41)(PORT=1521)))" +
                "(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=orcls)));";
            return new OracleConnection(cons);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ecou.Text = "Gata de lucru. Încarcă o imagine sau caută una.";
                if (string.IsNullOrEmpty(hdnActiveSection.Value))
                    hdnActiveSection.Value = "dashboard";
                AfiseazaToateImaginile();
                IncarcaStatisticiDashboard();
                IncarcaAlbume();


            }
            else
            {
                string active = hdnActiveSection.Value;
                ScriptManager.RegisterStartupScript(this, GetType(), "showSection",
                    $"document.addEventListener('DOMContentLoaded', function() {{ " +
                    $"document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));" +
                    $"document.getElementById('{active}').classList.add('active');" +
                    $"document.querySelectorAll('.menu-link').forEach(l => l.classList.remove('active'));" +
                    $"document.querySelector('[data-section=\"{active}\"]').classList.add('active'); }});", true);
            }
        }


        private void AfiseazaToateImaginile()
        {
            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand(
                        "SELECT ID, DESCRIERE, TREAT(IMG AS ORDSYS.ORDIMAGE).SOURCE.LOCALDATA AS DATAIMG FROM IMGS ORDER BY ID DESC", conn))
                    {
                        using (var rd = cmd.ExecuteReader())
                        {
                            var sb = new StringBuilder();
                            bool hasImages = false;

                            while (rd.Read())
                            {
                                hasImages = true;
                                int id = rd.GetInt32(0);
                                string desc = rd.IsDBNull(1) ? "Fără descriere" : rd.GetString(1);
                                string date = ExtractMetadata(desc, "DATE");
                                string location = ExtractMetadata(desc, "LOC");
                                string tags = ExtractMetadata(desc, "TAGS");
                                string cleanDesc = CleanDescription(desc);

                                string base64 = "";
                                if (!rd.IsDBNull(2))
                                {
                                    OracleBlob blob = rd.GetOracleBlob(2);
                                    byte[] bytes = new byte[blob.Length];
                                    blob.Read(bytes, 0, bytes.Length);
                                    base64 = Convert.ToBase64String(bytes);
                                }

                                sb.Append($@"
                        <div class='gallery-item'>
                            <div class='gallery-item-image-container'>
                                <img src='data:image/jpeg;base64,{base64}' alt='Photo {id}' />
                                <div class='gallery-item-overlay'>
                                    <div class='quick-actions'>
                                        <button type='button' class='quick-action-btn' onclick=""viewImage({id})"">
                                            <i class='fas fa-eye'></i> View
                                        </button>
                                        <button type='button' class='quick-action-btn' onclick=""editImage({id})"">
                                            <i class='fas fa-edit'></i> Edit
                                        </button>
                                        <button type='button' class='quick-action-btn' onclick=""downloadImage({id})"">
                                            <i class='fas fa-download'></i> Save
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class='gallery-item-info'>
                                <div class='gallery-item-header'>
                                    <div class='gallery-item-id'>
                                        <i class='fas fa-hashtag'></i> {id}
                                    </div>
                                    <div class='gallery-item-date'>{date}</div>
                                </div>
                                <div class='gallery-item-desc'>{cleanDesc}</div>
                                <div class='gallery-item-meta'>");

                                if (!string.IsNullOrEmpty(location))
                                    sb.Append($"<span class='meta-badge'><i class='fas fa-map-marker-alt'></i> {location}</span>");
                                if (!string.IsNullOrEmpty(tags))
                                    sb.Append($"<span class='meta-badge'><i class='fas fa-tags'></i> {tags}</span>");

                                sb.Append(@"
                                </div>
                            </div>
                        </div>");
                            }

                            galleryContainer.InnerHtml = hasImages ? sb.ToString() :
                                "<div class='empty-state'><i class='fas fa-images'></i><h3>Nicio fotografie</h3><p>Începe prin a încărca prima ta poză!</p></div>";
                        }
                    }
                }
                catch (Exception ex)
                {
                    ecou.Text = "Eroare: " + ex.Message;
                    ecou.Visible = true;
                }
            }
        }

        protected void btn_afiseaza_toate_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "gallery";
            ecou.Text = "";
            tb_img.Text = ""; 
            AfiseazaToateImaginile();
        }

       //Inserare imagine
        protected void btn_submit_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "upload";
            ecou.Text = "";

            if (!FileUpload1.HasFile)
            {
                ecou.Text = "Selectează un fișier imagine.";
                return;
            }

            var metaDate = tb_metaDate.Text.Trim();
            var metaLoc = tb_metaLocatie.Text.Trim();
            var metaTags = tb_tags.Text.Trim();

            byte[] imageBytes;
            try
            {
                using (var ms = new MemoryStream())
                {
                    FileUpload1.PostedFile.InputStream.CopyTo(ms);
                    imageBytes = ms.ToArray();
                }
            }
            catch (Exception ex)
            {
                ecou.Text = "Nu am putut citi fișierul: " + ex.Message;
                return;
            }

            var descriere = tb_descriere.Text.Trim();
            if (!string.IsNullOrEmpty(metaDate)) descriere += $" | DATE={metaDate}";
            if (!string.IsNullOrEmpty(metaLoc)) descriere += $" | LOC={metaLoc}";
            if (!string.IsNullOrEmpty(metaTags)) descriere += $" | TAGS={metaTags}";

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand("PROC_INS_IMAGINE", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("vID", OracleDbType.Int32).Value = Convert.ToInt32(tb_id.Text);
                        cmd.Parameters.Add("vDescriere", OracleDbType.Varchar2, 4000).Value = descriere;
                        cmd.Parameters.Add("vFisier", OracleDbType.Blob).Value = imageBytes;
                        cmd.ExecuteNonQuery();
                    }
                    ecou.Text = $"Imaginea '{FileUpload1.FileName}' a fost încărcată cu succes! (size={imageBytes.Length} bytes)";
                }
                catch (OracleException ex)
                {
                    ecou.Text = "Eroare Oracle la inserare: " + ex.Message;
                }
                catch (Exception ex)
                {
                    ecou.Text = "Eroare: " + ex.Message;
                }
            }
        }

       //Afiseaza imagine dupa id
        protected void afiseazaImagine_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "gallery";
            ecou.Text = "";

            int id;
            if (!int.TryParse(tb_img.Text, out id))
            {
                ecou.Text = "ID invalid.";
                AfiseazaToateImaginile(); // Revine la toate imaginile
                return;
            }

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand("PROC_AFIS_IMAGINE", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("vid", OracleDbType.Int32).Value = id;
                        var pOut = cmd.Parameters.Add("flux", OracleDbType.Blob);
                        pOut.Direction = System.Data.ParameterDirection.Output;

                        cmd.ExecuteScalar();

                        var blob = (OracleBlob)pOut.Value;
                        if (blob == null || blob.IsNull)
                        {
                            ecou.Text = "Nu există imagine pentru ID=" + id;
                            AfiseazaToateImaginile();
                            return;
                        }
                        byte[] bytes = new byte[blob.Length];
                        blob.Read(bytes, 0, bytes.Length);

                        string base64 = Convert.ToBase64String(bytes);
                        img.ImageUrl = "data:image/jpeg;base64," + base64;

                        // Afișează doar imaginea căutată
                        singleImageContainer.Visible = true;
                        galleryContainer.Visible = false;
                        ecou.Text = $"Imagine ID={id} afișată.";
                    }
                }
                catch (OracleException ex)
                {
                    ecou.Text = "Eroare Oracle la afișare: " + ex.Message;
                    AfiseazaToateImaginile();
                }
            }
        }

        //Prelucrarea imaginilor
        //Resize
        protected void btn_resize_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "edit";
            ecou.Text = "";

            int id, w, h;

            if (!int.TryParse(tb_resize_id.Text, out id)
                || !int.TryParse(tb_w.Text, out w)
                || !int.TryParse(tb_h.Text, out h))
            {
                ecou.Text = "Completează ID/Width/Height corect.";
                return;
            }

            try
            {
                using (var conn = GetConn())
                {
                    conn.Open();

                    byte[] originalBytes;
                    using (var cmdGet = new OracleCommand("PROC_EXPORT_IMAGINE", conn))
                    {
                        cmdGet.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdGet.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        var pOut = cmdGet.Parameters.Add("flux", OracleDbType.Blob);
                        pOut.Direction = System.Data.ParameterDirection.Output;

                        cmdGet.ExecuteScalar();

                        var blob = (OracleBlob)pOut.Value;
                        if (blob == null || blob.IsNull)
                        {
                            ecou.Text = $"Nu s-a găsit imaginea cu ID={id}.";
                            return;
                        }

                        originalBytes = new byte[blob.Length];
                        blob.Read(originalBytes, 0, originalBytes.Length);
                    }

                    byte[] resizedBytes;
                    using (var msIn = new MemoryStream(originalBytes))
                    using (var original = System.Drawing.Image.FromStream(msIn))
                    {
                        using (var resized = new System.Drawing.Bitmap(original, new System.Drawing.Size(w, h)))
                        using (var msOut = new MemoryStream())
                        {
                            resized.Save(msOut, System.Drawing.Imaging.ImageFormat.Jpeg);
                            resizedBytes = msOut.ToArray();
                        }
                    }

                    using (var cmdUpdate = new OracleCommand("PROC_UPDATE_IMAGINE", conn))
                    {
                        cmdUpdate.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdUpdate.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        cmdUpdate.Parameters.Add("vFisier", OracleDbType.Blob).Value = resizedBytes;
                        cmdUpdate.Parameters.Add("vLatime", OracleDbType.Int32).Value = w;
                        cmdUpdate.Parameters.Add("vInaltime", OracleDbType.Int32).Value = h;

                        cmdUpdate.ExecuteNonQuery();
                    }

                    ecou.Text = $"Imaginea a fost redimensionată la {w}x{h}px și actualizată.";
                }
            }
            catch (OracleException ex)
            {
                ecou.Text = "Eroare Oracle: " + ex.Message;
            }
            catch (Exception ex)
            {
                ecou.Text = "Eroare generală: " + ex.Message;
            }
        }

        //Rotire imagine
        protected void btn_rotate_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "edit";
            ecou.Text = "";

            if (!int.TryParse(tb_resize_id.Text, out int id) || !float.TryParse(tb_rotate_angle.Text, out float angle))
            {
                ecou.Text = "Completează ID și unghi valid (ex: 90, 180).";
                return;
            }

            try
            {
                using (var conn = GetConn())
                {
                    conn.Open();

                    byte[] bytes;
                    using (var cmdGet = new OracleCommand("PROC_EXPORT_IMAGINE", conn))
                    {
                        cmdGet.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdGet.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        var pOut = cmdGet.Parameters.Add("flux", OracleDbType.Blob);
                        pOut.Direction = System.Data.ParameterDirection.Output;

                        cmdGet.ExecuteScalar();
                        var blob = (OracleBlob)pOut.Value;
                        if (blob == null || blob.IsNull)
                        {
                            ecou.Text = "Imaginea nu a fost găsită.";
                            return;
                        }
                        bytes = new byte[blob.Length];
                        blob.Read(bytes, 0, bytes.Length);
                    }

                    using (var ms = new MemoryStream(bytes))
                    using (var img = System.Drawing.Image.FromStream(ms))
                    {
                        img.RotateFlip(System.Drawing.RotateFlipType.Rotate90FlipNone); 
                        using (var msOut = new MemoryStream())
                        {
                            img.Save(msOut, System.Drawing.Imaging.ImageFormat.Jpeg);
                            bytes = msOut.ToArray();
                        }
                    }

                    using (var cmdUpdate = new OracleCommand("PROC_UPDATE_IMAGINE", conn))
                    {
                        cmdUpdate.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdUpdate.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        cmdUpdate.Parameters.Add("vFisier", OracleDbType.Blob).Value = bytes;
                        cmdUpdate.Parameters.Add("vLatime", OracleDbType.Int32).Value = 0;
                        cmdUpdate.Parameters.Add("vInaltime", OracleDbType.Int32).Value = 0;
                        cmdUpdate.ExecuteNonQuery();
                    }

                    ecou.Text = $"Imaginea a fost rotită cu succes la {angle}°.";
                }
            }
            catch (Exception ex)
            {
                ecou.Text = "Eroare: " + ex.Message;
            }
        }

        //Ajusteaza imagine
        protected void btn_adjust_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "edit";
            ecou.Text = "";

            if (!int.TryParse(tb_resize_id.Text, out int id))
            {
                ecou.Text = "ID invalid.";
                return;
            }

            float brightness = float.TryParse(tb_brightness.Text, out float b) ? b : 1.0f;
            float contrast = float.TryParse(tb_contrast.Text, out float c) ? c : 1.0f;

            try
            {
                using (var conn = GetConn())
                {
                    conn.Open();
                    byte[] bytes;

                    using (var cmdGet = new OracleCommand("PROC_EXPORT_IMAGINE", conn))
                    {
                        cmdGet.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdGet.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        var pOut = cmdGet.Parameters.Add("flux", OracleDbType.Blob);
                        pOut.Direction = System.Data.ParameterDirection.Output;
                        cmdGet.ExecuteScalar();
                        var blob = (OracleBlob)pOut.Value;
                        bytes = new byte[blob.Length];
                        blob.Read(bytes, 0, bytes.Length);
                    }

                    using (var ms = new MemoryStream(bytes))
                    using (var img = System.Drawing.Image.FromStream(ms))
                    using (var bmp = new System.Drawing.Bitmap(img.Width, img.Height))
                    {
                        using (var g = System.Drawing.Graphics.FromImage(bmp))
                        {
                            float adjustedBrightness = brightness - 1.0f;
                            float[][] ptsArray = {
                        new float[] {contrast, 0, 0, 0, 0},
                        new float[] {0, contrast, 0, 0, 0},
                        new float[] {0, 0, contrast, 0, 0},
                        new float[] {0, 0, 0, 1, 0},
                        new float[] {adjustedBrightness, adjustedBrightness, adjustedBrightness, 0, 1}
                    };
                            var cm = new System.Drawing.Imaging.ColorMatrix(ptsArray);
                            var ia = new System.Drawing.Imaging.ImageAttributes();
                            ia.SetColorMatrix(cm);
                            g.DrawImage(img, new System.Drawing.Rectangle(0, 0, bmp.Width, bmp.Height),
                                0, 0, img.Width, img.Height, System.Drawing.GraphicsUnit.Pixel, ia);
                        }

                        using (var msOut = new MemoryStream())
                        {
                            bmp.Save(msOut, System.Drawing.Imaging.ImageFormat.Jpeg);
                            bytes = msOut.ToArray();
                        }
                    }

                    using (var cmdUpdate = new OracleCommand("PROC_UPDATE_IMAGINE", conn))
                    {
                        cmdUpdate.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdUpdate.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        cmdUpdate.Parameters.Add("vFisier", OracleDbType.Blob).Value = bytes;
                        cmdUpdate.Parameters.Add("vLatime", OracleDbType.Int32).Value = 0;
                        cmdUpdate.Parameters.Add("vInaltime", OracleDbType.Int32).Value = 0;
                        cmdUpdate.ExecuteNonQuery();
                    }

                    ecou.Text = "Luminozitatea și contrastul au fost ajustate!";
                }
            }
            catch (Exception ex)
            {
                ecou.Text = "Eroare: " + ex.Message;
            }
        }

        //Aplicare filtre pe imagini
        protected void btn_grayscale_Click(object sender, EventArgs e)
        {
            AplicăFiltruImagine("grayscale");
        }

        protected void btn_sepia_Click(object sender, EventArgs e)
        {
            AplicăFiltruImagine("sepia");
        }

        private void AplicăFiltruImagine(string tip)
        {
            hdnActiveSection.Value = "edit";
            ecou.Text = "";

            if (!int.TryParse(tb_resize_id.Text, out int id))
            {
                ecou.Text = "Introdu ID valid.";
                return;
            }

            try
            {
                using (var conn = GetConn())
                {
                    conn.Open();
                    byte[] bytes;

                    using (var cmdGet = new OracleCommand("PROC_EXPORT_IMAGINE", conn))
                    {
                        cmdGet.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdGet.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        var pOut = cmdGet.Parameters.Add("flux", OracleDbType.Blob);
                        pOut.Direction = System.Data.ParameterDirection.Output;
                        cmdGet.ExecuteScalar();
                        var blob = (OracleBlob)pOut.Value;
                        bytes = new byte[blob.Length];
                        blob.Read(bytes, 0, bytes.Length);
                    }

                    using (var ms = new MemoryStream(bytes))
                    using (var img = new System.Drawing.Bitmap(System.Drawing.Image.FromStream(ms)))
                    {
                        for (int y = 0; y < img.Height; y++)
                        {
                            for (int x = 0; x < img.Width; x++)
                            {
                                var p = img.GetPixel(x, y);
                                int gray = (int)(0.3 * p.R + 0.59 * p.G + 0.11 * p.B);
                                if (tip == "grayscale")
                                    img.SetPixel(x, y, System.Drawing.Color.FromArgb(gray, gray, gray));
                                else if (tip == "sepia")
                                {
                                    int r = Math.Min(255, (int)(gray * 1.07));
                                    int g = Math.Min(255, (int)(gray * 0.74));
                                    int b = Math.Min(255, (int)(gray * 0.43));
                                    img.SetPixel(x, y, System.Drawing.Color.FromArgb(r, g, b));
                                }
                            }
                        }

                        using (var msOut = new MemoryStream())
                        {
                            img.Save(msOut, System.Drawing.Imaging.ImageFormat.Jpeg);
                            bytes = msOut.ToArray();
                        }
                    }

                    using (var cmdUpdate = new OracleCommand("PROC_UPDATE_IMAGINE", conn))
                    {
                        cmdUpdate.CommandType = System.Data.CommandType.StoredProcedure;
                        cmdUpdate.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        cmdUpdate.Parameters.Add("vFisier", OracleDbType.Blob).Value = bytes;
                        cmdUpdate.Parameters.Add("vLatime", OracleDbType.Int32).Value = 0;
                        cmdUpdate.Parameters.Add("vInaltime", OracleDbType.Int32).Value = 0;
                        cmdUpdate.ExecuteNonQuery();
                    }

                    ecou.Text = tip == "grayscale" ? "Imaginea a fost convertită în alb-negru!" : "Filtrul sepia a fost aplicat!";
                }
            }
            catch (Exception ex)
            {
                ecou.Text = "Eroare: " + ex.Message;
            }
        }


        //EXPORT
        protected void btn_export_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "edit";
            ecou.Text = "";

            int id;
            if (!int.TryParse(tb_export_id.Text, out id))
            {
                ecou.Text = "ID invalid pentru export.";
                return;
            }

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand("PROC_EXPORT_IMAGINE", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("vID", OracleDbType.Int32).Value = id;
                        var pOut = cmd.Parameters.Add("flux", OracleDbType.Blob);
                        pOut.Direction = System.Data.ParameterDirection.Output;

                        cmd.ExecuteScalar();
                        var blob = (OracleBlob)pOut.Value;
                        if (blob == null || blob.IsNull)
                        {
                            ecou.Text = "Nu există imagine pentru export.";
                            return;
                        }

                        byte[] bytes = new byte[blob.Length];
                        blob.Read(bytes, 0, bytes.Length);

                        Response.Clear();
                        Response.ContentType = "image/jpeg";
                        Response.AddHeader("Content-Disposition", $"attachment; filename=img_{id}.jpg");
                        Response.BinaryWrite(bytes);
                        Response.End();
                    }
                }
                catch (System.Threading.ThreadAbortException)
                {
                    //
                }
                catch (OracleException ex)
                {
                    ecou.Text = "Eroare Oracle la export: " + ex.Message;
                }
            }
        }
        // Cautarea semantica 
        protected void btn_cauta_similar_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "search";
            ecou.Text = "";

            if (!FileUpload2.HasFile)
            {
                ecou.Text = "Încarcă imaginea pentru căutare.";
                return;
            }

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var gen = new OracleCommand("PROC_GEN_SEMN_IMAGINI", conn))
                    {
                        gen.CommandType = System.Data.CommandType.StoredProcedure;
                        gen.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    ecou.Text = "Eroare la generarea semnăturilor: " + ex.Message;
                    return;
                }
            }

            byte[] queryBytes;
            using (var ms = new MemoryStream())
            {
                FileUpload2.PostedFile.InputStream.CopyTo(ms);
                queryBytes = ms.ToArray();
            }

            decimal cCuloare = Convert.ToDecimal(ddl_culoare.SelectedValue, System.Globalization.CultureInfo.InvariantCulture);
            decimal cTextura = Convert.ToDecimal(ddl_textura.SelectedValue, System.Globalization.CultureInfo.InvariantCulture);
            decimal cForma = Convert.ToDecimal(ddl_forma.SelectedValue, System.Globalization.CultureInfo.InvariantCulture);
            decimal cLoc = Convert.ToDecimal(ddl_locatie.SelectedValue, System.Globalization.CultureInfo.InvariantCulture);

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand("PROC_REGASIRE_IMAGINE", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("vFisier", OracleDbType.Blob).Value = queryBytes;
                        cmd.Parameters.Add("vCuloare", OracleDbType.Decimal).Value = cCuloare;
                        cmd.Parameters.Add("vTextura", OracleDbType.Decimal).Value = cTextura;
                        cmd.Parameters.Add("vForme", OracleDbType.Decimal).Value = cForma;
                        cmd.Parameters.Add("vLocatie", OracleDbType.Decimal).Value = cLoc;
                        var pOut = cmd.Parameters.Add("vRezultat", OracleDbType.Int32);
                        pOut.Direction = System.Data.ParameterDirection.Output;

                        cmd.ExecuteNonQuery();

                        int idRez = Convert.ToInt32(pOut.Value.ToString());

                        if (idRez <= 0)
                        {
                            lbl_similar_result.CssClass = "alert alert-warning";
                            lbl_similar_result.Text = "😕 Nicio imagine asemănătoare nu a fost găsită.";
                        }
                        else
                        {
                            lbl_similar_result.CssClass = "alert alert-success";
                            lbl_similar_result.Text = "✅ Imagine asemănătoare găsită! ID: " + idRez;

                            tb_img.Text = idRez.ToString();
                            hdnActiveSection.Value = "gallery";
                            afiseazaImagine_Click(null, null);
                        }
                    }
                }
                catch (OracleException ex)
                {
                    ecou.Text = "Eroare Oracle la căutare semantică: " + ex.Message;
                }
            }
        }


        //Generare semnaturi
        protected void GenerareSemnaturi_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "settings";
            ecou.Text = "";

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand("PROC_GEN_SEMN_IMAGINI", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.ExecuteNonQuery();
                    }
                    ecou.Text = "Semnături generate cu succes!";
                }
                catch (OracleException ex)
                {
                    ecou.Text = "Eroare Oracle la generare semnături: " + ex.Message;
                }
            }
        }

        // Cautare textuala
        protected void btn_search_text_Click(object sender, EventArgs e)
        {
            hdnActiveSection.Value = "search";
            ecou.Text = "";

            var q = (tb_text_query.Text ?? "").Trim().ToLower();
            if (string.IsNullOrEmpty(q))
            {
                ecou.Text = "Introdu un termen (ex: pisici, munte, familie).";
                return;
            }

            using (var conn = GetConn())
            {
                try
                {
                    conn.Open();
                    using (var cmd = new OracleCommand("PROC_SEARCH_TEXTUAL_BLOB", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("vText", OracleDbType.Varchar2, 4000).Value = q;

                        var pOut = cmd.Parameters.Add("cur", OracleDbType.RefCursor);
                        pOut.Direction = System.Data.ParameterDirection.Output;

                        using (var rd = cmd.ExecuteReader())
                        {
                            var sb = new StringBuilder();
                            sb.Append("<div style='display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:1.5rem;'>");

                            bool found = false;

                            while (rd.Read())
                            {
                                found = true;
                                int id = rd.GetInt32(0);
                                string desc = rd.IsDBNull(1) ? "" : rd.GetString(1);

                                string base64 = "";
                                if (!rd.IsDBNull(2))
                                {
                                    OracleBlob blob = rd.GetOracleBlob(2);
                                    if (blob != null && !blob.IsNull)
                                    {
                                        byte[] bytes = new byte[blob.Length];
                                        blob.Read(bytes, 0, bytes.Length);
                                        base64 = Convert.ToBase64String(bytes);
                                    }
                                }

                                sb.Append($@"
                                    <div style='background:white;border-radius:16px;
                                                box-shadow:0 4px 15px rgba(0,0,0,0.1);
                                                overflow:hidden;text-align:center;padding:1rem;
                                                cursor:pointer;transition:transform 0.3s;'
                                         onmouseover='this.style.transform=""translateY(-8px)""'
                                         onmouseout='this.style.transform=""translateY(0)""'>
                                        {(string.IsNullOrEmpty(base64)
                                            ? "<div style='height:200px;display:flex;align-items:center;justify-content:center;color:#94a3b8;'>📄 Fără imagine</div>"
                                            : $"<img src='data:image/jpeg;base64,{base64}' style='width:100%;height:200px;object-fit:cover;border-radius:12px;' />")}
                                        <p style='font-weight:600;margin-top:0.5rem;color:#6366f1;'>ID={id}</p>
                                        <p style='font-size:0.9rem;color:#475569;'>{desc}</p>
                                    </div>");
                            }

                            sb.Append("</div>");

                            if (!found)
                                sb.Clear().Append("<div class='alert alert-warning'> Nicio imagine găsită pentru acest tag.</div>");

                            results.InnerHtml = sb.ToString();
                        }
                    }
                }
                catch (OracleException ex)
                {
                    ecou.Text = "Eroare Oracle la căutare text: " + ex.Message;
                }
                catch (Exception ex)
                {
                    ecou.Text = "Eroare generală la căutare text: " + ex.Message;
                }
            }
        }

        private void IncarcaStatisticiDashboard()
        {
            try
            {
                using (var conn = GetConn())
                {
                    conn.Open();

                    // Total imagini
                    using (var cmd = new OracleCommand("SELECT COUNT(*) FROM IMGS", conn))
                    {
                        lbl_totalImagini.Text = Convert.ToString(cmd.ExecuteScalar());
                    }

                    // Tag-uri unice extrase din descriere
                    using (var cmd = new OracleCommand(@"
                SELECT COUNT(DISTINCT REGEXP_SUBSTR(descriere, 'TAGS=([^|]+)', 1, 1, NULL, 1))
                FROM IMGS
                WHERE descriere LIKE '%TAGS=%'", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        lbl_totalTaguri.Text = (result == DBNull.Value) ? "0" : Convert.ToString(result);
                    }

                    // Locații distincte
                    using (var cmd = new OracleCommand(@"
                SELECT COUNT(DISTINCT REGEXP_SUBSTR(descriere, 'LOC=([^|]+)', 1, 1, NULL, 1))
                FROM IMGS
                WHERE descriere LIKE '%LOC=%'", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        lbl_totalLocatii.Text = (result == DBNull.Value) ? "0" : Convert.ToString(result);
                    }
                }
            }
            catch (Exception ex)
            {
                ecou.Text = "Eroare la încărcarea statisticilor: " + ex.Message;
            }
        }

        protected async void btn_analyze_ml_Click(object sender, EventArgs e)

        {
            hdnActiveSection.Value = "ml";
            lbl_ml_result.Text = "";
            lbl_ml_result.Visible = true;

            if (!FileUploadML.HasFile)
            {
                lbl_ml_result.CssClass = "alert alert-warning";
                lbl_ml_result.Text = "Selectează mai întâi o imagine pentru analiză.";
                img_ml_preview.Visible = false;
                return;
            }

            try
            {
                byte[] imgBytes;
                using (var ms = new MemoryStream())
                {
                    FileUploadML.PostedFile.InputStream.CopyTo(ms);
                    imgBytes = ms.ToArray();
                }

                // Validează mărimea imaginii
                if (imgBytes.Length == 0)
                {
                    lbl_ml_result.CssClass = "alert alert-warning";
                    lbl_ml_result.Text = "Imaginea încărcată este goală.";
                    img_ml_preview.Visible = false;
                    return;
                }

                if (imgBytes.Length > 10 * 1024 * 1024) // Max 10MB
                {
                    lbl_ml_result.CssClass = "alert alert-warning";
                    lbl_ml_result.Text = "⚠️ Imaginea este prea mare. Maxim 10MB.";
                    img_ml_preview.Visible = false;
                    return;
                }
                string base64 = Convert.ToBase64String(imgBytes);
                img_ml_preview.ImageUrl = "data:image/jpeg;base64," + base64;
                img_ml_preview.Visible = true;

                // Apel ML
                string rezultatML = await AnalyzeImageWithPythonAsync(imgBytes);


                // Afișează rezultatul
                if (rezultatML.StartsWith("❌"))
                {
                    lbl_ml_result.CssClass = "alert alert-danger";
                }
                else
                {
                    lbl_ml_result.CssClass = "alert alert-success";
                }

                lbl_ml_result.Text = rezultatML.Replace("\n", "<br/>");
            }
            catch (FileNotFoundException ex)
            {
                lbl_ml_result.CssClass = "alert alert-danger";
                lbl_ml_result.Text = $"Fișier lipsă: {ex.Message}<br/>Asigură-te că ai fișierele:<br/>- squeezenet1.0-12.onnx<br/>- imagenet_classes.txt<br/>în folderul AppData/Models/";
                img_ml_preview.Visible = false;
            }
            catch (Exception ex)
            {
                lbl_ml_result.CssClass = "alert alert-danger";
                lbl_ml_result.Text = $"Eroare la analiza ML: {ex.Message}";
                img_ml_preview.Visible = false;
            }
        }


        private async Task<string> AnalyzeImageWithPythonAsync(byte[] imageBytes)
        {
            try
            {
                using (var client = new HttpClient())
                using (var content = new MultipartFormDataContent())
                {
                    content.Add(new ByteArrayContent(imageBytes), "file", "image.jpg");

                    var response = await client.PostAsync("http://127.0.0.1:5000/classify", content);
                    var json = await response.Content.ReadAsStringAsync();

                    if (!response.IsSuccessStatusCode)
                        return $"Eroare API: {json}";

                    var results = JArray.Parse(json);
                    var formatted = "🎯 Top 3 predicții:<br/>";
                    foreach (var r in results.Take(3))
                    {
                        formatted += $"{r["label"]} ({(float)r["confidence"]:P1})<br/>";
                    }

                    return formatted;
                }
            }
            catch (Exception ex)
            {
                return $"Eroare conexiune cu API-ul Python: {ex.Message}";
            }
        }



        private string ExtractMetadata(string descriere, string tip)
        {
            if (string.IsNullOrEmpty(descriere) || string.IsNullOrEmpty(tip))
                return "";

            try
            {
                string pattern = $"{tip}=";
                int idx = descriere.IndexOf(pattern, StringComparison.OrdinalIgnoreCase);
                if (idx == -1) return "";

                int end = descriere.IndexOf('|', idx);
                if (end == -1) end = descriere.Length;

                string valoare = descriere.Substring(idx + pattern.Length, end - (idx + pattern.Length));
                return valoare.Trim();
            }
            catch
            {
                return "";
            }
        }

        private string CleanDescription(string descriere)
        {
            if (string.IsNullOrEmpty(descriere))
                return "";
            string[] parts = descriere.Split('|');
            return parts[0].Trim();
        }

        private void IncarcaAlbume()
        {
            try
            {
                using (var conn = GetConn())
                {
                    conn.Open();

                    // Funcție locală pentru a număra imaginile după tag
                    int CountByTag(string tag)
                    {
                        using (var cmd = new OracleCommand(
                            "SELECT COUNT(*) FROM IMGS WHERE LOWER(DESCRIERE) LIKE :tag", conn))
                        {
                            cmd.Parameters.Add(":tag", OracleDbType.Varchar2).Value = "%" + tag.ToLower() + "%";
                            object result = cmd.ExecuteScalar();
                            return (result == DBNull.Value) ? 0 : Convert.ToInt32(result);
                        }
                    }

                    // Setează numărul real în HTML (album-count)
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "updateAlbums", $@"
                document.querySelectorAll('.album-card').forEach(a => {{
                    let tag = a.getAttribute('onclick').match(/'(.*?)'/)[1];
                    let count = 0;
                    switch(tag){{
                        case 'familie': count = {CountByTag("familie")}; break;
                        case 'vacanta': count = {CountByTag("vacanta")}; break;
                        case 'natura': count = {CountByTag("natura")}; break;
                        case 'evenimente': count = {CountByTag("evenimente")}; break;
                        case 'animale': count = {CountByTag("animale")}; break;
                    }}
                    let el = a.querySelector('.album-count');
                    if (el) el.innerText = count + (count == 1 ? ' fotografie' : ' fotografii');
                }});", true);
                }
            }
            catch (Exception ex)
            {
                ecou.Text = "Eroare la încărcarea albumelor: " + ex.Message;
            }
        }


    }
}