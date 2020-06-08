-- Function: lpUpdate_MovementItem_amount()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar, TFloat);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_amount (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_amount (
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

    WITH CheckAmount AS (
        -- выбираем записи из таб. MovementItem, которые соответствуют inIncomingId и у которых amount отличается от qty из сообщения 'receiving_result'  
        SELECT MI.Id, InMsg.Qty 
        FROM wms_MI_Incoming AS Incoming
            INNER JOIN wms_to_host_message AS InMsg ON Incoming.Id = InMsg.MovementId 
            INNER JOIN wms_Movement_WeighingProduction AS Movement
                                                       ON Movement.OperDate    = Incoming.OperDate
                                                      AND Movement.GoodsId     = Incoming.GoodsId
                                                      AND Movement.GoodsKindId = Incoming.GoodsKindId 
            INNER JOIN wms_MI_WeighingProduction AS MI_WP 
                                                 ON MI_WP.MovementId      = Movement.Id  
                                                AND MI_WP.GoodsTypeKindId = Incoming.GoodsTypeKindId
            INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI_WP.BarCodeBoxId
            INNER JOIN MovementItem AS MI ON MI.MovementId = MI_WP.parentid   
            
        WHERE Incoming.Id                 = inIncomingId  
          AND Object_BarCodeBox.ValueData = inName 
          AND MI.amount <> InMsg.Qty    
    )

  -- обновляем MovementItem.amount значениями из таб. CheckAmount
  UPDATE MovementItem
  SET    amount = CheckAmount.Qty 
  FROM   CheckAmount
  WHERE  MovementItem.Id = CheckAmount.Id;
  
  
 
  -- нужно обновить дату операции в таб. Movement на значение, которое вернул WMS в to_host_header_message.START_DATE для сообщения 'receiving_result'
  
  -- получим ключ имеющегося документа и дату операции, значение которой сохранено в ALAN wms_to_host_message.operdate
  SELECT Movement.Id, InMsg.OperDate 
  INTO   vbMovementId, vbOperDate
  FROM   wms_MI_Incoming AS Incoming
  
    INNER JOIN wms_to_host_message AS InMsg ON Incoming.Id = InMsg.MovementId 
    
    INNER JOIN wms_Movement_WeighingProduction AS Movement_WP
                                               ON Movement_WP.OperDate    = Incoming.OperDate
                                              AND Movement_WP.GoodsId     = Incoming.GoodsId
                                              AND Movement_WP.GoodsKindId = Incoming.GoodsKindId 
                                              
    INNER JOIN wms_MI_WeighingProduction AS MI_WP 
                                         ON MI_WP.MovementId      = Movement_WP.Id  
                                        AND MI_WP.GoodsTypeKindId = Incoming.GoodsTypeKindId
                                        
    INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI_WP.BarCodeBoxId
    INNER JOIN MovementItem AS MI ON MI.MovementId = MI_WP.parentid  
    INNER JOIN Movement ON Movement.Id = MI.MovementId    

  WHERE Incoming.Id                 = inIncomingId  
    AND Object_BarCodeBox.ValueData = inName 
    AND MI.amount <> InMsg.Qty;   
    
 
  -- эти поля взяли из Заявки
  SELECT gpGet.FromId
       , gpGet.ToId
       , gpGet.PaidKindId
       , gpGet.ContractId 
         INTO vbFromid
            , vbToid
            , vbPaidKindId
            , vbContractId  
  FROM gpGet_Movement_OrderExternal (inMovementId := vbMovementId
                                   , inOperDate   := CURRENT_TIMESTAMP
                                   , inSession    := inSession
                                    ) AS gpGet; 
 
  -- выполняем обновление даты операции в существующем документе 
  PERFORM gpInsertUpdate_Scale_Movement (inId                := COALESCE(vbMovementId, -1) -- если vbMovementId=NULL нужно предотвратить создание нового документа (поэтому передаем -1, не 0) 
                                      , inOperDate           := COALESCE(vbOperDate, CURRENT_TIMESTAMP)
                                      , inMovementDescId     := 0
                                      , inMovementDescNumber := 0
                                      , inFromId             := vbFromId
                                      , inToId               := vbToId
                                      , inContractId         := vbContractId
                                      , inPaidKindId         := vbPaidkindId
                                      , inPriceListId        := 0
                                      , inMovementId_order   := vbMovementId
                                      , inChangePercent      := 0
                                      , inBranchCode         := 0
                                      , inSession            := inSession
                                       );

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpUpdate_MovementItem_amount (inIncomingId:= 1, inName:= 'AHC-00506', inSession:= '5')