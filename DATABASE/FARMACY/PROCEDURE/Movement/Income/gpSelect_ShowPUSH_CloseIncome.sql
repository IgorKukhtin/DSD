-- Function: gpSelect_ShowPUSH_CloseIncome(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_CloseIncome(integer,integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_CloseIncome(
    IN inMovementID   integer,          -- Приход
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbInvNumber   TVarChar;
   DECLARE vbStatusId    Integer; 
   DECLARE vbToId        Integer;
   DECLARE vbTelegramId  TVarChar;
   DECLARE vbisConduct   Boolean;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

  vbUserId:= lpGetUserBySession (inSession);

  outShowMessage := False;
    
  -- Если не кассир
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_CashierPharmacy()))
  THEN
    RETURN;
  END IF;
   

  -- определяется
  SELECT
      InvNumber  
    , StatusId
    , MovementLinkObject_To.ObjectId      AS ToId
    , ObjectString_Unit_TelegramId.ValueData 
    , COALESCE (MovementBoolean_Conduct.ValueData, FALSE) 
  INTO
      vbInvNumber
    , vbStatusId
    , vbToId
    , vbTelegramId
    , vbisConduct
  FROM Movement
       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
       LEFT JOIN MovementBoolean AS MovementBoolean_Conduct
                                 ON MovementBoolean_Conduct.MovementId = Movement.Id
                                AND MovementBoolean_Conduct.DescId = zc_MovementBoolean_Conduct()
       LEFT JOIN ObjectString AS ObjectString_Unit_TelegramId
                              ON ObjectString_Unit_TelegramId.ObjectId = MovementLinkObject_To.ObjectId
                             AND ObjectString_Unit_TelegramId.DescId = zc_ObjectString_Unit_TelegramId()
  WHERE Id = inMovementId;   

  IF vbToId NOT IN (377595, 377574, 1529734, 8156016)
  THEN
    RETURN;
  END IF;

  IF vbStatusId <> zc_Enum_Status_UnComplete() OR COALESCE (vbTelegramId, '') = '' OR vbisConduct = TRUE
  THEN
    RETURN;
  END IF;
  
  IF EXISTS (SELECT 1 FROM MovementItem
                 INNER JOIN MovementItemFloat AS MIFloat_AmountManual
                                              ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                             AND MIFloat_AmountManual.ValueData > 0
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.isErased   = False
               AND MovementItem.DescId     = zc_MI_Master()) AND
     EXISTS (SELECT 1 FROM MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                            ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.isErased   = False
              AND MovementItem.DescId     = zc_MI_Master()
              AND COALESCE (MIFloat_AmountManual.ValueData, 0) = 0)
  THEN
     outShowMessage := True;
     outPUSHType := 3;
     outText := 'В накладной <'||vbInvNumber||'> есть позиции, которые можно загрузить на остаток, воспользуйтесь частичной проводкой.'||Chr(13)||Chr(13)||
                'После этого вам будет выслан отчёт для подачи претензии о недовозе.';
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.11.21                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_CloseIncome(inMovementID := 25504550  ,inSession := '3')