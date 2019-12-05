-- Function: gpInsert_MovementItem_Loyalty_GUID()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Loyalty_GUID (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Loyalty_GUID(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
   OUT outGUID               TVarChar  , -- Ключ объекта <Документ>
   OUT outAmount             TFloat    , -- Сумма скидки
   OUT outDateEnd            TVarChar  , -- Дата окончания действия
   OUT outMessage            TVarChar  , -- Сообщение
    IN inComment             TVarChar  , -- примечание
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbInvNumber Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbStatusId Integer;
   DECLARE vbMonthCount Integer;
   DECLARE vbComment TVarChar;
   DECLARE vbStartPromo TDateTime;
   DECLARE vbEndPromo TDateTime;
   DECLARE vbChangePercent TFloat;
   DECLARE vbServiceDate TDateTime;
   DECLARE vbIsInsert Boolean;
   DECLARE vbLimit TFloat;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    outMessage :='';

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    SELECT Movement.InvNumber::Integer, Movement.StatusId, 
           MovementDate_StartPromo.ValueData, 
           MovementDate_EndPromo.ValueData,
           COALESCE(MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent,
           MovementDate_ServiceDate.ValueData                 AS ServiceDate,
           MovementFloat_MonthCount.ValueData::Integer  
    INTO vbInvNumber, vbStatusId, vbStartPromo, vbEndPromo, vbChangePercent, vbServiceDate, vbMonthCount
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement.Id
                               AND MovementDate_StartPromo.DescID = zc_MovementDate_StartPromo()
         LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId = Movement.Id
                               AND MovementDate_EndPromo.DescID = zc_MovementDate_EndPromo()
         LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                ON MovementDate_ServiceDate.MovementId = Movement.Id
                               AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
         LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                 ON MovementFloat_MonthCount.MovementId =  Movement.Id
                                AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()
    WHERE Movement.ID = inMovementId;

    IF COALESCE(vbChangePercent, 0) > 0 AND COALESCE(vbServiceDate, CURRENT_DATE - INTERVAL '1 DAY') <> CURRENT_DATE
    THEN
      PERFORM gpInsertUpdate_MovementItem_Loyalty_Accrual(inMovementId , inSession);
    END IF;

     -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN

        -- Если документ неподписан или неподходят даты то неформируем
        IF vbStatusId <> zc_Enum_Status_Complete() OR
           vbStartPromo > CURRENT_DATE OR
           vbEndPromo < CURRENT_DATE
        THEN
          RETURN;
        END IF;
        
        IF COALESCE((SELECT MovementLinkObject_Retail.ObjectId FROM MovementLinkObject AS MovementLinkObject_Retail
                     WHERE MovementLinkObject_Retail.MovementId = inMovementId
                       AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()), 0) <> COALESCE (vbRetailId, 0)
        THEN
          RETURN;
        END IF;

        -- Если аптека невходит
        IF NOT EXISTS(SELECT 1 FROM MovementItem AS MI_Loyalty
                      WHERE MI_Loyalty.MovementId = inMovementId
                        AND MI_Loyalty.DescId = zc_MI_Child()
                        AND MI_Loyalty.isErased = FALSE
                        AND MI_Loyalty.Amount = 1
                        AND MI_Loyalty.ObjectId = vbUnitId)
        THEN
          RETURN;
        END IF;

        IF COALESCE(vbChangePercent, 0) > 0
        THEN
          
          SELECT MI_Loyalty.Amount
          INTO vbLimit
          FROM MovementItem AS MI_Loyalty

               INNER JOIN MovementItemDate AS MIDate_OperDate
                                           ON MIDate_OperDate.MovementItemId =  MI_Loyalty.Id
                                          AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

          WHERE MI_Loyalty.MovementId = inMovementId
            AND MI_Loyalty.DescId = zc_MI_Second()
            AND MIDate_OperDate.ValueData = CASE WHEN date_part('DAY', CURRENT_DATE)::Integer = 1
                                                 THEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '2 DAY')
                                                 ELSE DATE_TRUNC ('MONTH', CURRENT_DATE) END;       
                    
          SELECT COALESCE(vbLimit, 0) - COALESCE(SUM(MI_Sign.Amount), 0)
          INTO vbLimit
          FROM MovementItem AS MI_Sign
               LEFT JOIN MovementItemDate AS MIDate_OperDate
                                          ON MIDate_OperDate.MovementItemId =  MI_Sign.Id
                                          AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
          WHERE MI_Sign.MovementId = inMovementId
            AND MI_Sign.DescId = zc_MI_Sign()
            AND MI_Sign.isErased = FALSE
            AND MIDate_OperDate.ValueData > CASE WHEN date_part('DAY', CURRENT_DATE)::Integer = 1
                                                 THEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '2 DAY')
                                                 ELSE DATE_TRUNC ('MONTH', CURRENT_DATE) END
            AND MIDate_OperDate.ValueData < CASE WHEN date_part('DAY', CURRENT_DATE)::Integer = 1
                                                 THEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '2 DAY')
                                                 ELSE DATE_TRUNC ('MONTH', CURRENT_DATE) END + INTERVAL '1 MONTH';
          
        END IF;

        -- Определякм сумму скидки
        WITH DD AS (SELECT ROW_NUMBER()OVER(ORDER BY MI_Loyalty.Amount, MIFloat_Count.ValueData) as ORD
                         , MI_Loyalty.Amount
                         , MIFloat_Count.ValueData::Integer  AS Count
                    FROM MovementItem AS MI_Loyalty

                         LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                     ON MIFloat_Count.MovementItemId = MI_Loyalty.Id
                                                    AND MIFloat_Count.DescId = zc_MIFloat_Count()

                    WHERE MI_Loyalty.MovementId = inMovementId
                      AND MI_Loyalty.DescId = zc_MI_Master()
                      AND MI_Loyalty.isErased = FALSE
                      AND MI_Loyalty.Amount > 0 
                      AND COALESCE(MIFloat_Count.ValueData, 0) > 0)
           , CC AS (SELECT Sum(Count) AS Options FROM DD)
           , SS AS (SELECT count(*)                         AS CountDay
                         , COALESCE(SUM(CASE WHEN MI_Sign.ObjectId = vbUnitId THEN MI_Sign.Amount ELSE 0 END), 0) AS SummDay
                    FROM MovementItem AS MI_Sign
                         INNER JOIN MovementItemDate AS MIDate_OperDate
                                                     ON MIDate_OperDate.MovementItemId = MI_Sign.Id
                                                    AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                                    AND MIDate_OperDate.ValueData  = CURRENT_DATE
                    WHERE MI_Sign.MovementId = inMovementId
                      AND MI_Sign.DescId = zc_MI_Sign()
                      AND MI_Sign.isErased = FALSE)
           , MM AS (SELECT COALESCE(NULLIF(MIFloat_DayCount.ValueData, 0), MovementFloat_DayCount.ValueData, 0)::Integer  AS DayCount
                         , COALESCE(NULLIF(MIFloat_Limit.ValueData, 0), MovementFloat_Limit.ValueData, 0)::TFloat      AS SummLimit
                    FROM Movement

                         LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                                 ON MovementFloat_DayCount.MovementId =  Movement.Id
                                                AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
                         LEFT JOIN MovementFloat AS MovementFloat_Limit
                                                 ON MovementFloat_Limit.MovementId =  Movement.Id
                                                AND MovementFloat_Limit.DescId = zc_MovementFloat_Limit()

                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId = zc_MI_Child()
                                               AND MovementItem.ObjectId = vbUnitId
                                               AND MovementItem.isErased = FALSE
                         LEFT JOIN MovementItemFloat AS MIFloat_DayCount
                                                     ON MIFloat_DayCount.MovementItemId =  MovementItem.Id
                                                     AND MIFloat_DayCount.DescId = zc_MIFloat_DayCount()
                         LEFT JOIN MovementItemFloat AS MIFloat_Limit
                                                     ON MIFloat_Limit.MovementItemId =  MovementItem.Id
                                                    AND MIFloat_Limit.DescId = zc_MIFloat_Limit()

                    WHERE Movement.Id = inMovementId)


        SELECT CASE WHEN (SS.CountDay < MM.DayCount OR MM.DayCount = 0) AND
                         (SS.SummDay < MM.SummLimit OR MM.SummLimit = 0) THEN D1.Amount ELSE 0 END
        INTO vbAmount
        FROM DD AS D1
             INNER JOIN CC ON 1 = 1
             INNER JOIN SS ON 1 = 1
             INNER JOIN MM ON 1 = 1
        WHERE COALESCE((SELECT SUM(D0.Count) FROM DD AS D0 WHERE D0.ORD < D1.ORD), 0) <= (SS.CountDay % CC.Options)
        ORDER BY ORD DESC
        LIMIT 1;

        -- Если сумма неполучена
        IF COALESCE(vbAmount, 0) = 0
        THEN
          RETURN;
        END IF;
                
        -- Если месячный лимит
        IF COALESCE(vbChangePercent, 0) > 0 AND COALESCE(vbLimit, 0) < vbAmount
        THEN
          outMessage := 'Лимит по программе лояльности исчерпан...';
          RETURN;
        END IF;
        
        -- сохранили <Элемент документа>
        ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), vbUnitId, inMovementId, COALESCE(vbAmount, 0), NULL, zc_Enum_Process_Auto_PartionClose());

        -- Сформировали промокод
        outGUID := TO_CHAR(CURRENT_DATE, 'MMYY')||'-';

        vbUnitKey := to_hex((random() * 65535)::Integer);
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        outGUID := outGUID||vbUnitKey||'-';

        vbUnitKey := to_hex((random() * 65535)::Integer);
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        outGUID := outGUID||vbUnitKey||'-';

        vbUnitKey := to_hex((random() * 65535)::Integer);
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        outGUID := upper(outGUID||vbUnitKey);

        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, outGUID);
        PERFORM lpInsertUpdate_MovementItem_Loyalty_GUID (ioId, outGUID, vbUserId);

        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, CURRENT_DATE);

        -- сохранили свойство <Примечание>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

        -- сохранили связь с <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
    END IF;

    SELECT MovementItem.Amount, 
           MIString_GUID.ValueData, 
           TO_CHAR(MIDate_OperDate.ValueData + (vbMonthCount||' MONTH' ) ::INTERVAL, 'DD.MM.YYYY') :: TVarChar,
           MIString_Comment.ValueData
    INTO outAmount, outGUID, outDateEnd, vbComment
    FROM MovementItem
         LEFT JOIN MovementItemString AS MIString_GUID
                                      ON MIString_GUID.MovementItemId = MovementItem.Id
                                     AND MIString_GUID.DescID = zc_MIString_GUID()
         LEFT JOIN MovementItemString AS MIString_Comment
                                      ON MIString_Comment.MovementItemId = MovementItem.Id
                                     AND MIString_Comment.DescID = zc_MIString_Comment()
         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                    ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
    WHERE MovementItem.Id = ioId;

    IF vbIsInsert = FALSE AND COALESCE(vbComment, '') <> COALESCE(inComment, '')
    THEN

        -- сохранили свойство <Примечание>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

        -- сохранили связь с <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, vbUserId);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
    END IF;
    
/*    IF inSession = '3'
    THEN
      RAISE EXCEPTION 'Ошибка. Прошло...';
    END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.11.19                                                       *
 */

-- zfCalc_FromHex

-- SELECT * FROM gpInsert_MovementItem_Loyalty_GUID (0, 16406918, '', '3');