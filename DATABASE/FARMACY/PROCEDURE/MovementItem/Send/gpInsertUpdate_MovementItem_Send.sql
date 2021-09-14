-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена Усред. закуп.
    IN inPriceUnitFrom       TFloat    , -- Цена отправителя
 INOUT ioPriceUnitTo         TFloat    , -- Цена получателя
   OUT outSumma              TFloat    , -- Сумма
   OUT outSummaUnitTo        TFloat    , -- Сумма в ценах получателя
    IN inAmountManual        TFloat    , -- Кол-во ручное
    IN inAmountStorage       TFloat    , -- Факт кол-во точки-отправителя
   OUT outAmountDiff         TFloat    , -- Загружаемое кол-во  минус  Факт кол-во точки-получателя
   OUT outAmountStorageDiff  TFloat    , -- Загружаемое кол-во  минус  Факт кол-во точки-отправителя
    IN inReasonDifferencesId Integer   , -- Причина разногласия
    IN inCommentSendID       Integer   , -- Комментарий
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbAmount        TFloat;
   DECLARE vbAmountManual  TFloat;
   DECLARE vbAmountStorage TFloat;
   DECLARE vbAmountAuto    TFloat;
   DECLARE vbIsSUN         Boolean;
   DECLARE vbIsSUN_v2      Boolean;
   DECLARE vbIsSUN_v3      Boolean;
   DECLARE vbIsDefSUN      Boolean;
   DECLARE vbInsertDate    TDateTime;
   DECLARE vbTotalCount    TFloat;
   DECLARE vbTotalCountOld TFloat;
   DECLARE vbCommentSendId Integer;
   DECLARE vbStatusId      Integer;
   DECLARE vbAmountPromo   TFloat;
   DECLARE vbRemains       TFloat;
   DECLARE vbUserUnit      Integer;
   DECLARE vbDaySaleForSUN Integer;
   DECLARE vbTRID          Integer;
   DECLARE vbTRInvNumber   TVarChar; 
   DECLARE vbTROperDate    TDateTime;
   DECLARE vbTRStatusId    Integer;
   DECLARE vbisDeferred    Boolean;
   DECLARE vHT_SUN         Integer;
   DECLARE vbisSent        Boolean;
   DECLARE vbisReceived    Boolean;
   DECLARE vbisBlockCommentSendTP  Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    --определяем подразделение получателя
    SELECT Movement.StatusId
         , Movement.OperDate
         , MovementLinkObject_To.ObjectId                               AS UnitId
         , MovementLinkObject_From.ObjectId                             AS FromId
         , COALESCE (MovementBoolean_SUN.ValueData, FALSE)::Boolean     AS isSUN
         , COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE)::Boolean  AS isSUN_v2
         , COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE)::Boolean  AS isSUN_v3
         , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)::Boolean  AS isDefSUN
         , DATE_TRUNC ('DAY', MovementDate_Insert.ValueData)
         , COALESCE (MovementFloat_TotalCount.ValueData, 0)
         , COALESCE (ObjectFloat_CashSettings_DaySaleForSUN.ValueData, 0)::Integer
         , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
         , COALESCE (MovementBoolean_Sent.ValueData, FALSE) ::Boolean
         , COALESCE (MovementBoolean_Received.ValueData, FALSE) ::Boolean
         , COALESCE (MILinkObject_CommentSend.ObjectId, 0)
         , COALESCE (ObjectBoolean_BlockCommentSendTP.ValueData, FALSE):: Boolean    AS isBlockCommentSendTP
    INTO vbStatusId, vbOperDate, vbUnitId, vbFromId, vbIsSUN, vbIsSUN_v2, vbIsSUN_v3, vbIsDefSUN, vbInsertDate, 
         vbTotalCountOld, vbDaySaleForSUN, vbisDeferred, vbisSent, vbisReceived, vbCommentSendID, vbisBlockCommentSendTP       
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      
          LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                           ON MILinkObject_CommentSend.MovementItemId = Movement.Id
                                          AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                    ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                   AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                    ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                   AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()

          LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                    ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                   AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
          LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

          LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                    ON MovementBoolean_Sent.MovementId = Movement.Id
                                   AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
          LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                    ON MovementBoolean_Received.MovementId = Movement.Id
                                   AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId = Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DaySaleForSUN
                                ON ObjectFloat_CashSettings_DaySaleForSUN.ObjectId = (SELECT Object_CashSettings.Id
                                                                                      FROM Object AS Object_CashSettings
                                                                                      WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                                                                                      LIMIT 1)
                               AND ObjectFloat_CashSettings_DaySaleForSUN.DescId = zc_ObjectFloat_CashSettings_DaySaleForSUN()
 
          LEFT JOIN ObjectBoolean AS ObjectBoolean_BlockCommentSendTP
                                  ON ObjectBoolean_BlockCommentSendTP.ObjectId = MovementLinkObject_From.ObjectId  
                                 AND ObjectBoolean_BlockCommentSendTP.DescId = zc_ObjectBoolean_Unit_BlockCommentSendTP()
                               
    WHERE Movement.Id = inMovementId;
    
    IF COALESCE (inCommentSendID, 0) <> 0
    THEN
    
       IF COALESCE (vbisBlockCommentSendTP, False) = TRUE AND 
          COALESCE ((SELECT ChildObjectId FROM ObjectLink
                      WHERE ObjectId = inCommentSendID
                        AND DescId = zc_ObjectLink_CommentSend_CommentTR()), 0) <> 0
       THEN
          RAISE EXCEPTION 'Ошибка. Использование причин уменьшения количества которые участвуют в техническом переучете запрещено.';       
       END IF;
       
       WITH tmpProtocolUnion AS (SELECT  MovementItemProtocol.Id
                                       , MovementItemProtocol.MovementItemId
                                       , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                  FROM MovementItemProtocol
                                  WHERE MovementItemProtocol.MovementItemId = ioId
                                        AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                        AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                  UNION ALL
                                  SELECT MovementItemProtocol.Id
                                       , MovementItemProtocol.MovementItemId
                                       , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                  FROM movementitemprotocol_arc AS MovementItemProtocol
                                  WHERE MovementItemProtocol.MovementItemId = ioId
                                        AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                        AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                  )
           , tmpProtocolAll AS (SELECT  MovementItem.Id
                                     , MovementItemProtocol.ProtocolData
                                     , MovementItem.Amount
                                     , MovementItem.ObjectId
                                     , Object_Goods_Main.Name
                                     , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                FROM MovementItem

                                     INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                                     INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                                     INNER JOIN tmpProtocolUnion AS MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                WHERE  MovementItem.Id = ioId
                                ) 
           , tmpProtocol AS (SELECT tmpProtocolAll.Id
                                  , tmpProtocolAll.ObjectId
                                  , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                             FROM tmpProtocolAll
                             WHERE tmpProtocolAll.Ord = 1)

       SELECT tmpProtocol.AmountAuto
       INTO vbAmountAuto
       FROM tmpProtocol;

       IF  COALESCE(vbAmountAuto, 0) = COALESCE(inAmount, 0) AND COALESCE(vbAmountAuto, 0) <> 0
       THEN
          RAISE EXCEPTION 'Ошибка. Количество % равно сформировано % уберите причину уменьшения количества!', inAmount, vbAmountAuto;
       END IF;
    END IF;
    
    IF COALESCE (ioId, 0) = 0 AND (vbIsSUN = TRUE OR vbIsSUN_v2 = TRUE OR vbIsSUN_v3 = TRUE) AND
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) AND
      (vbisReceived = FALSE OR NOT EXISTS(SELECT 1    
                                          FROM MovementItem 
                                               INNER JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                                                 ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                                                AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                                                                AND MILinkObject_CommentSend.ObjectId = 16978916
                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE))
    THEN
      RAISE EXCEPTION 'Ошибка. В перемещения по СУН добавление товара запрещено.';
    END IF;

    -- Получаем предыдущее значение количеств
    SELECT
           MovementItem.Amount                         AS Amount
         , COALESCE(MIFloat_AmountManual.ValueData,0)  AS AmountManual
         , COALESCE(MIFloat_AmountStorage.ValueData,0) AS AmountStorage
         , COALESCE (MILinkObject_CommentSend.ObjectId, 0)
         , MovementTR.ID
         , MovementTR.InvNumber
         , MovementTR.OperDate
         , MovementTR.StatusId
    INTO vbAmount, vbAmountManual, vbAmountStorage, vbCommentSendId, vbTRID, vbTRInvNumber, vbTROperDate, vbTRStatusId
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                     ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
         LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                     ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                          ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                         AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

         LEFT JOIN MovementItemFloat AS MIFloat_MITRId
                                     ON MIFloat_MITRId.MovementItemId = MovementItem.Id
                                     AND MIFloat_MITRId.DescId = zc_MIFloat_MITechnicalRediscountId()
                                                                                                                                    
         LEFT JOIN MovementItem AS MITR ON MITR.ID = MIFloat_MITRId.ValueData::Integer

         LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITR.MovementId
                                     
    WHERE MovementItem.Id = ioId;
    
    IF (vbAmount <> inAmount OR COALESCE(vbCommentSendId, 0) <> COALESCE(inCommentSendID, 0))
       AND COALESCE (vbTRStatusId, zc_Enum_Status_UnComplete()) = zc_Enum_Status_Complete()
    THEN
      RAISE EXCEPTION 'Ошибка. Технический переучет <%> проведен. Изменять количество или причину уменьшения количества запрещено.', vbTRInvNumber;    
    END IF;

    IF vbisSUN = TRUE AND COALESCE (ioId, 0) <> 0
       AND COALESCE (vbCommentSendId, 0) <> COALESCE (inCommentSendID, 0)
       AND (COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete() OR vbisDeferred = TRUE)
       AND COALESCE (vbAmount, 0) = COALESCE (inAmount, 0)
       AND COALESCE (vbAmountManual, 0) = COALESCE (vbAmountManual, 0)
       AND COALESCE (vbAmountStorage, 0) = COALESCE (inAmountStorage, 0)
       AND EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_TechnicalRediscount()))
    THEN
      -- Сохранили <Комментарий>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentSend(), ioId, inCommentSendID);

      IF COALESCE ((SELECT ChildObjectId FROM ObjectLink
                    WHERE ObjectId = vbCommentSendId
                      AND DescId = zc_ObjectLink_CommentSend_CommentTR()), 0) <>
         COALESCE ((SELECT ChildObjectId FROM ObjectLink
                    WHERE ObjectId = inCommentSendID
                      AND DescId = zc_ObjectLink_CommentSend_CommentTR()), 0) AND
         (COALESCE (vbStatusId, 0) = zc_Enum_Status_Complete() OR COALESCE (vbTotalCountOld, 0) = 0 OR vbisDeferred = TRUE)
      THEN
        PERFORM  gpSelect_MovementSUN_TechnicalRediscount(inMovementId, inSession);
      END IF;

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);

      RETURN;
    END IF;
    
    IF vbIsSUN = FALSE AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
      AND vbFromId NOT IN (1529734, 8156016) 
      AND vbUnitId NOT IN (17146811) 
      AND COALESCE (vbAmountStorage, 0) = COALESCE (inAmountStorage, 0)
      AND COALESCE (inAmountStorage, 0) > 0
      AND EXISTS(SELECT ObjectLink_Unit_Parent.ChildObjectId 
                 FROM ObjectLink AS ObjectLink_Unit_Parent
                 WHERE ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                   AND ObjectLink_Unit_Parent.ObjectId = vbUnitId
                   AND COALESCE(ObjectLink_Unit_Parent.ChildObjectId, 0) <> 0)
      AND CURRENT_DATE >= '09.07.2021'
    THEN
      vHT_SUN := COALESCE((SELECT Max(ObjectFloat_HT_SUN_v1.ValueData) FROM ObjectFloat AS ObjectFloat_HT_SUN_v1 
                           WHERE ObjectFloat_HT_SUN_v1.DescId = zc_ObjectFloat_Unit_HT_SUN_v1()), 0);
      IF vHT_SUN > 0 AND EXISTS(SELECT * 
                                FROM Container
                                     INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                                     AND MovementItemContainer.MovementDescId = zc_Movement_Send() 
                                                                     AND MovementItemContainer.Amount > 0
                                                                     AND MovementItemContainer.OperDate >= CURRENT_DATE - (vHT_SUN::TVarChar||' day')::INTERVAL
                                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = MovementItemContainer.MovementId
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                               AND MovementBoolean_SUN.ValueData = TRUE
                                WHERE Container.WhereObjectId = vbFromId 
                                  AND Container.ObjectId = inGoodsId  
                                  AND Container.DescId = zc_Container_Count()
                                  AND Container.Amount > 0)
      THEN
        RAISE EXCEPTION 'Ошибка. Данная позиция пришла к вам по СУН и остается на реализацию. Если нужно срочно переместить товар в другую аптеки - свяжитесь с IT отделом.';          
      END IF;
    END IF;

    -- Для роли "Безнал" отключаем проверки
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_Cashless())
    THEN
      -- Для роли "Кассир аптеки"
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
      THEN
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        IF COALESCE (vbUserUnitId, 0) = 0
        THEN
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';
        END IF;

        IF vbisDefSUN = TRUE
        THEN
          RAISE EXCEPTION 'Ошибка. Коллеги, вы не можете редактировать данное перемещение! Проверьте фильтр на Перемещение по СУН.';
        END IF;

        IF vbIsSUN = TRUE AND EXISTS(SELECT 1
                                     FROM Object AS Object_CashSettings
                                          LEFT JOIN ObjectDate AS ObjectDate_CashSettings_DateBanSUN
                                                               ON ObjectDate_CashSettings_DateBanSUN.ObjectId = Object_CashSettings.Id
                                                              AND ObjectDate_CashSettings_DateBanSUN.DescId = zc_ObjectDate_CashSettings_DateBanSUN()
                                     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                                       AND ObjectDate_CashSettings_DateBanSUN.ValueData = vbInsertDate)
        THEN
          RAISE EXCEPTION 'Ошибка. Работа СУН пока невозможна, ожидайте сообщение IT.';
        END IF;

        IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);
        END IF;

        IF vbUnitId <> 11299914 /*OR (DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - ('' ||
            CASE WHEN date_part('isodow', DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH') = 1
                 THEN 6 - date_part('isodow', DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH')
                 ELSE date_part('isodow', DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH') - 2 END|| 'DAY ')::INTERVAL) <= CURRENT_DATE*/
        THEN
          IF COALESCE (vbFromId, 0) = COALESCE (vbUserUnitId, 0)
          THEN
            IF COALESCE (vbAmountManual, 0) <> COALESCE (inAmountManual, 0)
            THEN
              RAISE EXCEPTION 'Ошибка. Изменять <Факт кол-во точки-получателя> вам запрещено.';
            END IF;
          END IF;

          IF COALESCE (vbUnitId, 0) = COALESCE (vbUserUnitId, 0)
          THEN
            IF COALESCE (vbAmount, 0) <> COALESCE (inAmount, 0) OR
             COALESCE (vbAmountStorage, 0) <> COALESCE (vbAmountStorage, 0)
            THEN
              RAISE EXCEPTION 'Ошибка. Изменять <Кол-во, загружаемое в точку-получатель> и <Факт кол-во точки-отправителя> вам запрещено.';
            END IF;
          END IF;

          IF vbIsSUN = TRUE
          THEN
             WITH tmpProtocolAll AS (SELECT  MovementItem.Id
                                           , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                           , MovementItem.Amount
                                           , MovementItem.ObjectId
                                           , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                      FROM MovementItem

                                           INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                                          AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                          AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                      WHERE  MovementItem.Id = ioId
                                      )
                 , tmpProtocol AS (SELECT tmpProtocolAll.Id
                                        , tmpProtocolAll.ObjectId
                                        , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                        , tmpProtocolAll.Amount
                                   FROM tmpProtocolAll
                                   WHERE tmpProtocolAll.Ord = 1)

             SELECT tmpProtocol.AmountAuto
             INTO vbAmountAuto
             FROM tmpProtocol;

            IF COALESCE (ioId, 0) <> 0 AND ceil(vbAmountAuto) < inAmount
            THEN
              RAISE EXCEPTION 'Ошибка. Увеличивать количество в перемещениях по СУН вам запрещено.';
            END IF;
          END IF;
        END IF;

