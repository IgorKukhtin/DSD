DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate       TDateTime;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbUnitId         Integer;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyValue      TFloat;
  DECLARE vbParValue           TFloat;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPartner;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Параметры из документа
     SELECT _tmp.OperDate, _tmp.PartnerId_From, _tmp.UnitId
          , _tmp.CurrencyDocumentId, _tmp.CurrencyValue, _tmp.ParValue
            INTO vbOperDate
               , vbPartnerId_From
               , vbUnitId
               , vbCurrencyDocumentId
               , vbCurrencyValue
               , vbParValue
     FROM (SELECT Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner()    THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId

                , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
                , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
                , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                        ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                       AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                        ON MovementFloat_ParValue.MovementId = Movement.Id
                                       AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Income()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Income()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 08.06.17                                        *
 25.04.17         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())

