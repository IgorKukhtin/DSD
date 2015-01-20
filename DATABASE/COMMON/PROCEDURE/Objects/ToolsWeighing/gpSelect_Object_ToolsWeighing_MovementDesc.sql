-- Function: gpSelect_Object_ToolsWeighing_MovementDesc()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_Guide (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_MovementDesc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_MovementDesc(
    IN inScaleNum    Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Number         Integer
             , MovementDescId Integer
             , FromId         Integer, FromName     TVarChar
             , ToId           Integer, ToName       TVarChar
             , PaidKindId     Integer, PaidKindName TVarChar
             , ColorGridValue Integer
             , GuideName      TVarChar
             , OrderById      Integer
               )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCount      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

    -- определяется кол-во операций
    vbCount:= (SELECT gpGet_ToolsWeighing_Value ('Scale_'||inScaleNum, 'Movement', '', 'Count', '10', inSession));

    -- временные таблица
    CREATE TEMP TABLE _tmpToolsWeighing (Number         Integer
                                       , MovementDescId Integer
                                       , FromId         TVarChar
                                       , ToId           TVarChar
                                       , PaidKindId     TVarChar
                                       , ColorGridValue Integer
                                       , OrderById        Integer
                                        ) ON COMMIT DROP;
    -- формирование
    INSERT INTO _tmpToolsWeighing (Number, MovementDescId, FromId, ToId, PaidKindId, ColorGridValue, OrderById)
       SELECT tmp.Number
            , CASE WHEN tmp.MovementDescId <> '' THEN tmp.MovementDescId ELSE '0' END :: Integer AS MovementDescId
            , tmp.FromId
            , tmp.ToId
            , tmp.PaidKindId
            , CASE WHEN tmp.ColorGridValue <> '' THEN tmp.ColorGridValue ELSE '0' END :: Integer AS ColorGridValue
            , CASE WHEN tmp.MovementDescId = zc_Movement_Income() :: TVarChar
                        THEN 1
                   WHEN tmp.MovementDescId = zc_Movement_ReturnOut() :: TVarChar
                        THEN 2
                   WHEN tmp.MovementDescId =  zc_Movement_Sale() :: TVarChar
                        THEN 3
                   WHEN tmp.MovementDescId =  zc_Movement_ReturnIn() :: TVarChar
                        THEN 4
                   WHEN tmp.MovementDescId =  zc_Movement_Send() :: TVarChar
                        THEN 5
                   WHEN tmp.MovementDescId =  zc_Movement_SendOnPrice() :: TVarChar
                        THEN 6
                   WHEN tmp.MovementDescId =   zc_Movement_Loss() :: TVarChar
                        THEN 7
                   WHEN tmp.MovementDescId =   zc_Movement_ProductionUnion() :: TVarChar
                        THEN 8
                   WHEN tmp.MovementDescId =   zc_Movement_Inventory() :: TVarChar
                        THEN 9
                   ELSE 0
              END * 1000 AS OrderById
       FROM
      (SELECT tmp.Number
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'DescId'    , '0', inSession) AS MovementDescId
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'FromId'    , '0', inSession) AS FromId
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ToId'      , '0', inSession) AS ToId
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'PaidKindId', '0', inSession) AS PaidKindId
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ColorGrid' , '0', inSession) AS ColorGridValue
       FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
      ) AS tmp;


    -- Результат
    RETURN QUERY
      SELECT _tmpToolsWeighing.Number                        AS Number
           , _tmpToolsWeighing.MovementDescId                AS MovementDescId
           , Object_From.Id                                  AS FromId
           , Object_From.ValueData                           AS FromName
           , Object_To.Id                                    AS ToId
           , Object_To.ValueData                             AS ToName
           , Object_PaidKind.Id                              AS PaidKindId
           , Object_PaidKind.ValueData                       AS PaidKindName
           , _tmpToolsWeighing.ColorGridValue                 AS ColorGridValue

           , CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '') || '   (' || _tmpToolsWeighing.Number :: TVarChar ||')'
                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '') || '   (' || _tmpToolsWeighing.Number :: TVarChar ||')'

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '') || '   (' || _tmpToolsWeighing.Number :: TVarChar ||')'

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '') || '   (' || _tmpToolsWeighing.Number :: TVarChar ||')')
             END :: TVarChar AS GuideName

           , (_tmpToolsWeighing.OrderById + _tmpToolsWeighing.Number) :: Integer AS OrderById

       FROM _tmpToolsWeighing
            LEFT JOIN Object AS Object_From ON Object_From.Id = CAST (CASE WHEN _tmpToolsWeighing.FromId <> '' THEN _tmpToolsWeighing.FromId ELSE '0' END AS Integer)
            LEFT JOIN Object AS Object_To ON Object_To.Id = CAST (CASE WHEN _tmpToolsWeighing.ToId <> '' THEN _tmpToolsWeighing.ToId ELSE '0' END AS Integer)
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CAST (CASE WHEN _tmpToolsWeighing.PaidKindId <> '' THEN _tmpToolsWeighing.PaidKindId ELSE '0' END AS Integer)
       WHERE _tmpToolsWeighing.MovementDescId <> 0
      UNION 
       SELECT 0                                   AS Number
            , 0                                   AS MovementDescId
            , 0                                   AS FromId
            , '' :: TVarChar                      AS FromName
            , 0                                   AS ToId
            , '' :: TVarChar                      AS ToName
            , 0                                   AS PaidKindId
            , '' :: TVarChar                      AS PaidKindName
            , 0                                   AS ColorGridValue
            , MovementDesc.ItemName               AS GuideName
            , tmp.OrderById                       AS OrderById
       FROM (SELECT _tmpToolsWeighing.MovementDescId, _tmpToolsWeighing.OrderById FROM _tmpToolsWeighing WHERE _tmpToolsWeighing.MovementDescId <> 0 GROUP BY _tmpToolsWeighing.MovementDescId, _tmpToolsWeighing.OrderById) AS tmp
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.MovementDescId
      ORDER BY 10;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_MovementDesc (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.01.15                                        * all
 20.03.14                                                         *
 14.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing_MovementDesc (1, zfCalc_UserAdmin())
