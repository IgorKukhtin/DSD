-- Function: gpMovementItem_ProductionPeresort_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionPeresort_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionPeresort_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vboutIsErased Boolean;
   DECLARE vbChildId Integer;
BEGIN
   
   
   outIsErased := (SELECT outIsErased FROM gpMovementItem_ProductionUnion_Master_SetErased(inMovementItemId, inSession));
   
   IF COALESCE (inMovementItemId,0) <> 0
   THEN
      vbChildId := (SELECT Id FROM MovementItem where ParentId   = inMovementItemId
                                                  AND DescId     = zc_MI_Child()
                                                  AND isErased   = FALSE);
      vboutIsErased:= (SELECT outIsErased FROM gpMovementItem_ProductionUnion_Child_SetErased(vbChildId, inSession));
   END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProductionPeresort_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 13.12.14         *
*/

-- тест
-- SELECT * FROM gpMovementItem_ProductionPeresort_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
