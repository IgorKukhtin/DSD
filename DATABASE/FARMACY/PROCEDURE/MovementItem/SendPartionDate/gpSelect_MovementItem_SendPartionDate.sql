-- Function: gpSelect_MovementItem_SendPartionDate()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendPartionDate (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendPartionDate(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbDate180  TDateTime;
    DECLARE vbDate30   TDateTime;

   DECLARE vbMonth_0  TFloat;
   DECLARE vbMonth_1  TFloat;
   DECLARE vbMonth_6  TFloat;
   
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendPartionDate());
    vbUserId:= lpGetUserBySession (inSession);

    vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                 FROM MovementLinkObject AS MovementLinkObject_Unit
                 WHERE MovementLinkObject_Unit.MovementId = inMovementId
                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                );

    --vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
    --vbDate180 := CURRENT_DATE + INTERVAL '6 MONTH';
    --vbDate30  := CURRENT_DATE + INTERVAL '1 MONTH';

    -- получаем значения из справочника 
    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbOperDate:= CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;


    IF inShowAll
    THEN    
        -- остатки по подразделению
    CREATE TEMP TABLE tmpRemains (ContainerId Integer, MovementId_Income Integer, GoodsId Integer, PartionDateKindId Integer, Amount TFloat, AmountRemains TFloat, Amount_0 TFloat, Amount_1 TFloat, Amount_2 TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO tmpRemains (ContainerId, MovementId_Income, GoodsId, PartionDateKindId, Amount, AmountRemains, Amount_0, Amount_1, Amount_2, ExpirationDate)
           SELECT tmp.ContainerId
                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                , tmp.GoodsId
                , CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                       WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 
                        AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate THEN zc_Enum_PartionDateKind_1() 
                       WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
                        AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) >  vbDate30 THEN zc_Enum_PartionDateKind_6()
                       ELSE 999
                  END AS PartionDateKindId
                , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN  tmp.Amount ELSE 0 END) AS Amount
                , SUM (tmp.Amount) AS AmountRemains

                , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN tmp.Amount ELSE 0 END) AS Amount_0   -- просрочено
                , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate THEN tmp.Amount ELSE 0 END) AS Amount_1   -- Меньше 1 месяца
                , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30 THEN tmp.Amount ELSE 0 END) AS Amount_2   -- Меньше 6 месяца

                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                
           FROM (SELECT Container.Id  AS ContainerId
                      , Container.ObjectId            AS GoodsId
                      , SUM(Container.Amount)::TFloat AS Amount
                 FROM Container
                 WHERE Container.DescId = zc_Container_Count()
                   --AND Container.ObjectId = inGoodsId
                   AND Container.WhereObjectId = vbUnitId
                   AND Container.Amount <> 0
                 GROUP BY Container.Id
                        , Container.ObjectId   
                 HAVING SUM(Container.Amount) <> 0
                 ) AS tmp
              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
              -- элемент прихода
              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                         
              LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
          -- WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
           GROUP BY tmp.ContainerId
                  , tmp.GoodsId
                  , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                  , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                  , CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                         WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 
                          AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate THEN zc_Enum_PartionDateKind_1() 
                         WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
                          AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) >  vbDate30 THEN zc_Enum_PartionDateKind_6()
                         ELSE 999
                    END
           ;
           
       -- Результат другой
       OPEN Cursor1 FOR
            WITH
            MI_Master AS (SELECT MovementItem.Id                    AS Id
                               , MovementItem.ObjectId              AS GoodsId
                               , MovementItem.Amount                AS Amount
                               , MIFloat_AmountRemains.ValueData    AS AmountRemains
                               , MIFloat_Price.ValueData            AS Price
                               , COALESCE (MIFloat_PriceExp.ValueData, MIFloat_Price.ValueData) AS PriceExp
                               , MovementItem.isErased              AS isErased
                          FROM  MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceExp
                                                          ON MIFloat_PriceExp.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PriceExp.DescId = zc_MIFloat_PriceExp()
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                          ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId = zc_MI_Master() 
                            AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                          )  
                              
          , tmpPrice AS (SELECT Price_Goods.ChildObjectId                AS GoodsId
                              , ROUND(Price_Value.ValueData, 2) ::TFloat AS Price
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              LEFT JOIN ObjectFloat AS Price_Value
                                                    ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                              LEFT JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit() 
                           AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                         )

    SELECT COALESCE(MI_Master.Id,0)                     AS Id
         -- , COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId) AS GoodsId
          , Object_Goods.Id            AS GoodsId
          , Object_Goods.ObjectCode    AS GoodsCode
          , Object_Goods.ValueData     AS GoodsName
          , COALESCE (MI_Master.Amount, tmpRemains.Amount)                          AS Amount
          , COALESCE (MI_Master.AmountRemains, tmpRemains.AmountRemains) ::TFloat   AS AmountRemains
          , tmpRemains.Amount_0
          , tmpRemains.Amount_1
          , tmpRemains.Amount_2
          , tmpRemains.Amount_all
          , tmpRemains.ExpirationDate :: TDateTime AS ExpirationDate
          , COALESCE (MI_Master.Price, tmpPrice.Price)    AS Price
          , COALESCE (MI_Master.PriceExp, tmpPrice.Price) AS PriceExp
          --, COALESCE(MI_Master.IsErased, FALSE)          AS isErased
    FROM (SELECT tmpRemains.GoodsId
               , MIN (tmpRemains.ExpirationDate) AS ExpirationDate
               , SUM (tmpRemains.AmountRemains)  AS AmountRemains
               , SUM (tmpRemains.Amount)         AS Amount
               , SUM (tmpRemains.Amount_0)       AS Amount_0
               , SUM (tmpRemains.Amount_1)       AS Amount_1
               , SUM (tmpRemains.Amount_2)       AS Amount_2
               , SUM (tmpRemains.AmountRemains - (tmpRemains.Amount_0 + tmpRemains.Amount_1 + tmpRemains.Amount_2) ) AS Amount_all
          FROM tmpRemains 
          GROUP BY tmpRemains.GoodsId
          ) AS tmpRemains 
        FULL OUTER JOIN MI_Master ON MI_Master.GoodsId = tmpRemains.GoodsId
        LEFT JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId)
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId)
        ;

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
       WITH
           MI_Master AS (SELECT MovementItem.Id       AS Id
                              , MovementItem.ObjectId AS GoodsId
                         FROM  MovementItem
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.IsErased = FALSE
                         )   
         , MI_Child AS (SELECT MovementItem.Id               AS Id
                             , MovementItem.ParentId         AS ParentId
                             , MovementItem.ObjectId         AS GoodsId
                             , MIFloat_ContainerId.ValueData AS ContainerId
                             , MovementItem.isErased
                        FROM MovementItem
                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Child() 
                          AND MovementItem.isErased = FALSE
                         )

         , tmpIncome AS (SELECT Movement.Id
                              , MovementDate_Branch.ValueData AS BranchDate
                              , Movement.Invnumber            AS Invnumber
                              , Object_From.ValueData         AS FromName
                              , Object_Contract.ValueData     AS ContractName
                         FROM Movement
                              LEFT JOIN MovementDate AS MovementDate_Branch
                                                     ON MovementDate_Branch.MovementId = Movement.Id
                                                    AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                              LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                         WHERE Movement.Id IN (SELECT DISTINCT tmpRemains.MovementId_Income FROM tmpRemains)
                         )

         --связвываем чайлд с мастером
         SELECT COALESCE (MI_Child.Id,0)                        AS Id
              , COALESCE (MI_Master.Id, MI_Child.ParentId, 0)      AS ParentId
              , COALESCE (MI_Child.GoodsId, tmpRemains.GoodsId) AS GoodsId
              , tmpRemains.Amount                               AS Amount
              , tmpRemains.ContainerId                 ::Integer

              , COALESCE (Object_PartionDateKind.ValueData, '') :: TVarChar AS PartionDateKindName
              , ObjectFloat_Month.ValueData  ::TFloat AS Expired
              , tmpRemains.ExpirationDate
              , tmpRemains.MovementId_Income  AS MovementId_Income
              , tmpIncome.BranchDate          AS OperDate_Income
              , tmpIncome.Invnumber           AS Invnumber_Income
              , tmpIncome.FromName            AS FromName_Income
              , tmpIncome.ContractName        AS ContractName_Income
              , COALESCE (MI_Child.isErased, FALSE) AS isErased
         FROM (SELECT tmpRemains.*
               FROM tmpRemains 
               WHERE tmpRemains.ExpirationDate <= vbDate180
               ) AS tmpRemains
             FULL JOIN MI_Child ON MI_Child.GoodsId     = tmpRemains.GoodsId
                               AND MI_Child.ContainerId = tmpRemains.ContainerId
             LEFT JOIN MI_Master ON MI_Master.GoodsId = COALESCE (MI_Child.GoodsId, tmpRemains.GoodsId)
             LEFT JOIN tmpIncome ON tmpIncome.Id = tmpRemains.MovementId_Income

             LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpRemains.PartionDateKindId
             LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                   ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                  AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

             ;

       RETURN NEXT Cursor2;
   
   ELSE
            -- Результат другой
          OPEN Cursor1 FOR
               WITH
                   MI_Master AS (SELECT MovementItem.Id                    AS Id
                                      , MovementItem.ObjectId              AS GoodsId
                                      , MovementItem.Amount                AS Amount
                                      , MIFloat_AmountRemains.ValueData    AS AmountRemains
                                      , MIFloat_Price.ValueData            AS Price
                                      , COALESCE (MIFloat_PriceExp.ValueData, MIFloat_Price.ValueData) AS PriceExp
                                      , MovementItem.isErased              AS isErased
                                 FROM  MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                     LEFT JOIN MovementItemFloat AS MIFloat_PriceExp
                                                                 ON MIFloat_PriceExp.MovementItemId = MovementItem.Id
                                                                AND MIFloat_PriceExp.DescId = zc_MIFloat_PriceExp()
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                                 ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master() 
                                   AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                 )  

                 , MI_Child AS (SELECT MovementItem.ParentId
                                     , SUM (CASE WHEN MILinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0() THEN MovementItem.Amount ELSE 0 END) AS Amount_0   -- просрочено
                                     , SUM (CASE WHEN MILinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_1() THEN MovementItem.Amount ELSE 0 END) AS Amount_1   -- Меньше 1 месяца
                                     , SUM (CASE WHEN MILinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_6() THEN MovementItem.Amount ELSE 0 END) AS Amount_2   -- Меньше 1 месяца
                                     , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())) AS ExpirationDate
                                FROM  MovementItem
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                     ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                                    LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                              AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Child() 
                                  AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE)
                                GROUP BY MovementItem.ParentId
                                 )

               SELECT MI_Master.Id               AS Id
                    , MI_Master.GoodsId          AS GoodsId
                    , Object_Goods.ObjectCode    AS GoodsCode
                    , Object_Goods.ValueData     AS GoodsName
                    , MI_Master.Amount           AS Amount
                    , MI_Master.AmountRemains    AS AmountRemains
                    , MI_Child.Amount_0       :: TFloat    AS Amount_0
                    , MI_Child.Amount_1       :: TFloat    AS Amount_1
                    , MI_Child.Amount_2       :: TFloat    AS Amount_2
                    , (COALESCE (MI_Master.AmountRemains,0) - (COALESCE (MI_Child.Amount_0,0) + COALESCE (MI_Child.Amount_1,0) + COALESCE (MI_Child.Amount_2,0))) :: TFloat AS Amount_all
                    , MI_Child.ExpirationDate :: TDateTime AS ExpirationDate
                    , MI_Master.Price          :: TFloat   AS Price
                    , MI_Master.PriceExp       :: TFloat   AS PriceExp
                    , MI_Master.IsErased                   AS isErased
               FROM MI_Master
                   LEFT JOIN MI_Child ON MI_Child.ParentId = MI_Master.Id
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId;
   
          RETURN NEXT Cursor1;
   
          OPEN Cursor2 FOR
               WITH
                   MI_Child AS (SELECT MovementItem.Id                    AS Id
                                     , MovementItem.ParentId              AS ParentId
                                     , MovementItem.ObjectId              AS GoodsId
                                     , MovementItem.Amount                AS Amount
                                     , MIFloat_ContainerId.ValueData      AS ContainerId
                                     , MILinkObject_PartionDateKind.ObjectId  AS PartionDateKindId
                                     , MIFloat_MovementId.ValueData ::Integer AS MovementId_Income
                                     , MIDate_ExpirationDate.ValueData    AS ExpirationDate
                                     , MovementItem.isErased              AS isErased
                                FROM  MovementItem
                                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                     ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                                    LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()
   
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Child() 
                                  AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                 )

                 , tmpIncome AS (SELECT Movement.Id
                                      , MovementDate_Branch.ValueData AS BranchDate
                                      , Movement.Invnumber            AS Invnumber
                                      , Object_From.ValueData         AS FromName
                                      , Object_Contract.ValueData     AS ContractName
                                 FROM Movement
                                      LEFT JOIN MovementDate AS MovementDate_Branch
                                                             ON MovementDate_Branch.MovementId = Movement.Id
                                                            AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                      LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                                 WHERE Movement.Id IN (SELECT DISTINCT MI_Child.MovementId_Income FROM MI_Child)
                                 )
                                         
               SELECT
                   COALESCE (MI_Child.Id, 0)        AS Id
                 , COALESCE (MI_Child.ParentId, 0)  AS ParentId
                 , MI_Child.GoodsId AS GoodsId
                 , MI_Child.ExpirationDate ::TDateTime
                 , MI_Child.Amount         ::TFloat AS Amount
                 , MI_Child.ContainerId    ::TFloat
                 , ObjectFloat_Month.ValueData      AS Expired
                 , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName

                 , MI_Child.MovementId_Income    AS MovementId_Income
                 , tmpIncome.BranchDate          AS OperDate_Income
                 , tmpIncome.Invnumber           AS Invnumber_Income
                 , tmpIncome.FromName            AS FromName_Income
                 , tmpIncome.ContractName        AS ContractName_Income

                 , MI_Child.IsErased             AS isErased

               FROM MI_Child
                    LEFT JOIN tmpIncome ON tmpIncome.Id = MI_Child.MovementId_Income
                    
                    LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_Child.PartionDateKindId
                    LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                          ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                         AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
               ;  
   
          RETURN NEXT Cursor2;
   END IF; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.19         *
*/
--select * from gpSelect_MovementItem_SendPartionDate(inMovementId := 4516628 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_SendPartionDate(inMovementId := 13671795 , inShowAll := 'True' , inIsErased := 'True' ,  inSession := '3');