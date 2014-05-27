-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS void
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbCloseDate TDateTime;
BEGIN
  -- проверка <Зарегестрирован>
  IF EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Registered() AND ValueData = TRUE)
  THEN
      RAISE EXCEPTION 'Ошибка.Документ зарегестрирован.<Удаление> невозможно.';
  END IF;


  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId
  RETURNING OperDate INTO vbOperDate;


  -- определяется дата для <Закрытие периода>
  SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END
         INTO vbCloseDate
  FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
             , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
        FROM PeriodClose
        -- select * FROM PeriodClose where Period = interval '1 day'
             LEFT JOIN ObjectLink_UserRole_View AS View_UserRole
                                                ON View_UserRole.RoleId = PeriodClose.RoleId
                                               AND View_UserRole.UserId = inUserId
        WHERE View_UserRole.UserId = inUserId OR PeriodClose.RoleId IS NULL
       ) AS tmp;
            
  -- проверка прав для <Закрытие периода>
  IF vbOperDate < vbCloseDate
  THEN 
       RAISE EXCEPTION 'Ошибка.Изменения за <%> не возможны.Период закрыт до <%>.', TO_CHAR (vbOperDate, 'DD.MM.YYYY'), TO_CHAR (vbCloseDate, 'DD.MM.YYYY');
  END IF;


  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);
  -- Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemReport (inMovementId);


  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.14                                        * add проверка прав для <Закрытие периода>
 10.05.14                                        * add проверка <Зарегестрирован>
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- тест
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
