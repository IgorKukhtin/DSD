-- Function: gpSelect_Object_BankAccountPdf(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccountPdf (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_BankAccountPdf (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccountPdf(
    IN inMovmentId          Integer,
    IN inMovmentItemId      Integer,
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
                              , MovementItem.Id                   AS MovementItemId
                              , zfConvert_StringToNumber (Movement_Invoice.InvNumber) ::Integer AS InvNumber
                         FROM MovementItem
                              JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                                           AND Movement.DescId   = zc_Movement_BankAccount()
                              INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                              INNER JOIN Movement AS Movement_Invoice
                                                  ON Movement_Invoice.Id       = MIFloat_MovementId.ValueData :: Integer
                                                 AND Movement_Invoice.StatusId <> zc_Enum_Status_Erased()
                                                 AND Movement_Invoice.DescId   = zc_Movement_Invoice()
                              INNER JOIN Movement AS Movement_OrderClient
                                                  ON Movement_OrderClient.Id       = Movement_Invoice.ParentId
                                                 AND Movement_OrderClient.StatusId <> zc_Enum_Status_Erased()
                                                 AND Movement_OrderClient.DescId   = zc_Movement_OrderClient()
                              INNER JOIN MovementItem AS MovementItem_OrderClient
                                                      ON MovementItem_OrderClient.MovementId  = Movement_OrderClient.Id
                                                     AND MovementItem_OrderClient.DescId      = zc_MI_Master()
                                                     AND MovementItem_OrderClient.isErased    = FALSE

                         WHERE MovementItem.MovementId = inMovmentId 
                           AND (MovementItem.Id = inMovmentItemId OR inMovmentItemId = 0)
                           AND MovementItem.DescId   = zc_MI_Child()
                           AND MovementItem.isErased = FALSE
                         --LIMIT 1
                        )
     SELECT
            Object_BankAccountPdf.Id        AS Id
          , Object_BankAccountPdf.ValueData AS FileName
          , Object_DocTag.Id                AS DocTagId
          , Object_DocTag.ValueData         AS DocTagName
          , ObjectString_Comment.ValueData  AS Comment
          , ObjectBlob_Data.ValueData       AS DocumentData 
          , tmpProduct.InvNumber ::TVarChar AS InvNumber_invoice
     FROM Object AS Object_BankAccountPdf
          JOIN ObjectFloat AS ObjectFloat_BankAccountPdf_MovmentItemId
                           ON ObjectFloat_BankAccountPdf_MovmentItemId.ObjectId = Object_BankAccountPdf.Id
                          AND ObjectFloat_BankAccountPdf_MovmentItemId.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId()
                          --AND ObjectFloat_BankAccountPdf_MovmentItemId.ValueData IN (SELECT DISTINCT tmpProduct.MovementItemId FROM tmpProduct)
          JOIN tmpProduct ON tmpProduct.MovementItemId = ObjectFloat_BankAccountPdf_MovmentItemId.ValueData

          LEFT JOIN ObjectLink AS ObjectLink_BankAccountPdf_DocTag
                               ON ObjectLink_BankAccountPdf_DocTag.ObjectId = Object_BankAccountPdf.Id
                              AND ObjectLink_BankAccountPdf_DocTag.DescId = zc_ObjectLink_BankAccountPdf_DocTag()
          LEFT JOIN Object AS Object_DocTag ON Object_DocTag.Id = ObjectLink_BankAccountPdf_DocTag.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_BankAccountPdf.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_BankAccountPdf_Comment()

          LEFT JOIN ObjectBlob AS ObjectBlob_Data
                               ON ObjectBlob_Data.ObjectId = Object_BankAccountPdf.Id
                              AND ObjectBlob_Data.DescId = zc_ObjectBlob_BankAccountPdf_Data()

     WHERE Object_BankAccountPdf.DescId = zc_Object_BankAccountPdf()

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
-- SELECT * FROM gpSelect_Object_BankAccountPdf (1804, 0,'2')
