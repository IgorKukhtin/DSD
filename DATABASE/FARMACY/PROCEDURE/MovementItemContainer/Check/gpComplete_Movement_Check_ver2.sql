-- Function: gpComplete_Movement_Check_ver2()

-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check_ver2(
    IN inMovementId        Integer              , -- ключ Документа
    IN inPaidType          Integer              , --Тип оплаты 0-деньги, 1-карта, 2-Смешенная
    IN inCashRegister      TVarChar             , --№ кассового аппарата
    IN inCashSessionId     TVarChar             , --Сессия программы
    IN inUserSession	   TVarChar             , -- сессия пользователя под которой проводился чек в программе
--    IN inSession         TVarChar DEFAULT ''    -- сессия пользователя
    IN inSession           TVarChar               -- сессия пользователя
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    MinExpirationDate TDateTime,
    PartionDateKindId  Integer,
    PartionDateKindName  TVarChar,
    NewRow Boolean,
    AccommodationId Integer,
    AccommodationName TVarChar,
    AmountMonth TFloat,
    PartionDateDiscount TFloat,
    Color_calc Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbCashRegisterId Integer;
  DECLARE vbMessageText Text;
BEGIN
    if coalesce(inUserSession, '') <> '' then
     inSession := inUserSession;
    end if;
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Check());
    vbUserId:= lpGetUserBySession (inSession);


    -- Если
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.ID = inMovementId AND Movement.DescId = zc_Movement_Check() AND Movement.StatusId <> zc_Enum_Status_Complete())
    THEN
        -- Перебили дату документа
        -- UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Movement.Id = inMovementId; /*Дата проведения хранится в локальной базе и не должна перебиваться*/

        -- Определить
        vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());

        -- сохранили тип оплаты
        IF inPaidType = 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(), inMovementId, zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_Card());
        ELSEIF inPaidType = 2
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_CardAdd());
        ELSE
            RAISE EXCEPTION 'Ошибка.Не определен тип оплаты';
        END IF;

        -- Определить ид кассового аппарата
        IF COALESCE(inCashRegister,'') <> ''
        THEN
            vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister -- Серийный номер аппарата
                                                                  , inSession:= inSession);
        ELSE
            vbCashRegisterId := 0;
        END IF;
        -- Сохранили связь с кассовым аппаратом
        IF vbCashRegisterId <> 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);
        END IF;

        -- пересчитали Итоговые суммы
        PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);


        -- формируются проводки
        vbMessageText:= COALESCE (lpComplete_Movement_Check (inMovementId, vbUserId), '');


        -- доводим снапшет до текущего состояния на клиенте
        UPDATE CashSessionSnapShot
           SET Remains = CashSessionSnapShot.Remains - MovementItem.Amount
        FROM
             (SELECT MovementItem.ObjectId, SUM (MovementItem.Amount) AS Amount
              FROM MovementItem
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                ON MovementLinkObject_PartionDateKind.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.Amount > 0
                AND vbMessageText = ''
              GROUP BY MovementItem.ObjectId
             ) AS MovementItem
        WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
          AND CashSessionSnapShot.ObjectId = MovementItem.ObjectId
          AND COALESCE(PartionDateKindId, 0) = COALESCE(MovementLinkObject_PartionDateKind.ObjectId, 0)
       ;

        -- определяем разницу в остатках реальных и сессионных
        CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MinExpirationDate TDateTime
                           , PartionDateKindId  Integer
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean
                           , AccommodationId Integer
                           , Color_calc Integer) ON COMMIT DROP;

        -- заливаем разницу
        INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow)
        SELECT ObjectId
             , GoodsCode
             , GoodsName
             , Price
             , Remains
             , MinExpirationDate
             , PartionDateKindId
             , MCSValue
             , Reserved
             , NewRow
             , AccommodationId
             , Color_calc FROM gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar);

        -- Возвращаем разницу в клиента
        RETURN QUERY
            SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.MinExpirationDate,
            NULLIF (_DIFF.PartionDateKindId, 0),
            Object_PartionDateKind.Name    AS PartionDateKindName,
            _DIFF.NewRow,
            _DIFF.AccommodationId,
            Object_Accommodation.ValueData AS AccommodationName,
            Object_PartionDateKind.AmountMonth                       AS AmountMonth,
            COALESCE(tmpPDChangePercentGoods.PartionDateDiscount,
                     tmpPDChangePercent.PartionDateDiscount)::TFloat AS PartionDateDiscount,
            _DIFF.Color_calc
        FROM _DIFF
            LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = _DIFF.AccommodationId
            LEFT JOIN tmpPDChangePercent ON tmpPDChangePercent.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN tmpPDChangePercentGoods ON tmpPDChangePercentGoods.Id = NULLIF (_DIFF.PartionDateKindId, 0)
                                            AND tmpPDChangePercentGoods.GoodsId = _DIFF.ObjectId;
    ELSE
        RETURN QUERY
            SELECT
                Null::Integer  AS ObjectId,
                NULL::Integer  AS GoodsCode,
                NULL::TVarChar AS GoodsName,
                NULL::TFloat   AS Price,
                NULL::TFloat   AS Remains,
                NULL::TFloat   AS MCSValue,
                NULL::TFloat   AS Reserved,
                NULL::TDateTime   AS MinExpirationDate,
                NULL::Integer  AS PartionDateKindId,
                NULL::TVarChar AS PartionDateKindName,
                NULL::Boolean  AS NewRow,
                NULL::Integer  AS AccommodationId,
                NULL::TVarChar AS AccommodationName,
                NULL::Integer  AS AmountMonth,
                NULL::TFloat   AS PartionDateDiscount,
                NULL::Integer  AS Color_calc
            WHERE
                1 = 0;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В
 02.11.18                                                                                    * add TotalSummPayAdd
 10.09.15                                                                       *  CashSession
 06.07.15                                                                       *  Добавлен тип оплаты
 05.02.15                         *

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')