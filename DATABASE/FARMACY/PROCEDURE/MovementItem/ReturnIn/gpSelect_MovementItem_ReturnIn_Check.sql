-- Function: gpSelect_MovementItem_ReturnIn_Check()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn_Check(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ContainerId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountCheck TFloat
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , List_UID TVarChar

             , OperDateIncome TDateTime
             , InvnumberIncome TVarChar
             , FromNameIncome TVarChar
             , ExpirationDate TDateTime
             , PartionDateKindId Integer
             , PartionDateKindName TVarChar
             , AccommodationId Integer, AccommodationName TVarChar
             , UKTZED TVarChar

             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbParentId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbRoundingTo10 Boolean;
  DECLARE vbRoundingTo50 Boolean;
  DECLARE vbRoundingDown Boolean;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpReturnInRight (inSession, zc_Enum_Process_Select_MovementItem_ReturnIn());
     vbUserId := inSession;

     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    --Определили подразделение для розничной цены и дату для остатка
    SELECT
          MovementFloat_MovementId.ValueData::Integer
        , MovementLinkObject_Unit.ObjectId
        , COALESCE (MB_RoundingTo10.ValueData, FALSE)::boolean
        , COALESCE (MB_RoundingDown.ValueData, FALSE)::boolean
        , COALESCE(MB_RoundingTo50.ValueData, FALSE)
    INTO
        vbParentId, vbUnitId, vbRoundingTo10, vbRoundingDown, vbRoundingTo50

    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                ON MovementFloat_MovementId.MovementId = Movement.Id
                               AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
        LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                  ON MB_RoundingTo10.MovementId = MovementFloat_MovementId.ValueData::Integer
                                 AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
        LEFT JOIN MovementBoolean AS MB_RoundingDown
                                  ON MB_RoundingDown.MovementId = MovementFloat_MovementId.ValueData::Integer
                                 AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
        LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                  ON MB_RoundingTo50.MovementId = MovementFloat_MovementId.ValueData::Integer
                                 AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
    WHERE Movement.Id = inMovementId;


    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

     -- Результат
     RETURN QUERY
     WITH
        tmpContainer AS (SELECT MovementItemContainer.ContainerId                    AS ContainerId
                              , (-1 * MovementItemContainer.Amount)::TFloat          AS Amount
                              , MovementItemContainer.Price                          AS Price
                              , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                              , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)       AS M_IncomeId
                          FROM MovementItemContainer

                               LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                             ON ContainerLinkObject_MovementItem.Containerid = MovementItemContainer.ContainerId
                                                            AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                               LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                               -- элемент прихода
                               LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                               -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                           ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                               -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                               LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                          WHERE MovementItemContainer.DescId = zc_MIContainer_Count()
                            AND MovementItemContainer.MovementId = vbParentId
                         ),
        tmpContainerPD AS (SELECT Container.ParentId                                       AS ContainerId
                                , Max(COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())) AS ExpirationDate
                                , Max(CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                                COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                 THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                           WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                           WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                           WHEN ObjectDate_Value.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                           WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                           WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END)  AS PartionDateKindId
                            FROM MovementItemContainer

                                  LEFT JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MovementItemContainer.ContainerId
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                             ON ObjectDate_Value.ObjectId = ContainerLinkObject.ObjectId
                                                            AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                          ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                         AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                            WHERE MovementItemContainer.DescId = zc_MIContainer_CountPartionDate()
                              AND MovementItemContainer.MovementId = vbParentId
                            GROUP BY Container.ParentId
                           ),
        tmpMI AS (SELECT MovementItem.Id
                       , MIFloat_ContainerId.ValueData :: Integer            AS ContainerId
                       , MovementItem.Amount                                 AS Amount
                       , MovementItem.isErased                               AS isErased

                  FROM  MovementItem

                        LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                    ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                           ),
        tmpExpirationDate AS (SELECT *
                              FROM MovementItemDate  AS MIDate_ExpirationDate
                              WHERE MIDate_ExpirationDate.MovementItemId in (SELECT DISTINCT tmpContainer.MI_IncomeId FROM tmpContainer)
                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                              ),
        tmpIncome AS (SELECT Container.ContainerId                    AS ContainerId
                           , M_Income.OperDate                        AS OperDate
                           , M_Income.Invnumber                       AS Invnumber
                           , Object_From.ValueData                    AS FromName
                           , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                      FROM tmpContainer AS Container

                            -- прихода от поставщика
                           LEFT JOIN Movement AS M_Income ON M_Income.Id  = Container.M_IncomeId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = M_Income.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                           LEFT OUTER JOIN tmpExpirationDate  AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = Container.MI_IncomeId
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                     ),
          tmpPartionDateKind AS (SELECT *
                                 FROM Object AS Object_PartionDateKind
                                 WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
                                 ),
          tmpGoodsUKTZED AS (SELECT Object_Goods_Juridical.GoodsMainId
                                  , REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')::TVarChar AS UKTZED
                                  , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Juridical.GoodsMainId
                                                 ORDER BY COALESCE(Object_Goods_Juridical.AreaId, 0), Object_Goods_Juridical.JuridicalId) AS Ord
                             FROM Object_Goods_Juridical
                             WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
                               AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                               AND Object_Goods_Juridical.GoodsMainId <> 0
                             )

            -- результат
            SELECT MovementItem.Id
                 , MovementItem.ContainerId   AS ContainerId
                 , Object_Goods.Id            AS GoodsId
                 , Object_Goods.ObjectCode    AS GoodsCode
                 , Object_Goods.ValueData     AS GoodsName
                 , tmpContainer.Amount        AS AmountCheck
                 , MovementItem.Amount        AS Amount
                 , MIFloat_Price.ValueData    AS Price

                 , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                                   , vbRoundingDown, vbRoundingTo10, vbRoundingTo50) AS Summ

                 , ObjectFloat_NDSKind_NDS.ValueData  AS NDS
                 , MIString_UID.ValueData     AS List_UID

                 , tmpIncome.OperDate          AS OperDateIncome
                 , tmpIncome.Invnumber         AS InvnumberIncome
                 , tmpIncome.FromName          AS FromNameIncome
                 , COALESCE (tmpContainerPD.ExpirationDate, tmpIncome.ExpirationDate)::TDateTime  AS ExpirationDate

                 , tmpContainerPD.PartionDateKindId  AS PartionDateKindId
                 , Object_PartionDateKind.ValueData  AS PartionDateKindName

                 , Accommodation.AccommodationId     AS AccommodationId
                 , Object_Accommodation.ValueData AS AccommodationName

                 , tmpGoodsUKTZED.UKTZED             AS UKTZED

                 , MovementItem.isErased      AS isErased

            FROM tmpMI AS MovementItem

                  LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MovementItem.ContainerId

                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                  LEFT JOIN MovementItemString AS MIString_UID
                                               ON MIString_UID.MovementItemId = MovementItem.Id
                                              AND MIString_UID.DescId = zc_MIString_UID()

                  LEFT JOIN Container AS Container ON Container.Id = MovementItem.ContainerId

                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Container.ObjectId

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                  LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                  LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                  LEFT JOIN tmpIncome ON tmpIncome.ContainerId = MovementItem.ContainerId

                  LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = MovementItem.ContainerId
                  LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainerPD.PartionDateKindId

                   -- Размещение товара
                  LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                         ON Accommodation.UnitId = vbUnitId
                                                        AND Accommodation.GoodsId = Container.ObjectId
                                                        AND Accommodation.isErased = False
                  LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId

                  -- Коды UKTZED
                  LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                  LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                          AND tmpGoodsUKTZED.Ord = 1
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.19         *
*/

-- тест
--  select * from lpDelete_MovementItem (365195207, '3');
select * from gpSelect_MovementItem_ReturnIn_Check(inMovementId := 20242591, inSession := '3');
