-- Function: gpSelect_LastPriceOut()
/*
  процедура вызывается в программе: SaveToXlsUnit
*/

DROP FUNCTION IF EXISTS gpSelect_LastPriceOut (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LastPriceOut(
    IN inJuridicalId Integer ,   --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Code Integer, Name TVarChar, Price TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    -- vbUserId:= lpGetUserBySession (inSession);

    SELECT Movement.Id INTO vbMovementId
    FROM Movement
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                              ON ObjectFloat_Deferment.ObjectId = MovementLinkObject_Contract.ObjectId
                             AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
    WHERE
        Movement.DescId = zc_Movement_PriceList()
        AND
        Movement.StatusId <> zc_Enum_Status_Erased()
        AND
        MovementLinkObject_Juridical.ObjectId = inJuridicalId
    ORDER BY
        Movement.OperDate DESC
       ,COALESCE(ObjectFloat_Deferment.ValueData,0) Desc 
    LIMIT 1;
    
        
        
    RETURN QUERY
        WITH 
            DiffPrice
            AS
            (
                SELECT 0::TFloat    as MinPrice, 14.99::TFloat      AS MaxPrice, 1.2::TFloat AS Margin
                UNION
                SELECT 15::TFloat   as MinPrice, 49.99::TFloat      AS MaxPrice, 1.18::TFloat AS Margin
                UNION
                SELECT 50::TFloat   as MinPrice, 99.99::TFloat      AS MaxPrice, 1.14::TFloat AS Margin
                UNION
                SELECT 100::TFloat  as MinPrice, 199.99::TFloat     AS MaxPrice, 1.12::TFloat AS Margin
                UNION
                SELECT 200::TFloat  as MinPrice, 299.99::TFloat     AS MaxPrice, 1.11::TFloat AS Margin
                UNION
                SELECT 300::TFloat  as MinPrice, 999.99::TFloat     AS MaxPrice, 1.09::TFloat AS Margin
                UNION
                SELECT 1000::TFloat as MinPrice, 9999999.99::TFloat AS MaxPrice, 1.08::TFloat AS Margin
            )
                
        SELECT
            Object_Goods.ObjectCode,
            Object_Goods.ValueData,
            ROUND(MovementItem.Amount * (1.0+(ObjectFloat_NDSKind_NDS.ValueData / 100.0)) * DiffPrice.Margin, 2)::TFloat as Price
        FROM 
            MovementItem
            LEFT JOIN Object AS Object_Goods 
                             ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                 ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
            LEFT OUTER JOIN DiffPrice ON ROUND(MovementItem.Amount * (1.0+(ObjectFloat_NDSKind_NDS.ValueData / 100.0)),2) between MinPrice AND MaxPrice
            LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites 
                                    ON ObjectBoolean_isNotUploadSites.ObjectId = Object_Goods.Id 
                                   AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()
        WHERE
            MovementItem.MovementId = vbMovementId
            AND 
            MovementItem.DescId = zc_MI_Master()
            AND 
            MovementItem.isErased = FALSE
            AND
            COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) = False;
  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_LastPriceOut (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 24.05.18                                                                                      *
 12.01.16                                                                        *
 
*/

-- тест
-- SELECT * FROM gpSelect_LastPriceOut (inJuridicalId:= 59611,inSession:= '3')