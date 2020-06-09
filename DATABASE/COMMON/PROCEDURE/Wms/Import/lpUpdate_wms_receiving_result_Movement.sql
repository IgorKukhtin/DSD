-- Function: lpUpdate_wms_receiving_result_Movement()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar, TFloat);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_wms_receiving_result_Movement (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_wms_receiving_result_Movement (
    IN inIncomingId    Integer,   -- номер задания на упаковку
    IN inName          TVarChar,  -- имя груза
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementId Integer;
  DECLARE vbOperDate   TDateTime;
  DECLARE vbFromId     Integer;
  DECLARE vbToId       Integer;
  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
BEGIN

    WITH tmpMI AS (-- данные из receiving_result
                   SELECT MI.Id
                        , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN wms_message.Qty ELSE wms_message.Weight END AS Amount
                   FROM wms_MI_Incoming AS MI_Incoming
                        INNER JOIN wms_to_host_message AS wms_message ON wms_message.MovementId = MI_Incoming.Id
                        INNER JOIN wms_Movement_WeighingProduction AS Movement_WP
                                                                   ON Movement_WP.OperDate    = MI_Incoming.OperDate
                                                                  AND Movement_WP.GoodsId     = MI_Incoming.GoodsId
                                                                  AND Movement_WP.GoodsKindId = MI_Incoming.GoodsKindId
                        INNER JOIN wms_MI_WeighingProduction AS MI_WP
                                                             ON MI_WP.MovementId      = Movement_WP.Id
                                                            AND MI_WP.GoodsTypeKindId = MI_Incoming.GoodsTypeKindId
                        INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id        = MI_WP.BarCodeBoxId
                                                              AND Object_BarCodeBox.ValueData = inName
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = Movement_WP.GoodsId
                                            AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                        INNER JOIN Movement ON Movement.Id = MI_WP.ParentId
                        INNER JOIN MovementItem AS MI
                                                ON MI.MovementId = Movement.Id
                                               AND MI.DescId     = zc_MI_Master()
                                               -- только если изменилось кол-во
                                               AND MI.Amount <> CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN wms_message.Qty ELSE wms_message.Weight END
                   WHERE MI_Incoming.Id = inIncomingId
                  )

    UPDATE MovementItem SET Amount = tmpMI.Amount
    FROM tmpMI
    WHERE MovementItem.Id = tmpMI.Id;



     -- нужно обновить дату операции в таб. Movement на значение, которое вернул WMS в to_host_header_message.START_DATE для сообщения 'receiving_result'


    -- выполняем обновление даты операции в существующем документе
    PERFORM gpInsertUpdate_Scale_Movement (inId                 := tmpMI.MovementId
                                         , inOperDate           := tmpMI.OperDate
                                         , inMovementDescId     := 0
                                         , inMovementDescNumber := 0
                                         , inFromId             := MovementLinkObject_From.ObjectId
                                         , inToId               := MovementLinkObject_To.ObjectId
                                         , inContractId         := MovementLinkObject_Contract.ObjectId
                                         , inPaidKindId         := MovementLinkObject_PaidKind.ObjectId
                                         , inPriceListId        := 0
                                         , inMovementId_order   := NULL
                                         , inChangePercent      := 0
                                         , inBranchCode         := 0
                                         , inSession            := inSession
                                          )
    FROM (-- данные из receiving_result
          SELECT DISTINCT
                 MI_WP.ParentId       AS MovementId
               , wms_message.OperDate AS OperDate
          FROM wms_MI_Incoming AS MI_Incoming
               INNER JOIN wms_to_host_message AS wms_message ON wms_message.MovementId = MI_Incoming.Id
               INNER JOIN wms_Movement_WeighingProduction AS Movement_WP
                                                          ON Movement_WP.OperDate    = MI_Incoming.OperDate
                                                         AND Movement_WP.GoodsId     = MI_Incoming.GoodsId
                                                         AND Movement_WP.GoodsKindId = MI_Incoming.GoodsKindId
               INNER JOIN wms_MI_WeighingProduction AS MI_WP
                                                    ON MI_WP.MovementId      = Movement_WP.Id
                                                   AND MI_WP.GoodsTypeKindId = MI_Incoming.GoodsTypeKindId
               INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id        = MI_WP.BarCodeBoxId
                                                     AND Object_BarCodeBox.ValueData = inName
               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                    ON ObjectLink_Goods_Measure.ObjectId = Movement_WP.GoodsId
                                   AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          WHERE MI_Incoming.Id = inIncomingId
         ) AS tmpMI
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = tmpMI.MovementId
                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = tmpMI.MovementId
                                     AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = tmpMI.MovementId
                                     AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                      ON MovementLinkObject_PaidKind.MovementId = tmpMI.MovementId
                                     AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
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
-- SELECT * FROM lpUpdate_wms_receiving_result_Movement (inIncomingId:= 1, inName:= 'AHC-00506', inSession:= '5')
