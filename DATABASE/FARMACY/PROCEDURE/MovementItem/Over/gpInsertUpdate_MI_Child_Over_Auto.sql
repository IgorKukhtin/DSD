-- Function: gpInsertUpdate_MI_Child_Over_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Child_Over_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Child_Over_Auto(
    IN inUnitFromId          Integer   , -- от кого
    IN inUnitToId            Integer   , -- кому
    IN inOperDate            TDateTime , -- дата
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inRemains	     TFloat    , -- 
    IN inPrice               TFloat    , -- Цена от кого
    IN inMCS                 TFloat    , -- период для расчета НТЗ
    IN inMinExpirationDate   TDateTime , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbMovementItemChildId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;

    IF COALESCE (inAmount, 0) <> 0
    THEN
      -- поиск документа (ключ - дата, Подразделение)
      vbMovementId:= (SELECT Movement.Id  
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                        AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId   = inUnitFromId
                      WHERE Movement.OperDate = inOperDate
                        AND Movement.DescId = zc_Movement_Over()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );
      -- проверка
      IF COALESCE (vbMovementId, 0) = 0 THEN
          RAISE EXCEPTION 'Ошибка.Документ не определен.';
      END IF;

      
      -- поиск строки Master (ключ - ид документа, товар)
      vbMovementItemId:= (SELECT MovementItem.Id
                          FROM MovementItem
                          WHERE MovementItem.MovementId = vbMovementId 
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.ObjectId   = inGoodsId
                            AND MovementItem.isErased   = FALSE
                         );
      /*-- проверка
      IF COALESCE (vbMovementItemId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Строка мастера не определена.';
      END IF;*/


     IF vbMovementItemId <> 0
     THEN
        -- проверка
        IF EXISTS (SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId AND MovementId = vbMovementId AND ObjectId = inUnitToId AND isErased = FALSE AND DescId = zc_MI_Child())
        THEN
           RAISE EXCEPTION 'Ошибка.Дублируется "подчиненный" товар <%> для аптеки <%>', lfGet_Object_ValueData ((SELECT ObjectId FROM MovementItem WHERE ParentId = vbMovementItemId)), lfGet_Object_ValueData (inUnitToId);
        END IF;

        -- сохранили строку документа
        vbMovementItemChildId := lpInsertUpdate_MI_Over_Child(ioId               := 0 --COALESCE (vbMovementItemChildId, 0)
                                                            , inMovementId       := vbMovementId
                                                            , inParentId         := vbMovementItemId                                
                                                            , inUnitId           := inUnitToId
                                                            , inAmount           := inAmount
                                                            , inRemains          := inRemains
                                                            , inPrice            := inPrice
                                                            , inMCS              := inMCS
                                                            , inMinExpirationDate:= inMinExpirationDate
                                                            , inComment          := Null :: TVarChar
                                                            , inUserId           := vbUserId
                                                            );

        -- сохранили в Master - сумму из Child
        PERFORM lpInsertUpdate_MovementItem (ioId           := MovementItem.Id
                                           , inDescId       := MovementItem.DescId
                                           , inObjectId     := MovementItem.ObjectId
                                           , inMovementId   := MovementItem.MovementId
                                           , inAmount       := COALESCE ((SELECT SUM (Amount) FROM MovementItem WHERE MovementId = vbMovementId AND ParentId = vbMovementItemId AND isErased = FALSE AND DescId = zc_MI_Child()), 0)
                                           , inParentId     := MovementItem.ParentId
                                           , inUserId       := vbUserId
                                            )
        FROM MovementItem
        WHERE MovementItem.Id = vbMovementItemId
       ;

      
      END IF;
  
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.07.16         *
*/

-- тест
--select * from gpInsertUpdate_MI_Child_Over_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
