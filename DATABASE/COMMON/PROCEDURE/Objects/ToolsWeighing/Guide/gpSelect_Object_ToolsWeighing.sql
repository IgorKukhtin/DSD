-- Function: gpSelect_Object_ToolsWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               NameFull TVarChar, NameUser TVarChar, ValueData TVarChar,
               ParentId Integer, ParentName TVarChar,
               isErased boolean, isLeaf boolean,
               ToolsWeighingPlaceName TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code
           , Object_ToolsWeighing_View.Name
           , Object_ToolsWeighing_View.NameFull

           , CASE WHEN Object_ToolsWeighing_View.isLeaf = FALSE AND COALESCE (Object_ToolsWeighing_View.ParentId, 0) = 0
                       THEN (SELECT gpSelect.Name FROM gpSelect_Object_ToolsWeighing_Tree (inSession) AS gpSelect WHERE gpSelect.Id = Object_ToolsWeighing_View.Id)
                  ELSE Object_ToolsWeighing_View.NameUser
             END :: TVarChar AS NameUser

           , Object_ToolsWeighing_View.ValueData
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.ParentName
           , Object_ToolsWeighing_View.isErased
           , Object_ToolsWeighing_View.isLeaf
           , COALESCE (Object_InfoMoney_View.InfoMoneyName_all, COALESCE (Object_ToolsWeighingPlace.ValueData, MovementDesc.ItemName)) :: TVarChar as ToolsWeighingPlaceName
       FROM Object_ToolsWeighing_View
            LEFT JOIN Object AS Object_ToolsWeighingPlace ON Object_ToolsWeighingPlace.Id = CASE WHEN CHAR_LENGTH (Object_ToolsWeighing_View.ValueData) > 0
                                                                                                  AND POSITION ('Id' IN Object_ToolsWeighing_View.Name) > 0
                                                                                                  AND POSITION ('DescId' IN Object_ToolsWeighing_View.Name) = 0
                                                                                                 THEN Object_ToolsWeighing_View.ValueData :: Integer ELSE 0
                                                                                            END
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_ToolsWeighingPlace.Id
            LEFT JOIN MovementDesc ON MovementDesc.Id = CASE WHEN CHAR_LENGTH (Object_ToolsWeighing_View.ValueData) > 0
                                                              AND POSITION ('DescId' IN Object_ToolsWeighing_View.Name) > 0
                                                             THEN Object_ToolsWeighing_View.ValueData :: Integer ELSE 0
                                                        END 
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.01.15                                        *
 13.03.14                                                         *
*/

/*
update Object set ValueData = ValueDataNew
from (with a1 as (select * from gpSelect_Object_ToolsWeighing( inSession := '5') as a
                  where nameFull Ilike 'SCALE_2 %'
                 )
         , a2 as (select *, 'Scale_2 ' || SPLIT_PART (namefull, 'Scale_12 ', 2) as nameNew from gpSelect_Object_ToolsWeighing( inSession := '5') as a
                  where nameFull Ilike 'SCALE_12 %'
                 )
      
      select a2.Id, a2.namefull , a2.ValueData
           , case when a1.ValueData = '8411'
                       then '3080691'
                  when a1.ValueData = '428365'
                       then '3080696'
             else a1.ValueData  end as ValueDataNew
      from a2
      join a1 on a1.namefull = a2.nameNew
      ) as tmp
where Object.Id = tmp.Id
*/
-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing (zfCalc_UserAdmin())
