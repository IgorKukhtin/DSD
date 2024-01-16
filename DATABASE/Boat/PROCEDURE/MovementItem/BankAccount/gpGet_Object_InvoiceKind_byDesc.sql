-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Object_InvoiceKind_byDesc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InvoiceKind_byDesc(
    IN inInvoiceKindDesc   TVarChar  ,--
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (InvoiceKindId Integer, InvoiceKindName  TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

  
     RETURN QUERY
         SELECT Object_InvoiceKind.Id        AS InvoiceKindId
              , Object_InvoiceKind.ValueData AS InvoiceKindName
         FROM  Object AS Object_InvoiceKind
         WHERE Object_InvoiceKind.Id = CASE WHEN inInvoiceKindDesc ILIKE 'zc_Enum_InvoiceKind_PrePay'   THEN zc_Enum_InvoiceKind_PrePay()
                                            WHEN inInvoiceKindDesc ILIKE 'zc_Enum_InvoiceKind_Pay'      THEN zc_Enum_InvoiceKind_Pay()
                                            WHEN inInvoiceKindDesc ILIKE 'zc_Enum_InvoiceKind_Proforma' THEN zc_Enum_InvoiceKind_Proforma()
                                            WHEN inInvoiceKindDesc ILIKE 'zc_Enum_InvoiceKind_Service'  THEN zc_Enum_InvoiceKind_Service()
                                            ELSE 0
                                       END
         ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_InvoiceKind_byDesc (inInvoiceKindDesc:= 'zc_Enum_InvoiceKind_PrePay', inSession:= zfCalc_UserAdmin());