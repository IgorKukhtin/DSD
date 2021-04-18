-- Function: gpGet_Object_MemberPriceList()

DROP FUNCTION IF EXISTS gpGet_Object_MemberPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberPriceList(
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberPriceList());

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
          SELECT Object_MemberPriceList.Id         AS Id
               , Object_PriceList.Id               AS PriceListId
               , Object_PriceList.ValueData        AS PriceListName
               , Object_Member.Id                  AS MemberId
               , Object_Member.ValueData           AS MemberName         
               , ObjectString_Comment.ValueData    AS Comment
          FROM Object AS Object_MemberPriceList
               LEFT JOIN ObjectString AS ObjectString_Comment
                                      ON ObjectString_Comment.ObjectId = Object_MemberPriceList.Id
                                     AND ObjectString_Comment.DescId  = zc_ObjectString_MemberPriceList_Comment()
    
               LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_PriceList
                                    ON ObjectLink_MemberPriceList_PriceList.ObjectId = Object_MemberPriceList.Id
                                   AND ObjectLink_MemberPriceList_PriceList.DescId = zc_ObjectLink_MemberPriceList_PriceList()
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_MemberPriceList_PriceList.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_Member
                                    ON ObjectLink_MemberPriceList_Member.ObjectId = Object_MemberPriceList.Id
                                   AND ObjectLink_MemberPriceList_Member.DescId = zc_ObjectLink_MemberPriceList_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberPriceList_Member.ChildObjectId
    
           WHERE Object_MemberPriceList.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.21         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberPriceList (0, '2')
