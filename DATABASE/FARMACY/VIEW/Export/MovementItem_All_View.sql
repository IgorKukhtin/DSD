DROP VIEW IF EXISTS MovementItem_All_Operate;

CREATE OR REPLACE VIEW MovementItem_All_Operate AS
    SELECT
        CLO_Unit.ObjectId                             AS UnitId
       ,MovementDesc.Code                             AS MovementDescCode
       ,MovementDesc.ItemName                         AS MovementItemNAme
       ,MIC_Count.Amount                              AS Amount
       ,MIFloat_Price.ValueData                       AS Price
       ,Container.ObjectId                            AS GoodsId
       ,(MIC_Count.Amount*MIFloat_Price.ValueData)::TFloat AS Summ
       ,MIC_Count.OperDate                                 AS OperDate
       ,Movement.InvNumber                                 AS InvNumber
       ,MLO_From.ObjectId                                  AS From_ID
       ,MLO_To.ObjectId                                    AS To_ID
       ,Object_NDSKind.Id                                  AS NDSKindId
       ,ObjectFloat_NDSKind_NDS.ValueData                  AS NDS
    FROM
        MovementItemContainer AS MIC_Count
        INNER JOIN Container ON Container.Id = MIC_Count.ContainerId
                            AND Container.DescId = zc_Container_Count()
        INNER JOIN ContainerLinkObject AS CLO_Unit
                                       ON CLO_Unit.ContainerId = Container.Id
                                      AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
        INNER JOIN MovementDesc ON MIC_Count.MovementDescId = MovementDesc.Id
        INNER JOIN MovementItemFloat AS MIFloat_Price 
                                     ON MIFloat_Price.MovementItemId = MIC_Count.MovementItemId
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
        INNER JOIN Movement ON MIC_Count.MovementId = Movement.Id                            
        LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                           ON MLO_From.MovementId = MIC_Count.MovementId
                                          AND MLO_From.DescId = zc_MovementLinkObject_From()
        LEFT OUTER JOIN MovementLinkObject AS MLO_To
                                           ON MLO_To.MovementId = MIC_Count.MovementId
                                          AND MLO_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
    WHERE
        MIC_Count.DescId = zc_MIContainer_Count();
ALTER TABLE MovementItem_All_Operate
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 03.09.15                                                         *
*/

-- тест
-- SELECT * FROM MovementItem_All_Operate
