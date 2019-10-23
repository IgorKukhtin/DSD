-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
 INOUT ioPrice               TFloat    , -- Цена
    IN inPriceSale           TFloat    , -- Цена без скидки
    IN inChangePercent       TFloat    , -- % скидки
   OUT outSumm               TFloat    , -- Сумма
   OUT outIsSp               Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsDeferred  Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbAmount    TFloat;
   DECLARE vbGoodsName  TVarChar;
   DECLARE vbSaldo      TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;

    -- Получили признак отложен
    SELECT COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
         , Movement_Sale.UnitId
    INTO vbIsDeferred
       , vbUnitId
    FROM Movement_Sale_View AS Movement_Sale
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement_Sale.Id = inMovementId;
    
    -- Сохранили начальное количество для отложеных чеков
    IF vbIsDeferred = TRUE AND COALESCE (ioId, 0) <> 0
    THEN
      vbAmount := COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0);
    ELSE
      vbAmount := 0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND vbUserId <> 235009 
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
       ioPrice:= ROUND( COALESCE(inPriceSale,0) - (COALESCE(inPriceSale,0)/100 * inChangePercent) ,2);
    END IF;

    --Посчитали сумму
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(ioPrice,0),2);

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inPrice              := ioPrice
                                            , inPriceSale          := inPriceSale
                                            , inChangePercent      := inChangePercent
                                            , inSumm               := outSumm
                                            , inisSp               := COALESCE(outIsSp,False) ::Boolean
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
 01.08.19                                                                                      *
 05.06.18         *
 09.02.17         *
 13.10.15                                                                         *
*/