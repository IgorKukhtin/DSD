-- Function: gpInsertUpdate_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChoiceCell(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inBarCode             TVarChar  , -- штрихкод яч. отбора 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbChoiceCellId Integer;  
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime; 
   DECLARE curPartionCell refcursor;
   DECLARE vbPartionCellId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChoiceCell())

     IF COALESCE (inBarCode,'') <> ''
     THEN
         IF CHAR_LENGTH (inBarCode) = 13
         THEN -- по штрих коду
              vbChoiceCellId:= (SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS ObjectId
                                     ) AS tmp
                                      INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                       AND Object.DescId = zc_Object_ChoiceCell()
                                                       AND Object.isErased = FALSE
                                );
         END IF;
         
         -- Проверка
         IF COALESCE (vbChoiceCellId, 0) = 0
         THEN
            -- 
             RAISE EXCEPTION 'Ошибка.Ячейка отбора со штрихкодом <%> не нвйдена' , inBarCode;
         END IF;
     END IF;     
        
    --пробуем найти жокумент
    vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.DescId = zc_Movement_ChoiceCell() AND Movement.OperDate = CURRENT_DATE);
    
    IF COALESCE (vbMovementId,0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_ChoiceCell (ioId          := 0
                                                          , inInvNumber   := CAST (NEXTVAL ('movement_ChoiceCell_seq') AS TVarChar)
                                                          , inOperDate    := CURRENT_DATE
                                                          , inUserId      := vbUserId
                                                           )AS tmp;
    END IF;
 
      --
     CREATE TEMP TABLE _tmpPartionCell_ful (PartionCellId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsDate TDateTime) ON COMMIT DROP;

     --
     OPEN curPartionCell FOR SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PartionCell() /*AND Object.Id = zc_PartionCell_RK()*/ ORDER BY Object.Id;
     -- начало цикла по курсору
     LOOP
          -- данные
          FETCH curPartionCell INTO vbPartionCellId;
          -- если данных нет, то мы выходим
          IF NOT FOUND THEN
             EXIT;
          END IF;

          -- Только заполненные ячейки + отбор
          INSERT INTO _tmpPartionCell_ful (PartionCellId, GoodsId, GoodsKindId, PartionGoodsDate)
             WITH tmpMILO AS (SELECT * FROM MovementItemLinkObject AS MILO WHERE MILO.ObjectId = vbPartionCellId)
                  , tmpMI AS (SELECT DISTINCT tmpMILO.ObjectId AS PartionCellId, MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId, COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) AS PartionGoodsDate
                              FROM tmpMILO
                                   LEFT JOIN MovementItem ON MovementItem.Id       = tmpMILO.MovementItemId
                                                         AND MovementItem.isErased = FALSE
                                   LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                   LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                             ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                            AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()
                                                            AND MovementBoolean_isRePack.ValueData  = TRUE
                                   LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                    ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                             AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                              -- Только заполненные
                              WHERE tmpMILO.ObjectId > 0
                                -- без ПЕРЕПАК
                                AND MovementBoolean_isRePack.MovementId IS NULL
                                --
                                AND tmpMILO.DescId IN (zc_MILinkObject_PartionCell_1()
                                                     , zc_MILinkObject_PartionCell_2()
                                                     , zc_MILinkObject_PartionCell_3()
                                                     , zc_MILinkObject_PartionCell_4()
                                                     , zc_MILinkObject_PartionCell_5()
                                                     , zc_MILinkObject_PartionCell_6()
                                                     , zc_MILinkObject_PartionCell_7()
                                                     , zc_MILinkObject_PartionCell_8()
                                                     , zc_MILinkObject_PartionCell_9()
                                                     , zc_MILinkObject_PartionCell_10()
                                                     , zc_MILinkObject_PartionCell_11()
                                                     , zc_MILinkObject_PartionCell_12()
                                                     , zc_MILinkObject_PartionCell_13()
                                                     , zc_MILinkObject_PartionCell_14()
                                                     , zc_MILinkObject_PartionCell_15()
                                                     , zc_MILinkObject_PartionCell_16()
                                                     , zc_MILinkObject_PartionCell_17()
                                                     , zc_MILinkObject_PartionCell_18()
                                                     , zc_MILinkObject_PartionCell_19()
                                                     , zc_MILinkObject_PartionCell_20()
                                                     , zc_MILinkObject_PartionCell_21()
                                                     , zc_MILinkObject_PartionCell_22()
                                                      )
                             )
             -- Результат
             SELECT tmpMI.PartionCellId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
             FROM tmpMI
            ;
          --
     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор

   
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_ChoiceCell (ioId                := COALESCE(ioId,0)
                                                , inMovementId         := vbMovementId
                                                , inChoiceCellId       := tmp.ChoiceCellId
                                                , inGoodsId            := tmp.GoodsId
                                                , inGoodsKindId        := tmp.GoodsKindId    
                                                , inPartionGoodsDate       := tmp.PartionGoodsDate
                                                , inPartionGoodsDate_next  := tmp.PartionGoodsDate_next
                                                , inUserId             := vbUserId
                                                 )
           FROM (WITH tmpPartionCell_RK AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                             -- № п/п
                                                 , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                                            FROM (SELECT DISTINCT _tmpPartionCell_ful.GoodsId, _tmpPartionCell_ful.GoodsKindId, _tmpPartionCell_ful.PartionGoodsDate
                                                  FROM _tmpPartionCell_ful
                                                  WHERE _tmpPartionCell_ful.PartionCellId = zc_PartionCell_RK()
                                                 ) AS tmpMI
                                           )
                   , tmpPartionCell_real AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                                    -- № п/п
                                                  , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate ASC) AS Ord
                                             FROM (SELECT DISTINCT _tmpPartionCell_ful.GoodsId, _tmpPartionCell_ful.GoodsKindId, _tmpPartionCell_ful.PartionGoodsDate
                                                   FROM _tmpPartionCell_ful
                                                   WHERE _tmpPartionCell_ful.PartionCellId <> zc_PartionCell_RK()
                                                  ) AS tmpMI
                                            )
                 
          
              -- Результат
              SELECT 
                     Object_ChoiceCell.Id                   AS ChoiceCellId
                   , ObjectLink_Goods.ChildObjectId         AS GoodsId
                   , ObjectLink_GoodsKind.ChildObjectId     AS GoodsKindId
                   , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
                   , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_next    
                   
                   , (zfFormat_BarCode (zc_BarCodePref_Object(), Object_ChoiceCell.Id)) ::TVarChar AS idBarCode
          
                   , Object_ChoiceCell.isErased      AS isErased
                 
              FROM Object AS Object_ChoiceCell 
          
                  LEFT JOIN ObjectLink AS ObjectLink_Goods
                                       ON ObjectLink_Goods.ObjectId = Object_ChoiceCell.Id
                                      AND ObjectLink_Goods.DescId = zc_ObjectLink_ChoiceCell_Goods()
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
          
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                       ON ObjectLink_GoodsKind.ObjectId = Object_ChoiceCell.Id
                                      AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
                  LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId
          
                  LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = Object_Goods.Id
                                             AND tmpPartionCell_RK.GoodsKindId = Object_GoodsKind.Id
                                             AND tmpPartionCell_RK.ord         = 1
          
                  LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = Object_Goods.Id
                                               AND tmpPartionCell_real.GoodsKindId = Object_GoodsKind.Id
                                               AND tmpPartionCell_real.ord         = 1
          
              WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()  
                AND Object_ChoiceCell.Id = vbChoiceCellId
              ) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
-- 