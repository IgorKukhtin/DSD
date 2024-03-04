-- Function: gpSelect_Movement_Invoice_DropBox()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_DropBox (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_DropBox(
    IN inStartDate     TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName           TVarChar
             , MovementId         Integer
             , isPostedToDropBox  Boolean
             , FilePath           TVarChar
             , ReceiptNumber      TVarChar
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
          tmpInvoicePdf AS (SELECT Movement_Invoice.Id                                         AS  MovementId
                                 , Movement_Invoice.InvNumber                                  AS  InvNumber
                                 , COALESCE(MovementBoolean_FilesNotUploaded.ValueData, False) AS isFilesUploaded
                                 , COALESCE(MovementBoolean_PostedToDropBox.ValueData, True)   AS isPostedToDropBox
                                 , Object_InvoicePdf.*
                            FROM Object AS Object_InvoicePdf
                                 INNER JOIN ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                                                        ON ObjectFloat_InvoicePdf_MovmentId.ObjectId = Object_InvoicePdf.Id
                                                       AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId()
                                 INNER JOIN Movement AS Movement_Invoice
                                                     ON Movement_Invoice.Id = ObjectFloat_InvoicePdf_MovmentId.ValueData
                                                    AND Movement_Invoice.DescId   = zc_Movement_Invoice()
                                                    AND Movement_Invoice.StatusId <> zc_Enum_Status_Erased()
                                 LEFT JOIN MovementBoolean AS MovementBoolean_FilesNotUploaded
                                                           ON MovementBoolean_FilesNotUploaded.MovementId = Movement_Invoice.Id
                                                          AND MovementBoolean_FilesNotUploaded.DescId = zc_MovementBoolean_FilesNotUploaded()
                                 LEFT JOIN MovementBoolean AS MovementBoolean_PostedToDropBox
                                                           ON MovementBoolean_PostedToDropBox.MovementId = Movement_Invoice.Id
                                                          AND MovementBoolean_PostedToDropBox.DescId = zc_MovementBoolean_PostedToDropBox()
                            WHERE Object_InvoicePdf.DescId = zc_Object_InvoicePdf()
                              AND COALESCE (MovementBoolean_FilesNotUploaded.ValueData, FALSE) = FALSE)

    SELECT
            Object_InvoicePdf.Id                 AS Id
          , Object_InvoicePdf.ValueData          AS FileName
          , Object_InvoicePdf.MovementId         AS MovementId
          , Object_InvoicePdf.isPostedToDropBox  AS isPostedToDropBox
          , CASE WHEN COALESCE(MovementFloat_Amount.ValueData, 0) < 0 
                 THEN vbKredit
                 ELSE vbDebet END::TVarChar   AS FilePath
          , COALESCE(MovementString_ReceiptNumber.ValueData, Object_InvoicePdf.InvNumber)::TVarChar  AS ReceiptNumber 
     FROM tmpInvoicePdf AS Object_InvoicePdf
     
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
       AND (Object_InvoicePdf.isPostedToDropBox = TRUE
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