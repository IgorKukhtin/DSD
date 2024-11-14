-- Function: gpMovementItem_ProductionPeresort_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionPeresort_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionPeresort_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
RETURNS Boolean
AS
$BODY$
BEGIN
   
   
   outIsErased := (SELECT tmp.outIsErased FROM gpMovementItem_ProductionUnion_Master_SetUnErased(inMovementItemId, inSession) AS tmp);
   
   IF COALESCE (inMovementItemId,0) <> 0
   THEN
      PERFORM gpMovementItem_ProductionUnion_Child_SetUnErased (MovementItem.Id, inSession)
      FROM MovementItem
      WHERE MovementItem.ParentId   = inMovementItemId
        AND MovementItem.DescId     = zc_MI_Child()
        AND MovementItem.isErased   = TRUE
      ;

   END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProductionPeresort_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 13.12.14         *
*/

-- тест
-- SELECT * FROM gpMovementItem_ProductionPeresort_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
