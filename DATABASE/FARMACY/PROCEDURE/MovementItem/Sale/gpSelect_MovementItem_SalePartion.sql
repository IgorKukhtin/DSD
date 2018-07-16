-- Function: gpSelect_MovementItem_SalePartion()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SalePartion (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_SalePartion (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SalePartion(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , -- �������� ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsId Integer
             , Remains TFloat, PriceWithVAT TFloat, SummWithVAT TFloat
             , FromName TVarChar, SummOut TFloat, Margin TFloat, MarginPercent TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������������ �������������
    SELECT 
        Movement_Sale.UnitId
       ,Movement_Sale.StatusId
    INTO
        vbUnitId
       ,vbStatusId
    FROM 
        Movement_Sale_View AS Movement_Sale
    WHERE 
        Movement_Sale.Id = inMovementId;

    -- ���������
    IF vbStatusId <> zc_Enum_Status_Complete() THEN
        -- ��������� �����
        IF inShowAll THEN
            RETURN QUERY
                WITH 
                    tmpRemains AS(
                                    SELECT 
                                         Container.Id
                                       , Container.ObjectId
                                       , Container.Amount
                                    FROM Container
                                    WHERE Container.DescId = zc_Container_Count()
                                      AND Container.WhereObjectId = vbUnitId
                                      AND Container.Amount > 0
                                 )
                  ,tmpRemainsPartion AS (SELECT tmpRemains.*
                                               , MI_Income.MovementId                             AS MovementId                            
                                               , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                                 THEN  MIFloat_Price.ValueData
                                                 ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                                 END::TFloat AS PriceWithVAT
                                        FROM
                                            tmpRemains
                                            LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                                ON CLI_MI.ContainerId = tmpRemains.Id
                                                                               AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                                            LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer

                                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                       ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                                      ON MovementBoolean_PriceWithVAT.MovementId = MI_Income.MovementId
                                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                                                     
                                            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                         ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                  ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                          )
                   ,tmpRemainsInfo AS ( SELECT
                                            tmpRemains.ObjectId                   AS GoodsId
                                           ,SUM(tmpRemains.Amount)::TFloat        AS Amount
                                           ,tmpRemains.PriceWithVAT               AS PriceWithVAT
                                           ,MLO_From.ObjectId                     AS JuridicalId
                                        FROM
                                            tmpRemainsPartion AS tmpRemains
                                                        
                                            LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                                               ON MLO_From.MovementId = tmpRemains.MovementId
                                                                              AND MLO_From.DescId = zc_MovementLinkObject_From()
                                        GROUP BY
                                            tmpRemains.ObjectId
                                           ,tmpRemains.PriceWithVAT
                                           ,MLO_From.ObjectId
                                      )
                SELECT
                    tmpRemainsInfo.GoodsId
                   ,tmpRemainsInfo.Amount
                   ,tmpRemainsInfo.PriceWithVAT
                   ,ROUND(tmpRemainsInfo.Amount * tmpRemainsInfo.PriceWithVAT,2)::TFloat AS SummWithVAT
                   ,Object_Juridical.ValueData
                   ,NULL::TFloat AS SummOut
                   ,NULL::TFloat AS Margin
                   ,NULL::TFloat AS MarginPercent
                FROM
                    tmpRemainsInfo
                    LEFT OUTER JOIN Object AS Object_Juridical
                                           ON Object_Juridical.Id = tmpRemainsInfo.JuridicalId;
        ELSE
            RETURN QUERY
                WITH 
                    tmpSale AS (
                                    SELECT
                                        MovementItem.ObjectId
                                    FROM
                                        MovementItem
                                    WHERE
                                        MovementItem.MovementId = inMovementId
                                        AND
                                        MovementItem.DescId = zc_MI_Master()
                    ),
                    tmpRemains AS(
                                    SELECT 
                                        Container.Id
                                       ,Container.ObjectId
                                       ,Container.Amount
                                    FROM tmpSale
                                        INNER JOIN Container ON tmpSale.ObjectId = Container.ObjectId
                                                            AND Container.DescId = zc_Container_Count()
                                                            AND Container.WhereObjectId = vbUnitId
                                                            AND Container.Amount > 0
                                 )
                   ,tmpRemainsInfo AS (
                                        SELECT
                                            tmpRemains.ObjectId                   AS GoodsId
                                           ,SUM(tmpRemains.Amount)::TFloat        AS Amount
                                           ,CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN  MIFloat_Price.ValueData
                                               ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                            END::TFloat AS PriceWithVAT
                                           ,MLO_From.ObjectId                     AS JuridicalId
                                        FROM
                                            tmpRemains
                                            LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                                ON CLI_MI.ContainerId = tmpRemains.Id
                                                                               AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                            LEFT OUTER JOIN MovementItem AS MI_Income
                                                                         ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
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
            
                                            LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                                               ON MLO_From.MovementId = MI_Income.MovementId
                                                                              AND MLO_From.DescId = zc_MovementLinkObject_From()
                                        GROUP BY
                                            tmpRemains.ObjectId
                                           ,CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN  MIFloat_Price.ValueData
                                               ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                            END
                                           ,MLO_From.ObjectId
                                      )
                SELECT
                    tmpRemainsInfo.GoodsId
                   ,tmpRemainsInfo.Amount
                   ,tmpRemainsInfo.PriceWithVAT
                   ,ROUND(tmpRemainsInfo.Amount * tmpRemainsInfo.PriceWithVAT,2)::TFloat AS SummWithVAT
                   ,Object_Juridical.ValueData
                   ,NULL::TFloat AS SummOut
                   ,NULL::TFloat AS Margin
                   ,NULL::TFloat AS MarginPercent
                FROM
                    tmpRemainsInfo
                    LEFT OUTER JOIN Object AS Object_Juridical
                                           ON Object_Juridical.Id = tmpRemainsInfo.JuridicalId;
        
        END IF;
    ELSE
        -- ��������� ������
        RETURN QUERY
            WITH 
                MIC AS (
                            SELECT
                                MovementItemContainer.ContainerId
                               ,(-MovementItemContainer.Amount)::TFloat AS Amount
                               ,MIFloat_Price.ValueData AS PriceOut
                            FROM
                                MovementItemContainer
                                LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                  ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            WHERE
                                MovementItemContainer.MovementId = inMovementId
                                AND
                                MovementItemContainer.DescId = zc_MIContainer_Count()
                       ),
                MIC_Info AS (
                                SELECT
                                    MI_Income.GoodsId
                                   ,MIC.Amount
                                   ,MI_Income.PriceWithVAT
                                   ,SUM((MIC.Amount
                                        *MI_Income.PriceWithVAT))::TFloat AS SummWithVAT
                                   ,SUM((MIC.Amount
                                        *MIC.PriceOut))::TFloat           AS SummOut
                                   ,MLO_From.ObjectId                     AS JuridicalId
                                    
                                FROM
                                    MIC
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = MIC.ContainerId
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    LEFT OUTER JOIN MovementItem_Income_View AS MI_Income
                                                                             ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                                       ON MLO_From.MovementId = MI_Income.MovementId
                                                                      AND MLO_From.DescId = zc_MovementLinkObject_From()
                                GROUP BY
                                    MI_Income.GoodsId
                                   ,MIC.Amount
                                   ,MI_Income.PriceWithVAT
                                   ,MLO_From.ObjectId 
                             )
            SELECT
                MIC_Info.GoodsId
               ,MIC_Info.Amount
               ,MIC_Info.PriceWithVAT
               ,MIC_Info.SummWithVAT
               ,Object_Juridical.ValueData
               ,MIC_Info.SummOut
               ,(MIC_Info.SummOut - MIC_Info.SummWithVAT)::TFloat                                AS Margin
               ,CASE WHEN COALESCE(MIC_Info.SummWithVAT,0)<> 0
                    THEN 100*((MIC_Info.SummOut - MIC_Info.SummWithVAT) / MIC_Info.SummWithVAT) 
                END::TFloat                                                                      AS MarginPercent
            FROM
                MIC_Info
                LEFT OUTER JOIN Object AS Object_Juridical
                                       ON Object_Juridical.Id = MIC_Info.JuridicalId;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SalePartion (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 18.01.18         *
 26.12.15                                                          *
*/
--select * from gpSelect_MovementItem_SalePartion(inMovementId := 3959856 , inShowAll := 'True' ,  inSession := '3');