-- Function: gpSelect_ShowPUSH_Inventory(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_Inventory(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_Inventory(
    IN inMovementID   integer,          -- ID инвентаризации
    IN inUnitID       integer,          -- Подразделение
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
BEGIN

  outShowMessage := False;
  vbText := '';

  IF COALESCE (inMovementID, 0) <> 0
  THEN
    RETURN;
  END IF;

  SELECT string_agg('Номер '||Movement.InvNumber||' дата '||TO_CHAR (Movement.OperDate, 'dd.mm.yyyy'), CHR(13) ORDER BY Movement.OperDate)
  INTO vbText
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND MovementLinkObject_Unit.ObjectId = inUnitID

  WHERE Movement.DescId = zc_Movement_Inventory()
    AND Movement.StatusId = zc_Enum_Status_UnComplete();


  IF COALESCE(vbText, '') <> ''
  THEN
    outShowMessage := True;
    outPUSHType := 3;
    outText := 'По подразделению не проведены инвентаризации:'||CHR(13)||vbText;
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.12.19                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_Inventory(1, 183292 , '3')
