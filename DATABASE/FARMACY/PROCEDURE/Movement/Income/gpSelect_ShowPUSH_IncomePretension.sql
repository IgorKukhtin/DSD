-- Function: gpSelect_ShowPUSH_IncomePretension(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_IncomePretension(integer,VarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_IncomePretension(
    IN inMovementID   integer,          -- Приход
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

    IF EXISTS(SELECT  1
              FROM MovementLinkMovement AS MLMovement_Income
              
                   INNER JOIN Movement ON Movement.Id = MLMovement_Income.MovementId
                                      AND Movement.DescId = zc_Movement_Pretension()
                                      AND Movement.StatusId = zc_Enum_Status_UnComplete() 
              
              WHERE MLMovement_Income.MovementChildId = inMovementID
                AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income())
    THEN
    
      WITH tmpMovement AS (SELECT Movement.Id
                                , '№ '||Movement.InvNumber||' от '||to_char(Movement.OperDate, 'DD.MM.YYYY') AS Pretension
                           FROM MovementLinkMovement AS MLMovement_Income
                            
                                INNER JOIN Movement ON Movement.Id = MLMovement_Income.MovementId
                                                   AND Movement.DescId = zc_Movement_Pretension()
                                                   AND Movement.StatusId = zc_Enum_Status_UnComplete() 
                            
                           WHERE MLMovement_Income.MovementChildId = inMovementID
                             AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income()
                          )
         , tnpMI AS (SELECT  Movement_Pretension.Id
                           , string_agg('    '||Object_Goods.ObjectCode::tvarchar||' - '||
                            Object_Goods.ValueData||'; '||zfConvert_FloatToString(MI_Pretension.Amount)||' - '||
                            Object_ReasonDifferences.ValueData, chr(13)) AS MIData
                     FROM tmpMovement AS Movement_Pretension
                          INNER JOIN MovementItem AS MI_Pretension
                                                  ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                 AND MI_Pretension.isErased  = FALSE
                                                 AND MI_Pretension.DescId     = zc_MI_Master()
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Pretension.ObjectId

                          INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                         ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                        AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                        AND MIBoolean_Checked.ValueData = TRUE
    
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                           ON MILinkObject_ReasonDifferences.MovementItemId = MI_Pretension.Id
                                                          AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                          LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
                     GROUP BY Movement_Pretension.Id)   
                          
      SELECT string_agg(Pretension||chr(13)||tnpMI.MIData, chr(13))
      INTO vbText
      FROM tmpMovement
           INNER JOIN tnpMI ON tnpMI.ID = tmpMovement.Id
      ;  

      outShowMessage := True;
      outPUSHType := 3;
      outText := 'ВНИМАНИЕ !!!'||chr(13)||chr(13)||'По этой приходной накладной у вас создана претензия  '||chr(13)||vbText||chr(13)||chr(13)||
                 'Просьба следить за Актуальностью данной претензии !';
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.12.21                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_IncomePretension(26110310, '3')
