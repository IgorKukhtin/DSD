-- Function: gpInsertUpdateMobile_Movement_Cash()

-- DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Cash (TVarChar, TVarChar, TDateTime, Integer, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Cash (TVarChar, TVarChar, TDateTime, Integer, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_Cash (
    IN inGUID          TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с мобильными устройствами
    IN inInvNumber     TVarChar  , -- Номер документа
    IN inOperDate      TDateTime , -- Дата документа
    IN inStatusId      Integer   , -- Виды статусов
    IN inInsertDate    TDateTime , -- Дата/время создания документа
    IN inAmount        TFloat    , -- Итого сумма
    IN inPaidKindId    Integer   , -- Вид формы оплаты
    IN inPartnerId     Integer   , -- Контрагент - От кого
    IN inCashId        Integer   , -- В какую кассу будет приход
    IN inMemberId      Integer   , -- Торговый агент
    IN inContractId    Integer   , -- Договор
    IN inComment       TVarChar  , -- Примечание
    IN inInvNumberSale TVarChar  , -- Основание №, Номер накладной продажи
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisInsert Boolean;
   DECLARE vbSaleId Integer;
   DECLARE vbCommentIfSaleAbsent TVarChar;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);


      -- RAISE EXCEPTION 'Ошибка.Нет Прав проводить расчеты с покупателем.';
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;


      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_Cash.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Cash
                         ON Movement_Cash.Id = MovementString_GUID.MovementId
                        AND Movement_Cash.DescId = zc_Movement_Cash()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbisInsert:= (COALESCE (vbId, 0) = 0);

      IF (vbisInsert = false) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN -- если приход денег проведен, то распроводим    
           PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
      END IF;

      -- попытка найти документ основания по номеру накладной продажи
      IF COALESCE (inInvNumberSale, '') <> ''
      THEN
           IF zfConvert_StringToNumber (inInvNumberSale) <> 0
           THEN
                -- если номер чисто цифровой (подхватывает индекс)
                SELECT Movement_Sale.Id
                INTO vbSaleId
                FROM Movement AS Movement_Sale
                     JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() 
                                            AND MovementLinkObject_From.ObjectId = inPartnerId
                WHERE Movement_Sale.DescId = zc_Movement_Sale()
                  AND zfConvert_StringToNumber (Movement_Sale.InvNumber) = zfConvert_StringToNumber (inInvNumberSale);
           ELSE
                -- если в номере присутствуют буквы и другие символы
                SELECT Movement_Sale.Id
                INTO vbSaleId
                FROM Movement AS Movement_Sale
                     JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() 
                                            AND MovementLinkObject_From.ObjectId = inPartnerId
                WHERE Movement_Sale.DescId = zc_Movement_Sale()
                  AND Movement_Sale.InvNumber = inInvNumberSale;
           END IF;

           IF COALESCE (vbSaleId, 0) = 0
           THEN
                vbCommentIfSaleAbsent:= ' (Основание №' || inInvNumberSale || ' отсутствует)';
           END IF; 
      END IF;

      vbId:= lpInsertUpdate_Movement_Cash (ioId                   := vbId
                                         , inParentId             := NULL
                                         , inInvNumber            := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                         , inOperDate             := inOperDate
                                         , inServiceDate          := DATE_TRUNC ('MONTH', inOperDate)
                                         , inAmountIn             := inAmount
                                         , inAmountOut            := 0.0
                                         , inAmountSumm           := 0.0
                                         , inAmountCurrency       := 0.0
                                         , inComment              := COALESCE (inComment, '') || COALESCE (vbCommentIfSaleAbsent, '')
                                         , inCarId                := NULL
                                         , inCashId               := inCashId
                                         , inMoneyPlaceId         := inPartnerId
                                         , inPositionId           := 0
                                         , inContractId           := inContractId
                                         , inInfoMoneyId          := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inContractId AND DescId = zc_ObjectLink_Contract_InfoMoney())
                                         , inMemberId             := inMemberId
                                         , inUnitId               := 0
                                         , inCurrencyId           := zc_Enum_Currency_Basis()
                                         , inCurrencyValue        := 0
                                         , inParValue             := 0
                                         , inCurrencyPartnerId    := NULL
                                         , inCurrencyPartnerValue := 0
                                         , inParPartnerValue      := 0
                                         , inMovementId_Partion   := COALESCE (vbSaleId, 0)
                                         , inUserId               := vbUserId
                                          );

      -- сохранили свойство <Дата/время создания на мобильном устройстве>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      -- !!! ВРЕММЕННО Удаляем Документ
      PERFORM lpSetErased_Movement (inMovementId:= vbId, inUserId:= vbUserId);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 21.05.17         *
 16.02.17                                                        *                                          
*/

-- тест
-- SELECT * FROM gpInsertUpdateMobile_Movement_Cash (inGUID:= '{88E07827-BCC3-41E7-A574-E0837AD2E17A}', inInvNumber:= '-30', inOperDate:= CURRENT_DATE, inStatusId:= zc_Enum_Status_UnComplete(), inInsertDate    := CURRENT_TIMESTAMP, inAmount        := 6456.45, inPaidKindId    := zc_Enum_PaidKind_SecondForm(), inPartnerId     := 17819, inCashId        := 280296, inMemberId      := 274610, inContractId    := 16687, inComment       := 'Приход конкретный', inInvNumberSale := '364957', inSession       := zfCalc_UserAdmin() );
-- SELECT * FROM gpInsertUpdateMobile_Movement_Cash (inGUID:= '{88E07827-BCC3-41E7-A574-E0837AD2E17A}', inInvNumber:= '-30', inOperDate:= CURRENT_DATE, inStatusId:= zc_Enum_Status_UnComplete(), inInsertDate    := CURRENT_TIMESTAMP, inAmount        := 6456.45, inPaidKindId    := zc_Enum_PaidKind_SecondForm(), inPartnerId     := 298605, inCashId        := 280296, inMemberId      := 301532, inContractId    := 80339, inComment       := 'Приход конкретный', inInvNumberSale := 'АЛ-0000817', inSession       := '351808' );
