-- Function: gpSelect_ShowPUSH_Income_ReturnOut(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_Income_ReturnOut(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_Income_ReturnOut(
    IN inMovementID        integer,          -- Приход
   OUT outShowMessage      Boolean,          -- Показыват сообщение
   OUT outPUSHType         Integer,          -- Тип сообщения
   OUT outText             Text,             -- Текст сообщения
   OUT outSpecialLighting  Boolean ,      -- 
   OUT outTextColor        Integer ,      -- 
   OUT outColor            Integer ,      -- 
   OUT outBold             Boolean ,      -- 
    IN inSession           TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  TVarChar;
BEGIN

    outShowMessage      := False;
    outSpecialLighting  := True;
    outTextColor        := zc_Color_Red();
    outColor            := zc_Color_White();
    outBold             := True;

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_ReturnOut
              WHERE Movement_ReturnOut.ParentId = inMovementID
                AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
                AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut())
    THEN

       WITH tmpMI AS (SELECT Movement_ReturnOut.Id,
                             string_agg('     '||Object_Goods.ObjectCode||' - '||Object_Goods.ValueData, chr(13)) AS ValueData
                       FROM Movement AS Movement_ReturnOut
                       
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement_ReturnOut.Id

                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                       WHERE Movement_ReturnOut.ParentId = inMovementID
                         AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
                         AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut()
                       GROUP BY Movement_ReturnOut.Id)
                           
       SELECT string_agg('Номер '||Movement_ReturnOut.InvNumber||' дата '||TO_CHAR (Movement_ReturnOut.OperDate, 'dd.mm.yyyy')||COALESCE(CHR(13)||tmpMI.ValueData, ''), CHR(13) ORDER BY Movement_ReturnOut.OperDate)
       INTO vbText
       FROM Movement AS Movement_ReturnOut
       
            LEFT JOIN tmpMI ON tmpMI.ID = Movement_ReturnOut.Id
            
       WHERE Movement_ReturnOut.ParentId = inMovementID
         AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
         AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut();

      outShowMessage := True;
      outPUSHType := zc_TypePUSH_Confirmation();
      outText := 'По приходу '||(SELECT Movement.InvNumber FROM Movement WHERE Movement.ID = inMovementID)||
                 ' созданы возвраты:'||CHR(13)||COALESCE(vbText, '');
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.08.22                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_Income_ReturnOut(29092124, '3')