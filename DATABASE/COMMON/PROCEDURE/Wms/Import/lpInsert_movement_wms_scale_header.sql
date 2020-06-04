-- Function: lpInsert_wms_order_status_changed_Movement()

DROP FUNCTION IF EXISTS lpInsert_movement_wms_scale_header (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsert_wms_order_status_changed_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsert_wms_order_status_changed_Movement (
 INOUT inMovementId    Integer,  -- Ключ Документа
    IN inOrderId       Integer,  -- Ключ заявки
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS Integer
AS			  
$BODY$
   DECLARE vbFromId     Integer;
   DECLARE vbToId       Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbContractId Integer;
BEGIN 

     -- Эти поля взяли из Заявки
     SELECT gpGet.FromId
          , gpGet.ToId
          , gpGet.PaidKindId
          , gpGet.ContractId 
            INTO vbFromid
               , vbToid
               , vbPaidKindId
               , vbContractId  
	FROM gpGet_Movement_OrderExternal (inMovementId := inMovementId
                                         , inOperDate   := CURRENT_TIMESTAMP
                                         , inSession    := inSession
                                          ) AS gpGet;

     -- создали Документ
     inMovementId:= gpInsertUpdate_Scale_Movement (inId                 := inMovementId
                                                 , inOperDate           := CURRENT_TIMESTAMP
                                                 , inMovementDescId     := 0
                                                 , inMovementDescNumber := 0
                                                 , inFromId             := vbFromId
                                                 , inToId               := vbToId
                                                 , inContractId         := vbContractId
                                                 , inPaidKindId         := vbPaidkindId
                                                 , inPriceListId        := 0
                                                 , inMovementId_order   := inMovementId
                                                 , inChangePercent      := 0
                                                 , inBranchCode         := 0
                                                 , inSession            := inSession
                                                  ) AS tmp;

END; 
$BODY$
 LANGUAGE PLPGSQL VOLATILE;
 
 /*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpInsert_wms_order_status_changed_Movement (inMovementId:= 0, inOrderId:= 1, inSession:= zfCalc_UserAdmin())
