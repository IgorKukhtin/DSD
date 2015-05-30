-- Function: gpSelect_Object_ToolsWeighing_MovementDesc()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_Guide (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_MovementDesc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_MovementDesc(
    IN inBranchCode  Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Number           Integer
             , MovementDescId   Integer
             , FromId           Integer, FromCode         Integer, FromName      TVarChar
             , ToId             Integer, ToCode           Integer, ToName        TVarChar
             , PaidKindId       Integer, PaidKindName     TVarChar
             , InfoMoneyId      Integer, InfoMoneyCode    Integer, InfoMoneyName TVarChar
             , PriceListId      Integer, PriceListCode    Integer, PriceListName TVarChar
             , GoodsKindWeighingGroupId Integer
             , ColorGridValue   Integer
             , MovementDescName        TVarChar
             , MovementDescName_master TVarChar
             , OrderById        Integer
             , isSendOnPriceIn  Boolean
               )
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbCount      Integer;
   DECLARE vbBranchId   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


    -- определяется кол-во операций
    vbCount:= (SELECT gpGet_ToolsWeighing_Value ('Scale_'||inBranchCode, 'Movement', '', 'Count', '10', inSession));
    -- определяется
    vbBranchId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch());


    -- временные таблица
    CREATE TEMP TABLE _tmpToolsWeighing (Number                   Integer
                                       , MovementDescId           Integer
                                       , FromId                   Integer
                                       , ToId                     Integer
                                       , PaidKindId               Integer
                                       , InfoMoneyId              Integer
                                       , GoodsKindWeighingGroupId Integer
                                       , ColorGridValue           Integer
                                       , OrderById                Integer
                                       , isSendOnPriceIn          Boolean
                                       , ItemName                 TVarChar
                                        ) ON COMMIT DROP;
    -- формирование
    INSERT INTO _tmpToolsWeighing (Number, MovementDescId, FromId, ToId, PaidKindId, InfoMoneyId, GoodsKindWeighingGroupId, ColorGridValue, OrderById, isSendOnPriceIn, ItemName)
       SELECT tmp.Number
            , CASE WHEN TRIM (tmp.MovementDescId)           <> '' THEN TRIM (tmp.MovementDescId)           ELSE '0' END :: Integer AS MovementDescId
            , CASE WHEN TRIM (tmp.FromId)                   <> '' THEN TRIM (tmp.FromId)                   ELSE '0' END :: Integer AS FromId
            , CASE WHEN TRIM (tmp.ToId)                     <> '' THEN TRIM (tmp.ToId)                     ELSE '0' END :: Integer AS ToId
            , CASE WHEN TRIM (tmp.PaidKindId)               <> '' THEN TRIM (tmp.PaidKindId)               ELSE '0' END :: Integer AS PaidKindId
            , CASE WHEN TRIM (tmp.InfoMoneyId)              <> '' THEN TRIM (tmp.InfoMoneyId)              ELSE '0' END :: Integer AS InfoMoneyId
            , CASE WHEN TRIM (tmp.GoodsKindWeighingGroupId) <> '' THEN TRIM (tmp.GoodsKindWeighingGroupId) ELSE '0' END :: Integer AS GoodsKindWeighingGroupId
            , CASE WHEN TRIM (tmp.ColorGridValue)           <> '' THEN TRIM (tmp.ColorGridValue)           ELSE '0' END :: Integer AS ColorGridValue
            , CASE WHEN tmp.MovementDescId = zc_Movement_Income() :: TVarChar
                        THEN 1
                   WHEN tmp.MovementDescId = zc_Movement_ReturnOut() :: TVarChar
                        THEN 2
                   WHEN tmp.MovementDescId = zc_Movement_Sale() :: TVarChar
                        THEN 3
                   WHEN tmp.MovementDescId = zc_Movement_ReturnIn() :: TVarChar
                        THEN 4
                   WHEN tmp.MovementDescId = zc_Movement_Send() :: TVarChar
                        THEN 5
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() :: TVarChar
                        THEN 0 -- можно расчитать здесь, но не хочется его нагромождать, и резервируется 6,7
                   WHEN tmp.MovementDescId = zc_Movement_Loss() :: TVarChar
                        THEN 8
                   WHEN tmp.MovementDescId = zc_Movement_ProductionUnion() :: TVarChar
                        THEN 9
                   WHEN tmp.MovementDescId = zc_Movement_Inventory() :: TVarChar
                        THEN 10
                   ELSE 0
              END * 1000 AS OrderById
            , CASE WHEN vbBranchId = zc_Branch_Basis() AND (Object_From.Id IS NULL OR ObjectLink_UnitFrom_Branch.ChildObjectId > 0)
                        THEN TRUE -- для главного - приход на него
                   WHEN vbBranchId = zc_Branch_Basis()
                        THEN FALSE -- для главного - расход с него
                   WHEN vbBranchId = ObjectLink_UnitTo_Branch.ChildObjectId
                        THEN TRUE -- для филиала - приход на него
                   ELSE FALSE -- для филиала - расход с него
              END AS isSendOnPriceIn

            , MovementDesc.ItemName

       FROM (SELECT tmp.Number
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'DescId'    ,               '0', inSession) AS MovementDescId
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'FromId'    ,               '0', inSession) AS FromId
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ToId'      ,               '0', inSession) AS ToId
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'PaidKindId',               '0', inSession) AS PaidKindId
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'InfoMoneyId', zc_Enum_InfoMoney_30101() :: TVarChar, inSession) AS InfoMoneyId -- Доходы + Продукция + Готовая продукция
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'GoodsKindWeighingGroupId', '345238', inSession) AS GoodsKindWeighingGroupId -- Продажа
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBranchCode, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ColorGrid' ,               '0', inSession) AS ColorGridValue
             FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
            ) AS tmp
            LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN TRIM (tmp.FromId) <> '' THEN TRIM (tmp.FromId) ELSE '0' END :: Integer
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = CASE WHEN TRIM (tmp.ToId)   <> '' THEN TRIM (tmp.ToId)   ELSE '0' END :: Integer
            LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                 ON ObjectLink_UnitFrom_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                 ON ObjectLink_UnitTo_Branch.ObjectId = Object_To.Id
                                AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN MovementDesc ON MovementDesc.Id = CASE WHEN TRIM (tmp.MovementDescId) <> '' THEN TRIM (tmp.MovementDescId) ELSE '0' END :: Integer
      ;

    -- можно расчитать и в пред. запросе, но не хочется его нагромождать
    UPDATE _tmpToolsWeighing SET OrderById = 1000 * CASE WHEN vbBranchId = zc_Branch_Basis() AND _tmpToolsWeighing.isSendOnPriceIn = FALSE
                                                              THEN 6 -- для главного - расход с него, будет в списке раньше
                                                         WHEN vbBranchId = zc_Branch_Basis()
                                                              THEN 7 -- для главного - приход на него, будет в списке позже
                                                         WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                                              THEN 6 -- для филиала - приход на него, будет в списке раньше
                                                         ELSE 7 -- для филиала - расход с него, будет в списке позже
                                                    END
                               , ItemName = CASE WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND _tmpToolsWeighing.isSendOnPriceIn = FALSE
                                                  AND vbBranchId = zc_Branch_Basis()
                                                      THEN 'Расход на филиал'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND vbBranchId = zc_Branch_Basis()
                                                      THEN 'Возврат с филиала'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                                      THEN 'Приход на филиал'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                      THEN 'Возврат с филиала'
                                                 ELSE _tmpToolsWeighing.ItemName
                                            END
    WHERE _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice();


    -- Результат
    RETURN QUERY
      SELECT _tmpToolsWeighing.Number                        AS Number
           , _tmpToolsWeighing.MovementDescId                AS MovementDescId
           , COALESCE (Object_From.Id, 0) :: Integer         AS FromId
           , Object_From.ObjectCode                          AS FromCode
           , Object_From.ValueData                           AS FromName
           , COALESCE (Object_To.Id, 0) :: Integer           AS ToId
           , Object_To.ObjectCode                            AS ToCode
           , Object_To.ValueData                             AS ToName
           , Object_PaidKind.Id                              AS PaidKindId
           , Object_PaidKind.ValueData                       AS PaidKindName
           , COALESCE (Object_InfoMoney.Id, 0) :: Integer    AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                     AS InfoMoneyCode
           , Object_InfoMoney.ValueData                      AS InfoMoneyName
           , Object_PriceList.Id                             AS PriceListId
           , Object_PriceList.ObjectCode                     AS PriceListCode
           , Object_PriceList.ValueData                      AS PriceListName
           , Object_GoodsKindWeighingGroup.Id                AS GoodsKindWeighingGroupId
           , _tmpToolsWeighing.ColorGridValue                AS ColorGridValue

           , ('(' || _tmpToolsWeighing.Number :: TVarChar ||') '
           || CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '')
                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Loss())
                       THEN COALESCE (Object_From.ValueData, '') || ' => '

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
              END) :: TVarChar AS MovementDescName

           , ('(' || _tmpToolsWeighing.Number :: TVarChar ||') '
          || _tmpToolsWeighing.ItemName -- MovementDesc.ItemName
          || ': '
          || CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '')
                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Loss())
                       THEN COALESCE (Object_From.ValueData, '') || ' => '

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
             END) :: TVarChar AS MovementDescName_master

           , (_tmpToolsWeighing.OrderById + _tmpToolsWeighing.Number) :: Integer AS OrderById
           , _tmpToolsWeighing.isSendOnPriceIn

       FROM _tmpToolsWeighing
            LEFT JOIN Object AS Object_PriceList              ON Object_PriceList.Id              = zc_PriceList_Basis() AND _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
            LEFT JOIN Object AS Object_From                   ON Object_From.Id                   = _tmpToolsWeighing.FromId
            LEFT JOIN Object AS Object_To                     ON Object_To.Id                     = _tmpToolsWeighing.ToId
            LEFT JOIN Object AS Object_PaidKind               ON Object_PaidKind.Id               = _tmpToolsWeighing.PaidKindId
            LEFT JOIN Object AS Object_InfoMoney              ON Object_InfoMoney.Id              = _tmpToolsWeighing.InfoMoneyId
            LEFT JOIN Object AS Object_GoodsKindWeighingGroup ON Object_GoodsKindWeighingGroup.Id = _tmpToolsWeighing.GoodsKindWeighingGroupId
            -- LEFT JOIN MovementDesc ON MovementDesc.Id = _tmpToolsWeighing.MovementDescId
       WHERE _tmpToolsWeighing.MovementDescId <> 0
      UNION
       -- это группы
       SELECT 0                                   AS Number
            ,(-1 * tmp.MovementDescId) :: Integer AS MovementDescId
            , 0                                   AS FromId
            , 0                                   AS FromCode
            , '' :: TVarChar                      AS FromName
            , 0                                   AS ToId
            , 0                                   AS ToCode
            , '' :: TVarChar                      AS ToName
            , 0                                   AS PaidKindId
            , '' :: TVarChar                      AS PaidKindName
            , 0                                   AS InfoMoneyId
            , 0                                   AS InfoMoneyCode
            , '' :: TVarChar                      AS InfoMoneyName
            , 0                                   AS PriceListId
            , 0                                   AS PriceListCode
            , '' :: TVarChar                      AS PriceListName
            , 0                                   AS GoodsKindWeighingGroupId
            , 0                                   AS ColorGridValue
            , CASE WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND tmp.isSendOnPriceIn = FALSE
                    AND vbBranchId = zc_Branch_Basis()
                        THEN 'Расход на филиал'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND vbBranchId = zc_Branch_Basis()
                        THEN 'Возврат с филиала'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND tmp.isSendOnPriceIn = TRUE
                        THEN 'Приход на филиал'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                        THEN 'Возврат с филиала'
                   ELSE tmp.ItemName -- MovementDesc.ItemName
              END :: TVarChar AS MovementDescName
            , '' :: TVarChar                      AS MovementDescName_master
            , tmp.OrderById                       AS OrderById
            , tmp.isSendOnPriceIn
       FROM (SELECT _tmpToolsWeighing.MovementDescId, _tmpToolsWeighing.OrderById, _tmpToolsWeighing.isSendOnPriceIn, _tmpToolsWeighing.ItemName FROM _tmpToolsWeighing WHERE _tmpToolsWeighing.MovementDescId <> 0 GROUP BY _tmpToolsWeighing.MovementDescId, _tmpToolsWeighing.OrderById, _tmpToolsWeighing.isSendOnPriceIn, _tmpToolsWeighing.ItemName) AS tmp
            -- LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.MovementDescId
      ORDER BY OrderById;


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
