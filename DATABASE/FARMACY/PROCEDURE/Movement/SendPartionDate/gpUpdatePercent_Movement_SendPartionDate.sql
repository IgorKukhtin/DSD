-- Function: gpUpdatePercent_Movement_SendPartionDate()

DROP FUNCTION IF EXISTS gpUpdatePercent_Movement_SendPartionDate (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdatePercent_Movement_SendPartionDate(
    IN inUnitID              Integer   , -- Подразделение
    IN inChangePercent       TFloat    , -- Номер документа
    IN inChangePercentMin    TFloat    , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendPartionDate());
    vbUserId := inSession;
    
    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Изменение процентов вам запрещено.';
    END IF;
    
      -- Поменяли процент в Документе
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), Movement.Id, inChangePercent),
            lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentMin(), Movement.Id, inChangePercentMin)
    FROM Movement 
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.DescId = zc_Movement_SendPartionDate()
      AND MovementLinkObject_Unit.ObjectId = inUnitID;

      -- Поменяли процент в содtржимом
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id, inChangePercent)
    FROM Movement 
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId = zc_MI_Master() 
                                
         INNER JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                
    WHERE Movement.DescId = zc_Movement_SendPartionDate()
      AND MovementLinkObject_Unit.ObjectId = inUnitID;

      -- Поменяли процент в содtржимом
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentMin(), MovementItem.Id, inChangePercentMin)
    FROM Movement 
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId = zc_MI_Master() 
                                
         INNER JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                      ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                     AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()
                                
    WHERE Movement.DescId = zc_Movement_SendPartionDate()
      AND MovementLinkObject_Unit.ObjectId = inUnitID;
      
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_ValueMin(), ContainerLinkObject.ObjectId, inChangePercentMin),
            lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Value(), ContainerLinkObject.ObjectId, inChangePercent)
    FROM Container

         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

    WHERE Container.DescId = zc_container_countpartiondate()
      AND Container.WhereObjectId = inUnitID;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.07.19                                                       *
*/

-- тест
-- select * from gpUpdatePercent_Movement_SendPartionDate(inUnitID := 183292 , inChangePercent := 110 , inChangePercentMin := 30 ,  inSession := '3');
