-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForOrderInternal(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_UnitForOrderInternal(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForOrderInternal(
    IN inSelectAll   Boolean,       -- выделить все подразделения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (NeedReorder Boolean, UnitId Integer, UnitCode Integer, UnitName TVarChar, ExistsOrderInternal Boolean, MovementId Integer) 
AS
$BODY$
DECLARE vbOperDate TDateTime;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
    vbOperDate := CURRENT_Date;
    RETURN QUERY 
    WITH OrderInternal AS (
                            SELECT 
                                MovementLinkObject_Unit.ObjectId AS UnitId
                               ,MAX(Movement.Id)::Integer        AS MovementId
                            FROM Movement
                                JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                JOIN MovementBoolean AS MovementBoolean_isAuto
                                                     ON MovementBoolean_isAuto.MovementId = Movement.Id 
                                                    AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                                        
                            WHERE 
                                Movement.StatusId = zc_Enum_Status_UnComplete() 
                                AND 
                                Movement.DescId = zc_Movement_OrderInternal() 
                                AND 
                                Movement.OperDate = vbOperDate 
                                AND 
                                MovementBoolean_isAuto.ValueData = True
                            GROUP BY
                                MovementLinkObject_Unit.ObjectId
                          ) 
    SELECT inSelectAll                              as NeedReorder
         , Object_Unit_View.Id                      as UnitId
         , Object_Unit_View.Code                    as UnitCode 
         , Object_Unit_View.Name                    as UnitName
         , CASE 
             WHEN OrderInternal.UnitId is null 
               then False 
             ELSE TRUE 
           END::Boolean                              as ExistsOrderInternal
         , OrderInternal.MovementId
    FROM Object_Unit_View
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = Object_Unit_View.id
        LEFT OUTER JOIN OrderInternal ON Object_Unit_View.Id = OrderInternal.UnitId
    WHERE Object_ImportExportLink_View.LinkTypeId =  zc_Enum_ImportExportLinkType_UnitUnitId() ;         
            
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitForOrderInternal(Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А
 04.08.15                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitForReprice ('2')