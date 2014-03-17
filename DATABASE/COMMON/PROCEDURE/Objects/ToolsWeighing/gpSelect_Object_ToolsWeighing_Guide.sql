-- Function: gpSelect_Object_ToolsWeighing_Guide()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_Guide (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_Guide(
    IN inRootId      Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
               DescId     Integer, DescName     TVarChar,
               FromId     Integer, FromName     TVarChar,
               ToId       Integer, ToName       TVarChar,
               PaidKindId Integer, PaidKindName TVarChar,
               ColorGridName TVarChar,
               Code       Integer,
               GroupNum   Integer,
               GroupSubNum   Integer,
               DisplayName TVarChar
               ) AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbAccessKeyAll   Boolean;
   DECLARE vbDescCount      Integer;
   DECLARE vbCurrentDesc    Integer;
   DECLARE vbRootName       TVarChar;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
--   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
--   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);
    CREATE TEMP TABLE tmpDesc (Id integer, DescName TVarChar);

--    vbRootName    := (SELECT Object_ToolsWeighing_View.Name FROM Object_ToolsWeighing_View WHERE Object_ToolsWeighing_View.Id = inRootId);
    vbDescCount   := (SELECT gpGetToolsPropertyValue FROM gpGetToolsPropertyValue ('Scale_'||inRootId, 'Movement', 'DescCount', '', '10', inSession));
    vbCurrentDesc := 1;

    LOOP
     INSERT INTO tmpDesc (Id, DescName)
     VALUES (vbCurrentDesc, CAST('MovementDesc_'||CAST(vbCurrentDesc AS TVarChar)  AS TVarChar));
     vbCurrentDesc := vbCurrentDesc + 1;
     EXIT WHEN vbCurrentDesc > vbDescCount;
    END LOOP;

    CREATE TEMP TABLE tmpData(
               DescId     Integer, DescName     TVarChar,
               FromId     Integer, FromName     TVarChar,
               ToId       Integer, ToName       TVarChar,
               PaidKindId Integer, PaidKindName TVarChar,
               ColorGridName TVarChar,
               Code       Integer,
               GroupNum   Integer,
               GroupSubNum   Integer,
               DisplayName TVarChar
               );

       INSERT INTO tmpData (DescId, DescName, FromId, FromName, ToId, ToName, PaidKindId, PaidKindName, ColorGridName, Code, GroupSubNum, GroupNum, DisplayName)
       SELECT
             MovementDesc.Id                        AS DescId
           , MovementDesc.ItemName                  AS DescName
           , Object_From.Id                         AS FromId
           , Object_From.ValueData                  AS FromName
           , Object_To.Id                           AS ToId
           , Object_To.ValueData                    AS ToName
           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName
           , ColorGridValue.Value                   AS ColorGridName
           , Object_MovementDesc.ObjectCode         AS Code
           , tmpDesc.Id                             AS GroupSubNum
           , CASE WHEN MovementDesc.Id = zc_Movement_Income()
                  THEN 1
                  WHEN MovementDesc.Id = zc_Movement_ReturnOut()
                  THEN 2
                  WHEN MovementDesc.Id =  zc_Movement_Sale()
                  THEN 3
                  WHEN MovementDesc.Id =  zc_Movement_ReturnIn()
                  THEN 4
                  WHEN MovementDesc.Id =  zc_Movement_Send()
                  THEN 5
                  WHEN MovementDesc.Id =   zc_Movement_Loss()
                  THEN 6
                  WHEN MovementDesc.Id =   zc_Movement_ProductionUnion()
                  THEN 7
                  WHEN MovementDesc.Id =   zc_Movement_Inventory()
                  THEN 8
              ELSE 0 END                             AS GroupNum

           , CASE WHEN ((COALESCE (Object_From.Id,0) <> 0)
                   AND (COALESCE (Object_To.Id,0) <> 0)
                   AND (COALESCE (Object_PaidKind.Id,0) <> 0))
                  THEN Object_From.ValueData||' => '||Object_To.ValueData||' <'||Object_PaidKind.ValueData||'>'||' ('||Object_MovementDesc.ObjectCode||')'

                  WHEN ((COALESCE (Object_From.Id,0) <> 0)
                   AND (COALESCE (Object_To.Id,0) <> 0)
                   AND (COALESCE (Object_PaidKind.Id,0) = 0))
                  THEN Object_From.ValueData||' => '||Object_To.ValueData||' ('||Object_MovementDesc.ObjectCode||')'

                  WHEN ((COALESCE (Object_From.Id,0) <> 0)
                   AND (COALESCE (Object_To.Id,0) = 0)
                   AND (COALESCE (Object_PaidKind.Id,0) <> 0))
                  THEN Object_From.ValueData||' <'||Object_PaidKind.ValueData||'>'||' ('||Object_MovementDesc.ObjectCode||')'

                  WHEN ((COALESCE (Object_From.Id,0) = 0)
                   AND (COALESCE (Object_To.Id,0) <> 0)
                   AND (COALESCE (Object_PaidKind.Id,0) <> 0))
                  THEN Object_To.ValueData||' <'||Object_PaidKind.ValueData||'>'||' ('||Object_MovementDesc.ObjectCode||')'

                  WHEN ((COALESCE (Object_From.Id,0) <> 0)
                   AND (COALESCE (Object_To.Id,0) = 0)
                   AND (COALESCE (Object_PaidKind.Id,0) = 0))
                  THEN Object_From.ValueData||' ('||Object_MovementDesc.ObjectCode||')'

                  WHEN ((COALESCE (Object_From.Id,0) = 0)
                   AND (COALESCE (Object_To.Id,0) <> 0)
                   AND (COALESCE (Object_PaidKind.Id,0) = 0))
                  THEN Object_To.ValueData||' ('||Object_MovementDesc.ObjectCode||')'
              ELSE '' END                           AS DisplayName

