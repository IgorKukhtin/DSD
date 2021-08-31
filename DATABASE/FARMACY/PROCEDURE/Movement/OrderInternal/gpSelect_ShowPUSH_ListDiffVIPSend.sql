-- Function: gpSelect_ShowPUSH_ListDiffVIPSend(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_ListDiffVIPSend(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_ListDiffVIPSend(
    IN inMovementID   integer,          -- Документ
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStatusId  Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbText      Text;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := False;
    
     -- ПАРАМЕТРЫ
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId
    INTO vbStatusId, vbUnitId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;
    
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
      RETURN;
    END IF;

    IF EXISTS(select * from gpSelect_MovementItem_ListDiffFormVIPSend(inUnitId := vbUnitId,  inSession := inSession))
    THEN
      outShowMessage := True;
      outPUSHType := 4;
      outText := 'В листах отказов есть товар по которому можно создать VIP перемещение';
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.08.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_ListDiffVIPSend(22749117, '3')

select * from gpSelect_ShowPUSH_ListDiffVIPSend(inMovementID := 24615831 ,  inSession := '3');