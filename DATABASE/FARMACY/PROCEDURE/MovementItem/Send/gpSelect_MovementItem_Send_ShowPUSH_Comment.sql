-- Function: gpSelect_MovementItem_Send_ShowPUSH_Comment(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send_ShowPUSH_Comment(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send_ShowPUSH_Comment(
    IN inCommentSendId  integer,          -- Коммент
   OUT outShowMessage   Boolean,          -- Показыват сообщение
   OUT outPUSHType      Integer,          -- Тип сообщения
   OUT outText          Text,             -- Текст сообщения
    IN inSession        TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbName  TVarChar;
   DECLARE vbJuridical Integer;
BEGIN

  outShowMessage := False;

  IF COALESCE(inCommentSendId, 0) = 15180138
  THEN
    outShowMessage := True;
    outPUSHType := 3;
    outText := 'В обязательном порядке перешлите фото на Калинину Кристину и тогда зануление пройдет без штрафа';
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.09.20                                                       *

*/

-- SELECT * FROM gpSelect_MovementItem_Send_ShowPUSH(183292,'3')

select * from gpSelect_MovementItem_Send_ShowPUSH_Comment(inCommentSendId := 7117700 ,  inSession := '3');

