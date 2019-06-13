-- Function: gpSelect_MovementItem_SendPartionDate()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendPartionDate (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendPartionDate (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendPartionDate(
    IN inMovementId  Integer      , -- ключ Документа
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

    -- текущие остатки по подразделению
    CREATE TEMP TABLE tmpCountPartionDate (ContainerId Integer, GoodsId Integer, Amount TFloat, AmountRemains TFloat, Amount_0 TFloat, Amount_1 TFloat, Amount_2 TFloat) ON COMMIT DROP;
          INSERT INTO tmpCountPartionDate (ContainerId, GoodsId, Amount, AmountRemains, Amount_0, Amount_1, Amount_2)
                 SELECT Container.Id         AS ContainerId
                      , Container.ObjectId   AS GoodsId
                      , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN  Container.Amount ELSE 0 END) AS Amount
                      , SUM (Container.Amount) AS AmountRemains
                      , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN Container.Amount ELSE 0 END) AS Amount_0   -- просрочено
                      , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate THEN Container.Amount ELSE 0 END) AS Amount_1   -- Меньше 1 месяца
                      , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30 THEN Container.Amount ELSE 0 END) AS Amount_2   -- Меньше 6 месяца
                 FROM Container
                      JOIN ContainerLinkObject AS CLO_Unit 
                                               ON CLO_Unit.ContainerId = Container.Id
                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                              AND CLO_Unit.ObjectId = vbUnitId
                      LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                                    ON CLO_PartionGoods.ContainerId = Container.Id
                                                   AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      LEFT JOIN ContainerLinkObject AS CLO_PartionMovementItem 
                                                    ON CLO_PartionMovementItem.ContainerId = Container.Id
                                                   AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()

                      LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
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
                     
                 WHERE Container.DescId = zc_Container_CountPartionDate()
                 GROUP BY Container.Id
                        , Container.ObjectId;
                 
                 
          -- Результат другой
          OPEN Cursor1 FOR
               WITH
                   MI_Master AS (SELECT MovementItem.Id                    AS Id
                                      , MovementItem.ObjectId              AS GoodsId
                                      , MovementItem.Amount                AS Amount
                                      , MIFloat_AmountRemains.ValueData    AS AmountRemains
                                      , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                      , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin
                                      , MovementItem.isErased              AS isErased
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                 ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                                 ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                                AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                                 ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master() 
                                   AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                 )  

                 , MI_Child AS (SELECT MovementItem.ParentId
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN MovementItem.Amount ELSE 0 END) AS Amount_0   -- просрочено
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 THEN MovementItem.Amount ELSE 0 END) AS Amount_1   -- Меньше 1 месяца
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN MovementItem.Amount ELSE 0 END) AS Amount_2   -- Меньше 6 месяцев
                                     --, SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate180 THEN MovementItem.Amount ELSE 0 END) AS Amount   -- Более 6 месяцев
                                     --, SUM (CASE WHEN MILinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0() THEN MovementItem.Amount ELSE 0 END) AS Amount_0   -- просрочено
                                     --, SUM (CASE WHEN MILinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_1() THEN MovementItem.Amount ELSE 0 END) AS Amount_1   -- Меньше 1 месяца
                                     --, SUM (CASE WHEN MILinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_6() THEN MovementItem.Amount ELSE 0 END) AS Amount_2   -- Меньше 1 месяца
                                     , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())) AS ExpirationDate
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <> COALESCE (MIDate_ExpirationDate_in.ValueData, zc_DateEnd()) THEN 1 ELSE 0 END) AS isExpirationDateDiff
                                FROM MovementItem
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                     ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                                    LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                              AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()

                                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                    -- находим срок годности из прихода
                                    LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                                  ON CLO_PartionMovementItem.Containerid = (MIFloat_ContainerId.ValueData :: Integer)
                                                                 AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                               
                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate_in
                                                                      ON MIDate_ExpirationDate_in.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate_in.DescId = zc_MIDate_PartionGoods()

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

                    , tmpCountPartionDate.Amount         :: TFloat  AS AmountPartionDate
                    , tmpCountPartionDate.Amount_0       :: TFloat  AS AmountPartionDate_0
                    , tmpCountPartionDate.Amount_1       :: TFloat  AS AmountPartionDate_1
                    , tmpCountPartionDate.Amount_2       :: TFloat  AS AmountPartionDate_2
                    
                    , MI_Child.ExpirationDate    :: TDateTime AS ExpirationDate
                    , MI_Master.ChangePercent    :: TFloat    AS ChangePercent
                    , MI_Master.ChangePercentMin :: TFloat    AS ChangePercentMin
                    , CASE WHEN MI_Child.isExpirationDateDiff > 0 THEN TRUE ELSE FALSE END AS isExpirationDateDiff
                    , MI_Master.IsErased                      AS isErased
               FROM MI_Master
                   LEFT JOIN MI_Child ON MI_Child.ParentId = MI_Master.Id
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId
                   LEFT JOIN tmpCountPartionDate ON tmpCountPartionDate.GoodsId = MI_Master.GoodsId;
   
          RETURN NEXT Cursor1;
   
          OPEN Cursor2 FOR
               WITH
                   MI_Child AS (SELECT MovementItem.Id                    AS Id
                                     , MovementItem.ParentId              AS ParentId
                                     , MovementItem.ObjectId              AS GoodsId
                                     , MovementItem.Amount                AS Amount
                                     , MIFloat_ContainerId.ValueData      AS ContainerId
                                     --, MILinkObject_PartionDateKind.ObjectId  AS PartionDateKindId
                                     , CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                                            WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 THEN zc_Enum_PartionDateKind_1()
                                            WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30   AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6()
                                            ELSE 0
                                       END                                AS PartionDateKindId

                                     , MIFloat_MovementId.ValueData ::Integer AS MovementId_Income
                                     , MIDate_ExpirationDate.ValueData    AS ExpirationDate
                                     , COALESCE (MIDate_ExpirationDate_in.ValueData, zc_DateEnd())  AS ExpirationDate_in
                                     , MovementItem.isErased              AS isErased
                                FROM MovementItem
                                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                    /*LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                     ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()*/
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                                    LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()

                                    -- находим срок годности из прихода
                                    LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                                  ON CLO_PartionMovementItem.Containerid = (MIFloat_ContainerId.ValueData :: Integer)
                                                                 AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                               
                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate_in
                                                                      ON MIDate_ExpirationDate_in.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate_in.DescId = zc_MIDate_PartionGoods()

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
                 , MI_Child.ExpirationDate    ::TDateTime
                 , MI_Child.ExpirationDate_in ::TDateTime
                 , MI_Child.Amount            ::TFloat AS Amount
                 , tmpCountPartionDate.Amount ::TFloat AS AmountPartionDate

                 , MI_Child.ContainerId       ::TFloat
                 , ObjectFloat_Month.ValueData         AS Expired
                 , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName

                 , MI_Child.MovementId_Income    AS MovementId_Income
                 , tmpIncome.BranchDate          AS OperDate_Income
                 , tmpIncome.Invnumber           AS Invnumber_Income
                 , tmpIncome.FromName            AS FromName_Income
                 , tmpIncome.ContractName        AS ContractName_Income

                 , CASE WHEN MI_Child.ExpirationDate <> MI_Child.ExpirationDate_in THEN TRUE ELSE FALSE END AS isExpirationDateDiff

                 , MI_Child.IsErased             AS isErased

               FROM MI_Child
                    LEFT JOIN tmpIncome ON tmpIncome.Id = MI_Child.MovementId_Income
                    
                    LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_Child.PartionDateKindId
                    
                    LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                          ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                         AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

                    LEFT JOIN tmpCountPartionDate ON tmpCountPartionDate.ContainerId = MI_Child.ContainerId;  
   
          RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.19         *
 03.04.19         *
*/
--select * from gpSelect_MovementItem_SendPartionDate(inMovementId := 4516628 , inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_SendPartionDate(inMovementId := 13671795, inIsErased := 'True' ,  inSession := '3');