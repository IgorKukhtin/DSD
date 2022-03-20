-- Function: lpInsert_Movement_Tax_isAutoPrepay()

DROP FUNCTION IF EXISTS lpInsert_Movement_Tax_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Tax_isAutoPrepay(
    IN inId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch     TVarChar  , -- Номер филиала
    IN inOperDate            TDateTime , -- Дата документа
    IN inisAuto              Boolean   , -- Автоматически
    IN inChecked             Boolean   , -- Проверен
    IN inDocument            Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inAmount              TFloat    , -- сумма предоплаты
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartnerId           Integer   , -- Контрагент
    IN inContractId          Integer   , -- Договора
    IN inDocumentTaxKindId   Integer   , -- Тип формирования налогового документа
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
BEGIN

    -- сохранили документ
    SELECT tmp.ioId
           INTO inId
    FROM lpInsertUpdate_Movement_Tax (inId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                    , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                    , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, inUserId
                                     ) AS tmp;    

    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId
                                         , (SELECT STRING_AGG (Object_PersonalCollation.ValueData, ';')
                                            FROM (SELECT DISTINCT ObjectLink_Contract_PersonalCollation.ChildObjectId AS PersonalId_collation
                                                  FROM Object_Contract_View
                                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                                                            ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract_View.ContractId 
                                                                           AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
                                                  WHERE Object_Contract_View.JuridicalId = inToId
                                                    AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                    AND Object_Contract_View.InfoMoneyId         = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                    AND Object_Contract_View.isErased            = FALSE
                                                    
                                                 ) AS tmp
                                                 LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = tmp.PersonalId_collation
                                           )
                                          );

    -- сохранили свойство <Автоматически>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inisAuto);

    --строка документа 
    PERFORM lpInsertUpdate_MovementItem_Tax (ioId                 := 0
                                           , inMovementId         := inId
                                           , inGoodsId            := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = 4 AND Object.DescId = zc_Object_Goods())
                                           , inAmount             := inAmount
                                           , inPrice              := 1
                                           , ioCountForPrice      := 1
                                           , inGoodsKindId        := NULL
                                           , inUserId             := inUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.21         *
*/

-- тест
--