--            , Object_From.ValueData

       FROM tmpDesc
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'Movement', 'MovementDesc_'||tmpDesc.Id, 'ColorGrid', '0',  inSession)  AS ColorGridValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'Movement', 'MovementDesc_'||tmpDesc.Id, 'DescId', '0', inSession)      AS DescIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'Movement', 'MovementDesc_'||tmpDesc.Id, 'FromId', '0', inSession)      AS FromIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'Movement', 'MovementDesc_'||tmpDesc.Id, 'ToId', '0', inSession)        AS ToIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'Movement', 'MovementDesc_'||tmpDesc.Id, 'PaidKindId', '0', inSession)  AS PaidKindIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyId ('Scale_'||inRootId, 'Movement', 'MovementDesc_'||tmpDesc.Id, '', inSession)                    AS ObjectMovementDescId ON 1 = 1
       LEFT JOIN MovementDesc ON MovementDesc.Id = COALESCE (CAST(DescIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (CAST(FromIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (CAST(ToIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (CAST(PaidKindIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_MovementDesc ON Object_MovementDesc.Id = ObjectMovementDescId.Value;
--       ORDER BY 1, 4, 7


   -- Результат
    RETURN QUERY
       SELECT

             tmpData.DescId                         AS DescId
           , tmpData.DescName                       AS DescName
           , tmpData.FromId                         AS FromId
           , tmpData.FromName                       AS FromName
           , tmpData.ToId                           AS ToId
           , tmpData.ToName                         AS ToName
           , tmpData.PaidKindId                     AS PaidKindId
           , tmpData.PaidKindName                   AS PaidKindName
           , tmpData.ColorGridName                  AS ColorGridName
           , tmpData.Code                           AS Code
           , tmpData.GroupNum                       AS GroupNum
           , tmpData.GroupSubNum                    AS GroupSubNum
           , tmpData.DisplayName                    AS DisplayName

       FROM tmpData
       UNION
       SELECT
             tmpData.DescId                         AS DescId
           , tmpData.DescName                       AS DescName
           , 0                                      AS FromId
           , CAST('' AS TVarChar)                   AS FromName
           , 0                                      AS ToId
           , CAST('' AS TVarChar)                   AS ToName
           , 0                                      AS PaidKindId
           , CAST('' AS TVarChar)                   AS PaidKindName
           , CAST('' AS TVarChar)                   AS ColorGridName
           , 0                                      AS Code
           , tmpData.GroupNum                       AS GroupNum
           , 0                                      AS GroupSubNum
           , CAST('          '||tmpData.GroupNum||'. '||tmpData.DescName AS TVarChar) AS DisplayName

       FROM tmpData
       GROUP BY tmpData.DescId, tmpData.DescName, tmpData.GroupNum, tmpData.DescName
       ORDER BY 11, 12;


    DROP TABLE tmpDesc;
    DROP TABLE tmpData;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_Guide (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.03.14                                                         *
*/

-- тест

-- SELECT * FROM gpSelect_Object_ToolsWeighing_Guide (88952, zfCalc_UserAdmin()) --Scale_1
-- SELECT * FROM gpSelect_Object_ToolsWeighing_Guide (89036, zfCalc_UserAdmin()) --Scale_77
-- SELECT * FROM gpSelect_Object_ToolsWeighing_Guide (77, zfCalc_UserAdmin()) --Scale_77

