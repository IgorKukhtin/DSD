-- Function: gpUpdate_Movement_EDIComdoc_Params() - Установить связь с документом (!!!cуществующий!!!)

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDIComdoc_Params (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDIComdoc_Params(
    IN inMovementId      Integer   , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, OperDateTax TDateTime, InvNumberTax TVarChar
             , TotalCountPartner TFloat
             , TotalSumm TFloat
             , OKPO TVarChar, JuridicalName TVarChar
             , GLNCode TVarChar,  GLNPlaceCode TVarChar
             , JuridicalId_Find Integer, JuridicalNameFind TVarChar, PartnerNameFind TVarChar

             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , UnitId Integer, UnitName TVarChar

             , MovementId_Sale Integer
             , OperDatePartner_Sale TDateTime, InvNumber_Sale TVarChar
             , FromName_Sale TVarChar, ToName_Sale TVarChar
             , TotalCountPartner_Sale TFloat
             , TotalSumm_Sale TFloat

             , MovementId_Tax Integer
             , OperDate_Tax TDateTime, InvNumberPartner_Tax TVarChar

             , MovementId_TaxCorrective Integer
             , OperDate_TaxCorrective TDateTime, InvNumberPartner_TaxCorrective TVarChar

             , MovementId_Order Integer
             , OperDate_Order TDateTime, InvNumber_Order TVarChar

             , DescName TVarChar
             , isCheck Boolean
             , isElectron Boolean
             , isError Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDIComdoc_Params());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!только для продажи!!!
     /*IF NOT EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         RAISE EXCEPTION 'Ошибка.Данные перенести можно только для документа <Продажа покупателю>.';
     END IF;*/

     -- сохранили расчетные параметры
     vbGoodsPropertyId:= (SELECT lpUpdate_Movement_EDIComdoc_Params (inMovementId      := Movement.Id
                                                                   , inPartnerOperDate := MovementDate_OperDatePartner.ValueData
                                                                   , inPartnerInvNumber:= MovementString_InvNumberPartner.ValueData
                                                                   , inOrderInvNumber  := Movement.InvNumber
                                                                   , inOKPO            := MovementString_OKPO.ValueData
                                                                   , inIsCheck         := TRUE
                                                                   , inUserId          := vbUserId
                                                                    )
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                               LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                               LEFT JOIN MovementString AS MovementString_OKPO
                                                        ON MovementString_OKPO.MovementId =  Movement.Id
                                                       AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                          WHERE Movement.Id = inMovementId);


     -- проверка ошибки - 2 связи должны быть установлены
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         -- так для продажи
         IF NOT EXISTS (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Sale())
         THEN 
             RAISE EXCEPTION 'Ошибка.Связь с существующим документом <%> не установлена.<%><%>', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()), (SELECT COUNT(*) FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Sale()), inMovementId;
         END IF;
         -- так для налоговой
         IF NOT EXISTS (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Tax())
         THEN 
             RAISE EXCEPTION 'Ошибка.Связь с существующим документом <%> не установлена.<%><%>', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Tax()), (SELECT COUNT(*) FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Tax()), inMovementId;
         END IF;
     ELSE
         IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
         THEN
             -- так для возврата
             IF NOT EXISTS (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_MasterEDI())
             THEN 
                 RAISE EXCEPTION 'Ошибка.Связь с существующим документом <%> не установлена.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ReturnIn());
             END IF;
             -- так для корректировки
             IF NOT EXISTS (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_ChildEDI())
             THEN 
                 RAISE EXCEPTION 'Ошибка.Связь с существующим документом <%> не установлена.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_TaxCorrective());
             END IF;
         ELSE
             RAISE EXCEPTION 'Ошибка.Нельзя обработать документ <%>.', COALESCE ((SELECT MovementDesc.ItemName FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc()), '');
         END IF;
     END IF;


     -- обновили <Классификатор товаров> + сохранили элементы !!!на самом деле только обновили GoodsId and GoodsKindId!!!
     PERFORM lpUpdate_MI_EDI_Params (inMovementId  := inMovementId
                                   , inContractId  := (SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = inMovementId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract())
                                   , inJuridicalId := (SELECT MLO_Juridical.ObjectId FROM MovementLinkObject AS MLO_Juridical WHERE MLO_Juridical.MovementId = inMovementId AND MLO_Juridical.DescId = zc_MovementLinkObject_Juridical())
                                   , inUserId      := vbUserId
                                    );


     -- !!!только для возврата!!!
     /*IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
          -- !!!создаются док-ты <Возврат от покупателя> и <Корректировка к налоговой накладной>!!!
          PERFORM lpInsertUpdate_Movement_EDIComdoc_In (inMovementId    := inMovementId
                                                      , inUserId        := vbUserId
                                                      , inSession       := inSession
                                                       );
     END IF;*/


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол - документ
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     -- сохранили протокол - элементы
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;


     RETURN QUERY 
     SELECT * FROM lpGet_Movement_EDI (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.15                                        * add lpGet_Movement_EDI
 01.09.14                                        * del !!!только для продажи!!!
 07.08.14                                        * add !!!только для продажи!!!
 07.08.14                                        * add zc_MovementString_InvNumberPartner
 31.07.14                                        * add lpInsertUpdate_Movement_EDIComdoc_In
 20.07.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_EDIComdoc_Params (inMovementId:= 0, inSession:= '2')
