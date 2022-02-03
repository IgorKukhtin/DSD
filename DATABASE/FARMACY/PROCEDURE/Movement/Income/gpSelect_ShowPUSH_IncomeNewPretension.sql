-- Function: gpSelect_ShowPUSH_IncomeNewPretension(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_IncomeNewPretension(integer, VarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_IncomeNewPretension(
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
   DECLARE vbText  Text;
BEGIN

    outShowMessage      := False;
    outSpecialLighting  := True;
    outTextColor        := zc_Color_Red();
    outColor            := zc_Color_White();
    outBold             := True;

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
                          
      SELECT string_agg(Pretension||chr(13), chr(13))
      INTO vbText
      FROM tmpMovement
      ;  

      IF COALESCE (vbText, '') <> ''
      THEN
        outShowMessage := True;
        outPUSHType := zc_TypePUSH_Confirmation();
        outText := 'ВНИМАНИЕ !!!'||chr(13)||chr(13)||'По данной приходной накладной уже была ранее создана претензия'||chr(13)||COALESCE (vbText, '')||chr(13)||chr(13)||
                   'Проверьте ее Актуальность!';
      END IF;
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.12.21                                                       *

*/

-- 

select * from gpSelect_ShowPUSH_IncomeNewPretension(inMovementID := 26650600 ,  inSession := '3');