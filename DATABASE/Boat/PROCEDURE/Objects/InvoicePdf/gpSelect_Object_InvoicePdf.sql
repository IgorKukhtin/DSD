-- Function: gpSelect_Object_InvoicePdf(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InvoicePdf (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InvoicePdf(
    IN inMovementId         Integer,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar
             , DocTagId Integer, DocTagName TVarChar
             , Comment TVarChar
             , DocumentData TBlob
             , InvNumber_invoice TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MovmentItemCondition());

   RETURN QUERY
     WITH tmpProduct AS (SELECT MovementItem_OrderClient.ObjectId AS ProductId
                              , Movement_Invoice.Id               AS MovementId
                              , zfConvert_StringToNumber (Movement_Invoice.InvNumber) ::Integer AS InvNumber
                         FROM Movement AS Movement_Invoice
                              LEFT JOIN Movement AS Movement_OrderClient
                                                 ON Movement_OrderClient.Id       = Movement_Invoice.ParentId
                                                AND Movement_OrderClient.StatusId <> zc_Enum_Status_Erased()
                                                AND Movement_OrderClient.DescId   = zc_Movement_OrderClient()
                              LEFT JOIN MovementItem AS MovementItem_OrderClient
                                                     ON MovementItem_OrderClient.MovementId  = Movement_OrderClient.Id
                                                    AND MovementItem_OrderClient.DescId      = zc_MI_Master()
                                                    AND MovementItem_OrderClient.isErased    = FALSE
                         WHERE Movement_Invoice.Id       = inMovementId
                           AND Movement_Invoice.StatusId <> zc_Enum_Status_Erased()
                           AND Movement_Invoice.DescId   = zc_Movement_Invoice()
                        )
     SELECT
            Object_InvoicePdf.Id        AS Id
          , Object_InvoicePdf.ValueData AS FileName
          , Object_DocTag.Id                AS DocTagId
          , Object_DocTag.ValueData         AS DocTagName
          , ObjectString_Comment.ValueData  AS Comment
          , ObjectBlob_Data.ValueData       AS DocumentData 
          , tmpProduct.InvNumber ::TVarChar AS InvNumber_invoice
     FROM Object AS Object_InvoicePdf
          JOIN ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                           ON ObjectFloat_InvoicePdf_MovmentId.ObjectId = Object_InvoicePdf.Id
                          AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId()
                         -- AND ObjectFloat_InvoicePdf_MovmentId.ValueData = inMovementId
          JOIN tmpProduct ON tmpProduct.MovementId = ObjectFloat_InvoicePdf_MovmentId.ValueData

          LEFT JOIN ObjectLink AS ObjectLink_InvoicePdf_DocTag
                               ON ObjectLink_InvoicePdf_DocTag.ObjectId = Object_InvoicePdf.Id
                              AND ObjectLink_InvoicePdf_DocTag.DescId = zc_ObjectLink_InvoicePdf_DocTag()
          LEFT JOIN Object AS Object_DocTag ON Object_DocTag.Id = ObjectLink_InvoicePdf_DocTag.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_InvoicePdf.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_InvoicePdf_Comment()

          LEFT JOIN ObjectBlob AS ObjectBlob_Data
                               ON ObjectBlob_Data.ObjectId = Object_InvoicePdf.Id
                              AND ObjectBlob_Data.DescId = zc_ObjectBlob_InvoicePdf_Data()

     WHERE Object_InvoicePdf.DescId = zc_Object_InvoicePdf()

    UNION ALL
     SELECT
            Object_ProductDocument.Id        AS Id
          , Object_ProductDocument.ValueData AS FileName
          , Object_DocTag.Id                 AS DocTagId
          , Object_DocTag.ValueData          AS DocTagName
          , ObjectString_Comment.ValueData   AS Comment
          , ObjectBlob_Data.ValueData        AS DocumentData
          , '' ::TVarChar                    AS InvNumber_invoice
     FROM Object AS Object_ProductDocument
          JOIN ObjectLink AS ObjectLink_ProductDocument_Product
                          ON ObjectLink_ProductDocument_Product.ObjectId = Object_ProductDocument.Id
                         AND ObjectLink_ProductDocument_Product.DescId   = zc_ObjectLink_ProductDocument_Product()
                         AND ObjectLink_ProductDocument_Product.ChildObjectId IN (SELECT DISTINCT tmpProduct.ProductId FROM tmpProduct)

          LEFT JOIN ObjectLink AS ObjectLink_DocTag
                               ON ObjectLink_DocTag.ObjectId = Object_ProductDocument.Id
                              AND ObjectLink_DocTag.DescId = zc_ObjectLink_ProductDocument_DocTag()
          LEFT JOIN Object AS Object_DocTag ON Object_DocTag.Id = ObjectLink_DocTag.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProductDocument.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProductDocument_Comment()

          LEFT JOIN ObjectBlob AS ObjectBlob_Data
                               ON ObjectBlob_Data.ObjectId = Object_ProductDocument.Id
                              AND ObjectBlob_Data.DescId = zc_ObjectBlob_ProductDocument_Data()
     WHERE Object_ProductDocument.DescId = zc_Object_ProductDocument()
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InvoicePdf (1808,'2'::TVarChar)