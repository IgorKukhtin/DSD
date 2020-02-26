-- Function: gpSelect_MovementItem_Send_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ContainerId TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             , PartionDateKindName TVarChar
             , DateInsert          TDateTime
             , PartyRelated        Boolean
             , Color_calc Integer
              )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbUserId Integer;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;

  DECLARE vbUnitId Integer;
  DECLARE vbPartionDateId Integer;
  DECLARE vbisSUN      Boolean;
  DECLARE vbisDeferred Boolean;
  DECLARE vbStatusID   Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId := inSession;

    -- параметры документа
    SELECT Movement.OperDate
         , Movement.StatusID
         , MovementLinkObject_From.ObjectId
         , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)
         , COALESCE (MovementLinkObject_PartionDateKind.ObjectId, 0)
         , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
    INTO vbOperDate
       , vbStatusID
       , vbUnitId
       , vbisSUN
       , vbPartionDateId
       , vbisDeferred
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                   ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                  AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_SUN()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                      ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                     AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement.Id = inMovementId;

    -- дата + 6 месяцев
    vbDate_6:= vbOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 1 месяц
    vbDate_1:= vbOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               )
               -- меняем: добавим еще 9 дней, будет от 60 дней включительно - только для СУН
             + INTERVAL '9 DAY'
             ;
    -- дата + 0 месяцев
    vbDate_0 := vbOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );

     IF vbStatusID = zc_Enum_Status_Complete() OR vbisDeferred = TRUE
     THEN

       -- Для проведенных и отложенных показываем что реально провелось

       RETURN QUERY
       WITH
           tmpMI_Child AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Child()
                        AND MovementItem.Amount > 0
                     )
         , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                           , MovementItemFloat.ValueData::Integer  AS ContainerId
                                      FROM MovementItemFloat
                                      WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                        AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                      )
         , tmpMI_Child_ContainerId AS (SELECT tmpMIFloat_ContainerId.ContainerId
                                            , MovementItem.Id                     AS MovementItemId
                                            , MovementItem.ParentID               AS ParentID
                                       FROM tmpMI_Child AS MovementItem
                                            INNER JOIN tmpMIFloat_ContainerId ON tmpMIFloat_ContainerId.MovementItemId = MovementItem.ID
                                       GROUP BY MovementItem.Id, MovementItem.ParentID, tmpMIFloat_ContainerId.ContainerId
                                       )
         , tmpMIContainerPD AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                     , Container.ParentId                       AS ParentId
                                     , - MovementItemContainer.Amount      AS Amount
                                 FROM  MovementItemContainer

                                       INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                                 WHERE MovementItemContainer.MovementId = inMovementId
                                   AND MovementItemContainer.DescId = zc_Container_CountPartionDate()
                                 )
         , tmpMIContainerAll AS ( SELECT MovementItemContainer.MovementItemID      AS MovementItemId
                                        , MovementItemContainer.ContainerID        AS ContainerID
                                        , MovementItemContainer.DescId
                                        , - MovementItemContainer.Amount - COALESCE(tmpMIContainerPD.Amount, 0) AS Amount
                                   FROM  MovementItemContainer

                                         LEFT JOIN tmpMIContainerPD ON tmpMIContainerPD.Id  = MovementItemContainer.MovementItemID
                                                                   AND tmpMIContainerPD.ParentId = MovementItemContainer.ContainerID

                                   WHERE MovementItemContainer.MovementId = inMovementId
                                     AND MovementItemContainer.DescId IN (zc_Container_Count(), zc_Container_CountPartionDate())
                                     AND COALESCE(MovementItemContainer.isActive, FALSE) = FALSE
                                     AND (- MovementItemContainer.Amount - COALESCE(tmpMIContainerPD.Amount, 0)) <> 0
                                   )
         , tmpContainer AS (SELECT tmp.ContainerId
                                 , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                                 , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                        WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                        WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                        WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- Востановлен с просрочки
                            FROM (SELECT DISTINCT tmpMIContainerAll.ContainerId FROM tmpMIContainerAll) AS tmp
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = tmp.ContainerId
                                                              AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                 LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                            ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                           AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = CLO_PartionGoods.ObjectId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                 LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                               ON CLO_MovementItem.Containerid = tmp.ContainerId
                                                              AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
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
                           )
          --
         , tmpPartion AS (SELECT Movement.Id
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
                          WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                          )

         SELECT
               COALESCE(tmpMI_Child_ContainerId.MovementItemId, 0)            AS ID
             , COALESCE(MovementItem.ParentId, MovementItem.Id)               AS ParentId
             , Object_Goods.Id            AS GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
             , Container.Amount::TFloat   AS Amount

             , Container.ContainerId:: TFloat                                 AS ContainerId
             , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime AS ExpirationDate
             , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
             , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
             , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
             , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income

             , Object_PartionDateKind.ValueData                  :: TVarChar  AS PartionDateKindName
             , DATE_TRUNC ('DAY', MIDate_Insert.ValueData)       :: TDateTime AS DateInsert
             , CASE WHEN COALESCE(tmpMI_Child_ContainerId.MovementItemId, 0) = 0 THEN FALSE ELSE TRUE END AS PartyRelated

             , zc_Color_Black()                                               AS Color_calc
         FROM tmpMIContainerAll AS Container

              LEFT JOIN MovementItem ON MovementItem.ID = Container.MovementItemId

              LEFT JOIN tmpMI_Child_ContainerId ON tmpMI_Child_ContainerId.ContainerId = Container.ContainerId
                                               AND tmpMI_Child_ContainerId.MovementItemId = MovementItem.Id

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

              LEFT JOIN tmpContainer ON tmpContainer.ContainerId = Container.ContainerId
              LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
              LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId
              LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
         ;

     ELSE

       -- Для не проведенных предпологаемые проводки

       RETURN QUERY
       WITH
           tmpMI_Child AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Child()
                        AND MovementItem.Amount > 0
                     )
         , tmpMI_Master AS (SELECT MovementItem.*
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.Amount > 0
                               AND MovementItem.isErased = FALSE
                               AND MovementItem.ID not In (SELECT tmpMI_Child.ParentID FROM tmpMI_Child)
                            )
         , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                           , MovementItemFloat.ValueData::Integer  AS ContainerId
                                      FROM MovementItemFloat
                                      WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                        AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                      )
         , tmpMI_Child_ContainerId AS (SELECT tmpMIFloat_ContainerId.ContainerId
                                            , MovementItem.Id                     AS MovementItemId
                                            , MovementItem.ParentID               AS ParentID
                                            , SUM(MovementItem.Amount)            AS Amount
                                       FROM tmpMI_Child AS MovementItem
                                            INNER JOIN tmpMIFloat_ContainerId ON tmpMIFloat_ContainerId.MovementItemId = MovementItem.ID
                                       GROUP BY MovementItem.Id, MovementItem.ParentID, tmpMIFloat_ContainerId.ContainerId
                                       )
         , REMAINS AS ( --остатки
                       SELECT Container.Id
                            , Container.ObjectId --Товар
                            , Container.Amount - COALESCE(tmpMI_Child_ContainerId.Amount, 0) AS Amount  --Тек. остаток
                       FROM Container
                            INNER JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Container.ObjectId
                            LEFT JOIN tmpMI_Child_ContainerId ON tmpMI_Child_ContainerId.ContainerId = Container.Id
                       WHERE Container.DescID = zc_Container_Count()
                         AND Container.WhereObjectId = vbUnitId
                         AND  Container.Amount - COALESCE(tmpMI_Child_ContainerId.Amount, 0) > 0
                       )
          , DD AS (SELECT tmpMI_Master.ID     AS MovementItemId
                        , tmpMI_Master.Amount
                        , REMAINS.Amount      AS ContainerAmount
                        , REMAINS.Id          AS ContainerId
                        , SUM(REMAINS.Amount) OVER (PARTITION BY REMAINS.objectid ORDER BY Movement.OPERDATE, REMAINS.Id)
                   FROM REMAINS
                        JOIN tmpMI_Master ON tmpMI_Master.objectid = REMAINS.objectid
                        JOIN containerlinkobject AS CLI_MI
                                                 ON CLI_MI.containerid = REMAINS.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN containerlinkobject AS CLI_Unit
                                                 ON CLI_Unit.containerid = REMAINS.Id
                                                AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                AND CLI_Unit.ObjectId = vbUnitId
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE REMAINS.Amount > 0)
          , tmpMIContainerAll AS (SELECT
                                         NULL::Integer    AS ID
                                       , DD.ContainerId
                                       , DD.MovementItemId
                                       , CASE
                                           WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount
                                           ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                                         END AS Amount
                                   FROM DD
                                   WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                                   UNION ALL
                                   SELECT tmpMI_Child_ContainerId.MovementItemId
                                        , tmpMI_Child_ContainerId.ContainerId
                                        , tmpMI_Child_ContainerId.ParentID
                                        , tmpMI_Child_ContainerId.Amount
                                   FROM tmpMI_Child_ContainerId
                                        )
         , tmpContainer AS (SELECT tmp.ContainerId
                                 , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                                 , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                        WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                        WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                        WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- Востановлен с просрочки
                            FROM (SELECT tmpMIContainerAll.ContainerId 
                                       , max(Container.Id)              AS PDContainerId
                                  FROM tmpMIContainerAll 
                                       LEFT JOIN Container ON Container.ParentId = tmpMIContainerAll.ContainerId
                                                          AND Container.DescId = zc_Container_CountPartionDate()
                                                          AND Container.Amount > 0
                                  GROUP BY tmpMIContainerAll.ContainerId) AS tmp
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = tmp.PDContainerId
                                                              AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                 LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                            ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                           AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = CLO_PartionGoods.ObjectId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                 LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                               ON CLO_MovementItem.Containerid = tmp.ContainerId
                                                              AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
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
                           )
          --
         , tmpPartion AS (SELECT Movement.Id
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
                          WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                          )

         SELECT
               Container.ID::Integer      AS ID
             , MovementItem.Id            AS ParentId
             , Object_Goods.Id            AS GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
             , Container.Amount::TFloat   AS Amount

             , Container.ContainerId:: TFloat                                   AS ContainerId
             , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime   AS ExpirationDate
             , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime   AS OperDate_Income
             , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar    AS Invnumber_Income
             , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar    AS FromName_Income
             , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar    AS ContractName_Income

             , Object_PartionDateKind.ValueData                  :: TVarChar    AS PartionDateKindName
             , DATE_TRUNC ('DAY', MIDate_Insert.ValueData)       :: TDateTime   AS DateInsert
             , CASE WHEN COALESCE(Container.ID, 0) = 0 THEN FALSE ELSE TRUE END AS PartyRelated

             , zc_Color_Black()                                                 AS Color_calc
         FROM tmpMIContainerAll AS Container

              LEFT JOIN MovementItem ON MovementItem.ID = Container.MovementItemId

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

              LEFT JOIN tmpContainer ON tmpContainer.ContainerId = Container.ContainerId
              LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
              LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId
              LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
         ;

     END IF;
     RETURN;



     -- Таблица для отображения партий по SUN
     CREATE TEMP TABLE tmpMIContainer (Id          Integer
                                     , ContainerID Integer
                                     , Amount      TFloat) ON COMMIT DROP;

