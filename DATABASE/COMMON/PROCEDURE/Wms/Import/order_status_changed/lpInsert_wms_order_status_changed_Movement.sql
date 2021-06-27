-- Function: lpInsert_wms_order_status_changed_Movement()

DROP FUNCTION IF EXISTS lpInsert_wms_order_status_changed_Movement (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsert_wms_order_status_changed_Movement (
 INOUT ioMovementId    Integer,  -- Ключ Документа
    IN inOrderId       Integer,  -- Ключ заявки
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbFromId       Integer;
   DECLARE vbToId         Integer;
   DECLARE vbPaidKindId   Integer;
   DECLARE vbContractId   Integer;
   DECLARE vbPriceListId  Integer;

   DECLARE vbBranchCode         Integer;
   DECLARE vbMovementDescId     Integer;
   DECLARE vbMovementDescNumber Integer;
   DECLARE vbChangePercent      TFloat;
BEGIN
     -- Днепр-Экспедиция
     vbBranchCode:= 1;

     -- Эти поля взяли из Заявки
     WITH tmpToolsWeighing_MovementDesc AS (SELECT *
                                            FROM gpSelect_Object_ToolsWeighing_MovementDesc (inIsCeh     := FALSE
                                                                                           , inBranchCode:= vbBranchCode
                                                                                           , inSession   := inSession
                                                                                            )
                                           )
         -- !!!заменили!!!
       , tmpMovement_OrderExternal_all AS (SELECT gpGet.FromId
                                                , 5314826 AS ToId      -- Светофор Упаковка
                                                , 8459    AS ToId_orig -- Склад Реализации
                                                , gpGet.PaidKindId
                                                , gpGet.ContractId
                                                , gpGet.PriceListId
                                           FROM gpGet_Movement_OrderExternal (inMovementId := inOrderId
                                                                            , inOperDate   := CURRENT_TIMESTAMP
                                                                            , inMask       := False
                                                                            , inSession    := inSession
                                                                             ) AS gpGet
                                          )
       , tmpMovement_OrderExternal AS (SELECT tmpMovement_OrderExternal_all.FromId
                                            , tmpMovement_OrderExternal_all.ToId
                                            , tmpMovement_OrderExternal_all.ToId_orig
                                            , tmpMovement_OrderExternal_all.PaidKindId
                                            , tmpMovement_OrderExternal_all.ContractId
                                            , tmpMovement_OrderExternal_all.PriceListId
                                            , CASE WHEN Object_From.DescId = zc_Object_Unit() THEN zc_Movement_SendOnPrice() ELSE zc_Movement_Sale() END AS MovementDescId
                                       FROM tmpMovement_OrderExternal_all
                                            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement_OrderExternal_all.FromId
                                      )
     -- Результат
     SELECT gpGet.ToId    -- !!!заменили!!!
          , gpGet.FromId  -- !!!заменили!!!
          , gpGet.PaidKindId
          , gpGet.ContractId
          , gpGet.PriceListId
          , gpGet.MovementDescId
          , tmpSelect.Number
          , Object_ContractCondition_PercentView.ChangePercent
            INTO vbFromId
               , vbToId
               , vbPaidKindId
               , vbContractId
               , vbPriceListId
               , vbMovementDescId
               , vbMovementDescNumber
               , vbChangePercent
     FROM tmpMovement_OrderExternal AS gpGet
          LEFT JOIN Object AS Object_From ON Object_From.Id = gpGet.FromId
          LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = gpGet.ContractId
                                                        AND CURRENT_DATE BETWEEN Object_ContractCondition_PercentView.StartDate AND Object_ContractCondition_PercentView.EndDate
          
          LEFT JOIN tmpToolsWeighing_MovementDesc AS tmpSelect ON tmpSelect.MovementDescId = gpGet.MovementDescId
                                                              AND tmpSelect.FromId = gpGet.ToId_orig
                                                              AND COALESCE (tmpSelect.PaidKindId, 0) = CASE WHEN gpGet.MovementDescId = zc_Movement_SendOnPrice()
                                                                                                                 THEN 0
                                                                                                            ELSE gpGet.PaidKindId
                                                                                                       END
    ;

     -- создали Документ
     ioMovementId := (SELECT gpInsertUpdate.Id
                      FROM   gpInsertUpdate_Scale_Movement (inId                 := ioMovementId
                                                          , inOperDate           := (SELECT gpGet_Scale_OperDate (FALSE, vbBranchCode, inSession))
                                                          , inMovementDescId     := vbMovementDescId
                                                          , inMovementDescNumber := vbMovementDescNumber
                                                          , inFromId             := vbFromId
                                                          , inToId               := vbToId
                                                          , inContractId         := vbContractId
                                                          , inPaidKindId         := vbPaidKindId
                                                          , inPriceListId        := vbPriceListId
                                                          , inSubjectDocId       := 0
                                                          , inMovementId_order   := inOrderId
                                                          , inMovementId_Transport:= 0
                                                          , inChangePercent      := vbChangePercent
                                                          , inBranchCode         := vbBranchCode
                                                          , inSession            := inSession
                                                           ) AS gpInsertUpdate
                     );


END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

 /*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpInsert_wms_order_status_changed_Movement (ioMovementId:= 0, inOrderId:= 1, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpInsert_wms_order_status_changed (inOrderId:= 18226694, inSession:= zfCalc_UserAdmin())
