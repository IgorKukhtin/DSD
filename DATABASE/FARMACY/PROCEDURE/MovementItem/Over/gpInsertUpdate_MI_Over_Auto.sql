-- Function: gpInsertUpdate_MI_Over_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Auto (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Auto (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Auto(
    IN inUnitId              Integer   , -- от кого
    IN inOperDate            TDateTime , -- дата
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inRemains	     TFloat    , -- остаток
    IN inAmountSend          TFloat    , -- автоперемещение приход
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
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;


   -- IF COALESCE(inAmount, 0) <> 0
   -- THEN
      -- ищем ИД документа (ключ - дата, Подразделение) 
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        Inner Join MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitId
      WHERE Movement.DescId = zc_Movement_Over() 
        AND Movement.OperDate = inOperDate
        AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0
      THEN
       -- записываем новый <Документ>
       vbMovementId := lpInsertUpdate_Movement_Over (ioId               := 0
                                                   , inInvNumber        := CAST (NEXTVAL ('Movement_Over_seq') AS TVarChar) --inInvNumber
                                                   , inOperDate         := inOperDate
                                                   , inUnitId           := inUnitId
                                                   , inComment          := '' :: TVarChar
                                                   , inUserId           := vbUserId
                                                   );
       END IF;
      
   
       -- проверка
       IF EXISTS (SELECT ObjectId FROM MovementItem WHERE MovementId = vbMovementId AND ObjectId = inGoodsId AND isErased = FALSE AND DescId = zc_MI_Master())
       THEN
          RAISE EXCEPTION 'Ошибка.Дублируется "главный" товар = <%> партия = <%> кол-во = <%>  остаток = <%> цена = <%>', lfGet_Object_ValueData (inGoodsId), DATE (inMinExpirationDate), zfConvert_FloatToString (inAmount), zfConvert_FloatToString (inRemains), zfConvert_FloatToString (inPrice);
       END IF;


      -- определяем срок годности остатка
      SELECT MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
   INTO inMinExpirationDate
      FROM (
            SELECT Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                 , Container.Id  AS ContainerId
            FROM Container 
                 LEFT JOIN MovementItemContainer AS MIContainer
                                                 ON MIContainer.ContainerId = Container.Id
                                                AND MIContainer.OperDate >= inOperDate
            WHERE Container.DescId = zc_Container_Count()
              AND Container.WhereObjectId = inUnitId --3457773
              AND Container.Objectid = inGoodsId --19996
            GROUP BY Container.Id, Container.Amount
            HAVING  Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
           ) AS tmp
           -- находим партию
           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                         ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
           -- элемент прихода
           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
           -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                      
           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
      HAVING  SUM (tmp.RemainsStart) <> 0;



       -- сохранили строку документа
       vbMovementItemId := lpInsertUpdate_MI_Over_Master    (ioId                 := 0 -- COALESCE (vbMovementItemId, 0)
                                                           , inMovementId         := vbMovementId
                                                           , inGoodsId            := inGoodsId
                                                           , inAmount             := 0 -- inAmount !!!автоматом = сумме в zc_MI_Child!!!
                                                           , inRemains            := inRemains
                                                           , inAmountSend         := inAmountSend
                                                           , inPrice              := inPrice
                                                           , inMCS                := inMCS
                                                           , inMinExpirationDate  := inMinExpirationDate
                                                           , inComment            := Null :: TVarChar
                                                           , inUserId             := vbUserId
                                                            );
  
  -- END IF;

       -- проверка
       IF EXISTS (SELECT ObjectId FROM MovementItem WHERE MovementId = vbMovementId AND isErased = FALSE AND DescId = zc_MI_Master() GROUP BY ObjectId HAVING COUNT(*) > 1)
       THEN
          RAISE EXCEPTION 'Ошибка.Дублируется "главный" товар <%>', lfGet_Object_ValueData ((SELECT ObjectId FROM MovementItem WHERE MovementId = vbMovementId AND isErased = FALSE AND DescId = zc_MI_Master() GROUP BY ObjectId HAVING COUNT(*) > 1 LIMIT 1));
       END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.16         *
*/

-- тест
--select * from gpInsertUpdate_MI_Over_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