/*     IF vbisSUN = TRUE
     THEN
       IF EXISTS(SELECT 1 FROM  MovementItemContainer
                 WHERE MovementItemContainer.MovementId = inMovementId)
       THEN
         WITH
           tmpMI_Child AS (SELECT MovementItem.*
                           FROM MovementItem
                           WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Child()
                           )

         , tmpMIContainerAll AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                      , MovementItemContainer.ContainerID        AS ContainerID
                                      , Container.ParentId                       AS ParentId
                                      , - MovementItemContainer.Amount      AS Amount
                                 FROM  MovementItemContainer
                                       INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID
                                                           AND Container.WhereObjectId = vbUnitId
                                 WHERE MovementItemContainer.MovementId = inMovementId
                                   AND MovementItemContainer.MovementItemId NOT IN (SELECT tmpMI_Child.ID FROM tmpMI_Child)
                                   AND MovementItemContainer.DescId IN (zc_Container_Count(), zc_Container_CountPartionDate())
                                 )
         , tmpMIParent AS (SELECT tmpMIContainerAll.ParentId                  AS ParentId
                                , SUM(tmpMIContainerAll.Amount)               AS Amount
                           FROM  tmpMIContainerAll
                           GROUP BY tmpMIContainerAll.ParentId
                           )

         INSERT INTO tmpMIContainer
         SELECT tmpMIContainerAll.ID                                         AS Id
              , tmpMIContainerAll.ContainerID                                AS ContainerID
              , tmpMIContainerAll.Amount - COALESCE (tmpMIParent.Amount, 0)  AS Amount
         FROM  tmpMIContainerAll
               LEFT JOIN tmpMIParent ON tmpMIParent.ParentId = tmpMIContainerAll.ContainerID
         WHERE tmpMIContainerAll.Amount - COALESCE (tmpMIParent.Amount, 0) > 0;
       ELSE
         -- Таблица для проводок
         CREATE TEMP TABLE tmpMIContainer_insert (DescId         Integer
                                                , MovementItemId Integer
                                                , ContainerID    Integer
                                                , Amount         TFloat) ON COMMIT DROP;
          -- А сюда товары
          WITH
              -- строки документа перемещения
              tmpMI_Child AS (SELECT MovementItem.*
                           FROM MovementItem
                           WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Child()
                           )

            , tmpMI_Send AS (SELECT MI_Master.Id       AS MovementItemId
                                  , MI_Master.ObjectId AS ObjectId
                                  , MI_Master.Amount  AS Amount
                             FROM MovementItem AS MI_Master
                             WHERE MI_Master.MovementId = inMovementId
                               AND MI_Master.Id NOT IN (SELECT tmpMI_Child.ParentID FROM tmpMI_Child)
                               AND MI_Master.IsErased   = FALSE
                               AND MI_Master.DescId     = zc_MI_Master()
                               AND MI_Master.Amount     > 0
                            )
              -- строки документа перемещения размазанные по текущему остатку(Контейнерам) на подразделении "From"
            , DD AS (SELECT
                         tmpMI_Send.MovementItemId
                         -- сколько надо получить
                       , tmpMI_Send.Amount
                         -- остаток
                       , Container.Amount  AS AmountRemains
                       , Container.ObjectId
                       , Movement.OperDate   -- дата прихода от пост.
                       , MovementItem.Id AS PartionMovementItemId
                       , Container.Id    AS ContainerId
                         -- итого "накопительный" остаток
                       , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId ORDER BY Movement.OperDate, Container.Id, tmpMI_Send.MovementItemId) AS AmountRemains_sum
                         -- для последнего элемента - не смотрим на остаток
                       , ROW_NUMBER() OVER (PARTITION BY tmpMI_Send.MovementItemId ORDER BY Movement.OperDate DESC, Container.Id DESC, tmpMI_Send.MovementItemId DESC) AS DOrd
                     FROM Container
                          JOIN tmpMI_Send ON tmpMI_Send.ObjectId = Container.ObjectId
                          JOIN containerlinkObject AS CLI_MI
                                                   ON CLI_MI.ContainerId = Container.Id
                                                  AND CLI_MI.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                          JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                          JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                          JOIN Movement ON Movement.Id = MovementItem.MovementId
                     WHERE Container.WhereObjectId = vbUnitId
                       AND Container.DescId        = zc_Container_Count()
                       AND Container.Amount > 0
                    )
              -- контейнеры и zc_Container_Count, которые будут списаны (с подразделения "From")
            , tmpItem AS (
                          -- для простых перемещений - распределение
                          SELECT
                              DD.ContainerId            AS ContainerId_count
                            , NULL           :: Integer AS ContainerId_summ
                            , DD.PartionMovementItemId  AS PartionMovementItemId
                            , DD.MovementItemId         AS MovementItemId
                            , DD.ObjectId               AS ObjectId
                            , CASE WHEN DD.Amount - DD.AmountRemains_sum > 0.0 AND DD.DOrd <> 1
                                        THEN DD.AmountRemains
                                   ELSE DD.Amount - DD.AmountRemains_sum + DD.AmountRemains
                              END AS Amount
                          FROM DD
                          WHERE  (DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0)
                         )
              -- проводки кол-во
            , tmpAll AS  (-- расход с подразделения "From"
                          SELECT
                               tmpItem.ContainerId_count
                             , tmpItem.MovementItemId
                             , tmpItem.ObjectId
                             , -1 * tmpItem.Amount AS Amount
                          FROM tmpItem
                         )

          -- Результат
          INSERT INTO tmpMIContainer_insert (DescId, MovementItemId, ContainerId, Amount)
             -- обычные проводки по количеству
             SELECT
                 zc_MIContainer_Count()
               , tmpAll.MovementItemId
               , tmpAll.ContainerId_count
               , tmpAll.Amount
             FROM tmpAll;

          -- Списуем сроковые партии
          IF EXISTS (SELECT 1 FROM Container
                     WHERE Container.DescId   = zc_Container_CountPartionDate()
                       AND Container.Amount   > 0
                       AND Container.ParentId IN (-- только расход
                                                  SELECT tmpMIContainer_insert.ContainerId FROM tmpMIContainer_insert
                                                  WHERE tmpMIContainer_insert.DescId   = zc_MIContainer_Count()
                                                  ))
          THEN
            WITH -- Остатки сроковых партий - zc_Container_CountPartionDate
                 DD AS (SELECT tmpMIContainer_insert.MovementItemId
                               -- сколько надо получить
                             , -1 * tmpMIContainer_insert.Amount AS Amount
                               -- остаток
                             , Container.Amount AS AmountRemains
                             , Container.Id     AS ContainerId
                               -- итого "накопительный" остаток
                             , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id) AS AmountRemains_sum
                               -- для последнего элемента - не смотрим на остаток
                             , ROW_NUMBER() OVER (PARTITION BY tmpMIContainer_insert.MovementItemId ORDER BY Container.Id DESC) AS DOrd
                         FROM tmpMIContainer_insert
                              JOIN Container ON Container.ParentId = tmpMIContainer_insert.ContainerId
                                            AND Container.DescId   = zc_Container_CountPartionDate()
                                            AND Container.Amount   > 0.0
                         WHERE tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
                        )

                 -- распределение
               , tmpItem AS (SELECT DD.ContainerId
                                  , DD.MovementItemId
                                  , CASE WHEN DD.Amount - DD.AmountRemains_sum > 0.0 AND DD.DOrd <> 1
                                              THEN DD.AmountRemains
                                         ELSE DD.Amount - DD.AmountRemains_sum + DD.AmountRemains
                                    END AS Amount
                               FROM DD
                               WHERE (DD.Amount > 0 AND DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0))

              -- Результат - проводки по срокам - расход
              INSERT INTO tmpMIContainer_insert(DescId, MovementItemId, ContainerId, Amount)
                SELECT zc_MIContainer_CountPartionDate()
                     , tmpItem.MovementItemId
                     , tmpItem.ContainerId
                     , -1 * tmpItem.Amount
                FROM tmpItem
               ;

          END IF;

         WITH
           tmpMIContainerAll AS (SELECT tmpMIContainer_insert.MovementItemID     AS Id
                                      , tmpMIContainer_insert.ContainerID        AS ContainerID
                                      , Container.ParentId                       AS ParentId
                                      , - tmpMIContainer_insert.Amount           AS Amount
                                 FROM tmpMIContainer_insert
                                       INNER JOIN Container ON Container.ID = tmpMIContainer_insert.ContainerID
                                                           AND Container.WhereObjectId = vbUnitId
                                 )
         , tmpMIParent AS (SELECT tmpMIContainerAll.ParentId                  AS ParentId
                                , SUM(tmpMIContainerAll.Amount)               AS Amount
                           FROM  tmpMIContainerAll
                           GROUP BY tmpMIContainerAll.ParentId
                           )

         INSERT INTO tmpMIContainer
         SELECT tmpMIContainerAll.ID                                         AS Id
              , tmpMIContainerAll.ContainerID                                AS ContainerID
              , tmpMIContainerAll.Amount - COALESCE (tmpMIParent.Amount, 0)  AS Amount
         FROM  tmpMIContainerAll
               LEFT JOIN tmpMIParent ON tmpMIParent.ParentId = tmpMIContainerAll.ContainerID
         WHERE tmpMIContainerAll.Amount - COALESCE (tmpMIParent.Amount, 0) > 0;
       END IF;
     END IF;
*/

     RETURN QUERY
     WITH
     tmpMI_Child AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Child()
                     )
   , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                     , MovementItemFloat.ValueData :: Integer AS ContainerId
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )
    --
   , tmpContainer AS (SELECT tmp.ContainerId
                           , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                           , COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())  AS ExpirationDate
                           , CASE WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_0 THEN zc_Enum_PartionDateKind_0()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_1 THEN zc_Enum_PartionDateKind_1()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_1   AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_6 THEN zc_Enum_PartionDateKind_6()
                                  ELSE 0
                             END                                                       AS PartionDateKindId
