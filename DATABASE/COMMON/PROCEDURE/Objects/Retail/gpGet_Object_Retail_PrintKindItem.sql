-- Function: gpGet_Object_Retail_PrintKindItem

DROP FUNCTION IF EXISTS gpGet_Object_Retail_PrintKindItem (integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Retail_PrintKindItem(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , OperDateOrder Boolean
             , GLNCode TVarChar, GLNCodeCorporate TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , isMovement boolean, isAccount boolean, isTransport boolean
             , isQuality boolean, isPack boolean, isSpec boolean, isTax boolean   
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Retail()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS OperDateOrder
           , CAST ('' as TVarChar)  AS GLNCode
           , CAST ('' as TVarChar)  AS GLNCodeCorporate
           , CAST (0 as Integer)    AS GoodsPropertyId 
           , CAST ('' as TVarChar)  AS GoodsPropertyName 
       
           , CAST (NULL AS Boolean) AS isMovement
           , CAST (NULL AS Boolean) AS isAccount
           , CAST (NULL AS Boolean) AS isTransport
           , CAST (NULL AS Boolean) AS isQuality
           , CAST (NULL AS Boolean) AS isPack
           , CAST (NULL AS Boolean) AS isSpec
           , CAST (NULL AS Boolean) AS isTax

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       WITH tmpPrintKindItem AS( SELECT tmp.Id
                                      , tmp.isMovement, tmp.isAccount, tmp.isTransport
                                      , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax
                                 FROM lpSelect_Object_PrintKindItem(inSession) AS tmp
                                )
       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , COALESCE (ObjectBoolean_OperDateOrder.ValueData, CAST (False AS Boolean)) AS OperDateOrder
 
           , GLNCode.ValueData               AS GLNCode
           , GLNCodeCorporate.ValueData      AS GLNCodeCorporate
           , Object_GoodsProperty.Id         AS GoodsPropertyId
           , Object_GoodsProperty.ValueData  AS GoodsPropertyName 
           
           , COALESCE (tmpPrintKindItem.isMovement, CAST (False AS Boolean))   AS isMovement
           , COALESCE (tmpPrintKindItem.isAccount, CAST (False AS Boolean))    AS isAccount
           , COALESCE (tmpPrintKindItem.isTransport, CAST (False AS Boolean))  AS isTransport
           , COALESCE (tmpPrintKindItem.isQuality, CAST (False AS Boolean))    AS isQuality
           , COALESCE (tmpPrintKindItem.isPack, CAST (False AS Boolean))       AS isPack
           , COALESCE (tmpPrintKindItem.isSpec, CAST (False AS Boolean))       AS isSpec
           , COALESCE (tmpPrintKindItem.isTax, CAST (False AS Boolean))        AS isTax
          
           , Object_Retail.isErased   AS isErased
       FROM OBJECT AS Object_Retail
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object_Retail.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
        LEFT JOIN ObjectString AS GLNCodeCorporate
                               ON GLNCodeCorporate.ObjectId = Object_Retail.Id 
                              AND GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                 ON ObjectBoolean_OperDateOrder.ObjectId = Object_Retail.Id 
                                AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder() 
    
        LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                             ON ObjectLink_Retail_GoodsProperty.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Retail_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                             ON ObjectLink_Retail_PrintKindItem.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
	LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id =  ObjectLink_Retail_PrintKindItem.ChildObjectId

                          
       WHERE Object_Retail.Id = inId;
   END IF; 
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.15         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Retail_PrintKindItem (0, zfCalc_UserAdmin())
