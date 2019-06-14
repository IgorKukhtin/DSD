-- Function: gpReport_GoodsPartionDate()

DROP FUNCTION IF EXISTS gpReport_GoodsPartionDate (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsPartionDate(
    IN inUnitId           Integer  ,  -- �������������
    IN inIsDetail         Boolean  ,  -- �������� ��������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (ContainerId      Integer   --�� 
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

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� �������� �� ����������� 
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

    -- ���� + 6 �������, + 1 �����
    vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbOperDate:= CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;


    -- ���������
    RETURN QUERY
        WITH 
        tmpCountPartionDate AS (SELECT Container.Id                                               AS ContainerId
                                     , Container.ObjectId                                         AS GoodsId
                                     , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId_Income
                                     --, SUM (Container.Amount)                                     AS AmountRemains
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180  THEN Container.Amount ELSE 0 END) AS Amount     -- ����� �� ������
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN Container.Amount ELSE 0 END) AS Amount_0   -- ����������
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate THEN Container.Amount ELSE 0 END) AS Amount_1   -- ������ 1 ������
                                     , SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30  THEN Container.Amount ELSE 0 END) AS Amount_2   -- ������ 6 ������
                                     , SUM ( SUM (CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180  THEN Container.Amount ELSE 0 END) ) OVER (PARTITION BY Container.ObjectId) AS AmountTerm
                                     
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
                                                                   --AND CLO_Unit.ObjectId = inUnitId
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ObjectId = CLO_PartionGoods.ObjectId
                                     
                                     /*LEFT JOIN ContainerLinkObject AS CLO_PartionMovementItem 
                                                                   ON CLO_PartionMovementItem.ContainerId = Container.Id
                                                                  AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()*/
               
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = Object_PartionGoods.ObjectCode--CLO_PartionMovementItem.ObjectId
                                     -- ������� �������
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                                
                                     LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                       ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                    
                                WHERE Container.DescId = zc_Container_CountPartionDate()
                                GROUP BY Container.Id
                                       , Container.ObjectId
                                       , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                       , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                )

      , tmpData AS (SELECT tmpCountPartionDate.GoodsId
                         , CASE WHEN inIsDetail = TRUE THEN tmpCountPartionDate.ContainerId ELSE 0 END AS ContainerId
                         , CASE WHEN inIsDetail = TRUE THEN tmpCountPartionDate.MovementId_Income ELSE 0 END AS MovementId_Income
                         , CASE WHEN inIsDetail = TRUE THEN tmpCountPartionDate.PartionDateKindId ELSE 0 END AS PartionDateKindId
                         , MIN (tmpCountPartionDate.ExpirationDate) AS ExpirationDate
                         , SUM ( tmpCountPartionDate.Amount)        AS Amount
                         , SUM ( tmpCountPartionDate.Amount_0)      AS Amount_0
                         , SUM ( tmpCountPartionDate.Amount_1)      AS Amount_1
                         , SUM ( tmpCountPartionDate.Amount_2)      AS Amount_2
                         , SUM ( COALESCE (Container.Amount,0))     AS AmountRemains

                    FROM tmpCountPartionDate
                         LEFT JOIN Container ON Container.Id = tmpCountPartionDate.ContainerId
                                            AND Container.DescId = zc_Container_CountPartionDate()
                    --WHERE COALESCE (tmpCountPartionDate.AmountTerm,0) <> 0
                    GROUP BY tmpCountPartionDate.GoodsId
                           , CASE WHEN inIsDetail = TRUE THEN tmpCountPartionDate.ContainerId ELSE 0 END
                           , CASE WHEN inIsDetail = TRUE THEN tmpCountPartionDate.MovementId_Income ELSE 0 END
                           , CASE WHEN inIsDetail = TRUE THEN tmpCountPartionDate.PartionDateKindId ELSE 0 END
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
                                   
        -- ���������
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
                 
          , CASE WHEN tmpData.Amount <> tmpData.AmountRemains THEN TRUE ELSE FALSE END AS isDiff
        FROM tmpData 
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

           LEFT JOIN tmpIncome ON tmpIncome.Id = tmpData.MovementId_Income 

           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpData.PartionDateKindId
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.19         *
*/

-- ����
--select * from gpReport_GoodsPartionDate( inUnitId := 183292 , inIsDetail := False ,  inSession := '3' ::TVarchar);
--select * from gpReport_GoodsPartionDate( inUnitId := 183292 , inIsDetail := False ,  inSession := '3' ::TVarchar)
--order by 3;
