-- Function: gpSelect_Object_PriceList (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inShowAll        Boolean,
    IN inSession        TVarChar         -- сессия пользователя
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
               , PriceWithVAT Boolean, VATPercent TFloat
               , CurrencyId Integer, CurrencyName TVarChar
               , isIrna Boolean
               , isUser Boolean
               , isErased Boolean
                )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbNotUser Boolean; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- права пользователя - Прайс-лист - просмотр с ограничениями
     vbNotUser:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND RoleId = 10575455);


     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
          , tmpViewPriceList AS (SELECT DISTINCT COALESCE (Object_ViewPriceList_View.PriceListId, 0) AS PriceListId FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId)
          , tmpViewPriceList_isALL AS (SELECT DISTINCT 0 AS PriceListId FROM tmpViewPriceList WHERE tmpViewPriceList.PriceListId = 0)
       SELECT
             Object_PriceList.Id                  AS Id
           , Object_PriceList.ObjectCode          AS Code
           , Object_PriceList.ValueData           AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData     AS VATPercent
           , Object_Currency.Id                   AS CurrencyId
           , Object_Currency.ValueData            AS CurrencyName
           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna
           , COALESCE (ObjectBoolean_User.ValueData, FALSE)         :: Boolean AS isUser
           , Object_PriceList.isErased            AS isErased
       FROM Object AS Object_PriceList
            JOIN tmpIsErased on tmpIsErased.isErased= Object_PriceList.isErased

            LEFT JOIN tmpViewPriceList ON tmpViewPriceList.PriceListId = Object_PriceList.Id
            LEFT JOIN tmpViewPriceList_isALL ON 1=1

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                    ON ObjectBoolean_Guide_Irna.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_User
                                    ON ObjectBoolean_User.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_User.DescId = zc_ObjectBoolean_PriceList_User()

            LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                  ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                 AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
            LEFT JOIN ObjectLink AS ObjectLink_Currency
                                 ON ObjectLink_Currency.ObjectId = Object_PriceList.Id
                                AND ObjectLink_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId
       WHERE Object_PriceList.DescId = zc_Object_PriceList()
         AND (vbNotUser = FALSE OR COALESCE (ObjectBoolean_User.ValueData, FALSE) = FALSE OR tmpViewPriceList.PriceListId > 0)
         AND (tmpViewPriceList.PriceListId > 0 OR vbNotUser = FALSE OR tmpViewPriceList_isALL.PriceListId = 0)

      UNION ALL
       SELECT
             0 AS Id
           , NULL :: Integer AS Code
           , 'УДАЛИТЬ' :: TVarChar AS Name
           , FALSE AS PriceWithVAT
           , NULL :: TFloat AS VATPercent
           , 0 AS CurrencyId
           , '' :: TVarChar AS CurrencyName
           , FALSE :: Boolean AS isIrna
           , FALSE :: Boolean AS isUser
           , TRUE  :: Boolean AS isErased
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_PriceList (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.05.22         *
 23.02.15         * add inShowAll
 16.11.14                                        * add Currency...
 07.09.13                                        * add PriceWithVAT and VATPercent
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceList ( false , '5')
