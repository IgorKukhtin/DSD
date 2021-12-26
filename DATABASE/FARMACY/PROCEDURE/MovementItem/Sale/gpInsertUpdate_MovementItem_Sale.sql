-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioPriceSale           TFloat    , -- Цена без скидки
    IN inChangePercent       TFloat    , -- % скидки
    IN inNDSKindId           Integer   , -- НДС
   OUT outSumm               TFloat    , -- Сумма
   OUT outIsSp               Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbIsInsert  Boolean;
   DECLARE vbIsDeferred Boolean;
   DECLARE vbUnitId    Integer;
   DECLARE vbSPKindId  Integer;
   DECLARE vbAmount    TFloat;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbSaldo     TFloat;
   DECLARE vbPriceCalc TFloat;
   DECLARE vbPersent   TFloat;
   DECLARE vbisVIPforSales Boolean;
   DECLARE vbAmountVIP TFloat;
   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;

    IF COALESCE (inNDSKindId, 0) = 0
    THEN
      inNDSKindId := COALESCE((SELECT Object_Goods_Main.NDSKindId FROM  Object_Goods_Retail
                                      LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               WHERE Object_Goods_Retail.Id = inGoodsId), zc_Enum_NDSKind_Medical());
    
    END IF;
    
    -- Получили признак отложен
    SELECT COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
         , Movement_Sale.UnitId
         , Movement_Sale.SPKindId
    INTO vbIsDeferred
       , vbUnitId
       , vbSPKindId
    FROM Movement_Sale_View AS Movement_Sale
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement_Sale.Id = inMovementId;

    -- проверка ЗАПРЕТ на отпуск препаратов у которых ндс 20%, для пост. 1303
    IF vbSPKindId = zc_Enum_SPKind_1303() AND vbUserId <> 235009    --  Колеуш И. И.
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
            -- проверка ЗАПРЕТ на отпуск препаратов у которых ндс 20%, для пост. 1303
       THEN
            --
            IF EXISTS (SELECT 1
                       FROM ObjectLink
                            INNER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId
                                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                  AND ObjectFloat_NDSKind_NDS.ValueData = 20
                       WHERE ObjectLink.ObjectId = inGoodsId
                         AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind())
               THEN
                   RAISE EXCEPTION 'Ошибка. Запрет на отпуск товара по ПКМУ 1303 со ставкой НДС=20 проц. (ТОВАР БЕЗ РЕГИСТРАЦИИ !!!)';
            END IF;

            SELECT CASE WHEN tt.Price < 100 THEN tt.Price * 1.25
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN tt.Price * 1.2
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN tt.Price * 1.15
                         WHEN tt.Price >= 1000 THEN tt.Price * 1.1
                    END :: TFloat AS PriceCalc
                  , CASE WHEN tt.Price < 100 THEN 25
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN 20
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN 15
                         WHEN tt.Price >= 1000 THEN 10
                    END :: TFloat AS Persent
            INTO vbPriceCalc, vbPersent
             FROM (SELECT CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                               ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData,1)/100))::TFloat    -- в партии инвентаризации  цена с НДС, а параметра НДС нет
                          END AS Price   -- цена c НДС
                        , ROW_NUMBER() OVER (ORDER BY Container.Id DESC) AS ord   -- Люба сказала смотреть по последней партии
                   FROM Container
                      LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                                          ON CLI_MI.ContainerId = Container.Id
                                                         AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                      LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                      LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                   ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                  AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                      LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                            ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                           AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                   WHERE Container.ObjectId = inGoodsId
                     AND Container.DescId = zc_Container_Count()
                     AND Container.WhereObjectId = vbUnitId
                     AND COALESCE (Container.Amount,0 ) > 0
                     AND COALESCE (MIFloat_Price.ValueData ,0) > 0
                   ) AS tt
             WHERE tt.Ord = 1;

            -- проверка  Цена < 100грн – максимальна торгівельна надбавка може складати 25%. від 100 до 500 грн – надбавка на рівні 20%. Від 500 до 1000 – 15%. Понад 1000 грн надбавка на рівні 10%.
            IF (COALESCE(ioId, 0) = 0) AND (COALESCE (vbPriceCalc,0) <> 0)
            THEN
              ioPriceSale := trunc(vbPriceCalc * 10) / 10;
            ELSEIF (COALESCE (vbPriceCalc,0) < ioPriceSale) AND (COALESCE (vbPriceCalc,0) <> 0)
               THEN
                   IF vbPersent = 25 THEN  RAISE EXCEPTION 'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 25 процентов (для товара с приходной ценой до 100грн).% Сделать PrintScreen экрана с ошибкой и отправить на Skype своему менеджеру для  исправления Цены реализации (после исправления - препарат можно отпустить по рецепту)', Chr(13)||Chr(10); END IF;
                   IF vbPersent = 20 THEN  RAISE EXCEPTION 'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 20 процентов (для товара с приходной ценой от 100грн до 500грн).% Сделать PrintScreen экрана с ошибкой и отправить на Skype своему менеджеру для  исправления Цены реализации (после исправления - препарат можно отпустить по рецепту)', Chr(13)||Chr(10); END IF;
                   IF vbPersent = 15 THEN  RAISE EXCEPTION 'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 15 процентов (для товара с приходной ценой от 500грн до 1000грн).% Сделать PrintScreen экрана с ошибкой и отправить на Skype своему менеджеру для  исправления Цены реализации (после исправления - препарат можно отпустить по рецепту)', Chr(13)||Chr(10); END IF;
                   IF vbPersent = 10 THEN  RAISE EXCEPTION 'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 10 процентов (для товара с приходной ценой свыше 1000грн).% Сделать PrintScreen экрана с ошибкой и отправить на Skype своему менеджеру для  исправления Цены реализации (после исправления - препарат можно отпустить по рецепту)', Chr(13)||Chr(10); END IF;
            END IF;

    END IF;

