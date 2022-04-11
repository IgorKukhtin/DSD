-- Function: lpInsert_Movement_TaxCorrective_isAutoPrepay()

DROP FUNCTION IF EXISTS lpInsert_Movement_TaxCorrective_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_Movement_TaxCorrective_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_TaxCorrective_isAutoPrepay(
    IN inId                    Integer   , -- Ключ объекта <Документ TaxCorrective>
    IN inInvNumber             TVarChar  , -- Номер документа
    IN inInvNumberPartner      TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch       TVarChar  , -- Номер филиала
    IN inOperDate              TDateTime , -- Дата документа
    IN inisAuto                Boolean   , -- Автоматически
    IN inChecked               Boolean   , -- Проверен
    IN inDocument              Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT          Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent            TFloat    , -- % НДС
    IN inAmount                TFloat    , -- сумма предоплаты
    IN inFromId                Integer   , -- От кого (в документе)
    IN inToId                  Integer   , -- Кому (в документе)
    IN inPartnerId             Integer   , -- Контрагент
    IN inContractId            Integer   , -- Договора
    IN inDocumentTaxKindId     Integer   , -- Тип формирования документа TaxCorrective
    IN inPersonalCollationName TVarChar  ,
    IN inUserId                Integer     -- пользователь
)


RETURNS VOID AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
BEGIN

    -- сохранили документ
    inId:= (SELECT tmp.ioId
            FROM lpInsertUpdate_Movement_TaxCorrective (inId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                                      , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                                      , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, inUserId
                                                       ) AS tmp);

    -- сохранили свойство <Автоматически>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inPersonalCollationName);
    -- сохранили свойство <Автоматически>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inisAuto);

    --строка документа 
    PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                     , inMovementId         := inId
                                                     , inGoodsId            := 2117 -- код 4 -- inDocumentTaxKindId
                                                     , inAmount             := inAmount
                                                     , inPrice              := 1
                                                     , inPriceTax_calc      := 1
                                                     , ioCountForPrice      := 1
                                                     , inGoodsKindId        := zc_GoodsKind_Basis()
                                                     , inUserId             := inUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.21         *
*/

-- тест
--