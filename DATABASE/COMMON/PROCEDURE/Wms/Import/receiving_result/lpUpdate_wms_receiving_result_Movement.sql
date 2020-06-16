-- Function: lpUpdate_wms_receiving_result_Movement()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar, TFloat);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_wms_receiving_result_Movement (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_wms_receiving_result_Movement (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_wms_receiving_result_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_wms_receiving_result_Movement (
    IN inId            Integer,  -- Наш Id сообщения -> wms_to_host_message.Id
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementId Integer;
BEGIN
     -- нашли Документ zc_Movement_WeighingProduction
     vbMovementId:= (SELECT DISTINCT MI_WP.ParentId AS MovementId
                     FROM wms_to_host_message AS wms_message
                          -- Наш Id задания на упаковку
                          INNER JOIN wms_MI_Incoming AS MI_Incoming ON MI_Incoming.Id = wms_message.MovementId :: Integer

                          INNER JOIN wms_Movement_WeighingProduction AS Movement_WP
                                                                     ON Movement_WP.OperDate    = MI_Incoming.OperDate
                                                                    AND Movement_WP.GoodsId     = MI_Incoming.GoodsId
                                                                    AND Movement_WP.GoodsKindId = MI_Incoming.GoodsKindId
                          INNER JOIN wms_MI_WeighingProduction AS MI_WP
                                                               ON MI_WP.MovementId      = Movement_WP.Id
                                                              AND MI_WP.GoodsTypeKindId = MI_Incoming.GoodsTypeKindId

                          INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id        = MI_WP.BarCodeBoxId
                                                                -- имя груза - Ш/К ящика
                                                                AND Object_BarCodeBox.ValueData = wms_message.Name
                     WHERE wms_message.Id = inId
                    );

     -- Проверка
     IF COALESCE (vbMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не найден Id = <%> + IncomingId = <%> + Name = <%>'
                        , inId
                        , (SELECT wms_message.MovementId FROM wms_to_host_message AS wms_message WHERE wms_message.Id = inId)
                        , (SELECT wms_message.Name       FROM wms_to_host_message AS wms_message WHERE wms_message.Id = inId)
                         ;
     END IF;


    -- обновление даты документа
    PERFORM gpInsertUpdate_Movement_WeighingProduction (ioId                  := vbMovementId
                                                      , inOperDate            := (SELECT wms_message.OperDate FROM wms_to_host_message AS wms_message WHERE wms_message.Id = inId)
                                                      , inMovementDescId      := MovementDesc.Id
                                                      , inMovementDescNumber  := MovementFloat_MovementDescNumber.ValueData :: Integer
                                                      , inWeighingNumber      := MovementFloat_WeighingNumber.ValueData :: Integer
                                                      , inFromId              := MovementLinkObject_From.ObjectId
                                                      , inToId                := MovementLinkObject_To.ObjectId
                                                      , inDocumentKindId      := MovementLinkObject_DocumentKind.ObjectId
                                                      , inPartionGoods        := MovementString_PartionGoods.ValueData
                                                      , inIsProductionIn      := FALSE
                                                      , inSession             := inSession
                                                       )
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                      ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                     AND MovementLinkObject_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
         LEFT JOIN MovementString AS MovementString_PartionGoods
                                  ON MovementString_PartionGoods.MovementId = Movement.Id
                                 AND MovementString_PartionGoods.DescId     = zc_MovementString_PartionGoods()
         LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                 ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                AND MovementFloat_WeighingNumber.DescId     = zc_MovementFloat_WeighingNumber()
         LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                 ON MovementFloat_MovementDescNumber.MovementId = Movement.Id
                                AND MovementFloat_MovementDescNumber.DescId     = zc_MovementFloat_MovementDescNumber()
         LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                 ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
         LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData

    WHERE Movement.Id =  vbMovementId
   ;

    -- обновление элемента - zc_MI_Master
    PERFORM gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := MovementItem.Id
                                                          , inMovementId          := vbMovementId
                                                          , inGoodsId             := MovementItem.ObjectId
                                                          , inAmount              := CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                          THEN wms_message.Qty    :: TFloat
                                                                                          ELSE wms_message.Weight :: TFloat
                                                                                     END
                                                          , inIsStartWeighing     := FALSE
                                                          , inRealWeight          := wms_message.Weight :: TFloat
                                                          , inWeightTare          := 0
                                                          , inLiveWeight          := 0
                                                          , inHeadCount           := 0
                                                          , inCount               := 0
                                                          , inCountPack           := wms_message.Qty :: TFloat
                                                          , inCountSkewer1        := 0
                                                          , inWeightSkewer1       := 0
                                                          , inCountSkewer2        := 0
                                                          , inWeightSkewer2       := 0
                                                          , inWeightOther         := 0
                                                          , inPartionGoodsDate    := NULL
                                                          , inPartionGoods        := ''
                                                          , inMovementItemId      := 0
                                                          , inGoodsKindId         := MILO_GoodsKind.ObjectId
                                                          , inStorageLineId       := NULL
                                                          , inSession             := inSession
                                                           )
    FROM MovementItem
         LEFT JOIN wms_to_host_message AS wms_message ON wms_message.Id = inId
         LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                          ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                         AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                             AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
    WHERE MovementItem.MovementId = vbMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      -- только если изменилось кол-во
      AND MovementItem.Amount <> CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                      THEN wms_message.Qty    :: TFloat
                                      ELSE wms_message.Weight :: TFloat
                                 END
    ;


END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 09.06.20                                         *
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpUpdate_wms_receiving_result_Movement (inId:= 1, inSession:= zfCalc_UserAdmin())
