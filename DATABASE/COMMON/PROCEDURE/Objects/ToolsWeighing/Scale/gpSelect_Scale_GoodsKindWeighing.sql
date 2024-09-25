-- Function: gpSelect_Scale_GoodsKindWeighing()

DROP FUNCTION IF EXISTS gpSelect_Scale_GoodsKindWeighing (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_GoodsKindWeighing(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (GroupId             Integer
             , GroupCode           Integer
             , GroupName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindCode       Integer
             , GoodsKindName       TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_GoodsKindWeighingGroup.Id         AS GroupId
            , Object_GoodsKindWeighingGroup.ObjectCode AS GroupCode
            , Object_GoodsKindWeighingGroup.ValueData  AS GroupName
            , Object_GoodsKind.Id                      AS GoodsKindId
            , Object_GoodsKind.ObjectCode              AS GoodsKindCode
            , Object_GoodsKind.ValueData               AS GoodsKindName

       FROM ObjectLink AS ObjectLink_GoodsKindWeighing_Group
            INNER JOIN Object AS Object_GoodsKindWeighing ON Object_GoodsKindWeighing.Id       = ObjectLink_GoodsKindWeighing_Group.ObjectId
                                                         AND Object_GoodsKindWeighing.isErased = FALSE

            INNER JOIN Object AS Object_GoodsKindWeighingGroup ON Object_GoodsKindWeighingGroup.Id = ObjectLink_GoodsKindWeighing_Group.ChildObjectId
                                                              AND Object_GoodsKindWeighingGroup.ObjectCode > 0
                                                              AND Object_GoodsKindWeighingGroup.isErased   = FALSE
            LEFT JOIN ObjectLink AS ObjectLink_GoodsKindWeighing_GoodsKind
                                 ON ObjectLink_GoodsKindWeighing_GoodsKind.ObjectId = ObjectLink_GoodsKindWeighing_Group.ObjectId
                                AND ObjectLink_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()
            INNER JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKindWeighing_GoodsKind.ChildObjectId
                                                 AND (Object_GoodsKind.ObjectCode <> 0 OR Object_GoodsKind.Id = zc_GoodsKind_WorkProgress())
                                                 AND Object_GoodsKind.isErased = FALSE
       WHERE ObjectLink_GoodsKindWeighing_Group.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup()
     UNION ALL
       SELECT Object_GoodsKindWeighingGroup.Id         AS GroupId
            , Object_GoodsKindWeighingGroup.ObjectCode AS GroupCode
            , Object_GoodsKindWeighingGroup.ValueData  AS GroupName
            , Object_GoodsKind.Id                      AS GoodsKindId
            , Object_GoodsKind.ObjectCode              AS GoodsKindCode
            , Object_GoodsKind.ValueData               AS GoodsKindName
       FROM Object AS Object_GoodsKind 
            LEFT JOIN Object AS Object_GoodsKindWeighingGroup ON Object_GoodsKindWeighingGroup.ObjectCode = 0
                                                             AND Object_GoodsKindWeighingGroup.DescId = zc_Object_GoodsKindWeighingGroup()
       WHERE Object_GoodsKind.DescId = zc_Object_GoodsKind()
         AND Object_GoodsKind.ObjectCode <> 0
         AND Object_GoodsKind.isErased = FALSE
       ORDER BY 1, 5
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_GoodsKindWeighing (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_GoodsKindWeighing (inSession:=zfCalc_UserAdmin())
