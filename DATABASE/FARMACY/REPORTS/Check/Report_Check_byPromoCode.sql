-- Function: Report_Check_byPromoCode()

DROP FUNCTION IF EXISTS gpReport_Check_byPromoCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_byPromoCode(
    IN inMovementItemId       Integer   , -- 
    IN inSession              TVarChar    -- сессия пользователя
)

RETURNS TABLE (MovementId    Integer
             , Invnumber     Integer
             , OperDate      TDateTime
             , UnitName      TVarChar
             , JuridicalName TVarChar
             , RetailName    TVarChar
)
AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    -- Результат
    RETURN QUERY
        WITH
        -- Документы чек
        tmpCheck_Mov AS (SELECT MovementFloat_MovementItemId.MovementId
                              , MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                         FROM MovementFloat AS MovementFloat_MovementItemId
                         WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                           AND MovementFloat_MovementItemId.ValueData :: Integer = inMovementItemId
                         )
      -- результат
      SELECT Movement_Check.Id          AS MovementId
           , Movement_Check.Invnumber ::Integer  AS Invnumber
           , Movement_Check.OperDate    AS OperDate
           , Object_Unit.ValueData      AS UnitName
           , Object_Juridical.ValueData AS JuridicalName
           , Object_Retail.ValueData    AS RetailName
      FROM tmpCheck_Mov
                                  
           LEFT JOIN Movement AS Movement_Check ON Movement_Check.Id = tmpCheck_Mov.MovementId
           
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
 ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 16.12.17         *
*/

-- тест
-- SELECT * FROM gpReport_Check_byPromoCode (4, 3)