--                           , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())     AS ExpirationDateIn
                      FROM (SELECT tmpMIFloat_ContainerId.ContainerId FROM tmpMIFloat_ContainerId
                            /*UNION
                            SELECT tmpMIContainer.ContainerId FROM tmpMIContainer*/) AS tmp
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = tmp.ContainerId
                                                        AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                           LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                      ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                     AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()

                           LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                         ON CLO_MovementItem.Containerid = tmp.ContainerId
                                                        AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                           -- элемент прихода
                           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                           -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                           -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

/*                           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
                     )
    --
   , tmpPartion AS (SELECT Movement.Id
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
                    WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                    )

       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , Object_Goods.Id              AS GoodsId
           , Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName
           , MovementItem.Amount          AS Amount

           , MIFloat_ContainerId.ContainerId                   :: TFloat    AS ContainerId
           , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income

           , Object_PartionDateKind.ValueData                  :: TVarChar  AS PartionDateKindName
           , DATE_TRUNC ('DAY', MIDate_Insert.ValueData)       :: TDateTime AS DateInsert
           , True                                                           AS PartyRelated

           , zc_Color_Black()                                               AS Color_calc
       FROM tmpMI_Child AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId
                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
            LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIFloat_ContainerId.ContainerId
            LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId
            LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                              ON MIDate_Insert.MovementItemId = MovementItem.Id
                                             AND MIDate_Insert.DescId = zc_MIDate_Insert()
       /*UNION ALL
       SELECT
             - 1
           , MovementItem.Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , tmpMIContainer.Amount::TFloat  AS Amount

           , tmpMIContainer.ContainerId                        :: TFloat    AS ContainerId
           , COALESCE (tmpContainer.ExpirationDateIn, NULL)    :: TDateTime AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income

           , Object_PartionDateKind.ValueData                  :: TVarChar  AS PartionDateKindName
           , NULL::TDAteTime                                                AS DateInsert
           , 694938                                                         AS Color_calc
       FROM tmpMIContainer
            INNER JOIN MovementItem ON MovementItem.ID = tmpMIContainer.ID
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpContainer ON tmpContainer.ContainerId = tmpMIContainer.ContainerId
            LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId*/
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.06.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send_Child(inMovementId := 3959328 ,  inSession := '3');
-- select * from gpSelect_MovementItem_Send_Child(inMovementId := 15390729 ,  inSession := '3');
-- select * from gpSelect_MovementItem_Send_Child(inMovementId := 16804677 ,  inSession := '3');

-- select * from gpSelect_MovementItem_Send_Child(inMovementId := 16905503       ,  inSession := '3');
