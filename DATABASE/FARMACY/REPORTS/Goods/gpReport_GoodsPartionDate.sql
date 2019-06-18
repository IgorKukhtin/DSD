-- Function: gpReport_GoodsPartionDate()

DROP FUNCTION IF EXISTS gpReport_GoodsPartionDate (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsPartionDate(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inIsDetail         Boolean  ,  -- показать детально
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId      Integer   --ИД 
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , PartionDateKindName TVarChar
             , ExpirationDate      TDateTime
             , Amount              TFloat
             , AmountRemains       TFloat
             , MovementId_Income   Integer
             , DescName_Income     TVarChar
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             , MovementId_SendPartionDate Integer  
             , DescName_SendPartionDate   TVarChar 
             , OperDate_SendPartionDate   TDateTime
             , Invnumber_SendPartionDate  TVarChar
             , StatusCode_SendPartionDate Integer
             , isDiff              Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbOperDate TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;

   DECLARE vbMonth_0  TFloat;
   DECLARE vbMonth_1  TFloat;
   DECLARE vbMonth_6  TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

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


    -- Результат
    RETURN QUERY
        WITH 
        tmpCountPartionDate AS (SELECT Container.Id                                               AS ContainerId
                                     , Container.ParentId                                         AS ParentId_Container
                                     , Container.ObjectId                                         AS GoodsId
                                     , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId_Income
                                     , COALESCE (MI_Income_find.Id,MI_Income.Id)                  AS MI_Id_Income
                                     , ObjectFloat_PartionGoods_MovementId.ValueData   :: Integer AS MovementId_SendPartionDate
                                     , SUM (Container.Amount)                                     AS Amount
                                     --, SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN Container.Amount ELSE 0 END) AS Amount     -- итого со сроком
                                     , SUM ( SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN Container.Amount ELSE 0 END) ) OVER (PARTITION BY Container.ObjectId) AS AmountTerm
                                     
                                     , CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                                            WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 THEN zc_Enum_PartionDateKind_1()
                                            WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30   AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6()
                                            ELSE 0
                                       END                                                        AS PartionDateKindId
                                     , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())   AS ExpirationDate
                                FROM Container
                                     INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                   AND CLO_Unit.ObjectId = inUnitId
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                                     -- документ срок/не срок
                                     INNER JOIN ObjectFloat AS ObjectFloat_PartionGoods_MovementId 
                                                           ON ObjectFloat_PartionGoods_MovementId.DescId = zc_ObjectFloat_PartionGoods_MovementId()
                                                          AND ObjectFloat_PartionGoods_MovementId.ObjectId = CLO_PartionGoods.ObjectId
                                     
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
                                  AND COALESCE (Container.Amount,0) <> 0
                                GROUP BY Container.Id
                                       , Container.ObjectId
                                       , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                       , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                       , COALESCE (MI_Income_find.Id,MI_Income.Id)
                                       , Container.ParentId
                                       , ObjectFloat_PartionGoods_MovementId.ValueData
                                )

      , tmpContainer AS (SELECT COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                              , COALESCE (MI_Income_find.Id,MI_Income.Id)                 AS MI_Id_Income
                              , tmp.GoodsId
                              , SUM (tmp.Amount) AS Amount                                                                    -- остаток
                              , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDate        -- Срок годности

                              , CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                                     WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 THEN zc_Enum_PartionDateKind_1()
                                     WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30   AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6()
                                     ELSE 0
                                END                                                       AS PartionDateKindId
                         FROM (SELECT Container.Id                           AS ContainerId
                                    , Container.ObjectId                     AS GoodsId
                                    , COALESCE (Container.Amount,0) ::TFloat AS Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = inUnitId
                                 AND COALESCE (Container.Amount,0) <> 0
                               GROUP BY Container.Id
                                      , Container.ObjectId   
                               ) AS tmp
                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
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
                         WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
                         GROUP BY tmp.ContainerId
                                , tmp.GoodsId
                                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                , COALESCE (MI_Income_find.Id,MI_Income.Id)
                        )

      , tmpData AS (SELECT COALESCE (tmpCountPartionDate.GoodsId, tmpContainer.GoodsId)                             AS GoodsId
                         , CASE WHEN inIsDetail = TRUE THEN COALESCE (tmpCountPartionDate.ContainerId,0) ELSE 0 END AS ContainerId
                         , COALESCE (tmpCountPartionDate.MovementId_Income, tmpContainer.MovementId_Income)         AS MovementId_Income
                         , tmpCountPartionDate.MovementId_SendPartionDate
                         , COALESCE (tmpCountPartionDate.MI_Id_Income, tmpContainer.MI_Id_Income)                   AS MI_Id_Income
                         , COALESCE (tmpCountPartionDate.PartionDateKindId, tmpContainer.PartionDateKindId)         AS PartionDateKindId
                         , MIN ( COALESCE (tmpCountPartionDate.ExpirationDate, tmpContainer.ExpirationDate))         AS ExpirationDate
                         , SUM ( COALESCE (tmpCountPartionDate.Amount,0))      AS Amount
                         , SUM ( COALESCE (tmpContainer.Amount,0))             AS AmountRemains

                    FROM tmpCountPartionDate
                         FULL JOIN tmpContainer ON tmpContainer.MI_Id_Income = tmpCountPartionDate.MI_Id_Income
                    GROUP BY COALESCE (tmpCountPartionDate.GoodsId, tmpContainer.GoodsId)
                           , CASE WHEN inIsDetail = TRUE THEN COALESCE (tmpCountPartionDate.ContainerId,0) ELSE 0 END
                           , COALESCE (tmpCountPartionDate.MovementId_Income, tmpContainer.MovementId_Income)
                           , tmpCountPartionDate.MovementId_SendPartionDate
                           , COALESCE (tmpCountPartionDate.MI_Id_Income, tmpContainer.MI_Id_Income)
                           , COALESCE (tmpCountPartionDate.PartionDateKindId, tmpContainer.PartionDateKindId)
                    )

      , tmpIncome AS (SELECT Movement.Id
                           , MovementDesc.ItemName         AS DescName
                           , MovementDate_Branch.ValueData AS BranchDate
                           , Movement.Invnumber            AS Invnumber
                           , Object_From.ValueData         AS FromName
                           , Object_Contract.ValueData     AS ContractName
                      FROM Movement
                           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
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
                      WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId_Income FROM tmpData)
                      )

      , tmpSendPartionDate AS (SELECT Movement.Id              AS Id
                                    , MovementDesc.ItemName    AS DescName
                                    , Movement.InvNumber       AS InvNumber
                                    , Movement.OperDate        AS OperDate
                                    , Object_Status.ObjectCode AS StatusCode
                                    , Object_Status.ValueData  AS StatusName
                               FROM Movement
                                    LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                    LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                               WHERE Movement.Id IN (SELECT DISTINCT tmpData.MovementId_SendPartionDate FROM tmpData)
                               )

        -- результат
        SELECT
            tmpData.ContainerId
          , Object_Goods.ObjectCode    AS GoodsCode
          , Object_Goods.ValueData     AS GoodsName

          , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName
          , tmpData.ExpirationDate  :: TDateTime

          , tmpData.Amount ::TFloat
          , tmpData.AmountRemains ::TFloat

          , tmpData.MovementId_Income     AS MovementId_Income
          , tmpIncome.DescName            AS DescName_Income
          , tmpIncome.BranchDate          AS OperDate_Income
          , tmpIncome.Invnumber           AS Invnumber_Income
          , tmpIncome.FromName            AS FromName_Income
          , tmpIncome.ContractName        AS ContractName_Income
          
          , tmpSendPartionDate.Id          AS MovementId_SendPartionDate
          , tmpSendPartionDate.DescName    AS DescName_SendPartionDate
          , tmpSendPartionDate.OperDate    AS OperDate_SendPartionDate
          , tmpSendPartionDate.Invnumber   AS Invnumber_SendPartionDate
          , tmpSendPartionDate.StatusCode  AS StatusCode_SendPartionDate
                 
          , CASE WHEN tmpData.Amount <> tmpData.AmountRemains THEN TRUE ELSE FALSE END AS isDiff
        FROM tmpData 
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

           LEFT JOIN tmpIncome ON tmpIncome.Id = tmpData.MovementId_Income 
           LEFT JOIN tmpSendPartionDate ON tmpSendPartionDate.Id = tmpData.MovementId_SendPartionDate

           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpData.PartionDateKindId
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.19         *
*/

-- тест
--select * from gpReport_GoodsPartionDate( inUnitId := 183292 , inIsDetail := False ,  inSession := '3' ::TVarchar);
--select * from gpReport_GoodsPartionDate( inUnitId := 183292 , inIsDetail := False ,  inSession := '3' ::TVarchar)
--order by 3;
