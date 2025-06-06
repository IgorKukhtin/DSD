-- Function: gpSelect_MovementItem_ListDiff()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_ListDiff (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ListDiff(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , DiffKindId Integer, DiffKindName TVarChar
             , isClose_DiffKind  Boolean
             , Amount TFloat
             , Price TFloat
             , Summa TFloat
             , RemainsInUnit TFloat
             , Income_Amount TFloat
             , MCS          TFloat
             , MCSIsClose   Boolean
             , MCSNotRecalc Boolean
             , isClose      Boolean
             , MCSDateChange TDateTime, MCSNotRecalcDateChange TDateTime
             , Comment    TVarChar
             , InsertName TVarChar, UpdateName TVarChar, ListName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime, ListDate TDateTime
             , MovementId_Order Integer, OrderInvNumber_full TVarChar
             , isVIPSend Boolean, isOrderInternal Boolean, AmountSend TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    SELECT MovementLinkObject_Unit.ObjectId AS UnitId
    INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_Unit
    WHERE MovementLinkObject_Unit.MovementId = inMovementId
      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

    IF inShowAll
    THEN
        RETURN QUERY
        WITH
        tmpIsErased AS (SELECT FALSE AS isErased
                      UNION ALL
                        SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                       )

      , tmpMI AS   (SELECT MovementItem.ObjectId                   AS GoodsId
                         , MovementItem.Amount                     AS Amount
                         , MovementItem.Id                         AS Id
                         , MovementItem.isErased                   AS isErased
                    FROM tmpIsErased
                       JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = tmpIsErased.isErased
                    )

      , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                          , ROUND(Price_Value.ValueData,2) ::TFloat AS Price
                          , MCS_Value.ValueData                     AS MCSValue
                          , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                          , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                          , MCSNotRecalc_DateChange.ValueData       AS MCSNotRecalcDateChange
                          , MCS_DateChange.ValueData                AS MCSDateChange
                     FROM ObjectLink AS ObjectLink_Price_Unit
                          LEFT JOIN ObjectFloat AS Price_Value
                                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          LEFT JOIN ObjectLink AS Price_Goods
                                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                          LEFT JOIN tmpMI ON tmpMI.GoodsId = Price_Goods.ChildObjectId  -- goodsId

                          LEFT JOIN ObjectFloat AS MCS_Value
                                                ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                          LEFT JOIN ObjectBoolean AS MCS_isClose
                                                  ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                          LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                  ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc() 
                          LEFT JOIN ObjectDate AS MCSNotRecalc_DateChange
                                               ON MCSNotRecalc_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                          LEFT JOIN ObjectDate AS MCS_DateChange
                                               ON MCS_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        AND (inShowAll = TRUE OR tmpMI.Id IS NOT NULL)
                     )

      , tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId                 AS GoodsId
                          , Object_Goods.ObjectCode                          AS GoodsCode
                          , Object_Goods.ValueData                           AS GoodsName
                          , COALESCE(ObjectBoolean_Goods_Close.ValueData, FALSE) AS isClose
                     FROM ObjectLink AS ObjectLink_Goods_Object

                       LEFT JOIN tmpMI ON tmpMI.GoodsId = ObjectLink_Goods_Object.ObjectId

                       INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                                                        AND Object_Goods.IsErased = FALSE
              
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                               ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink_Goods_Object.ObjectId 
                                              AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   
                     WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                       AND (inShowAll = TRUE OR tmpMI.Id IS NOT NULL)
                     )
      -- Виды отказов
      , tmpDiffKind AS (SELECT Object_DiffKind.Id                     AS Id
                             , Object_DiffKind.ObjectCode             AS Code
                             , Object_DiffKind.ValueData              AS Name
                             , COALESCE (ObjectBoolean_DiffKind_Close.ValueData, FALSE) AS isClose
                        FROM Object AS Object_DiffKind
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                                     ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id
                                                    AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()   
                        WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
                          AND Object_DiffKind.isErased = FALSE
                        )

      -- считаем остатки
      , tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                            , SUM (Container.Amount) AS Amount
                       FROM Container
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                           ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                          AND ContainerLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN tmpMI ON (tmpMI.GoodsId = Container.ObjectId OR inShowAll = TRUE)
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount <> 0
                       GROUP BY Container.ObjectId
                      )
      -- приход
      , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS GoodsId
                           , SUM (MovementItem_Income.Amount) :: TFloat AS Amount
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementItem AS MovementItem_Income
                                                   ON Movement_Income.Id = MovementItem_Income.MovementId
                                                  AND MovementItem_Income.DescId = zc_MI_Master()
                                                  AND MovementItem_Income.isErased = FALSE
                                                  AND MovementItem_Income.Amount > 0

                           INNER JOIN tmpMI ON (tmpMI.GoodsId = MovementItem_Income.ObjectId OR inShowAll = TRUE)
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = vbUnitId
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     )
      , tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        )
      , tmpMI_Order AS (SELECT MovementItemFloat.MovementItemId
                             , MovementItemFloat.ValueData ::Integer
                                , MovementItemFloat.DescId
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                        )
      , tmpMI_String AS (SELECT MovementItemString.*
                           FROM MovementItemString
                           WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                           )
      , tmpMI_LinkObject AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Juridical(), zc_MILinkObject_Contract(), zc_MILinkObject_Insert() , zc_MILinkObject_List(), zc_MILinkObject_Update(), zc_MILinkObject_DiffKind())
                           )
      , tmpMI_Date AS (SELECT MovementItemDate.*
                           FROM MovementItemDate
                           WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemDate.DescId IN (zc_MIDate_Insert(), zc_MIDate_Update(), zc_MIDate_List())
                           )
      , tmpMI_ObjectBoolean AS (SELECT ObjectBoolean.*
                           FROM ObjectBoolean
                           WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                             AND ObjectBoolean.DescId = zc_ObjectBoolean_Goods_Close()
                           )

            SELECT
                0                          AS Id
              , tmpGoods.GoodsId           AS GoodsId
              , tmpGoods.GoodsCode         AS GoodsCode
              , tmpGoods.GoodsName         AS GoodsName
              
              , 0                          AS JuridicalId
              , NULL::TVarChar             AS JuridicalName
              , 0                          AS ContractId
              , NULL::TVarChar             AS ContractName

              , 0                          AS DiffKindId
              , NULL::TVarChar             AS DiffKindName
              , FALSE                      AS isClose_DiffKind
             
              , NULL ::TFloat              AS Amount
              , tmpPrice.Price             AS Price
              , NULL ::TFloat              AS Summa
             
              , tmpRemains.Amount           ::TFloat    AS RemainsInUnit
              , tmpIncome.Amount            ::TFloat    AS Income_Amount
              , COALESCE (tmpPrice.MCSValue, 0)        :: TFloat     AS MCS
              , COALESCE (tmpPrice.MCSIsClose, FALSE)  :: Boolean    AS MCSIsClose
              , COALESCE (tmpPrice.MCSNotRecalc, FALSE):: Boolean    AS MCSNotRecalc
              , COALESCE (tmpGoods.isClose, FALSE)     :: Boolean    AS isClose
              , tmpPrice.MCSNotRecalcDateChange        :: TDateTime  AS MCSNotRecalcDateChange
              , tmpPrice.MCSDateChange                 :: TDateTime  AS MCSDateChange

              , NULL::TVarChar             AS Comment
              , NULL::TVarChar             AS InsertName
              , NULL::TVarChar             AS UpdateName
              , NULL::TVarChar             AS ListName
              , NULL::TDateTime            AS InsertDate
              , NULL::TDateTime            AS UpdateDate
              , NULL::TDateTime            AS ListDate              

              , 0                          AS MovementId_Order
              , NULL::TVarChar             AS OrderInvNumber_full

              , FALSE                      AS isErased

            FROM tmpGoods
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId
                LEFT JOIN tmpIncome  ON tmpIncome.GoodsId  = tmpGoods.GoodsId
            WHERE tmpMI.GoodsId IS NULL
         UNION ALL
            SELECT MovementItem.Id                         AS Id
                 , MovementItem.GoodsId                    AS GoodsId
                 , Object_Goods.ObjectCode                 AS GoodsCode
                 , Object_Goods.ValueData                  AS GoodsName
                 , Object_Juridical.Id         ::Integer   AS JuridicalId
                 , Object_Juridical.ValueData  ::TVarChar  AS JuridicalName
                 , Object_Contract.Id          ::Integer   AS ContractId
                 , Object_Contract.ValueData   ::TVarChar  AS ContractName

                 , Object_DiffKind.Id          ::Integer   AS DiffKindId
                 , Object_DiffKind.Name        ::TVarChar  AS DiffKindName
                 , COALESCE (Object_DiffKind.isClose, FALSE) :: Boolean  AS isClose_DiffKind

                 , MovementItem.Amount         ::TFloat    AS Amount
                 , MIFloat_Price.ValueData     ::TFloat    AS Price
                 , (MovementItem.Amount * MIFloat_Price.ValueData) ::TFloat AS Summa
                 
                 , tmpRemains.Amount           ::TFloat    AS RemainsInUnit
                 , tmpIncome.Amount            ::TFloat    AS Income_Amount
                 
                 , COALESCE (tmpPrice.MCSValue, 0)         ::TFloat   AS MCS
                 , COALESCE (tmpPrice.MCSIsClose, FALSE)  ::Boolean   AS MCSIsClose
                 , COALESCE (tmpPrice.MCSNotRecalc, FALSE)::Boolean   AS MCSNotRecalc
                 , COALESCE(ObjectBoolean_Goods_Close.ValueData, FALSE) ::Boolean AS isClose
                 , tmpPrice.MCSNotRecalcDateChange        :: TDateTime  AS MCSNotRecalcDateChange
                 , tmpPrice.MCSDateChange                 :: TDateTime  AS MCSDateChange
                 
                 , MIString_Comment.ValueData  ::TVarChar  AS Comment
                 , Object_Insert.ValueData                 AS InsertName
                 , Object_Update.ValueData                 AS UpdateName
                 , Object_List.ValueData                   AS ListName
                 , MIDate_Insert.ValueData                 AS InsertDate
                 , MIDate_Update.ValueData                 AS UpdateDate
                 , MIDate_List.ValueData                   AS ListDate

                 , Movement_Order.Id                       AS MovementId_Order
                 , ('№ ' || Movement_Order.InvNumber ||' от '||TO_CHAR(Movement_Order.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS OrderInvNumber_full

                 , COALESCE (MIBoolean_VIPSend.ValueData, False)  AS isVIPSend
                 , COALESCE (MIBoolean_OrderInternal.ValueData, False)  AS isOrderInternal
                 , MIFloat_AmountSend.ValueData                         AS AmountSend

                 , MovementItem.isErased                   AS isErased
            FROM tmpMI AS MovementItem
               LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.GoodsId
               LEFT JOIN tmpIncome  ON tmpIncome.GoodsId  = MovementItem.GoodsId
               LEFT JOIN tmpPrice   ON tmpPrice.GoodsId   = MovementItem.GoodsId
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId

               LEFT JOIN tmpMI_Float AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price() 
               LEFT JOIN tmpMI_Float AS MIFloat_AmountSend
                                     ON MIFloat_AmountSend.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend() 
               LEFT OUTER JOIN tmpMI_String AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
               LEFT JOIN tmpMI_LinkObject AS MILO_Juridical
                                          ON MILO_Juridical.MovementItemId = MovementItem.Id
                                         AND MILO_Juridical.DescId = zc_MILinkObject_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILO_Juridical.ObjectId 

               LEFT JOIN tmpMI_LinkObject AS MILO_Contract
                                          ON MILO_Contract.MovementItemId = MovementItem.Id
                                         AND MILO_Contract.DescId = zc_MILinkObject_Contract()
               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILO_Contract.ObjectId 

               LEFT JOIN tmpMI_LinkObject AS MILO_DiffKind
                                          ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                         AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
               LEFT JOIN tmpDiffKind AS Object_DiffKind ON Object_DiffKind.Id = MILO_DiffKind.ObjectId 

               LEFT JOIN tmpMI_Date AS MIDate_Insert
                                    ON MIDate_Insert.MovementItemId = MovementItem.Id
                                   AND MIDate_Insert.DescId = zc_MIDate_Insert()
               LEFT JOIN tmpMI_Date AS MIDate_Update
                                    ON MIDate_Update.MovementItemId = MovementItem.Id
                                   AND MIDate_Update.DescId = zc_MIDate_Update()
               LEFT JOIN tmpMI_Date AS MIDate_List
                                    ON MIDate_List.MovementItemId = MovementItem.Id
                                   AND MIDate_List.DescId = zc_MIDate_List()

               LEFT JOIN tmpMI_LinkObject AS MILO_Insert
                                          ON MILO_Insert.MovementItemId = MovementItem.Id
                                         AND MILO_Insert.DescId = zc_MILinkObject_Insert()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
               LEFT JOIN tmpMI_LinkObject AS MILO_Update
                                          ON MILO_Update.MovementItemId = MovementItem.Id
                                         AND MILO_Update.DescId = zc_MILinkObject_Update()
               LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
               LEFT JOIN tmpMI_LinkObject AS MILO_List
                                          ON MILO_List.MovementItemId = MovementItem.Id
                                         AND MILO_List.DescId = zc_MILinkObject_List()
               LEFT JOIN Object AS Object_List ON Object_List.Id = MILO_List.ObjectId

               LEFT JOIN tmpMI_Order AS MIFloat_OrderId
                                     ON MIFloat_OrderId.MovementItemId = MovementItem.Id
                                    AND MIFloat_OrderId.DescId = zc_MIFloat_MovementId()
               LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MIFloat_OrderId.ValueData ::Integer

               LEFT JOIN tmpMI_ObjectBoolean AS ObjectBoolean_Goods_Close
                                             ON ObjectBoolean_Goods_Close.ObjectId = MovementItem.GoodsId
                                            AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()    
                                 
               LEFT JOIN MovementItemBoolean AS MIBoolean_VIPSend
                                             ON MIBoolean_VIPSend.MovementItemId = MovementItem.Id
                                            AND MIBoolean_VIPSend.DescId = zc_MIBoolean_VIPSend()

               LEFT JOIN MovementItemBoolean AS MIBoolean_OrderInternal
                                             ON MIBoolean_OrderInternal.MovementItemId = MovementItem.Id
                                            AND MIBoolean_OrderInternal.DescId = zc_MIBoolean_OrderInternal()
          ;
    ELSE
       RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
      , tmpMI AS   (SELECT MovementItem.ObjectId                   AS GoodsId
                         , MovementItem.Amount                     AS Amount
                         , MovementItem.Id                         AS Id
                         , MovementItem.isErased                   AS isErased
                    FROM tmpIsErased
                       JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = tmpIsErased.isErased
                    )

      , tmpPrice AS (SELECT DISTINCT
                            Price_Goods.ChildObjectId               AS GoodsId
                          , ROUND(Price_Value.ValueData,2) ::TFloat AS Price
                          , MCS_Value.ValueData                     AS MCSValue
                          , COALESCE(MCS_isClose.ValueData,FALSE)   AS MCSIsClose
                          , COALESCE(MCS_NotRecalc.ValueData,FALSE) AS MCSNotRecalc
                          , MCSNotRecalc_DateChange.ValueData       AS MCSNotRecalcDateChange
                          , MCS_DateChange.ValueData                AS MCSDateChange
                     FROM ObjectLink AS ObjectLink_Price_Unit
                          LEFT JOIN ObjectFloat AS Price_Value
                                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          LEFT JOIN ObjectLink AS Price_Goods
                                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                          INNER JOIN tmpMI ON tmpMI.GoodsId = Price_Goods.ChildObjectId  -- goodsId

                          LEFT JOIN ObjectFloat AS MCS_Value
                                                ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                          LEFT JOIN ObjectBoolean AS MCS_isClose
                                                  ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                          LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                  ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                          LEFT JOIN ObjectDate AS MCSNotRecalc_DateChange
                                               ON MCSNotRecalc_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                          LEFT JOIN ObjectDate AS MCS_DateChange
                                               ON MCS_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                     )
      -- Виды отказов
      , tmpDiffKind AS (SELECT Object_DiffKind.Id                     AS Id
                             , Object_DiffKind.ObjectCode             AS Code
                             , Object_DiffKind.ValueData              AS Name
                             , COALESCE (ObjectBoolean_DiffKind_Close.ValueData, FALSE) AS isClose
                        FROM Object AS Object_DiffKind
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                                     ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id
                                                    AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()   
                        WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
                          AND Object_DiffKind.isErased = FALSE
                        )

      -- считаем остатки
      , tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                            , SUM (Container.Amount) AS Amount
                       FROM Container
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                           ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                          AND ContainerLinkObject_Unit.ObjectId = vbUnitId
                            INNER JOIN tmpMI ON tmpMI.GoodsId = Container.ObjectId
                       WHERE Container.DescId = zc_Container_Count()
                         AND Container.Amount <> 0
                       GROUP BY Container.ObjectId
                      )
      -- приход
      , tmpIncome AS (SELECT MovementItem_Income.ObjectId               AS GoodsId
                           , SUM (MovementItem_Income.Amount) :: TFloat AS Amount
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                  AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'

                           INNER JOIN MovementItem AS MovementItem_Income
                                                   ON Movement_Income.Id = MovementItem_Income.MovementId
                                                  AND MovementItem_Income.DescId = zc_MI_Master()
                                                  AND MovementItem_Income.isErased = FALSE
                                                  AND MovementItem_Income.Amount > 0

                           INNER JOIN tmpMI ON tmpMI.GoodsId = MovementItem_Income.ObjectId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = vbUnitId

                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MovementItem_Income.ObjectId
                     )

      , tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        )
      , tmpMI_Order AS (SELECT MovementItemFloat.MovementItemId
                             , MovementItemFloat.ValueData ::Integer
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                        )
      , tmpMI_String AS (SELECT MovementItemString.*
                         FROM MovementItemString
                         WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         )
      , tmpMI_LinkObject AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Juridical(), zc_MILinkObject_Contract(), zc_MILinkObject_Insert() , zc_MILinkObject_List(), zc_MILinkObject_Update(), zc_MILinkObject_DiffKind())
                             )
      , tmpMI_Date AS (SELECT MovementItemDate.*
                       FROM MovementItemDate
                       WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemDate.DescId IN (zc_MIDate_Insert(), zc_MIDate_Update(), zc_MIDate_List())
                       )    
      , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                                FROM MovementItemBoolean
                                WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
      
                           )
      , tmpMI_All AS (SELECT MovementItem.*
                 
                           , tmpRemains.Amount           ::TFloat    AS RemainsInUnit
                           , tmpIncome.Amount            ::TFloat    AS Income_Amount
                           
                           , COALESCE (tmpPrice.MCSValue, 0)         ::TFloat   AS MCS
                           , COALESCE (tmpPrice.MCSIsClose, FALSE)  ::Boolean   AS MCSIsClose
                           , COALESCE (tmpPrice.MCSNotRecalc, FALSE)::Boolean   AS MCSNotRecalc
                           , tmpPrice.MCSNotRecalcDateChange        :: TDateTime  AS MCSNotRecalcDateChange
                           , tmpPrice.MCSDateChange                 :: TDateTime  AS MCSDateChange

                           , Movement_Order.Id                       AS MovementId_Order
                           , ('№ ' || Movement_Order.InvNumber ||' от '||TO_CHAR(Movement_Order.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS OrderInvNumber_full

                      FROM tmpMI AS MovementItem

                         LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.GoodsId
                         LEFT JOIN tmpIncome  ON tmpIncome.GoodsId  = MovementItem.GoodsId               
                         LEFT JOIN tmpPrice   ON tmpPrice.GoodsId   = MovementItem.GoodsId

                         LEFT JOIN tmpMI_Float AS MIFloat_OrderId
                                               ON MIFloat_OrderId.MovementItemId = MovementItem.Id
                                              AND MIFloat_OrderId.DescId = zc_MIFloat_MovementId() 
                         LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MIFloat_OrderId.ValueData ::Integer
                      )

            SELECT MovementItem.Id                         AS Id
                 , MovementItem.GoodsId                    AS GoodsId
                 , Object_Goods_Main.ObjectCode            AS GoodsCode
                 , Object_Goods_Main.Name                  AS GoodsName
                 , Object_Juridical.Id         ::Integer   AS JuridicalId
                 , Object_Juridical.ValueData  ::TVarChar  AS JuridicalName
                 , Object_Contract.Id          ::Integer   AS ContractId
                 , Object_Contract.ValueData   ::TVarChar  AS ContractName

                 , Object_DiffKind.Id          ::Integer   AS DiffKindId
                 , Object_DiffKind.Name        ::TVarChar  AS DiffKindName
                 , COALESCE (Object_DiffKind.isClose, FALSE) :: Boolean  AS isClose_DiffKind

                 , MovementItem.Amount         ::TFloat    AS Amount
                 , MIFloat_Price.ValueData     ::TFloat    AS Price
                 , (MovementItem.Amount * MIFloat_Price.ValueData) ::TFloat AS Summa
                 
                 , MovementItem.RemainsInUnit              AS RemainsInUnit
                 , MovementItem.Income_Amount              AS Income_Amount
                 
                 , MovementItem.MCS                        AS MCS
                 , MovementItem.MCSIsClose                 AS MCSIsClose
                 , MovementItem.MCSNotRecalc               AS MCSNotRecalc
                 , COALESCE(ObjectBoolean_Goods_Close.ValueData, FALSE) ::Boolean AS isClose
                 , MovementItem.MCSNotRecalcDateChange     AS MCSNotRecalcDateChange
                 , MovementItem.MCSDateChange              AS MCSDateChange
                 
                 , MIString_Comment.ValueData  ::TVarChar  AS Comment
                 , Object_Insert.ValueData                 AS InsertName
                 , Object_Update.ValueData                 AS UpdateName
                 , Object_List.ValueData                   AS ListName
                 , MIDate_Insert.ValueData                 AS InsertDate
                 , MIDate_Update.ValueData                 AS UpdateDate
                 , MIDate_List.ValueData                   AS ListDate

                 , MovementItem.MovementId_Order           AS MovementId_Order
                 , MovementItem.OrderInvNumber_full        AS OrderInvNumber_full
                 
                 , COALESCE (MIBoolean_VIPSend.ValueData, False)        AS isVIPSend
                 , COALESCE (MIBoolean_OrderInternal.ValueData, False)  AS isOrderInternal
                 , MIFloat_AmountSend.ValueData                         AS AmountSend

                 , MovementItem.isErased                   AS isErased
                 
            FROM tmpMI_All AS MovementItem

                 LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN Object_Goods_Main   AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

               LEFT JOIN tmpMI_Float AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price() 
               LEFT JOIN tmpMI_Float AS MIFloat_AmountSend
                                     ON MIFloat_AmountSend.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend() 
               LEFT OUTER JOIN tmpMI_String AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
               LEFT JOIN tmpMI_LinkObject AS MILO_Juridical
                                          ON MILO_Juridical.MovementItemId = MovementItem.Id
                                         AND MILO_Juridical.DescId = zc_MILinkObject_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILO_Juridical.ObjectId 

               LEFT JOIN tmpMI_LinkObject AS MILO_Contract
                                          ON MILO_Contract.MovementItemId = MovementItem.Id
                                         AND MILO_Contract.DescId = zc_MILinkObject_Contract()
               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILO_Contract.ObjectId 

               LEFT JOIN tmpMI_LinkObject AS MILO_DiffKind
                                          ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                         AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
               LEFT JOIN tmpDiffKind AS Object_DiffKind ON Object_DiffKind.Id = MILO_DiffKind.ObjectId

               LEFT JOIN tmpMI_Date AS MIDate_Insert
                                    ON MIDate_Insert.MovementItemId = MovementItem.Id
                                   AND MIDate_Insert.DescId = zc_MIDate_Insert()
               LEFT JOIN tmpMI_Date AS MIDate_Update
                                    ON MIDate_Update.MovementItemId = MovementItem.Id
                                   AND MIDate_Update.DescId = zc_MIDate_Update()
               LEFT JOIN tmpMI_Date AS MIDate_List
                                    ON MIDate_List.MovementItemId = MovementItem.Id
                                   AND MIDate_List.DescId = zc_MIDate_List()

               LEFT JOIN tmpMI_LinkObject AS MILO_Insert
                                          ON MILO_Insert.MovementItemId = MovementItem.Id
                                         AND MILO_Insert.DescId = zc_MILinkObject_Insert()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
               LEFT JOIN tmpMI_LinkObject AS MILO_Update
                                          ON MILO_Update.MovementItemId = MovementItem.Id
                                         AND MILO_Update.DescId = zc_MILinkObject_Update()
               LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

               LEFT JOIN tmpMI_LinkObject AS MILO_List
                                          ON MILO_List.MovementItemId = MovementItem.Id
                                         AND MILO_List.DescId = zc_MILinkObject_List()
               LEFT JOIN Object AS Object_List ON Object_List.Id = MILO_List.ObjectId

               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                       ON ObjectBoolean_Goods_Close.ObjectId = MovementItem.GoodsId
                                      AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  

               LEFT JOIN tmpMI_Boolean AS MIBoolean_VIPSend
                                       ON MIBoolean_VIPSend.MovementItemId = MovementItem.Id
                                      AND MIBoolean_VIPSend.DescId = zc_MIBoolean_VIPSend()
               LEFT JOIN tmpMI_Boolean AS MIBoolean_OrderInternal
                                       ON MIBoolean_OrderInternal.MovementItemId = MovementItem.Id
                                      AND MIBoolean_OrderInternal.DescId = zc_MIBoolean_OrderInternal()
      ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.18         *
 14.11.18         *
 07.11.18         *
 01.11.18         *
 15.09.18         * 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ListDiff (inMovementId:= 1084910, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ListDiff (inMovementId:= 1084910, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')

select * from gpSelect_MovementItem_ListDiff(inMovementId := 24492140 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');