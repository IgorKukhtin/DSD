-- Function: gpSelect_ShowPUSH_TechnicalRediscount(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_TechnicalRediscount(integer,integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_TechnicalRediscount(
    IN inMovementID   integer,          -- Id документа
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

   IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementID)
   THEN
     outShowMessage := False;
     RETURN;
   END IF;
   
      outShowMessage := True;
      outPUSHType := 3;
      outText := 'СПИСАНИЕ СРОКОВ ПРИ ПОМОЩИ ТЕХ.ПЕРЕУЧЁТА!!!
Если Вам необходимо списать сроки ПРИ ПОМОЩИ КОПИЛКИ, то делаете тех.переучёт в минус (если сумма полного списания меньше суммы копилки)!
Если Вам необходимо списать сроки ЗА СЧЁТ ПОДАРКОВ МЕД.ПРЕДСТАВИТЕЛЕЙ, то делаете это непосредственно!!! в тех.переучёте! При этом в колонке "Пояснение" В ОБЯЗАТЕЛЬНОМ ПОРЯДКЕ УКАЗЫВАЕТЕ ЗА КАКОЙ ИМЕННО СРОК ДАННЫЙ ПОДАРОК!!!
Если Вы осуществляете возврат/обмен клиента, то В ОБЯЗАТЕЛЬНОМ ПОРЯДКЕ ПРЕДОСТАВЛЯЕТЕ ЗАЯВЛЕНИЕ И ЧЕК (ФОТО ЧЕКА)!!!
Все НЕДОСТАЧИ и ИЗЛИШКИ должны быть ВНИМАТЕЛЬНО проверены на наличие пересортов!!!
Прежде чем пробивать или списывать НЕДОСТАЧУ, ВНИМАТЕЛЬНО проверьте все полки и ящики, возможно препарат лежит в другом месте, в другой фарм.группе!!!';

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.08.20                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_TechnicalRediscount(inMovementID := 19447685 , inSession := '3')


select * from gpSelect_ShowPUSH_TechnicalRediscount(inMovementID := 21332817 ,  inSession := '3999200');