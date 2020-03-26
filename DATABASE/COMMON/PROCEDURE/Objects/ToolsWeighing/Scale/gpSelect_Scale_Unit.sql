-- Function: gpSelect_Scale_Unit()

-- DROP FUNCTION IF EXISTS gpSelect_Scale_Unit (Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Unit (Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Unit(
    IN inIsCeh            Boolean,
    IN inBranchCode       Integer,
    IN inBarCode          TVarChar,
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (UnitId      Integer
             , UnitCode    Integer
             , UnitName    TVarChar
             , isErased    Boolean
             , UnitId_to   Integer
             , UnitCode_to Integer
             , UnitName_to TVarChar
             , isErased_to Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    

    IF CHAR_LENGTH (TRIM (inBarCode)) > 2
    THEN

        vbUnitId:= (WITH tmpBarCode   AS (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13)
                       , tmpInvNumber AS (SELECT inBarCode AS BarCode WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13)
                    -- по Ш/К
                    SELECT MLO.ObjectId
                    FROM Movement
                         LEFT JOIN MovementLinkObject AS MLO
                                                      ON MLO.MovementId = Movement.Id
                                                     AND MLO.DescId     = zc_MovementLinkObject_From()
                    WHERE Movement.Id IN (SELECT DISTINCT tmpBarCode.MovementId FROM tmpBarCode)
                      AND Movement.DescId = zc_Movement_OrderInternal()
                      AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '18 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                    --AND Movement.StatusId <> zc_Enum_Status_Erased()
                   UNION
                    -- по № документа
                    SELECT MLO.ObjectId
                    FROM tmpInvNumber AS tmp
                         INNER JOIN Movement ON Movement.InvNumber = tmp.BarCode
                                            AND Movement.DescId = zc_Movement_OrderInternal()
                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '18 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                          --AND Movement.StatusId <> zc_Enum_Status_Erased()
                         LEFT JOIN MovementLinkObject AS MLO
                                                      ON MLO.MovementId = Movement.Id
                                                     AND MLO.DescId     = zc_MovementLinkObject_From()
                   );
    END IF;

    -- Результат
    RETURN QUERY
       WITH tmpToolsWeighing AS (SELECT zfConvert_StringToFloat (tmp.ValueData) AS UnitId
                                      , tmp.NameFull, tmp.ParentId, tmp.ValueData
                                 FROM gpSelect_Object_ToolsWeighing (inSession:= inSession) AS tmp
                                 WHERE tmp.NameFull ILIKE CASE WHEN inIsCeh = TRUE THEN 'ScaleCeh_' || inBranchCode ELSE 'Scale_' || inBranchCode END || '%'
                                   AND (tmp.NameFull ILIKE '%FromId%'
                                     OR tmp.NameFull ILIKE '%ToId%'
                                     OR tmp.NameFull ILIKE '%DescId%'
                                       )
                                 --AND zfConvert_StringToFloat (tmp.ValueData) > 0
                                )
     , tmpToolsWeighing_desc AS (SELECT *
                                 FROM tmpToolsWeighing
                                 WHERE tmpToolsWeighing.NameFull ILIKE '%DescId%'
                                   AND zfConvert_StringToFloat (tmpToolsWeighing.ValueData) = zc_Movement_Send()
                                )
       -- Результат
       SELECT DISTINCT
              Object_Unit_from.Id          AS UnitId
            , Object_Unit_from.ObjectCode  AS UnitCode
            , Object_Unit_from.ValueData   AS UnitName
            , Object_Unit_from.isErased    AS isErased
            , Object_Unit_to.Id            AS UnitId_to
            , Object_Unit_to.ObjectCode    AS UnitCode_to
            , Object_Unit_to.ValueData     AS UnitName_to
            , Object_Unit_to.isErased      AS isErased_to
       FROM tmpToolsWeighing_desc
            JOIN tmpToolsWeighing AS tmpToolsWeighing_from
                                  ON tmpToolsWeighing_from.ParentId = tmpToolsWeighing_desc.ParentId
                                 AND tmpToolsWeighing_from.NameFull ILIKE '%FromId%'
            JOIN tmpToolsWeighing AS tmpToolsWeighing_to
                                  ON tmpToolsWeighing_to.ParentId = tmpToolsWeighing_desc.ParentId
                                 AND tmpToolsWeighing_to.NameFull ILIKE '%ToId%'
            JOIN Object AS Object_Unit_from ON Object_Unit_from.Id         = tmpToolsWeighing_from.UnitId
                                           AND Object_Unit_from.DescId     = zc_Object_Unit()
                                           AND Object_Unit_from.ObjectCode <> 0
            JOIN Object AS Object_Unit_to ON Object_Unit_to.Id         = tmpToolsWeighing_to.UnitId
                                         AND Object_Unit_to.DescId     = zc_Object_Unit()
                                         AND Object_Unit_to.ObjectCode <> 0
       WHERE (Object_Unit_from.ValueData ILIKE '%ЦЕХ%'
           OR Object_Unit_to.ValueData   ILIKE '%ЦЕХ%'
             )
          AND (tmpToolsWeighing_from.UnitId = vbUnitId
            OR tmpToolsWeighing_to.UnitId   = vbUnitId
            OR COALESCE (vbUnitId, 0)       = 0
            )
       ORDER BY 3, 7
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.20                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Unit (inIsCeh:= TRUE, inBranchCode:= '201', inBarCode:= '6071', inSession:=zfCalc_UserAdmin())
