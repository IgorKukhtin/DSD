-- Function: gpComplete_Movement_Recalc_commerc (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lpComplete_Movement_Recalc_commerc (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpComplete_Movement_Recalc_commerc (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Recalc_commerc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementDescId    Integer  , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbRouteTtId   Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId  Integer;
   DECLARE vbPaidKindId  Integer;
   DECLARE vbOperDatePartner TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- 
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail())
     THEN
         RETURN;
     END IF;


     -- нашли
     vbOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner());
     -- нашли
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     -- нашли
     vbPaidKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());
     -- нашли
     vbPartnerId:= CASE WHEN inMovementDescId = zc_Movement_ReturnIn()
                             THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                        WHEN inMovementDescId = zc_Movement_Sale()
                             THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                   END;
     -- нашли
     vbJuridicalId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Juridical());
     -- нашли
     vbRouteTtId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_RouteTT());


     -- только для ReturnIn
     IF inMovementDescId = zc_Movement_ReturnIn()
     THEN
         vbPriceListId:= (SELECT Object_PriceList.Id AS PriceListId
                          FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                                                    , inPartnerId      := vbPartnerId
                                                                    , inMovementDescId := zc_Movement_ReturnIn()
                                                                    , inOperDate_order := NULL
                                                                    , inOperDatePartner:= vbOperDatePartner
                                                                    , inDayPrior_PriceReturn:= 0
                                                                    , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                                    , inOperDatePartner_order:= NULL
                                                        ) AS tmp
                               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmp.PriceListId
                          LIMIT 1
                         );
         -- сохранили связь с <PriceList>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId);

     END IF;
     
     -- сохранили связь с <RouteTT>
     IF vbRouteTtId > 0
     THEN
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteTT(), inMovementId, vbRouteTtId);
     END IF;
     

     --IF inUserId = 5
     IF 1 = 1
     THEN

     -- Бонусы
     CREATE TEMP TABLE _tmpBonus (-- Договор (условие бонуса)
                                  ContractId_bonus Integer
                                  -- Договор(начисление)
                                , ContractId Integer
                                  -- Вид Условия договора - Только % бонуса за отгрузку-возврат
                                , ContractConditionKindId Integer
                                  -- Вид бонуса
                                , BonusKindId Integer
                                  -- Форма оплаты (Договор начисление)
                                , PaidKindId Integer
                                  -- Форма оплаты
                                , InfoMoneyId Integer
                                  -- % бонуса
                                , BonusValue TFloat
                                 ) ON COMMIT DROP;

     -- Бонусы
     INSERT INTO _tmpBonus (ContractId_bonus, ContractId, ContractConditionKindId, BonusKindId, PaidKindId, InfoMoneyId, BonusValue)
        SELECT
              -- Договор (условие бонуса)
              lpSelect.ContractId_bonus
              -- Договор(начисление)
            , lpSelect.ContractId
              -- Вид Условия договора - Только % бонуса за отгрузку-возврат
            , lpSelect.ContractConditionKindId
              -- Вид бонуса
            , lpSelect.BonusKindId
              -- Форма оплаты (Договор начисление)
            , lpSelect.PaidKindId
              -- 
            , lpSelect.InfoMoneyId
              -- % бонуса
            , lpSelect.BonusValue

        FROM lpSelect_Movement_Recalc_commerc (inContractId := vbContractId
                                             , inJuridicalId:= vbJuridicalId
                                             , inPaidKindId := vbPaidKindId
                                             , inOperDate   := vbOperDatePartner
                                             , inUserId     := vbUserId
                                              ) AS lpSelect;


     -- сохранили <Бонусы>
     PERFORM lpInsertUpdate_MovementItem_Sale_Detail (ioId                      := 0 :: Integer
                                                    , inMovementId              := inMovementId
                                                    , inContractId_bonus        := _tmpBonus.ContractId_bonus
                                                    , inContractId              := _tmpBonus.ContractId
                                                    , inContractConditionKindId := _tmpBonus.ContractConditionKindId
                                                    , inBonusKindId             := _tmpBonus.BonusKindId
                                                    , inPaidKindId              := _tmpBonus.PaidKindId
                                                    , inInfoMoneyId             := _tmpBonus.InfoMoneyId
                                                    , inBonusValue              := _tmpBonus.BonusValue
                                                    , inUserId                  := vbUserId
                                                     )
     FROM _tmpBonus
    ;

     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.26                                        *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Recalc_commerc (inMovementId:= 34407362, inMovementDescId:= zc_Movement_ReturnIn(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Recalc_commerc (inMovementId:= 34334385, inMovementDescId:= zc_Movement_Sale(), inSession:= zfCalc_UserAdmin())
