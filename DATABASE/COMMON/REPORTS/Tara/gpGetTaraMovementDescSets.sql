-- Function: gpGetTaraMovementDescSets()

DROP FUNCTION IF EXISTS gpGetTaraMovementDescSets(TVarChar);

CREATE OR REPLACE FUNCTION gpGetTaraMovementDescSets(
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    InDesc           TVarChar, --Дески внутренних приходов
    InBayDesc        TVarChar, --Дески Внешних приходов
    OutDesc          TVarChar, --Дески внутренних расходов
    OutSaleDesc      TVarChar, --Дески внешних приходов
    InventoryDesc    TVarChar, --Дески инвентаризаций
    LossDesc         TVarChar, --Дески списаний
    InMLODesc        Integer,  --Деск "От кого / кому" для приходов
    OutMLODesc       Integer,  --Деск "От кого / кому" для расходов
    InventoryMLODesc Integer,  --Деск "От кого / кому" для инвентаризаций
    LossMLODesc      Integer)  --Деск "От кого / кому" для списаний
AS
$BODY$
BEGIN

    RETURN QUERY
        SELECT
            ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';IN;InternalMovement')::TVarChar    AS InDesc
          , ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';IN;ExternalMovement')::TVarChar    AS InBayDesc
          , ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';OUT;InternalMovement')::TVarChar   AS OutDesc
          , ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';OUT;ExternalMovement')::TVarChar   AS outSaleDesc
          , zc_Movement_Inventory()::TVarChar AS InventoryDesc
          , zc_Movement_Loss()::TVarChar      AS LossDesc
          , zc_MovementLinkObject_From()      AS InMLODesc
          , zc_MovementLinkObject_To()        AS OutMLODesc
          , zc_MovementLinkObject_To()        AS InventoryMLODesc
          , zc_MovementLinkObject_To()        AS LossMLODesc
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetTaraMovementDescSets (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 18.12.15                                                        *

*/

-- тест
-- SELECT * FROM gpGetTaraMovementDescSets (inSession:= '2')