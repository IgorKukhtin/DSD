-- Function: gpSelect_ShowCompilePUSH_Inventory(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowCompilePUSH_Inventory(integer, integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowCompilePUSH_Inventory(
    IN inMovementID   integer,          -- ID инвентаризации
    IN inUnitID       integer,          -- Подразделение
    IN inOperDate     TDateTime,        -- Дата
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
BEGIN

  outShowMessage := False;
  vbText := '';

/*  IF inSession <> '3'
  THEN
    RETURN;
  END IF;
*/
  SELECT string_agg('Номер '||CASE Movement.DescId WHEN zc_Movement_ReturnOut() THEN 'возврата поставщику'
                                                   WHEN zc_Movement_Sale() THEN 'продажа' ELSE 'перемещения' END||' '
                            ||Movement.InvNumber||' дата '||TO_CHAR (Movement.OperDate, 'dd.mm.yyyy'), CHR(13) ORDER BY Movement.OperDate)
  INTO vbText
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                                    AND MovementLinkObject_Unit.ObjectId = inUnitID

       INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()


  WHERE Movement.DescId in (zc_Movement_ReturnOut(), zc_Movement_Send(), zc_Movement_Sale())
    AND Movement.StatusId = zc_Enum_Status_UnComplete()
    AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE
    AND Movement.OperDate <= DATE_TRUNC ('DAY', inOperDate) + INTERVAL '1 DAY';


  IF COALESCE(vbText, '') <> ''
  THEN
    outShowMessage := True;
    outPUSHType := zc_TypePUSH_Confirmation();
    outText := 'По подразделению есть отложенные перемещения, возвраты поставщику или продажи датой инвентаризации или ранее. Необходимо их переотложить датой познее даты инвентаризации т.к. они могут исказить результат инвентаризации.'||CHR(13)||vbText;
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.12.19                                                       *

*/

-- SELECT * FROM gpSelect_ShowCompilePUSH_Inventory(17001222, 183292, '26.12.2019' , '3')