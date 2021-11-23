-- Function:  gpReport_SummaInsuranceCompanies()

DROP FUNCTION IF EXISTS gpReport_SummaInsuranceCompanies (TDateTime, TDateTime, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_SummaInsuranceCompanies(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalOurId   Integer,    -- наше юр.лицо
    IN inUnitId           Integer,    -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalMainId Integer
             , JuridicalMainCode Integer
             , JuridicalMainName TVarChar
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar

             , SummSale TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE Cursor1 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    RETURN QUERY
    WITH
         -- список подразделений
          tmpUnit AS (SELECT inUnitId                                  AS UnitId
                      WHERE COALESCE (inUnitId, 0) <> 0 
                     UNION 
                      SELECT ObjectLink_Unit_Juridical.ObjectId        AS UnitId
                      FROM ObjectLink AS ObjectLink_Unit_Juridical
                      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalOurId)
                        AND COALESCE (inUnitId, 0) = 0
                        AND COALESCE (inJuridicalOurId, 0) <> 0
                     UNION
                      SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                      FROM ObjectLink AS ObjectLink_Unit_Juridical
                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        AND COALESCE (inUnitId, 0) = 0
                        AND COALESCE (inJuridicalOurId, 0) = 0  
                     )
                    
        -- выбираем продажи по товарам соц.проекта 1303
        , tmpMovement_Sale AS (SELECT MovementLinkObject_Unit.ObjectId             AS UnitId
                                    , Movement_Sale.Id                             AS Id
                               FROM Movement AS Movement_Sale
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                    
                                    INNER JOIN MovementLinkObject AS MLO_InsuranceCompanies
                                                                  ON MLO_InsuranceCompanies.MovementId = Movement_Sale.Id
                                                                 AND MLO_InsuranceCompanies.DescId = zc_MovementLinkObject_InsuranceCompanies()

                               WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                 AND Movement_Sale.OperDate >= inStartDate AND Movement_Sale.OperDate < inEndDate + INTERVAL '1 DAY'
                                 AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                               )
 
        , tmMISale AS (SELECT Movement_Sale.UnitId                    AS UnitId
                            , SUM (Round(MI_Sale.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0), 2)) AS SummSale
                       FROM tmpMovement_Sale AS Movement_Sale
                           
                            INNER JOIN MovementItem AS MI_Sale
                                                    ON MI_Sale.MovementId = Movement_Sale.Id
                                                   AND MI_Sale.DescId = zc_MI_Master()
                                                   AND MI_Sale.isErased = FALSE
                           
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                        ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
  
                       GROUP BY Movement_Sale.UnitId
                       ) 
 
                         
     -- результат  
        SELECT
             ObjectLink_Unit_Juridical.ChildObjectId AS JuridicalMainId
           , Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , tmp.UnitId
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , tmp.SummSale           :: TFloat
       FROM tmMISale AS tmp
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN Object AS Object_JuridicalMain ON Object_JuridicalMain.Id = ObjectLink_Unit_Juridical.ChildObjectId
                
       ORDER BY Object_JuridicalMain.ValueData 
              , Object_Unit.ValueData;
              
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.11.21                                                       *
*/
-- тест
-- 

select * from gpReport_SummaInsuranceCompanies(inStartDate := ('01.11.2021')::TDateTime , inEndDate := ('23.11.2021')::TDateTime , inJuridicalOurId := 0 , inUnitId := 0 ,  inSession := '3');