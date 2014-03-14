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
               Code       Integer
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

    vbRootName    := (SELECT Object_ToolsWeighing_View.Name FROM Object_ToolsWeighing_View WHERE Object_ToolsWeighing_View.Id = inRootId);
    vbDescCount   := (SELECT gpGetToolsPropertyValue FROM gpGetToolsPropertyValue (vbRootName, 'Movement', 'DescCount', '', '10', inSession));
    vbCurrentDesc := 1;

    LOOP
     INSERT INTO tmpDesc (Id, DescName)
     VALUES (vbCurrentDesc, CAST('MovementDesc_'||CAST(vbCurrentDesc AS TVarChar)  AS TVarChar));
     vbCurrentDesc := vbCurrentDesc + 1;
     EXIT WHEN vbCurrentDesc > vbDescCount;
    END LOOP;

   -- Результат
    RETURN QUERY
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

       FROM tmpDesc
       LEFT JOIN gpGetToolsPropertyValue (vbRootName, 'Movement', tmpDesc.DescName, 'ColorGrid', '0',  inSession)  AS ColorGridValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue (vbRootName, 'Movement', tmpDesc.DescName, 'DescId', '0', inSession)      AS DescIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue (vbRootName, 'Movement', tmpDesc.DescName, 'FromId', '0', inSession)      AS FromIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue (vbRootName, 'Movement', tmpDesc.DescName, 'ToId', '0', inSession)        AS ToIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyValue (vbRootName, 'Movement', tmpDesc.DescName, 'PaidKindId', '0', inSession)  AS PaidKindIdValue ON 1 = 1
       LEFT JOIN gpGetToolsPropertyId (vbRootName, 'Movement', tmpDesc.DescName, '', inSession)                    AS ObjectMovementDescId ON 1 = 1
       LEFT JOIN MovementDesc ON MovementDesc.Id = COALESCE (CAST(DescIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (CAST(FromIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (CAST(ToIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (CAST(PaidKindIdValue.Value AS Integer),0)
       LEFT JOIN Object AS Object_MovementDesc ON Object_MovementDesc.Id = ObjectMovementDescId.Value
       ORDER BY 1, 4, 7
      ;

    DROP TABLE tmpDesc;

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
 SELECT * FROM gpSelect_Object_ToolsWeighing_Guide (89036, zfCalc_UserAdmin()) --Scale_77