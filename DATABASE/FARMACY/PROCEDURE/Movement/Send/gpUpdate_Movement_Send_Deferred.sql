-- Function: gpUpdate_Movement_Send_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_Deferred(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisDeferred          Boolean   ,    -- Отложен
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbisSUN Boolean;
   DECLARE vbisVIP Boolean;
   DECLARE vbisDefSUN Boolean;
   DECLARE vbSumma TFloat;
   DECLARE vbLimitSUN TFloat;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountStorage  TFloat;
   DECLARE vbSaldo TFloat;
   DECLARE vbUnit_From Integer;
   DECLARE vbComment TVarChar;
   DECLARE vbisAuto Boolean;
   DECLARE vbOccupancySUN TFloat;
   DECLARE vbPartionDateKindId Integer;
   DECLARE vbisReceived Boolean;
   DECLARE vbInsertDate TDateTime;
   DECLARE vbConfirmed Boolean;
   DECLARE vbisBanFiscalSale Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    -- параметры документа
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE),
        COALESCE (MovementBoolean_SUN.ValueData, FALSE),
        COALESCE (MovementBoolean_DefSUN.ValueData, FALSE),
        COALESCE (MovementFloat_TotalSummFrom.ValueData, 0),
        COALESCE (ObjectFloat_LimitSUN.ValueData, 0),
        MovementLinkObject_From.ObjectId, 
        COALESCE (MovementString_Comment.ValueData,''), 
        COALESCE (MovementBoolean_isAuto.ValueData, FALSE), 
        COALESCE (ObjectFloat_OccupancySUN.ValueData, 0),
        MovementLinkObject_PartionDateKind.ObjectId,
        COALESCE (MovementBoolean_Received.ValueData, FALSE),
        DATE_TRUNC ('DAY', MovementDate_Insert.ValueData),
        COALESCE (MovementBoolean_VIP.ValueData, FALSE),
        COALESCE (MovementBoolean_Confirmed.ValueData, FALSE), 
        COALESCE (MovementBoolean_BanFiscalSale.ValueData, FALSE)
    INTO
        vbStatusId,
        vbisDeferred,
        vbisSUN,
        vbisDefSUN,
        vbSumma,
        vbLimitSUN,
        vbUnit_From,
        vbComment,
        vbisAuto,
        vbOccupancySUN,
        vbPartionDateKindId,
        vbisReceived,
        vbInsertDate,
        vbisVIP,
        vbConfirmed,
        vbisBanFiscalSale
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.ID
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN ObjectFloat AS ObjectFloat_LimitSUN
                              ON ObjectFloat_LimitSUN.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                             AND ObjectFloat_LimitSUN.DescId = zc_ObjectFloat_Retail_LimitSUN()

        LEFT JOIN ObjectFloat AS ObjectFloat_OccupancySUN
                              ON ObjectFloat_OccupancySUN.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                             AND ObjectFloat_OccupancySUN.DescId = zc_ObjectFloat_Retail_OccupancySUN()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()
        LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                  ON MovementBoolean_Received.MovementId = Movement.Id
                                 AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
        LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                  ON MovementBoolean_isAuto.MovementId = Movement.Id
                                 AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                  ON MovementBoolean_VIP.MovementId = Movement.Id
                                 AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()
        LEFT JOIN MovementBoolean AS MovementBoolean_Confirmed
                                  ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                 AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()
        LEFT JOIN MovementBoolean AS MovementBoolean_BanFiscalSale
                                  ON MovementBoolean_BanFiscalSale.MovementId = Movement.Id
                                 AND MovementBoolean_BanFiscalSale.DescId = zc_MovementBoolean_BanFiscalSale()
    WHERE Movement.Id = inMovementId;
   
    IF vbisDefSUN = TRUE AND inisDeferred = TRUE
    THEN
      RAISE EXCEPTION 'Ошибка. Коллеги, отложенные перемещение по СУН проводить нельзя.';
    END IF;
    
    IF vbisSUN = TRUE AND COALESCE(vbLimitSUN, 0) > 0 AND vbSumma < COALESCE(vbLimitSUN, 0) AND inisDeferred = TRUE 
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Ошибка. Коллеги, перемещения по СУН с суммой менее % грн. отлаживать нельзя.', COALESCE(vbLimitSUN, 0);
    END IF;

    -- Для роли "Кассир аптеки"
    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
    THEN

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
    END IF;

   -- свойство не меняем у проведенных документов
   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
   THEN

