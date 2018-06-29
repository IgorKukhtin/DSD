-- Function: gpSelect_ObjectGUID(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ObjectGUID (TDateTime, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectGUID (TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectGUID (TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectGUID(
    IN inStartDate   TDateTime,     --
    IN inDataBaseId  Integer,       --
    IN inDescCode    TVarChar,      -- если надо только один справочник
    IN inIsProtocol  Boolean,       -- данные зависят от inStartDate или все записи
    IN inIsGUID_null Boolean,       -- с пустым GUID, т.к. сначала надо его заполнить
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbDescId          Integer;
    DECLARE Cur_Object        refcursor;
    DECLARE Cur_ObjectString  refcursor;
    DECLARE Cur_ObjectFloat   refcursor;
    DECLARE Cur_ObjectDate    refcursor;
    DECLARE Cur_ObjectBoolean refcursor;
    DECLARE Cur_ObjectLink    refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- 
     vbDescId:= COALESCE((SELECT ObjectDesc.Id FROM ObjectDesc WHERE LOWER (ObjectDesc.Code) = LOWER (inDescCode)), 0);


     -- таблица - Результат
     CREATE TEMP TABLE _tmpObject (ObjectId Integer, DescId Integer, UserId Integer, OperDate_last TDateTime) ON COMMIT DROP;
     -- Результат
     INSERT INTO _tmpObject (ObjectId, DescId, UserId, OperDate_last)
        WITH tmpDesc AS (SELECT ObjectDesc.Id AS DescId
                         FROM ObjectDesc
                         WHERE (ObjectDesc.Id = vbDescId OR vbDescId = 0)
                           AND (ObjectDesc.Id IN (zc_Object_Role()
                                                , zc_Object_User()
                                                , zc_Object_PaidKind()
                                                , zc_Object_Member()
                                                , zc_Object_Personal()
                                                , zc_Object_Goods()
                                                , zc_Object_GoodsByGoodsKind()
                                                , zc_Object_GoodsProperty()
                                                , zc_Object_GoodsPropertyValue()
                                                , zc_Object_GoodsKind()
                                                , zc_Object_PriceListItem()
                                                , zc_Object_Box()
                                                , zc_Object_Unit()
                                                , zc_Object_Route()
                                                , zc_Object_Retail()
                                                , zc_Object_Juridical()
                                                , zc_Object_Contract()
                                                , zc_Object_Partner()
                                                , zc_Object_Bank()
                                                , zc_Object_BankAccount()
                                                , zc_Object_Currency()
                                                , zc_Object_BankAccountContract()
                                                , zc_Object_CorrespondentAccountIntermediaryBank()
                                                 )
                             OR vbDescId > 0)
                        )
           , tmpProtocol AS (SELECT Object.DescId
                                  , ObjectProtocol.*
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                             FROM ObjectProtocol
                                  JOIN Object ON Object.Id = ObjectProtocol.ObjectId
                                  JOIN tmpDesc ON tmpDesc.DescId = Object.DescId
                             WHERE inStartDate             > zc_DateStart()
                               AND inIsProtocol            = TRUE
                               AND ObjectProtocol.OperDate >= inStartDate - INTERVAL '1 HOUR' -- на всякий случай, что отловить ВСЕ изменения
                            )
          , tmpList_0 AS (SELECT tmpProtocol.DescId, tmpProtocol.ObjectId
                          FROM tmpProtocol
                          WHERE tmpProtocol.Ord = 1 -- !!!последний!!!
                         UNION
                          SELECT Object.DescId, Object.Id AS ObjectId
                          FROM tmpDesc
                               INNER JOIN Object ON Object.DescId = tmpDesc.DescId
                          WHERE inIsProtocol = FALSE
                         )
          , tmpList_1 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_0
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_0.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                          WHERE vbDescId = 0
                         )
          , tmpList_2 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_1
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_1.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                          WHERE vbDescId = 0
                         )
          , tmpList_3 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_2
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_2.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                          WHERE vbDescId = 0
                         )
          , tmpList_4 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_3
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_3.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                          WHERE vbDescId = 0
                         )
        , tmpList_all AS (SELECT tmpList_0.DescId, tmpList_0.ObjectId FROM tmpList_0
                         UNION
                          SELECT tmpList_1.DescId, tmpList_1.ObjectId FROM tmpList_1
                         UNION
                          SELECT tmpList_2.DescId, tmpList_2.ObjectId FROM tmpList_2
                         UNION
                          SELECT tmpList_3.DescId, tmpList_3.ObjectId FROM tmpList_3
                         UNION
                          SELECT tmpList_4.DescId, tmpList_4.ObjectId FROM tmpList_4
                         )
     -- Результат
     SELECT tmpList_all.ObjectId, tmpList_all.DescId, tmpProtocol.UserId, tmpProtocol.OperDate AS OperDate_last
     FROM tmpList_all
          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = tmpList_all.ObjectId AND tmpProtocol.Ord = 1 -- !!!последний!!!
         ;

     -- Результат

     -- 1. Object
     OPEN Cur_Object FOR
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
     SELECT
          _tmpObject.OperDate_last                  AS OperDate_last
        , Object.Id                                 AS ObjectId
        , Object.DescId                          AS DescId
        -- , _tmpObject.DescId                         AS DescId
        , ObjectDesc.Code           :: VarChar (50) AS DescName
        , ObjectDesc.ItemName       :: VarChar (50) AS ItemName
        , Object.ObjectCode                         AS ObjectCode
        , Object.ValueData                          AS ValueData
        , Object_User.Id                            AS UserId
        , Object_User.ObjectCode                    AS UserCode
        , Object_User.ValueData     :: VarChar (30) AS UserName
        , tmpPersonal.MemberId                      AS MemberId
        , tmpPersonal.MemberName    :: VarChar (30) AS MemberName
        , tmpPersonal.UnitName      :: VarChar (30) AS UnitName
        , tmpPersonal.PositionName  :: VarChar (30) AS PositionName
        , tmpPersonal.BranchName    :: VarChar (30) AS BranchName
        , (Object.Id :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM _tmpObject
          INNER JOIN Object     ON Object.Id     = _tmpObject.ObjectId
          LEFT JOIN  ObjectDesc ON ObjectDesc.Id = Object.DescId

          LEFT JOIN Object AS Object_User ON Object_User.Id = _tmpObject.UserId
          LEFT JOIN tmpPersonal ON tmpPersonal.UserId = _tmpObject.UserId
     -- WHERE 1=0
     ORDER BY Object.Id
    ;
     --
     RETURN NEXT Cur_Object;


     -- 2. ObjectString
     OPEN Cur_ObjectString FOR
     SELECT
          _tmpObject.OperDate_last                  AS OperDate_last
        , _tmpObject.ObjectId                       AS ObjectId
        , ObjectString.DescId                       AS DescId
        , ObjectStringDesc.Code     :: VarChar (50) AS DescName
        , ObjectStringDesc.ItemName :: VarChar (50) AS ItemName

        , ObjectString.ValueData                    AS ValueData
        , (_tmpObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM _tmpObject
          INNER JOIN ObjectString     ON ObjectString.ObjectId = _tmpObject.ObjectId
          LEFT JOIN  ObjectStringDesc ON ObjectStringDesc.Id   = ObjectString.DescId
     -- WHERE 1=0
     ORDER BY _tmpObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectString;


     -- 3. ObjectFloat
     OPEN Cur_ObjectFloat FOR
     SELECT
          _tmpObject.OperDate_last                  AS OperDate_last
        , _tmpObject.ObjectId                       AS ObjectId
        , ObjectFloat.DescId                        AS DescId
        , ObjectFloatDesc.Code      :: VarChar (50) AS DescName
        , ObjectFloatDesc.ItemName  :: VarChar (50) AS ItemName
        , ObjectFloat.ValueData     :: TFloat       AS ValueData
        , (_tmpObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM _tmpObject
          INNER JOIN ObjectFloat     ON ObjectFloat.ObjectId = _tmpObject.ObjectId
          LEFT JOIN  ObjectFloatDesc ON ObjectFloatDesc.Id   = ObjectFloat.DescId
     -- WHERE 1=0
     -- WHERE _tmpObject.DescId = zc_Object_Goods()
     ORDER BY _tmpObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectFloat;


     -- 4. ObjectDate
     OPEN Cur_ObjectDate FOR
     SELECT
          _tmpObject.OperDate_last                  AS OperDate_last
        , _tmpObject.ObjectId                       AS ObjectId
        , ObjectDate.DescId                         AS DescId
        , ObjectDateDesc.Code       :: VarChar (50) AS DescName
        , ObjectDateDesc.ItemName   :: VarChar (50) AS ItemName
        , ObjectDate.ValueData                      AS ValueData
        , (_tmpObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM _tmpObject
          INNER JOIN ObjectDate     ON ObjectDate.ObjectId = _tmpObject.ObjectId
          LEFT JOIN  ObjectDateDesc ON ObjectDateDesc.Id   = ObjectDate.DescId
     -- WHERE 1=0
     ORDER BY _tmpObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectDate;


     -- 5. ObjectBoolean
     OPEN Cur_ObjectBoolean FOR
     SELECT
          _tmpObject.OperDate_last                  AS OperDate_last
        , _tmpObject.ObjectId                       AS ObjectId
        , ObjectBoolean.DescId                      AS DescId
        , ObjectBooleanDesc.Code    :: VarChar (50) AS DescName
        , ObjectBooleanDesc.ItemName:: VarChar (50) AS ItemName
        , ObjectBoolean.ValueData                   AS ValueData
        , (_tmpObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID

     FROM _tmpObject
          INNER JOIN ObjectBoolean     ON ObjectBoolean.ObjectId = _tmpObject.ObjectId
          LEFT JOIN  ObjectBooleanDesc ON ObjectBooleanDesc.Id   = ObjectBoolean.DescId
     -- WHERE 1=0
     ORDER BY _tmpObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectBoolean;


     OPEN Cur_ObjectLink FOR
     -- 5. ObjectLink
     SELECT
          _tmpObject.OperDate_last                  AS OperDate_last
        , _tmpObject.ObjectId                       AS ObjectId
        , ObjectLink.DescId                         AS DescId
        , ObjectLinkDesc.Code       :: VarChar (50) AS DescName
        , ObjectLinkDesc.ItemName   :: VarChar (50) AS ItemName
        , ObjectLink.ChildObjectId  :: Integer      AS ChildObjectId
        , (_tmpObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar) :: TVarChar AS GUID
     FROM _tmpObject
          INNER JOIN ObjectLink     ON ObjectLink.ObjectId = _tmpObject.ObjectId
          LEFT JOIN  ObjectLinkDesc ON ObjectLinkDesc.Id   = ObjectLink.DescId
     -- WHERE 1=0
     ORDER BY _tmpObject.ObjectId
    ;
     --
     RETURN NEXT Cur_ObjectLink;



END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectGUID  (inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDataBaseId:= 1, inDescCode:= '', inIsProtocol:= FALSE, inIsGUID_null:= FALSE, inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
-- SELECT * FROM gpSelect_ObjectGUID  (inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDataBaseId:= 1, inDescCode:= '', inIsProtocol:= TRUE,  inIsGUID_null:= FALSE, inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