/*        IF EXISTS(SELECT 1 FROM MovementBoolean
                  WHERE MovementBoolean.MovementId = inMovementId
                    AND MovementBoolean.DescId = zc_MovementBoolean_isAuto()
                    AND MovementBoolean.ValueData = TRUE)
        THEN

          IF COALESCE (ioId, 0) = 0 OR EXISTS(SELECT 1 FROM MovementItem
                                              WHERE MovementItem.ID = ioId
                                                AND MovementItem.Amount < inAmount)
          THEN
            RAISE EXCEPTION 'Ошибка. Увеличивать количество в автоматически сформированных перемещениях вам запрещено.';
          END IF;
        END IF;
*/

        IF vbIsSUN = TRUE AND vbInsertDate >= '25.08.2020' AND COALESCE (inCommentSendID, 0) = 0 AND COALESCE(vbAmount, 0) <> COALESCE(inAmount, 0)
        THEN
           WITH tmpProtocolAll AS (SELECT  MovementItem.Id
                                         , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                         , MovementItem.Amount
                                         , MovementItem.ObjectId
                                         , Object_Goods_Main.Name
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                    FROM MovementItem

                                         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                                         INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                                     AND Object_Goods_Main.isInvisibleSUN = False

                                         INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                                        AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                        AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                    WHERE  MovementItem.Id = ioId
                                    )
               , tmpProtocol AS (SELECT tmpProtocolAll.Id
                                      , tmpProtocolAll.ObjectId
                                      , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                      , tmpProtocolAll.Name
                                      , tmpProtocolAll.Amount
                                 FROM tmpProtocolAll
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                                       ON MILinkObject_CommentSend.MovementItemId = tmpProtocolAll.Id
                                                                      AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                 WHERE tmpProtocolAll.Ord = 1
                                   AND COALESCE (MILinkObject_CommentSend.ObjectId, 0) = 0)

           SELECT tmpProtocol.AmountAuto
           INTO vbAmountAuto
           FROM tmpProtocol;

           IF COALESCE(vbAmountAuto, 0) > COALESCE(inAmount, 0)
           THEN
              RAISE EXCEPTION 'Ошибка. Количество % меньше сформировано % укажите причину уменьшения количества!', inAmount, vbAmountAuto;
           END IF;
        END IF;
      END IF;

      IF COALESCE(inCommentSendID, 0) <> 0 AND COALESCE(inCommentSendID, 0) <> COALESCE(vbCommentSendId, 0)
         AND EXISTS(SELECT 1 FROM ObjectBoolean
                    WHERE ObjectBoolean.ObjectId = inCommentSendID
                      AND ObjectBoolean.DescId = zc_ObjectBoolean_CommentSun_Promo()
                      AND ObjectBoolean.ValueData = TRUE)
      THEN
          vbAmountPromo := (SELECT Sum(MI_Goods.Amount) AS Amount
                            FROM Movement

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                               ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                                              AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
                                 INNER JOIN ObjectLink AS OL_UnitCategory
                                                       ON OL_UnitCategory.DescId = zc_ObjectLink_Unit_Category()
                                                      AND OL_UnitCategory.Objectid = vbFromId
                                                      AND OL_UnitCategory.ChildObjectId = MovementLinkObject_UnitCategory.ObjectId

                                 INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                    AND MI_Goods.DescId = zc_MI_Master()
                                                                    AND MI_Goods.isErased = FALSE
                                                                    AND MI_Goods.ObjectId = inGoodsId

                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_PromoUnit()
                              AND Movement.OperDate = DATE_TRUNC ('MONTH', vbOperDate));
                              
        IF COALESCE (vbAmountPromo, 0) = 0
        THEN
          RAISE EXCEPTION 'Ошибка. Товар не найден в плане для точки.';
        END IF;

          vbUserUnit := (SELECT Count(*)
                         FROM Movement
                                
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                      AND MovementItem.DescId = zc_MI_Master()

                               LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                    ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
 
                               LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                    ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                               LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                    ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                          
                         WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                           AND Movement.OperDate = DATE_TRUNC ('MONTH', vbOperDate)
                           AND COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) = vbFromId
                           AND ObjectLink_Member_Position.ChildObjectId = 1672498);
          
          IF COALESCE (vbUserUnit, 0) = 0
          THEN
            vbUserUnit := 1;
          END IF ;
          
          vbRemains := (SELECT Sum(Container.Amount) AS Amount
                            FROM Container
                            WHERE Container.DescId = zc_Container_Count()
                              AND Container.ObjectId = inGoodsId
                              AND Container.WhereObjectId = vbFromId
                              AND Container.Amount <> 0);

           WITH tmpProtocolAll AS (SELECT  MovementItem.Id
                                         , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                         , MovementItem.Amount
                                         , MovementItem.ObjectId
                                         , Object_Goods_Main.Name
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                    FROM MovementItem

                                         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                                         INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                                     AND Object_Goods_Main.isInvisibleSUN = False

                                         INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                                        AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                        AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                    WHERE  MovementItem.Id = ioId
                                    )
               , tmpProtocol AS (SELECT tmpProtocolAll.Id
                                      , tmpProtocolAll.ObjectId
                                      , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                      , tmpProtocolAll.Name
                                      , tmpProtocolAll.Amount
                                 FROM tmpProtocolAll
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                                       ON MILinkObject_CommentSend.MovementItemId = tmpProtocolAll.Id
                                                                      AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                 WHERE tmpProtocolAll.Ord = 1
                                   AND COALESCE (MILinkObject_CommentSend.ObjectId, 0) = 0)

           SELECT tmpProtocol.AmountAuto
           INTO vbAmountAuto
           FROM tmpProtocol;

        IF COALESCE (COALESCE (vbAmountPromo, 0) * vbUserUnit, 0) < (COALESCE (vbRemains, 0) - COALESCE (vbAmountAuto, 0))
        THEN
          RAISE EXCEPTION 'Ошибка. Остаток с учетом зануления <%> больше чем в плане по точке <%> использование коментария <%> запрещено.',
                           COALESCE (vbRemains, 0) - COALESCE (vbAmountAuto, 0), COALESCE (vbAmountPromo * vbUserUnit, 0), (SELECT Object.ValueData FROM Object WHERE Object.ID = inCommentSendID);
        END IF;
      END IF;

      -- Для менеджеров
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
         AND vbUserId NOT IN (183242 )
      THEN

        IF COALESCE (vbAmountManual, 0) <> COALESCE (inAmountManual, 0) OR
         COALESCE (vbAmountStorage, 0) <> COALESCE (inAmountStorage, 0)
        THEN
          RAISE EXCEPTION 'Ошибка. Изменять <Факт кол-во точки-получателя> и <Факт кол-во точки-отправителя> вам запрещено.';
        END IF;
      END IF;

    END IF;

