-- Function: gpGet_Object_BankAccountPdf_photo()

DROP FUNCTION IF EXISTS gpGet_Object_BankAccountPdf_photo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccountPdf_photo(
    IN inMovmentItemId      Integer,       -- 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Image1 TBlob
              )
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPriceListName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MovmentItemId());

       RETURN QUERY
       WITH tmpPhoto AS (SELECT ObjectFloat_BankAccountPdf_MovmentItemId.ValueData :: Integer AS MovmentItemId
                              , Object_BankAccountPdf.Id                                      AS PhotoId
                              , ROW_NUMBER() OVER (PARTITION BY ObjectFloat_BankAccountPdf_MovmentItemId.ValueData ORDER BY Object_BankAccountPdf.Id) AS Ord
                         FROM Object AS Object_BankAccountPdf
                              JOIN ObjectFloat AS ObjectFloat_BankAccountPdf_MovmentItemId
                                               ON ObjectFloat_BankAccountPdf_MovmentItemId.ObjectId = Object_BankAccountPdf.Id
                                              AND ObjectFloat_BankAccountPdf_MovmentItemId.DescId   = zc_ObjectFloat_BankAccountPdf_MovmentItemId()
                                              AND ObjectFloat_BankAccountPdf_MovmentItemId.ValueData = inMovmentItemId
                          WHERE Object_BankAccountPdf.DescId   = zc_Object_BankAccountPdf()
                            AND Object_BankAccountPdf.isErased = FALSE
                        )

       SELECT tmpPhoto.MovmentItemId                   AS Id
            , ObjectBlob_BankAccountPdf_Data.ValueData AS Image1
           
      FROM tmpPhoto
            LEFT JOIN ObjectBLOB AS ObjectBlob_BankAccountPdf_Data
                                 ON ObjectBlob_BankAccountPdf_Data.ObjectId = tmpPhoto.PhotoId

       ;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.24         *
*/

-- тест
--
 SELECT * FROM gpGet_Object_BankAccountPdf_photo (1, '2')
