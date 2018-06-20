-- Function: gpSelect_ObjectGUID(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ObjectGUID (TDateTime, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectGUID (TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectGUID(
    IN inStartDate   TDateTime,     --
    IN inDataBaseId  Integer,       -- 
    IN inDescId      Integer,       -- если надо только один справочник
    IN inIsProtocol  Boolean,       -- данные зависят от inStartDate или все записи
    IN inIsGUID_null Boolean,       -- с пустым GUID, т.к. сначала надо его заполнить
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last TDateTime
             , DescName      TVarChar
             , DescId        Integer
             , Id            Integer
             , Code          Integer
             , Name          TVarChar
             , UserId        Integer
             , UserCode      Integer
             , UserName      TVarChar
             , MemberId      Integer
             , MemberName    TVarChar
             , UnitName      TVarChar
             , PositionName  TVarChar
             , BranchName    TVarChar
             , GUID          TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат
     RETURN QUERY
        WITH tmpPersonal AS (SELECT ObjectLink_User_Member.ObjectId AS UserId
                                  , lfSelect.MemberId               AS MemberId
                                  , Object_Member.ObjectCode        AS MemberCode
                                  , Object_Member.ValueData         AS MemberName
                                  , lfSelect.UnitId                 AS UnitId
                                  , Object_Unit.ObjectCode          AS UnitCode
                                  , Object_Unit.ValueData           AS UnitName
                                  , lfSelect.PositionId             AS PositionId
                                  , Object_Position.ObjectCode      AS PositionCode
                                  , Object_Position.ValueData       AS PositionName
                                  , Object_Branch.Id                AS BranchId
                                  , Object_Branch.ObjectCode        AS BranchCode
                                  , Object_Branch.ValueData         AS BranchName
                             FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = lfSelect.UnitId
                                  LEFT JOIN Object AS Object_Position ON Object_Position.Id = lfSelect.PositionId
                                  LEFT JOIN Object AS Object_Member ON Object_Member.Id = lfSelect.MemberId
                                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                       ON ObjectLink_User_Member.ChildObjectId = lfSelect.MemberId
                                                      AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                       ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                                      AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                                  LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                            )
           , tmpDesc AS (SELECT ObjectDesc.Id AS DescId
                         FROM ObjectDesc
                         WHERE (ObjectDesc.Id = inDescId OR inDescId = 0)
                           AND ObjectDesc.Id IN (zc_Object_User()
                                               , zc_Object_PaidKind()
                                               , zc_Object_Member()
                                               , zc_Object_Personal()
                                               , zc_Object_Goods()
                                               , zc_Object_GoodsKind()
                                               , zc_Object_Unit()
                                               , zc_Object_Juridical()
                                               , zc_Object_Contract()
                                               , zc_Object_Partner()
                                                )
                        )
           , tmpProtocol AS (SELECT ObjectProtocol.*
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                             FROM ObjectProtocol
                                  JOIN Object ON Object.Id = ObjectProtocol.ObjectId
                                  JOIN tmpDesc ON tmpDesc.DescId = Object.DescId
                             WHERE inStartDate             > zc_DateStart()
                               AND inIsProtocol            = TRUE
                               AND ObjectProtocol.OperDate >= inStartDate - INTERVAL '1 HOUR' -- на всякий случай, что отловить ВСЕ изменения
                            )
          , tmpList_0 AS (SELECT tmpProtocol.ObjectId
                          FROM tmpProtocol
                          WHERE tmpProtocol.Ord = 1 -- !!!последний!!!
                         UNION
                          SELECT Object.Id AS ObjectId
                          FROM tmpDesc
                               INNER JOIN Object ON Object.DescId = tmpDesc.DescId
                          WHERE inIsProtocol = FALSE
                         )
          , tmpList_1 AS (SELECT DISTINCT ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_0
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_0.ObjectId
                         )
          , tmpList_2 AS (SELECT DISTINCT ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_1
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_1.ObjectId
                         )
          , tmpList_3 AS (SELECT DISTINCT ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_2
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_2.ObjectId
                         )
          , tmpList_4 AS (SELECT DISTINCT ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_3
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_3.ObjectId
                         )
        , tmpList_all AS (SELECT tmpList_0.ObjectId FROM tmpList_0
                         UNION
                          SELECT tmpList_1.ObjectId FROM tmpList_1
                         UNION
                          SELECT tmpList_2.ObjectId FROM tmpList_2
                         UNION
                          SELECT tmpList_3.ObjectId FROM tmpList_3
                         UNION
                          SELECT tmpList_4.ObjectId FROM tmpList_4
                         )
     -- Результат
     SELECT
          tmpProtocol.OperDate    AS OperDate_last
        , ObjectDesc.ItemName     AS DescName
        , Object.DescId
        , Object.Id
        , Object.ObjectCode
        , Object.ValueData
        , Object_User.Id          AS UserId
        , Object_User.ObjectCode  AS UserCode
        , Object_User.ValueData   AS UserName
        , tmpPersonal.MemberId
        , tmpPersonal.MemberName
        , tmpPersonal.UnitName
        , tmpPersonal.PositionName
        , tmpPersonal.BranchName
        , (Object.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID
     FROM tmpList_all
          INNER JOIN Object     ON Object.Id     = tmpList_all.ObjectId
          LEFT JOIN  ObjectDesc ON ObjectDesc.Id = Object.DescId

          LEFT JOIN tmpProtocol           ON tmpProtocol.ObjectId = tmpList_all.ObjectId
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = tmpProtocol.UserId
    ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectGUID  (inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDataBaseId:= 1, inDescId:= 0, inIsProtocol:= FALSE, inIsGUID_null:= FALSE, inSession:= zfCalc_UserAdmin()) ORDER BY 1
-- SELECT * FROM gpSelect_ObjectGUID  (inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDataBaseId:= 1, inDescId:= 0, inIsProtocol:= TRUE,  inIsGUID_null:= FALSE, inSession:= zfCalc_UserAdmin()) ORDER BY 1
