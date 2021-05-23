-- Function: gpInsert_ScaleLight_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_Movement_all (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_Movement_all(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId_begin    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleLight_Movement_all());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет данных для документа.';
     END IF;

     --
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMovement_WeighingProduction'))
     THEN
         DELETE FROM _tmpMovement_WeighingProduction;
     ELSE
         CREATE TEMP TABLE _tmpMovement_WeighingProduction (MovementId Integer, GoodsTypeKindId Integer, BarCodeBoxId Integer, Ord Integer) ON COMMIT DROP;
     END IF;


     -- 
     INSERT INTO _tmpMovement_WeighingProduction (MovementId, GoodsTypeKindId, BarCodeBoxId, Ord)
        SELECT DISTINCT
               0 AS MovementId
             , tmp.GoodsTypeKindId
             , tmp.BarCodeBoxId
             , ROW_NUMBER() OVER (ORDER BY tmp.GoodsTypeKindId ASC) AS Ord
        FROM (SELECT DISTINCT
                     MovementItem.GoodsTypeKindId
                   , MovementItem.BarCodeBoxId
              FROM wms_MI_WeighingProduction AS MovementItem
              WHERE MovementItem.MovementId      = inMovementId
                AND MovementItem.isErased        = FALSE
                -- если еще не закрыт
                AND MovementItem.ParentId        IS NULL
             ) AS tmp
         ;

     -- Создали Документ zc_Movement_WeighingProduction
     UPDATE _tmpMovement_WeighingProduction
        SET MovementId = gpInsertUpdate_Movement_WeighingProduction (ioId                  := 0
                                                                   , inOperDate            := Movement.OperDate
                                                                   , inMovementDescId      := Movement.MovementDescId
                                                                   , inMovementDescNumber  := Movement.MovementDescNumber
                                                                   , inWeighingNumber      := _tmpMovement_WeighingProduction.Ord
                                                                                            + COALESCE ((SELECT COUNT(*)
                                                                                                         FROM (SELECT DISTINCT MovementItem.BarCodeBoxId
                                                                                                               FROM wms_MI_WeighingProduction AS MovementItem
                                                                                                               WHERE MovementItem.MovementId = inMovementId
                                                                                                                 AND MovementItem.isErased   = FALSE
                                                                                                                 AND MovementItem.ParentId   > 0
                                                                                                              ) AS tmp
                                                                                                        )
                                                                                                      , 0) :: Integer
                                                                    , inFromId              := Movement.FromId
                                                                    , inToId                := Movement.ToId
                                                                    , inDocumentKindId      := 0
                                                                    , inPartionGoods        := ''
                                                                    , inIsProductionIn      := FALSE
                                                                    , inSession             := inSession
                                                                     )
     FROM wms_Movement_WeighingProduction AS Movement
     WHERE Movement.Id = inMovementId;


     -- в Документ еще сохранили
     PERFORM -- <КАТЕГОРИЯ товара (груза)>
             lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), _tmpMovement_WeighingProduction.MovementId, _tmpMovement_WeighingProduction.GoodsTypeKindId)
             -- <Ш/К ящика (груза)>
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), _tmpMovement_WeighingProduction.MovementId, _tmpMovement_WeighingProduction.BarCodeBoxId)
     FROM _tmpMovement_WeighingProduction;


     -- Добавили элемент - zc_MI_Master
     PERFORM gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                           , inMovementId          := Movement.MovementId
                                                           , inGoodsId             := Movement.GoodsId
                                                           , inAmount              := CASE WHEN Movement.MeasureId = zc_Measure_Sh() THEN Movement.Amount ELSE Movement.RealWeight END
                                                           , inIsStartWeighing     := FALSE
                                                           , inRealWeight          := Movement.RealWeight
                                                           , inWeightTare          := 0
                                                           , inLiveWeight          := 0
                                                           , inHeadCount           := 0
                                                           , inCount               := 0
                                                           , inCountPack           := Movement.Amount
                                                           , inCountSkewer1        := 0
                                                           , inWeightSkewer1       := 0
                                                           , inCountSkewer2        := 0
                                                           , inWeightSkewer2       := 0
                                                           , inWeightOther         := 0
                                                           , inPartionGoodsDate    := NULL
                                                           , inPartionGoods        := ''
                                                           , inMovementItemId      := 0
                                                           , inGoodsKindId         := Movement.GoodsKindId
                                                           , inStorageLineId       := NULL
                                                           , inSession             := inSession
                                                            )
     FROM (SELECT _tmpMovement_WeighingProduction.MovementId
                , CASE WHEN MovementItem.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END AS GoodsId
                , CASE WHEN MovementItem.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END AS GoodsKindId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , SUM (MovementItem.RealWeight) AS RealWeight
                , SUM (MovementItem.Amount)     AS Amount
           FROM wms_Movement_WeighingProduction AS Movement
                INNER JOIN wms_MI_WeighingProduction AS MovementItem
                                                     ON MovementItem.MovementId      = Movement.Id
                                                    AND MovementItem.isErased        = FALSE
                                                    AND MovementItem.ParentId        IS NULL
                LEFT JOIN _tmpMovement_WeighingProduction ON _tmpMovement_WeighingProduction.GoodsTypeKindId = MovementItem.GoodsTypeKindId
                                                         AND _tmpMovement_WeighingProduction.BarCodeBoxId    = MovementItem.BarCodeBoxId
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = CASE WHEN MovementItem.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh ELSE Movement.GoodsId END
                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
           WHERE Movement.Id = inMovementId
           GROUP BY _tmpMovement_WeighingProduction.MovementId
                  , CASE WHEN MovementItem.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END
                  , CASE WHEN MovementItem.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END
                  , ObjectLink_Goods_Measure.ChildObjectId
          ) AS Movement;


     -- сохранили что ВСЕ ящики ЗАКРЫТЫ
     UPDATE wms_MI_WeighingProduction SET ParentId = _tmpMovement_WeighingProduction.MovementId
     FROM _tmpMovement_WeighingProduction
     WHERE wms_MI_WeighingProduction.MovementId      = inMovementId
    -- AND wms_MI_WeighingProduction.isErased        = FALSE
       AND wms_MI_WeighingProduction.ParentId        IS NULL
       AND wms_MI_WeighingProduction.GoodsTypeKindId = _tmpMovement_WeighingProduction.GoodsTypeKindId
       AND wms_MI_WeighingProduction.BarCodeBoxId    = _tmpMovement_WeighingProduction.BarCodeBoxId
    ;
    
     -- провели текущий документ
     UPDATE wms_Movement_WeighingProduction SET StatusId = zc_Enum_Status_Complete() WHERE wms_Movement_WeighingProduction.Id = inMovementId;



if vbUserId = 5 AND 1=0
then
    RAISE EXCEPTION 'Admin - Errr _end <%>', (select count(*) from _tmpMovement_WeighingProduction);
    -- 'Повторите действие через 3 мин.'
end if;

     -- Результат
     RETURN QUERY
       SELECT 0 AS MovementId_begin;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.15                                        * !!!Проверка что документ один!!!
 11.06.15                                        *
*/

-- тест
-- SELECT * FROM gpInsert_ScaleLight_Movement_all (inBranchCode:= 0, inMovementId:= 10, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())
