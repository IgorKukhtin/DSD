-- Function: gpGet_Object_ViewPriceList()

DROP FUNCTION IF EXISTS gpGet_Object_ViewPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ViewPriceList(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PriceListId Integer, PriceListName TVarChar
             , MemberId Integer, MemberName TVarChar
             , Comment TVarChar)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ViewPriceList());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
          SELECT CAST (0 AS Integer)    AS Id
               , CAST (0 AS Integer)    AS PriceListId
               , CAST ('' AS TVarChar)  AS PriceListName
               , CAST (0 AS Integer)    AS MemberId
               , CAST ('' AS TVarChar)  AS MemberName
               , CAST ('' AS TVarChar)  AS Comment;
   ELSE
       RETURN QUERY
          SELECT Object_ViewPriceList.Id         AS Id
               , Object_PriceList.Id               AS PriceListId
               , Object_PriceList.ValueData        AS PriceListName
               , Object_Member.Id                  AS MemberId
               , Object_Member.ValueData           AS MemberName         
               , ObjectString_Comment.ValueData    AS Comment
          FROM Object AS Object_ViewPriceList
               LEFT JOIN ObjectString AS ObjectString_Comment
                                      ON ObjectString_Comment.ObjectId = Object_ViewPriceList.Id
                                     AND ObjectString_Comment.DescId  = zc_ObjectString_ViewPriceList_Comment()
    
               LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_PriceList
                                    ON ObjectLink_ViewPriceList_PriceList.ObjectId = Object_ViewPriceList.Id
                                   AND ObjectLink_ViewPriceList_PriceList.DescId = zc_ObjectLink_ViewPriceList_PriceList()
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_ViewPriceList_PriceList.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_Member
                                    ON ObjectLink_ViewPriceList_Member.ObjectId = Object_ViewPriceList.Id
                                   AND ObjectLink_ViewPriceList_Member.DescId = zc_ObjectLink_ViewPriceList_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_ViewPriceList_Member.ChildObjectId
    
           WHERE Object_ViewPriceList.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.24         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_ViewPriceList (0, '2')
