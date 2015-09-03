DROP VIEW IF EXISTS MovementItem_Check_View_ForExport;

CREATE OR REPLACE VIEW MovementItem_Check_View_ForExport AS
    SELECT
        MLO_Unit.ObjectId                                   AS UnitId
       ,MIC_Check.MovementId                                AS CheckId
       ,DATE_TRUNC('day',MIC_Check.OperDate)                AS CheckDate
       ,MIC_Check.OperDate::TIME                            AS CheckTime
       ,COALESCE(MovementBoolean_Deferred.ValueData,False)  AS IsDeferred
       ,MI_Check.ObjectId                                   AS GoodsId
       ,MIC_Check.Amount                                     AS Amount
       ,MIFloat_Price.ValueData                             AS Price
       ,(((COALESCE (MIC_Check.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS Summ
    FROM
        MovementItemContainer AS MIC_Check
        INNER JOIN MovementLinkObject AS MLO_Unit
                                      ON MLO_Unit.MovementId = MIC_Check.MovementId
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        INNER JOIN MovementItem AS MI_Check
                                ON MI_Check.MovementId = MIC_Check.MovementItemId
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MI_Check.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_Deferred
                                        ON MovementBoolean_Deferred.MovementId = MIC_Check.MovementId
                                       AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                     ON MovementLinkObject_CheckMember.MovementId = MIC_Check.MovementId
                                    AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
        LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
        LEFT JOIN MovementString AS MovementString_Bayer
                                         ON MovementString_Bayer.MovementId = MIC_Check.MovementId
                                        AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
            
    WHERE 
        MIC_Check.MovementDescId = zc_Movement_Check();

ALTER TABLE MovementItem_Check_View_ForExport
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 03.09.15                                                         *
*/

-- тест
-- SELECT * FROM MovementItem_Check_View_ForExport
