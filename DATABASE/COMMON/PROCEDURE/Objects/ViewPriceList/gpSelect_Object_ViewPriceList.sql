-- Function: gpSelect_Object_ViewPriceList()

DROP FUNCTION IF EXISTS gpSelect_Object_ViewPriceList(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ViewPriceList(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ViewPriceList(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PriceListId Integer, PriceListCode Integer, PriceListName TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , BranchName_Personal TVarChar
             , UnitName_Personal TVarChar
             , PositionName_Personal TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ViewPriceList());
     vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
      WITH
          tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.PositionId
                               , lfSelect.BranchId
                               , lfSelect.UnitId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )

      SELECT Object_ViewPriceList.Id      AS Id
           , Object_PriceList.Id          AS PriceListId
           , Object_PriceList.ObjectCode  AS PriceListCode
           , Object_PriceList.ValueData   AS PriceListName
           , Object_Member.Id             AS MemberId
           , Object_Member.ObjectCode     AS MemberCode
           , Object_Member.ValueData      AS MemberName 

           , Object_Branch.ValueData         AS BranchName_Personal
           , Object_Unit.ValueData           AS UnitName_Personal
           , Object_Position.ValueData       AS PositionName_Personal
                   
           , ObjectString_Comment.ValueData  AS Comment
           , Object_ViewPriceList.isErased AS isErased
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

           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
           LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
           LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id   = tmpPersonal.UnitId
            
   WHERE Object_ViewPriceList.DescId = zc_Object_ViewPriceList()
     AND (Object_ViewPriceList.isErased = inIsShowAll OR inIsShowAll = TRUE)
   ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.24         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ViewPriceList (TRUE, '2')