/*    IF COALESCE(inCommentSendID, 0) = 14883331
       AND NOT EXISTS(SELECT 1 FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId AND COALESCE(Object_Goods_Retail.GoodsPairSunId, 0) <> 0)
    THEN
       RAISE EXCEPTION 'Ошибка. Использование коментария <%> с товаром <%> запрещено.',
                           (SELECT Object.ValueData FROM Object WHERE Object.ID = 14883331), (SELECT Object.ValueData FROM Object WHERE Object.ID = inGoodsId);
    END IF;
*/
    IF COALESCE(inCommentSendID, 0) = 14911561
    THEN
       IF NOT EXISTS(SELECT MovementItem.ObjectId         AS GoodsId
                     FROM Movement
                          INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                  ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                 AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                 AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE
 
                          INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                  ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                 AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                 AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                                                 AND MovementItem.ObjectId   = 
                                                     (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId) 
 
                     WHERE Movement.DescId = zc_Movement_GoodsSP()
                       AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                     )
       THEN 
         RAISE EXCEPTION 'Ошибка. Данная позиция не участвует в СП, выберите другую причину.';
       END IF;
    END IF;

    IF COALESCE(inCommentSendID, 0) = 14883299 AND COALESCE (vbDaySaleForSUN, 0) > 0 AND
       NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      IF EXISTS(SELECT 1
                FROM Movement

                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  AND MovementLinkObject_From.ObjectId = vbFromId

                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                ON MovementBoolean_SUN.MovementId = Movement.Id
                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                               AND MovementBoolean_SUN.ValueData = TRUE

                     LEFT JOIN MovementDate AS MovementDate_Insert
                                            ON MovementDate_Insert.MovementId = Movement.Id
                                           AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                                            AND MovementItem.ObjectId = inGoodsId

                     INNER JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                       ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                                      AND MILinkObject_CommentSend.ObjectId = 14883299

                WHERE Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
                  AND Movement.DescId = zc_Movement_Send()
                  AND MovementDate_Insert.ValueData BETWEEN vbInsertDate - ((vbDaySaleForSUN + 7)::TVarChar||' DAY')::INTERVAL AND vbInsertDate - ((vbDaySaleForSUN - 1)::TVarChar||' DAY')::INTERVAL)
        AND COALESCE((SELECT SUM(Container.Amount) FROM Container 
                      WHERE Container.DescId = zc_Container_Count() AND Container.ObjectId = inGoodsId AND Container.WhereObjectId = vbFromId), 0) > 0
      THEN
         RAISE EXCEPTION 'Ошибка. По товару <%> был использован комментарий <%> % дней назад. Использовать сейчас запрещено',
                             (SELECT Object.ValueData FROM Object WHERE Object.ID = inGoodsId), vbDaySaleForSUN, 
                             (SELECT Object.ValueData FROM Object WHERE Object.ID = 14883299);
      END IF;
    END IF;
    
    IF COALESCE(inCommentSendID, 0) = 14957072
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND NOT EXISTS (WITH tmpMovement AS (SELECT Movement.ID
                                                 , Movement.InvNumber
                                                 , Movement.StatusId
                                                 , Movement.OperDate
                                            FROM Movement
                                                 INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                         ON MovementBoolean_SUN.MovementId = Movement.Id
                                                        AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                        AND MovementBoolean_SUN.ValueData = TRUE
                                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                             AND MovementLinkObject_From.ObjectId = vbFromId 
                                                 LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                            WHERE Movement.DescId = zc_Movement_Send()
                                              AND (Movement.StatusId = zc_Enum_Status_Complete()
                                               OR Movement.StatusId = zc_Enum_Status_UnComplete() AND COALESCE(MovementBoolean_Deferred.ValueData, False) = TRUE)
                                              AND Movement.OperDate >= vbOperDate - INTERVAL '1 MONTH') 
                       SELECT Movement.ID                                                                    AS ID
                            , Movement.InvNumber
                            , Movement.OperDate
                            , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                            , MovementItem.ObjectId                                                          AS GoodsID
                            , MovementItem.Id                                                                AS MovementItemId
                            , MovementItem.Amount                                                            AS Amount
                       FROM tmpMovement AS Movement

                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                                   AND MovementItem.ObjectId = inGoodsId

                            INNER JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                             ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                                            AND MILinkObject_CommentSend.ObjectId = 14957072 
                           )
    THEN
       IF NOT EXISTS(WITH GoodsPromo AS (SELECT Object_Goods_Retail.GoodsMainId                                                     AS GoodsId  
                                              , max(tmp.RelatedProductId)                                                          AS RelatedProductId
                                         FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                                              LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmp.GoodsId
                                         GROUP BY Object_Goods_Retail.GoodsMainId
                                         )
                          
                     SELECT *
                     FROM Object_Goods_Retail AS Object_Goods_Retail 
                          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                          LEFT JOIN ObjectFloat AS ObjectFloat_RelatedProduct
                                                ON ObjectFloat_RelatedProduct.ObjectId = Object_Goods_Main.ConditionsKeepId
                                               AND ObjectFloat_RelatedProduct.DescId = zc_ObjectFloat_ConditionsKeep_RelatedProduct()            

                          LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_Main.Id

                     WHERE Object_Goods_Retail.Id = inGoodsId
                       AND COALESCE(GoodsPromo.RelatedProductId, ObjectFloat_RelatedProduct.ValueData) = 20628048)
       THEN 
         RAISE EXCEPTION 'Ошибка. По товару <%> - <%> нельзя ставить коммент "Нет хладогена."' 
           , (SELECT ObjectCode FROM Object WHERE ID = inGoodsId)
           , (SELECT ValueData FROM Object WHERE ID = inGoodsId);
       END IF;
    END IF;

    IF (COALESCE(inCommentSendID, 0) <> COALESCE(vbCommentSendID, 0)) AND (COALESCE(inCommentSendID, 0) = 16978916 OR COALESCE(vbCommentSendID, 0) = 16978916)
    THEN
       IF vbisReceived = FALSE AND COALESCE(inCommentSendID, 0) = 16978916
       THEN 
         RAISE EXCEPTION 'Ошибка. Коммент "Пересорт по факту, отравитель редактирует." можно установить только после получения аптекой получателем.';
       END IF;
       
       IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) AND
          NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       THEN
         RAISE EXCEPTION 'Ошибка. Коммент "Пересорт по факту, отравитель редактирует." изменять разрешено сотруднику аптеки получателя';
       END IF;       
    END IF; 

    IF vbIsSUN = TRUE AND COALESCE (inReasonDifferencesId, 0) <> 0
    THEN
       RAISE EXCEPTION 'Ошибка. В перемещениях СУН причину разногласия использовать нельзя.';
    END IF;

    --если цена получателя = 0 заменяем ее на цену отвравителя и записываем в прайс
    IF COALESCE (ioPriceUnitTo, 0) = 0 AND COALESCE (inPriceUnitFrom, 0) <> 0
    THEN
        ioPriceUnitTo := inPriceUnitFrom;

        --переоценить товар
        PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                            inUnitId  := vbUnitId,
                                            inPrice   := ioPriceUnitTo,
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);
    END IF;

    --Посчитали сумму
    outSumma := ROUND(inAmount * inPrice, 2);
    outAmountDiff := COALESCE (inAmountManual,0) - COALESCE (inAmount,0);
    outAmountStorageDiff := COALESCE (inAmountStorage,0) - COALESCE (inAmount,0);

    outSummaUnitTo := ROUND(inAmount * ioPriceUnitTo, 2);


    IF outAmountDiff = 0
    THEN
        inReasonDifferencesId := 0;
    END IF;

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_Send (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inAmountManual       := inAmountManual
                                            , inAmountStorage      := inAmountStorage
                                            , inReasonDifferencesId:= inReasonDifferencesId
                                            , inCommentSendID      := inCommentSendID
                                            , inUserId             := vbUserId
                                             );

    -- Добавили в ТП
    IF vbIsSUN = TRUE
    THEN

      --определяем
      SELECT COALESCE (MovementFloat_TotalCount.ValueData, 0)
      INTO vbTotalCount
      FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

      WHERE Movement.Id = inMovementId;

      IF COALESCE (vbTotalCount, 0) = 0 OR COALESCE (vbTotalCountOld, 0) = 0
      THEN
        PERFORM  gpSelect_MovementSUN_TechnicalRediscount(inMovementId, inSession);
      END IF;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 23.08.20                                                                      * СУН в ТП
 21.12.19                                                                      * звпрет добавления в перемещения по СУН
 01.04.19                                                                      *
 05.02.19         * add inAmountStorage
 19.12.18                                                                      *
 07.09.17         *
 28.06.16         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')n