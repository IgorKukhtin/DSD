-- Function: gpSelect_Movement_Invoice_DropBox()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_DropBox (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_DropBox(
    IN inStartDate     TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar
             , MovementId Integer
             , isFilesUploaded Boolean
             , FilePath TVarChar
             , ReceiptNumber TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbProductId Integer;
   DECLARE vbKredit TVarChar;
   DECLARE vbDebet TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    vbDebet := COALESCE((SELECT tmp.Value
                         FROM gpSelect_Object_EmailSettings (inEmailKindId:= 0, inSession:= '5') AS tmp
                         WHERE tmp.Value <> '' AND tmp.EmailKindId IN (zc_Enum_EmailKind_DropBox_InvoiceDebet())), 'InvoiceFile\Debet');

    vbKredit := COALESCE((SELECT tmp.Value
                          FROM gpSelect_Object_EmailSettings (inEmailKindId:= 0, inSession:= '5') AS tmp
                          WHERE tmp.Value <> '' AND tmp.EmailKindId IN (zc_Enum_EmailKind_DropBox_InvoiceKredit())), 'InvoiceFile\Kredit');

     -- Результат
     RETURN QUERY
       WITH
          tmpInvoicePdf AS (SELECT Movement_Invoice.Id                                    AS  MovementId
                                 , Movement_Invoice.InvNumber                             AS  InvNumber
                                 , MovementBoolean_FilesNotUploaded.ValueData IS NOT NULL AS isFilesUploaded
                                 , Object_InvoicePdf.*
                            FROM Object AS Object_InvoicePdf
                                 INNER JOIN ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                                                        ON ObjectFloat_InvoicePdf_MovmentId.ObjectId = Object_InvoicePdf.Id
                                                       AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId()
                                 INNER JOIN Movement AS Movement_Invoice
                                                     ON Movement_Invoice.Id = ObjectFloat_InvoicePdf_MovmentId.ValueData
                                                    AND Movement_Invoice.DescId   = zc_Movement_Invoice()
                                 LEFT JOIN MovementBoolean AS MovementBoolean_FilesNotUploaded
                                                           ON MovementBoolean_FilesNotUploaded.MovementId = Movement_Invoice.Id
                                                          AND MovementBoolean_FilesNotUploaded.DescId = zc_MovementBoolean_FilesNotUploaded()
                            WHERE Object_InvoicePdf.DescId = zc_Object_InvoicePdf()
                              AND COALESCE (MovementBoolean_FilesNotUploaded.ValueData, FALSE) = FALSE),
          tmpObjectProtocol AS (SELECT ObjectProtocol.ObjectId
                                     , Max(ObjectProtocol.OperDate)   AS OperDate
                                FROM tmpInvoicePdf 
                                     INNER JOIN ObjectProtocol ON ObjectProtocol.ObjectId = tmpInvoicePdf.Id
                                     LEFT JOIN ObjectDate AS ObjectDate_DateUnloading
                                                          ON ObjectDate_DateUnloading.ObjectId = tmpInvoicePdf.Id
                                                         AND ObjectDate_DateUnloading.DescId = zc_ObjectDate_InvoicePdf_DateUnloading()
                                WHERE ObjectProtocol.OperDate <> COALESCE(ObjectDate_DateUnloading.ValueData, ObjectProtocol.OperDate - INTERVAL '1 DAY')
                                GROUP BY ObjectProtocol.ObjectId
                                )

    SELECT
            Object_InvoicePdf.Id               AS Id
          , Object_InvoicePdf.ValueData        AS FileName
          , Object_InvoicePdf.MovementId       AS MovementId
          , Object_InvoicePdf.isFilesUploaded  AS isFilesUploaded
          , CASE WHEN COALESCE(MovementFloat_Amount.ValueData, 0) < 0 
                 THEN vbKredit
                 ELSE vbDebet END::TVarChar   AS FilePath
          , COALESCE(MovementString_ReceiptNumber.ValueData, Object_InvoicePdf.InvNumber)::TVarChar  AS ReceiptNumber 
     FROM tmpInvoicePdf AS Object_InvoicePdf
     
          LEFT JOIN tmpObjectProtocol ON tmpObjectProtocol.ObjectId = Object_InvoicePdf.Id 

          LEFT JOIN MovementFloat AS MovementFloat_Amount
                                  ON MovementFloat_Amount.MovementId = Object_InvoicePdf.MovementId 
                                 AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

          LEFT JOIN ObjectDate AS ObjectDate_DateUnloading
                               ON ObjectDate_DateUnloading.ObjectId = Object_InvoicePdf.Id
                              AND ObjectDate_DateUnloading.DescId = zc_ObjectDate_InvoicePdf_DateUnloading()

          LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                   ON MovementString_ReceiptNumber.MovementId = Object_InvoicePdf.MovementId 
                                  AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
                                     
     WHERE COALESCE(MovementFloat_Amount.ValueData, 0) <> 0 
       AND (tmpObjectProtocol.OperDate >= inStartDate
        OR Object_InvoicePdf.isFilesUploaded = TRUE
        OR ObjectDate_DateUnloading.ValueData IS NULL)
     ORDER BY Object_InvoicePdf.MovementId, Object_InvoicePdf.Id
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.02.24                                                       *
*/

-- тест
-- 
select * from gpSelect_Movement_Invoice_DropBox(inStartDate := ('01.01.2024 01:00:20')::TDateTime , inSession := '5');