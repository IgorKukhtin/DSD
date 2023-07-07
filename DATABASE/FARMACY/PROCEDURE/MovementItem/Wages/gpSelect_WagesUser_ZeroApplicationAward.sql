-- Function: gpSelect_MovementItem_WagesMoneyBoxSun()

DROP FUNCTION IF EXISTS gpSelect_WagesUser_ZeroApplicationAward (Integer, Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_WagesUser_ZeroApplicationAward(
    IN inMovementId      Integer      , -- ключ Документа
    IN inUserId          Integer      , -- Сотрудник
   OUT outisResetZero    Boolean      , -- Обнулялось
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    
    outisResetZero := False;

    SELECT Movement.OperDate
    INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;
        
    CREATE TEMP TABLE _tmpUserWages ON COMMIT DROP AS
    SELECT Movement.OperDate
         , MovementItem.Id
         , MIFloat_ApplicationAward.ValueData AS ApplicationAward
    FROM Movement 
    
         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id 
                                AND MovementItem.ObjectId = inUserId
                                AND MovementItem.isErased = False
                                AND MovementItem.DescId = zc_MI_Master()

         LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                     ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                    AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()
    
    WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 YEAR' AND vbOperDate
      AND Movement.DescId = zc_Movement_Wages()
      AND Movement.StatusId <> zc_Enum_Status_Erased();
      
    ANALYSE _tmpUserWages;
        
    CREATE TEMP TABLE _tmpProtocol ON COMMIT DROP AS
    WITH
    tmpProtocol AS (SELECT MovementItemProtocol.MovementItemId
                         , CASE WHEN MovementItemProtocol.ProtocolData ILIKE '%Штраф за моб. приложение%' 
                                THEN SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Штраф за моб. приложение' IN MovementItemProtocol.ProtocolData) + 40, 50)
                                ELSE '0"' END AS ApplicationAward
                    FROM _tmpUserWages 
                    
                         INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = _tmpUserWages.Id)
      
    SELECT tmpProtocol.MovementItemId
         , SUBSTRING(tmpProtocol.ApplicationAward, 1, POSITION('"' IN tmpProtocol.ApplicationAward) - 1)::TFloat AS ApplicationAward
    FROM tmpProtocol
    WHERE SUBSTRING(tmpProtocol.ApplicationAward, 1, POSITION('"' IN tmpProtocol.ApplicationAward) - 1)::TFloat <> 0;
    
    ANALYSE _tmpProtocol;
    
    IF EXISTS(SELECT 1
              FROM _tmpUserWages 
                   INNER JOIN _tmpProtocol ON _tmpProtocol.MovementItemId = _tmpUserWages.Id
              WHERE _tmpUserWages.ApplicationAward = 0
              )
    THEN
      outisResetZero := True;
      
      RAISE EXCEPTION 'Ошибка. Ранее по сотруднику <%> в месяце <%> был штраф за работу с мобильным приложением. Повторное обнуление штрафа запрещено!.'
         , (SELECT Object.ValueData FROM Object WHERE Object.ID = inUserId)
         , zfCalc_MonthYearName((SELECT _tmpUserWages.OperDate 
                                 FROM _tmpUserWages 
                                      INNER JOIN _tmpProtocol ON _tmpProtocol.MovementItemId = _tmpUserWages.Id
                                 WHERE _tmpUserWages.ApplicationAward = 0
                                 ORDER BY _tmpUserWages.OperDate DESC
                                 LIMIT 1));
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.07.23                                                        *
*/
-- 
select * from gpSelect_WagesUser_ZeroApplicationAward(inMovementId := 32588552 , inUserId := 5851320,  inSession := '3');