DROP VIEW IF EXISTS MovementItem_Sales_View_ForQV;

CREATE OR REPLACE VIEW MovementItem_Sales_View_ForQV AS
    SELECT
        MovementItem.Amount                                AS Amount
      , MIFloat_Price.ValueData                            AS Price
      , ROUND(MovementItem.Amount*MIFloat_Price.ValueData) AS Summ
      , date_trunc('day',Movement.OperDate)                AS OperDate
      , Object_Goods.ObjectCode                            AS GoodsName
      , Object_Goods.ValueData                             AS GoodsCode
      , NDSKind_NDS.ValueData                              AS NDS
      , Link_Juridical.IntegerKey                          AS Juridical_QVCode
      , Link_Unit.IntegerKey                               AS Unit_QVCode      
    FROM  
        Movement
        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.isErased = FALSE
                               AND MovementItem.Amount <> 0
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN Object AS Object_Goods 
                         ON Object_Goods.Id = MovementItem.ObjectId
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                   ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.ID
                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT OUTER JOIN ObjectFloat AS NDSKind_NDS
                                    ON NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                   AND NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
        LEFT OUTER JOIN MovementLinkObject AS Movement_Unit
                                           ON Movement_Unit.MovementId = Movement.Id
                                          AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON ObjectLink_Unit_Juridical.ObjectId = Movement_Unit.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT OUTER JOIN Object_ImportExportLink_View AS Link_Juridical
                                                     ON Link_Juridical.MainId = ObjectLink_Unit_Juridical.ChildObjectId
                                                    AND Link_Juridical.LinkTypeId = zc_Enum_ImportExportLinkType_QlikView()
        LEFT OUTER JOIN Object_ImportExportLink_View AS Link_Unit
                                                     ON Link_Unit.MainId = Movement_Unit.ObjectId
                                                    AND Link_Unit.LinkTypeId = zc_Enum_ImportExportLinkType_QlikView()
    WHERE 
        Movement.DescId in (zc_Movement_Sale(),zc_Movement_Check())
        AND
        Movement.StatusId = zc_Enum_Status_Complete()
        AND
        MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_Sales_View_ForQV
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».  ¬ÓÓ·Í‡ÎÓ ¿.¿.
 13.10.15                                                         *
*/
--Select * from MovementItem_Sales_View_ForQV Where OperDate between '20151201' AND '20151202' AND Juridical_QVCode = 1 AND Unit_QVCode = 1