/*    IF (COALESCE(ioId, 0) = 0)
    THEN
      RAISE EXCEPTION 'Ошибка. % % ', ioPriceSale, vbPriceCalc;
    END IF;*/
    
    
    IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) WHERE GoodsId = inGoodsId)
    THEN
      vbisVIPforSales := False;
      vbAmountVIP := COALESCE ((SELECT Amount FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) WHERE GoodsId = inGoodsId), 0);        
    ELSE
      vbisVIPforSales := True;
      vbAmountVIP := 0;    
    END IF;
    
    -- Сохранили начальное количество для отложеных чеков
    IF vbIsDeferred = TRUE AND COALESCE (ioId, 0) <> 0
    THEN
      vbAmount := COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0);
    ELSE
      vbAmount := 0;
    END IF;
    
    IF vbAmount + vbAmountVIP < inAmount
    THEN
      IF vbAmount + vbAmountVIP = 0
      THEN
        RAISE EXCEPTION 'Ошибка. По товару не установлен резерв аптекой для продажи.';    
      ELSE
        RAISE EXCEPTION 'Ошибка. Аптекой для продажи установлен резерв % шт. вы пытаетесь отпустить % шт.', vbAmount + vbAmountVIP, inAmount;          
      END IF;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND vbUserId <> 235009 AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND EXISTS(SELECT 1 FROM MovementLinkMovement AS MLM_Child
                      INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                    ON MovementLinkObject_SPKind.MovementId = MLM_Child.MovementId
                                                   AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                   AND COALESCE (MovementLinkObject_SPKind.ObjectId, 0) = zc_Enum_SPKind_1303()
                      INNER JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId
                  WHERE MLM_Child.MovementId = inMovementId
                    AND MLM_Child.descId = zc_MovementLinkMovement_Child())
    THEN
      RAISE EXCEPTION 'Ошибка. По документу выписан <Счет (пост.1303)> изменение документа запрещено.';
    END IF;

    --определяем признак участвует в соц.проекте, по шапке док.
    outIsSp:= COALESCE (
             (SELECT CASE WHEN COALESCE(MovementString_InvNumberSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MedicSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MemberSP.ValueData,'') <> '' OR
                               -- COALESCE(MovementDate_OperDateSP.ValueData,Null) <> Null OR
                                COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 THEN True
                           ELSE FALSE
                      END
              FROM Movement
                          LEFT JOIN MovementString AS MovementString_InvNumberSP
                                 ON MovementString_InvNumberSP.MovementId = Movement.Id
                                AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                          LEFT JOIN MovementString AS MovementString_MedicSP
                                 ON MovementString_MedicSP.MovementId = Movement.Id
                                AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                          LEFT JOIN MovementString AS MovementString_MemberSP
                                 ON MovementString_MemberSP.MovementId = Movement.Id
                                AND MovementString_MemberSP.DescId = zc_MovementString_MemberSP()
                          LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                 ON MovementDate_OperDateSP.MovementId = Movement.Id
                                AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                  ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                 AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Sale())
              , False)  :: Boolean ;

    -- проверку на 1 товар вдокументе добавили в проведение
    -- если  признак участвует в соц.проекте = TRUE . то в док. должна быть 1 строка
    IF outIsSp = TRUE
    THEN
         IF (SELECT COUNT(*) FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.Id <> ioId
               AND MovementItem.IsErased = FALSE
               AND MovementItem.Amount > 0) >= 1
            THEN
                 RAISE EXCEPTION 'Ошибка.В документе может быть только 1 препарат.';
            END IF;
    END IF;

    --Посчитали цену продажи
    IF COALESCE(inChangePercent,0) <> 0 THEN
       ioPrice:= ROUND( COALESCE(ioPriceSale,0) - (COALESCE(ioPriceSale,0)/100 * inChangePercent) ,2);
    END IF;

    --Посчитали сумму
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(ioPrice,0),2);

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inPrice              := ioPrice
                                            , inPriceSale          := ioPriceSale
                                            , inChangePercent      := inChangePercent
                                            , inSumm               := outSumm
                                            , inisSp               := COALESCE(outIsSp,False) ::Boolean
                                            , inNDSKindId          := inNDSKindId 
                                            , inUserId             := vbUserId
                                             );

    -- Сохранили начальное количество для отложеных чеков
    IF vbIsDeferred = TRUE AND inAmount <> vbAmount
    THEN

      --Проверка на то что бы не продали больше чем есть на остатке
      SELECT MI_Sale.GoodsName
           , COALESCE(SUM(Container.Amount),0) + vbAmount
      INTO
          vbGoodsName
        , vbSaldo
      FROM MovementItem_Sale_View AS MI_Sale
          LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                   AND Container.WhereObjectId = vbUnitId
                                   AND Container.DescId = zc_Container_Count()
                                   AND Container.Amount > 0
      WHERE MI_Sale.Id = ioId
        AND MI_Sale.isErased = FALSE
      GROUP BY MI_Sale.GoodsId
             , MI_Sale.GoodsName
             , MI_Sale.Amount
      HAVING COALESCE (MI_Sale.Amount, 0) > (COALESCE (SUM (Container.Amount) ,0) + vbAmount);

      IF (COALESCE(vbGoodsName,'') <> '')
      THEN
         RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во продажи <%> больше, чем есть на остатке <%>.', vbGoodsName, inAmount, vbSaldo;
      END IF;

      IF inAmount < vbAmount
      THEN
        -- Проверяем VIP чек для продажи         
        IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) 
                  WHERE GoodsId = inGoodsId)
        THEN
          PERFORM gpInsertUpdate_MovementItem_Check_VIPforSales (inUnitId   := vbUnitId
                                                               , inGoodsId  := inGoodsId
                                                               , inAmount   := vbAmount
                                                               , inSession  := inSession
                                                                );                  
        END IF;

        -- Распроводим строку Документ
        PERFORM lpDelete_MovementItemContainerOne (inMovementId := inMovementId
                                                 , inMovementItemId := ioId);
      END IF;

      -- собственно проводки
      PERFORM lpComplete_Movement_Sale(inMovementId, -- ключ Документа
                                       ioId,         -- ключ содержимое Документа
                                       vbUserId);    -- Пользователь
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.  Шаблий О.В.
 11.05.20                                                                                      *               
 26.11.19         *
 01.08.19                                                                                      *
 05.06.18         *
 09.02.17         *
 13.10.15                                                                         *
*/