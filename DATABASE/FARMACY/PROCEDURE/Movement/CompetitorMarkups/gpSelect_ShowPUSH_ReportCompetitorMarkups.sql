-- Function: gpSelect_ShowPUSH_ReportCompetitorMarkups(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_ReportCompetitorMarkups(integer,VarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_ReportCompetitorMarkups(
    IN inOperDate     TDateTime,        -- Приход
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    outShowMessage := False;

    WITH
      tmpMovement AS (SELECT Movement.Id                              AS ID
                           , Movement.StatusId                        AS StatusId
                           , Movement.OperDate                        AS OperDate
                           , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                      FROM Movement
                      WHERE Movement.OperDate <= inOperDate
                        AND Movement.DescId = zc_Movement_CompetitorMarkups()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                      )
    
    SELECT Movement.Id, Movement.StatusId
    INTO vbMovementId, vbStatusId
    FROM tmpMovement AS Movement 
    WHERE Movement.Ord = 1;
      
    IF vbStatusId <> zc_Enum_Status_Complete()
    THEN
      outShowMessage := True;
      outPUSHType := zc_TypePUSH_Confirmation();
      outText := 'Идёт ввод актуальных цен по конкурентам. Открыть предыдущий срез?';
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.22                                                       *

*/

-- 

SELECT * FROM gpSelect_ShowPUSH_ReportCompetitorMarkups('20.05.2022', '3')
