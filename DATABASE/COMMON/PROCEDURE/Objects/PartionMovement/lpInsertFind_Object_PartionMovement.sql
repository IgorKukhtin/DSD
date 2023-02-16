-- Function: lpInsertFind_Object_PartionMovement (Integer, TDateTime)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionMovement (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovement(
    IN inMovementId   Integer,   -- ссылка на документ
    IN inPaymentDate  TDateTime  -- ссылка на документ
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionMovementId Integer;
   DECLARE vbContractId        Integer;
   DECLARE vbOperDatePartner   TDateTime;
BEGIN

   --
   IF COALESCE (inMovementId, 0) = 0
   THEN
       vbPartionMovementId:= 0; -- !!!будет без партий, и элемент с пустой партией не создается!!!

   ELSE
       -- Находим
       vbPartionMovementId:= (SELECT ObjectId FROM ObjectFloat WHERE ValueData = inMovementId AND DescId = zc_ObjectFloat_PartionMovement_MovementId());

       IF COALESCE (vbPartionMovementId, 0) = 0
       THEN
           -- сохранили <Объект>
           vbPartionMovementId:= (SELECT lpInsertUpdate_Object (vbPartionMovementId, zc_Object_PartionMovement(), 0, zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)))
                                  FROM Movement
                                       LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                       LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                              ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                             AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                  WHERE Movement.Id = inMovementId
                                 );
           -- сохранили
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionMovement_MovementId(), vbPartionMovementId, inMovementId :: TFloat);

           -- проверка
           IF inPaymentDate IS NULL
           THEN
               --
               vbOperDatePartner:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner());
               --
               vbContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());

               --
               inPaymentDate:= (SELECT tmp.OperDate + (tmp.OperDate - zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), COALESCE (Value, 0) :: Integer, tmp.OperDate))
                                FROM (SELECT vbOperDatePartner AS OperDate) AS tmp
                                     LEFT JOIN Object_ContractCondition_View
                                            ON Object_ContractCondition_View.ContractId = vbContractId
                                           AND Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                           AND Object_ContractCondition_View.Value <> 0
                                           AND vbOperDatePartner BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                               );
               --
               IF inPaymentDate IS NULL
               THEN
                   RAISE EXCEPTION 'Ошибка.Партия накладной № <%> от <%> не найдена.'
                                  , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                                   , zfConvert_DateToString ((SELECT MovementDate.ValueData FROM MovementDate WHERE  MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner()))
                                   ;
               END IF;

           END IF;

       END IF;

       -- сохранили !!!почти всегда!!!
       IF inPaymentDate IS NOT NULL
       THEN PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionMovement_Payment(), vbPartionMovementId, inPaymentDate);
       END IF;

   END IF;

   -- Возвращаем значение
   RETURN (vbPartionMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionMovement (Integer, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.04.15                                        * add
 26.04.15                                        * all
 13.02.14                                        * !!!будем без партий!!! но по другому
 27.09.13                                        * !!!будем без партий!!!
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionMovement (inMovementId:= 123, inPaymentDate:= NULL)
