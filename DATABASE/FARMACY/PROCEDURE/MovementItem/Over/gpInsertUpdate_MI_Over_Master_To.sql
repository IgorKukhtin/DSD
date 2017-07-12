-- Function: gpInsertUpdate_MI_Over_Master_To()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Master_To  (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Master_To(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Подразделение на кот. приход
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Количество
   OUT outSumma              TFloat    , -- Сумма расход
   OUT outAmountMaster       TFloat    , --
   OUT outSummaMaster        TFloat    , --
    IN inRemains             TFloat    , -- Остаток
    IN inAmountSend          TFloat    , -- Автоперемещение приход
    IN inPrice	             TFloat    , -- Цена расход
    IN inMCS                 TFloat    , -- НТЗ
    IN inOperDate            TDateTime , -- Дата отчета, документа
    IN inMinExpirationDate   TDateTime , -- Срок годности остатка
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountChild TFloat;
   DECLARE vbCountUnit TFloat;
   DECLARE vbObjectId Integer;
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   -- получаем кол-во распределенное по аптекам, и кол-во аптек (из нижнего грида)
   SELECT Sum(MI.Amount)::TFloat AS Amount 
        , COUNT(*) ::TFloat AS CountUnit
   INTO vbAmountChild, vbCountUnit
   FROM MovementItem AS MI
   WHERE MI.MovementId = inMovementId 
     AND MI.ParentId = ioId 
     AND MI.DescId = zc_MI_Child() 
     AND MI.isErased = False;
        
   IF COALESCE(ioAmount,0) <> 0 AND COALESCE(ioAmount,0) <> vbAmountChild
   THEN 
       IF COALESCE(vbCountUnit,0) <> 1 
       THEN
           --ругаемся
           ioAmount:= vbAmountChild;
           outSumma = (vbAmountChild * inPrice) ::TFloat;
       ELSE
           outSumma = (ioAmount * inPrice) ::TFloat;

           --сохраняем значение строки-чайлд
           PERFORM lpInsertUpdate_MovementItem (ioId           := MI.Id
                                              , inDescId       := zc_MI_Child()
                                              , inObjectId     := MI.ObjectId
                                              , inMovementId   := inMovementId
                                              , inAmount       := ioAmount
                                              , inParentId     := ioId
                                                )
           FROM MovementItem AS MI
           WHERE MI.MovementId = inMovementId 
             AND MI.ParentId = ioId 
             AND MI.DescId = zc_MI_Child() 
             AND MI.isErased = False;
       END IF;
   END IF;

   IF COALESCE(ioAmount,0) = 0  -- в чайлде все кол-во перемещение = 0
   THEN
       PERFORM lpInsertUpdate_MovementItem (ioId           :=  MI.Id
                                          , inDescId       := zc_MI_Child()
                                          , inObjectId     := MI.ObjectId
                                          , inMovementId   := inMovementId
                                          , inAmount       := 0
                                          , inParentId     := ioId
                                          , inUserId       := vbUserId
                                           )
       FROM MovementItem AS MI 
       WHERE MI.MovementId = inMovementId 
         AND MI.ParentId = ioId 
         AND MI.DescId = zc_MI_Child() 
         AND MI.isErased = False;

       outSumma = (vbAmountChild * inPrice) ::TFloat;
   END IF;
   
   -- сохранили <Элемент документа>
   ioId :=lpInsertUpdate_MI_Over_Master (ioId                := ioId
                                       , inMovementId        := inMovementId
                                       , inGoodsId           := inGoodsId
                                       , inAmount            := ioAmount
                                       , inRemains           := inRemains
                                       , inAmountSend        := inAmountSend
                                       , inPrice             := inPrice
                                       , inMCS               := inMCS
                                       , inMinExpirationDate := inMinExpirationDate
                                       , inComment           := inComment
                                       , inUserId            := vbUserId
                                       );
   
   -- далее найдем по всем док.распред. итого колво / сумму для заданного товара, чтоб передать в верхний грид отчета
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );
       -- определяем подразделения для распределения
       WITH 
       tmpUnit_list AS (SELECT ObjectBoolean_Over.ObjectId  AS UnitId
                        FROM ObjectBoolean AS ObjectBoolean_Over
                                INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                      ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Over.ObjectId --Container.WhereObjectId
                                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
                          AND ObjectBoolean_Over.ValueData = TRUE
                        )

      -- ищем ИД документа Распределений остатков (ключ - дата, Подразделение) 
      , tmpMovOver AS(SELECT Movement.Id  
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                           INNER JOIN tmpUnit_list ON tmpUnit_list.UnitId = MovementLinkObject_Unit.ObjectId 
                                                  AND tmpUnit_list.UnitId <> inUnitId
                      WHERE Movement.OperDate = inOperDate
                        AND Movement.DescId = zc_Movement_Over()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                      )

      -- Ищем cтроки мастера (ключ - ид документа, товар)
      , tmpMIMaster AS (SELECT  tmpMovOver.Id                     AS MovementId
                              , MovementItem.Id                   AS MIMaster_Id
                        FROM tmpMovOver
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovOver.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.ObjectId = inGoodsId
                       )

      -- Ищем cтроки чайлда (ключ - ид документа, товар)
      SELECT  SUM (MI_Child.Amount)                   AS Amount
            , SUM (MI_Child.Amount * COALESCE(MIFloat_Price.ValueData,0)) :: TFloat AS Summa
        INTO outAmountMaster , outSummaMaster
      FROM tmpMIMaster
           INNER JOIN MovementItem AS MI_Child
                                   ON MI_Child.ParentId = tmpMIMaster.MIMaster_Id
                                  AND MI_Child.ObjectId = inUnitId
                                  AND MI_Child.DescId = zc_MI_Child()
                                  AND MI_Child.isErased = FALSE
           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId =  MI_Child.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
          ;
------------------------------------------------


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.17         *
*/

-- тест
-- select * from gpInsertUpdate_MI_Over_Master_To(ioId := 67374764 , inMovementId := 3959674 , inUnitId := 183292 , inGoodsId := 733 , ioAmount := 2 , inRemains := 14 , inAmountSend := -3 , inPrice := 4.3 , inMCS := 6 , inOperDate := ('16.11.2016')::TDateTime , inMinExpirationDate := ('NULL')::TDateTime , inComment := '' ,  inSession := '3');
