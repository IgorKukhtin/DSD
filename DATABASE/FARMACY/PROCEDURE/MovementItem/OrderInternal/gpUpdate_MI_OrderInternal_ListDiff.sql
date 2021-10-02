-- Function: gpUpdate_MI_OrderInternal_ListDiff()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_ListDiff (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_ListDiff(
    IN inMovementId          Integer   , -- Ключ объекта <документ>
    IN inUnitId              Integer   , -- подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- строки заказа
     CREATE TEMP TABLE _tmp_MI (Id integer, GoodsId Integer, ListDiffAmount TFloat, AmountManual TFloat, Comment TVarChar) ON COMMIT DROP;
       INSERT INTO _tmp_MI (Id, GoodsId, ListDiffAmount, AmountManual, Comment)
             WITH
                  tmpMI AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId AS GoodsId
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            )
                  -- сохраненные данные кол-во отказ
                , tmpMIFloat_ListDiff AS (SELECT MovementItemFloat.*
                                          FROM MovementItemFloat
                                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                            AND MovementItemFloat.DescId = zc_MIFloat_ListDiff()
                                            AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                          )
                  -- сохраненные данные <Ручное количество>
                , tmpMIFloat_AmountManual AS (SELECT MovementItemFloat.*
                                              FROM MovementItemFloat
                                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                AND MovementItemFloat.DescId = zc_MIFloat_AmountManual()
                                                AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                              )
                , tmpMI_String AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MovementItemString.DescId = zc_MIString_Comment()
                                  )
                
             SELECT tmpMI.Id
                  , tmpMI.GoodsId
                  , COALESCE (MIFloat_ListDiff.ValueData, 0)         AS ListDiffAmount
                  , COALESCE (MIFloat_AmountManual.ValueData, 0)     AS AmountManual
                  , COALESCE (tmpMI_String.ValueData, '') ::TVarChar AS Comment
             FROM tmpMI
                  LEFT JOIN tmpMIFloat_ListDiff     AS MIFloat_ListDiff     ON MIFloat_ListDiff.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMIFloat_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMI_String            AS tmpMI_String         ON tmpMI_String.MovementItemId = tmpMI.Id
                  ;

     -- Данные из док. отказ
     CREATE TEMP TABLE _tmpListDiff_MI (MovementId Integer, Id Integer, GoodsId Integer, Amount TFloat, Comment TVarChar, DiffKindName TVarChar) ON COMMIT DROP;
       INSERT INTO _tmpListDiff_MI (MovementId, Id, GoodsId, Amount, Comment, DiffKindName)
              WITH    
                  -- документы отказа
                  tmpListDiff AS (SELECT Movement.*
                                       , MovementLinkObject_Unit.ObjectId AS UnitId
                                  FROM Movement
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                                    AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  WHERE Movement.DescId = zc_Movement_ListDiff() 
                                    AND Movement.StatusId <> zc_Enum_Status_Erased() --zc_Enum_Status_Complete()
                                    AND Movement.OperDate >= '07.11.2018'
                                 )
                  -- строки документа отказ
                , tmpListDiff_MI_All AS (SELECT MovementItem.*
                                              , Object_DiffKind.ValueData ::TVarChar AS DiffKindName
                                              , MIFloat_AmountSend.ValueData         AS AmountSend
                                         FROM tmpListDiff
                                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpListDiff.Id
                                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                                     AND MovementItem.isErased   = FALSE
                                              LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                                                               ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                                                              AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
                                              LEFT JOIN Object AS Object_DiffKind ON Object_DiffKind.Id = MILO_DiffKind.ObjectId

                                              LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                                                      ON ObjectBoolean_DiffKind_Close.ObjectId = MILO_DiffKind.ObjectId
                                                                     AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()
                                                                     
                                              LEFT JOIN MovementItemFloat AS MIFloat_AmountSend
                                                                          ON MIFloat_AmountSend.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend() 

                                         WHERE COALESCE (ObjectBoolean_DiffKind_Close.ValueData, FALSE) = FALSE                         -- берем все строки кроме закрытых для заказа (св-во вид отказа)
                                     )

                  -- свойство строк <Id док. заказа>
                , tmpMI_MovementId AS (SELECT MovementItemFloat.*
                                       FROM MovementItemFloat
                                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpListDiff_MI_All.Id FROM tmpListDiff_MI_All)
                                         AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                                         AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                      )
                , tmpMI_Comment AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpListDiff_MI_All.Id FROM tmpListDiff_MI_All)
                                      AND MovementItemString.DescId = zc_MIString_Comment()
                                    )
                                                 
                SELECT tmpListDiff_MI_All.MovementId                     AS MovementId
                     , tmpListDiff_MI_All.Id                             AS Id
                     , tmpListDiff_MI_All.ObjectId                       AS GoodsId
                     , (tmpListDiff_MI_All.Amount - COALESCE(tmpListDiff_MI_All.AmountSend, 0))::TFloat   AS Amount
                     , COALESCE (tmpMI_Comment.ValueData, '') ::TVarChar AS Comment
                     , CASE WHEN COALESCE (tmpListDiff_MI_All.DiffKindName, '') = COALESCE (tmpMI_Comment.ValueData, '') THEN '' ELSE COALESCE (tmpListDiff_MI_All.DiffKindName, '') END ::TVarChar AS DiffKindName
                FROM tmpListDiff_MI_All
                     LEFT JOIN tmpMI_MovementId ON tmpMI_MovementId.MovementItemId = tmpListDiff_MI_All.Id
                     LEFT JOIN tmpMI_Comment    ON tmpMI_Comment.MovementItemId    = tmpListDiff_MI_All.Id
                WHERE tmpMI_MovementId.ValueData IS NULL;
           
     -- сохраняем свойства, если такого товара нет в заказе дописываем
     PERFORM lpInsertUpdate_MI_OrderInternal_ListDiff (inId             := COALESCE (_tmp_MI.Id, 0)
                                                     , inMovementId     := inMovementId
                                                     , inGoodsId        := COALESCE ( _tmp_MI.GoodsId, tmpListDiff_MI.GoodsId)
                                                     , inAmountManual   := CASE WHEN COALESCE (_tmp_MI.AmountManual,0) >= COALESCE (tmpListDiff_MI.Amount, 0)    --27.01.2020 ренее была сумма этих значений
                                                                                THEN COALESCE (_tmp_MI.AmountManual,0)
                                                                                ELSE COALESCE (tmpListDiff_MI.Amount, 0)
                                                                           END ::TFloat
                                                     , inListDiffAmount := (COALESCE (_tmp_MI.ListDiffAmount,0) + COALESCE (tmpListDiff_MI.Amount, 0) )::TFloat

                                                     , inComment        := CASE WHEN COALESCE (_tmp_MI.Comment, '') <> '' 
                                                                                THEN CASE WHEN COALESCE (tmpListDiff_MI.Comment, '') <> '' 
                                                                                          THEN COALESCE (_tmp_MI.Comment, '') ||', '||COALESCE (tmpListDiff_MI.Comment, '')
                                                                                          ELSE COALESCE (_tmp_MI.Comment, '')
                                                                                     END 
                                                                                ELSE COALESCE (tmpListDiff_MI.Comment, '')
                                                                           END :: TVarChar
                                                     , inUserId         := vbUserId
                                                     )
     FROM _tmp_MI
          FULL JOIN (SELECT _tmpListDiff_MI.GoodsId      AS GoodsId
                          , CASE WHEN SUM (_tmpListDiff_MI.Amount) > 0 THEN SUM (_tmpListDiff_MI.Amount) ELSE 0 END  AS Amount 
                          , STRING_AGG (DISTINCT _tmpListDiff_MI.Comment, ';')  || STRING_AGG (DISTINCT _tmpListDiff_MI.DiffKindName, ';') :: TVarChar AS Comment
                          --, STRING_AGG (DISTINCT _tmpListDiff_MI.DiffKindName, ';') :: TVarChar AS DiffKindName
                     FROM _tmpListDiff_MI
                     GROUP BY _tmpListDiff_MI.GoodsId
                     ) AS tmpListDiff_MI ON tmpListDiff_MI.GoodsId = _tmp_MI.GoodsId
     ;
     
     --записываем Ид заказа в строки док. отказа
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), tmp.Id, inMovementId)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_List(), tmp.Id, vbUserId)
           , lpInsertUpdate_MovementItemDate (zc_MIDate_List(), tmp.Id, CURRENT_TIMESTAMP)
           , lpInsert_MovementItemProtocol (tmp.Id, vbUserId, FALSE)
     FROM _tmpListDiff_MI AS tmp;


     -- если все позиции из листа отказа перенесены во внутренний заказ - проводим документ Лист отказа, проводятся листы отказов за прошлый день, а листы отказов за текущий день не проводятся 
     PERFORM gpComplete_Movement_ListDiff (tmp.MovementId, inSession)
     FROM (SELECT Movement.Id AS MovementId
                , SUM (CASE WHEN COALESCE (MovementItemFloat.ValueData,0) <> 0 OR
                                (MovementItem.Amount - COALESCE(MIFloat_AmountSend.ValueData, 0)) <= 0 THEN 0 ELSE 1 END) AS ord
           FROM Movement 
           
                INNER JOIN  MovementItem ON MovementItem.MovementId = Movement.Id

                LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                           AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                                           AND MovementItem.isErased = FALSE
                                           AND MovementItem.DescId   = zc_MI_Master()

                LEFT JOIN MovementItemFloat AS MIFloat_AmountSend
                                            ON MIFloat_AmountSend.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend() 
                                     
            WHERE Movement.DescId = zc_Movement_ListDiff() 
              AND Movement.StatusId = zc_Enum_Status_UnComplete()
              AND Movement.OperDate >= '07.11.2018'
              AND Movement.OperDate < CURRENT_DATE

           GROUP BY Movement.Id
           HAVING SUM (CASE WHEN COALESCE (MovementItemFloat.ValueData,0) <> 0 OR
                      (MovementItem.Amount - COALESCE(MIFloat_AmountSend.ValueData, 0)) <= 0 THEN 0 ELSE 1 END) = 0
           ) AS tmp;


     -- !!!ВРЕМЕННО для ТЕСТА!!!
     IF inSession = zfCalc_UserAdmin()
     THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inSession, (select Sum(_tmpListDiff_MI.Amount) from _tmpListDiff_MI);
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.11.18         *
 01.11.18         *
*/

-- тест
--

 /*lpInsertUpdate_MovementItemFloat (zc_MIFloat_ListDiff(), COALESCE (_tmp_MI.Id, 0), COALESCE (_tmp_MI.ListDiffAmount,0) + COALESCE (tmpListDiff_MI.Amount, 0) )   -- сохранили свойство кол-во отказ
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), COALESCE (_tmp_MI.Id, 0), COALESCE (_tmp_MI.AmountManual,0) + COALESCE (tmpListDiff_MI.Amount, 0) ) -- сохранили свойство <Ручное количество>
           , lpInsert_MovementItemProtocol (_tmp_MI.Id, vbUserId, FALSE) 
           */
           