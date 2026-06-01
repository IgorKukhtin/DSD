-- Function: lpComplete_Movement_Recalc_commerc (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Recalc_commerc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Recalc_commerc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementDescId    Integer  , --
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbRouteTtId   Integer;
   DECLARE vbJuridicalId Integer;
BEGIN
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
                          FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                    , inPartnerId      := vbPartnerId
                                                                    , inMovementDescId := zc_Movement_ReturnIn()
                                                                    , inOperDate_order := NULL
                                                                    , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
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
     

     -- Бонусы
     CREATE TEMP TABLE _tmpBonus (-- Договор (условие бонуса)
                                  ContractId_bonus Integer
                                  -- Договор(начисление)
                                , ContractId Integer
                                  -- Условие договора - Только % бонуса за отгрузку-возврат
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
     CREATE TEMP TABLE _tmpBonus (ContractId_bonus, ContractId, ContractConditionKindId, BonusKindId, PaidKindId, InfoMoneyId, BonusValue)



END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.26                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Recalc_commerc (inMovementId:= 34407362, inMovementDescId:= zc_Movement_ReturnIn(), inUserId:= zfCalc_UserAdmin() :: Integer)
