-- Function: gpSelect_Income_SendTelegram(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Income_SendTelegram(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Income_SendTelegram(
    IN inMovementID         integer,          -- Приход
   OUT outTelegramId        TVarChar ,        -- ID аптеки
   OUT outTelegramBotToken  TVarChar ,        -- Токен телеграм бота
   OUT outisSend            Boolean  ,        -- отправлять
   OUT outMessage           Text     ,        -- отправлять
    IN inSession            TVarChar          -- сессия пользователя
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
   DECLARE vbMessage     Text;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

  vbUserId:= lpGetUserBySession (inSession);

  outisSend := False;
    
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

  SELECT ObjectString_CashSettings_TelegramBotToken.ValueData                     AS TelegramBotToken
  INTO outTelegramBotToken
  FROM Object AS Object_CashSettings
       LEFT JOIN ObjectString AS ObjectString_CashSettings_TelegramBotToken
                              ON ObjectString_CashSettings_TelegramBotToken.ObjectId = Object_CashSettings.Id 
                             AND ObjectString_CashSettings_TelegramBotToken.DescId = zc_ObjectString_CashSettings_TelegramBotToken()

  WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
  LIMIT 1;
   
  IF vbStatusId <> zc_Enum_Status_UnComplete() OR COALESCE (vbTelegramId, '') = '' OR vbisConduct = FALSE OR COALESCE (outTelegramBotToken, '') = '' 
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
              AND COALESCE (MIFloat_AmountManual.ValueData, 0) < MovementItem.Amount)
  THEN
     outisSend := False;
     
     IF vbUserId = 3 
     THEN
       vbTelegramId := '568330367';
     ELSEIF vbUserId = 4183126 
     THEN
       vbTelegramId := '300408824';     
     END IF;
     
     SELECT
         COALESCE (Object_Juridical.ValueData, '')||Chr(13)|| 
         COALESCE (Object_To.ValueData, '')||Chr(13)|| 
         COALESCE (Object_From.ValueData, '')||' №'||Movement.InvNumber||' от '||TO_CHAR(Movement.OperDate, 'DD.MM.YYYY')||Chr(13)||Chr(13)
     INTO
         outMessage
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
     WHERE Movement.Id = inMovementId;   
     
     SELECT string_agg(Object_Goods.ValueData||' -'||zfConvert_FloatToString(MovementItem.Amount - COALESCE (MIFloat_AmountManual.ValueData, 0)), Chr(13))
     INTO vbMessage
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                      ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased   = False
        AND MovementItem.DescId     = zc_MI_Master()
        AND COALESCE (MIFloat_AmountManual.ValueData, 0) < MovementItem.Amount;
        
     outMessage := outMessage || COALESCE (vbMessage, '');
     outTelegramId := vbTelegramId;
     outisSend := True;
     
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
SELECT * FROM gpSelect_Income_SendTelegram(inMovementID := 25504550   ,inSession := '3')