/*       IF inisDeferred = TRUE
       THEN
       
           IF vbisSUN = TRUE AND vbInsertDate >= '10.08.2020'
           THEN
             IF EXISTS(SELECT 1 FROM gpSelect_MovementItem_Send_Child(inMovementId := inMovementId,  inSession := inSession) AS T1 WHERE T1.Color_calc = zc_Color_Red())
             THEN
               SELECT Object_Goods.ValueData 
               INTO vbGoodsName
               FROM gpSelect_MovementItem_Send_Child(inMovementId := inMovementId,  inSession := inSession) AS T1
                    LEFT JOIN  Object AS Object_Goods ON Object_Goods.Id = T1.GoodsId
               WHERE Color_calc = zc_Color_Red()
               LIMIT 1;
               
               RAISE EXCEPTION 'Ошибка. Данная позиция <%> запрещена к перемещению, по причине УКТВЭД! Обнулите код!', vbGoodsName;
             END IF; 
           END IF; 
       END IF; 
*/
       -- определили признак
       outisDeferred:=  inisDeferred;
       -- сохранили признак
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN
       
           IF vbisDeferred = TRUE
           THEN
             RAISE EXCEPTION 'Ошибка.Документ уже отложен!';
           END IF;
           
           IF COALESCE(vbComment, '') = '' AND vbisAuto = FALSE AND vbisVIP = FALSE
              AND COALESCE(vbPartionDateKindId, 0) <> zc_Enum_PartionDateKind_0()
           THEN
             RAISE EXCEPTION 'ВНЕСИТЕ В ЯЧЕЙКУ КОММЕНТАРИЙ - ПРИЧИНУ ПЕРЕДАЧИ!!!';
           END IF;
           
           IF vbisVIP = TRUE AND vbConfirmed = FALSE
           THEN
             PERFORM gpUpdate_Movement_Confirmed(inMovementId, TRUE, inSession);
           END IF;
                      
           IF (vbOccupancySUN > 0) AND vbisSUN = TRUE AND vbisReceived = FALSE
             AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
           THEN
             IF (WITH tmpProtocolUnion AS (SELECT  MovementItemProtocol.Id
                                                 , MovementItemProtocol.MovementItemId
                                                 , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                            FROM MovementItemProtocol
                                            WHERE MovementItemProtocol.MovementItemId IN (SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.MovementId = inMovementID)
                                                  AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                  AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                            UNION ALL
                                            SELECT MovementItemProtocol.Id
                                                 , MovementItemProtocol.MovementItemId
                                                 , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                            FROM MovementItemProtocol_arc AS MovementItemProtocol
                                            WHERE MovementItemProtocol.MovementItemId  IN (SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.MovementId = inMovementID)
                                                  AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                  AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                          )
                    , tmpProtocolAll AS (SELECT MovementItemProtocol.MovementItemId
                                              , MovementItemProtocol.ProtocolData
                                              , MovementItem.Amount
                                              , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                         FROM MovementItem
                                              INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                                              INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                                          AND Object_Goods_Main.isInvisibleSUN = False
                                              INNER JOIN tmpProtocolUnion AS MovementItemProtocol 
                                                                          ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                                         AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                         AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                         WHERE MovementItem.MovementId = inMovementId)
                    , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                                           , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                           , tmpProtocolAll.Amount
                                         FROM tmpProtocolAll
                                         WHERE tmpProtocolAll.Ord = 1)
               SELECT SUM(Amount) / SUM(AmountAuto) * 100  FROM tmpProtocol) < vbOccupancySUN
             THEN
               RAISE EXCEPTION 'Обнуляете товар ниже установленной нормы. Обратитесь в IT';
             END IF;
           END IF;
           
           IF vbisSUN = TRUE AND vbInsertDate >= '25.08.2020' AND 
              NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
           THEN
             IF EXISTS(WITH tmpProtocolAll AS (SELECT  MovementItem.Id
                                                     , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                                     , MovementItem.Amount
                                                     , MovementItem.ObjectId
                                                     , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                                                FROM MovementItem 

                                                     INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                                                     INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                                                 AND Object_Goods_Main.isInvisibleSUN = False

                                                     INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                                                    AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                                    AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                                                WHERE  MovementItem.MovementId = inMovementID
                                                )
                           , tmpProtocol AS (SELECT tmpProtocolAll.Id
                                                  , tmpProtocolAll.ObjectId
                                                  , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                                  , tmpProtocolAll.Amount
                                             FROM tmpProtocolAll
                                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                                                   ON MILinkObject_CommentSend.MovementItemId = tmpProtocolAll.Id
                                                                                  AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                             WHERE tmpProtocolAll.Ord = 1
                                               AND COALESCE (MILinkObject_CommentSend.ObjectId, 0) = 0)
                       SELECT 1
                       FROM tmpProtocol
                       WHERE tmpProtocol.AmountAuto > tmpProtocol.Amount)
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
                                        WHERE  MovementItem.MovementId = inMovementID
                                        )
                   , tmpProtocol AS (SELECT tmpProtocolAll.Id
                                          , tmpProtocolAll.ObjectId
                                          , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                                          , tmpProtocolAll.Name
                                          , tmpProtocolAll.Amount
                                     FROM tmpProtocolAll
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                                           ON MILinkObject_CommentTR.MovementItemId = tmpProtocolAll.Id
                                                                          AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                                     WHERE tmpProtocolAll.Ord = 1
                                       AND COALESCE (MILinkObject_CommentTR.ObjectId, 0) = 0)
                                     
               SELECT tmpProtocol.Name
               INTO vbGoodsName
               FROM tmpProtocol
               WHERE tmpProtocol.AmountAuto > tmpProtocol.Amount             
               LIMIT 1;
             
               RAISE EXCEPTION 'Ошибка. Данная позиция <%> количество меньше сформировано укажите причину уменьшения количества!', vbGoodsName;
             END IF; 
           END IF; 
           
       
           -- Проверка на то что бы не списали больше чем есть на остатке
           SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountRemains
                  INTO vbGoodsName, vbAmount, vbSaldo
           FROM (WITH tmpMI AS (SELECT MovementItem.ObjectId     AS GoodsId
                                     , SUM (MovementItem.Amount) AS Amount
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE
                                  AND MovementItem.Amount <> 0
                                GROUP BY MovementItem.ObjectId
                               )
             , tmpContainer AS (SELECT Container.ObjectId     AS GoodsId
                                     , SUM (Container.Amount) AS Amount
                                FROM tmpMI
                                     INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND Container.Amount <> 0
                                     INNER JOIN ContainerLinkObject AS CLO_From
                                                                    ON CLO_From.ContainerId = Container.Id
                                                                   AND CLO_From.ObjectId    = vbUnit_From
                                                                   AND CLO_From.DescId      = zc_ContainerLinkObject_Unit()
                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                   ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                                  AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                              
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                             ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                            AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
                                WHERE (vbisBanFiscalSale = False OR vbisBanFiscalSale = True AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True)
                                GROUP BY Container.ObjectId
                               )
                 SELECT tmpMI.GoodsId, tmpMI.Amount
                      , COALESCE (tmpContainer.Amount, 0) AS AmountRemains
                 FROM tmpMI
                      LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI.GoodsId
                 WHERE tmpMI.Amount > COALESCE (tmpContainer.Amount, 0)
                ) AS tmp
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
           LIMIT 1;
           
           IF (COALESCE(vbGoodsName,'') <> '') 
           THEN
               RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во перемещения <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
           END IF;

           -- Проверка: Не проводить накладные перемещения - у которых колонка - "Кол-во получателя" отличается от кол-ки "Факт кол-во". 
           vbGoodsName := '';
           SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountStorage
           INTO vbGoodsName, vbAmount, vbAmountStorage
           FROM (SELECT MovementItem.ObjectId                             AS GoodsId
                      , SUM (MovementItem.Amount)                         AS Amount
                      , SUM (COALESCE(MIFloat_AmountStorage.ValueData,0))  AS AmountStorage
                 FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                                  ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                 GROUP BY MovementItem.ObjectId
                ) AS tmp
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
           WHERE tmp.Amount <> tmp.AmountStorage
             AND zfCalc_AccessKey_SendAll (vbUserId) = FALSE -- !!!ЭТИМ ПОЛЬЗОВАТЕЛЯМ - РАЗРЕШИЛИ!!!
           LIMIT 1
           ;

           IF vbGoodsName <> '' AND 
              vbUserId NOT IN (375661, 2301972, 183242) -- Зерин Юрий Геннадиевич              
           THEN
               RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам Кол-во получателя <%> отличается от Факт кол-ва точки-отправителя <%>.', vbGoodsName, vbAmount, vbAmountStorage;
           END IF;
           
           -- собст	венно проводки
           PERFORM lpComplete_Movement_Send(inMovementId  -- ключ Документа
                                          , vbUserId);    -- Пользователь  
       ELSE
           -- убираем проводки
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;

       -- сохранили свойство <Дата изменения>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Deferred(), inMovementId, CURRENT_TIMESTAMP);

   ELSE
       RAISE EXCEPTION 'Ошибка. Отлаживать документ в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   outisDeferred := COALESCE (outisDeferred, COALESCE (vbisDeferred, FALSE));
   
   -- возвращаем статус документа
   -- UPDATE Movement SET StatusId = vbStatusId WHERE Id = inMovementId;
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

   -- Добавили в ТП
   IF vbIsSUN = TRUE 
   THEN
      PERFORM  gpSelect_MovementSUN_TechnicalRediscount(inMovementId, True, inSession);
   END IF;

    -- Проверим а не провели за время отложки были прицеденты
   IF NOT EXISTS(SELECT Movement.StatusId
                 FROM Movement
                 WHERE Movement.Id = inMovementId
                   AND Movement.StatusId = zc_Enum_Status_UnComplete())
   THEN
       RAISE EXCEPTION 'Ошибка. За время отложки документ провели или удалили.';
   END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 06.02.20                                                                      *
 08.11.17         *
*/